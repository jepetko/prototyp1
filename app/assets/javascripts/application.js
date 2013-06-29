// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or vendor/assets/javascripts of plugins, if any, can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// the compiled file.
//
// WARNING: THE FIRST BLANK LINE MARKS THE END OF WHAT'S TO BE PROCESSED, ANY BLANK LINE SHOULD
// GO AFTER THE REQUIRES BELOW.
//
//= require jquery
//= require jquery_ujs
//= require bootstrap
//= require jquery-fileupload
//= require_tree .

var ProtoSupport = (function() {
    return {
        addCompanyAvatarFileUploadSupport : function() {
            $(function () {
                // Initialize the jQuery File Upload widget:
                $('#fileupload').fileupload({maxNumberOfFiles : 1});
            });
        },
        setCompanyAvatarOnCustomer : function(val) {
            $('#customer_company_avatar').val(val);
        },
        listExistingUpload : function(id) {
            $.getJSON( $('#fileupload').prop('action') + "/" + id, function(files) {
                if(!files) return;
                var filesArr = files['files'];
                var fu = $('#fileupload').data('blueimp-fileupload')
                        || $('#fileupload').data('fileupload');
                var template;
                fu._adjustMaxNumberOfFiles(-filesArr.length);
                template = fu._renderDownload(filesArr)
                    .appendTo($('#fileupload .files'));
                // Force reflow:
                fu._reflow = fu._transition && template.length &&
                    template[0].offsetWidth;
                template.addClass('in');
                $('#loading').remove();
            });
        }
    };
})();
