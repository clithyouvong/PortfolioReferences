
const electron = require('electron');
const process = require('process');
const {app, BrowserWindow, Menu, ipcMain, shell} = electron;
const {download} = require("electron-dl");

const axios = require('axios');  
const exec = require('child_process').exec;
const fs = require('fs');
const isDev = require('electron-is-dev');
const machineId = require('node-machine-id');

const Iac = process.platform == 'darwin';

global.IIdentifier;
global.ComputerIdentifier;
global.Version;
global.indexjson = './index.json';
global.indexConfig = './indexConfig.json';

let mainWindow;
let loginWindow;
let downloaderWindow;
 
CreateConfigurationFile();
OpenPfx();

// *******************************
// Windows
// *******************************
// -------------------
// Main Window
function CreateMainWindow(){
    mainWindow = new BrowserWindow({
        webPreferences: {
            nodeIntegration: true
        }, 
        width: 800,
        height: 600,
        minWidth: 800,
        minHeight: 600
    });
    mainWindow.on('closed', () => {
        CloseApp();
    })
    mainWindow.on('uncaughtException', function(err) {
        // handle the error safely
        console.log(err)
    })

    mainWindow.loadURL('file://' + __dirname + '/Views/main.html'); 
    
    let template = [
        {
          label: 'File',
          submenu: [
            {
                label: 'Download Latest Updates',
                click(){
                    CreateDownloaderWindow('');
                }
            },
            { type: 'separator' },
            Iac ? { role: 'close' } : { role: 'quit' }
          ]
        },
        {
            label: 'Help',
            submenu: [
                {
                    label: 'Download Adobe',
                    click(){
                        CreateAdobeDownloadDialog();
                    }
                }
            ]
        }
    ];
    if(isDev){
        template.push(AddDevTools());

        Menu.setApplicationMenu(Menu.buildFromTemplate(template));
    }else{
        Menu.setApplicationMenu(Menu.buildFromTemplate(template));
    }
}

// -------------------
// Downloader Window
function CreateDownloaderWindow(){
    downloaderWindow = new BrowserWindow({
        webPreferences: {
            nodeIntegration: true
        }, 
        width: 800,
        height: 600,
        resizable: false,
        frame: false
    });
    downloaderWindow.loadURL('file://' + __dirname + '/Views/downloader.html'); 
    downloaderWindow.setMenuBarVisibility(false);
}


// -------------------
// Login Window
function CreateLoginWindow(){
    loginWindow = new BrowserWindow({
        webPreferences: {
            nodeIntegration: true
        }, 
        width: 400,
        height: 600,
        resizable: false
    });
    loginWindow.loadURL('file://' + __dirname + '/Views/login.html');


    
    let template = [];
    if(isDev){
        template.push(AddDevTools());

        Menu.setApplicationMenu(Menu.buildFromTemplate(template));
    }else{
        if($.isEmptyObject(template)) {
            loginWindow.setMenuBarVisibility(false);
        }else{
            Menu.setApplicationMenu(Menu.buildFromTemplate(template));
        }        
    }
}

// Adobe Dialog
function CreateAdobeDownloadDialog(){
    mainWindow.webContents.send('Main.CreateAdobeDownloadDialog');
}





// *******************************
// Handlers
// *******************************
app.on('ready', function(){
    CreateLoginWindow();
});

app.on('window-all-closed', () => {
    CloseApp();
})

ipcMain.on('Index.LoadMainWindow', function(){
    loginWindow = null;
    
    CreateMainWindow();
});

ipcMain.on('Index.LoadDownloaderWindow', function(){
    CreateDownloaderWindow();
});

ipcMain.on('Index.WriteConfigurationVersion', function(e, item){
    WriteConfigurationVersion(item);
});

ipcMain.on('Index.RefreshMainWindow', function(){
    mainWindow.webContents.send('Main.RefereshMainWindow');
});

ipcMain.on("Index.Download", (event, info) => {
    info.properties.onProgress = status => window.webContents.send("download progress", status);
    download(BrowserWindow.getFocusedWindow(), info.url, info.properties)
        .then(dl => window.webContents.send("download complete", dl.getSavePath()));
});




// *******************************
// Functions
// *******************************
function CloseApp(){
    RemovePfx();

    app.quit();
}

function CreateConfigurationFile() {    
    fs.readFile(global.indexjson, 'utf8', function (err, data) {
        let obj = JSON.parse(data);
        
        if(obj['IIdentifier'] == undefined || obj['IIdentifier'] == '') { 
            let val = uuidv4()
            obj["IIdentifier"] = val;
            global.IIdentifier = val;
        }else{
            global.IIdentifier = obj['IIdentifier'];
        }

        if(obj['ComputerIdentifier'] == undefined || obj['ComputerIdentifier'] == '') { 
            let val = machineId.machineIdSync(); 
            obj["ComputerIdentifier"] = val;
            global.ComputerIdentifier = val;                 
        }else{
            global.ComputerIdentifier = obj['ComputerIdentifier'];
        }

        if(obj['LastLogin'] == undefined || obj['LastLogin'] == '') { obj["LastLogin"] = ''; }

        if(obj['Version'] == undefined || obj['Version'] == '') {
            obj["Version"] = ''; 
            global.Version = "";
        }
        else{
            global.Version = obj["Version"];
        }

        let json = JSON.stringify(obj);
    
        if(json.length > 0){
            fs.writeFile(global.indexjson, json, function(err) {
                if(err) {
                    console.log(err);
                }
            });            
        }
    });
    
    fs.exists(global.indexConfig, function (exists) {
        if(exists){ }
        else {
            fs.writeFile(global.indexConfig, '', function (err, data)  {  });
        }
    });
}

function WriteConfigurationVersion(version){    
    fs.readFile(global.indexjson, 'utf8', function (err, data) {
        let obj = JSON.parse(data);
        obj["Version"] = version; 

        let json = JSON.stringify(obj);
    
        if(json.length > 0){
            fs.writeFile(global.indexjson, json, function(err) {
                if(err) {
                    console.log(err);
                }
            });            
        }
    });
}

function OpenPfx(){
    let file = __dirname + "/Assets/key.pfx";
    let pass = "some key";
    let cmd = 'CERTUTIL -f -user -p "'+pass+'" -importpfx "'+file+'" NoRoot';

    executecmd(cmd, (output) => {
        console.log(output);
    });
};

function RemovePfx(){
    let cmd = 'CERTUTIL -delstore -user My "key"';

    executecmd(cmd, (output) => {
        console.log(output);
    });
}

function executecmd(command, callback) {
    exec(command, (error, stdout, stderr) => { 
        callback(stdout); 
    });
};


/// Used to create a Unique identifier for the program
function uuidv4() {
    return 'xxxxxxxx-xxxx-4xxx-yxxx-xxxxxxxxxxxx'.replace(/[xy]/g, function(c) {
        var r = Math.random() * 16 | 0, v = c == 'x' ? r : (r & 0x3 | 0x8);
        return v.toString(16);
    });
}

function AddDevTools(){
    return {
        label: 'Dev Tools',
        submenu: [
        { role: 'reload' },
        { role: 'forcereload' },
        { role: 'toggledevtools' },
        { type: 'separator' },
        { role: 'resetzoom' },
        { role: 'zoomin' },
        { role: 'zoomout' },
        { type: 'separator' },
        { role: 'togglefullscreen' }
        ]
    };
}


    

