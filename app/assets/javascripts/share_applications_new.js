$(document).ready(function () {
  $('#share_application_amount').observe_field(0.5, function()
  {
    var newShareApplicationAmount = parseInt(this.value, 10);
    if (isNaN(newShareApplicationAmount)) {
      $('p.share_payment').hide();
      $('p.maximum_shareholding').hide();
    } else {
      if ((newShareApplicationAmount + OneClickOrgs.currentShareholding) > OneClickOrgs.maximumShareholding) {
        $('p.share_payment').hide();
        $('p.maximum_shareholding').show();
        $('form#new_share_application input[type=submit]').attr('disabled', 'disabled')
      } else {
        $('p.share_payment').show();
        $('p.share_payment span').text(newShareApplicationAmount);
        $('p.maximum_shareholding').hide();
        $('form#new_share_application input[type=submit]').removeAttr('disabled');
      }
    }
  });
});
