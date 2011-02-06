
/*global $ */
$(document).ready(function () {
  $('form#start_founding_vote_form').bind('submit', function (event) {
    event.preventDefault();
    OneClickOrgs.activateLightbox({id : 'start_founding_vote_confirmation_lightbox', complete : function () {$('button#cancel_start_founding_vote').focus();}});
  });
  $('button#cancel_start_founding_vote').click(function () {
    OneClickOrgs.dismissLightbox({id : 'start_founding_vote_confirmation_lightbox'});
  });
  $('button#confirm_start_founding_vote').click(function (event) {
    $('p#loading').show();
    
    $(event.target).attr('disabled', true);
    $('button#cancel_start_founding_vote').attr('disabled', true);
    
    $('form#start_founding_vote_form').unbind('submit');
    $('form#start_founding_vote_form input#submit').trigger('click');
  });
});
