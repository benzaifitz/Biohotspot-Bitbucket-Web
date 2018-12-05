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

    $('.has_many_container.monitoring_image .has_many_remove').hide();
    $('.has_many_container.sample_image .has_many_remove').hide();
    $('#submission_monitoring_image_attributes_file').on('change', function(){readCategoryImageURL(this);});
    $('#submission_sample_image_attributes_file').on('change', function(){readCategoryImageURL(this);});
    $('#project_image_input #project_image').on('change', function(){
        $(this).css({'color':'black'});
        readCategoryImageURL(this);
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
            alert('Sample can not blank');
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
        n = window.location.pathname.indexOf("admin")
        if(n < 0)
          path = "/pm/maps/search_submissions"
        else
          path = "/admin/maps/search_submissions"
        return $.ajax({
            url: path,
            data: {
                category_ids: selected
            },
            complete: function(jqxhr, response) {
                $('body').removeClass("loading");
                return $(".map").html(jqxhr.responseText);
            }
        });
    };

    window.remove_blank_slate_from_notification = function() {
        if($('.admin_notifications .blank_slate').length > 0) {
            $('.admin_notifications .blank_slate a').remove();
        }
    }
    remove_blank_slate_from_notification();
});

$(document).ready(function() {
    //option A
    $(".submission_map_filter_form").submit(function(e){
        e.preventDefault(e);
        if (!$('body').hasClass("loading")) {
            $('body').addClass("loading");
        }
        n = window.location.pathname.indexOf("admin")
        if(n < 0)
          path = "/pm/maps/search_submissions"
        else
          path = "/admin/maps/search_submissions"
        return $.ajax({
            url: path,
            data: $('form').serializeArray(),
            complete: function(jqxhr, response) {
                $('body').removeClass("loading");
                return $(".map").html(jqxhr.responseText);
            }
        });
    });
});

$(document).ready(function() {
    if($('input.project_category_checkbox:checked').length == $('input.project_category_checkbox').length-1){
        $($('input.project_category_checkbox')[0]).prop('checked', true);
    }
    $('input.project_category_checkbox').on('change', function(){
        if(this.checked){
            if($(this).val()==''){
                $('input.project_category_checkbox').prop('checked', true);
            }else{
                if($('input.project_category_checkbox:checked').length == $('input.project_category_checkbox').length-1){
                    $($('input.project_category_checkbox')[0]).prop('checked', true);
                }
            }
        }else{
            if($(this).val()==''){
                $('input.project_category_checkbox').prop('checked', false);
            }
            $($('input.project_category_checkbox')[0]).prop('checked', false);
        }
    });
});
reg = /[A-E]/gi

$(document).ready(function() {
    if($('#sub_category_site_id').length > 0) {
        $('#sub_category_site_id').on('change', function(){
            var title = $('#sub_category_site_id').find(":selected").data('title');
            $.each($('#sub_category_category_ids option'), function( key, value ) {
              $(value).removeAttr('disabled');
              $(value).css('color','black');
              $(value).removeAttr("selected");
              console.log($(value).data('title'));
              if ($(value).data('title').indexOf(title) == -1) {
                $(value).attr('disabled','disabled'); 
                $(value).css('color','grey')
              }
            });            
        });        
    }    
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

