$(document).ready(function () {
  $('#share_application_amount').observe_field(0.5, function()
  {
    var newShareApplicationAmount = parseInt(this.value);
    if (isNaN(newShareApplicationAmount)) {
      $('p.share_payment').hide();
    } else {
      $('p.share_payment').show();
      $('p.share_payment span').text(newShareApplicationAmount);
    }
  });
});
