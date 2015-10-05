import os
import requests
from flask import Flask

app = Flask(__name__)

@app.route('/')
def index():
    data = get_app_data()
    return 'The linked container said... "{0}"'.format(data)


def get_app_data():
    # the web container MUST be run with --link <appName>:helloapp
    link_alias = 'helloapp'

    # Request data from the app container
    response = requests.get('http://{0}:5000'.format(link_alias))
    return response.text


if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5000)
