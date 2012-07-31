$(document).ready(function () {
  $('#general_meeting_annual_general_meeting').change(function () {
    if ($('#general_meeting_annual_general_meeting:checked').val() == '1') {
      $('#annual_general_meeting_fields').show();
    } else {
      $('#annual_general_meeting_fields').hide();
    }
  });
});
