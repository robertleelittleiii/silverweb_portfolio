/* 
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */


$(document).ready(function() {
    bindClickToShowBefore();
    bindClickToHideBefore();
    activate_slides();
});


function bindClickToShowBefore() {
    $('div#image-before-button').click(function() {
        console.log(this);
        $("div#before-picture").fadeIn();
        //   window.location.href = $($(this)).find("a.product-detail-link").attr('href');

        //   $(this).find("a.product-detail-link").click();
    });
}



function bindClickToHideBefore() {
    $('div#close-before-picture').click(function() {
        console.log(this);
        $("div#before-picture").fadeOut();
        //   window.location.href = $($(this)).find("a.product-detail-link").attr('href');

        //   $(this).find("a.product-detail-link").click();
    });
}

function activate_slides() {

    if (($("div#slides3").length > 0))
    {
        $("#page-slider-gallary-page").show();
    }
    else
    {
        $("#page-slider-gallary-page").hide();

    }

    console.log($("div#slides3 > div").length);

    if ($("div#slides3 > div").length > 1)
    {
        console.log("slides activated");
        slideshow_width = parseInt($("#slider-width").text().trim());
        slideshow_height = parseInt($("#slider-height").text().trim());
        slideshow_nav_pagination = $("#slider-nav").text().trim();
        slideshow_effect = $("#slider-effect").text().trim();
        slideshow_auto = $("#slider-auto").text().trim() || false;
        slideshow_speed = $("#slider-speed").text().trim() || "5000";
        slideshow_play = slideshow_speed > 0;


        $('#slides3').slidesjs({
            width: slideshow_width,
            height: slideshow_height,
            pagination: {
                // active: true,
                // [boolean] Create pagination items.
                // You cannot use your own pagination. Sorry.
                effect: slideshow_effect
                        // [string] Can be either "slide" or "fade".
            },
            play: {
                active: slideshow_play,
                // [boolean] Generate the play and stop buttons.
                // You cannot use your own buttons. Sorry.
                effect: slideshow_effect,
                // [string] Can be either "slide" or "fade".
                interval: slideshow_speed,
                // [number] Time spent on each slide in milliseconds.
                auto: slideshow_auto,
                // [boolean] Start playing the slideshow on load.
                //swap: true,
                // [boolean] show/hide stop and play buttons
                pauseOnHover: true,
                // [boolean] pause a playing slideshow on hover
                //    restartDelay: 2500
                // [number] restart delay on inactive slideshow
            },
            navigation: {
                active: slideshow_nav_pagination,
                // [boolean] Generates next and previous buttons.
                // You can set to false and use your own buttons.
                // User defined buttons must have the following:
                // previous button: class="slidesjs-previous slidesjs-navigation"
                // next button: class="slidesjs-n           ext slidesjs-navigation"
                effect: slideshow_effect
                        // [string] Can be either "slide" or "fade".
            }

        });


        if (($("div#slides3 div.slidesjs-container").length > 0))
        {


            if ($("#slider-nav").text().trim() == "false") {
                $("a.slidesjs-navigation").hide();
            }
            ;

            $("div#slides3 .slidesjs-container").width($("#slider-width").text().trim());
            $("div#slides3 .slidesjs-container").height($("#slider-height").text().trim());
            $("div#slides3 .slidesjs-container div.slides_control").width($("#slider-width").text().trim());
            $("div#slides3 .slidesjs-container div.slides_control").height($("#slider-height").text().trim());
            $("div#slides3 .slidesjs-container div.slider-content").width($("#slider-width").text().trim());
            $("div#slides3 .slidesjs-container div.slider-content").height($("#slider-height").text().trim());

            //  slideshow_width = $("#slides").width();
            //  slideshow_height =$("#slides").height();

            slideshow_width = parseInt($("#slider-width").text());
            slideshow_height = parseInt($("#slider-height").text());

            slideshow_offset = $("#slides3").offset();
            slideshow_middle = (slideshow_height / 2) - ($("#slides3 .next-slide").height() / 2);

//            $("#slides3 a.slidesjs-next").offset({
//                top: slideshow_middle + slideshow_offset.top,
//                left: slideshow_width + slideshow_offset.left + 17
//            });
//
//            $("#slides3 a.slidesjs-previous").offset({
//                top: slideshow_middle + slideshow_offset.top,
//                left: slideshow_offset.left - $("#slides3 .prev-slide").width() - 30
//            });

            $("#slides3").css("overflow", "visible");

        }

    }
    else
    {
        $("#page-slider-gallary-page").css("top", "0px");
        $("#page-slider-gallary-page").css("overflow", "hidden");

    }
    $("#page-slider-gallary-page").css("position", "absolute");

}