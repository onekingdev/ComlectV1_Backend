window.fix_turnkeys = -> 
  max_height = 0
  $('.turnkey-entry').each ->
    $(this).find("form").height "auto"
  $('.turnkey-entry > form').each ->
    if $(this).height() > max_height
      max_height = $(this).height()
  $('.turnkey-entry').each ->
    $(this).find("form").height max_height

$.onContentReady ($parent) ->
  window.fix_turnkeys()
  $(".turnkey_pages.show").on 'click', '.btn-purchase', ->
    form = $("[data-solution-id="+$(this).attr("data-solution")+"]").closest("form")

    $.ajax
      type: 'PATCH'
      url: form.attr("action")
      data: form.serialize()
      success: (data) ->
        _Modal.showPlain(data)

  $(".turnkey_pages.show").on 'click', '.btn-customize', ->
    form = $("[data-solution-id="+$(this).attr("data-solution")+"]").closest("form")
    form.attr "method", "get"
    form.attr "action", "/turnkey/new"
    form.submit()
  $(".solution_flavor").on 'change', ->
    order = []
    $(this).find("label.btn").each ->
      order.push($(this).hasClass("active"))
    price = $(this).closest("form").attr("data-budgets").split(' ')[order.indexOf(true)]
    $($(this).closest("form").find("h1 span")[0]).html("$"+parseInt(price).toLocaleString())
    switcher = $(this).closest("form").find(".description_switcher")
    switcher.hide()
    $(switcher[order.indexOf(true)]).show()
  #$(".solution_flavor").on 'change', ->
  #  window.sss = this
  #  if $(this).find(".active input").val() == "era"
  #    $(this).parent().find(".solution_state").fadeOut()
  #  else
  #    $(this).parent().find(".solution_state").fadeIn()

  #$(".hidden-on-load").closest(".solution_state").fadeOut()

$(document).on 'click', '.remote-submit-no-popup', (e) ->
  form = $(this).closest("form")
  $.ajax
    type: 'POST'
    url: form.attr("action")
    data: form.serialize()
    success: (data) ->
      form.find(".remote-submit-errors").html(data)

$(window).resize ->
  window.fix_turnkeys()
