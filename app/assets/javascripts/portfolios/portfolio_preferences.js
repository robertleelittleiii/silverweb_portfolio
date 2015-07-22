/* 
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */

var portfolio_preferences_callDocumentReady_called = false;

$(document).ready(function () {
    if (!portfolio_preferences_callDocumentReady_called)
    {
        portfolio_preferences_callDocumentReady_called = true;
        if ($("#as_window").text() == "true")
        {
            //  alert("it is a window");
        }
        else
        {
            portfolio_preferences_callDocumentReady();
        }
    }
});

function portfolio_preferences_callDocumentReady() {
    $("#portfolio-settings-tabs").tabs();
     $(".best_in_place").best_in_place();
    ui_ajax_select();
    $("a.button-link").button();
    
}

