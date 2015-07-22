/* 
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

// TODO:  Add ajax function to load pictures based on properties object.

function bindClickToArtifactItem () {
    $('.artifact-item').click(function(){
        //   console.log(this);
        window.location.href = $($(this)).find("a.artifact-detail-link").attr('href');

    //   $(this).find("a.artifact-detail-link").click();
    });
}


$(document).ready(function(){
   
    bindClickToArtifactItem();
        
    if ($("#admin-active").text() == "true") {
        setUpOrderChange();
    }
});

//
// Admin editor 
//

function orderUpdate(event, ui)
{
    alert("order changed!");
    console.log(event);
    console.log(ui);
}

function setUpOrderChange() {
    //    $( "#artifact-block" ).sortable({ 
    //        handle: "#edit-artifact" , 
    //        stop: function( event, ui ) {
    //            orderUpdate(event,ui);
    //        }
    //    });
    var currentPage = $("#page_number").text();
   
    $('#artifact-block').sortable({
        dropOnEmpty: false,
        items: 'div.artifact-item',
        handle: '.handle',
        cursor: 'crosshair',
        opacity: 0.4,
        scroll: true,
        update: function(){
            $.ajax({
                type: 'post',
                data: $('#artifact-block').sortable('serialize') + "&   page=" + currentPage,
                dataType: 'script',
                complete: function(request){
                    $('#artifact-block').effect('highlight');
                },
                url: '/artifacts/sort'
            })
        }
    });
}

