from flask import Flask, session, redirect, url_for, escape, request
import docker
import sys
import os

app = Flask(__name__)
app.debug = True

@app.route("/version", methods=['GET'])
def hello():
    return "2.0.2"

@app.route('/webhook', methods=['POST'])
def webhook():
    try:
        tls_config = docker.tls.TLSConfig(
            client_cert=('/etc/docker/server-cert.pem', '/etc/docker/server-key.pem'),
            verify='/etc/docker/ca.pem')
        cli = docker.Client(base_url='https://swarm-manager:2376', tls=tls_config)
        container_env="DB_IP=" + os.environ["DB_IP"]
        container_env=",DB_POST=" + os.environ["DB_PORT"]
        host_config = cli.create_host_config(port_bindings={8080: 8080})
        container = cli.create_container(image=os.environ["WHWATCH_IMAGE_NAME"], detach=True, host_config=host_config, environment="DB_IP=104.130.0.7,DB_PORT=32769")
        response = cli.start(container=container.get('Id'))

    except Exception:
        return "<p>Error: %s</p>" % sys.exc_info()[0]
    else:
        return "started!"

if __name__ == "__main__":
    app.run(host='0.0.0.0', port=5000)
