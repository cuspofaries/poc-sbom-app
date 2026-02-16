"""Simple Flask app to demonstrate reusable SBOM pipeline."""

from flask import Flask, jsonify
from PIL import Image
from cryptography.fernet import Fernet
import aiohttp
import io

app = Flask(__name__)

# Generate a demo encryption key at startup
_fernet = Fernet(Fernet.generate_key())


@app.route("/")
def index():
    return jsonify({"app": "poc-sbom-build", "status": "running"})


@app.route("/health")
def health():
    return jsonify({"status": "ok"})


@app.route("/demo/encrypt")
def demo_encrypt():
    """Encrypt a sample payload (cryptography demo)."""
    token = _fernet.encrypt(b"supply-chain-demo").decode()
    return jsonify({"encrypted": token})


@app.route("/demo/thumbnail")
def demo_thumbnail():
    """Generate a 1x1 pixel PNG (Pillow demo)."""
    img = Image.new("RGB", (1, 1), color="blue")
    buf = io.BytesIO()
    img.save(buf, format="PNG")
    return jsonify({"size_bytes": buf.tell()})


@app.route("/demo/http-client")
def demo_http_client():
    """Show aiohttp version (async HTTP client demo)."""
    return jsonify({"aiohttp_version": aiohttp.__version__})


if __name__ == "__main__":
    app.run(host="0.0.0.0", port=8080)
