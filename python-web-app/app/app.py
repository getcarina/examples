import logging
import os

from flask import Flask, render_template, request, redirect, url_for
from flask.ext.script import Manager
from flask.ext.sqlalchemy import SQLAlchemy


logging.basicConfig(
    level=logging.DEBUG,
    format='%(levelname)s: %(message)s')
logger = logging.getLogger(__name__)
logger.debug("Welcome to Carina Guestbook")


SQLALCHEMY_DATABASE_URI = \
    '{engine}://{username}:{password}@{hostname}/{database}'.format(
        engine='mysql+pymysql',
        username=os.getenv('MYSQL_USER'),
        password=os.getenv('MYSQL_PASSWORD'),
        hostname=os.getenv('MYSQL_HOST'),
        database=os.getenv('MYSQL_DATABASE'))

logger.debug("The log statement below is for educational purposes only. Do *not* log credentials.")
logger.debug("%s", SQLALCHEMY_DATABASE_URI)

app = Flask(__name__)
app.config['SQLALCHEMY_DATABASE_URI'] = SQLALCHEMY_DATABASE_URI
app.config['SQLALCHEMY_COMMIT_ON_TEARDOWN'] = True
app.config['SQLALCHEMY_TRACK_MODIFICATIONS'] = False

manager = Manager(app)
db = SQLAlchemy(app)


@app.route('/', methods=['GET', 'POST'])
def index():
    logger.debug("index")

    if request.method == 'POST':
        name = request.form['name']
        guest = Guest(name=name)
        db.session.add(guest)
        db.session.commit()
        return redirect(url_for('index'))

    return render_template('index.html', guests=Guest.query.all())


class Guest(db.Model):
    __tablename__ = 'guests'

    id = db.Column(db.Integer, primary_key=True)
    name = db.Column(db.String(256), nullable=False)

    def __repr__(self):
        return "[Guest: id={}, name={}]".format(self.id, self.name)


@manager.command
def create_db():
    logger.debug("create_db")
    app.config['SQLALCHEMY_ECHO'] = True
    db.create_all()

@manager.command
def create_dummy_data():
    logger.debug("create_test_data")
    app.config['SQLALCHEMY_ECHO'] = True
    guest = Guest(name='Steve')
    db.session.add(guest)
    db.session.commit()

@manager.command
def drop_db():
    logger.debug("drop_db")
    app.config['SQLALCHEMY_ECHO'] = True
    db.drop_all()


if __name__ == '__main__':
    manager.run()
