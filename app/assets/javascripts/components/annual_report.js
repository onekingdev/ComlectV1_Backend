if (typeof(annual_report_loop) != "undefined") {
  $(".compliance_category_nav li").on("click", function() {
    var title = $(this).find("a").html();
    if ($(this).find("a").attr("data-category") != undefined) { // Categories
      var data_cid = $(this).find("a").attr("data-category");
      $($(".panel-settings-body h1")[0]).html(title);
      $(".panel-settings-body .panel-default").hide();
      $(".compliance_category_blk").hide();
      $("#compliance_category_blk_"+data_cid).show();
      $("#compliance_category_blk_"+data_cid+" .panel-default").show();
    } else { // General
      $($(".panel-settings-body h1")[0]).html("Annual Review");
      $(".panel-settings-body .panel-default").show();
      $(".compliance_category_blk").hide();
    }
  });

  $(document).ready(function() {
    $(".compliance_category_blk").hide();
    setTimeout(function() {
      $(".apply_changes").on("click", function() {
        var body = $("html, body");
        body.animate({scrollTop:$(".save-annual-report").offset().top}, 500, 'swing', function() { 
          // poof
        });
        setTimeout(function() {
          $(".save-annual-report").trigger("click");
          $(".save-annual-report").prop("disabled", true);
        }, 500)
      });

      $(".apply_changes").hide();
      var prev_report_form = JSON.stringify($(".edit_annual_report").serializeArray());
      var new_report_form;
      setInterval(function() {
        var new_report_form = JSON.stringify($(".edit_annual_report").serializeArray());
        if (prev_report_form != new_report_form) {
          prev_report_form = new_report_form;
          report_needs_update = false;
          $(".hide_on_change").animate({width: "0px", padding: "0px", "margin-left": "0px", "margin-right": "0px", opacity: "0"}).fadeOut();
          //$(".apply_changes").show();
          if ($(".apply_changes").hasClass("apply_bounce") == false) {
            $(".apply_changes").addClass("apply_bounce");
          }
          $(".apply_changes")[0].style.animation = "none";
          $(".apply_changes")[0].offsetHeight;
          $(".apply_changes")[0].style.animation = null;
        }
      }, 1000);
    }, 1000);
    $(".cof_bits").on("change", function() {
      var new_state = $(this).find("input").prop("checked")
      var ind = $(".cof_bits").index(this);
      var all_boxes = $(".cof_bits");
      //if ($(this).hasClass("parent_node")) {
      //  for (var i = ind+1; i < $(".cof_bits").length; i++) {
      //    if ($($(".cof_bits")[i]).hasClass("parent_node")) {
      //      break;
      //    } else {
      //      $($(".cof_bits")[i]).find("input").prop("checked", new_state);
      //    }
      //  }
      //} else {
      //  var last_parent = null;
      //  var enable_parent = true;
      //  for (box of all_boxes) {
      //    if ($(box).hasClass("parent_node")) {
      //      if (last_parent != null) {
      //        $(last_parent).find("input").prop("checked", enable_parent);
      //      }
      //      enable_parent = true;
      //      last_parent = box;
      //    } else {
      //      if (enable_parent) {
      //        if ($(box).find("input").prop("checked") == false) {
      //          enable_parent = false;
      //        }
      //      }
      //    }
      //  }
      //  if (last_parent != null) {
      //    $(last_parent).find("input").prop("checked", enable_parent);
      //  }
      //}
    });
  });
}

$(document).ready(function() {
  if (typeof(annual_review_render_id) != "undefined") {
    var bsurl = "/business/annual_reviews/";
    if (typeof(annual_review_baseurl) != "undefined") {
      bsurl = annual_review_baseurl;
    }
    var requestloop = setInterval(function() {
      $.ajax({
        type: 'GET',
        url: bsurl+annual_review_render_id+"json",
        success: function(data) {
          if (data.preview != false) {
            $(".pdf_preview_area").html("<iframe height='500px' src='/pdfjs/minimal?file="+encodeURIComponent(data.preview)+"' width='100%'></iframe>");
            clearInterval(requestloop);
          }
        }
      });
    }, 3000)
  }
})