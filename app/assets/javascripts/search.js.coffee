# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/
$ ->
  #on click more results
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
      $.get "/search/more",
        num: num
      , (data) ->
      	
        clearInterval progress
        $('.bar').width "100%"
        $('.progress').removeClass "progress-info"
        $('.progress').addClass "progress-success"
        $('.bar').text("")
        $("#resultados").append(data).fadeIn 1000 
        $("#more").val parseInt(page) + 1
        moreResults(num)
        
  # on click search /search      
  $("form#search").submit ->
  	
    $("#resultados .well").remove()
    $("#resultados").children().not(".loading").remove()
    $(".loading").fadeIn()
    data = $(this).serialize()
    $.get "/search/result", data, (data) ->
    	
      $(".loading").hide()
      $("#resultados").append(data).fadeIn 1000 
      moreResults(0)

    false
    
  #get parameters from URL
  getParameter = (paramName) ->
    searchString = window.location.search.substring(1)
    i = undefined
    val = undefined
    params = searchString.split("&")
    i = 0
    while i < params.length
      val = params[i].split("=")
      return unescape(val[1])  if val[0] is paramName
      i++
    null
  
  #on load search send json
  make = getParameter("make")
  model = getParameter("model")
  state = getParameter("state")
  price1 = getParameter("price1")
  price2 = getParameter("price2")
  year1 = getParameter("year1")
  year2 = getParameter("year2")
  
  if make? and model? and state? and price1? and price2? and year1? and year2?
    
    $("#resultados").children().not(".loading").remove()
    $(".loading").fadeIn()
    
    $.get "/search/result", {make: make,model: model,state: state,price1: price1, price2: price2, year1: year1, year2: year2}, (data) ->
    
      $(".loading").hide()
      $("#resultados").append(data).fadeIn 1000 
      moreResults(0)
    
    false
    
    
	#Get model list by make
	$("#make").change ->
		
    make_id = $(this).val()
    $.getJSON "/search/getmodels", make_id: make_id, (data) ->
    	
      $("#model").children("option:not(:first)").remove()
      $.each data, (key, value) ->
      	$("#model").append "<option value='"+value.id+"'>"+value.name+"</option>"
      
      $(document).foundation()  if $(window).width() > 768
    false
    