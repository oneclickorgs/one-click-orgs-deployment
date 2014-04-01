/*global $ */
$(document).ready(function () {
  // Setup a new org, autofill subdomain while typing group name
  // Hide helper text:
  $('body.setup p#help_subdomain').hide();
  // Show helper text on typing:
  $('body.setup input#association_name').focus(function() {
    $('body.setup p#help_subdomain').fadeIn('slow');
  });
  // On every key press:
  $('body.setup input#association_name').keyup(function() {
    var text = $('input#association_name').val();
    text = text.toLowerCase();
    // Regex to whitelist organisation name to generate a subdomain
    // Obviously, we still need to validate this in the app
    text = text.replace(/[^a-z0-9]/g,'');
    $('input#association_subdomain').val(text);
  });
  
  $('a.terms').click(function(event)
  {
    event.preventDefault();
    OneClickOrgs.activateLightbox();
  });
  $('button#close_terms').click(function ()
  {
    OneClickOrgs.dismissLightbox();
  });
  $('form#new_association').bind('submit', function(event)
  {
    $('p#loading').show();
    $(event.target).attr('disabled', true)
    $('#submit').hide();
  });
});
