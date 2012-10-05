$('document').ready(function()
{
  // Given a list of links to individual types of proposal,
  // produce a 'select' drop-down which loads in the given URL
  // via AJAX.
  $('ul.resolution_types').each(function(index, resolutionTypeList)
  {
    resolutionTypeList = $(resolutionTypeList);

    // Build a select element with option elements inside,
    // using the contents of the ul.
    var select = $('<select name="resolution_type" id="resolution_type" class="resolution_types"/>');
    resolutionTypeList.children('li').each(function(index, resolutionTypeItem)
    {
      resolutionTypeItem = $(resolutionTypeItem);

      var url = resolutionTypeItem.children('a').first().attr('href');
      var description = resolutionTypeItem.text();

      var option = $('<option/>');

      option.attr('value', url);
      option.text(description);

      select.append(option);
    });

    // Build a container to hold the content we load in
    var container = $('<div id="resolution_sub_form">');

    select.change(function(event)
    {
      var select = $(this);
      select.attr('disabled', 'disabled');

      var url = select.val();
      $.ajax(url,
        {
          dataType: 'script',
          complete: function()
          {
            select.removeAttr('disabled');
          }
        }
      );
    });

    // Add the select element and the container to the DOM
    resolutionTypeList.after(container);
    resolutionTypeList.after(select);

    // Load in the currently-selected form
    $.ajax(select.val(), {dataType: 'script'});

    // Hide the list
    resolutionTypeList.hide();
  });
});
