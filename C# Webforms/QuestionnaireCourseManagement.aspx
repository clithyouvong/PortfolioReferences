/*
  This is the Questionnaire System used to edit Questionnaire Course or Project level groupping.
  
  The following code demonstrates a typical implementation of the front-end code done in C# ASP.NET 4.5 Webforms and Twitter Bootstrap 3
  
  This is not a copy of any current implementation of any company but rather a demonstration of how things 
  were initially scaffolded during the design phrase.

  
  Order of Implementation:
    - References
    - Any inline CSS
    - Heading Section
    - Search Criteria
    - Controls Criteria
    - Main Content Criteria
    - Popup / Views Criteria
    - Any inline Scripts
    
  Dependencies:
    - Company Specific User Controls
*/


<%@ Page Title="" Language="C#" MasterPageFile="~/bst-Web.master" AutoEventWireup="true" CodeFile="QECourse.aspx.cs" Inherits="ServicesQECourse" ValidateRequest="false"  %>
<%@ Register TagPrefix="N" TagName="Heading" Src="~/Global/Controls/NHeading.ascx" %>
<%@ Register TagPrefix="cc2" Namespace="N.WebControls" Assembly="WebControls" %>

<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolderHeader" Runat="Server">
    <style type="text/css">
        /* Search CSS */
        div[id*=pnlSearch] table tr td:first-child {
            white-space: nowrap;
        }
        div[id*=pnlSearch] table tr td:nth-child(2) input[type=text],
        div[id*=pnlSearch] table tr td:nth-child(2) select {
            width: 100%; max-width: 300px;
        }

        /* Gridview CSS */
        .table tbody tr:hover { background-color: beige; }
        .table table tbody tr:hover { background-color: whitesmoke; }


        /* Modal (fix style) */
        .modal-header,
        .modal-footer {
            padding: 3px;
        }
        .modal-header {
            font-weight: bold;
            font-size: large;
        }

        
        /* Panel (fix style) */
        .panel-heading,
        .panel-body,
        .panel-footer {
            padding: 3px;margin: 0;
        }
        .panel-heading {
            font-size: large;font-weight: bold;
        }
        .panel-heading table tr td:last-child {
            text-align: right;
        }
        .panel-heading table {
            width: 100%;
        }
        .panel-heading table tr td:first-child {
            vertical-align: top;
            white-space: nowrap;
        }
        .panel-heading table tr td:last-child {
            text-align: right;
            vertical-align: top;
        }
        .panel-heading table select,
        .panel-heading table input[type=text] {
            width: 100%;
            max-width: 150px;
        }
    </style>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolderBody" Runat="Server">
    <asp:ScriptManager runat="server" />
    
    <%-----------------------------
    -- Header
    -----------------------------%>
    <asp:Panel runat="server" ID="pnlHeader" CssClass="hidden-print">
        <N:Heading runat="server" HeadingLabel="Questionnaire Editor v4" HeadingHyperlink="~/Services/QECourse.aspx" />
        <cc2:MessageBox ID="MessageBox1" runat="server" width="100%" />
    </asp:Panel>
    
    
    <%---------------------------------
    -- Context
    -- Written by Colby Lithyouvong
    -- 2019 Mar
    ---------------------------------%>
    <asp:Panel ID="pnlContent" runat="server">
        Use this system to design Questionnaires. If you have any questions please contact IT support at ITStaff@domain.org or by phone at (800) 000 - 0000.
    </asp:Panel>
    
    <%----------------------------------
    -- SEARCH
    ----------------------------------%>
    <asp:Panel runat="server" ID="pnlSearch">
        <table>
            <tr>
                <td>Course: </td>
                <td>
                    <asp:TextBox runat="server"
                                    ID="SearchCourse"
                                    EnableViewState="True"
                                    placeholder="[Course...]"
                                    AutoCompleteType="None" 
                                    autocomplete="off" />
                </td>
            </tr>
            <tr>
                <td>Course Types: </td>
                <td>
                    <asp:DropDownList runat="server"
                                        ID="SearchCourseType"
                                        EnableViewState="True"/>
                </td>
            </tr>
            <tr>
                <td>Status: </td>
                <td>
                    <asp:DropDownList runat="server"
                                        ID="SearchStatus"
                                        EnableViewState="True">
                        <asp:ListItem Text="Both Active and Inactive" Value="-1"/>
                        <asp:ListItem Text="Active" Value="1"/>
                        <asp:ListItem Text="Inactive" Value="0"/>
                    </asp:DropDownList>
                </td>
            </tr>
                </table>
    </asp:Panel><br/>
    
    <%---------------------------------------------- 
    -- Controls
    ----------------------------------------------%>
    <asp:Panel runat="server" ID="pnlControls">
        <div id="pnlControlsControls">
            <asp:Button runat="server" ID="SearchSearch" OnClick="SearchSearch_OnClick" Text="Search" OnClientClick="ToggleWaitToLoad2('Search');"/>
            <asp:Button runat="server" ID="SearchReset" OnClick="SearchReset_OnClick" Text="Reset" OnClientClick="ToggleWaitToLoad2('Search');"/>
            <span style="margin-right: 20px;">&nbsp;</span>

            <asp:Button runat="server" ID="ControlsCreate" Text="Create Course..." OnClick="ControlsCreate_OnClick" OnClientClick="ToggleWaitToLoad2('Search');"/>

            <asp:Button runat="server" ID="ControlsExport" Text="Export" OnClick="ControlsExport_OnClick" Visible="False"/>
        
            <asp:Literal runat="server" ID="ControlsStats"/>            
        </div>

        <span id="SearchWaitToLoad"></span>
    </asp:Panel><br/>
   
    
    <%---------------------------------------------- 
    -- gv
    ----------------------------------------------%>
    <h2>Courses: </h2>
    <div style="overflow: auto; overflow-x: auto; overflow-y: auto;max-width: 1500px;">
        <asp:GridView runat="server" 
                      ID="gvCourses"
                      AutoGenerateColumns="False" 
                      ShowHeaderWhenEmpty="True"
                      UseAccessibleHeader="True"
                      HeaderStyle-BackColor="MidnightBlue"
                      HeaderStyle-ForeColor="ghostwhite"
                      CssClass="table table-bordered table-condensed"
                      EmptyDataText="No Records Found."
                      OnRowDataBound="gvCourses_OnRowDataBound" 
                      OnRowCommand="gvCourses_OnRowCommand">
            <Columns>
                <asp:TemplateField >
                    <ItemTemplate>
                        <asp:Literal runat="server" ID="gcBackgroundColor"/>&nbsp;
                    </ItemTemplate>
                </asp:TemplateField>

                <asp:BoundField DataField="CourseType" HeaderText="Type" ItemStyle-Width="75" ItemStyle-Wrap="False"/>
                <asp:BoundField DataField="Course" HeaderText="Course" ItemStyle-Width="75" ItemStyle-Wrap="False"/>
                <asp:CheckBoxField DataField="Status" HeaderText="Status" ItemStyle-Width="50" ItemStyle-Wrap="False" />
                
                <asp:TemplateField HeaderText="Sections" ItemStyle-Wrap="False">
                    <ItemTemplate>
                        <table class="table table-bordered table-condensed">
                            <tbody>
                                <asp:Literal runat="server" ID="gcSections"/>
                            </tbody>
                        </table>
                    </ItemTemplate>
                </asp:TemplateField>

                <asp:TemplateField ItemStyle-Width="110" ItemStyle-Wrap="False">
                    <ItemTemplate>
                        <asp:HiddenField runat="server" ID="gcCourseId"/>
                        
                        <table class="table table-bordered table-condensed">
                            <tr>
                                <td>
                                    <asp:LinkButton runat="server" 
                                                    ID="gcModifyCourse"
                                                    Text=" Edit"
                                                    CssClass="glyphicon glyphicon-edit"
                                                    aria-hidden="true"
                                                    OnClientClick="$('table[id*=gvCourses] a').hide();ToggleAppendObject($('table[id*=gvCourses] a').parent());"
                                                    style="text-decoration: underline;"
                                                    CommandName="gcModifyCourse"
                                                    CommandArgument="<%# Container.DataItemIndex %>"/>                                    
                                </td>
                            </tr>
                            <tr>
                                <td>
                                    <asp:LinkButton runat="server" 
                                                    ID="gcModifySection"
                                                    Text=" Sections"
                                                    CssClass="glyphicon glyphicon-share"
                                                    aria-hidden="true"
                                                    OnClientClick="$('table[id*=gvCourses] a').hide();ToggleAppendObject($('table[id*=gvCourses] a').parent());"
                                                    style="text-decoration: underline;"
                                                    CommandName="gcModifySection"
                                                    CommandArgument="<%# Container.DataItemIndex %>"/>                                    
                                </td>
                            </tr>
                        </table>
                    </ItemTemplate>   
                </asp:TemplateField>
            </Columns>
        </asp:GridView>
    </div>
    
    
    <%--------------------------------------------
    -- Modal    Course
    --------------------------------------------%>
    <div class="modal fade" id="ModalCourse" tabindex="-1" role="dialog" aria-labelledby="ModalCourse" aria-hidden="true">
        <div class="modal-dialog" runat="server" id="ModalCourseDialog">
            <div class="modal-content">
                <div class="modal-header" style="background-color: lightcyan;">
                    <div class="modal-title">
                        <h4>Course Management</h4>
                    </div>
                </div>
                    
                <div class="modal-body">

                    <asp:HiddenField runat="server" ID="ModalCourseCourseId"/>
                    <cc2:MessageBox runat="server" ID="ModalCourseMessageBox"/>

                    <!-- --------------------------------
                    -- Course Type
                    --------------------------------- -->
                    <div class="panel panel-default">
                        <div class="panel-body">
                            <table width="100%">
                                <tr>
                                    <td>Course Type: </td>
                                    <td align="right">
                                        <asp:DropDownList runat="server" ID="ModalCourseCourseType" style="width: 100%; max-width: 250px;"/>
                                    </td>
                                </tr>
                            </table>
                        </div>
                        <div class="panel-footer">
                            <small style="font-style: italic;">
                                If you need a different course type, please contact IT Support. 
                            </small>
                        </div>
                    </div>

                    <!-- --------------------------------
                    -- Course
                    --------------------------------- -->
                    <div class="panel panel-default">
                        <div class="panel-heading">
                            <table width="100%;">
                                <tr>
                                    <td>Course: </td>
                                    <td align="right">
                                        Active: <asp:CheckBox runat="server" ID="ModalCourseStatus"/>
                                    </td>
                                </tr>
                            </table>
                        </div>
                        <div class="panel-body">
                            <asp:TextBox runat="server" ID="ModalCourseCourse" 
                                style="width: 100%; height: 75px; resize: none;" 
                                TextMode="MultiLine"
                                AutoCompleteType="None" 
                                autocomplete="off" 
                                placeholder="[Course..]"
                                onkeypress="return taLimit(this, 500)" 
                                onkeyup="return taCount(this,'ModalCourseCourseCounter', 500)" maxlength="500"/>
                        </div>
                        <div class="panel-footer">
                            You have <strong><span id='ModalCourseCourseCounter'>500</span></strong> characters remaining 
                        </div>
                        <div class="panel-footer">
                            <small style="font-style: italic;">
                                Courses must be unique to the Course Type.
                            </small>
                        </div>
                    </div> 
                            
                    <!-- --------------------------------
                    -- History
                    --------------------------------- -->
                    <div class="panel panel-default" runat="server" id="ModalCourseHistoryWrapper">
                        <div class="panel-heading">
                            <asp:Literal runat="server" ID="ModalCourseHistoryCount"/> History
                        </div>
                        <div class="panel-body">
                            <div style="overflow: auto; overflow-x: auto; overflow-y: auto; max-height: 300px;">
                                <asp:GridView runat="server" 
                                                ID="ModalCourseHistory"
                                                AutoGenerateColumns="True" 
                                                ShowHeaderWhenEmpty="True"
                                                UseAccessibleHeader="True"
                                                HeaderStyle-BackColor="MidnightBlue"
                                                HeaderStyle-ForeColor="ghostwhite"
                                                ItemStyle-Wrap="False"
                                                CssClass="table table-bordered table-condensed"
                                                EmptyDataText="No Records Found."
                                                OnRowDataBound="ModalCourseHistory_OnRowDataBound"/>
                            </div>
                        </div>
                    </div>    
                </div>
                
                <div class="modal-footer" style="background-color: lightcyan;">
                    <table width="100%">
                        <tr>
                            <td align="left">
                                <asp:Button runat="server" 
                                            ID="ModalCourseDelete"
                                            CssClass="btn btn-danger" 
                                            Text="Delete"
                                            OnClick="ModalCourseDelete_OnClick" 
                                            OnClientClick="$('.modal-footer table').hide(); return ToggleContent2('ModalCourse');"/>
                            </td>
                            <td align="right">
                                <button type="button" class="btn btn-default" data-dismiss="modal" >Close</button>

                                <asp:Button runat="server" ID="ModalCourseInsert" Visible="False"
                                            CssClass="btn btn-primary" Text="Create Course"
                                            OnClick="ModalCourseInsert_OnClick" OnClientClick="$('.modal-footer table').hide(); ToggleWaitToLoad2('ModalCourse');"/>

                                <asp:Button runat="server" ID="ModalCourseInsertAndAddSection" Visible="False"
                                            CssClass="btn btn-primary" Text="Create Course and Add Sections"
                                            OnClick="ModalCourseInsertAndAddSection_OnClick" OnClientClick="$('.modal-footer table').hide(); ToggleWaitToLoad2('ModalCourse');"/>

                                <asp:Button runat="server" ID="ModalCourseUpdate" Visible="False" 
                                            CssClass="btn btn-success" Text="Save Changes"
                                            OnClick="ModalCourseUpdate_OnClick" OnClientClick="$('.modal-footer table').hide(); ToggleWaitToLoad2('ModalCourse');"/>                                
                            </td>
                        </tr>
                    </table>
                    
                    <span id="ModalCourseWaitToLoad"></span>
                </div>
            </div>
        </div>
    </div>
    
    <script type="text/javascript" src="<%=ResolveUrl("~/Global/Javascript/jquery.autosize.min.js") %>"></script>
    <script type="text/javascript">
        function ToggleWaitToLoad2(obj) {
            if (obj.includes('Modal')) {
                $('.modal-footer table').hide();
            }
            if (obj === 'Search') {
                $('#pnlControlsControls').hide();
            }

            ToggleAppendObject2("span[id*=" + obj + "WaitToLoad]");
        }
        

        function ToggleAppendObject2(obj) {
            $(obj).html(
                $('<img>',
                    {
                        src: '<%= ResolveUrl("~/Images/loading_blue.gif") %>',
                        alt: '[Please Wait!... Do not refresh or reload the page...]',
                        style: 'width: auto;height: 100%;max-height: 25px;'
                    })
            );
        }

        function ToggleContent2(obj) {
            if (confirm("Are you sure you want to delete this? Once deleted, you won't be able to recover it.")) {
                ToggleWaitToLoad2(obj);

                return true;
            } else {
                return false;
            }
        }
    </script>
    <script type="text/javascript">
        //-------------------------------------------------------+
        // CHARACTER COUNTER CODE
        //DHTML textbox character counter script. Courtesy of SmartWebby.com (http://www.smartwebby.com/dhtml/)
        //-------------------------------------------------------+
        var bName = navigator.appName;

        function taLimit(taObj, maxLength) {
            if (taObj.value.length === maxLength) return false;
            return true;
        }

        function taCount(taObj, cnt, maxLength) {
            var objCnt = createObject(cnt);
            var objVal = taObj.value;
            if (objVal.length > maxLength) objVal = objVal.substring(0, maxLength);
            if (objCnt) {
                if (bName === "Netscape") {
                    objCnt.textContent = maxLength - objVal.length;
                }
                else { objCnt.innerText = maxLength - objVal.length; }
            }
            return true;
        }


        function createObject(objId) {
            if (document.getElementById) return document.getElementById(objId);
            else if (document.layers) return eval("document." + objId);
            else if (document.all) return eval("document.all." + objId);
            else return eval("document." + objId);
        }
        //-------------------------------------------------------+
    </script>
</asp:Content>
