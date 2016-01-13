FROM rails

# Generate a rails app
RUN cd /usr/src && rails new --skip-bundle app
WORKDIR /usr/src/app
RUN bundle install
RUN bin/rails generate controller Demo helloworld

# Switch to MySQL
RUN rm Gemfile.lock && sed -i -- "s/gem 'sqlite3'/gem 'mysql'/g" Gemfile && bundle install

# Make it pretty
COPY carina.png public/
COPY helloworld.html.erb app/views/demo/

# Show the demo page as the homepage
RUN sed -i -- "s/get 'demo\/helloworld'/root to: 'demo#helloworld'/g" config/routes.rb

EXPOSE 3000

CMD bin/rails server -b 0.0.0.0
