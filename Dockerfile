FROM public.ecr.aws/lambda/python:3.14

# Install Python dependencies into the Lambda base image.
COPY requirements.txt .
RUN pip install -r requirements.txt

# Copy Lambda source files into the runtime task root.
COPY src/ ${LAMBDA_TASK_ROOT}

# Set the Lambda handler entrypoint.
CMD ["handler.handler"]