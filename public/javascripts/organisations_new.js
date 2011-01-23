/*global $ */
$(document).ready(function () {
  // Setup a new org, autofill subdomain while typing group name
  // Hide helper text:
  $('body.setup p#help_subdomain').hide();
  // Show helper text on typing:
  $('body.setup input#organisation_name').focus(function() {
    $('body.setup p#help_subdomain').fadeIn('slow');
  });
  // On every key press:
  $('body.setup input#organisation_name').keyup(function() {
    var text = $('input#organisation_name').val();
    text = text.toLowerCase();
    // Regex to whitelist organisation name to generate a subdomain
    // Obviously, we still need to validate this in the app
    text = text.replace(/[^a-z0-9]/g,'');
    $('input#organisation_subdomain').val(text);
  });
  
  $('form#new_organisation').bind('submit', function (event) {
    event.preventDefault();
    OneClickOrgs.activateLightbox();
    $('button#cancel_terms').focus();
  })
  $('button#cancel_terms').click(function () {
    OneClickOrgs.dismissLightbox();
  });
  $('button#confirm_terms').click(function (event) {
    $(event.target).attr('disabled', true);
    $('button#cancel_terms').attr('disabled', true);
    
    $('input#founder_terms_and_conditions').val('1');
    
    $('form#new_organisation').unbind('submit');
    // Can't just use form.submit(), because the presence of an input
    // element with id 'submit' monkeys that up or something.
    $('form#new_organisation input#submit').trigger('click');
  });
});
