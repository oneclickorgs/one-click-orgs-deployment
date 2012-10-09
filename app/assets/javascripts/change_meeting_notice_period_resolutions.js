// Place all the behaviors and hooks related to the matching controller here.
// All this logic will automatically be available in application.js.
$(document).ready(function () {
  $(document).on('change', '#change_meeting_notice_period_resolution_meeting_notice_period', function() {
    var currentMeetingNoticePeriod = parseInt($('span.meeting_notice_period').first().text(), 10);
    var newMeetingNoticePeriod = parseInt(this.value, 10);
    if (newMeetingNoticePeriod >= currentMeetingNoticePeriod) {
      $('.increase_meeting_notice_period').slideDown();
      $('.decrease_meeting_notice_period').slideUp();
    } else {
      $('.increase_meeting_notice_period').slideUp();
      $('.decrease_meeting_notice_period').slideDown();
    }
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
