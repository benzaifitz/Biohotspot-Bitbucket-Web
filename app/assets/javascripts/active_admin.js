//= require active_admin/base
//= require activeadmin_addons/all
//= require fancybox
//= require jquery-ui
//= require underscore
//= require gmaps/google

$(document).ready(function() {
    $("a.fancybox").fancybox();

    function readURL(input) {
        if (input.files && input.files[0]) {
            var reader = new FileReader();

            reader.onload = function (e) {
                $('#profile_picture_preview').attr('src', e.target.result);
            }

            reader.readAsDataURL(input.files[0]);
        }
    }

    $("#user_profile_picture").on('change', function(){
        readURL(this);
    });

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

