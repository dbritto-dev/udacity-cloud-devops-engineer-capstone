from waitress import serve
from capstone import create_app

app = create_app()

if __name__ == "__main__":
    serve(app, port=5000)
