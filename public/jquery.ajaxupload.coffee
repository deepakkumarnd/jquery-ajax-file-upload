class Uploader
  constructor: (@container, @opts) ->
    browse    = "<a href='javascript:void(0);' class='browse'>#{@opts.browse_text}</a>"
    filefield = "<input type='file' hidden multiple=#{@opts.multiple}></input>"
    list      = "<ul class='list'></ul>"
    choose_file = (if @opts.drag_and_drop then "<div class='droparea'>#{browse}</div>" else browse)
    choose_section = "#{choose_file}#{filefield}#{list}"

    @container.addClass("upload")
    @container.append(choose_section)

    nodes      = @container.children()
    @browse    = @container.find(".browse")
    @filefield = @container.find("input[type=file]")
    @list      = @container.find("ul")

    if @opts.drag_and_drop
      @droparea  = @container.find(".droparea")
      @droparea.bind "dragover", @handleDragOver
      @droparea.bind "drop", @handleFileSelection

    @browse.bind "click", =>
      @filefield.click()
    @filefield.bind "change", @handleFileSelection

    $(".list").on "click", ".delete-link", (evt) ->
      evt.preventDefault()
      delete_link = $(evt.target)
      $.ajax
        url: delete_link.data("path")
        type: "DELETE"
        success: (data) ->
          delete_link.closest("li").remove()
        error: (data) ->
          console.log "error"

  handleDragOver: (evt) =>
    evt.stopPropagation()
    evt.preventDefault()
    evt.originalEvent.dataTransfer.dropEffect = "copy"

  handleFileSelection: (evt) =>
    evt.stopPropagation()
    evt.preventDefault()

    files = evt.target.files || evt.originalEvent.dataTransfer.files

    $(files).each (i, file) =>
      item = """<li><div class='progressbar'><div class='progress' style='width:0%;'></div></div>
                <div class='fileinfo'><span class='preview'></span><span class='filename'>#{file.name}</span>
                <span>#{@toSize(file.size)}</span>&nbsp;&mdash;&nbsp;</div></div></li>"""
      @list.append(item)
      preview = $(".preview").last()
      @setPreview(file, preview) if @opts.preview
      @upload(file, @list.children().last())

  setPreview: (file, preview) =>
    return unless file.type.match("image.*")
    reader = new FileReader()
    reader.onload = (evt) ->
      preview.html("<img src='#{evt.target.result}'></img>")
    reader.readAsDataURL(file)

  toSize: (size) ->
    units = ["KB", "MB", "GB"]
    unit  = "BYTES"

    while size > 1000
      size = size/1000.0
      unit = units.shift()

    size = Math.round(size)
    size + " " + unit

  upload: (file, li) =>
    xhr = new XMLHttpRequest()
    fd  = new FormData()
    progress = li.find(".progress")

    fd.append "filename", escape(file.name)
    fd.append "size", file.size
    fd.append "file", file

    xhr.open "POST", @opts.upload_path, true

    xhr.onload = =>
      if xhr.status == 200
        @processResponse(xhr.responseText, li)
      else
        console.log "failed #{xhr.status}"

    xhr.upload.onprogress = (e) ->
      if e.lengthComputable
        progress.css("width", (e.loaded/e.total*100) + "%")

    xhr.send(fd)

  processResponse: (response_text, li) ->
    response = JSON.parse(response_text)
    if response.delete_path
      delete_link = "<a id='#{response.id}' class='delete-link' data-path='#{response.delete_path}' href='javascript:void(0);' >delete</a>"
      li.find(".fileinfo").append(delete_link)

    @opts.callback(response)

$.fn.ajaxUpload = (options) ->
  options = $.extend {}, $.fn.ajaxUpload.default_options, options
  new Uploader(this, options)

$.fn.ajaxUpload.default_options =
  upload_path: "/"
  browse_text: "browse"
  drag_and_drop: false
  multiple: true
  preview: false
  callback: (data) ->
    console.log("no callbacks")