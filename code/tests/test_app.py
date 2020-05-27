# Local Packages
from capstone import create_app

app = create_app()

JSON_MIMETYPE = "application/json"
HTTP_STATUS_OK = 200


def test_index():
    with app.test_client() as client:
        res = client.get("/")

        assert res.status_code == HTTP_STATUS_OK
        assert res.mimetype == JSON_MIMETYPE
        assert res.json.get("message") == "Hello World!"


def test_index_with_app_name(monkeypatch):
    with app.test_client() as client:
        app_name = "Docker App"
        monkeypatch.setenv("APP_NAME", app_name)

        res = client.get("/")

        assert res.status_code == HTTP_STATUS_OK
        assert res.mimetype == JSON_MIMETYPE
        assert res.json.get("message") == f"Hello {app_name}!"


def test_world_stats():
    with app.test_client() as client:
        res = client.get("/world-stats")

        assert res.status_code == HTTP_STATUS_OK
        assert res.mimetype == JSON_MIMETYPE
        assert res.json.get("updatedAt") is not None
