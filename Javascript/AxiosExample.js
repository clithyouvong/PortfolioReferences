
function DoFile(fileId, fileName, filePath, fileUrl, currentCount, fileArrlength){
    // update the database saying it's downloading
    return axios.post('https://www.example.org/Webservices/Software.asmx/SetFileAsRequested', {
        'Identifier': Identifier,
        'computerIdentifier' : computerIdentifier,
        'fileId': fileId
    })
    .then(function (response) {
        console.log('DoFile: ' + fileName + " Started");
        AddMessageToDownloadLog('Requesting File: ' + fileName + ' from Server...');

        // Set the Current file in Current Progress Bar    
        $('progressBarCurrentItem').html(fileName);   

        console.log('DoFile: ' + fileName + ' downloadFile Started');
        
        // download the current file. log the progress to the screen
        downloadFile(filePath + fileUrl, "./SRC/" + fileUrl, 'progressBarCurrent', fileName, fileId, currentCount++, fileArrlength);

        console.log('DoFile: ' + fileName + ' downloadFile done');
    })
    .then(function (response){
        console.log('DoFile: ' + fileName + ' returning now!');
    })
    .catch(function (error) {
        console.log(error)
        AddMessageToDownloadLog(error);
    });
}