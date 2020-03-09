 
let $ = require('jquery');
let axios = require('axios');  
const fs = require('fs'); 
require('popper.js');
require('bootstrap');   

const electron = require('electron');
const {ipcRenderer, shell, remote} = electron;

// Grab the Identifiers 
var filename = remote.getGlobal('indexjson');
var Identifier = remote.getGlobal('Identifier');
var computerIdentifier = remote.getGlobal('ComputerIdentifier');

function ToggleWaitToLoad(obj) {
    ToggleAppendObject("span[id*=" + obj + "WaitToLoad]");
}

function ToggleAppendObject(obj) {
    $(obj).html(
        $('<img>',
            {
                src: '../Assets/loading_blue.gif',
                alt: '[Please Wait!... Do not refresh or reload the page...]',
                style: 'width: auto;height: 100%;max-height: 25px;'
            })
    );
}

function OpenRegistrationPage(){
    shell.openExternal('https://www.example.org/bst-UserInfo.aspx');                
}

function LoginPassword_OnEnterKeyPress(e){
    if(e.keyCode === 13){
        e.preventDefault(); // Ensure it is only this code that rusn

        LoginSubmit_OnClick();
    }
}        

function LoginSubmit_OnClick(){
    $('#LoginErrorMessage').html('').attr('class', '').attr('style','');
    $('#LoginSubmit').hide(); 
    ToggleWaitToLoad('LoginSubmit');

    //Login
    axios.post('https://www.example.org/Webservices/Software.asmx/Login', {
        'username': $.trim($('#LoginUsername').val()),
        'password': $.trim($('#LoginPassword').val())
    })
        .then(function (response) {
            var msg = response.data.d;
            
            if(!msg.startsWith('Good')){
                $('#LoginErrorMessage').html(msg).attr('class', 'alert alert-warning').attr('style','display:block;');
                $('#LoginSubmit').show(); 
                $('#LoginSubmitWaitToLoad').html('');
            }
            else{
                axios.post('https://www.example.org/Webservices/Software.asmx/LoginUpdate', {
                    'loginid': msg.replace("Good", ""),
                    'Identifier': Identifier,
                    'computerIdentifier' : computerIdentifier
                })
                .then(function (response) {
                    fs.readFile(filename, 'utf8', function (err, data) {
                        if (err){ console.log(err); }        
                        else{
                            let obj = JSON.parse(data);
                            obj["LastLogin"] = new Date().toJSON().slice(0,10).replace(/-/g,'/');                                        
                            var json = JSON.stringify(obj);
                        
                            fs.writeFile(filename, json, function(err) {
                                if(err) {
                                    console.log(err);
                                }
                            });
                        }  
                    });

                    ipcRenderer.send('Index.LoadMainWindow');

                    window.close();
                })
                .catch(function (error) {console.log(error)});
            }
        })
        .catch(function (error) {
            $('#LoginErrorMessage').html(error).attr('class', 'alert alert-danger').attr('style','display:block;');
            $('#LoginSubmit').show(); 
            $('#LoginSubmitWaitToLoad').html('');
            console.log(error);
        });
}   