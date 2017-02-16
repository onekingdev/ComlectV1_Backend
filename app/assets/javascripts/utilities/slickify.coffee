@slickify = (div_id) ->
  console.log div_id
  $(div_id + ' > .row').on 'init', (slick) ->
    slick_dots = $(slick.currentTarget).find('.slick-dots')
    if slick_dots.length > 0
      slick_prev = $(slick.currentTarget).find('.slick-prev')[0]
      slick_next = $(slick.currentTarget).find('.slick-next')[0]
      $(slick_dots[0]).prepend '<div class=\'slick-prev-sub\'>Q</div>'
      $(slick_dots[0]).append '<div class=\'slick-next-sub\'>+</div>'
      $($(slick.currentTarget).find('.slick-prev-sub')[0]).click ->
        $(slick_prev).trigger 'click'
        return
      $($(slick.currentTarget).find('.slick-next-sub')[0]).click ->
        $(slick_next).trigger 'click'
        return
    return
  $(div_id + ' > .row').slick
    dots: true
    infinite: false
    speed: 300
    slidesToShow: 3
    slidesToScroll: 3
    customPaging: (slider, i) ->
      i + 1
    responsive: [
      {
        breakpoint: 1024
        settings:
          slidesToShow: 3
          slidesToScroll: 3
          infinite: false
          dots: true
      }
      {
        breakpoint: 992
        settings:
          slidesToShow: 2
          slidesToScroll: 2
      }
      {
        breakpoint: 480
        settings:
          slidesToShow: 1
          slidesToScroll: 1
      }
    ]
  return

@slickify_timesheets = (div_id) ->
  console.log div_id
  $(div_id + ' > .row').on 'init', (slick) ->
    slick_dots = $(slick.currentTarget).find('.slick-dots')
    if slick_dots.length > 0
      slick_prev = $(slick.currentTarget).find('.slick-prev')[0]
      slick_next = $(slick.currentTarget).find('.slick-next')[0]
      $(slick_dots[0]).prepend '<div class=\'slick-prev-sub\'>Q</div>'
      $(slick_dots[0]).append '<div class=\'slick-next-sub\'>+</div>'
      $($(slick.currentTarget).find('.slick-prev-sub')[0]).click ->
        $(slick_prev).trigger 'click'
        return
      $($(slick.currentTarget).find('.slick-next-sub')[0]).click ->
        $(slick_next).trigger 'click'
        return
    return
  $(div_id + ' > .row').slick
    dots: true
    infinite: false
    speed: 300
    slidesToShow: 5
    slidesToScroll: 5
    customPaging: (slider, i) ->
      i + 1
    responsive: [
      {
        breakpoint: 1024
        settings:
          slidesToShow: 5
          slidesToScroll: 5
          infinite: false
          dots: true
      }
      {
        breakpoint: 992
        settings:
          slidesToShow: 4
          slidesToScroll: 4
      }
      {
        breakpoint: 480
        settings:
          slidesToShow: 3
          slidesToScroll: 3
      }
    ]
  return