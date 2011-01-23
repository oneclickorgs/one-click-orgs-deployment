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
});

var OneClickOrgs = {};

OneClickOrgs.activateLightbox = function () {
  $('#lightbox_screen').fadeIn();
  $('#lightbox').css('top', 100).css('opacity', 0.0).fadeIn().animate({top: 50, opacity: 1.0}, {queue: false});
  $.scrollTo('#lightbox', 'medium');
}
OneClickOrgs.dismissLightbox = function () {
  $('#lightbox_screen').fadeOut();
  $('#lightbox').css('top', 50).css('opacity', 1.0).animate({top: 100, opacity: 0.0}, {queue: false});
}
