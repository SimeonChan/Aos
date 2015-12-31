<%@ Page Language="C#" ValidateRequest="false" Inherits="ClsPage" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<script runat="server">
    protected int gintTable;
    protected String gstrConnString;
</script>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
    <title></title>
</head>
<body>
    <form id="form1" runat="server">
        <div>
            <%ClsAjaxPage pg = new ClsAjaxPage(this);%>
            <%
                gintTable = Ly.String.Source(Pub.Request(this, "Table")).toInteger;

                Ly.DB.Dream.Tables gTabs = new Ly.DB.Dream.Tables(this.ConnectString);

                pg.PageRequest.SetStyle(pg.PageArgs.UIMain, "backgroundColor", "#fff");
                pg.PageRequest.SetDebugLine("正在加载平台数据库管理:");

                using (ClsAjaxRequest.Arg arg = new ClsAjaxRequest.Arg(pg)) {
                    arg["Arg_Path"] = pg["Arg_Path"];
                    pg.PageRequest.SetScript("Editer_Text", pg.PageArgs.UIPath + "js/Default.js");
                    pg.PageRequest.SetAjaxLoad(pg.PageArgs.UITool, pg.PageArgs.UIPath + "Tool.aspx", arg, "->(1/2)加载工具栏...");
                    pg.PageRequest.SetAjaxLoad(pg.PageArgs.UIMain, pg.PageArgs.UIPath + "Main.aspx", arg, "->(2/2)加载主界面...");
                }
                pg.OutPutJsonRequest();
            %>
            <%pg.Dispose();%>
        </div>
    </form>
</body>
</html>
