import runpod

from start_server import start_stylebert_server
from sbv2_client import synthesize_text


_server_started = False


def handler(job):
    global _server_started

    if not _server_started:
        start_stylebert_server()
        _server_started = True

    job_input = job.get("input", {})

    text = job_input.get("text")
    speaker = job_input.get("speaker")
    style = job_input.get("style")

    if not text:
        return {
            "error": "input.text is required"
        }

    result = synthesize_text(
        text=text,
        speaker=speaker,
        style=style,
    )

    return result


runpod.serverless.start({"handler": handler})