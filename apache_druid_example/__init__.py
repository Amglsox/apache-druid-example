from flask import Flask


def create_app() -> Flask:
    """Construct the core application."""
    app = Flask(__name__, instance_relative_config=False)
    return app
