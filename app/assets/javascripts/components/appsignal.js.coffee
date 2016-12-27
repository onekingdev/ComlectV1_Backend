class @Appsignal
  constructor: ->
    @action = ""
    @tags   = {}

  setAction: (action) ->
    @action = action

  tagRequest: (tags) ->
    for key in tags
      @tags[key] = tags[key]

  sendError: (error) ->
    data = {
      action:    @action
      message:   error.message
      name:      error.name
      backtrace: error.stack?.split("\n")
      path:      window.location.pathname
      tags:      @tags
      environment: {
        agent:         navigator.userAgent
        platform:      navigator.platform
        vendor:        navigator.vendor
        screen_width:  screen.width
        screen_height: screen.height
      }
    }

    xhr = new XMLHttpRequest()
    xhr.open('POST', '/errors', true)
    xhr.setRequestHeader('Content-Type', 'application/json; charset=UTF-8')
    xhr.send(JSON.stringify(data))
