<%@ Page Language="C#" AutoEventWireup="true" CodeFile="Default.aspx.cs" Inherits="_Default" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml">
<head id="Head1" runat="server">
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
    <title>Azalea Web OS</title>
    <link href="/css/Page.css" rel="stylesheet" />
    <link href="/css/Default.css" rel="stylesheet" />
    <link href="/css/Plug.css" rel="stylesheet" />
</head>

<body>
    <script language="javascript" type="text/javascript" src="/js/jquery-1.10.2.min.js"></script>
    <script language="javascript" type="text/javascript" src="/js/jq-debug.js"></script>
    <script language="javascript" type="text/javascript" src="/js/jq-Process.js"></script>
    <script language="javascript" type="text/javascript" src="/js/jq-Dialog.js"></script>
    <script language="javascript" type="text/javascript" src="/js/Controls/LeftOnly.js"></script>
    <script language="javascript" type="text/javascript" src="/js/Class.js"></script>
    <script language="javascript" type="text/javascript" src="/js/Controls/Tip.js"></script>
    <script language="javascript" type="text/javascript" src="/js/Controls/Console.js"></script>
    <script language="javascript" type="text/javascript" src="/js/Controls/Taskbar.js"></script>
    <script language="javascript" type="text/javascript" src="/js/Controls/DatePicker.js"></script>
    <script language="javascript" type="text/javascript" src="/js/Default.js"></script>
    <script language="javascript" type="text/javascript" src="/js/Default_Init.js"></script>
    <script language="javascript" type="text/javascript" src="/js/Default_Desktop.js"></script>
    <script language="javascript" type="text/javascript" src="/js/Controls/AjaxRequest.js"></script>
    <%if ((gUserAgent.Browser != "Google Chrome") && (this["mode"] != "qz")) {%>
    <div style="margin: 0 auto; padding-top: 100px; width: 640px; font-size: 12px;">
        <div style="background: #222; color: #EFEFEF; padding: 5px;">浏览器兼容性提示</div>
        <div style="background: #FFF; padding: 10px 12px 12px 12px; line-height: 18px; border: 1px solid #222;">
            <p style="">本平台基于Chrome浏览器内核构建，当前您的浏览器核心为：<%=gUserAgent.Browser%></p>
            <p style="padding: 10px 0px 10px 0px; font-weight: bold;">当前浏览器与构架平台可能存在兼容性问题，您可以通过以下方法处理解决兼容性问题：</p>
            <p style="padding: 0px 0px 10px 0px; text-indent: 24px;">1、如果您使用的是类似360、百度等双核浏览器，可在浏览器中设置使用"急速模式"即可。</p>
            <p style="padding: 0px 0px 10px 0px; text-indent: 24px;">2、如果您使用的是类似Internet Explorer(IE)、Firefox、Safari等非Chrome核心浏览器，可【<a href="Files/Down/ChromeSetup.exe">点击此处</a>】下载安装Google Chrome浏览器后通过Google Chrome浏览器访问本平台。</p>
            <p style="text-indent: 24px;">3、如果一定要使用当前模式浏览本平台，可以【<a href="Default.aspx?mode=qz">点击此处</a>】进行强制模式运行（强制模式可能会有显示不正常、无法正常登录等问题）。</p>
        </div>
    </div>
    <%} else { %>
    <form id="form1" runat="server">
        <div style="overflow: hidden; position: relative;" id="Main">
            <div class="page-desktop" id="Desktop">
                <div id="Menu" class="page-menu" style="display: none;">
                    <div class="page-menu-item" onclick="$.Process.Add('AppManager','我的应用', '/Files/App/Com_Application/','Process.aspx', { Path: '/Files/App/Com_Application/', ID: 'Win_AppManager' });">
                        <img alt="" width="24" height="24" src="/Files/App/Com_Application/logo.png" class="pub-left" />
                        <div class="page-menu-text">我的应用</div>
                        <div class="pub-clear"></div>
                    </div>
                    <div id="Menu_Main" style="margin-top: 5px; border-top: 1px solid #fff; position: relative;"></div>
                </div>
                <div id="Window_Title" class="page-window-title" style="display: none;">
                    <div id="Windows_Logo" class="page-window-logo">
                        <img alt="" src="/images/user.jpg" width="48" height="48" />
                    </div>
                    <div id="Windows_User" class="page-window-user"></div>
                    <div id="Windows_Close" class="pub-right"></div>
                    <div class="page-window-name">当前窗口-[<span id="Windows_Name"></span>]</div>
                    <div class="pub-clear"></div>
                </div>
                <div id="Window" class="page-window" style="display: none;">
                    <div id="Window_Rect" class="page-window-rect">
                        <div id="Window_Bg" class="page-window-bg"></div>
                    </div>
                </div>
                <div id="Console" class="page-console" style="display: none;"></div>
                <div id="Login" class="page-login" style="display: none;">
                    <div class="page-login-user">
                        <div>用户名:</div>
                        <div>
                            <input type="text" id="UserName" value="<%=gszCookieName%>" onkeyup="if(event.keyCode == 13){$('#Password').focus();}" />
                        </div>
                    </div>
                    <div class="page-login-pwd">
                        <div>密码:</div>
                        <div>
                            <input type="password" id="Password" onkeyup="if(event.keyCode == 13){Page.Login();}" />
                        </div>
                    </div>
                    <div class="page-login-btn">
                        <a href="javascript:;" onclick="Page.Login();">登录</a>
                    </div>
                    <div class="page-login-info">
                        产品基于&nbsp;<%=ClsSite.AppKernel%>&nbsp;技术构架&nbsp;<a href="<%=ClsSite.AppTechnicalUrl%>" target="_blank"><%=ClsSite.AppTechnicalSupport%></a>&nbsp;提供技术支持
                    </div>
                </div>
                <div id="UploadDialog" class="page-uploaddialog" style="z-index: 100; display: none;">
                    <div class="page-uploaddialog-rect">
                        <div class="page-uploaddialog-bg"></div>
                        <div class="page-uploaddialog-title">文件上传<input id="UploadDialog_Path" type="hidden" /></div>
                        <div class="page-uploaddialog-work">
                            <iframe id="UploadDialog_Frame" src="Upload.aspx" frameborder="0" class="page-uploaddialog-frame"></iframe>
                            <div class="pub-left" id="UploadDialog_Info" style="padding: 8px 0px 0px 10px;"></div>
                            <div class="pub-right" style="padding: 5px 10px 0px 0px;">
                                <input id="UploadDialog_Cancel" type="button" value="取消" onclick="$('#UploadDialog').css({ display: 'none' });" />
                            </div>
                            <div class="pub-right" style="padding: 5px 10px 0px 0px;">
                                <input id="UploadDialog_OK" type="button" value="确定" onclick="Page.SubmitUpload();" />
                            </div>
                            <div class="pub-clear"></div>
                        </div>
                    </div>
                </div>
                <div id="DateDialog" class="page-datedialog" style="z-index: 200; display: none;"></div>
            </div>
        </div>
    </form>
    <script language="javascript" type="text/javascript">
        $(function () {
            Taskbar.ObjectsJson = "<%=gstrApps%>";
        });
    </script>
    <%} %>
</body>
</html>
