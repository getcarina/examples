import logging
import os

from flask import Flask, render_template, request, redirect, url_for

from pymongo import MongoClient


logging.basicConfig(
    level=logging.DEBUG,
    format='%(levelname)s: %(message)s')
logger = logging.getLogger(__name__)
logger.info("Welcome to Guestbook: Mongo Edition")


host = os.getenv('MONGO_HOST')
port = int(os.getenv('MONGO_PORT'))
ssl = os.getenv('MONGO_SSL') == 'True'
db = os.getenv('MONGO_DATABASE')
username = os.getenv('MONGO_USER')
password = os.getenv('MONGO_PASSWORD')


logger.debug("The log statement below is for educational purposes only. "
             "Do not log credentials.")
logger.debug('mongodb://%s:%s@%s:%s/%s?ssl=%s',
             username, password, host, port, db, ssl)


app = Flask(__name__)
client = MongoClient(host, port, ssl=ssl)
db = client.get_database(db)
db.authenticate(username, password)
guests = db.guests


@app.route('/', methods=['GET', 'POST'])
def index():
    if request.method == 'POST':
        name = request.form['name']
        guests.insert_one({'name': name})
        return redirect(url_for('index'))

    return render_template('index.html', guests=guests.find())

if __name__ == '__main__':
    app.run(host='0.0.0.0', debug=True)
