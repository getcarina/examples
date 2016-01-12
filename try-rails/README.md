# Try Rails on Carina

This is a sample Rails application which runs on Carina and is backed by a
MySQL database hosted on the Rackspace Cloud Database service.

1. Create a MySQL database in the IAD region in the Rackspace Cloud Control Panel.
    Note it's host name as it will be needed later.

2. Run the `rackerlabs/try-rails` container.

    ```bash
    docker run --detach --name rails --publish-all rackerlabs/try-rails
    ```

3. Identity the port where the rails application was published. In the example below,
    the port is 56740.

    ```bash
    $ docker port rails
    164.2.58.187:56740
    ```

4. Open http://<em>&lt;dockerHost&gt;</em>:<em>&lt;containerPort&gt;</em>/demo/helloworld,
    for example **http://164.2.58.187:56740/demo/helloworld**. You should see the following output:

    ![Powered by Carina](carina.png)
