from flask import Flask, session, redirect, url_for, escape, request
import docker
import sys

app = Flask(__name__)
app.debug = True

@app.route("/version", methods=['GET'])
def hello():
    return "1.0.0"

@app.route('/webhook', methods=['POST'])
def webhook():
    try:
        tls_config = docker.tls.TLSConfig(
            client_cert=('/etc/docker/server-cert.pem', '/etc/docker/server-key.pem'), 
            verify='/etc/docker/ca.pem')
        cli = docker.Client(base_url='https://swarm-manager:2376', tls=tls_config)

        host_config = cli.create_host_config(port_bindings={8080: 8080})
        container = cli.create_container(image="donschenck/productws", detach=True, host_config=host_config)
        response = cli.start(container=container.get('Id'))

    except Exception:
        return "<p>Error: %s</p>" % sys.exc_info()[0]
    else:
        return "started!"

if __name__ == "__main__":
    app.run(host='0.0.0.0', port=5000)
