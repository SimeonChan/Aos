<%@ Page Language="C#" AutoEventWireup="true" CodeFile="Default.aspx.cs" Inherits="_Default" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
    <title></title>
    <link href="/css/Page.css" rel="stylesheet" />
    <link href="/css/Default.css" rel="stylesheet" />
    <link href="/css/Plug.css" rel="stylesheet" />
    <link href="/css/Card.css" rel="stylesheet" />
    <link href="css/Default.css" rel="stylesheet" />
</head>
<body>
    <script src="/js/jquery-1.10.2.min.js"></script>
    <script src="/js/Az.js"></script>
    <script src="/js/Page.js"></script>
    <script src="/js/jq-debug.js"></script>
    <script src="/js/jq-Process.js"></script>
    <script src="/js/jq-Dialog.js"></script>
    <script src="/js/Controls/LeftOnly.js"></script>
    <script src="/js/Class.js"></script>
    <script src="/js/Controls/Tip.js"></script>
    <script src="/js/Controls/Console.js"></script>
    <script src="/js/Controls/Taskbar.js"></script>
    <script src="/js/Controls/DatePicker.js"></script>
    <script src="/js/Default.js"></script>
    <script src="/js/Default_Init.js"></script>
    <script src="/js/Default_Desktop.js"></script>
    <script src="/js/Controls/AjaxRequest.js"></script>
    <script src="js/Default.js"></script>
    <form id="form1" runat="server">
        <div id="Desktop_Tool" class="page-desktop-tool">
            <div style="padding-top: 2px;"><%=ClsSite.AppName%></div>
        </div>
        <div id="WorkWindow">
            <div id="Desktop" class="page-desktop">
                <div id="Desktop_Main"></div>
            </div>
        </div>
        <div id="Console" class="page-console"></div>
        <div id="UploadDialog" class="page-uploaddialog" style="z-index: 100; display: none;">
            <div class="page-uploaddialog-rect">
                <div class="page-uploaddialog-bg"></div>
                <div class="page-uploaddialog-title">文件上传<input id="UploadDialog_Path" type="hidden" /></div>
                <div class="page-uploaddialog-work">
                    <iframe id="UploadDialog_Frame" src="/Upload.aspx" frameborder="0" class="page-uploaddialog-frame"></iframe>
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
    </form>
    <script>
        $(function () {
            //var t01 = document.getElementById("T01");
            //var div = document.createElement("div");
            //div.innerHTML = "OK";
            //t01.parentNode.insertBefore(div, t01);

            //$(".cardpanel").css({ width: 1000 });
            Taskbar.ObjectsJson = "<%=gstrApps%>";
        });
    </script>
</body>
</html>
