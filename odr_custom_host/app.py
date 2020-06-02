import os
from pathlib import Path

from flask import Flask, request, abort, jsonify, send_from_directory, send_file, render_template


app = Flask(__name__)

@app.route("/<path:filename>")
def download_odr_file(filename):
    print('Path = ', filename)    
    return send_from_directory(directory='.', filename=filename, as_attachment=True)    

if __name__ == "__main__":
    app.run(debug=True, port=8000)