<%@ Page Language="C#" Inherits="ClsPage" %>

<!DOCTYPE html>

<script runat="server">
    protected String gstrFullPath;
</script>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
    <title>文件下载</title>
</head>
<body>
    <form id="form1" runat="server">
        <div>
            <%
                int nID = Ly.String.Source(Pub.Request(this, "ID")).toInteger;

                using (Ly.DB.Dream.Tables gTabs = new Ly.DB.Dream.Tables(this.ConnectString)) {
                    if (gTabs.SystemChats.GetDataByID(nID)) {
                        if (gTabs.SystemChats.Structure.ChatType == 2) {
                            Response.ContentType = "application/octet-stream";
                            string filename = Server.MapPath(gTabs.SystemChats.Structure.Content);
                            Response.AddHeader("Content-Disposition", "attachment;filename=" + System.IO.Path.GetFileName(filename));
                            Response.TransmitFile(filename);
                        } else {
                            Response.Write("未找到文件!");
                        }
                    }
                }
            %>
        </div>
    </form>
</body>
</html>
