/*global $ */
$(document).ready(function () {
  $('form#edit_member').bind('submit', function (event) {
    event.preventDefault();
    OneClickOrgs.activateLightbox({complete : function () {$('button#cancel_terms').focus();}});
  });
  $('button#cancel_terms').click(function () {
    OneClickOrgs.dismissLightbox();
  });
  $('button#confirm_terms').click(function (event) {
    $(event.target).attr('disabled', true);
    $('button#cancel_terms').attr('disabled', true);
    
    $('input#member_terms_and_conditions').val('1');
    
    $('form#edit_member').unbind('submit');
    $('form#edit_member').submit();
  });
});
