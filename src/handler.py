import base64
import json
import logging
from main import run

logger = logging.getLogger()
logger.setLevel(logging.INFO)


def handler(event, context):
    try:
        # SQS / SNS batch
        if "Records" in event:
            payloads = []

            for record in event["Records"]:
                raw_data = record.get("body") or record.get("Sns", {}).get("Message")
                if raw_data:
                    payloads.append(json.loads(raw_data))

            return run(
                {
                    "source": "records",
                    "payload": payloads,
                },
                context,
            )

        # API Gateway
        if "requestContext" in event and "body" in event:
            body = event["body"]

            if event.get("isBase64Encoded"):
                body = base64.b64decode(body).decode("utf-8")

            parsed_body = json.loads(body) if isinstance(body, str) else body

            return run(
                {
                    "source": "apigateway",
                    "payload": parsed_body,
                },
                context,
            )

        # Direct invocation
        return run(
            {
                "source": "direct",
                "payload": event,
            },
            context,
        )

    except (json.JSONDecodeError, TypeError, ValueError) as e:
        logger.exception("Failed to normalize Lambda event")
        return {
            "statusCode": 400,
            "body": json.dumps({"error": "Invalid JSON payload"}),
        }
