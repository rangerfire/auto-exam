/**
 * Created by Yc on 2016/3/3.
 */
(function (factory) {
    if (typeof define === 'function' && define.amd) {
        define(['jquery'], factory);
    } else if (typeof exports === 'object') {
        // Node / CommonJS
        factory(require('jquery'));
    } else {
        factory(jQuery);
    }
})(function ($) {

    'use strict';

    var console = window.console || { log: function () {} };

    function CropAvatar($element) {
        this.$container = $element;

        this.$avatarView = this.$container.find('[role=head-container]');
        this.$avatar = this.$avatarView.find('img');
        this.$avatarModal = $("body").find('#avatar-modal');
        this.$loading = $("#page-wrapper").find('.loading');
        this.$avatarForm = this.$avatarModal.find('.avatar-form');
        this.$avatarUpload = this.$avatarForm.find('.avatar-upload');
        this.$avatarSrc = this.$avatarForm.find('.avatar-src');
        this.$avatarData = this.$avatarForm.find('.avatar-data');
        this.$avatarInput = this.$avatarForm.find('.avatar-input');
        this.$avatarSave = this.$avatarForm.find('.avatar-save');
        this.$avatarBtns = this.$avatarForm.find('.avatar-btns');

        this.$avatarWrapper = this.$avatarModal.find('.avatar-wrapper');
        this.$avatarPreview = this.$avatarModal.find('.avatar-preview');

        this.init();
    }

    CropAvatar.prototype = {
        constructor: CropAvatar,
        support: {
            fileList: !!$('<input type="file">').prop('files'),
            blobURLs: !!window.URL && URL.createObjectURL,
            formData: !!window.FormData
        },
        init: function () {
            this.support.datauri = this.support.fileList && this.support.blobURLs;

            if (!this.support.formData) {
                this.initIframe();
            }

            this.initTooltip();
            this.initModal();
            this.addListener();
        },

        addListener: function () {
            this.$avatarView.on('click', $.proxy(this.click, this));
            this.$avatarInput.on('change', $.proxy(this.change, this));
            this.$avatarForm.on('submit', $.proxy(this.submit, this));
            this.$avatarBtns.on('click', $.proxy(this.rotate, this));
        },

        initTooltip: function () {
            this.$avatarView.tooltip({
                placement: 'bottom'
            });
        },

        initModal: function () {
            this.$avatarModal.modal({
                show: false
            });
        },

        initPreview: function () {
            var url = this.$avatar.attr('src');

            this.$avatarPreview.empty().html('<img src="' + url + '">');
        },

        initIframe: function () {
            var target = 'upload-iframe-' + (new Date()).getTime(),
                $iframe = $('<iframe>').attr({
                    name: target,
                    src: ''
                }),
                _this = this;

            // Ready ifrmae
            $iframe.one('load', function () {

                // respond response
                $iframe.on('load', function () {
                    var data;

                    try {
                        data = $(this).contents().find('body').text();
                    } catch (e) {
                        console.log(e.message);
                    }

                    if (data) {
                        try {
                            data = $.parseJSON(data);
                        } catch (e) {
                            console.log(e.message);
                        }

                        _this.submitDone(data);
                    } else {
                        _this.submitFail('Image upload failed!');
                    }

                    _this.submitEnd();

                });
            });

            this.$iframe = $iframe;
            this.$avatarForm.attr('target', target).after($iframe.hide());
        },

        click: function () {
            this.$avatarModal.modal('show');
            this.initPreview();
        },

        change: function () {
            var files,
                file;

            if (this.support.datauri) {
                files = this.$avatarInput.prop('files');

                if (files.length > 0) {
                    file = files[0];

                    if (this.isImageFile(file)) {
                        if (this.url) {
                            URL.revokeObjectURL(this.url); // Revoke the old one
                        }

                        this.url = URL.createObjectURL(file);
                        this.startCropper();
                    }else{
                        $.moyuAlert('请选择图片文件');
                    }
                }
            } else {
                file = this.$avatarInput.val();

                if (this.isImageFile(file)) {
                    this.syncUpload();
                }
            }
        },

        submit: function () {
            if (!this.$avatarSrc.val() && !this.$avatarInput.val()) {
                return false;
            }

            if (this.support.formData) {
                this.ajaxUpload();
                return false;
            }
        },

        rotate: function (e) {
            var data;

            if (this.active) {
                data = $(e.target).data();

                if (data.method) {
                    this.$img.cropper(data.method, data.option);
                }
            }
        },

        isImageFile: function (file) {
            if (file.type) {
                return /^image\/\w+$/.test(file.type);
            } else {
                return /\.(jpg|jpeg|png|gif)$/.test(file);
            }
        },

        startCropper: function () {
            var _this = this;

            if (this.active) {
                this.$img.cropper('replace', this.url);
            } else {
                this.$img = $('<img src="' + this.url + '">');
                this.$avatarWrapper.empty().html(this.$img);
                this.$img.cropper({
                    aspectRatio: 1,
                    preview: this.$avatarPreview.selector,
                    strict: false,
                    crop: function (data) {
                        var json = [
                            '{"x":' + data.x,
                            '"y":' + data.y,
                            '"height":' + data.height,
                            '"width":' + data.width,
                            '"rotate":' + data.rotate + '}'
                        ].join();

                        _this.$avatarData.val(json);
                    }
                });

                this.active = true;
            }
        },

        stopCropper: function () {
            if (this.active) {
                this.$img.cropper('destroy');
                this.$img.remove();
                this.active = false;
            }
        },

        ajaxUpload: function () {
            var url = this.$avatarForm.attr('action'),
                data = new FormData(this.$avatarForm[0]),
                _this = this;

            $.ajax(url, {
                headers: {'X-XSRF-TOKEN': $('meta[name="csrf-token"]').attr('content')},
                type: 'post',
                data: data,
                //dataType: 'json',
                processData: false,
                contentType: false,

                beforeSend: function () {
                    _this.submitStart();
                },

                success: function (data) {
                    $('body').append(data);
                    //_this.submitDone(data);
                },

                error: function (XMLHttpRequest, textStatus, errorThrown) {
                    _this.submitFail(textStatus || errorThrown);
                },

                complete: function () {
                    _this.submitEnd();
                }
            });
        },

        syncUpload: function () {
            this.$avatarSave.click();
        },

        submitStart: function () {
            this.$loading.fadeIn();
        },

        submitDone: function (data) {
            if ($.isPlainObject(data)) {
                if (data.result) {
                    this.url = data.result;
                    if (this.support.datauri || this.uploaded) {
                        this.uploaded = false;
                        this.cropDone();
                    } else {
                        this.uploaded = true;
                        this.$avatarSrc.val(this.url);
                        this.startCropper();
                    }
                    this.$avatarInput.val('');
                } else if (data.message) {
                    this.alert(data.message);
                }
            } else {
                this.alert('Failed to response');
            }
        },

        submitFail: function (msg) {
            this.alert(msg);
        },

        submitEnd: function () {
            this.$loading.fadeOut();
        },

        cropDone: function () {
            this.$avatarForm.get(0).reset();
            this.$avatar.attr('src', this.url);
            this.stopCropper();
            this.$avatarModal.modal('hide');
        },

        alert: function (msg) {
            var $alert = [
                '<div class="alert alert-danger avater-alert">',
                '<button type="button" class="close" data-dismiss="alert">&times;</button>',
                msg,
                '</div>'
            ].join('');

            this.$avatarUpload.after($alert);
        }
    };




    $(function () {

        var crop = new CropAvatar($('#crop-avatar'));
        $('#btn-file-up').click(function () {
            var f = document.getElementsByName('avatar_file')[0].files;
            if(f.length==0
                || !/^image\/\w+$/.test(f[0].type) ){
                $.moyuAlert('请选择图片文件');
                return false;
            }
            var d = getSelectedImg();
            if(!d)
                $.moyuAlert('请选择图片文件');
            else {
                $.moyuConfirm('是否确定上传？', function () {
                    $.ajax({
                        method:'post',
                        contentType:f[0].type,
                        data:d,
                        url:'ajax/head_upload.jsp'
                    }).done(function (d) {
                        if(d==1){
                            $.moyuAlert('上传成功，请刷新页面查看 :)');
                        }else
                            $.moyuAlert('上传失败 :(');
                    })
                    return true;
                });
            }
            return false;
        });
    });

});
function createCanvas(){
    return document.createElement('canvas').getContext('2d');
}
function downloadImg(data,filename){
    var save_link = document.createElement('a');
    save_link.href = data;
    save_link.download = filename;
    save_link.click()
}
function getSelectedImg(){
    var img = $('.cropper-canvas img');
    var box = $('.cropper-crop-box'), boxWidth = Math.floor(box.width()),boxHeight = Math.floor(box.height());
    if(boxHeight<boxWidth) boxWidth=boxHeight;
    else if(boxHeight>boxWidth) boxHeight=boxWidth;
    if(img.length==0||box.length==0)
        return false;

    var canvas = createCanvas();
    canvas.canvas.width=img.width();
    canvas.canvas.height=img.height();
    canvas.drawImage(img[0],0,0,img.width(),img.height());
    var s = box.css('left'),s2= img.parent().css('left');
    var x = Number(s.substr(0, s.length-2)-s2.substr(0, s2.length-2));
    s = box.css('top'),s2=img.parent().css('top');
    var y = Number(s.substr(0, s.length-2)-s2.substr(0, s2.length-2));
    var newImg = canvas.getImageData(Math.floor(x),Math.floor(y),boxWidth,boxHeight);
    var c = createCanvas();
    //boxWidth==boxHeight
    c.canvas.width=boxWidth;
    c.canvas.height=boxHeight;
    var mat = img[0].style.transform;
    if(mat=='none'||mat==''||mat==null) {
        c.putImageData(newImg,0,0);
        return c.canvas.toDataURL();
    }
    var tempCanv = createCanvas();
    tempCanv.canvas.width=newImg.width;
    tempCanv.canvas.height=newImg.height;
    tempCanv.putImageData(newImg,0,0);
    var imgTag = document.createElement('img');
    imgTag.src = tempCanv.canvas.toDataURL();

    var bg = mat.indexOf('('),ed = mat.indexOf('deg');
    var deg = Number(mat.substr(bg+1,ed-bg-1));
    deg=deg>=0?deg:360+deg;
    c.rotate(deg*Math.PI/180);
    switch (deg){
        case 90:c.drawImage(imgTag,0,-boxHeight); break;
        case 180:c.drawImage(imgTag,-boxWidth,-boxHeight);break;
        case 270:c.drawImage(imgTag,-boxWidth,0);break;
    }
    //downloadImg(c.canvas.toDataURL(),'t.png');
    //debugger;
    //eval("c.transform("+deg+")");

    return c.canvas.toDataURL();
}