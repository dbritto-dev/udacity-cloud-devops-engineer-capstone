# 3rd Party Packages
from pytest import mark

# Local Packages
from capstone import create_app

app = create_app()

JSON_MIMETYPE = "application/json"
HTTP_STATUS_OK = 200


@mark.parametrize(
    "valid_case",
    [(None, "Hello World!"), ("", "Hello World!"), ("Docker App", "Hello Docker App!")],
)
def test_index(valid_case, monkeypatch):
    value, expected_output = valid_case

    with app.test_client() as client:
        monkeypatch.setenv("APP_NAME", value or "")
        res = client.get("/")

        assert res.status_code == HTTP_STATUS_OK
        assert res.mimetype == JSON_MIMETYPE
        assert res.json.get("message") == expected_output


def test_world_stats():
    with app.test_client() as client:
        res = client.get("/world-stats")

        assert res.status_code == HTTP_STATUS_OK
        assert res.mimetype == JSON_MIMETYPE
        assert res.json.get("updatedAt") is not None
