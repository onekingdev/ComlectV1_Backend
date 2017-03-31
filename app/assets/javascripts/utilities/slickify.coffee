@slickify = (div_id, bp_1024, bp_992, bp_480) ->
  console.log div_id
  $(div_id + ' > .row').on 'init', (s) ->
    showhide_pages(div_id)
    return
  $(div_id + ' > .row').slick
    dots: true,
    infinite: false,
    speed: 300,
    slidesToShow: bp_1024,
    slidesToScroll: bp_1024,
    appendDots: $(div_id).find('.dot-pagination'),
    prevArrow: '.prev-slide',
    nextArrow: '.next-slide',
    arrows: false,

    customPaging: (slider, i) ->
      i + 1
    responsive: [
      {
        breakpoint: 992
        settings:
          slidesToShow: bp_992
          slidesToScroll: bp_992
      }
      {
        breakpoint: 480
        settings:
          slidesToShow: bp_480
          slidesToScroll: bp_480
      }
    ]

  $(div_id).on 'click', '.prev-slide', (e) ->
    e.preventDefault()
    $(div_id + ' > .row').slick 'slickPrev'
    return
  $(div_id).on 'click', '.next-slide', (e) ->
    e.preventDefault()
    $(div_id + ' > .row').slick 'slickNext'
    return
  .on 'breakpoint', (e, s, d) ->
    showhide_pages(div_id)
  .on 'afterChange', (s, c, n) ->
    showhide_pages(div_id)
  return

showhide_pages = (div_id) -> 
  nav = $(div_id).find(".slick-nav")
  if $(div_id).find(".slick-track").width() > $(div_id + " > .row").width()
    nav.show()
    dots = nav.find(".slick-dots")
    active = dots.find(".slick-active")
    index = active.index()
    $(".dot-ellipsis").removeClass("dot-ellipsis")
    lis = dots.find("li")
    lis.each (i) ->
      $(lis[i]).html(i+1)
      $(lis[i]).hide()
      return
    $(lis[0]).show()
    $(lis[1]).show()
    $(lis[2]).show()
    $(lis[lis.length-1]).show()
    $(lis[lis.length-2]).show()
    $(lis[lis.length-3]).show()
    $(lis[index-2]).show()
    $(lis[index-1]).show()
    $(lis[index]).show()
    $(lis[index+1]).show()
    $(lis[index+2]).show()
    if $(lis[3]).is(":hidden")
      $(lis[3]).html("...").show().addClass("dot-ellipsis")
    if $(lis[lis.length-4]).is(":hidden") && active.html() != "1" && active.html() != String(lis.length)
      $(lis[lis.length-4]).html("...").show().addClass("dot-ellipsis")
  else
    nav.hide()
  return