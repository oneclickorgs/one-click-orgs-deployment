/*global $ */
$(document).ready(function () {
  $('.constitution_proposal .reveal_link a').click(function (event) {
    $(event.target).parents('.constitution_proposal').children('.proposal_form').slideDown('normal');
    $(event.target).parents('.reveal_link').slideUp();
    event.preventDefault();
  });
  $('.constitution_proposal .cancel_link').click(function (event) {
    $(event.target).parents('.constitution_proposal').children('.reveal_link').slideDown('normal');
    $(event.target).parents('.constitution_proposal').children('.proposal_form').slideUp();
    event.preventDefault();
  });

  // Forms at the top of the dashboard
  // (If JavaScript is disabled, they all show by default)
  $('.form-to-hide').hide();
  $('.button-form-show').show();
  // Reset when a button is clicked
  $('.button-form-show').click(function() {
    $('.button-form-show').removeClass('clicked');
    $('.form-to-hide').hide();
  });
  // Each of the three buttons:
  $('#button-proposal').click(function() {
    $('#propose_freeform_form').show('medium');
    $(this).addClass('clicked');
  });
  $('#button-member-invite').click(function() {
    $('#propose_new_member_form').show('medium');
    $(this).addClass('clicked');
  })
  $('#button-constitution-change').click(function() {
    $(location).attr('href','/settings');
  });
  
  // Setup a new org: autofill subdomain while typing org name
  $('body.setup input#organisation_name').keyup(function() {
    var text = $('input#organisation_name').val();
    text = text.toLowerCase();
    text = text.replace(/ /g,'');
    $('input#organisation_subdomain').val(text);
  });
});