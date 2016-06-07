# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

#= require qiniu_direct_uploader

$(document).ready ->
  photoForm = $("form#photograph-uploader")
  if photoForm.length > 0
    photoForm.QiniuUploader
      # see also  https://github.com/blueimp/jQuery-File-Upload/wiki/Options
      autoUpload: true
      singleFileUploads: false
      limitMultiFileUploads: 2
      customCallbackData: {"xyz": 100}
      onFilesAdd: (file) ->
        return true
        if file.type != "video/mp4" and file.type != "video/mov" and file.type != "video/mpeg"
          alert('请选择视频文件！')
          return false
        else
          return true

    photoForm.bind "ajax:success", (e, data) ->
      console.log('success')
      $("#video_file").val(data.file)
      console.log(data)

    photoForm.bind "ajax:failure", (e, data) ->
      console.log('failure')
      console.log(data)
