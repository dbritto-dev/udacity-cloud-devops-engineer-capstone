# 3rd Party Packages
from flask import Flask

# Local Packages
from . import core


def create_app() -> Flask:
    app = Flask(__name__)

    register_blueprints(app)

    return app


def register_blueprints(app: Flask) -> None:
    app.register_blueprint(core.bp)
