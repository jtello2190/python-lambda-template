# Core Lambda business logic.
# Keep request-parsing concerns in handler.py and place domain logic here.

def run(event, context):
    return {
        "statusCode": 200,
        "body": event.get("payload", "No message provided")
    }
