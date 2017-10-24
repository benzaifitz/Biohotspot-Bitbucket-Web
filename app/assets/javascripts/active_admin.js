//= require active_admin/base
//= require activeadmin_addons/all
//= require fancybox
//= require jquery-ui
//= require underscore
//= require gmaps/google
//= require responsiveslides
//= require jquery
/* //= require jquery.jcrop */

//window.JCropper

$(document).ready(function() {
    $("a.fancybox").fancybox();

    function readURL(input,object) {
        if (input.files && input.files[0]) {
            var reader = new FileReader();

            reader.onload = function (e) {
                object.attr('src', e.target.result);
            }

            reader.readAsDataURL(input.files[0]);
        }
    }

    $("#user_profile_picture").on('change', function(){
        readURL(this,$('#picture_preview'));
    });

    $("#submission_sample_photo").on('change', function(){
        readURL(this,$('#picture_preview'));
    });

    $("#submission_monitoring_photo").on('change', function(){
        readURL(this,$("#monitoring_picture_preview"));
    });

    $("#land_manager_profile_picture").on('change', function(){
        readURL(this,$('#picture_preview'));
    });

    $(document).on('change','input[id*="category_photos_attributes_"]', function(){
        readCategoryImageURL(this);
    });

    $(document).on('change','input[id*="submission_photos_attributes_"]', function(){
        readCategoryImageURL(this);
    });

    function readCategoryImageURL(input) {
        if (input.files && input.files[0]) {
            var reader = new FileReader();

            reader.onload = function (e) {
                $(input).parent().find('.inline-hints').html("<div><img width='100px' src='" +e.target.result +"'/></div>");
            }

            reader.readAsDataURL(input.files[0]);
        }
    }

    $( "form" ).on( "submit", function() {
        if($('#submission_sub_category_id').val() == ''){
            alert('Sub category can not blank');
            return false;
        }
    });

    window.fetch_near_by_submissions = function() {
        if (!$('body').hasClass("loading")) {
            $('body').addClass("loading");
        }
        var selected=[];
        $('#category_ids :selected').each(function(){
            selected[$(this).val()]=$(this).val();
        });
        console.log(selected);
        return $.ajax({
            url: "/admin/submission_map/search_submissions",
            data: {
                category_ids: selected
            },
            complete: function(jqxhr, response) {
                $('body').removeClass("loading");
                return $(".map").html(jqxhr.responseText);
            }
        });
    };
});



//
//update_crop = function(coords) {
//    var img_height, img_width, ratio, rx, ry;
//    rx = 100 / coords.w;
//    ry = 100 / coords.h;
//    img_width = $('#category_photo_preview')[0].naturalWidth;
//    img_height = $('#category_photo_preview')[0].naturalHeight;
//    ratio = 1;
//    $('#company_logo_crop_x').val(Math.round(coords.x * ratio));
//    $('#company_logo_crop_y').val(Math.round(coords.y * ratio));
//    $('#company_logo_crop_w').val(Math.round(coords.w * ratio));
//    $('#company_logo_crop_h').val(Math.round(coords.h * ratio));
//};
//
//jcrop_company_logo = function() {
//    $('#category_photo_preview').Jcrop({
//        onChange: update_crop,
//        onSelect: update_crop,
//        setSelect: [0, 0, 500, 500]
//    }, function() {
//        return window.JCropper = this;
//    });
//};
//
//$(function() {
//    jcrop_company_logo();
//});

