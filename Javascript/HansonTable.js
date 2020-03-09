
var isLoadedData = true;
var hot = null;
var isDoneCount = new Array();

$(document).ready(function () {

    var container = document.getElementById('handsontableContent');

    /*
        EXCEL INITALIZATION

        THIS IS DONE ONCE AND THE OBJECT REMAINS AVAILABLE ONLY AT INITIZATION. 
        var hot, is declared on the outter scope for this reason. 
        (to remain accessible, outside of Document Ready)

        Because there's a glitch in this version where JQuery references 
        to this object are not possible                    
    */
    hot = new Handsontable(container, {
        data: [
            //some data

        ],
        minCols: 16,
        maxCols: 16,
        minRows: 8,
        maxRows: 31,
        colHeaders: [ '', "col1, col2, col3"],
        currentRowClassName: 'currentRow',
        currentColClassName: 'currentCol',
        colWidths: [125, 50,75],
        rowHeaders: false,
        formulas: true,
        contextMenu: false,
        fillHandle: false,

        // RULE-JS DOESN'T LIKE THIS...
        //                columns: [
        //                    { type: 'numeric', format: '0.00' },
        //                    { type: 'numeric', format: '0.00' },
        //                    { type: 'numeric', format: '0.00' },
        //                    { type: 'numeric', format: '0.00' },
        //                    { type: 'numeric', format: '0.00' },

        //                    { type: 'numeric', format: '0.00' },
        //                    { type: 'numeric', format: '0.00' },
        //                    { type: 'numeric', format: '0.00' },
        //                    { type: 'numeric', format: '0.00' },
        //                    { type: 'numeric', format: '0.00' },

        //                    { type: 'numeric', format: '0.00' },
        //                    { type: 'numeric', format: '0.00' },
        //                    { type: 'numeric', format: '0.00' },
        //                    { type: 'numeric', format: '0.00' },
        //                    { type: 'numeric', format: '0.00', renderer: negativeValueRenderer }
        //                ],

        //Cells formated for each cell created, checked by if statements below, 
        //      @see API documentation (it really doesn't help)...
        cells: function (row, col, prop) {
            var cellProperties = {};

            //Total Hours
            //  o note: always 1 less, index starts at 0
            //  o restricts the editing of this collumn
            if ((col === 15) || (col === 0) || (row === 0)) {
                cellProperties.readOnly = true;
            }
            
            if (col === 15 && row === 0) {
                //do nothing
            }
            else if (((col === 0) || (row === 0))) {
                cellProperties.renderer = negativeValueRenderer;
            }
            
            //Bottom Most Rows
            //  o note: always 1 less, index starts at 0
            if (row > 0) {
                cellProperties.readOnly = true;
            }

            return cellProperties;
        },


        //Responsible for handling the update schemas after any type of change happens to the spreadsheet
        //      This method is new compared to previous versions of the JS file
        //      Docmentation s heavy except for explaining the life cycle of this program
        /*
            DOM Life cycle workaround
            - HOT is declared, initialized, and prefilled in $(document).ready
            - Prefilled values are coming in from the DB, readily avaliable by $(document).ready
                - instead of defining the entire table verbatum i.e. HOT.data = data, we use the following func:
                    o hot.setDataAtCell([row], [col], [prop]) to fill
                    o DIS: func happens at event:: [edit] not [loaddata]
                    o event:: [edit] triggers DB update / insert
            - Trigger event is set here to prevent the following:
                o to distrigush the diff from events:: 
                    x [edit]
                    x [edit] on load
                    x [loaddata]
            - Since HOT events don't execute until $(document).ready func has completed.
        */
        afterChange: function(changes, source) {


            if (isLoadedData)
                return;

            if (source == "LoadData")
                return;

            if (source === 'edit') {  
                // -- TESTING -- UNCOMMENT TO DEBUG  
                //alert("Changes: " + changes + "\nisLoadedData:" + isLoadedData + "\nsource:" + source);

                $.ajax({
                    type: "POST",
                    url: "someurl/api/UpdateContext",
                    data: '{c: "' + changes + '"}',
                    dataType: 'json',
                    contentType: "application/json; charset=utf-8",
                    success: function(response) {
                        if (response.d != "") {
                            alert("!" + response.d + "\n\nPlease Contact IT Support");
                        }
                    },
                    failure: function(response) {
                        if (response.d != "") {
                            alert("FAILURE: " + response.d + "\n\nPlease Contact IT Support");
                        }
                    },
                    error: function(response) {
                        if (response.d != "") {
                            alert("ERROR: " + response.d + "\n\nPlease Contact IT Support");
                        }
                    }
                });
            }
        }
    });

    function negativeValueRenderer(instance, td, row, col, prop, value, cellProperties) {
        Handsontable.renderers.TextRenderer.apply(this, arguments);

        td.style.background = '#EEE';
    }


    function bindDumpButton() {

        Handsontable.Dom.addEvent(document.body, 'click', function (e) {

            var element = e.target || e.srcElement;

            if (element.nodeName == "BUTTON" && element.name == 'dump') {
                var name = element.getAttribute('data-dump');
                var instance = element.getAttribute('data-instance');
                var hot = window[instance];
                console.log('data of ' + name, hot.getData());
            }
        });
    }
});