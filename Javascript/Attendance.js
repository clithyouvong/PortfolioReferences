  
/*
  This code demonstrates a AJAX call to a Server object using Javascript Ecmascript 5 and Jquery.
 
  This implementation is a stripped down version of a current implementation and should be considered 'gibberish' 
  when out of context. 
  
  This code is intended to be used as a 'copy and paste reference' when developing new systems and should be used as 'baseline'
*/


        /*-- ----------------------------------
        -- Function:    AddSelectSection(mode, sender, xmlData = null)
        -- Mode:        String, denotes what column to apply the actions to
        -- Sender:      The selector on the row and column
        -- xmlData:     optional, AJAX HTML data that is being passed from another 
                        AJAX function
        -- Description: Calls the corresponding webservice to bring back HTML. 
        --              Optionally, if data has already been saved to the form, 
        --              rerender that information after append(). If the data has 
        --              more than 1 saved set, render them by passing the saved set to 
        --              AddAnotherSelectSelection(). 
        -- Debug:
        --      console.log("original string: [" + str + "], strarrif: [" + strarrif + "], strarriffirst: [" + strarriffirst + "]");
        ---------------------------------- --*/
        function AddSelectSection(mode, sender, xmlData = null) {
            var parentObj = $(sender).parent();
            var labelObj = $(parentObj).children('span');

            $(labelObj).hide();
            $(sender).hide();

            var classId2 = $('someid').val();
            var courseId2 = $(sender).parent().parent().find('input[type=hidden][id*=gcCourseId]').val();
            if (courseId2 == undefined) courseId2 = $('someid').val();
            
            $.ajax({
                url: "someurl.aspx/GetNewTableRowForSelctions",
                type: "POST",
                contentType: "application/json; charset=utf-8",
                data: JSON.stringify({
                    courseId: courseId2,
                    classId: classId2
                }),
                dataType: "json",
                success: function (result) {
                    $(sender).parent().append(result.d);

                    // Grabs data from Associated TD HF
                    var str = $(sender).parent().find('input[type=hidden][id*=rp' + mode +'Value]').val();

                    // If data exists, render it
                    if (str.length > 0) {
                        var strarrif = str.split(',');
                        var strarriffirst = strarrif[0].split(':');

                        // Render data 1
                        $(sender).parent().find('.' + mode + 'Selector').each(function () {
                            $(this).val(strarriffirst[0] + ":" + strarriffirst[1]);
                            SelectSelectorShowInput(mode, this, strarriffirst[2]);
                            if (strarriffirst.length > 3) SelectTypeSelector(mode, this, strarriffirst[3]);
                        });

                        // If more than 1, render Render data 2 and 3?
                        if (strarrif.length > 1) {
                            AddAnotherSelectSection(mode, $(sender).parent().find('table tr:first-child td.rp' + mode + mode + 'TdWrapper img'), strarrif[1]);

                            // If more than 2, render data 3
                            if (strarrif.length === 3) {
                                AddAnotherSelectSection(mode, $(sender).parent().find('table tr:first-child td.rp' + mode + mode + 'TdWrapper img'), strarrif[2], true);
                            }

                            // If more than 3, render data 4
                            else if (strarrif.length === 4) {
                                AddAnotherSelectSection(mode, $(sender).parent().find('table tr:first-child td.rp' + mode + mode + 'TdWrapper img'), strarrif[2], true);
                                AddAnotherSelectSection(mode, $(sender).parent().find('table tr:first-child td.rp' + mode + mode + 'TdWrapper img'), strarrif[3], true);
                            }

                            // If more than 4, render data 5
                            else if (strarrif.length === 5) {
                                AddAnotherSelectSection(mode, $(sender).parent().find('table tr:first-child td.rp' + mode + mode + 'TdWrapper img'), strarrif[2], true);
                                AddAnotherSelectSection(mode, $(sender).parent().find('table tr:first-child td.rp' + mode + mode + 'TdWrapper img'), strarrif[3], true);
                                AddAnotherSelectSection(mode, $(sender).parent().find('table tr:first-child td.rp' + mode + mode + 'TdWrapper img'), strarrif[4], true);
                            }
                        }

                        // Resets the Associated HF to prevent invalid duplication
                        $(sender).parent().find('input[type=hidden][id*=rp' + mode + 'Value]').val("");
                    }

                    // If this function is being called from another function and that
                    // the xmlData is present and that the total rows on the TABLE are 
                    // less than 5 and that the HF STR is less than 5, add the xmlData 
                    // HTML TR to the associated TD TABLE. This section is triggered by 
                    // Global Adds
                    if (xmlData != null && $(sender).parent().find('table tr').length < 5 && str.split(',').length < 5) {
                        var strarrxmldata = str.split(',');

                        // Sets the Associated TD's '-' state
                        if (strarrxmldata.length >= 2) {
                            $(sender).parent().parent().parent().find('.' + mode + mode + 'TdWrapper').hide();
                        }
                        else if (strarrxmldata.length === 1) {
                            $(sender).parent().find('table tr:first-child td.rp' + mode + mode + 'TdWrapper').hide();
                        }

                        // Renders the HTML and sets the Data 
                        $(sender).parent().find('table tbody').append(xmlData);
                        $(sender).parent().find('.' + mode + 'Selector').last().val($('th[id*=rp'+mode+'TH] .' + mode + 'Selector option:selected').val());
                        SelectSelectorShowInput(mode, $(sender).parent().find('.' + mode + 'Selector').last());
                    }
                },
                error: function (jqXhr, exception) {
                    alert(DisplayMessage(jqXhr, exception));
                },
                failure: function(response) {
                    alert(response.d);
                }
            });
        }

        /*-- ----------------------------------
        -- Function:    AddAnotherSelectSection(mode, sender, stringvalue = "")
        -- Mode:        String, denotes what column to apply the actions to
        -- Sender:      The selector on the row and column
        -- Description: Calls the corresponding webservice to bring back HTML. 

        ---------------------------------- --*/
        function AddAnotherSelectSection(mode, sender, stringvalue = "", showPlusButton = false) {
            var classId2 = $('someid').val();
            var courseId2 = $(sender).parent().parent().parent().parent().parent().parent().find('input[type=hidden][id*=gcCourseId]').val();
            if (courseId2 == undefined) courseId2 = $('someid').val();

            $.ajax({
                url: "someurl.aspx/GetNewTableRowForSelctions",
                type: "POST",
                contentType: "application/json; charset=utf-8",
                data: JSON.stringify({
                    courseId: courseId2,
                    classId: classId2
                }),
                dataType: "json",
                success: function (result) {
                    // mode occurs when being rendered by Global
                    if (stringvalue === "all") {
                        // Grabs the selector value of global
                        var selectedValue = $.trim($(sender).parent().parent().find('.' + mode + 'Selector option:selected').val());

                        // If selected, render on each row
                        if (selectedValue.length > 0) {
                            $('.rp' + mode + 'GlobalTd').each(function () {
                                // Grabs the Data from HF of the associated TD
                                var exisitingEntries = $(this).find('input[type=hidden][id*=rp' + mode + 'Value]').val();

                                // If data is present, past the rendered HTML
                                if (exisitingEntries.length > 0) {
                                    AddSelectSection(mode, $(this).find('a'), result.d);
                                    // No data is present, render as new entry on associated TD
                                } else {
                                    if ($(this).find('table tr').length < 5) {
                                        // table exists on the page; add the result
                                        if ($(this).find('table').length > 0) {
                                            $(this).find('table tbody').append(result.d);
                                            // table does not exist; render as new
                                        } else {
                                            //Renders the table as new
                                            $(this).append(
                                                "<table class='rp" + mode + "Table' style='display:inline;'><tbody>" +
                                                result.d +
                                                "</tbody></table>"
                                            );

                                            // Sets proper '-' and '+' modes
                                            $(this).find('table').remove().prependTo(this);
                                            $(this).find('table img[src*=circle_minus]').parent().hide();
                                        }

                                        // Set the proper Value and visibilities
                                        $(this).find('tr').last().find('.' + mode + 'Selector').each(function () {
                                            $(this).val(selectedValue);
                                            SelectSelectorShowInput(mode, this);
                                        });

                                        $(this).find('td.rp' + mode + mode + 'TdWrapper').hide();
                                        if ($(this).find('tr').length < 5)
                                            $(this).find('tr:last-child td.rp' + mode + mode + 'TdWrapper').show();
                                    }

                                    // Hides the Anchor and Span
                                    $(this).find('span[id*=rp' + mode + ']').hide();
                                    $(this).find('a').hide();
                                }
                            });
                        }
                    }
                    // Mode occurs when being rendered on the associated TD
                    else {
                        // Appends the new HTML TR
                        $(sender).parent().parent().parent().append(result.d);

                        // toggles the '+' that was just used
                        $(sender).parent().css('display', 'none');

                        // 2018 JAN
                        // fixes issue of hiding the '+' if more than 1 and less than max records
                        if (showPlusButton) {
                            var obj = $(sender).parent().parent().parent();
                            $(obj).find('td.rp' + mode + mode + 'TdWrapper').hide();
                            $(obj).find('tr:last-child td.rp' + mode + mode + 'TdWrapper').show();
                        }

                        // If data has been passed in, render it. Happens when the 
                        // Associated TD has data and was rendered individually
                        if (stringvalue.length > 0) {
                            var strarr = stringvalue.split(':');

                            $(sender).parent().parent().parent().find('tr:last-child .' + mode + 'Selector').each(function () {
                                $(this).val(strarr[0] + ":" + strarr[1]);
                                SelectSelectorShowInput(mode, this, strarr[2]);
                                if (strarr.length > 3) SelectTypeSelector(mode, this, strarr[3]);
                            });
                        }

                        //Sets the Maximum limit to 5
                        if ($(sender).closest('tbody').children('tr').length === 5 || $(sender).parents('table.rpExamsTable').find('tr').length === 5) {
                            $(sender).parent().parent().parent().find('td.rp' + mode + mode + 'TdWrapper').hide();
                        }
                    }
                },
                error: function (jqXhr, exception) {
                    alert(DisplayMessage(jqXhr, exception));
                },
                failure: function (response) {
                    alert(response.d);
                }
            });
        }
        

        /*-- ----------------------------------
        -- Function:    RemoveAnotherSelectSection(mode, sender) 
        -- Mode:        String, denotes what column to apply the actions to
        -- Sender:      The selector on the row and column
        -- Description: Assumes the '-' button on the TABLE object, 
        --              Removes that ROW and adjusts for the surrounding TRs
        --              to properly show the '-' and '+' functions
        ---------------------------------- --*/
        function RemoveAnotherSelectSection(mode, sender) {
            if ($(sender).parent().parent().next().length <= 0) {
                $(sender).parent().parent().prev().children('td.rp' + mode + mode + 'TdWrapper').css('display', '');
            } else {
                $(sender).parent().parent().next().children('td.rp' + mode + mode + 'TdWrapper').css('display', '');
            }
            $(sender).parent().parent().remove();
        }

        /*-- ----------------------------------
        -- Function:        RemoveSelectSection(mode, sender, validateSender = true)
        -- Mode:            String, denotes what column to apply the actions to
        -- Sender:          The selector on the row and column
        -- validateSender:  TRUE: validation should always happens. assumes the action is done on TD; 
        --                  FALSE: validation should not happen. assumes validation is checked on Global beforehand;
        -- Description:     Validations the TD (Default), Enumerates the associated TABlE and 
        --                  based on the visiblity, sets the values to the SPAN and HF,
        --                  show the associated Anchor tab and remove the associated TABLE
        -- Debug Code:                      
        --      console.log("RemoveSelectSection() Attribute Returns:");
        --      console.log(">  Type value[" + typeValue + "]");
        --      console.log(">  Selector value[" + selectorValue + "] text[" + selectorText + "]");
        --      console.log(">  Passfail value[" + passFailValue + "] text[" + passFailText + "] visible[" + passFailVisible + "]");
        --      console.log(">  Input value[" + inputValue + "] visible[" + inputVisible + "]");
        ---------------------------------- --*/
        function RemoveSelectSection(mode, sender, validateSender = true) {
            if (validateSender) {
                if (!ValidateSelect(mode, sender))
                    return false;
            }
            
            var savedStateValues = new Array();
            var savedStateTexts = "";
            
            $(sender).parent().find('tr').each(function () {
                var selectorText = $.trim($(this).find('.' + mode + 'Selector option:selected').text());
                var selectorValue = $.trim($(this).find('.' + mode + 'Selector option:selected').val());
                var passFailText = $.trim($(this).find('.' + mode + 'PassFailSelector option:selected').text());
                var passFailValue = $.trim($(this).find('.' + mode + 'PassFailSelector option:selected').val());
                var passFailVisible = $(this).find('.rp' + mode + 'PassFailTd').is(":visible"); 
                var typeValue = $.trim($(this).find('.' + mode + 'TypeSelector option:selected').val());
                var inputVisible = $(this).find('.rp' + mode + 'InputTd').is(":visible"); 
                var inputValue = $.trim($(this).find('.' + mode + 'InputSelector').val());
                
                if (inputValue > 100) inputValue = 100;

                if (selectorValue !== "" && ((inputVisible && inputValue !== "") || (passFailVisible && passFailValue !== "")) ) {
                    savedStateValues.push(
                        selectorValue + ":" +
                        ((inputVisible) ? inputValue : passFailValue) +
                        ((typeValue == undefined || typeValue === "") ? "" : ":" + typeValue));

                    savedStateTexts +=
                        ((typeValue == undefined || typeValue === "") ? "" : typeValue + " - ") +
                        selectorText + " - " +
                        ((inputVisible) ? inputValue + "%" : passFailText) +
                        "<br/>";
                }
            }); 
            
            $(sender).parent().find('input[type=hidden][id*=rp' + mode + 'Value]').val(savedStateValues.join(','));
            $(sender).parent().find('span[id*=rp' + mode + ']').html(savedStateTexts).show();
            $(sender).parent().find('a').show();
            $(sender).parent().find('table').remove();
            $(sender).remove();

            return true;
        }

        /*-- ----------------------------------
        -- Function:            SelectSelectorShowInput(mode, sender, inputpassfailvalue = "")
        -- Mode:                String, denotes what column to apply the actions to
        -- Sender:              The selector on the row and column
        -- InputPassFailValue:  Optional, sets the value of the PassFail or Input
        -- Description:         Finds the Table Row selector and parses out the value. 
        --                      (Expects [value:selectormode:type?]). Then based on the selctormode,
        --                      Hide or show either the passfail TD or the input TD. but not both. 
        --                      Optional, we can set the values based on the passed in inputpassfailvalue.
        ---------------------------------- --*/
        function SelectSelectorShowInput(mode, sender, inputpassfailvalue = "") {
            var selectorValue = $(sender).find('option:selected').val().split(':');
            var passFailSelector = $(sender).parent().parent().find('.rp' + mode + 'PassFailTd');
            var inputSelector = $(sender).parent().parent().find('.rp' + mode + 'InputTd');

            if (selectorValue[1] === "score" || selectorValue[1] === "legacy") {
                $(passFailSelector).hide();
                $(inputSelector).show();
            } else if (selectorValue[1] === "passfail") {
                $(passFailSelector).show();
                $(inputSelector).hide();
            } else {
                $(passFailSelector).hide();
                $(inputSelector).hide();
            }

            if (inputpassfailvalue !== "") {
                $(passFailSelector).find('.' + mode +'PassFailSelector').val($(passFailSelector).is(':visible') ? inputpassfailvalue : "");
                $(inputSelector).find('.'+mode+'InputSelector').val($(inputSelector).is(':visible') ? inputpassfailvalue : "");
            }
        }

        /*-- ----------------------------------
        -- Function:            SelectTypeSelector(mode, sender, value)
        -- Mode:                String, denotes what column to apply the actions to
        -- Sender:              The selector on the row and column
        -- Value:               The 'Mode' / 'Type' Value to set this to.
        -- Description:         Finds the Type Selector of the given sender, and sets the Type accordingly.
        ---------------------------------- --*/
        function SelectTypeSelector(mode, sender, value) {
            var typeSelector = $(sender).parent().parent().find('.' + mode + 'TypeSelector');

            if (typeSelector != undefined) {
                $(typeSelector).val(value);
            }
        }

        /*-- ----------------------------------
        -- Function:    DisplayMessage(jqXhr, exception)
        -- jqXhr:       Jquery Handler
        -- exception:   Browser DOM
        -- Description: displays a message to the user when AJAX calls encouter an error
        ---------------------------------- --*/
        function DisplayMessage(jqXhr, exception) {
            var msg;

            if (jqXhr.status === 0) {
                msg = 'System has detected no connection to the network protocol. Please verify your Network access.';
            } else if (jqXhr.status === 404) {
                msg = 'System has encountered an unknown response. Please contact  IT Support. Requested page not found. [404]';
            } else if (jqXhr.status === 500) {
                msg = 'System has been altered. Please reload the page to continue. Internal Server Error [500].';
            } else if (exception === 'parsererror') {
                msg = 'System has failed. Please contact  IT Support. Requested JSON parse failed.';
            } else if (exception === 'timeout') {
                msg = 'System detects that you are no longer logged in. Please login again. Time out error.';
            } else if (exception === 'abort') {
                msg = 'System has aborted the Ajax request. Please reload the page and try again. ';
            } else {
                msg = 'System has detected an uncaught Error. \r\n ' +
                    'Please reload the page and try again. If this message continues to occur, please contact  IT Support. \r\n' +
                    jqXhr.responseText;
            }

            return msg;
        }
