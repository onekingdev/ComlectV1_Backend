## Complect Web App

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

### Docker on Heroku
* `heroku container:push web worker -a <Heroku App ID>`
* `heroku container:release web worker -a <Heroku App ID>`

### Global Development Rules

- When creating validations for forms, all error messages should be in form. Do not use toasts.
- When user submits a form with a required field that is empty/missing, the error message text is ALWAYS: "Required field". Do not use periods for error messages within forms. 
- When creating success toasts, general text format should be "XX has been YY." For example, "Task has been created." Do not add "The" "A", etc. in front of the sentence. Always use periods for text within toasts.
- When creating error toasts, general text format should be "XX has not been YY. Please try again." For example, "Project has not been posted. Please try again." When it is possible for user to correct something to avoid error, then text format should be "XX has not been YY. Please XYZ." For example, "Proposal has not been submitted. Please add a bank account for Client Billing." Do not add "The" "A", etc. in front of the sentence. Always use periods for text within toasts.
-Buttons should always have capitalized words, EXCEPT for connecting words like "and", "as", "an" etc. For example, "Save as Draft" NOT "Save As Draft". For example, "New Task" NOT "New task"
