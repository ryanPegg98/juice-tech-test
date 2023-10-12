# Juice Tech Test

## Breif

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

## Planning

This work will use the Open Weather API to look at the weather of major cities around the world. These could be defined by a user or have default locations. The defaults this will use are:

* London
* Paris
* New York

When a user clicks into a city they will be able to see the 16-day weather forecast and see some averaged data. They should also be presented with an option 
to download the data in a CSV format.


