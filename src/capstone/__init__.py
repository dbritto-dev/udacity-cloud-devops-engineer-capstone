from flask import Flask


def create_app():
    app = Flask(__name__, instance_relative_config=True)

    from . import core

    app.register_blueprint(core.bp)

    return app
