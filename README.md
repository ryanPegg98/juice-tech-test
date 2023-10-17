# Juice Tech Test

## Brief

### Project Description:

You are tasked with building a Ruby on Rails application that consumes data from a public API, processes that data with business logic, and exports a subset of the data to a CSV file.

### Requirements:

* Create a new Ruby on Rails application from scratch (Rails version 6+).
* Implement an API integration feature that consumes data from a publicly available API. You can choose any API of your preference (e.g., JSON placeholder, GitHub API, weather API). If you're stuck, you can use this: https://retool.com/utilities/generate-api-from-csv
* Upon fetching the data from the API, you should process it with some business logic. The business logic should include at least one of the following:
  * Filtering and selecting specific data based on certain criteria.
  * Transforming the data in a meaningful way.
  * Calculating statistics or aggregations.
* Implement a simple frontend view that allows users to export a subset of the processed data to a CSV file. Users should have the ability to select which data to export based on certain criteria (e.g., date range, specific category).

### Bonus (optional, if time permits):

* Style the application to provide a visually appealing user interface.
* Add user authentication.
* Users should be able to sign up, log in, and log out.
* Implement authorization to ensure that only authenticated users can access the application and export data.

### Evaluation:

Your submission will be evaluated based on the following criteria:

* Correct implementation of the API integration and data processing.
* Proper organization and code quality, adhering to Rails conventions.
* Ability to export processed data to a CSV file.
* Bonus points for implementing user authentication and authorization (if chosen) and styling.

## Software Requirements

* Ruby 3.2.1
* Rails 7.0.8
* Postgresql 9.3+

## Running Locally

To get the application running you will need to clone the repo and then run the following commands in the terminal.

```bash
bundle
cp .env.example .env
cp config/database.example.yml config/database.yml
bin/rails db:create
bin/rails db:schema:load
bin/rails s
```

In the `.env` file, you will need to add the OPEN_WEATHER_KEY to allow the application to run. This can be obtained from [Openweathmap.org](https://openweathermap.org/api)

You will then be able to go to `localhost:3000` which will allow you to search for a location and see the weather forecast.

To run the tests you will need to run `bundle exec rspec` which will run all of the automated tests.

## Recommended Improvements

While building this application time was hard to come by. Due to this, I was unable to take it as far as I would like. Below are some ideas I have that I would have implemented given more time.

### Authentication

The first one would allow users to sign up and sign in. This could have been used to allow users to store locations which would reduce the time it would take for a user to find a specific user. I would have gone one step further and allowed the users to pin these to a dashboard to be able to see the current weather at a glance. The simplest way to do this would be to use Devise as the information not being critical then it does not need to be super secure authentication.

### Utilise the Database

While building out the Location service I thought that an additional step would allow the application to store the locations in the database which would make it easier to recall and pass data from the controller to the location service. This will reduce the location value being passed into the show method and the export method using the URL parameters which is not the best method.

### Validation

To improve the reliability I could have implemented some validation which would prevent a service from running when it does not have all of the required information. This was a weakness in this application and could be rectified with the models being used. Simple active record validations would have been an option with DRY validation being an alternative.

### Improved Testing

On some of the specs, mainly the feature spec, I would add more scenarios for the different pages to ensure they would behave as a user would expect if an invalid response is received. Additionally, I would include cucumber tests as I think they offer more to other developers who can use them as another set of documentation.

