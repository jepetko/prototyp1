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
//= require jquery-ui/jquery-ui-1.10.3.custom
//= require jquery_ujs
//= require bootstrap
//= require jquery-fileupload

var ProtoSupport = (function() {
    return {
        addCompanyAvatarFileUploadSupport : function() {
            // Initialize the jQuery File Upload widget:
            $('#fileupload').fileupload({maxNumberOfFiles : 1});
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
        executeScript : function(path) {
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
        fade : function(selector) {
            var el = $(selector);
            if( el.css('display') == 'none' ) {
                //el.fadeIn();
                el.css('display','block');
            } else {
                //el.fadeOut();
                el.css('display','none');
            }
        },
        addNewContactSupport : function(customerID) {
            $('.btn-contact-form').on('click', function() {
                var form = $('.contact-form');
                form.remove();
                $.getScript('/customers/' + customerID + '/contacts/new').done(
                    function(script, status) {
                        ProtoSupport.fade('.contact-form');
                    }
                );
            });
        },
        addEditContactSupport : function(customerID) {
            var rows = $('table.contacts tr');

            for( var i=0; i<rows.length; i++ ) {
                var row = rows[i];
                var $row = $(row);

                var loadForm = function() {
                    var id = $(this).attr('data-id');
                    $.getScript('/customers/' + customerID + '/contacts/' + id + '/form').done(
                        function(script,status) {
                            ProtoSupport.fade('.contact-form');
                        }
                    );
                };
                $row.on('click', loadForm );
            }
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
        clearForm : function(cssClass) {
            var form = $(cssClass);
            $.each(['text','color','date','datetime','datetime-local','email','month','number','range','search',
            'tel','time','url','week'], function(idx,val) {
                form.find('input[type='+val+']').val('');
            });
            form.find('textarea, select').val('');
        },
        addGeocodeSupport : function(cssClass) {
            var form = $(cssClass);
            var inputs = form.find('input[type="text"], select');
            inputs.on('blur', (function(formClass) {
                return function() {
                    ProtoSupport.doGeocode(formClass);
                };
            })(cssClass))
        },
        doGeocode : function(cssClass) {
            var form = $(cssClass);
            var inputs = form.find('input[type="text"], select');
            var params = {};
            var whiteList = ['street', 'zip', 'city', 'country'];
            inputs.each( function(idx,input) {
                var lastPos = input.id.lastIndexOf('_');
                if( lastPos !== -1) {
                    var name = input.id.substr(lastPos+1);
                    if($.inArray(name, whiteList) >= 0) {
                        params[name] = input.value;
                    }
                }
            });
            $.ajax({ url : '/locations/find.json', data : params })
                .done(function(response) {
                    if(!response) return;
                    if(response.length == 0) return;
                    var result = response[0];
                    var $scope = angular.element($('#map-app')[0]).scope();
                    $scope.currentLatLng = new OpenLayers.LonLat(result['lon'],result['lat']);
                    $scope.currentLatLngAsString = 'POINT(' + result['lon'] + ' ' + result['lat'] + ')';
                    $scope.$apply();
                });
        }
    };
})();