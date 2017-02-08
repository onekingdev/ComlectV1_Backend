# Discourse Setup

* Set e-mail addresses
  * `/admin/site_settings/category/required`
  * `contact email` and `notification email`

* Company info
  * `/admin/site_settings/category/required`
  * `company short name` -> `Complect`
  * `company full name` -> `Complect LLC`
  * `company domain` -> `<domain>` or `complect.co`

* Login settings
  * `/admin/site_settings/category/login`
  * Enable `login required`
  * Enable `enable sso`
  * `sso url` -> `https://<domain>/specialist_sso`
  * `sso secret` -> Same as Heroku config `DISCOURSE_SECRET`

* Users
  * `/admin/site_settings/category/users`
  * `username change period` -> `0`
  * `logout redirect` -> `https://<domain>/users/sign_out/force`

* Posting
  * `/admin/site_settings/category/posting`
  * Disable `enable private messages`
  
* Trust level
  * `/admin/site_settings/category/trust`
  * `default trust level` -> 1

* Security
  * `/admin/site_settings/category/security`
  * Disable `allow index in robots txt`
  
* Other
  * `/admin/site_settings/category/uncategorized`
  * Disable `version checks`
  * Disable `new version emails`

## Colors

`/admin/customize/colors`

Create a new theme, and use the following colors:

* `header background` -> `#646464`
* `header primary` -> `#ffffff`

Save and enable.

## Customization

For each section, go to `/admin/customize/css_html` and add code as instructed.

Make sure to enable each customization.

### Theme

Put the following code into the `CSS` section:

```css
@font-face {
  font-family: Muller, Helvetica, serif;
  src: url('https://beta.complect.co/fonts/mullerregular-webfont.eot');
  src: url('https://beta.complect.co/fonts/mullerregular-webfont.eot?#iefix') format('embedded-opentype'),
       url('https://beta.complect.co/fonts/mullerregular-webfont.woff2') format('woff2'),
       url('https://beta.complect.co/fonts/mullerregular-webfont.woff') format('woff'),
       url('https://beta.complect.co/fonts/mullerregular-webfont.ttf') format('truetype'),
       url('https://beta.complect.co/fonts/mullerregular-webfont.svg#mullerregular') format('svg');
  font-weight: 400;
  font-style: normal;
}

@font-face {
  font-family: Muller, Helvetica, serif;
  src: url('https://beta.complect.co/fonts/mullerbold-webfont.eot');
  src: url('https://beta.complect.co/fonts/mullerbold-webfont.eot?#iefix') format('embedded-opentype'),
       url('https://beta.complect.co/fonts/mullerbold-webfont.woff2') format('woff2'),
       url('https://beta.complect.co/fonts/mullerbold-webfont.woff') format('woff'),
       url('https://beta.complect.co/fonts/mullerbold-webfont.ttf') format('truetype'),
       url('https://beta.complect.co/fonts/mullerbold-webfont.svg#mullerbold') format('svg');
  font-weight: 600;
  font-style: normal;
}

body {
  font-family: Muller, Helvetica;
  font-size: 12px;
  font-weight: 400;
}
```

### Disable About Page

Put the following code into the `</head>` section:

```html
<script type='text/x-handlebars' data-template-name='about'>
<div class='container body-page'>
  {{#if contactInfo}}
    <section class='about contact'>
      <h3>{{i18n 'about.contact'}}</h3>
      <p>{{{contactInfo}}}</p>
    </section>
  {{/if}}
</div>
</script>
```
