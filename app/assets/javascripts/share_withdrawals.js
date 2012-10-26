$(document).ready(function () {
  $('#share_withdrawal_amount').observe_field(0.5, function ()
  {
    var amount = parseInt($(this).val(), 10);
    if (amount > OneClickOrgs.maximum_share_withdrawal) {
      $('#terminate_membership').show();
    } else {
      $('#terminate_membership').hide();
    }
  });
});
