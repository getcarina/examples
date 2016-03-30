This example demonstrates how to use a web application to provide a Software as a Service solution with Carina. This example uses:

 - Tomcat for the web application server
 - maven for packaging and testing
 - The jclouds Docker API to deploy, remove, and list containers on Carina
 - Mumble for the service being provided 

##### Before you start:

This example requires Java and maven.

You need to download and extract your Carina access file to the access directory. This is the file specified in this guide:

<a>https://getcarina.com/docs/getting-started/getting-started-on-carina/#connect-to-your-cluster</a>

##### Deploy to docker:

The application sets up and runs containers on Docker, but the application itself is also designed to run on Docker. To run it on Carina, having followed the [Getting Started on Carina](https://getcarina.com/docs/getting-started/getting-started-on-carina/#connect-to-your-cluster) guide, you can:

`mvn clean package`

`docker build -t cse .`

`docker run --name cse -d -p 8080:8080 cse`

##### Testing:

`mvn tomcat7:run-war`

This will run the web application at `localhost:8080/cse`

##### Debugging:

`mvndebug tomcat7:run-war`