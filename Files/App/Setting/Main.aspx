<%@ Page Language="C#" Inherits="ClsPage" %>

<!DOCTYPE html>

<script runat="server">
    protected String gstrConnString;
    protected long gintTable;
    protected long glngRelation;
    protected long glngID;
    protected int gintIndex;
    protected string gstrArgs;

    protected Ly.DB.Dream.AzTables gTab;
    protected String gstrFullPath;
    protected Ly.IO.Json gJson;
    protected int gintWidth;
    protected int gintHeight;
    protected int gintLines;
    protected int gintPage;
    protected string gstrSQL;
    protected Ly.IO.Json gAddJson;
    protected string gstrRelation;
</script>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
    <title></title>
    <link href="../../../../css/Plug.css" rel="stylesheet" />
</head>
<body>
    <form id="form1" runat="server">
        <div>
            <%ClsAjaxPage pg = new ClsAjaxPage(this); %>
            <% 
                string sPath = Pub.Request(this, "Path");
                string sID = Pub.Request(this, "ID");
                string sTable = Pub.Request(this, "Table");
                gAddJson = new Ly.IO.Json();

                gintWidth = 640;
                gintHeight = 380;
                gintLines = 20;
                gintPage = 1;
                gstrConnString = Pub.IO.ReadAllText(Server.MapPath(this.WebConfig.ConnectStringPath));

                string szFormScript = "$.Dialog.Form.DataClear();";
                szFormScript += "$.Dialog.Form.DataSetByValue('Pwd_Old','Pwd_Old');";
                szFormScript += "$.Dialog.Form.DataSetByValue('Pwd_New','Pwd_New');";
                szFormScript += "$.Dialog.Form.DataSetByValue('Pwd_NewRe','Pwd_NewRe');";
                szFormScript += "$.Dialog.Form.Submit('" + sPath + "Ajax/PwdSave.aspx');";

            %>
            <div style="padding: 8px; background-color: #0094ff; color: #ffffff; font-size: 14px;">修改密码</div>
            <div style="margin: 10px 0px 10px 10px">
                <div style="float: left; padding: 3px;">原密码:</div>
                <div style="float: left; padding: 1px 3px 0px 3px;">
                    <input id="Pwd_Old" type="password" style="width: 120px; padding: 3px; font-size: 12px; border: 1px solid #222222;" />
                </div>
                <div style="float: left; padding: 3px;">新密码:</div>
                <div style="float: left; padding: 1px 3px 0px 3px;">
                    <input id="Pwd_New" type="password" style="width: 120px; padding: 3px; font-size: 12px; border: 1px solid #222222;" />
                </div>
                <div style="float: left; padding: 3px;">重复密码:</div>
                <div style="float: left; padding: 1px 3px 0px 3px;">
                    <input id="Pwd_NewRe" type="password" style="width: 120px; padding: 3px; font-size: 12px; border: 1px solid #222222;" />
                </div>
                <div style="float: left; padding: 1px 0px 0px 3px;">
                    <input id="Button1" type="button" value="保存" style="width: 80px; padding: 1px 0px 3px 0px; font-size: 12px;" onclick="<%=szFormScript%>" />
                </div>
                <div style="clear: both;"></div>
            </div>
            <%
                string szUserSettingPath = Server.MapPath(this.WebConfig.UserSettingPath);
                string szJson = Pub.IO.ReadAllEncryptionText(szUserSettingPath);
                Ly.Formats.Json jSon = new Ly.Formats.Json(szJson);
                string szBackground = jSon["Background"].Value;

                string szBgSaveScript = "$.Dialog.Form.DataClear();";
                szBgSaveScript += "$.Dialog.Form.DataSetByValue('Setting_Background','Setting_Background');";
                szBgSaveScript += "$.Dialog.Form.DataSet('Process_ElementID','" + pg.XPortArgs.Process_ElementID + "');";
                szBgSaveScript += "$.Dialog.Form.DataSet('Process_ID','" + pg.XPortArgs.Process_ID + "');";
                szBgSaveScript += "$.Dialog.Form.Submit('" + sPath + "Ajax/BgSave.aspx');";
                szBgSaveScript += "Page.Desktop.BackgroudImage.src=$('#Setting_Background').val();";
            %>
            <div style="padding: 8px; background-color: #0094ff; color: #ffffff; font-size: 14px;">设置背景</div>
            <div style="margin: 10px 0px 10px 10px">
                <div style="font-weight: bold;">系统内置背景</div>
                <%
                    string[] szImgs = System.IO.Directory.GetFiles(Server.MapPath(this.WebConfig.SystemBackgroundPath), "*.jpg");
                    for (int i = 0; i < szImgs.Length; i++) {
                        string szStyle = "border: 2px solid #fff;";
                        string szImgPath = this.WebConfig.SystemBackgroundPath + "/" + System.IO.Path.GetFileName(szImgs[i]);
                        if (szImgPath == szBackground) szStyle = "border: 2px solid #ff6a00;";
                %>
                <div style="float: left; margin: 2px 2px 0px 0px; <%=szStyle%>">
                    <a href="javascript:;" onclick="$('#Setting_Background').val('<%=szImgPath%>');<%=szBgSaveScript%>">
                        <img src="<%=szImgPath%>" height="50" /></a>
                </div>
                <%
                    }
                %>
                <div style="clear: both;"></div>
            </div>
            <div style="margin: 10px 0px 10px 10px">
                <div style="font-weight: bold;">自定义</div>
                <div style="float: left; margin: 4px 4px 2px 2px;">
                    <a href="javascript:;" onclick="Page.ShowUpload('Setting_Background');">
                        <img id="Setting_Background_Img" src="<%=szBackground%>" height="50" /></a>
                </div>
                <div style="float: left;">
                    <div style="margin: 5px 0px 0px 5px;">路径:<span id="Setting_Background_Div"><%=szBackground%></span></div>
                    <div style="margin: 5px 0px 0px 5px;">
                        <input id="btnBgSave" type="button" value="保存" style="width: 80px; padding: 1px 0px 3px 0px; font-size: 12px;" onclick="<%=szBgSaveScript%>" />
                    </div>
                </div>
                <div style="clear: both;">
                    <input type="hidden" id="Setting_Background" value="<%=szBackground%>" />
                </div>
            </div>
            <%pg.Dispose();%>
        </div>
    </form>
</body>
</html>
