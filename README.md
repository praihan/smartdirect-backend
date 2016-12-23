# Smartdirect

[![Build Status](https://travis-ci.org/prshreshtha/smartdirect-backend.svg?branch=master)](https://travis-ci.org/prshreshtha/smartdirect-backend)

## Testing

Testing is done with RSpec. You will need to set up a PostgreSQL database on `localhost` for testing.
You will need to do the following in `psql`:
```SQL
CREATE USER <username>;
CREATE DATABASE <database>;

REVOKE CONNECT ON DATABASE <database> FROM PUBLIC;
GRANT CONNECT ON DATABASE <database> TO username;

ALTER USER <username> CREATEDB;
ALTER DATABASE <database> OWNER TO <username>
```
Please see [settings/test.yml](/config/settings/test.yml) to see/modify the connection settings
used when testing.

Make sure to run `bin/rails db:migrate RAILS_ENV=test` afterwards!

***

Things you may want to cover:

* Ruby version

* System dependencies

* Configuration

* Database creation

* Database initialization

* How to run the test suite

* Services (job queues, cache servers, search engines, etc.)

* Deployment instructions

* ...
