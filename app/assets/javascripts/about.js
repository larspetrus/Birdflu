$(document).on('click', '#about-link', function(event) {
  $('#about-box').dialog({
    position: { my: 'center top', at: 'center bottom', of: '#pickers' },
    width: '240px',
    title: 'About Algopalooza',
    modal: true,
    closeOnEscape: true,
    dialogClass: 'lars-dialog'
  });
})