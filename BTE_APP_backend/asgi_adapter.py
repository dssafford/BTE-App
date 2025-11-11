"""
ASGI adapter to bridge Azure Functions HTTP triggers with FastAPI
"""
import azure.functions as func
from typing import Dict, List
import asyncio
import logging


class AsgiMiddleware:
    def __init__(self, app):
        self.app = app

    async def handle(self, req: func.HttpRequest) -> func.HttpResponse:
        """Convert Azure Functions HttpRequest to ASGI scope and call FastAPI app"""

        # Build ASGI scope from Azure Functions request
        scope = {
            "type": "http",
            "asgi": {"version": "3.0"},
            "http_version": "1.1",
            "method": req.method,
            "scheme": "https",
            "path": req.route_params.get("route", "/"),
            "query_string": req.url.split("?", 1)[1].encode() if "?" in req.url else b"",
            "headers": [[k.lower().encode(), v.encode()] for k, v in req.headers.items()],
            "server": ("localhost", 443),
        }

        # Add leading slash if not present
        if not scope["path"].startswith("/"):
            scope["path"] = "/" + scope["path"]

        # Capture response
        response_started = False
        status_code = 200
        response_headers: List[tuple] = []
        body_parts: List[bytes] = []

        async def receive():
            """ASGI receive callable"""
            body = req.get_body()
            return {
                "type": "http.request",
                "body": body,
                "more_body": False,
            }

        async def send(message):
            """ASGI send callable"""
            nonlocal response_started, status_code, response_headers, body_parts

            if message["type"] == "http.response.start":
                response_started = True
                status_code = message["status"]
                response_headers = message.get("headers", [])

            elif message["type"] == "http.response.body":
                body = message.get("body", b"")
                if body:
                    body_parts.append(body)

        # Call FastAPI app
        await self.app(scope, receive, send)

        # Build Azure Functions response
        headers_dict: Dict[str, str] = {}
        for name, value in response_headers:
            headers_dict[name.decode()] = value.decode()

        return func.HttpResponse(
            body=b"".join(body_parts),
            status_code=status_code,
            headers=headers_dict,
        )
