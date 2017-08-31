//= require active_admin/base
//= require fancybox
//= require jquery-ui

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
});

