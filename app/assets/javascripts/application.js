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

            var action = $('#fileupload').prop('action');
            if( !/[\d]+$/.test(action) ) action += "/" + id;

            $.getJSON( action, function(files) {
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
        },
        fetchCustomersContacts : function(path) {
            $.getScript(path);
        },
        addAsyncPagination : function() {
            $(function() {
                $(".pagination a").on("click", function() {
                    if( $(this).attr('href') == '#' ) return false;
                    $(".pagination").html("Page is loading...");
                    $.getScript(this.href);
                    return false;
                });
            });
        },
        addNewContactSupport : function() {
            $('.btn-new-contact').on('click', function() {
                var form = $('.new_contact');
                if( form.css('display') == 'none' )
                    form.fadeIn();
                else
                    form.fadeOut();
            })
        },
        showValidationErrors : function(model,json) {
            if( json ) {
                $.each( json, function(key,val) {
                    var el = $('[for="' + model + '_' + key + '"]');
                    el.attr('error-message', val.join('; ')).addClass('label-visible');
                })
            } else {
                var labels = $('label');
                $.each(labels, function(idx,val) {
                    $(val).attr('error-message','').removeClass('label-visible');
                })
            }

        },
        clearForm : function(id) {
            var form = $('form#'+id);
            $.each(['text','color','date','datetime','datetime-local','email','month','number','range','search',
            'tel','time','url','week'], function(idx,val) {
                form.find('input[type='+val+']').val('');
            });
            form.find('textarea, select').val('');
        }
    };
})();