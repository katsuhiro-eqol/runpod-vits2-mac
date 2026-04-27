import os
import subprocess
import time
import requests

SBV2_DIR = "/app/Style-Bert-VITS2"
HOST = os.environ.get("SBV2_HOST", "127.0.0.1")
PORT = int(os.environ.get("SBV2_PORT", "5000"))
MODEL_ROOT = os.environ.get("MODEL_ROOT", "/runpod-volume/models")

_server_process = None


def wait_until_ready(timeout_sec: int = 120):
    url = f"http://{HOST}:{PORT}/docs"

    start = time.time()
    while time.time() - start < timeout_sec:
        try:
            r = requests.get(url, timeout=2)
            if r.status_code < 500:
                return
        except Exception:
            pass
        time.sleep(1)

    raise RuntimeError("StyleBertVITS2 server did not become ready")


def start_stylebert_server():
    global _server_process

    if _server_process is not None and _server_process.poll() is None:
        return

    if not os.path.exists(MODEL_ROOT):
        raise FileNotFoundError(f"MODEL_ROOT not found: {MODEL_ROOT}")

    env = os.environ.copy()
    env["MODEL_ROOT"] = MODEL_ROOT

    # StyleBertVITS2側の設定に合わせて必要なら引数を調整してください
    cmd = [
        "python",
        "server_fastapi.py",
        "--host",
        HOST,
        "--port",
        str(PORT),
    ]

    _server_process = subprocess.Popen(
        cmd,
        cwd=SBV2_DIR,
        env=env,
    )

    wait_until_ready()