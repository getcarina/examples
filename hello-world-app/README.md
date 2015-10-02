# Hello World App

This is a sample Python web application, running on port 5000,
which prints `Hello  World!`.

1. Run the `rackerlabs/hello-world-app` container.

    ```bash
    docker run --detach --name app --publish-all rackerlabs/hello-world-app
    ```

2. Identity the port where the app container was published. In the example below,
    the port is 32770.

    ```bash
    $ docker port app
    5000/tcp -> 0.0.0.0:32770
    ```

3. Open http://<em>&lt;dockerHost&gt;</em>:<em>&lt;containerPort&gt;</em>, for example **http://localhost:32770**.
    You should see the following output:

    ```
    Hello World!
    ```
