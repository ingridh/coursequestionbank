# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/



@myfunction = $.ajax(url: "/add_problem").done (html) -> $("#problems").append html
