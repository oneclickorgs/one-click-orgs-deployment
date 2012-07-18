// Place all the behaviors and hooks related to the matching controller here.
// All this logic will automatically be available in application.js.
$(document).ready(function () {
  var currentMeetingNoticePeriod = parseInt($('span.meeting_notice_period').first().text());
  $('#change_meeting_notice_period_resolution_meeting_notice_period').observe_field(1, function () {
    var newMeetingNoticePeriod = parseInt(this.value);
    if (newMeetingNoticePeriod >= currentMeetingNoticePeriod) {
      $('.increase_meeting_notice_period').slideDown();
      $('.decrease_meeting_notice_period').slideUp();
    } else {
      $('.increase_meeting_notice_period').slideUp();
      $('.decrease_meeting_notice_period').slideDown();
    }
  });
});
