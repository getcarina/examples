FROM rails

# Generate a rails app
RUN cd /usr/src && rails new --skip-bundle app
WORKDIR /usr/src/app
RUN bundle install
RUN bin/rails generate controller Demo helloworld

# Make it pretty
COPY carina.png public/
COPY helloworld.html.erb app/views/demo/

EXPOSE 3000

CMD bin/rails server -b 0.0.0.0
