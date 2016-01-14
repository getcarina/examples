# Hello World Web

This is a sample Python web application, running on port 5000,
which prints data retrieved from the linked `carinamarina/hello-world-app` container.

1. Run the `carinamarina/hello-world-app` container.

    ```bash
    docker run --detach --name app carinamarina/hello-world-app
    ```

2. Run the `carinamarina/hello-world-web` container, linking to the app container using
    the alias **helloapp**.

    ```bash
    docker run --detach --name web --link app:helloapp --publish-all carinamarina/hello-world-web
    ```

3. Identity the port where the web container was published. In the example below,
    the port is 32770.

    ```bash
    $ docker port web
    5000/tcp -> 0.0.0.0:32770
    ```

4. Open http://<em>&lt;dockerHost&gt;</em>:<em>&lt;appContainerPort&gt;</em>, for example **http://localhost:32770**.
    You should see the following output:

    ```
    The linked container says ... "Hello World!"
    ```
