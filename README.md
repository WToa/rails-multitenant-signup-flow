# Rails Multitenant Signup Flow

A Rails generator that installs multi-tenant authentication scaffolding, services, concerns, and configuration based on `activerecord-tenanted`.

## Installation

Add this line to your application's Gemfile:

```
gem "rails-multitenant-signup-flow", path: "../rails-multitenant-signup-flow"
```

And then execute:

```
bundle install
```

## Usage

```
bin/rails generate rails_multitenant_signup_flow:install
```

Run with `--force` to overwrite existing files.

## After running the generator

- Update `config/routes.rb` so your app has a root route, for example:
	```ruby
	root to: "sign_ups#show"
	```
	Adjust the controller/action to whatever should serve as your landing page.
- Start the server with `bin/rails server` and test subdomains locally using [lvh.me](https://lvh.me), which always resolves to `127.0.0.1`. For example, sign in at `http://app.lvh.me:3000` after creating a tenant named `app`.
