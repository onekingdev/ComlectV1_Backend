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

  #$(".solution_flavor").on 'change', ->
  #  window.sss = this
  #  if $(this).find(".active input").val() == "era"
  #    $(this).parent().find(".solution_state").fadeOut()
  #  else
  #    $(this).parent().find(".solution_state").fadeIn()

  #$(".hidden-on-load").closest(".solution_state").fadeOut()

$(window).resize ->
  window.fix_turnkeys()
