/* 
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

var portfolios_index_callDocumentReady_called = false;
var portfolioTableAjax = "";

$(document).ready(function () {
    if (!portfolios_index_callDocumentReady_called)
    {
        portfolios_index_callDocumentReady_called = true;
        if ($("#as_window").text() == "true")
        {
            //  alert("it is a window");
        }
        else
        {
            portfolios_index_callDocumentReady();
        }
    }
});

function portfolios_index_callDocumentReady() {
    requireCss("tables.css");
    require("portfolios/shared.js");
    
  //  Required scripts (loaded for this js file)
    //

    // reatePortfolioDialog();
    //    $("#loader_progress").show();
    //    portfolioTableOld=$('#portfolio-table-old').dataTable({
    //        "aLengthMenu": [[-1, 10, 25, 50], ["All", 10, 25, 50]]
    //    });
    $("#loader_progress").show();

    createPortfolioTable();

    $("#loader_progress").hide();

    //
    //    $('#portfolio-table .portfolio-row').bind('click', function(){
    //        $(this).addClass('row_selected');
    //        portfolioID=$(this).find("#portfolio-id").text().strip();
    //        window.location = "/portfolio/edit/"+portfolioID;
    //    });

    //    $('.delete-portfolio-item').bind('ajax:success', function(xhr, data, status){
    //        $("#loader_progress").show();
    //        theTarget=this.parentNode.parentNode;
    //        var aPos = portfolioTableAjax.fnGetPosition( theTarget );
    //        portfolioTableAjax.fnDeleteRow(aPos);
    //        portfolioTableAjax.fnDraw();
    //        $("#loader_progress").hide();
    //    });

    //    $('.delete-portfolio-item').bind('ajax:error', function(xhr, data, error){
    //        alert("Error:" + JSON.parse(data.responseText)["error"]);
    //        $("#loader_progress").hide();
    //
    //    });

//    $(".edit_portfolio").bind('ajax:success', function (xhr, data, status) {
//        $('#edit-password-dialog').dialog('close');
//    });

    


//    createPasswordDialog();
//    createPortfolioDialog();
    bindNewPortfolio();
    $("a.button-link").button();

}

function deletePortfolio(portfolio_id)
{
    var answer = confirm('Are you sure you want to delete this?')
    if (answer) {
        $.ajax({
            url: '/portfolios/delete_ajax/?id='+ + portfolio_id,
            success: function (data)
            {
                setUpPurrNotifier("Notice", "Item Successfully Deleted.");
                portfolioTableAjax.fnDraw();

            }
        });

    }
}

//function editPortfolio(portfolio_id)
//{
//    var url = '/portfolios/edit/' + portfolio_id + '?request_type=window&window_type=iframe';
//    $('iframe#portfolios-app-id', window.parent.document).attr("src", url);
//}



//function portfolioeditClickBinding(selector) {
//    // selectors .edit-portfolio-item, tr.portfolio-row 
//
//    $(selector).unbind("click").one("click", function () {
//        console.log($(this).find('#portfolio-id').text());
//        var portfolio_id = $(this).find('#portfolio-id').text();
//        var is_iframe = $("application-space").length > 0
//
//        var url = '/portfolios/edit/' + portfolio_id + '?request_type=window&window_type=iframe';
//        $(this).effect("highlight", {color: "#669966"}, 1000);
//        if (is_iframe) {
//            $('iframe#portfolios-app-id', window.parent.document).attr("src", url);
//            portfolioeditClickBinding(this);
//        }
//        else
//        {
//            window.location = url;
//
//        }
//
//    });
//}

function loadPortfolioScreen() {

    portfolio - action - area
}


function createPortfolioDialog() {

    $('#edit-portfolio-dialog').dialog({
        autoOpen: false,
        width: 455,
        height: 625,
        modal: true,
        buttons: {
            "Delete": function () {
                portfolio_id = $(".m-content div#portfolio-id").text().trim();
                if (confirm("Are you sure you want to delete this portfolio?"))

                {
                    $(this).dialog("close");

                    $.ajax({
                        url: '/portfolios/delete_ajax?id=' + portfolio_id,
                        success: function (data)
                        {
                            portfolioTableAjax.fnDraw();
                        }
                    });
                }
                else
                {

                }
            },
            "Ok": function () {
                $(this).dialog("close");
                portfolioTableAjax.fnDraw();
            }
        }

    });
}



function createPortfolioTable() {
    portfolioTableAjax = $('#portfolio-table').dataTable({
        "iDisplayLength": 25,
        "aLengthMenu": [[25, 50, 100], [25, 50, 100]],
        "bStateSave": true,
        "fnStateSave": function (oSettings, oData) {
            localStorage.setItem('DataTables_portfolios_' + window.location.pathname, JSON.stringify(oData));
        },
        "fnStateLoad": function (oSettings) {
            return JSON.parse(localStorage.getItem('DataTables_portfolios_' + window.location.pathname));
        },
        "bProcessing": true,
        "bServerSide": true,
        "aaSorting": [[1, "asc"]],
        "sAjaxSource": "/portfolios/portfolio_table",
        "fnRowCallback": function (nRow, aData, iDisplayIndex, iDisplayIndexFull) {
            $(nRow).addClass('portfolio-row');
            $(nRow).addClass('gradeA');
            return nRow;
        },
        "fnInitComplete": function () {
            // $(".best_in_place").best_in_place(); 

        },
        "fnDrawCallback": function () {
            $(".best_in_place").best_in_place();
            //portfolioeditClickBinding(".edit-portfolio-item");
            portfolioeditClickBinding("tr.portfolio-row");
            bindDeletePortfolio();
        }
    });
}

function bindNewPortfolio() {
    
   $('a#new-portfolio').unbind().bind('ajax:beforeSend', function (e, xhr, settings) {
        xhr.setRequestHeader('accept', '*/*;q=0.5, text/html, ' + settings.accepts.html);
        $("body").css("cursor", "progress");
    }).bind('ajax:success', function (xhr, data, status) {
        $("body").css("cursor", "default");
        portfolioTableAjax.fnDraw();
        setUpPurrNotifier("Notice", "New Portfolio Created!'");
    }).bind('ajax:error', function (evt, xhr, status, error) {
                setUpPurrNotifier("Error", "Portfolio Creation Failed!'");
    }); 

}

//function bindNewPortfolio() {
//    $('a#new-portfolio').bind('ajax:beforeSend', function (evt, xhr, settings) {
//        // alert("ajax:before");  
//        console.log('ajax:before');
//        console.log(evt);
//        console.log(xhr);
//        console.log(settings);
//
//        $("#loader_progress").show();
//
//
//
//    }).bind('ajax:success', function (evt, data, status, xhr) {
//        //  alert("ajax:success"); 
//        console.log('ajax:success');
//        console.log(evt);
//        console.log("date:" + data + ":");
//
//        $("#loader_progress").show();
//        console.log(data.id);
//        editPortfolio(data.id);
//
//        console.log(status);
//        console.log(xhr);
//
//    }).bind('ajax:error', function (evt, xhr, status, error) {
//        // alert("ajax:failure"); 
//        console.log('ajax:error');
//        console.log(evt);
//        console.log(xhr);
//        console.log(status);
//        console.log(error);
//
//        alert("Error:" + JSON.parse(data.responseText)["error"]);
//        $("#loader_progress").hide();
//
//
//    }).bind('ajax:complete', function (evt, xhr, status) {
//        //    alert("ajax:complete");  
//        console.log('ajax:complete');
//        console.log(evt);
//        console.log(xhr);
//        // console.log(status);
//        $("#loader_progress").hide();
//
//
//    });
//
//}

function bindDeletePortfolio() {
    $(".delete-portfolio-item").on("click", function (e) {

        // console.log($(this).parent().parent().parent().find('#portfolio-id').text());
        var portfolio_id = $(this).parent().parent().parent().find('#portfolio-id').text();
        deletePortfolio(portfolio_id);
        return false;
    });
}



// ************************************    
//
// Create Edit Dialog Box
//
// ************************************    

//function createAppDialog(theContent) {
//
//
//    if ($("#app-dialog").length == 0)
//    {
//        var dialogContainer = "<div id='app-dialog'></div>";
//        $("#portfolio").append($(dialogContainer));
//    }
//    else
//    {
//        dialogContainer = $("#app-dialog");
//    }
//    // $('#app-dialog').html(theContent);
//    theContent = '<input type="hidden" autofocus="autofocus" />' + theContent
//    theAppDialog = $('#app-dialog').dialog({
//        autoOpen: false,
//        modal: true,
//        buttons: {
//            "Close": function () {
//                // Do what needs to be done to complete 
//                $(this).dialog("close");
//            }
//        },
//        close: function (event, ui) {
//            $('#app-dialog').html("");
//            $('#app-dialog').dialog("destroy");
//        },
//        open: function (event, ui)
//        {
//            popUpAlertifExists();
//        }
//
//
//    });
//
//    $('#app-dialog').html(theContent);
//
//    theHeight = $('#app-dialog #dialog-height').text() || "500";
//    theWidth = $('#app-dialog #dialog-width').text() || "500";
//    theTitle = $('#app-dialog #dialog-name').text() || "Edit";
//
//    theAppDialog.dialog({
//        title: theTitle,
//        width: theWidth,
//        height: theHeight
//    });
//
//    return(theAppDialog)
//}


