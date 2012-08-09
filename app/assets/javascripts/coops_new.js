/*global $ */
$(document).ready(function () {
  // Setup a new org, autofill subdomain while typing group name
  // On every key press:
  $('body.setup input#coop_name').keyup(function() {
    var text = $('input#coop_name').val();
    text = text.toLowerCase();
    // Regex to whitelist organisation name to generate a subdomain
    // Obviously, we still need to validate this in the app
    text = text.replace(/[^a-z0-9]/g,'');
    $('input#coop_subdomain').val(text);
  });
});
