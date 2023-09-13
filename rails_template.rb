# Create a new project with this template:
# rails new my_new_project -d postgresql --skip-turbolinks --skip-test -j esbuild --css tailwind -m ./rails_template.rb

# Add jsbundling-rails with esbuild
rails_command 'jsbundling:install:esbuild'
run 'bundle add sassc-rails'

run 'rake db:create'

# Testing
gem 'rspec-rails', '~> 5.0', group: :test
gem 'capybara', group: :test
gem 'factory_bot_rails', group: :test
gem 'faker', group: :test
gem 'database_cleaner-active_record', group: :test
gem 'simplecov', group: :test

# Remove the `use_transactional_fixtures` line from rails_helper.rb
inside('spec') do
  run 'rails generate rspec:install'
  insert_into_file 'rails_helper.rb', after: "require 'rspec/rails'\n" do
    <<~RUBY
      require 'capybara/rails'
      # Require support files
      Dir[Rails.root.join('spec', 'support', '**', '*.rb')].each { |f| require f }
    RUBY
  end
end

run 'mkdir -p spec/support'
gsub_file 'spec/rails_helper.rb', /^config.use_transactional_fixtures = true$/, ''

file 'spec/support/factory_bot.rb', <<~RUBY
  RSpec.configure do |config|
    config.include FactoryBot::Syntax::Methods
  end
RUBY

file 'spec/support/database_cleaner.rb', <<~RUBY
  RSpec.configure do |config|
    config.use_transactional_fixtures = false

    config.before(:suite) do
      DatabaseCleaner.clean_with(:truncation)
    end

    config.before(:each) do
      DatabaseCleaner.strategy = :transaction
    end

    config.before(:each, type: :system) do
      driven_by :rack_test
      DatabaseCleaner.strategy = :transaction
    end

    config.before(:each, type: :system, js: true) do
      driven_by :selenium_chrome_headless
      DatabaseCleaner.strategy = :truncation
    end

    config.before(:each) do
      DatabaseCleaner.start
    end

    config.after(:each) do
      DatabaseCleaner.clean
    end
  end
RUBY

# SimpleCov
gem 'simplecov', group: :test

prepend_to_file 'spec/spec_helper.rb' do
  <<~RUBY
    require 'simplecov'
    SimpleCov.start 'rails' do
    end

  RUBY
end

append_to_file '.gitignore', "coverage/\n"

# Image processing gems for Active Storage
run 'bundle install'

# Active Storage
rails_command 'active_storage:install'
rails_command 'db:migrate'

# Action Text
rails_command 'action_text:install'
rails_command 'db:migrate'

# Devise
gem 'devise'

# Add Devise test helpers for RSpec in a separate support file.
create_file 'spec/support/devise.rb' do
  <<-RUBY
    RSpec.configure do |config|
      # Include Devise test helpers
      config.include Devise::Test::ControllerHelpers, type: :controller
      config.include Devise::Test::ControllerHelpers, type: :view
      config.include Devise::Test::IntegrationHelpers, type: :feature
      config.include Devise::Test::IntegrationHelpers, type: :system
      config.extend ControllerMacros, type: :controller
    end

    # ControllerMacros module for Devise.
    module ControllerMacros
      def login_admin
        @request.env['devise.mapping'] = Devise.mappings[:admin]
        sign_in FactoryBot.create(:admin)
      end

      def login_user
        @request.env['devise.mapping'] = Devise.mappings[:user]
        user = FactoryBot.create(:user)
        user.confirm unless user.confirmed?
        sign_in user
      end
    end
  RUBY
end


# ActiveAdmin
gem 'activeadmin'

# Pagination
gem 'kaminari'

# Delayed Job
gem 'delayed_job_active_record'
generate 'delayed_job:active_record'

insert_into_file 'config/application.rb', after: '  class Application < Rails::Application' do
  "\n    config.active_job.queue_adapter = :delayed_job\n"
end

# PG Search
gem 'pg_search'

# Code Quality Tools
gem 'bullet', group: [:development, :test]
gem 'rack-mini-profiler', group: [:development, :test]
gem 'rubocop', require: false, group: [:development, :test]
gem 'rubocop-rails', require: false, group: [:development, :test]
gem 'rubocop-rspec', require: false, group: [:development, :test]
gem 'rubycritic', group: [:development, :test]
gem 'brakeman', group: [:development, :test]
gem 'bundler-audit', group: [:development, :test]
gem 'lol_dba', group: :development

run 'rubocop --auto-gen-config'
append_to_file '.rubocop.yml', <<-YAML
require:
  - rubocop-rails
  - rubocop-rspec
YAML

# Configure Procfile.dev
file 'Procfile.dev', <<-PROCF
web: unset PORT && env RUBY_DEBUG_OPEN=true bin/rails server
js: yarn build --watch
css: yarn build:css --watch
worker: rake jobs:work
redis: redis-server
PROCF

# Set the root route to the "home" action of the "StaticController"
route "root 'static#home'"

# Create the 'static' directory and 'home.html.erb' view file
generate 'controller Static'
file 'app/views/static/home.html.erb', <<-ERB
<h1 class='font-black text-4xl'>Home</h1>
ERB

run 'rake db:migrate'
