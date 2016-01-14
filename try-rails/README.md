# Try Rails on Carina

This is a sample Rails application which runs on Carina and is backed by a
MySQL database hosted on the Rackspace Cloud Database service.

1. Create a MySQL database in the IAD region in the Rackspace Cloud Control Panel.
    Note the host name, and credentials as it will be needed in the next step.

2. Run the `rackerlabs/try-rails` container. Update the `DATABASE_URL` environment
    variable with your database connection details.

    ```bash
    docker run --name rails \
    --env DATABASE_URL="mysql://username:password@host/dbname" \
    --detach \
    --publish-all \
    rackerlabs/try-rails
    ```

3. Identity the port where the rails application was published. In the example below,
    the port is 32800.

    ```bash
    $ docker port rails
    3000/tcp -> 172.99.65.237:32800
    ```

4. Open http://<em>&lt;dockerHost&gt;</em>:<em>&lt;containerPort&gt;</em>,
    for example **http://172.99.65.237:32800**. You should see the
    Powered By Carina badge if the database connection was successful.

    ![Powered by Carina](carina.png)
