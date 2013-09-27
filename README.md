# jQuery Ajax File Upload

## usage

in html page create a target element

     <div class="upload"></div>

in javascript

     $(".upload").ajaxUpload();


Ajax upload does not contain any default style for now, you need to create a stylesheet for this. The plugin creates the following structure.
A new li is added for each selected file. You can create a stylesheet based on this structure

     <div class="uploader">
          <a href="javascript:void(0);" class="browse">browse</a>
          <input type="file" hidden="" multiple="true">
          <ul class="list">
              <li>
                <div>
                        <span>filename</span>&nbsp;
                        <span>82 MB</span>
                </div>
                <div>
                        <progress hidden="" value="1" style="display: inline-block;"></progress>
                </div>
                <a id="12121" class="delete-link" data-path="/" href="javascript:void(0);">delete</a>
              </li>
          </ul>
     </div>
   

