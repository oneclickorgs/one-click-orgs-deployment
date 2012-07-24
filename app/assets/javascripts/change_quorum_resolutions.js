// Place all the behaviors and hooks related to the matching controller here.
// All this logic will automatically be available in application.js.
$(document).ready(function () {
  $('#change_quorum_resolution_pass_immediately').change(function () {
    if ($('#change_quorum_resolution_pass_immediately:checked').val() == '1') {
      $('.pass_immediately_true').show();
      $('.pass_immediately_false').hide();
    } else {
      $('.pass_immediately_true').hide();
      $('.pass_immediately_false').show();
    }
  });
});
