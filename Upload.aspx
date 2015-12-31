<%@ Page Language="C#" AutoEventWireup="true" CodeFile="Upload.aspx.cs" Inherits="Upload" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
    <title></title>
    <link href="css/Page.css" rel="stylesheet" />
</head>
<body>
    <script language="javascript" type="text/javascript" src="/js/jq/jquery-1.11.3.js"></script>
    <form id="form1" runat="server">
        <div style="overflow: hidden;">
            <div style="padding: 10px 0px 0px 10px;">
                <asp:FileUpload ID="FileUpload1" runat="server" />
            </div>
            <div style="padding: 10px 0px 0px 10px;">
                <%
                    if (gstrType.StartsWith("image")) {
                %>
                <img alt="" height="120" src="<%=gstrPath%>" />
                <%
                    }
                %>
            </div>
        </div>
    </form>
    <script language="javascript" type="text/javascript">
        if (parent.document.getElementById("UploadDialog_Info")) parent.document.getElementById("UploadDialog_Info").innerHTML = "<%=gstrMessage%>";
        if (parent.document.getElementById("UploadDialog_Path")) parent.document.getElementById("UploadDialog_Path").value = "<%=gstrPath%>";
        if (parent.document.getElementById("UploadDialog_Name")) parent.document.getElementById("UploadDialog_Name").value = "<%=gszName%>";

        $("#FileUpload1").change(function () {
            $("#form1").submit();
        });
    </script>
</body>
</html>
