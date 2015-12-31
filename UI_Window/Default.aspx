<%@ Page Language="C#" AutoEventWireup="true" CodeFile="Default.aspx.cs" Inherits="_Default" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head id="Head1" runat="server">
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
    <title>Azalea Web OS</title>
    <link href="/css/Page.css" rel="stylesheet" />
    <link href="/css/Default.css" rel="stylesheet" />
    <link href="/css/Plug.css" rel="stylesheet" />
    <link href="css/Default.css" rel="stylesheet" />
    <link rel="Shortcut Icon" href="/lianyi.ico" />
</head>

<body>
    <script type="text/javascript" charset="utf-8" src="ueditor.config.js"></script>
    <script type="text/javascript" charset="utf-8" src="ueditor.all.min.js"> </script>
    <!--建议手动加在语言，避免在ie下有时因为加载语言失败导致编辑器加载失败-->
    <!--这里加载的语言文件会覆盖你在配置项目里添加的语言类型，比如你在配置项目里配置的是英文，这里加载的中文，那最后就是中文-->
    <script type="text/javascript" charset="utf-8" src="lang/zh-cn/zh-cn.js"></script>
    <script src="/js/jq/jquery-1.11.3.js"></script>
    <script src="/js/XKits/1.03.1512.js"></script>
    <script src="/js/Page/Initialize.js"></script>
    <%
        string szMode = "";
        if (Request["mode"] != null) szMode = Request["mode"].ToString();
    %>
    <%if ((gUserAgent.Browser == "Internet Explorer 6" || gUserAgent.Browser == "Internet Explorer 7" || gUserAgent.Browser == "Internet Explorer 5") && (szMode != "qz")) {%>
    <div style="margin: 0 auto; padding-top: 100px; width: 640px; font-size: 12px;">
        <div style="background: #222; color: #EFEFEF; padding: 5px;">浏览器兼容性提示</div>
        <div style="background: #FFF; padding: 10px 12px 12px 12px; line-height: 18px; border: 1px solid #222;">
            <p style="">本平台基于Chrome浏览器内核构建，当前您的浏览器核心为：<%=gUserAgent.Browser%></p>
            <p style="padding: 10px 0px 10px 0px; font-weight: bold;">当前浏览器与构架平台可能存在兼容性问题，您可以通过以下方法处理解决兼容性问题：</p>
            <p style="padding: 0px 0px 10px 0px; text-indent: 24px;">1、我们推荐您使用Google Chrome浏览器，可【<a href="Files/Down/ChromeSetup.exe">点击此处</a>】下载安装Google Chrome浏览器后通过Google Chrome浏览器访问本平台。</p>
            <p style="padding: 0px 0px 10px 0px; text-indent: 24px;">2、如果您使用的是类似360、百度、猎豹等双核浏览器，可在浏览器中设置使用"极速模式"或类似非IE模式即可。</p>
            <p style="padding: 0px 0px 10px 0px; text-indent: 24px;">3、本平台兼容Firefox、Safari等非Chrome核心浏览器，如果您的电脑安装有上述浏览器，请使用他们来访问本平台。</p>
            <p style="padding: 0px 0px 10px 0px; text-indent: 24px;">4、本平台最低兼容Internet Explorer 8，使用Internet Explorer 9及更高级版本可以获得更好的使用体验。</p>
            <p style="text-indent: 24px;">3、如果一定要使用当前模式浏览本平台，可以【<a href="Default.aspx?mode=qz">点击此处</a>】进行强制模式运行（强制模式可能会有显示不正常、无法正常登录等问题）。</p>
        </div>
    </div>
    <%} else { %>
    <div style="overflow: hidden; position: relative; width: 100%; height: 100%;" id="Main">
        <div class="page-launch" id="Launch">
            <div class="page-launch-rect">
                <img alt="" src="/images/background.jpg" style="position: absolute; left: 0px; top: 0px; width: 100%; height: 100%;" />
                <!--商标动画部分-->
                <div id="Logo" class="page-logo" style="display: none;">
                    <div class="page-logo-rect">
                        <div class="page-logo-empty"></div>
                        <div id="Logo_Full" class="page-logo-full"></div>
                    </div>
                </div>
                <!--企业选择-->
                <div id="CompanyList" class="page-company" style="display: none;">
                    <div class="page-company-head">请选择平台入口：</div>
                    <div class="page-company-list">
                        <ul id="Company_List">
                        </ul>
                    </div>
                </div>
                <!--登录部分-->
                <div id="Login" class="page-login" style="display: none;">
                    <div class="page-logo-ver">Ver:<%=ClsSite.AppVersion%></div>
                    <div>
                        <table style="width: 100%;">
                            <tr>
                                <td style="width: 50px;">用户名:</td>
                                <td>
                                    <input type="text" id="Login_UserName" value="<%=gszCookieName%>" onkeyup="if(event.keyCode == 13){$('#Login_Password').focus();}" /></td>
                            </tr>
                            <tr>
                                <td>密码:</td>
                                <td>
                                    <input type="password" id="Login_Password" onkeyup="if(event.keyCode == 13){$('#Login_Code').focus();}" /></td>
                            </tr>
                            <tr>
                                <td>验证码:</td>
                                <td>
                                    <input type="text" id="Login_Code" value="" style="width: 120px;" onkeyup="if(event.keyCode == 13){Page.Login();}" onfocus="X.Custom.getCode();" /><input type="button" id="btnSubmit" value="登录" onclick="Page.Login();" /></td>
                            </tr>
                            <tr>
                                <td>&nbsp;</td>
                                <td id="td_Login_Code">
                                    <a href="javascript:;" onclick="X.Custom.getCode();">点击获取验证码</a>
                                </td>
                            </tr>
                        </table>
                    </div>
                </div>
            </div>
        </div>
        <div class="page-desktop" id="Desktop" style="display: none;">
            <div class="page-desktop-rect">
                <div id="Menu" class="page-menu" style="display: none;">
                    <div class="page-menu-item" onclick="Page.UI.Open('Home', '', '主页', '/Files/App/System/Home/', 'Process.aspx', { Arg_Path: '/Files/App/System/Home/', ID: 'Home' });">
                        <img alt="" width="24" height="24" src="/Files/App/System/Home/logo.png" class="pub-left" />
                        <div class="page-menu-text">主页</div>
                        <div class="pub-clear"></div>
                    </div>
                    <div class="page-menu-item" onclick="Page.UI.Open('DataManager', '', '数据管理', '/Files/App/System/DataManager/', 'Process.aspx', { Arg_Path: '/Files/App/System/DataManager/', ID: 'DataManager' });">
                        <img alt="" width="24" height="24" src="/Files/App/System/DataManager/logo.png" class="pub-left" />
                        <div class="page-menu-text">数据管理</div>
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
            </div>
        </div>
    </div>
    <!--HTML内容编辑框-->
    <div id="UEditorDialog" class="page-ueditor" style="z-index: 100; display: none;">
        <div class="page-ueditor-rect">
            <div class="page-ueditor-bg"></div>
            <div class="page-ueditor-title">
                <div class="pub-left">HTML信息编辑器</div>
                <div class="pub-right">
                    <div style="width: 20px; height: 20px; text-align: center; cursor: pointer; padding: 0px; vertical-align: middle;" onmousemove="this.style.backgroundColor='#990000';" onmouseout="this.style.backgroundColor='';" onclick="Page.CloseUEditor();">×</div>
                </div>
                <div class="pub-clear"></div>
            </div>
            <div class="page-ueditor-work">
                <script id="editor" type="text/plain" style="width: 100%; height: 500px;"></script>
                <%--<iframe id="UEditorDialog_Frame" name="UEditorDialog_Frame" src="about:blank" class="page-ueditor-frame"></iframe>--%>
            </div>
        </div>
    </div>
    <!--文件上传对话框-->
    <div id="UploadDialog" class="page-uploaddialog" style="z-index: 101; display: none;">
        <div class="page-uploaddialog-rect">
            <div class="page-uploaddialog-bg"></div>
            <div class="page-uploaddialog-title">文件上传<input id="UploadDialog_Path" type="hidden" /></div>
            <div class="page-uploaddialog-work">
                <iframe id="UploadDialog_Frame" src="about:blank" frameborder="0" class="page-uploaddialog-frame"></iframe>
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
    <!--日期对话框-->
    <div id="DateDialog" class="page-datedialog" style="z-index: 102; display: none;"></div>
    <%
        string szKey = "";
        string szJsScript = "";
        if (Request["key"] != null) szKey = Request["key"].ToString();

        using (dyk.DB.Aos.AosAuthorize.ExecutionExp sz = new dyk.DB.Aos.AosAuthorize.ExecutionExp(gszConnectString)) {
            if (sz.GetDataByCode(szKey.ToUpper())) {
                szJsScript = "X.Custom.AddAuth(" + sz.Structure.ID + ",\"" + sz.Structure.Name + "\",\"" + sz.Structure.Code + "\");\n";
                szJsScript += "X.Custom.AuthCheck(" + sz.Structure.ID + ");";
            }
        }
    %>
    <script>

        //实例化编辑器
        //建议使用工厂方法getEditor创建和引用编辑器实例，如果在某个闭包下引用该编辑器，直接调用UE.getEditor('editor')就能拿到相关的实例
        var ue = UE.getEditor('editor');

        $(function () {
            X.Custom.Application.Name = "<%=ClsSite.AppProduceName%>";
            X.Custom.Application.Version = "<%=ClsSite.AppVersion%>";
            //Taskbar.ObjectsJson = "<%=gstrApps%>";

        });

        X.Custom.AuthInit = function () {
            <%=szJsScript%>
        }
    </script>
    <%} %>
</body>
</html>
