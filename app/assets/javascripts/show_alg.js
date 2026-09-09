var ROOFPIG_CONF_AD = "solved=U-| hover=3 | speed=600";  // RoofPig pick this config up!

var rp_setups = {
  0: "",
  1: "| setupmoves=U",
  2: "| setupmoves=U2",
  3: "| setupmoves=U'"
};

function rp_setup(u_setup) {
  net_setup = (u_setup + page_rotation + 4) % 4
  return rp_setups[net_setup]
}


var rp_dialog_count = 0;

function roofpig_dialog(title, alg, u_setup, below_element) {
  var dialog_id = 'show-alg-' + (rp_dialog_count++);
  var $dialog = $("<div id='" + dialog_id + "' style='height:225px; width:225px; background: radial-gradient(circle at  50% 40%, #999 0%, #fff 70%);'></div>");
  $("body").append($dialog);

  CubeAnimation.create_in_dom('#' + dialog_id, 'alg='+alg+'|base=AD|flags=showalg'+rp_setup(u_setup), "class='roofpig rp-dialog'");

  $dialog.dialog({
    position: { my: 'center top', at: 'center bottom', of: below_element },
    width: '265px',
    title: title,
    modal: false,
    closeOnEscape: false, // handled globally below, so Escape closes every open animation at once
    dialogClass: 'lars-dialog',
    close: function( event, ui ) {
      var cube_id = $dialog.children().attr('data-cube-id');
      if (cube_id) {
        CubeAnimation.by_id[cube_id].remove();
      }
      $dialog.dialog('destroy').remove();
    }
  });
}

$(document).on('keydown', function(event) {
  if (event.key === 'Escape') {
    $('[id^="show-alg-"]').each(function() { $(this).dialog('close'); });
  }
});

$(document).on('click', '.algs-list .show-pig', function(event) {
  var td = $(event.target).parent();
  var alg = td.prev().text();
  var title = td.siblings().eq(2).text();

  roofpig_dialog(title, alg, td.data("uset"), td.parent())
});

$(document).on('click', '.mirroralg-list .show-pig', function(event) {
  var td = $(event.target).parent();
  var alg = td.prev().text();
  var title = td.prev().prev().prev().prev().text();

  roofpig_dialog(title, alg, td.data("uset"), td.parent())
});

$(document).on('click', '.positions-list .show-pig', function(event) {
  var td = $(event.target).parent();
  var alg = td.prev().text();
  var title = td.siblings().eq(0).text() + ' shortest';

  roofpig_dialog(title, alg, td.data("uset"), td.parent())
});
