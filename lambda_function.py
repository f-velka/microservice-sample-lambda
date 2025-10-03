"""Simple Lambda handler returning a JSON response."""

import json
from http import HTTPStatus


def handler(event, context):
    """Return a minimal payload describing the request."""
    request_context = event.get("requestContext", {})
    function_url_context = request_context.get("http", {})

    body = {
        "message": "Hello from Lambda Function URL secured with IAM",
        "method": function_url_context.get("method"),
        "path": function_url_context.get("path"),
    }

    return {
        "statusCode": HTTPStatus.OK,
        "headers": {
            "Content-Type": "application/json",
        },
        "body": json.dumps(body),
    }
