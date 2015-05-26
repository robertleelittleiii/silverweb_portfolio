/* 
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

// TODO:  Add ajax function to load pictures based on properties object.



$(document).ready(function(){
    
    if ($("#admin-active").text() == "true") {
        // alert("Admin Active");
        setUpOrderChange();
    }
});

//
// Admin editor 
//


function setUpOrderChange() {
    //    $( "#portfolio-block" ).sortable({ 
    //        handle: "#edit-portfolio" , 
    //        stop: function( event, ui ) {
    //            orderUpdate(event,ui);
    //        }
    //    });
    var currentPage = $("#page_number").text();
   
    $('#portfolio-artifacts').sortable({
        dropOnEmpty: false,
        items: 'div.portfolio-artifact',
        handle: '.handle',
        cursor: 'crosshair',
        opacity: 0.4,
        scroll: true,
        update: function(){
            $.ajax({
                type: 'post',
                data: $('#portfolio-artifacts').sortable('serialize') + "&   page=" + currentPage,
                dataType: 'script',
                complete: function(request){
                    $('#portfolio-artifacts').effect('highlight');
                },
                url: '/artifacts/sort'
            })
        }
    });
}

