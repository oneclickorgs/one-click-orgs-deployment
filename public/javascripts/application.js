/*global $ */

var OneClickOrgs = {};

OneClickOrgs.activateLightbox = function (options) {
  var completionCallback, lightboxSelector;
  if (options && options['complete']) {
    completionCallBack = options['complete'];
  }
  if (options && options['id']) {
    lightboxSelector = '#' + options['id'];
  } else {
    lightboxSelector = '#lightbox'
  }
  $('#lightbox_screen').fadeIn();
  $(lightboxSelector).css('top', 100).animate(
    {top: 50, opacity: 'show'},
    {
      queue: false,
      complete: function () {
        $.scrollTo(lightboxSelector, 'medium');
        if (completionCallback) {
          completionCallback.call();
        }
      }
    }
  );
}
OneClickOrgs.dismissLightbox = function (options) {
  var lightboxSelector;
  if (options && options['id']) {
    lightboxSelector = '#' + options['id'];
  } else {
    lightboxSelector = '#lightbox'
  }
  $('#lightbox_screen').fadeOut();
  $(lightboxSelector).animate(
    {top: 100, opacity: 'hide'},
    {queue: false}
  );
}

OneClickOrgs.trackAnalyticsEvent = function (eventName) {
  if (_gaq) {
    _gaq.push(['_trackPageview', '/analytics_events/' + eventName]);
  }
}

$(document).ready(function () {


  // Forms on the Voting & proposals page
  // If JavaScript is disabled, they all show by default
  $('.form-to-hide').hide();

  var cancel_button = $('<span class="cancel">cancel</span>');
  $('.form-to-hide').each(function() {
    var cloned_cancel = cancel_button.clone();
    $(this).find(':submit').after(cloned_cancel);
    
    // make it slide back up on click
    cloned_cancel.click(function() {
    $(this).closest('.form-to-hide').slideUp();
    })
  })


  $('.button-form-show').show();

  $('.button-form-show').click(function() {
    $(this).toggleClass('clicked');
  });
  // this isn't quite behaving how it should:
  // ideally these slideDown() animations only fire after a 
  // slideUp, but putting them in the call back means that these
  // end up being called twice.
  // TODO - fix this fire only at the right time
  //
  $('#button-proposal').click(function() {
      if (!$(this).hasClass('active')) {

        $('.button-form-show').removeClass('active');

        $(this).addClass('active');

        $('.form-to-hide').not( $('.active')).slideUp( function() {
          $('#propose_freeform_form').slideDown('medium');
        });
     
      }
  });
  
  $('.button-form').click(function() {
    window.location.href = $(this).data('url');
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
