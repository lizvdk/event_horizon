source "https://rubygems.org"

ruby "2.1.3"

gem "rails", "4.1.4"

gem "pg"
gem "sass-rails", "~> 4.0.3"
gem "uglifier", ">= 1.3.0"
gem "jquery-rails"
gem "haml-rails"
gem "foundation-rails"
gem "omniauth-github"
gem "redcarpet"
gem "rouge"
gem "unicorn"
gem "jbuilder"
gem "carrierwave"
gem "fog"
gem "sidekiq"
gem "newrelic_rpm"

group :development do
  gem "spring"
  gem "quiet_assets"
  gem "dotenv-rails"
end

group :development, :test do
  gem "rspec-rails"
  gem "capybara"
  gem "factory_girl_rails"
  gem "pry-rails"
end

group :test do
  gem "coveralls", require: false
  gem "launchy", require: false
end

group :production do
  gem "rails_12factor"
  gem "bugsnag"
end
