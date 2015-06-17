// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or any plugin's vendor/assets/javascripts directory can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file.
//
// Read Sprockets README (https://github.com/sstephenson/sprockets#sprockets-directives) for details
// about supported directives.
//


$(document).ready(function () {
 enableArtifactEdit();
 enablePortfolioEdit();
 enableMeusEdit();
 });


function enableArtifactEdit() {
    if ($("#edit-artifacts").length > 0)
    {
        require("artifacts/shared.js");
        artifacteditClickBinding("div#edit-artifacts");
    }
}

function enablePortfolioEdit() {
    if ($("div.edit-portfolios").length > 0)
    {
        require("portfolios/shared.js");
        portfolioeditClickBinding("div#edit-portfolios");
    }
}

function enableMeusEdit() {
    if ($("#edit-menu").length > 0)
    {
        requireCss("menus.css");
        require("menus/shared.js");
        menueditClickBinding("div.edit-menu",true);
    }
}