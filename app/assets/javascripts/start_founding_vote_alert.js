/*global $ */
$(document).ready(function () {
  $('form#start_founding_vote_form').bind('submit', function (event) {
    event.preventDefault();
    OneClickOrgs.activateLightbox({id : 'start_founding_vote_alert_lightbox', complete : function () {$('button#ok').focus();}});
  });
  $('button#ok').click(function () {
    OneClickOrgs.dismissLightbox({id : 'start_founding_vote_alert_lightbox'});
  });
});

