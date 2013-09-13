# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/
$ ->
  $("form#search2").submit ->
    data = $(this).serialize()
    url = location.protocol + "//" + location.host + "/search/#?" + data
    location.href = url
    false