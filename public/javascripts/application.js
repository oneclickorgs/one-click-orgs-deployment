/*global $ */

var OneClickOrgs = {};

OneClickOrgs.activateLightbox = function (completionCallback) {
  $('#lightbox_screen').fadeIn();
  $('#lightbox').css('top', 100).animate(
    {top: 50, opacity: 'show'},
    {
      queue: false,
      complete: function () {
        $.scrollTo('#lightbox', 'medium');
        if (completionCallback) {
          completionCallback.call();
        }
      }
    }
  );
}
OneClickOrgs.dismissLightbox = function () {
  $('#lightbox_screen').fadeOut();
  $('#lightbox').animate(
    {top: 100, opacity: 'hide'},
    {queue: false}
  );
}

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

  // Forms at the top of the Dashboard
  // (If JavaScript is disabled, they all show by default)
  $('.form-to-hide').hide();
  $('.button-form-show').show();
  // Reset when any button is clicked
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
  
  // Notifications
  if ($('#lightbox div.notification').length > 0) {
    OneClickOrgs.activateLightbox();
  }
  
  $('#lightbox div.notification button#close_notification').click(function ()
  {
    OneClickOrgs.dismissLightbox();
  });
});
