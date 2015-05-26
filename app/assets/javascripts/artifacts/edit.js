var tinyMCE_editor_artifact = "";
var artifacts_edit_callDocumentReady_called = false;

$(document).ready(function () {
    if (!artifacts_edit_callDocumentReady_called)
    {
        artifacts_edit_callDocumentReady_called = true;
        if ($("#as_window").text() == "true")
        {
            //  alert("it is a window");
        }
        else
        {
            artifacts_edit_callDocumentReady();
        }
    }
});

function artifacts_edit_callDocumentReady() {
    requireCss("image_libraries/image_list.css");
    
   // requireCss("files.css");

$("#artifact-tabs").tabs({
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

    bind_file_upload_to_upload_form();

    bindDivDepartmentUpdate();

    $(".combobox").combobox();
    $(".best_in_place").best_in_place();
    ui_ajax_select();
    $("a.button-link").button();
  
    tinyMCE_editor_artifact = tinyMCE.init(tinymce_config_artifact);
   
    set_up_save_callback();
    bind_download_to_files();
    bindPicturesSort();
    bindDeleteImage();
    
    initialize_edit_button();
    activate_buttons();
    bind_mouseover();
};


var toggleLoading = function () {
    $("#loader_progress").toggle()
};
var toggleAddButton = function () {
    $("#upload-form").toggle()
};

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

function bindBlurToDepartmentPopup() {

    $('#artifact_department_id').change(function () {

        var $artifact_id = $("#artifact-id").text();
        // $("#artifact_department_id").val()
        setTimeout(function () {

            $.post('/artifacts/render_category_div?id=' + $artifact_id, function (data)
            {
                $('#category-div').html(data);
                $("#loader_progress").hide();
                //bindBlurToDepartmentPopup();
            });
        }, 100);
        //alert('Handler for .blur() called.');
    });
    $('.department-check').change(function () {

        var $artifact_id = $("#artifact-id").text();
        // $("#artifact_department_id").val()
        setTimeout(function () {

            $.post('/artifacts/render_category_div?id=' + $artifact_id, function (data)
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
    var $artifact_id = $("#artifact-id").text();
    $("#loader_progress").show();

    $.post('/artifacts/render_image_section/' + $artifact_id, function (data)
    {
        $('.imagesection').html(data);
        $("#loader_progress").hide();
        styleizefilebutton();
        bindImageChage();
        disableSelectOptionsSeperators();

    });

}


function BestInPlaceCallBack(input) {
    //    if(input.data.indexOf("artifact_detail[color]") != -1)
    if (input.attributeName.indexOf("color") != -1)
    {
        //  alert("color changed");
        var $artifact_id = $("#artifact-id").text();
        $("#loader_progress").show();

        $.post('/artifacts/render_image_section/' + $artifact_id, function (data)
        {
            $('.imagesection').html(data);
            $("#loader_progress").hide();
            styleizefilebutton();
            bindImageChage();

        });
    }
}
;

//$(document).ready(function () {
//
//    // var toggleLoading = function() {
//    //     $("#loader").toggle()
//    // };
//
//
//    setupCheckboxes(".department-check");
//    setupCheckboxes(".category-check");
//
//    bindImageChage();
//    //   bindBlurToDepartmentPopup();
//    bindDivDepartmentUpdate();
//    $(".combobox").combobox();
//    bindChangeColor();
//// test();
//});
//

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


    var $artifact_id = $("#artifact-id").text();
    // $("#artifact_department_id").val()

    $.post('/artifacts/render_category_div?id=' + $artifact_id, function (data)
    {
        $('#category-div').html(data);
        $("#loader_progress").hide();
        // setupCheckboxes(".category-check");
    });
}

function bind_file_upload_to_upload_form()
{
    $("form.upload-form").fileupload({
        dataType: "json",
        add: function (e, data) {
            file = data.files[0];
            data.context = $(tmpl("template-upload", file));
            // $("div.progress").progressbar();
            $('#images').append(data.context);
            var jqXHR = data.submit()
                    .success(function (result, statusText, jqXHR) {

                        // console.log("------ - fileupload: Success - -------");
                        // console.log(result);
                        // console.log(statusText);
                        // console.log(jqXHR);

                        // console.log(JSON.stringify(jqXHR.responseJSON["attachment"]));

                        // console.log(typeof(jqXHR.responseText));
// specifically for IE8. 
                        if (typeof (jqXHR.responseText) == "undefined") {
                            setUpPurrNotifier("info.png", "Notice", jqXHR.responseJSON["attachment"][0]);
                            data.context.remove();
                        }
                        else
                        {
                            render_picture(result.id);
                        }

                    })
                    .error(function (jqXHR, statusText, errorThrown) {
                        console.log("------ - fileupload: Error - -------");
                        console.log(jqXHR.status);
                        console.log(statusText);
                        console.log(errorThrown);
                        console.log(jqXHR.responseText);
                        if (jqXHR.status == "200")
                        {
                            render_picture(result.id);
                        }
                        else
                        {
                            var obj = jQuery.parseJSON(jqXHR.responseText);
                            // console.log(typeof obj["attachment"][0])
                            setUpPurrNotifier("info.png", "Notice", obj["attachment"][0]);
                            data.context.remove();
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
                progress = parseInt(data.loaded / data.total * 100, 10);
                data.context.find('.bar').css('width', progress + '%');
            }
        },
        done: function (e, data) {
            // console.log(e);
            // console.log(data);
            data.context.text('');
        }
    }).bind('fileuploaddone', function (e, data) {
        // console.log(e);
        // console.log(data);
        data.context.remove();
        //data.context.text('');
    });
}

function bind_download_to_files()
{
    $("div.file-item div#logo-links").unbind("click");
    $("div.file-item div#logo-links").bind("click",
            function () {
                var href = $($(this)[0]).find('a').attr('href');
                window.location.href = href
            });
}

function render_pictures(artifact_id) {
    $.ajax({
        dataType: "html",
        url: '/pictures/render_pictures',
        cache: false,
        data: "class_name=artifact&id=" + artifact_id,
        success: function (data)
        {
            $("div#images").html(data).hide().fadeIn();

            max_images = $('#max-images').text();

            if (max_images.length > 0)
            {
                total_images = $("div.file-list-item").size();
                if (total_images >= max_images) {
                    $("div#imagebutton").fadeOut();
                }

            }
            bind_file_upload_to_upload_form();


        }
    });

}

function render_picture(picture_id) {
    $.ajax({
        dataType: "html",
        url: '/pictures/render_picture',
        cache: false,
        data: "class_name=artifact&id=" + picture_id,
        success: function (data)
        {
            $("div#images").append(data).hide().fadeIn();

            max_images = $('#max-images').text();

            if (max_images.length > 0)
            {
                total_images = $("div.file-list-item").size();
                if (total_images >= max_images) {
                    $("div#imagebutton").fadeOut();
                }

            }
            
            bind_file_upload_to_upload_form();
            bindDeleteImage();
            bind_mouseover();
            activate_buttons();
            initialize_edit_button();
            

        }
    });

}

function myartifactsave() {
    console.log("trigger save");
    tinymce.triggerSave();
    // $("#page-body-save").closest("form").trigger("submit");
    $("#artifact_description").parent().parent().closest("form").trigger("submit");
}

function set_up_save_callback() {

    $("form.edit_artifact")
            .on("ajax:success", function (event, data, status, xhr) {
                //   console.log(event);
                //   console.log(data["notice"]);
                //  console.log(status);
                //   console.log(xhr);
                setUpPurrNotifier("Attention", data["notice"]);
                $('iframe.preview').attr("src", $('iframe.preview').attr("src"));

            });
}

$(document).off('focusin').on('focusin', function (e) {
    if ($(event.target).closest(".mce-window").length) {
        e.stopImmediatePropagation();
        console.log("worked!");
    }
});

// binds the download attachment link for each attached file.

function bind_download_to_files()
{
    $("div.file-item div#logo-links").unbind("click");
    $("div.file-item div#logo-links").bind("click",
            function () {
                var href = $($(this)[0]).find('a').attr('href');
                window.location.href = href
            });
}
function bindPicturesSort() {
    
    
    $('div#images').sortable({
    dropOnEmpty: false,
    handle: 'div.file-item',
    cursor: '-webkit-grabbing',
    items: 'div.file-list-item',
    opacity: 0.4,
    scroll: true,
    tolerance: "pointer",
    update: function(){
        console.log($(this));
      $.ajax({
        url: '/artifacts/update_image_order',
        type: 'post',
        data: $(this).sortable('serialize'),
        dataType: 'json',
        complete: function(request){
        }
      });
    }
  });
  
  
//$("div#images").sortable({
//    //handle : '.handle',
//    update : function () {
//        var order = $(this).sortable('serialize');
//        var table = $(this).parent().attr('id');
//        console.log(order);
//        $.ajax ({
//            type: "POST",
//            url: "/artifacts/update_image_order",
//            data: "album=" + order + "&sort=1&sort_table=" + table,
//            dataType: "json",
//            cache: false,
//            success: function(data)
//            {
//                console.log(data);
//            }
//        });
//    }
//});
}

function tinyMcePostInit(inst) {
    artifacts_bind_file_paste_to_upload_form();
}

function artifacts_bind_file_paste_to_upload_form()
{
    $("form#picture-paste-artifact").fileupload({
        dataType: "json",
        pasteZone: $("iframe#artifact_description_ifr").contents().find("body"),
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

function bindDeleteImage() {
    $('a.picture-delete').unbind().bind('ajax:beforeSend', function () {
         // alert("ajax:before");  
    }).bind('ajax:success', function () {
        console.log($(this).parent().parent());
       $(this).parent().parent().remove();
       //  alert("ajax:success");  
    }).bind('ajax:failure', function () {
      //    alert("ajax:failure");    
    }).bind('ajax:complete', function () {
      //   alert("ajax:complete"); 
    });

}


//  Picture management routines

function initialize_edit_button()
        {
            $("a.edit-picture-artifact").unbind()
                    .bind("ajax:beforeSend", function(evt, xhr, settings) {
                 //alert("ajax:beforeSend");
            })
                    .bind("ajax:success", function(evt, data, status, xhr) {
                // alert("ajax:success");
                edit_picture_dialog(data);
            })
                    .bind('ajax:complete', function(evt, xhr, status) {
                 //alert("ajax:complete");
            })
                    .bind("ajax:error", function(evt, xhr, status, error) {
                //  alert("ajax:error");

                var $form = $(this),
                        errors,
                        errorText;

                try {
                    // Populate errorText with the comment errors
                    console.log(xhr);
                    console.log(status);
                    console.log(error);
                    
                    errors = $.parseJSON(xhr.responseText);
                    console.log(errors);
                    
                } catch (err) {
                    // If the responseText is not valid JSON (like if a 500 exception was thrown), populate errors with a generic error message.
                    errors = {
                        message: "Please reload the page and try again"
                    };
                }
                var errorText;
                // Build an unordered list from the list of errors
                errorText = "<ul>";

                for (error in errors) {
                    console.log(error);
                    console.log(errors[error][0]);
                    errorText += "<li>" + error + ': ' + errors[error][0] + "</li> ";
                    console.log(errorText);
                }

                errorText += "</ul>";
                    console.log(errorText);

                // Insert error list into form
                setUpNotifier("error.png", "Warning", errorText);
            });

        }
        
        
        
        function edit_picture_dialog(data) {

    // alert("ajax:success");
        picture_edit_dialog = createAppDialog(data, "edit-picture", {}, "");
        
        picture_edit_dialog.dialog({
                    close: function (event, ui) {
                      picture_id = $("div#picture-id").text().trim();
                      value =   $("select#picture_title").val();
                      $("div#picture_" + picture_id + " div.picture-info").text(value);
                    }
                });

    //initialize_save_button();
    //$('.datepicker').datepicker();
    //tiny_mce_initializer();
    //bind_org_select();
    //bind_membership_select();
    //bind_grade_select();
    //bind_flags_select();

    //bind_grade_all_select();

    //bind_grade_filter_display();
    //bind_membership_filter_display();
    //bind_flags_filter_display();
    //bind_select_ajax("picture_priority");
    //bind_select_ajax("picture_status");



    //current_notice = $("#picture-id").text();
    //set_before_edit(current_notice);
    // tinyMCE.init({"selector":"textarea.tinymce"});
    $(".best_in_place").best_in_place();
    ui_ajax_select();
    //bind_file_upload_to_upload_form();
    //$("button.ui-dialog-titlebar-close").hide();

    //initialize_add_organization();
    //select_subject_field();
    //initialize_select_all_button();
    //initialize_select_none_button();
    //initilize_filter_buttons();

}

function activate_buttons() {
    
    $("div.ui-button a").button();
}

function bind_mouseover()
{

    $("div.file-block")
            .unbind("mouseenter").mouseenter(function () {
                $(this).parent().find("div.hover-block").fadeIn();
                // console.log("fadeIn");
            })
            .unbind("mouseleave").mouseleave(function () {
                 $(this).parent().find("div.hover-block").fadeOut();
               //   console.log("fadeOut");
           });

//$("div.file-block").hover(function() {
//                //$(this).parent().find("div.hover-block").css('opacity','1');
//                console.log("hover-on");
//    },function(){
//                // $(this).parent().find("div.hover-block").css('opacity','0');
//                                 console.log("hover-off");
//
//    });

}