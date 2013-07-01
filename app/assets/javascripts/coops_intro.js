/*global $ */
$(document).ready(function()
{
  $('#show_more_info').show();
  $('#more_info').hide();

  $('#show_more_info').click(function(event)
  {
    $('#show_more_info').hide();
    $('#more_info').show(1000);
    event.preventDefault();
  });
});
