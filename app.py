import io                      # lets us build the image in memory (no temp files needed)
import base64                  # converts image bytes into text so we can embed it in HTML
import qrcode                  # the library that actually draws the QR code

from flask import Flask, request, render_template

# Create the Flask application instance.
# This "app" object is what Flask uses to route requests to the right function.
app = Flask(__name__)


def generate_qr_base64(text: str) -> str:
    """
    Takes a piece of text (usually a URL) and returns a QR code
    image encoded as a base64 string, ready to embed in HTML.
    """
    # Build the QR code object with basic settings.
    qr = qrcode.QRCode(
        box_size=8,   # size of each square in the QR code
        border=4,     # thickness of the white border around it
    )

    qr.add_data(text)   # feed in the text/URL we want encoded
    qr.make(fit=True)   # let the library size the QR code correctly

    # Render the QR code as an image (black squares on white background).
    img = qr.make_image(fill_color="black", back_color="white")

    # Save the image into memory instead of a file on disk.
    buffer = io.BytesIO()
    img.save(buffer, format="PNG")

    # Convert the raw image bytes into a base64 text string,
    # which is what lets us embed the image directly in the HTML page.
    encoded_image = base64.b64encode(buffer.getvalue()).decode("utf-8")

    return encoded_image


# This single route handles both:
# - GET  -> just show the empty form (first page load)
# - POST -> user submitted the form, so generate and show the QR code
@app.route("/", methods=["GET", "POST"])
def home():
    qr_image_base64 = None   # will hold the generated image, if any
    submitted_text = None    # will hold what the user typed, to keep it in the input box

    if request.method == "POST":
        # Get the text the user typed into the form field named "url_text"
        submitted_text = request.form.get("url_text", "").strip()

        if submitted_text:
            # Only generate a QR code if the user actually entered something
            qr_image_base64 = generate_qr_base64(submitted_text)

    # Render the HTML page, passing in the image (if generated) and the submitted text
    return render_template(
        "index.html",
        qr_image_base64=qr_image_base64,
        submitted_text=submitted_text,
    )


# Simple health check endpoint - useful later for Docker/CI to confirm the app is alive
@app.route("/health")
def health():
    return {"status": "ok"}, 200


if __name__ == "__main__":
    # host="0.0.0.0" makes the app reachable from outside the container later (important for Docker)
    app.run(host="0.0.0.0", port=5000, debug=True)
