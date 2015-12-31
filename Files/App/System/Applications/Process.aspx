﻿<%@ Page Language="C#" ValidateRequest="false" Inherits="ClsPage" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<script runat="server">
    protected int gintTable;
    //protected String gstrConnString;
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

                pg.PageRequest.SetStyle(pg.PageArgs.UIMain, "backgroundColor", "");
                pg.PageRequest.SetDebugLine("正在加载我的应用:");

                string szJson = Pub.IO.ReadAllText(Server.MapPath(this.WebConfig.AppsSettingPath));
                using (Ly.Formats.Json json = new Ly.Formats.Json(szJson)) {
                    for (int i = 0; i < json.Object.Count; i++) {
                        Ly.Formats.JsonUnitPoint jup = json.Object[i];
                        if (jup.Name == "App") {
                            if (jup["Js"].Value != "") {
                                pg.PageRequest.SetScript("js_" + jup["ID"].Value, jup["Js"].Value);
                            }
                        }
                    }
                }

                using (ClsAjaxRequest.Arg arg = new ClsAjaxRequest.Arg(pg)) {
                    arg.Path = pg.PageArgs.UIPath;
                    pg.PageRequest.SetAjaxLoad(pg.PageArgs.UITool, pg.PageArgs.UIPath + "Tool.aspx", arg, "->(1/2)加载我的应用工具栏...");
                    pg.PageRequest.SetAjaxLoad(pg.PageArgs.UIMain, pg.PageArgs.UIPath + "Main.aspx", arg, "->(2/2)加载我的应用主界面...");
                    pg.PageRequest.SetAjaxScript(pg.PageArgs.UIPath + "Msg.aspx", arg);
                }
                pg.OutPutJsonRequest();
            %>
            <%pg.Dispose();%>
        </div>
    </form>
</body>
</html>
