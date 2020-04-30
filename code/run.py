from waitress import serve
from capstone import create_app

if __name__ == "__main__":
    serve(create_app, port=8080)
