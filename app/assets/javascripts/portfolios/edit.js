var artifactsTable;

var artifacts_id = "";
var artifacts_list_row = "";

var tinyMCE_editor_portfolio = "";

var portfolios_edit_callDocumentReady_called = false;

$(document).ready(function () {
    if (!portfolios_edit_callDocumentReady_called)
    {
        portfolios_edit_callDocumentReady_called = true;
        if ($("#as_window").text() == "true")
        {
            //  alert("it is a window");
        }
        else
        {
            portfolios_edit_callDocumentReady();
        }
    }
});

function portfolios_edit_callDocumentReady() {

    var toggleLoading = function () {
        $("#loader").toggle()
    };

    $("#portfolio-tabs").tabs({
        activate: function (event, ui) {
//            if ($(ui.newTab[0]).find('a').text() == "Live Preview")
//            {
//                console.log("updated!")
//                $('iframe.preview').each(function () {
//                    this.contentWindow.location.reload(true)
//                });
//            }

        }
    });

    setupCheckboxes(".department-check");
    setupCheckboxes(".category-check");

    bindImageChage();
    bindPortfolioDetailNew();
    buildartifactsListTable();

    bindDivDepartmentUpdate();

    $(".combobox").combobox();
    $(".best_in_place").best_in_place();
    ui_ajax_select();
    $("a.button-link").button();

    init_tinyMCE_portfolio();
    set_up_save_callback();


}

function init_tinyMCE_portfolio() {
    if ((typeof tinyMCE.activeEditor == "undefined") || (tinyMCE.activeEditor == null)){
            tinyMCE_editor_portfolio = tinyMCE.init(tinymce_config_portfolio);
    }
//    else {
//        if (tinyMCE.activeEditor.id == "portfolio_description")
//        {
//        }
//        else
//        {
//            tinyMCE_editor_portfolio = tinyMCE.init(tinymce_config_portfolio);
//
//        }
//    }
}

var toggleLoading = function () {
    $("#loader_progress").toggle()
};
var toggleAddButton = function () {
    $("#upload-form").toggle()
};



function wait(msecs)
{
    var start = new Date().getTime();
    var cur = start
    while (cur - start < msecs)
    {
        cur = new Date().getTime();
    }
}
function buildartifactsListTable() {
    var portfolio_id = $("div#edit-portfolio-dialog div#portfolio-id").text();

    if  (portfolio_id == "") {
            var portfolio_id = $("div#portfolio-id").text();
    }
    artifactsTable = $('#artifacts-table').dataTable({
        "bProcessing": true,
        "bServerSide": true,
        "sAjaxSource": "/artifacts/artifacts_table" + "?" + "portfolio_id=" + portfolio_id,
        "fnRowCallback": function (nRow, aData, iDisplayIndex, iDisplayIndexFull) {
            $(nRow).addClass('artifact-row');
            // $(nRow).addClass('gradeA');

            return nRow;
        },
        "aoColumns":
                [
                    {
                        "sWidth": "40px"
                    },
                    {
                        "sWidth": "250px"
                    },
                    {
                        "sWidth": ""
                    },
                    {
                        "sWidth": "10px"
                    }
                ]
        ,
        "fnDrawCallback": function () {
            $(".best_in_place ").best_in_place();
            $(".combobox").combobox();
            bindDeleteArtifact();
            require("artifacts/shared.js");
            requireCss("artifacts.css")
            artifacteditClickBinding("tr.artifact-row");

            //bindClicktoPortfolioTableRow();
        }
    });

    // $("#artifacts-table").css("width","100%")

}

//function setUpPurrNotifier(headline, message)
//{
//    var notice = '<div class="notice">'
//    + '<div class="notice-body">'
//    + '<img src="/images/interface/info.png" />'
//    + '<h3>' + headline + '</h3>'
//    + '<p>' + message + '</p>'
//    + '</div>'
//    + '<div class="notice-bottom">'
//    + '</div>'
//    + '</div>';
//
//    $( notice ).purr();
//    alert("testing");
//};

function buildartifactsListTableOLD()
{
    artifactsTable = $('#artifacts-table').dataTable({
        "aLengthMenu": [[-1, 10, 25, 50], ["All", 10, 25, 50]],
        "fnDrawCallback": function () {
            $(".best_in_place ").best_in_place();
            $(".combobox").combobox();
            bindChangeColor();

        }
    });

}

$.extend({
    getUrlVars: function () {
        var vars = [], hash;
        var hashes = window.location.href.slice(window.location.href.indexOf('?') + 1).split('&');
        for (var i = 0; i < hashes.length; i++)
        {
            hash = hashes[i].split('=');
            vars.push(hash[0]);
            vars[hash[0]] = hash[1];
        }
        return vars;
    },
    getUrlVar: function (name) {
        return $.getUrlVars()[name];
    }
});


function bindImageChage() {

    //
    //
    // image class bindings
    //

    $('input#image').bind("change", function () {
        //alert("changed");
        toggleLoading();
        toggleAddButton();
        $(this).closest("form").trigger("submit");
        $(".imageSingle .best_in_place").best_in_place();
        disableSelectOptionsSeperators();

    });

}

function updateBestinplaceImageTitles() {
    $(".imageSingle .best_in_place").best_in_place();

}

function refreshPortfolioDetails() {
    artifactsTable.fnDraw(true);
    $("#loader_progress").hide();

//    var $portfolio_id = $("#portfolio-id").text();
//    $("#loader_progress").hide();
//
//    $.post('/portfolios/show_detail/' + $portfolio_id, function(data)
//    {
//        $('#artifacts').html(data);
//        $("#loader_progress").hide();
//        buildartifactsListTable();
//        $(".details-row .best_in_place").best_in_place();
//        $(".combobox").combobox();
//
//    });

}

function bindPortfolioDetailNew()
{
    $('#new-artifact-item').bind('ajax:success', function (xhr, data, status) {
        refreshPortfolioDetails();

    }).bind('ajax:beforeSend', function (e, xhr, settings) {
        xhr.setRequestHeader('accept', '*/*;q=0.5, text/html, ' + settings.accepts.html);
        $("#loader_progress").show();

    });

    $('#duplicate-artifacts').bind('ajax:success', function (xhr, data, status) {
        refreshPortfolioDetails();

    }).bind('ajax:beforeSend', function (e, xhr, settings) {
        xhr.setRequestHeader('accept', '*/*;q=0.5, text/html, ' + settings.accepts.html);
        $("#loader_progress").show();

    });


    $('#delete-artifacts').bind('ajax:success', function (xhr, data, status) {
        $("#loader_progress").show();
        theTarget = this.parentNode.parentNode;
        var aPos = artifactsTable.fnGetPosition(theTarget);
        artifactsTable.fnDeleteRow(aPos);
        $("#loader_progress").hide();
    });


}
;

function bindBlurToDepartmentPopup() {

    $('#portfolio_department_id').change(function () {

        var $portfolio_id = $("#portfolio-id").text();
        // $("#portfolio_department_id").val()
        setTimeout(function () {

            $.post('/portfolios/render_category_div?id=' + $portfolio_id, function (data)
            {
                $('#category-div').html(data);
                $("#loader_progress").hide();
                //bindBlurToDepartmentPopup();
            });
        }, 100);
        //alert('Handler for .blur() called.');
    });
    $('.department-check').change(function () {

        var $portfolio_id = $("#portfolio-id").text();
        // $("#portfolio_department_id").val()
        setTimeout(function () {

            $.post('/portfolios/render_category_div?id=' + $portfolio_id, function (data)
            {
                $('#category-div').html(data);
                $("#loader_progress").hide();
                //bindBlurToDepartmentPopup();
            });
        }, 100);
        //alert('Handler for .blur() called.');
    });
}

function updateImages() {

    //  alert("color changed");
    var $portfolio_id = $("#portfolio-id").text();
    $("#loader_progress").show();

    $.post('/portfolios/render_image_section/' + $portfolio_id, function (data)
    {
        $('.imagesection').html(data);
        $("#loader_progress").hide();
        styleizefilebutton();
        bindImageChage();
        disableSelectOptionsSeperators();

    });

}


function BestInPlaceCallBack(input) {
    //    if(input.data.indexOf("artifacts[color]") != -1)
    if (input.attributeName.indexOf("color") != -1)
    {
        //  alert("color changed");
        var $portfolio_id = $("#portfolio-id").text();
        $("#loader_progress").show();

        $.post('/portfolios/render_image_section/' + $portfolio_id, function (data)
        {
            $('.imagesection').html(data);
            $("#loader_progress").hide();
            styleizefilebutton();
            bindImageChage();

        });
    }
}
;




function myportfoliosave() {
    console.log("trigger save");
    tinymce.triggerSave();
    // $("#page-body-save").closest("form").trigger("submit");
    $("#portfolio_description").parent().parent().closest("form").trigger("submit");
}

function set_up_save_callback() {

    $("form.edit_portfolio")
            .on("ajax:success", function (event, data, status, xhr) {
                //   console.log(event);
                //   console.log(data["notice"]);
                //  console.log(status);
                //   console.log(xhr);
                setUpPurrNotifier("Attention", data["notice"]);
                $('iframe.preview').attr("src", $('iframe.preview').attr("src"));

            });
}

//function ajaxSave()
//{
//    
//    tinyMCE.triggerSave();
//
//    $("#portfolio_description_save").closest("form").trigger("submit");
//
//}

function bindChangeColor() {

    $('.combobox').change(function () {
        var $detail_id = $(this).parent().parent().find("#detail-id").text();
        var value = $(this).val();
        console.log($detail_id);
        "/portfolios/update_ajax/1?field=color&pointer_class=PortfolioDetail"
        $.ajax({
            url: '/portfolios/update_ajax/' + $detail_id,
            data: 'field=color&pointer_class=PortfolioDetail&color=' + value,
            success: function (data) {
                $(this).html(data);
                updateImages();

            }
        })
    });
}


function test() {
    $('#details_color').bind("change", function () {
        $("#loader_progress").show();

        wait(5000);
        updateImages();
        alert("images updated");
        //alert("changed");

    }).bind('ajax:success', function (xhr, data, status) {
        alert("changed");

    });

}




function bindDivDepartmentUpdate() {
    $('.div-department form').bind('ajax:beforeSend', function () {
        // show spinner
        // alert("ajax:before");  
    }).bind('ajax:success', function () {
        updateCategoryDiv();
        //alert("ajax:success");  
    }).bind('ajax:failure', function () {
        //  alert("ajax:failure");    
    }).bind('ajax:complete', function () {
        //hide spinner
        // alert("ajax:complete");  

    });

}

function updateCategoryDiv() {


    var $portfolio_id = $("#portfolio-id").text();
    // $("#portfolio_department_id").val()

    $.post('/portfolios/render_category_div?id=' + $portfolio_id, function (data)
    {
        $('#category-div').html(data);
        $("#loader_progress").hide();
        // setupCheckboxes(".category-check");
    });
}

//function artifacteditClickBinding(selector) {
//   // selectors .edit-artifact-item, tr.artifact-row 
//   
//    $(selector).unbind("click").one("click",function(){
//        
//        console.log($(this).find('#artifact-id').text());
//        var artifact_id = $(this).find('#artifact-id').text();
//        var is_iframe = $("application-space").length > 0
//        
//        var url='/artifacts/'+artifact_id+'/edit/?request_type=window&window_type=iframe';
//        $(this).effect( "highlight", {color:"#669966"},1000 );
//        if (is_iframe) {
//                        $('iframe#artifacts-app-id',window.parent.document).attr("src",url);
//                        artifacteditClickBinding(this);
//        }
//        else
//            {
//                window.location = url;
//
//            }
//
//    });
//}

function bindDeleteArtifact() {
    $(".delete-artifact-item").on("click", function (e) {

        // console.log($(this).parent().parent().parent().find('#artifact-id').text());
        var artifact_id = $(this).parent().parent().parent().find('#artifact-id').text();
        deleteArtifact(artifact_id);
        return false;
    });
}

function deleteArtifact(artifact_id)
{
    var answer = confirm('Are you sure you want to delete this?')
    if (answer) {
        $.ajax({
            url: '/artifacts/delete_ajax?id=' + artifact_id,
            success: function (data)
            {
                setUpPurrNotifier("Notice", "Item Successfully Deleted.");
                artifactsTable.fnDraw();

            }
        });

    }
}

function tinyMcePostInit(inst) {
    portfolios_bind_file_paste_to_upload_form();
}

function portfolios_bind_file_paste_to_upload_form()
{
    $("form#picture-paste-portfolio").fileupload({
        dataType: "json",
        pasteZone: $("iframe#portfolio_description_ifr").contents().find("body"),
        add: function (e, data) {
            file = data.files[0];
            data.context = $(tmpl("template-upload", file));
            // $("div.progress").progressbar();
            // $('#pictures').append(data.context);
            var jqXHR = data.submit()
                    .success(function (result, statusText, jqXHR) {

                        //   console.log("------ - fileupload: Success - -------");
                        //  console.log(result);
                        //   console.log(statusText);
                        //   console.log(jqXHR);

                        //  console.log(JSON.stringify(jqXHR.responseJSON["attachment"]));

                        //  console.log(typeof (jqXHR.responseText));


// specifically for IE8. 
                        if (typeof (jqXHR.responseText) == "undefined") {
                            top.tinymce.activeEditor.undoManager.undo();
                            setUpPurrNotifier("info.png", "Notice", jqXHR.responseJSON["attachment"][0]);
                            data.context.remove();
                        }
                        else
                        {
                            top.tinymce.activeEditor.undoManager.undo();
                            //  console.log(result.image.url)
                            image_tag = "<img src='" + result.image.url + "'/>"
                            top.tinymce.activeEditor.insertContent(image_tag);
                            console.log("success");
                            //  render_pictures();
                        }

                    })
                    .error(function (jqXHR, statusText, errorThrown) {
                        // console.log("------ - fileupload: Error - -------");
                        // console.log(jqXHR.status);
                        // console.log(statusText);
                        // console.log(errorThrown);
                        // console.log(jqXHR.responseText);
                        if (jqXHR.status == "200")
                        {
                            //render_pictures();
                        }
                        else
                        {
                            //var obj = jQuery.parseJSON(jqXHR.responseText);
                            // console.log(typeof obj["attachment"][0])
                            //setUpPurrNotifier("info.png", "Notice", obj["attachment"][0]);
                            // data.context.remove();
                        }
//                        if (jqXHR.statusText == "success") {
//                            render_pictures();
//                            // It succeeded and we need to update the file list.
//                        }
//                        else {
//                            var obj = jQuery.parseJSON(jqXHR.responseText);
//                            setUpPurrNotifier("info.png", "Notice", obj["attachment"][0]);
//                            data.context.remove();
//                        }

                    })
                    .complete(function (result, textStatus, jqXHR) {
                        // console.log("------ - fileupload: Complete - -------");
                        // console.log(result);
                        // console.log(textStatus);
                        // console.log(jqXHR);
                    });
        },
        progress: function (e, data) {
            if (data.context)
            {
                // progress = parseInt(data.loaded / data.total * 100, 10);
                //data.context.find('.bar').css('width', progress + '%');
            }
        },
        done: function (e, data) {
            // console.log(e);
            // console.log(data);
            //data.context.text('');
        }
    }).bind('fileuploaddone', function (e, data) {
        // console.log(e);
        // console.log(data);
        // data.context.remove();
        //data.context.text('');
    }).bind('fileuploadpaste', function (e, data) {
        /* ... */
        image_tag = "<img src='/assets/interface/ajax-loader-big.gif'/>"
        top.tinymce.activeEditor.undoManager.add();
        top.tinymce.activeEditor.insertContent(image_tag);
        top.tinymce.activeEditor.undoManager.add();

        // assets/interface/ajax-loader.gif
        console.log("paste event.")


    })
}

$(document).off('focusin').on('focusin', function (e) {
    if ($(event.target).closest(".mce-window").length) {
        e.stopImmediatePropagation();
        console.log("worked!");
    }
});
