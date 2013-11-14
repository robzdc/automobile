# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/
$ ->
   #Get model list by make
   $("#make").change ->  
     make_id = $(this).val()
     $.getJSON "/search/getmodels", 
       make_id: make_id
     , (data) ->
       $("#model").children("option:not(:first)").remove()
       $.each data, (key, value) ->
         $("#model").append "<option value='"+value.id+"'>"+value.name+"</option>"
	

     false



$ ->
  $(document).foundation "orbit",
    pause_on_hover: true
    animation: 'fade'
    navigation_arrows: true
    slide_number: false
    bullets: false
    timer_speed: 5000

  $(".orbit-slides-container").mouseout ->
    $(".orbit-timer").click()
