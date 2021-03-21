High Order Components (HOC) for working with REST API
=====================================================

Because almost all features are implemented as forms, API interactions fall into these three scenarios:
  1) retrieving data from API (GET) to render single model or list of models
  2) retrieving data from API (GET) to fill model editing form fields
  3) saving when creating (POST) or editing (PUT) a single entry from a form, or standalone button

All these three scenarios are implemented in the form of High Order Components (HOC):
  1) `common/rest/Get.vue` for fetching API data for rendering
  2) `common/rest/ModelLoader.vue` for fetching a model from backend and loading it into a form
  3) `common/rest/Post.vue` for form save buttons and other standalone buttons

`Get.vue`
---------

For every given prop, fetches JSON from API, and passes it down to child components. A scoped slot is required to pass these props:

```
  Get(projects="/api/business/projects"): template(v-slot="{projects}")
    div(v-for="project in projects" :key="project.id")
      ...
```

For convenience, you can pass a function that will be applied to retrieved data into `callback` prop.

If you need to trigger re-fetching the component content from parent component, you should update it's `etag` property.
For easy etag handling and generation, parent component may use `EtaggerMixin`.

`ModelLoader.vue`
-----------------

Loads a model from API URL into a form, or loads default form values (if URL not set).
It is different from `Get.vue`:
  + only assigns attributes that are required on frontend
  + no need to separate creating and editing logic
  + if no API loading required, returns initial form state

Example:

```
  ModelLoader(:url="projectId ? projectApiUrl : undefined" :default="initialModel" @loaded="project = $event")
    input.form-control(v-model="project.title" type=text placeholder="Title")
    input.form-control(v-model="project.description" type=text placeholder="Description")
    ...
```

Where `url` should be set if loading existing project (editing), or empty if creating new,
`initialModel` - callback returning initial form state object,
`@loaded` - event triggered after successfully retrieving data.

You can trigger re-fetching data from parent component if you change the value of `etag` property (see `Get.vue` about `etag`).

`Post.vue`
----------

This component is useful when creating form submission buttons. Other use case is standalone buttons that update one field of certain model.
Example (form submission):

```
  Post(action="/api/business/project" :model="project" @errors="errors = $event" @saved="saved")
    button.btn.btn-dark Create
```

Where `action` is API endpoint URL,
`model` - object being sent to endpoint,
`@errors` - event triggered on validation errors,
`@saved` - successful saving event.
Alternatively, you can use POST method, if you pass `method="PUT"`.

Another example, updating one field:

```
  Post(action="/api/business/tasks/123" method="PUT" :model="{done:true}" @errors="errors = $event" @saved="saved")
    button.btn.btn-dark Mark as Done
```
