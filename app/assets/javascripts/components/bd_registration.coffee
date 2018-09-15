if typeof all_bds != 'undefined'
  $(".bd-stuff > .check_boxes").change ->
    bds = []
    $(this).find("input:checked").each ->
      bds.push($(this).val())
    bd_prices = [[1200, 0], [20000, 5000], [65000, 5000], [135000, 0]]
    ranked_bds = []
    for i of bds
      for j of all_bds
        if all_bds[j][0] == bds[i]
          ranked_bds.push([bds[i], all_bds[j][1]])
    max_bd = ["", -1]
    for i of ranked_bds
      if max_bd[1] < ranked_bds[i][1]
        max_bd = ranked_bds[i]
    base_price = 0
    if max_bd[1] >= 0
      base_price = bd_prices[max_bd[1]][0]
    add_price = 0
    g = {}
    for i of ranked_bds
      if !(g[ranked_bds[i][1]] == undefined)
        g[ranked_bds[i][1]] += 1
      else
        g[ranked_bds[i][1]] = 1
    for k,v of g
      cnt = parseInt(v / 3)
      if cnt > 0
        add_price += bd_prices[k][1] * cnt
    price_span = $($(this).closest("form").find("span")[0])
    total_price = base_price+add_price
    if total_price == 0
      price_span.html("$12,000-$135,000+")
    else
      price_span.html("$"+parseInt(base_price+add_price).toLocaleString())