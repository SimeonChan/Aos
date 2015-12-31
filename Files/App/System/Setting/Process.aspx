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
                //gstrConnString = Pub.IO.ReadAllText(Server.MapPath("/Files/System/Conn.txt"));
                Ly.DB.Dream.Tables gTabs = new Ly.DB.Dream.Tables(this.ConnectString);

                using (ClsAjaxRequest js = new ClsAjaxRequest()) {
                    //js.Message = "Test";
                    //js.SetText("MsgNav_Info", "<font color='#990000'>保存失败!<font>");
                    //js.SetStyle(pg.UITool, "display", "none");
                    js.SetStyle(pg.PageArgs.UIMain, "backgroundColor", "#fff");
                    js.SetDebugLine("正在加载个人设置:");
                    using (ClsAjaxRequest.Arg arg = new ClsAjaxRequest.Arg(pg)) {
                        arg.Path = pg.PageArgs.UIPath;
                        js.SetAjaxLoad(pg.PageArgs.UITool, pg.PageArgs.UIPath + "Tool.aspx", arg, "->(1/2)加载工具栏...");
                        js.SetAjaxLoad(pg.PageArgs.UIMain, pg.PageArgs.UIPath + "Main.aspx", arg, "->(2/2)加载主界面...");
                    }
                    Response.Write(js.ToString());
                }
            %>
            <%pg.Dispose();%>
        </div>
    </form>
</body>
</html>
