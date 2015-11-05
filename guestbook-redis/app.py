import logging
import os

from flask import Flask, render_template, request, redirect, url_for

from redis import Redis


logging.basicConfig(
    level=logging.DEBUG,
    format='%(levelname)s: %(message)s')
logger = logging.getLogger(__name__)
logger.info("Welcome to Guestbook: Redis Edition")


host = os.getenv('REDIS_HOST')
port = int(os.getenv('REDIS_PORT'))

app = Flask(__name__)
redis = Redis(host=host, port=port, charset='utf-8', decode_responses=True)


@app.route('/', methods=['GET', 'POST'])
def index():
    if request.method == 'POST':
        name = request.form['name']
        redis.lpush('guests', name)
        return redirect(url_for('index'))

    return render_template('index.html', guests=redis.lrange('guests', 0, -1))

if __name__ == '__main__':
    app.run(host='0.0.0.0', debug=True)
