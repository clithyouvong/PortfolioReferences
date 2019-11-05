/*
  This is intended for references only.
  
  This file represents a set of standard helper functions found anywhere on the web.
  
  This file is intended to be reused as a base line to solving additional problems in the future
  
  This code is written in javascript ecmascript 5 using JQuery
*/


function Site_AddToList(checkbox, hf, useValue) {
    /// <summary>
    /// Version 6
    ///
    /// Takes in the Sender's Checkbox and the Hiddenfield managing the List Construction
    /// And modifies that Hiddenfield's List
    /// </summary>
    /// <param name="checkbox" type="Object">input[type=checkbox] the sender checkbox to where this function is targeting</param>
    /// <param name="hf" type="Object">input[type=hidden] the hiddenfield to where the list is being constructed</param>
    /// <param name="useValue" type="Boolean">The Method with extract the value of the checkbox instead of a substring of the ID</param>
    var cbxIdVal = (useValue)
        ? $(checkbox).val()
        : $(checkbox).attr('id').substr(3);

    var cbxIsChecked = $(checkbox).attr('checked');
    var hfArray = $(hf).val().split(',');

    if (cbxIsChecked == 'checked') {
        //[list construction]
        hfArray.push(cbxIdVal);
        $(hf).val(hfArray.toString());

        var hfVal1 = $(hf).val();
        if (hfVal1.indexOf(',', 0) == 0) {
            $(hf).val(hfVal1.substring(1));
        }
    } else {
        //[list Deconstruction]
        //NOTE: POP() removes the last index
        //This construction takes apart the hf and does substring manipulation
        var newArray = new Array();
        for (var i = 0; i < hfArray.length; i++) {
            if (hfArray[i] != cbxIdVal) {
                newArray.push(hfArray[i]);
            }
        }
        $(hf).val(newArray.toString());
    }
}

/*********************************************************
Takes in a string and returns true or false wheither the 
date is of valid form
MM/DD/YYYY  MM-DD-YYYY 
M/D/YYYY    M-D-YYYY
MM/D/YYYY   MM-D-YYYY  
M/DD/YYYY   M-DD-YYYY  

- expects <string>
- returns <boolean>
*********************************************************/
function Site_ValidateDate(testdate) {
    var dateRegex = /^(0[1-9]|1[0-2]|[1-9])[-\/](0[1-9]|1\d|2\d|3[01]|\d)[-\/]\d{4}$/;
    return dateRegex.test(testdate);
}


/*********************************************************
Takes in a string and returns true or false wheither the 
email is of valid form

- expects <string>
- returns <boolean>
*********************************************************/
function Site_ValidateEmail(email) {
    var re = /^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$/;
    return re.test(email);
}

/*********************************************************
auto fixes / enforces the value of the textbox to always be 
numeric based on key strokes

- expects OBJECT <input[type=text]> (not an asp control)
- returns N/A, modifies the <input[type=text]>'s value instead
*********************************************************/
function Site_NumericFilter(txb) {
    txb.value = txb.value.replace(/[^\0-9]/ig, "");
}


/*********************************************************
value of a textbox is restricted to this pattern only
[a-zA-Z0-9]

- expects <string>
- returns <boolean>
*********************************************************/
function Site_ValidateAlphanumeric(value) {
    var dataRegex = "/[^a-zA-Z0-9]/";
    return dataRegex.test(value);
}

/*********************************************************
value of a textbox is restricted to this pattern only
[0-9]

- expects <string>
- returns <boolean>
*********************************************************/
function Site_ValidateNumeric(testStr) {
    var dataRegex = /^\d+$/;
    return dataRegex.test(testStr);
}
