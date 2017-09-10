# Smartdirect

[![Build Status](https://travis-ci.org/prshreshtha/smartdirect-backend.svg?branch=master)](https://travis-ci.org/prshreshtha/smartdirect-backend)

Smartdirect is like Dropbox for URL-shorteners. Instead of files, you store links which you can update any time. So `/blogs/latest` can be updated every time you post and everyone with the link will always see your latest post!

***

## Related Repositories

* [Web Frontend](https://github.com/prshreshtha/smartdirect-web)

***

## Roadmap

- [X] Implement User
  * [X] JWT Authentication with dynamic user info
  * [X] Friendly-name generation
  * [X] JSON API access w/ Authorization (tested)
- [X] Implement Directory
  * [X] Closure tree structure
  * [X] Ownership validation (tested)
  * [X] Name validation (tested)
  * [X] Cascading delete (tested)
  * [X] JSON API access w/ Authorization (tested)
- [ ] Implement Linkation
  * [X] Ownership validation (**needs testing**)
  * [X] Name validation (**needs testing**)
  * [X] URL validation (**needs testing**)
  * [ ] Cascading delete from parent directory
  * [ ] JSON API access w/ Authorization (partial / **needs testing**)
- [ ] Implement redirection
  * [X] Friendly-name of user
  * [ ] Proper indexes for optimized look up (**needs verification**)
  * [ ] Redis/CDN cache integration using per-link TTL
- [ ] Deployment
  * [ ] Heroku Ruby on Rails
  * [ ] Heroku Redis or CDN setup

***

## Ruby Version

Smartdirect is tested with **Ruby 2.3.1** and **PostgreSQL 9.4** on Travis CI. See [`.travis.yml`](/.travis.yml) and [`.ruby-version`](/.ruby-version).

***

## Running

Smartdirect is built with [Rails 5](http://rubyonrails.org/). If you don't already know how to work with rails, consider [JetBrains RubyMine](https://www.jetbrains.com/ruby/).

***

## Configuration

To run the app, you must create a `.env` file based on [`.env.template`](/.env.template). This file will set environment variables for you but only in development. You will need to set the appropriate environment variables yourself in production.

Application settings can be found in [`config/settings.yml`](/config/settings.yml) and [`config/settings/`](/config/settings/).

***

## Database Setup

You may set up a PostgreSQL database on `localhost` for testing.
You will need to do the following in `psql`:

```SQL
CREATE USER smartdirect; /* with password `smartdirect` */
CREATE DATABASE smartdirect_dev;

REVOKE CONNECT ON DATABASE smartdirect_dev FROM PUBLIC;
GRANT CONNECT ON DATABASE smartdirect_dev TO smartdirect;
```

If you plan on deleting and recreating databases you may also want to do the following:

```SQL
ALTER USER smartdirect CREATEDB;
ALTER DATABASE smartdirect_dev OWNER TO smartdirect
```

Please see [`settings/development.yml`](/config/settings/development.yml) to see/modify the connection settings used when developing.

Connection settings can also be modified using the environment variables `SMD_DATABASE_HOST`, `SMD_DATABASE_USER`, `SMD_DATABASE_PASSWORD`, `SMD_DATABASE_DB`, and `SMD_DATABASE_PORT`.

Make sure to run `bin/rails db:migrate RAILS_ENV=development` before starting!

***

## Testing

Testing is done with [RSpec](http://rspec.info/).

You may use an IDE such as [JetBrains RubyMine](https://www.jetbrains.com/ruby/) or use `bin/rspec` from the command line.

Please see [`config/settings/test.yml`](/config/settings/test.yml) to see/modify the connection settings used when testing.

Make sure to run `bin/rails db:migrate RAILS_ENV=test` before running tests!

***

## Deploying

TODO

***

## Contributions

Contributions are welcome. Smartdirect is MIT Licensed.