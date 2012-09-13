/*global $ */

var OneClickOrgs = {};

OneClickOrgs.activateLightbox = function (options) {
  var completionCallback, lightboxSelector;
  if (options && options.complete) {
    completionCallBack = options.complete;
  }
  if (options && options.id) {
    lightboxSelector = '#' + options.id;
  } else {
    lightboxSelector = '#lightbox';
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
};
OneClickOrgs.dismissLightbox = function (options) {
  var lightboxSelector;
  if (options && options.id) {
    lightboxSelector = '#' + options.id;
  } else {
    lightboxSelector = '#lightbox';
  }
  $('#lightbox_screen').fadeOut();
  $(lightboxSelector).animate(
    {top: 100, opacity: 'hide'},
    {queue: false}
  );
};

OneClickOrgs.trackAnalyticsEvent = function (eventName) {
  if (_gaq) {
    _gaq.push(['_trackPageview', '/analytics_events/' + eventName]);
  }
};

$(document).ready(function () {
  // Revealed forms
  // If JavaScript is disabled, they all show by default
  $('.form-to-hide').hide();

  var cancel_button = $('<a class="cancel" href="">Cancel</a>');
  $('.form-to-hide').each(function() {
    var cloned_cancel = cancel_button.clone();
    $(this).find(':submit').after(cloned_cancel);

    // make it slide back up on click
    cloned_cancel.click(function(event) {
      event.preventDefault();
      $(this).closest('.form-to-hide').removeClass('active').slideUp();
    });
  });

  $('.button-form-show').show();

  $('.button-form-show').click(function() {
    var button = $(this);
    var form = $('#' + button.data('formId'));

    if (!form.hasClass('active')) {
      $('.form-to-hide.active').removeClass('active').slideUp();
      form.addClass('active').slideDown('medium');
    } else {
      form.removeClass('active').slideUp();
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

  // Convert Rails date selects into jQuery UI datepicker
  $('select.datepicker[name*="(3i)"]').each(function(index, element)
  {
    element = $(element);

    var originalSelects = [];

    // Collect the three date select elements
    originalSelects.push($(element));
    originalSelects.push($(element).siblings('select.datepicker[name*="(2i)"]'));
    originalSelects.push($(element).siblings('select.datepicker[name*="(1i)"]'));

    originalSelects = $(originalSelects).map(function() {return this.toArray();});

    if (originalSelects.length != 3) {
      return;
    }

    var defaultYear = parseInt($(originalSelects[2]).val(), 10);
    var defaultMonth = parseInt($(originalSelects[1]).val(), 10);
    var defaultDay = parseInt($(originalSelects[0]).val(), 10);

    var defaultDateString = [defaultYear, defaultMonth, defaultDay].join('-');
    var defaultDate = new Date(
      defaultYear,
      defaultMonth - 1, // JS Date object indexes months starting at zero
      defaultDay
    );

    var attributeName = element.attr('name').replace('(3i)', '');
    var altFieldId = element.attr('id').replace('3i', 'altField');
    var datepickerDivId = element.attr('id').replace('3i', 'datepicker');

    var datepickerField = $('<input type="hidden"/>');
    datepickerField.attr('name', attributeName);
    datepickerField.attr('value', defaultDateString);
    datepickerField.attr('id', altFieldId);

    var datepickerDiv = $('<div class="datepicker"/>');
    datepickerDiv.attr('id', datepickerDivId);

    $(originalSelects[2]).after(datepickerField);
    $(originalSelects[2]).after(datepickerDiv);
    datepickerDiv.datepicker({
      altFormat: "yy-mm-dd",
      altField: '#' + altFieldId,
      defaultDate: defaultDate
    });

    originalSelects.hide();
    $.each(originalSelects, function(index, element)
    {
      $(element).attr('disabled', 'disabled');
    });
  });
});