# test_app.py
# Basic tests for the QR code Flask app.
# Run with: pytest

import pytest
from app import app  # import the Flask app instance we're testing


@pytest.fixture
def client():
    """
    A pytest fixture creates a reusable piece of setup for tests.
    Here, it gives each test a fresh Flask "test client" —
    a fake browser that can send requests without needing a real server running.
    """
    app.config["TESTING"] = True
    with app.test_client() as client:
        yield client


def test_health_check(client):
    """The /health endpoint should return status 200 and {"status": "ok"}."""
    response = client.get("/health")

    assert response.status_code == 200
    assert response.get_json() == {"status": "ok"}


def test_home_page_loads(client):
    """The home page should load successfully on a normal GET request."""
    response = client.get("/")

    assert response.status_code == 200
    # The form should be present on the page
    assert b"Generate" in response.data


def test_generate_qr_with_valid_text(client):
    """Submitting text via POST should return a page containing a QR image."""
    response = client.post("/", data={"url_text": "https://github.com"})

    assert response.status_code == 200
    # A generated QR code is embedded as a base64 PNG image
    assert b"data:image/png;base64," in response.data


def test_generate_qr_with_empty_text(client):
    """Submitting an empty form should NOT crash, and should not show a QR image."""
    response = client.post("/", data={"url_text": ""})

    assert response.status_code == 200
    assert b"data:image/png;base64," not in response.data
