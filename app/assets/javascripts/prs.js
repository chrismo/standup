$( document ).ready(function() {

  new ClipboardJS('#copy-standup', {
    text: function(trigger) {
      // strip more than two spaces from the JS & strip leading and trailing whitespace
      // plus remove empty lines
      return $.trim($(".daily-standup").text().replace(/ {2,}/g, "")).replace(/\n+/g, "\n");
    }
  });

});
