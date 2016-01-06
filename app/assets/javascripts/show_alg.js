var ROOFPIG_CONF_AD = "solved=U-| hover=3 | speed=600";

var rp_setups = {
  0: "",
  1: "| setupmoves=U",
  2: "| setupmoves=U2",
  3: "| setupmoves=U'"
};

function rp_setup(u_setup) {
  net_setup = (u_setup + u_rotation + 4) % 4
  return rp_setups[net_setup]
}


function roofpig_dialog(title, alg, u_setup, below_element) {
  CubeAnimation.create_in_dom('#show-alg', 'alg='+alg+'|base=AD|flags=showalg'+rp_setup(u_setup), "class='roofpig rp-dialog'");
  $('#show-alg').dialog({
    position: { my: 'center top', at: 'center bottom', of: below_element },
    width: '240px',
    title: title,
    modal: true,
    closeOnEscape: true,
    dialogClass: 'lars-dialog',
    close: function( event, ui ) {
      var cube_id = $('#show-alg').children().attr('data-cube-id');
      if (cube_id) {
        CubeAnimation.by_id[cube_id].remove();
      }
    }
  });
}

$(document).on('click', '.algs-list .show-pig', function(e) {
  var td = $(event.target).parent();
  var alg = td.prev().text();
  var title = td.siblings().eq(2).text();

  roofpig_dialog(title, alg, td.data("uset"), td.parent())
});

$(document).on('click', '.positions-list .show-pig', function(e) {
  var td = $(event.target).parent();
  var alg = td.prev().text();
  var title = td.siblings().eq(0).text() + ' shortest';

  roofpig_dialog(title, alg, td.data("uset"), td.parent())
});
