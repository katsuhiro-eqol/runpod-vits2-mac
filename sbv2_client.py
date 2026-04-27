import base64
import os
import requests

HOST = os.environ.get("SBV2_HOST", "127.0.0.1")
PORT = int(os.environ.get("SBV2_PORT", "5000"))

BASE_URL = f"http://{HOST}:{PORT}"


def synthesize_text(text: str, speaker: str | None = None, style: str | None = None):
    """
    StyleBertVITS2のFastAPIに投げるクライアント。
    実際のエンドポイント・パラメータ名は /docs で確認して合わせてください。
    """

    payload = {
        "text": text,
    }

    if speaker is not None:
        payload["speaker"] = speaker

    if style is not None:
        payload["style"] = style

    # 仮の例です。実際のAPI仕様に合わせて変更してください。
    response = requests.post(
        f"{BASE_URL}/voice",
        json=payload,
        timeout=120,
    )

    response.raise_for_status()

    audio_bytes = response.content
    audio_base64 = base64.b64encode(audio_bytes).decode("utf-8")

    return {
        "audio_base64": audio_base64,
        "mime_type": "audio/wav",
    }