class Grid
    currentGridPosition = 0
    currentImageId = 0
    
    blockMap = {
        0: 'a',
        1: 'b'    
    } 
    
    # PhoneGap is ready
    onDeviceReady: () =>
        $('#main-data-grid').html('')
        window.requestFileSystem(LocalFileSystem.PERSISTENT, 0, @gotFS, @fail)
    
    gotFS: (fileSystem) =>      
        backpackDirectory = fileSystem.root.getDirectory("backpack",
                                                            {create: true, exclusive: false},
                                                            @traverseBackpackDirectory, @fail)
    
    traverseBackpackDirectory: (backpackDirectory) =>
        reader = backpackDirectory.createReader();
        reader.readEntries(@convertEntriestoFiles, @fail);

    convertEntriestoFiles: (entries) =>
        for entry in entries
            entry.file(@gotFile, @fail) if entry.isFile     #Convert file entry to actual file object                                                             

    
    gotFile: (file) =>
        if(file.type.match('image') != null \     #Only support images currently
        and file.name[0] != '.' \                 #Ignore junk files
        and Math.floor(file.size/1000000) < 1)    #Ignore files larger than 1MB (TODO: Find some way to handle these files)
            @readDataUrl(file)
    
    readDataUrl: (file) =>
        reader = new FileReader
        reader.onloadend = @processFile
        reader.readAsDataURL(file)
    
    processFile: (evt) =>
        fileName = evt.target.fileName.match(/\/*([^/]*)$/)[1]
        base64Image = evt.target.result            
        id = @getNewGridElementId()    
        $('#image_' + id).attr('src', base64Image)
        $('#image_' + id).click(-> new Sync().upload(base64Image))  #Upload on click for now
        $('#span_'  + id).text(fileName)
    
    getNewGridElementId: () =>
        new_element = "<div class='ui-block-" + blockMap[currentGridPosition++ % 2] + "'>" + 
                      "<img id='image_" + currentImageId + "' />" + 
                      "<span id='span_" + currentImageId + "'></span></div>"
        $('#main-data-grid').append(new_element)
        return currentImageId++
        
    fail: (evt) =>
        console.log(evt.target.error.code)

    processLogin: () => 
        if window.localStorage.getItem("loggedIn") == "true"
            button = $('#login-button .ui-btn-text')
            button.text("Logout")
            $('#login-button').attr("href", "#")
            $('#login-button').click(->
                new Sync().logout()
            )
        else
            button = $('#login-button .ui-btn-text')
            button.text("Login")
            $('#login-button').attr("href", "login.html")