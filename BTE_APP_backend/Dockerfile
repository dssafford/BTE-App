# Use the official AWS Lambda image for Python 3.9
FROM public.ecr.aws/lambda/python:3.9

# Set the working directory in the container
WORKDIR /var/task

# Copy the requirements file and install dependencies
COPY requirements.txt .
RUN pip install -r requirements.txt

# Copy the rest of the application code
COPY . .

# Command to run the handler function
# The file is main.py and the Mangum handler object is handler
CMD [ "main.handler" ] 