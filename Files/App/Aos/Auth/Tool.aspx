<%@ Page Language="C#" Inherits="ClsPage" ValidateRequest="false" %>

<!DOCTYPE html>

<script runat="server">
    protected String gstrPath;
    protected String gstrFullPath;
    protected Ly.IO.JsonFile gJson;
</script>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
    <title></title>
</head>
<body>
    <form id="form1" runat="server">
        <div>
            <%ClsAjaxPage pg = new ClsAjaxPage(this); %>
            <% 

                int gnPage = Ly.String.Source(this["Arg_Page"]).toInteger;
                string szTable = Pub.Request(this, "Arg_Table");

                string szColor = "color: #fff; text-shadow: 1px 1px 3px #000;";
                if (pg.PageArgs.UI == "Touch") szColor = "color: #222; text-shadow: 1px 1px 3px #bbb;";

                string szUserLimitAll = "|*|";//访问权限设定，设定此项，代表任何用户名默认允许访问
                string szUserLimitPass = "|" + this.Session.Manager + "|";//单用户访问权限设定，设定此项，代表任何该用户名允许访问
                string szUserLimitStop = "|-" + this.Session.Manager + "|";//单用户阻止访问权限设定，设定此项，代表任何该用户名不允许访问

                gstrPath = "";
                if (Request["Path"] != null) gstrPath = Request["Path"].ToString().Trim().Replace("\\", "/");
                if (gstrPath.StartsWith("/") || gstrPath.IndexOf("..") >= 0) gstrPath = "";
                if (gstrPath != "" && !gstrPath.EndsWith("/")) gstrPath += "/";
                gstrFullPath = "/" + gstrPath;
                gJson = new Ly.IO.JsonFile(Server.MapPath(this.WebConfig.AppsSettingPath), System.Text.Encoding.UTF8);

                string szClick = "";
            %>
            <%
                if (pg.PageArgs.UI != "Touch") {
                    szClick = "Page.UI.Open('Home','','主页','/Files/App/System/Home/','Process.aspx', {});";
            %>
            <div style="float: left;">
                <div class="pub-left">
                    <a href="javascript:;" onclick="<%=szClick%>">
                        <img src="<%=pg.XPortArgs.UI_Path%>images/back.png" width="24" height="24" alt="" style="padding-top: 0px;" /></a>
                </div>
                <div class="pub-left" style="padding: 2px 0px 0px 5px;"><a href="javascript:;" onclick="<%=szClick%>">返回</a></div>
                <div class="pub-clear"></div>
            </div>
            <div style="float: left; padding: 0px 8px 0px 8px; height: 24px"><span></span></div>
            <%
                }
                szClick = "X.Custom.AosAuth.Add();";
            %>
            <div style="float: left;">
                <div class="pub-left">
                    <a href="javascript:;" onclick="<%=szClick%>">
                        <img src="<%=pg.XPortArgs.UI_Path%>images/Tool_Add.gif" width="24" height="24" alt="" style="padding-top: 0px;" /></a>
                </div>
                <div class="pub-left" style="padding: 2px 0px 0px 5px;"><a href="javascript:;" onclick="<%=szClick%>">添加</a></div>
                <div class="pub-clear"></div>
            </div>
            <div style="float: left; padding: 0px 8px 0px 8px; height: 24px"></div>
            <%
                szClick = "X.Custom.AosAuth.Delete();";
            %>
            <div style="float: left;">
                <div class="pub-left">
                    <a href="javascript:;" onclick="<%=szClick%>">
                        <img src="<%=pg.XPortArgs.UI_Path%>images/Tool_Delete.gif" width="24" height="24" alt="" style="padding-top: 0px;" /></a>
                </div>
                <div class="pub-left" style="padding: 2px 0px 0px 5px;"><a href="javascript:;" onclick="<%=szClick%>">删除</a></div>
                <div class="pub-clear"></div>
            </div>
            <div style="float: left; padding: 0px 8px 0px 8px; height: 24px"><span></span></div>
            <%
                szClick = "X.Custom.AosAuth.CreatDB();";
            %>
            <div style="float: left;">
                <div class="pub-left">
                    <a href="javascript:;" onclick="<%=szClick%>">
                        <img src="<%=pg.XPortArgs.UI_Path%>images/Database.png" width="24" height="24" alt="" style="padding-top: 0px;" /></a>
                </div>
                <div class="pub-left" style="padding: 2px 0px 0px 5px;"><a href="javascript:;" onclick="<%=szClick%>">建立数据库</a></div>
                <div class="pub-clear"></div>
            </div><div style="float: left; padding: 0px 8px 0px 8px; height: 24px"><span></span></div>
            <%
                szClick = "Page.UI.Open('" + pg.XPortArgs.UI_ID + "','','我的应用','" + pg.XPortArgs.UI_Path + "','Process.aspx', {});";
            %>
            <div style="float: left;">
                <div class="pub-left">
                    <a href="javascript:;" onclick="<%=szClick%>">
                        <img src="<%=pg.XPortArgs.UI_Path%>images/Tool_Refresh.gif" width="24" height="24" alt="" style="padding-top: 0px;" /></a>
                </div>
                <div class="pub-left" style="padding: 2px 0px 0px 5px;"><a href="javascript:;" onclick="<%=szClick%>">刷新</a></div>
                <div class="pub-clear"></div>
            </div>
            <%
                if (pg.PageArgs.UI != "Touch") {
                    szClick = "Page.Logout();";
            %>
            <div style="float: left; padding: 0px 8px 0px 8px; height: 24px"><span></span></div>
            <div style="float: left;">
                <div class="pub-left">
                    <a href="javascript:;" onclick="<%=szClick%>">
                        <img src="<%=pg.XPortArgs.UI_Path%>images/Exit.png" width="24" height="24" alt="" style="padding-top: 0px;" /></a>
                </div>
                <div class="pub-left" style="padding: 2px 0px 0px 5px;"><a href="javascript:;" onclick="<%=szClick%>">退出登录</a></div>
                <div class="pub-clear"></div>
            </div>
            <%
                }
            %>
            <div style="clear: both;"></div>
            <%pg.Dispose();%>
        </div>
    </form>
</body>
</html>
