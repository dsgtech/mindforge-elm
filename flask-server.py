import os
from flask import jsonify
import subprocess

from flask import Flask, send_from_directory
app = Flask(__name__, static_url_path="")

@app.route('/')
def main_page():
    return send_from_directory("static", "index.html")

@app.route('/rebuild_source')
def rebuild_source():
    subprocess.call(["elm-make", "Main.elm", "--output=static/index.html"])
    return ""

@app.route('/list_files')
def list_files():
    files = [f for f in os.listdir('static') if f.endswith('.json')]
    #print(jsonify(files).get_data().decode())
    return jsonify(files)

@app.route('/<path:path>')
def serve_page(path):
    return send_from_directory("static", path)
