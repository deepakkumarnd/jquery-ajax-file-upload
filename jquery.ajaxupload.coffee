(($) ->
        class Uploader
                constructor: (@container, @opts) ->
                        console.log @opts

                        browse    = "<a href='javascript:void(0);' class='#{@opts.browse_class}'>#{@opts.browse_text}</a>"
                        filefield = "<input type='file' hidden multiple=#{@opts.multiple}></input>"
                        list      = "<ul class='#{@opts.list_class}'></ul>"

                        @container.append(browse)
                        @container.append(filefield)
                        @container.append(list)

                        nodes      = @container.children()
                        @browse    = $(nodes[0])
                        @filefield = $(nodes[1])
                        @list      = $(nodes[2])

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
                                                console.log "success"
                                                delete_link.parent().remove()
                                        error: (data) ->
                                                console.log "error"

                handleFileSelection: (evt) =>
                        files = evt.target.files

                        $(files).each (i, file) =>
                                item = "<li><div><span>#{file.name}</span>&nbsp;<span>#{@toSize(file.size)}</span></div><div><progress hidden></progress></div></li>"
                                @list.append(item)
                                @upload(file, @list.children().last())

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
                        progress = li.children().last().children().first()
                        progress.show()

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
                                progress.show()
                                if e.lengthComputable
                                        progress.val(e.loaded/e.total)
                        xhr.send(fd)

                processResponse: (response_text, li) ->
                        response = JSON.parse(response_text)
                        if response.delete_path
                                delete_link = "<a id='#{response.id}' class='delete-link' data-path='#{response.delete_path}' href='javascript:void(0);' >delete</a>"
                                li.append(delete_link)

        $.fn.ajaxUpload = (options) ->
                options = $.extend {}, $.fn.ajaxUpload.default_options, options
                new Uploader(this, options)

        $.fn.ajaxUpload.default_options =
                upload_path: "/"
                browse_text: "browse"
                browse_class: "browse"
                list_class: "list"
                progress_class: "progressbar"
                multiple: true
) jQuery