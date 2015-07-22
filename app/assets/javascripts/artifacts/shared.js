/* 
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */

artifact_edit_dialog = "";

function artifacteditClickBinding(selector) {
    // selectors .edit-artifact-item, tr.artifact-row 

    $(selector).unbind("click").one("click", function () {
        console.log($(this).find('#artifact-id').text());
        event.stopPropagation();
        var artifact_id = $(this).find('#artifact-id').text();
        var is_iframe = $("application-space").length > 0

        var url = '/artifacts/' + artifact_id + '/edit?request_type=window&window_type=iframe&as_window=true';

        // $(this).effect("highlight", {color: "#669966"}, 1000);

        $.ajax({
            url: url,
            success: function (data)
            {
                if (tinyMCE.activeEditor != null)
                {
                    tinyMCE.activeEditor.remove();
                }

                artifact_edit_dialog = createAppDialog(data, "edit-artifact", {}, "");
                artifact_edit_dialog.dialog({
                    close: function (event, ui) {
                        if ($("table#artifacts-table").length > 0)
                            artifactsTable.fnDraw();

                        if (($("div#artifact-list").length == 0) && ($("div#edit-artifact").length > 0))
                        {
                            current_artifact_id = $("div#edit-artifact div#attr-artifacts div#artifact-id").text();
                            if (artifact_id === current_artifact_id)
                            {
                                show_artifact(artifact_id);
                            }
                        }
                        tinyMCE.activeEditor.destroy();
                        $('#edit-artifact').html("");
                        $('#edit-artifact').dialog("destroy");
                        if (typeof init_tinyMCE_portfolio == "function") {
                            init_tinyMCE_portfolio();
                        }

                    }
                });

                require("artifacts/edit.js");
                requireCss("artifacts/edit.css");
                requireCss("artifacts.css");

                artifacts_edit_callDocumentReady();
                artifact_edit_dialog.dialog('open');


            }
        });




//        if (is_iframe) {
//                        $('iframe#artifacts-app-id',window.parent.document).attr("src",url);
//                        artifacteditClickBinding(this);
//        }
//        else
//            {
//                window.location = url;
//
//            }

    });
}

function show_artifact(artifact_id) {

    if (typeof artifact_id === 'undefined')
    {
        artifact_id = $("div#artifact-id").first().text()
        if (artifact_id === "") {
            return
        }
    }

    if ($("div.portfolio-artifact").length > 0) {

        var url = "/site/update_artifact_partial?id=" + artifact_id
        $.ajax({
            url: url,
            type: 'get',
            success: function (data)
            {
                $("div.portfolio-artifact#artifact_" + artifact_id).html(data);
                if (typeof (call_document_ready_on_artifact_detail) != "undefined") {
                    call_document_ready_on_artifact_detail();
                }
                enableArtifactEdit();
                enableSliderEdit();
            }
        });
    }
    else
    {
        var url = "/site/artifact_detail?id=" + artifact_id
        $.ajax({
            url: url,
            type: 'get',
            success: function (data)
            {
                $("div#content").html(data);
                if (typeof (call_document_ready_on_artifact_detail) != "undefined") {
                    call_document_ready_on_artifact_detail();
                }
                enableArtifactEdit();
                enableSliderEdit();
                if (typeof (initialize_artifact_detail_custom) != "undefined") {
                    initialize_artifact_detail_custom();
                }
            }
        });
    }



}