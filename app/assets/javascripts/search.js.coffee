# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/
$ ->
	moreResults = (num) -> 
    $("#more").click (e) ->
    	
      page = $(this).val()
      num = parseInt(page)+num
      make = $(this).attr "data-make"
      state = $(this).attr "data-state"
      price1 = $(this).attr "data-min"
      price2 = $(this).attr "data-max"
      that = $(this)
      $(this).replaceWith('<div class="progress progress-info"><div class="bar" data-value='+num+' style="width: 0%"></div></div>')
      complete = $(".progress").width()
      progress = setInterval(->
          $bar = $(".bar[data-value='"+num+"']")
          if $bar.width() is complete
            clearInterval progress
            $(".progress").removeClass "active"
          else
            $bar.width $bar.width() + (complete/10)
          $bar.text $bar.width() / (complete/100) + "%"
        , 900)
      $.get "/search/result",
        page: page
        make: make
        state: state
        price1: price1
        price2: price2
      , (data) ->
      	
        clearInterval progress
        $('.bar').width "100%"
        $('.progress').removeClass "progress-info"
        $('.progress').addClass "progress-success"
        $('.bar').text("")
        $("#resultados").append(data).fadeIn 1000 
        $("#more").val parseInt(page) + 1
        moreResults(num)
        
        
      
  
  $("form").submit ->
  	
    $("#resultados .well").remove()
    $("#resultados").children().not(".loading").remove()
    $(".loading").fadeIn()
    data = $(this).serialize()
    $.get "/search/result", data, (data) ->
    	
      $(".loading").hide()
      $("#resultados").append(data).fadeIn 1000 
      moreResults(0)

    false
    
      
  $("#price1").change ->
  
    value = accounting.formatMoney($(this).val())
    $("#price1_tag").text value
    
    