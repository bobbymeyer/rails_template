# Rails Template

![Ruby Version](https://img.shields.io/badge/Ruby-3.0.0-red.svg)
![Rails Version](https://img.shields.io/badge/Rails-7.0.0-red.svg)

This is a customizable Rails application template that helps you kickstart your Ruby on Rails projects with a set of preconfigured tools, gems, and best practices. It streamlines the setup process and provides you with a solid foundation for building web applications.

## Features

- Ruby on Rails 7
- PostgreSQL database setup
- JavaScript bundling with [esbuild](https://esbuild.github.io/)
- Tailwind CSS integration
- User authentication with [Devise](https://github.com/heartcombo/devise)
- ActiveAdmin for admin panel
- RSpec for testing framework
- Capybara for integration testing
- Factory Bot and Faker for test data generation
- Database Cleaner for test database management
- SimpleCov for test coverage reporting
- Image processing gems for Active Storage
- Action Text for rich text editing
- Pagination with Kaminari
- Delayed Job for background job processing
- Redis for caching and background jobs
- Bullet for N+1 query detection
- Rack Mini Profiler for performance profiling
- RuboCop and RuboCop extensions for code linting
- RubyCritic for code quality analysis
- Brakeman and Bundler Audit for security checks
- Loldba for database optimization

## Getting Started

To create a new Rails application using this template, follow these steps:

1. Make sure you have Ruby (3.0.0) and Rails (7.0.0) installed on your system.

2. Create a new Rails project using the template:

   ```bash
   rails new my_new_project -d postgresql --skip-turbolinks --skip-test -j esbuild --css tailwind -m ./rails_template.rb
