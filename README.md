# jQuery Ajax File Upload

## usage


Load the script files first. In html page create a target element.

    <div class="uploader"></div>

Add the following code in your javascript

    $(".uploader").ajaxUpload({
        preview: true,
        ...
        callback: function(data) {
          // data containes json response from server
        }
    });

# Options supported

    upload_path: "/"              // to which the file is uploaded POST request
    browse_text: "browse"         // text on the browse link
    multiple: true                // choose multiple files
    drag_and_drop: true           // add drag and drop support
    preview : true                // add a preview for the selected image file
    callback:  function(data) {}  // do something after each file upload, the data will be the data returned form server.

eg:

    <html>
        <head>
            <title>Ajax Multi File Upload Plugin</title>
            <link rel="stylesheet" type="text/css" href="jquery_ajax_upload/style.css" />
            <script type="text/javascript" src="jquery_ajax_upload/jquery2.min.js"></script>
            <script type="text/javascript" src="jquery_ajax_upload/jquery.ajaxupload.js"></script>
            <script>
                $(function(){
                    $(".uploader").ajaxUpload();
                });
            </script>
        </head>
        <body>
            <div class="uploader"></div>
        </body>
    </html>

Ajax upload comes with a simple scss (css) file you are free to override the default styling.
A new li is added for each selected file. The DOM structure created by the plugin is as follows

    <div class="upload-3 upload">
        <a href="javascript:void(0);" class="browse">browse</a>
        <input type="file" hidden="" multiple="true">
        <ul class="list">
            <li>
                <div class="progressbar"><div class="progress" style="width: 100%;"></div></div>
                <div class="fileinfo">
                    <span class="preview"><img src="..."></span>
                    <span class="filename">IMG_20130913_213045.jpg</span>
                    <span>218 KB</span>&nbsp;—&nbsp;
                    <a id="12121" class="delete-link" data-path="/delete" href="javascript:void(0);">delete</a>
                </div>
            </li>
            ...
            ...
        </ul>
    </div>

## How to test it?

There is no ruby or sinatra dependency I just used it to simulate a server to test this plugin.

1. Install ruby
2. Install sinatra
        
        gem install sinatra

3. clone the repo

        git clone git@github.com:42races/jquery-ajax-file-upload.git

4. cd to the repo directory
5. run the command

        ruby app.rb

now just go to the url [http://localhost:4567/](http://localhost:4567/) on your browser, A demo along with documentation is available on this page.
