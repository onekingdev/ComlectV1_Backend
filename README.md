## Complect Web App

### Setup project locally

1. If you don't have ruby `2.5.7` on your computer:

    * install [rbenv](https://github.com/rbenv/rbenv)

    * `rbenv install 2.5.7`

    * `gem install bundler`
  
2. If you don't have postgress on your computer:

    * [Install Postgres](https://www.postgresql.org/download/)

    * Check postgres version: `pg_config --version`

3. App needs postgis.control (example for install `postgis` for postgres 13)

    * Check if you have postgis.control extension: `find /usr -name postgis.control`
    
    * Install: `sudo apt install postgis postgresql-13-postgis-3`

4. Check if you have `node 14.17.3`

    * node -v

    * install node: `nvm install 14.17.3`


5. `git clone git@github.com:complectco/complect.git`
6. `cd complect`
7. `rbenv local 2.5.7`
8. `bundle`
9. Run `overcommit --install && overcommit --sign`
10. Ask about `.env` and `env.local` files
11. Check `POSTGRES_USER` and `POSTGRES_PASSWORD` in `.env` file
12. `rake db:create`
13. `rake db:migrate`
14. `rake db:seed`
15. Run `rails s` in one tab of terminal
16. Open second tab and run commands:

    * `nvm use 14.17.3`

    * `npm install`

    *  `./bin/webpack-dev-server`

17. [http://localhost:3000/](http://localhost:3000/)

### Tests
- Prepare for testing: `rake db:test:prepare`
- Run tests: `rspec spec/`
- You can check tests coverage. Open file in browser: `coverage/index.html`

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

### Docker on Heroku
* `heroku container:push web worker -a <Heroku App ID>`
* `heroku container:release web worker -a <Heroku App ID>`

### Global Development Rules

- When creating validations for forms, all error messages should be in form. Do not use toasts.
- When user submits a form with a required field that is empty/missing, the error message text is ALWAYS: "Required field". Do not use periods for error messages within forms. 
- When creating success toasts, general text format should be "XX has been YY." For example, "Task has been created." Do not add "The" "A", etc. in front of the sentence. Always use periods for text within toasts.
- When creating error toasts, general text format should be "XX has not been YY. Please try again." For example, "Project has not been posted. Please try again." When it is possible for user to correct something to avoid error, then text format should be "XX has not been YY. Please XYZ." For example, "Proposal has not been submitted. Please add a bank account for Client Billing." Do not add "The" "A", etc. in front of the sentence. Always use periods for text within toasts.
-Buttons should always have capitalized words, EXCEPT for connecting words like "and", "as", "an" etc. For example, "Save as Draft" NOT "Save As Draft". For example, "New Task" NOT "New task"
