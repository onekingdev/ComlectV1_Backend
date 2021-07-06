# Almost identical to Rails' version with two changes:
# 1) Use data-url attribute when $.rails.href(link) returns undefined
# 2) Make the form remote if the link is also remote
$.rails.handleMethod = (link) ->
  href = $.rails.href(link) || link.data('url')
  method = link.data('method')
  target = link.attr('target')
  csrfToken = $.rails.csrfToken()
  csrfParam = $.rails.csrfParam()
  form = $("<form method='post' action='#{href}'></form>")
  metadataInput = "<input name='_method' value='#{method}' type='hidden' />"

  if csrfParam? && csrfToken? && !$.rails.isCrossDomain(href)
    metadataInput += "<input name='#{csrfParam}' value='#{csrfToken}' type='hidden' />"

  if target then form.attr('target', target)
  if link.data('remote') then form.attr('data-remote', link.data('remote'))

  form.hide().append(metadataInput).appendTo('body')
  form.submit()
