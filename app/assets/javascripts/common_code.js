function roofpig_dialog(title, alg, u_setup) {
  CubeAnimation.create_in_dom('#show-alg', 'alg='+alg+'|base=AD|flags=showalg'+u_setup, "class='roofpig rp-dialog'");
  $('#show-alg').dialog({
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
