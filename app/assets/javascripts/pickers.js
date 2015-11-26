var mouse_is_inside_picker = '';

var picker_dialog_props = {
  cop: options({ width: '400px', title: 'Corner orientation & position (COP)'}),
  oll: options({ width: '404px', title: 'Corner and edge orientation (OLL)'}),
  co:  options({ width: '394px', title: 'Corner orientation (CO)'}),
  cp:  options({ width: '308px', title: 'Corner position (CP)'}),
  eo:  options({ width: '394px', title: 'Edge orientation (EO)'}),
  ep:  options({ width: '572px', title: 'Edge position (EP)'})
};
function options(specifics) {
  var pos = { my: 'center top', at: 'center bottom', of: '#pickers' };
  return $.extend(specifics, {resizable: false, modal: false, draggable: false, position: pos, dialogClass: "picker-dialog"});
}

$(document).on({
  mouseenter: function(event) {
    var field = $(event.currentTarget).attr('data-prop');
    var picker = $('#'+field+'-picker').dialog(picker_dialog_props[field]);
    picker.parent().attr('data-dialog-field', field)
  },
  mouseleave: function(event) {
    var field = $(event.currentTarget).attr('data-prop');
    setTimeout(function(){
      if (mouse_is_inside_picker != field) { $('#'+field+'-picker').dialog('close'); }
    }, 100);
  }
}, ".selected-icon");

$(document).on({
  mouseenter: function(event) {
    mouse_is_inside_picker = $(event.currentTarget).attr('data-dialog-field')
  },
  mouseleave: function(event) {
    var field = $(event.currentTarget).attr('data-dialog-field');
    $('#'+field+'-picker').dialog('close');
    mouse_is_inside_picker = ''
  }
}, ".picker-dialog");
