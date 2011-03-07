$(document).ready(function() {
    // Open external links in a new window or tab
    $('a[rel$="external"]').live('click', function() {
      $(this).attr('target', "_blank");
    });
    $('a[href$=".pdf"]').live('click', function() {
      $(this).attr('target', "_blank");
    });
    // Open all urls that don't belong to our domain in a new window or tab
    $("a[href^='http:']:not([href*='" + window.location.host + "'])").live('click', function() {
      $(this).attr("target", "_blank");
    });

  // Applies placeholder attribute behavior in web browsers that don't support it
  if (!('placeholder' in document.createElement('input'))) {

    $('input[placeholder]').each(function() {
      $(this).data('originalText', $(this).val()).data('placeholder', $(this).attr("placeholder"));

      if (!$(this).data('originalText').length)
        $(this).val($(this).data("placeholder")).addClass('placeholder');
      
      $(this)
      .bind("focus", function () {
        if ($(this).val() === $(this).data('placeholder'))
          $(this).val("").removeClass('placeholder');
      })
      .bind("blur", function () {
        if (!$(this).val().length)
          $(this).val($(this).data('placeholder')).addClass('placeholder');
      })
      .parents("form").bind("submit", function () {
        // Empties the placeholder text at form submit if it hasn't changed
        if ($(this).val() === $(this).data('placeholder')) 
          $(this).val("").removeClass('placeholder');
      });
    });

    // Clear at window reload to avoid it stored in autocomplete
    $(window).bind("unload", function () {
      $('input[placeholder]').each(function(index) {
        if ($(this).val() === $(this).data('placeholder'))
          $(this).val("");
      });
    });
  }
  if (undefined !== window.DD_belatedPNG) {
    DD_belatedPNG.fix('.png');
    DD_belatedPNG.fix('#logo img');
  }
  
  
  $("a[rel=fancybox]").fancybox({
    'width': 800,
    'autoDimensions': false,
    'padding': 5,
    'overlayOpacity': 0.6,
    'overlayColor': '#000000'
  });

});