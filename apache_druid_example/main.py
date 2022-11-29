import json
import os

from classes.producer_kafka import Producer
from fake_web_events import Simulation
from flask import jsonify
from flask import make_response
from flask import wrappers

from __init__ import create_app


app = create_app()


@app.route("/", methods=["GET"])
def index() -> wrappers.Response:
    """Rota index da api do Lucas Mari"""
    return make_response(jsonify({"message": "OK"}), 200)


@app.route("/create_event", methods=["POST", "GET"])
def create_event() -> wrappers.Response:
    """Rota index da api do Lucas Mari"""
    simulation = Simulation(user_pool_size=30, sessions_per_day=10)
    events = simulation.run(duration_seconds=10)
    for event in events:
        Producer(data=json.dumps(event)).run()

    return make_response(jsonify({"message": "OK"}), 200)


if __name__ == "__main__":
    app.run(host="0.0.0.0", port=int(os.environ.get("PORT", 1010)))
