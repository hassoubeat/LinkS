// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, or any plugin's
// vendor/assets/javascripts directory can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file. JavaScript code in this file should be added after the last require_* statement.
//
// Read Sprockets README (https://github.com/rails/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require activestorage
//= require wow.js
//= require animsition.min.js

// 改行以外のHTMLタグを無効化するXSS対策
function antiXSS(str){
  str = $('<dummy>').text(str).html().replace(/\\r\\n|\\r|\\n/g, '<br>');
  return str;
}

// トースターメッセージの表示
function viewToaster(message, view_ms, message_type) {
  background_color = "#B8DCEF";
  if (message_type == "error") {
    background_color = "#F6CECE";
  }
  $.toast({
    text : message,
    showHideTransition : 'slide',
    bgColor : background_color,
    textColor : "#797F82",
    hideAfter: view_ms,
    position: 'top-right',
    stack : 5,
    textAlign : 'left',
    position : 'bottom-right'
  });
}