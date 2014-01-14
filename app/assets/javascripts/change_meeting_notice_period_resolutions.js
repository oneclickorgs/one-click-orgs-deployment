// Place all the behaviors and hooks related to the matching controller here.
// All this logic will automatically be available in application.js.
$(document).ready(function () {
  var observeMeetingNoticePeriodField = function()
  {
    var currentMeetingNoticePeriod = parseInt($('span.meeting_notice_period').first().text(), 10);
    var newMeetingNoticePeriod = parseInt($('#change_meeting_notice_period_resolution_meeting_notice_period').val(), 10);
    if (newMeetingNoticePeriod >= currentMeetingNoticePeriod) {
      $('.increase_meeting_notice_period').slideDown();
      $('.decrease_meeting_notice_period').slideUp();
    } else {
      $('.increase_meeting_notice_period').slideUp();
      $('.decrease_meeting_notice_period').slideDown();
    }
  };

  setInterval(observeMeetingNoticePeriodField, 100);

  $(document).on('change', '#change_meeting_notice_period_resolution_meeting_notice_period', function() {
  });
  $('#change_meeting_notice_period_resolution_pass_immediately').change(function () {
    if ($('#change_meeting_notice_period_resolution_pass_immediately:checked').val() == '1') {
      $('.pass_immediately_true').show();
      $('.pass_immediately_false').hide();
    } else {
      $('.pass_immediately_true').hide();
      $('.pass_immediately_false').show();
    }
  });
});
