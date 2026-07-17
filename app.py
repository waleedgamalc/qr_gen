import io
import qrcode
from flask import Flask, request, jsonify, send_file

app = Flask(__name__)


@app.route("/", methods=["GET"])
def index():
    return jsonify({
        "service": "QR Code Generator API",
        "endpoints": {
            "GET /health": "health check",
            "POST /qr": "body: {\"text\": \"...\"} -> returns PNG image"
        }
    })


@app.route("/health", methods=["GET"])
def health():
    return jsonify({"status": "ok"}), 200


@app.route("/qr", methods=["POST"])
def generate_qr():
    data = request.get_json(silent=True)

    if not data or "text" not in data or not str(data["text"]).strip():
        return jsonify({"error": "Request body must include a non-empty 'text' field"}), 400

    text = str(data["text"])

    qr = qrcode.QRCode(
        version=1,
        error_correction=qrcode.constants.ERROR_CORRECT_L,
        box_size=10,
        border=4,
    )
    qr.add_data(text)
    qr.make(fit=True)
    img = qr.make_image(fill_color="black", back_color="white")

    buffer = io.BytesIO()
    img.save(buffer, format="PNG")
    buffer.seek(0)

    return send_file(buffer, mimetype="image/png")


if __name__ == "__main__":
    app.run(host="0.0.0.0", port=5000)
