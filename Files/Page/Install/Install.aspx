<%@ Page Language="C#" AutoEventWireup="true" CodeFile="Install.aspx.cs" Inherits="Files_App_Install_Install" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
    <title><%=ClsSite.AppProduceName%>初始化安装</title>
    <link href="css/Root.css" rel="stylesheet" />
    <link href="css/Nav.css" rel="stylesheet" />
</head>
<body>
    <script language="javascript" type="text/javascript" src="/js/jq/jquery-1.11.3.js"></script>
    <script language="javascript" type="text/javascript" src="http://js.dyksoft.com/XKits/1.02.1511/X.js"></script>
    <script language="javascript" type="text/javascript" src="/js/Controls/AjaxRequest.js"></script>
    <script language="javascript" type="text/javascript" src="js/Default.js"></script>
    <form id="form1" runat="server">
        <div class="page-line">
            <div class="page-title"><%=ClsSite.AppProduceName%>初始化安装</div>
        </div>
        <%if (gnStep == 1) {%>
        <div class="page-line">
            <div class="ListView">
                <div style="padding: 10px; font-size: 14px; font-weight: bold;">第1/3步:设置数据库连接信息</div>
                <table style="width: 100%;">
                    <tr>
                        <td style="width: 20%;" align="right">数据库实例/IP:</td>
                        <td style="">
                            <input id="dbHost" type="text" style="width: 300px;" /></td>
                    </tr>
                    <tr>
                        <td align="right">连接账号:</td>
                        <td>
                            <input id="dbName" type="text" /></td>
                    </tr>
                    <tr>
                        <td align="right">连接密码:</td>
                        <td>
                            <input id="dbPwd" type="password" /></td>
                    </tr>
                    <tr>
                        <td align="right">&nbsp;</td>
                        <td>
                            <input id="Button1" type="button" value="确认保存，进入下一步" onclick="X.Custom.SaveDBConn();" /></td>
                    </tr>
                </table>
            </div>
        </div>
        <%} else if (gnStep == 2) { %>
        <div class="page-line">
            <div class="ListView">
                <div style="padding: 10px; font-size: 14px; font-weight: bold;">第2/3步:设置数据库保存路径并初始化Aos库</div>
                <%
                    string szFileSetting = Server.MapPath(WebConfig.SZ_FILE_SETTING);
                    string szSetting = dyk.IO.File.UTF8.ReadAllText(szFileSetting, true);
                    using (dyk.Format.XML xml = new dyk.Format.XML(szSetting)) {
                        string szPath = xml["Database.SavePath"].InnerText;
                        if (szPath == "") szPath = WebConfig.SZ_DIR_DATABASE_DEFAULT;
                %>
                <table style="width: 100%;">
                    <tr>
                        <td style="width: 20%;" align="right">数据库保存路径:</td>
                        <td style="">
                            <input id="dbPath" type="text" style="width: 300px;" value="<%=szPath%>" /></td>
                    </tr>
                    <tr>
                        <td align="right">当前网站路径:</td>
                        <td><%=Server.MapPath("/")%>&nbsp;<a href="javascript:;" onclick="$('#dbPath').val('<%=Server.MapPath("/").Replace("\\","\\\\")%>\Aos_Database');">设置到网站目录下</a></td>
                    </tr>
                    <tr>
                        <td align="right">&nbsp;</td>
                        <td>
                            <input id="Button2" type="button" value="确认保存，进入下一步" onclick="X.Custom.SaveAos();" /></td>
                    </tr>
                </table>
                <%} %>
            </div>
        </div>
        <%} else if (gnStep == 3) { %>
        <div class="page-line">
            <div class="ListView">
                <div style="padding: 10px; font-size: 14px; font-weight: bold;">第3/3步:初始化Aos_Manage库并设置Root用户密码</div>
                <table style="width: 100%;">
                    <tr>
                        <td style="width: 20%;" align="right">设置Root密码:</td>
                        <td style="">
                            <input id="dbRootPwd" type="password" style="width: 200px;" value="" /></td>
                    </tr>
                    <tr>
                        <td style="width: 20%;" align="right">重复Root密码:</td>
                        <td style="">
                            <input id="dbRootPwdRe" type="password" style="width: 200px;" value="" /></td>
                    </tr>
                    <tr>
                        <td align="right">&nbsp;</td>
                        <td>
                            <input id="Button3" type="button" value="确认保存，完成安装" onclick="X.Custom.SaveAosManage();" /></td>
                    </tr>
                </table>
            </div>
        </div>
        <%} else if (gnStep == 4) { %>
        <%} else { %>
        <div class="page-line">
            <div class="ListView">
                <div style="padding: 10px; font-size: 14px; font-weight: bold;">安装完成!&nbsp;<a href="/Default.aspx" target="">返回主页</a></div>
            </div>
        </div>
        <%} %>
    </form>
</body>
</html>
