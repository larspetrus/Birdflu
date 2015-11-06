function roofpig_dialog(title, alg, u_setup, below_element) {
  CubeAnimation.create_in_dom('#show-alg', 'alg='+alg+'|base=AD|flags=showalg'+u_setup, "class='roofpig rp-dialog'");
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
