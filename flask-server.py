from flask import Flask, send_from_directory
app = Flask(__name__, static_url_path="")

@app.route('/')
def main_page():
    return send_from_directory("static", "index.html")

@app.route('/<path:path>')
def serve_page(path):
    return send_from_directory("static", path)
