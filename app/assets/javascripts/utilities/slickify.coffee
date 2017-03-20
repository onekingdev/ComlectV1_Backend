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
  return

showhide_pages = (div_id) -> 
  console.log "ulyulyukyukee"
  console.log $(div_id).find(".slick-track").width()
  console.log $(div_id + " > .row").width()
  if $(div_id).find(".slick-track").width() > $(div_id + " > .row").width()
    $(div_id).find(".slick-nav").show()
  else
    $(div_id).find(".slick-nav").hide()
  return