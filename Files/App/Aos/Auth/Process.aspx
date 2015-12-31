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

                pg.XPort.SetStyle(pg.PageArgs.UIMain, "backgroundColor", "#fff");
                pg.XPort.SetDebugLine("正在加载我的应用:");

                pg.XPort.SetScript("Js_Aos_Auth", pg.PageArgs.UIPath + "js/Main.js");
                pg.XPort.SetStorage("Aos_Auth_UIPath", pg.PageArgs.UIPath);

                //将页面参数进行存储
                pg.XPort.SetUIStorage(pg.XPortArgs);

                pg.XPort.SetAjaxLoad(pg.XPortArgs.UI_Tool, pg.XPortArgs.UI_Path + "Tool.aspx", pg.XPortArgs, "->(1/2)加载我的应用工具栏...");
                pg.XPort.SetAjaxLoad(pg.XPortArgs.UI_Main, pg.XPortArgs.UI_Path + "Main.aspx", pg.XPortArgs, "->(2/2)加载我的应用主界面...");

                pg.OutPutXPort();
                //using (ClsAjaxRequest.Arg arg = new ClsAjaxRequest.Arg(pg)) {
                //    arg.Path = pg.PageArgs.UIPath;
                //    pg.PageRequest.SetAjaxLoad(pg.PageArgs.UITool, pg.PageArgs.UIPath + "Tool.aspx", arg, "->(1/2)加载我的应用工具栏...");
                //    pg.PageRequest.SetAjaxLoad(pg.PageArgs.UIMain, pg.PageArgs.UIPath + "Main.aspx", arg, "->(2/2)加载我的应用主界面...");
                //}
                //pg.OutPutJsonRequest();
            %>
            <%pg.Dispose();%>
        </div>
    </form>
</body>
</html>
