var lastFocused

function apply(e) {
  const formData = $("#messages-form").serializeJSON();
  $.ajax({
      type: 'POST',
      url: '/',
      data: JSON.stringify(formData),
      success: function(data) { console.log("OK") },
      contentType: "application/json",
      dataType: 'json'
  });
  e.preventDefault();
}

function reset(e) {
  $.ajax({
      type: 'POST',
      url: '/reset',
      data: "",
      success: function(data) { console.log("OK") },
      contentType: "application/json",
      dataType: 'json'
  });
  e.preventDefault();
}

function deleteMessage(e) {
  e.preventDefault();
}

function insertCharacter(text) {
  var input = lastFocused;
  console.log(text);
  console.log(input);
  if (input == undefined) { return; }
  var scrollPos = input.scrollTop;
  var pos = 0;
  var browser = ((input.selectionStart || input.selectionStart == "0") ? 
    "ff" : (document.selection ? "ie" : false ) );
  if (browser == "ie") { 
    input.focus();
    var range = document.selection.createRange();
    range.moveStart ("character", -input.value.length);
    pos = range.text.length;
  }
  else if (browser == "ff") { pos = input.selectionStart };

  var front = (input.value).substring(0, pos);  
  var back = (input.value).substring(pos, input.value.length); 
  input.value = front+text+back;
  pos = pos + text.length;
  if (browser == "ie") { 
    input.focus();
    var range = document.selection.createRange();
    range.moveStart ("character", -input.value.length);
    range.moveStart ("character", pos);
    range.moveEnd ("character", 0);
    range.select();
  }
  else if (browser == "ff") {
    input.selectionStart = pos;
    input.selectionEnd = pos;
    input.focus();
  }
  input.scrollTop = scrollPos;
}

function trackMessageInput(e) {
  lastFocused = document.activeElement;
}



$(function() {
  $("#apply-button").click(apply)
  $("#reset-button").click(reset)
  $(".delete-button").click(deleteMessage)
  $(".message-input").focus(trackMessageInput)
  $(".character-button").click(function(e) {
    insertCharacter($(this).data('character'))
    e.preventDefault();
  })
  
})
