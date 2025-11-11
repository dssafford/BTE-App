"""
Azure Functions entry point for BTE App
This file handles Azure Functions HTTP triggers and routes them to FastAPI
"""
import azure.functions as func
import logging
import os

# Set cloud provider for Azure
os.environ.setdefault("CLOUD_PROVIDER", "azure")

# Import the FastAPI app
from main import app

# Azure Functions uses ASGI adapter for FastAPI
import nest_asyncio
nest_asyncio.apply()

# Create Azure Functions app
azure_app = func.FunctionApp(http_auth_level=func.AuthLevel.ANONYMOUS)

@azure_app.route(route="{*route}", methods=["GET", "POST", "PUT", "DELETE", "PATCH", "OPTIONS"])
async def bte_api(req: func.HttpRequest) -> func.HttpResponse:
    """
    Azure Functions HTTP trigger that forwards all requests to FastAPI app
    """
    logging.info(f"Python HTTP trigger function processing request: {req.method} {req.url}")

    try:
        # Import ASGI adapter
        from asgi_adapter import AsgiMiddleware

        # Create ASGI adapter for FastAPI
        asgi_middleware = AsgiMiddleware(app)

        # Convert Azure Functions request to ASGI and get response
        response = await asgi_middleware.handle(req)

        return response

    except Exception as e:
        logging.error(f"Error processing request: {str(e)}")
        import traceback
        logging.error(traceback.format_exc())

        return func.HttpResponse(
            f"Error: {str(e)}",
            status_code=500
        )
