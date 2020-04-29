# Built-in Packages
from os import getenv
from urllib.request import urlopen

# 3rd Party Packages
from flask import Blueprint, jsonify, Response
from bs4 import BeautifulSoup

# Local Packages
from .helpers import slugify, string_to_integer, parse_date

bp = Blueprint("core", __name__, url_prefix="/")


@bp.route("/")
def index() -> Response:
    app_name = getenv("APP_NAME")

    if app_name:
        return jsonify({"message": f"Hello {app_name}!"})

    return jsonify({"message": "Hello World!"})


@bp.route("/world-stats")
def world_stats() -> Response:
    world_stats_url = "https://en.wikipedia.org/wiki/Template:2019%E2%80%9320_coronavirus_pandemic_data#covid19-container"

    with urlopen(world_stats_url) as response:
        html = response.read().decode("utf-8")
        soup = BeautifulSoup(html, "html.parser")
        stats_table = soup.select("#thetable > tbody tr:not(.sortbottom)")[2:]

        stats = {}
        for country_data in stats_table:
            country_flag = country_data.select_one("th:nth-child(1) img").get("src")
            country_name = country_data.select_one("th:nth-child(2) a").get_text()
            country_url = country_data.select_one("th:nth-child(2) a").get("href")
            country_cases = string_to_integer(
                country_data.select_one("td:nth-child(3)").get_text()
            )
            country_deaths = string_to_integer(
                country_data.select_one("td:nth-child(4)").get_text()
            )
            country_recoveries = string_to_integer(
                country_data.select_one("td:nth-child(5)").get_text()
            )
            key = slugify(country_name)
            stats[key] = {
                "flag": country_flag,
                "name": country_name,
                "cases": country_cases,
                "deaths": country_deaths,
                "recoveries": country_recoveries,
                "url": country_url,
            }

        updated_at = parse_date(
            soup.select_one("#footer-info-lastmod")
            .get_text()
            .replace("This page was last edited on", "")
            .replace("(UTC).", "UTC")
            .strip()
        ).isoformat()

        return jsonify({"stats": stats, "updatedAt": updated_at})
