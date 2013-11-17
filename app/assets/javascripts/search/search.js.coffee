# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/
$ ->
  #on click more results
  moreResults(0)
	moreResults = (num) -> 
    $("#more").click (e) ->
    	
      page = $(this).val()
      $(".loading").remove()
      num = parseInt(page)
      make = $(this).attr "data-make"
      model = $(this).attr "data-model"
      state = $(this).attr "data-state"
      price1 = $(this).attr "data-min"
      price2 = $(this).attr "data-max"
      that = $(this)
      $(this).parent().remove()
      $.get "/search/more",
        num: num
        make: make
        model: model
        state: state
        price1: price1
        price2: price2
      , (data) ->
      	
        $("#resultados").append(data).fadeIn 1000 
        $("#more").val parseInt(page) + 1
        moreResults(num)
        
  # on click search /search  
  ###    
  $("form#search").submit ->
  	
    $("#resultados .well").remove()
    $("#resultados").children().not(".loading").remove()
    $(".loading").fadeIn()
    datos = $(this).serialize()
    $.get "/search/result", datos, (data) ->
    	
      location.search = "?" + datos
      $(".loading").hide()
      $("#resultados").append(data).fadeIn 1000 
      moreResults(0)

    false
  
  ### 
  #get parameters from URL
  getParameter = (paramName) ->
    searchString = window.location.hash.substring 2
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
  ###
  make = getParameter("make")
  model = getParameter("model")
  state = getParameter("state")
  price1 = getParameter("price1")
  price2 = getParameter("price2")
  year1 = getParameter("year1")
  year2 = getParameter("year2")
  
  if make? or model? or state? or price1? or price2? or year1? or year2?
    
    $("#resultados").children().not(".loading").remove()
    $(".loading").fadeIn()
    
    $.getJSON "/search/getmodels", make_id: make, (data) ->
    	
      $("#model").children("option:not(:first)").remove()
      $.each data, (key, value) ->
      	$("#model").append "<option value='"+value.id+"'>"+value.name+"</option>"
        
      $("#make option[value='" + make + "']").prop "selected", true
      $("#model option[value='" + model + "']").prop "selected", true
      $("#state option[value='" + state + "']").prop "selected", true
      $("#price1 option[value='" + price1 + "']").prop "selected", true
      $("#price2 option[value='" + price2 + "']").prop "selected", true
      $("#year1 option[value='" + year1 + "']").prop "selected", true
      $("#year2 option[value='" + year2 + "']").prop "selected", true
      
    false
    
    hash = window.location.hash.substring 2
    
    $.get "/search/result", hash, (data) ->
      
      $(".loading").hide()
      $("#resultados").append(data).fadeIn 1000 
      moreResults(0)
    
    false
    
  ###  
	#Get model list by make
	$("#make").change ->
		
    make_id = $(this).val()
    $.getJSON "/search/getmodels", make_id: make_id, (data) ->
    	
      $("#model").children("option:not(:first)").remove()
      $.each data, (key, value) ->
      	$("#model").append "<option value='"+value.id+"'>"+value.name+"</option>"
      
    false
    