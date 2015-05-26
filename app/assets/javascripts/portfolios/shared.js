/* 
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */

portfolio_edit_dialog = "";
function portfolioeditClickBinding(selector) {
    // selectors .edit-portfolio-item, tr.portfolio-row 

    $(selector).unbind("click").one("click", function (event) {
        event.stopPropagation();
        console.log($(this).find('#portfolio-id').text());
        var portfolio_id = $(this).find('#portfolio-id').text();
        var is_iframe = $("application-space").length > 0

        var url = '/portfolios/' + portfolio_id + '/edit?request_type=window&window_type=iframe&as_window=true';
        // $(this).effect("highlight", {color: "#669966"}, 1000);

        $.ajax({
            url: url,
            success: function (data)
            {
                portfolio_edit_dialog = createAppDialog(data, "edit-portfolio-dialog", {
                    completion: function completionCallback() {
                        if ($("table#portfolio-table").length > 0)
                            portfolioTableAjax.fnDraw();
                        if ($("div#edit-portfolio-dialog").length > 0)
                        {
                            current_portfolio_id = $("div#portfolio-id").first().text();
                            if (portfolio_id === current_portfolio_id)
                            {
                                show_portfolio(portfolio_id);

                            }
                        }

                        tinyMCE.editors[0].destroy();
                        $('#edit-portfolio-dialog').html("");
                        $('#edit-portfolio-dialog').dialog("destroy");
                    }}, "");
//                portfolio_edit_dialog.dialog({
//                    close: function (event, ui) {
//                        if ($("table#portfolio-table").length > 0)
//                            portfolioTableAjax.fnDraw();
//
//                        if ($("div#edit-portfolio-dialog").length > 0)
//                        {
//                            current_portfolio_id = $("div#portfolio div#attr-portfolios div#portfolio-id").text();
//                            if (portfolio_id === current_portfolio_id)
//                            {
//                                show_portfolio(portfolio_id);
//                            }
//                        }
                //tinyMCE.editors[0].destroy();
                //$('#edit-portfolio-dialog').html("");
                //$('#edit-portfolio-dialog').dialog("destroy");

                require("portfolios/edit.js");
                requireCss("portfolios/edit.css");
                requireCss("portfolios.css");
                portfolios_edit_callDocumentReady();
                portfolio_edit_dialog.dialog('open');
            }
        });


    });
//        if (is_iframe) {
//                        $('iframe#portfolios-app-id',window.parent.document).attr("src",url);
//                        portfolioeditClickBinding(this);
//        }
//        else
//            {
//                window.location = url;
//
//            }

}


function show_portfolio(portfolio_id) {

    if (typeof portfolio_id === 'undefined')
    {
        portfolio_id = $("div#portfolio-id").first().text()
        if (portfolio_id === "") {
            return
        }
    }
    var url = "/site/portfolio_detail?id=" + portfolio_id
    $.ajax({
        url: url,
        type: 'get',
        success: function (data)
        {
            $("div#content").html(data);
            if (typeof (call_document_ready_on_portfolio_detail) != "undefined") {
                call_document_ready_on_portfolio_detail();
            }
            setUpOrderChange();
            enablePortfolioEdit();
            enableArtifactEdit();
            enableSliderEdit();
        }
    });

}
