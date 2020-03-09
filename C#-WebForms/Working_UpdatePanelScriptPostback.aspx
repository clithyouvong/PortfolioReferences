
<%@ Page Title="" Language="C#" MasterPageFile="~/Web.master" AutoEventWireup="true" CodeFile="DemoCourse.aspx.cs" Inherits="ServicesDemoCourse" ValidateRequest="false"  %>
<%@ Register TagPrefix="N" TagName="Heading" Src="~/Global/Controls/NHeading.ascx" %>

<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolderHeader" Runat="Server">
    <script type="text/javascript" language="javascript">
        var pageRequestManager = Sys.WebForms.PageRequestManager.getInstance();
        pageRequestManager.add_endRequest(dothis);

        function dothis() {
            //do something
        }
    </script>
</asp:Content>
