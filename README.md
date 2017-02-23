## Complect Web App

Build Status: ![Codeship](https://codeship.com/projects/7b4076f0-db4b-0134-05b7-4a5a03b4ed0e/status?branch=master)

### Getting Started

1. `bundle install`
2. Run `overcommit --install && overcommit --sign`
3. Configure database

### Configuration

Everything is configured using environment variables so we have it all on one place.

- `.env` contains all the variables used by the application.
- `.env.development` houses settings that can be shared between developers.
- `.env.test` contains settings for the test environment
- `.env.production` this file belongs on the server; we set here all the variables (or use Heroku's variables)
- `.env.local` is ".gitignore'd" so each dev can override any setting

### Database

Using PostgreSQL via a `DATABASE_URL` environment variable.

### Asset Management

Using bower at `vendor/assets/components`.
