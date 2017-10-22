//= require active_admin/base
//= require activeadmin_addons/all
//= require fancybox
//= require jquery-ui
//= require underscore
//= require gmaps/google
//= require responsiveslides


$(document).ready(function() {
    $("a.fancybox").fancybox();

    //function readURL(input) {
    //    if (input.files && input.files[0]) {
    //        var reader = new FileReader();
    //
    //        reader.onload = function (e) {
    //            $('#picture_preview').attr('src', e.target.result);
    //        }
    //
    //        reader.readAsDataURL(input.files[0]);
    //    }
    //}

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

