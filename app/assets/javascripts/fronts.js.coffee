# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/


window.refresh_linkedin_data = (msg) ->
  if confirm msg
    $("#spinner").show()
    window.location.href = $("#refresh_lnk_id").attr('href')



window.callAjaxRequest = (email, ssUrl) ->
  $.ajax {
    type: "GET"
    dataType: 'html'
    data: {email: email}
    url: ssUrl 
    success: (result) ->
      # console.log(res)
  }
  false

add_remove_active_class = (div_param, remove=true) ->
  if remove
    $(div_param).removeClass('active')
  else
    $(div_param).addClass('active')  

  
show_hide_header_link = (div_param, hide=true) ->
  if hide    
    $(div_param).hide()
  else
    $(div_param).show()
    
$(document).ready ->
  
  $("input:text").eq(0).focus()
  
  $('#notice').delay(4000).animate
    height: '0px'
    opacity: 0
    
  $('#error').delay(4000).animate
    height: '0px'
    opacity: 0
    
  $('#subscribe_lnk').click (e) ->
    $("#spinner").show()
    
  $("#invite_btn").click (e) ->
    user_email = $('#user_email').val()
    if !user_email
      alert "Please enter email address"
    else
      $.ajax {
        type: 'GET'
        dataType: 'json'
        data: {email: user_email}
        url: "/is_email_invited"
        success: (res) ->
          if res.result
            if confirm "You already sent your cv to " +user_email+ " on " +res.invited_date+ ". Do you wish to send it again?"
              $("#spinner").show()
              document.forms[0].submit()
          else
            $("#spinner").show()
            document.forms[0].submit()
      }
    false
      
  $("#stepform1, #stepform11").click (e) ->
    show_hide_header_link '#stepcontent2, #stepcontent3, #stepcontent4, #stepcontent5' 
    add_remove_active_class '#stepform2, #stepform3, #stepform4, #stepform5'
    show_hide_header_link '#stepcontent1', false
    add_remove_active_class '#stepform1', false      
        
  $('#stepform2, #stepform22').click (e) ->
    show_hide_header_link  '#stepcontent1, #stepcontent3, #stepcontent4, #stepcontent5'
    add_remove_active_class '#stepform1, #stepform3, #stepform4, #stepform5'
    show_hide_header_link '#stepcontent2', false
    add_remove_active_class '#stepform2', false
          
  $('#stepform3, #stepform33').click (e) ->
    show_hide_header_link '#stepcontent2, #stepcontent1, #stepcontent4, #stepcontent5'
    add_remove_active_class '#stepform2, #stepform1, #stepform4, #stepform5'
    show_hide_header_link '#stepcontent3', false
    add_remove_active_class '#stepform3', false
    
  $('#stepform4, #stepform44, #stepform66').click (e) ->
    show_hide_header_link '#stepcontent2, #stepcontent3, #stepcontent1, #stepcontent5'
    add_remove_active_class '#stepform2, #stepform3, #stepform1, #stepform5'
    show_hide_header_link '#stepcontent4', false
    add_remove_active_class '#stepform4', false
    
  $('#stepform5, #stepform55').click (e) ->
    show_hide_header_link '#stepcontent2, #stepcontent3, #stepcontent1, #stepcontent4'
    add_remove_active_class '#stepform2, #stepform3, #stepform1, #stepform4'
    show_hide_header_link '#stepcontent5', false
    add_remove_active_class '#stepform5', false