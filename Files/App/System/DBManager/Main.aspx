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
                //读取基础数据库配置文件
                string szJsBase = Pub.IO.ReadAllEncryptionText(Server.MapPath(WebConfig.SZ_DB_BASE));

                Ly.DB.Dream.Tables gTab = new Ly.DB.Dream.Tables(this.ConnectString);
                using (Ly.Formats.Json json = new Ly.Formats.Json(szJsBase)) {
                    for (int i = 0; i < json.Object.Count; i++) {
                        Ly.Formats.JsonUnitPoint jup = json.Object[i];
                        if (jup["Lv"].Value == "Base") {
                            using (Ly.Data.SQLClient Conn = new Ly.Data.SQLClient(this.ConnectString)) {
                                Conn.NewCmd("select ID from sysobjects where type='U' and name=@Name");
                                Conn.AddParameter("@Name", jup.Name, System.Data.SqlDbType.VarChar, 50);
                                Conn.ExecuteReader();
                                if (!Conn.DataReader.Read()) {
                                    //bBase = false;
                                    break;
                                }
                            }
                        }
                    }
            %>
            <%
                string szClick = "";
                string szName = pg["Arg_Name"];
                string szPath = Server.MapPath(WebConfig.SZ_PLUG + "/" + szName + "/db.json");

                //默认使用Base
                if (!System.IO.File.Exists(szPath)) {
                    szName = "Base";
                    szPath = Server.MapPath(WebConfig.SZ_PLUG + "/" + szName + "/db.json");
                }

                string szScript; //= "Page.Functions.DBManager.Update('" + pg.PageArgs.Path + "',);";
                using (ClsAjaxRequest.Arg arg = new ClsAjaxRequest.Arg(pg)) {
                    arg["Arg_File"] = szName;
                    using (Ly.Formats.Json argJson = new Ly.Formats.Json(arg.ToString())) {
                        szScript = "Page.Functions.DBManager.Update('" + pg.PageArgs.Path + "'," + argJson["Arg"].ToJsonString().Replace("\"", "'") + ");";
                    }
                }
            %>
            <div class="plug-Nav">
                <ul>
                    <li>
                        <div class="pub-left">
                            <a href="javascript:;" onclick="<%=szScript%>">
                                <img src="<%=pg.PageArgs.Path%>images/update.png" width="16" height="16" alt="" style="padding-top: 0px;" /></a>
                        </div>
                        <div class="pub-left"><a href="javascript:;" onclick="<%=szScript%>">更新表结构</a></div>
                        <%
                            using (ClsAjaxRequest.Arg arg = new ClsAjaxRequest.Arg(pg)) {
                                arg["Arg_File"] = szName;
                                using (Ly.Formats.Json argJson = new Ly.Formats.Json(arg.ToString())) {
                                    szScript = "Page.Functions.DBManager.OAUpdate('" + pg.PageArgs.Path + "'," + argJson["Arg"].ToJsonString().Replace("\"", "'") + ");";
                                }
                            }
                        %>
                        <div class="pub-left" style="margin-left: 10px;">
                            <a href="javascript:;" onclick="<%=szScript%>">
                                <img src="<%=pg.PageArgs.Path%>images/update.png" width="16" height="16" alt="" style="padding-top: 0px;" /></a>
                        </div>
                        <div class="pub-left"><a href="javascript:;" onclick="<%=szScript%>">更新管理信息</a></div>
                        <%
                            szScript = "Page.Functions.DBManager.Init('" + pg.PageArgs.Path + "')";
                        %>
                        <div class="pub-left" style="border-left: 1px solid #CCCCCC; padding-left: 10px; margin-left: 10px;">
                            <a href="javascript:;" onclick="<%=szScript%>">
                                <img src="<%=pg.PageArgs.Path%>images/init.png" width="16" height="16" alt="" style="padding-top: 0px;" /></a>
                        </div>
                        <div class="pub-left"><a href="javascript:;" onclick="<%=szScript%>">初始化信息填充</a></div>
                        <div class="pub-clear"></div>
                    </li>
                </ul>
                <div style="clear: both;"></div>
            </div>
            <div style="padding: 5px;">
                <%
                    using (Ly.Formats.JsonObject jsSetting = new Ly.Formats.JsonObject()) {
                        string szJsSetting = Pub.IO.ReadAllEncryptionText(Server.MapPath(WebConfig.SZ_DB_SETTING));
                        jsSetting.InnerJson = szJsSetting;
                        for (int i = 0; i < jsSetting.Count; i++) {
                            if (jsSetting[i].Name == "File") {
                                string szJsName = jsSetting[i]["Name"].Value;
                                szClick = "Page.UI.Open('" + pg.PageArgs.UID + "','','个人设置','" + pg.PageArgs.Path + "','Process.aspx', {Arg_Name:'" + szJsName + "'});";
                %>
                <div style="float: left; border-bottom: 1px solid #0094ff; width: 5px; height: 24px;"></div>
                <%if (szJsName == szName) {%>
                <div style="float: left; border: 1px solid #0094ff; border-bottom-width: 0px; height: 21px; padding: 3px 5px 0px 5px; font-weight: bold;"><%=jsSetting[i]["Text"].Value%></div>
                <%} else { %>
                <div style="float: left; border: 1px solid #9eb6ce; border-bottom-color: #0094ff; height: 20px; padding: 3px 5px 0px 5px; background: #e4ecf7;"><a href="javascript:;" onclick="<%=szClick%>"><%=jsSetting[i]["Text"].Value%></a></div>
                <%} %>
                <%
                            }
                        }
                    }
                %>
                <div style="float: left; border-bottom: 1px solid #0094ff; width: 50px; height: 24px;"></div>
                <div style="clear: both;"></div>
            </div>
            <%
                string szJson = Pub.IO.ReadAllEncryptionText(szPath);
                dyk.Format.Json dJson = new dyk.Format.Json(szJson);
            %>
            <div style="padding: 5px;">
                命名空间:&nbsp;dyk.DB.<%=dJson["Sign"].Value%>&nbsp;&nbsp;&nbsp;名称:&nbsp;<%=dJson["Name"].Value%>&nbsp;&nbsp;&nbsp;版本:&nbsp;<%=dJson["Version"].Value%>
            </div>
            <%
                dJson.Dispose();
            %>
            <div class="plug-NavLine">
                <table style="width: 1010px;">
                    <tr>
                        <th style="width: 30px;">序号</th>
                        <th style="width: 120px;">表名称</th>
                        <th style="width: 150px;">显示名称</th>
                        <th style="width: 80px;">管理对象</th>
                        <th style="width: 80px;">结构版本</th>
                        <th style="width: 80px;">管理版本</th>
                        <th style="width: 80px;">更新版本</th>
                        <th>表说明</th>
                    </tr>
                    <% 
                        using (Ly.Formats.JsonObject jsObj = new Ly.Formats.JsonObject()) {
                            jsObj.InnerJson = szJson;
                            ///输出列表
                            for (int i = 0; i < jsObj.Count; i++) {
                                Ly.Formats.JsonObject jup = jsObj[i];
                                if (jup.Children.Count > 0) {
                                    string szVer = "无";
                                    string szOAVer = "无";
                                    string szObj = "-";
                                    if (gTab.SystemObjects.GetDataByName(jup.Name)) {
                                        szVer = gTab.SystemObjects.Structure.Version;
                                        szOAVer = gTab.SystemObjects.Structure.OAVersion;
                                    }
                                    if (gTab.SystemTables.GetDataByName(jup.Name)) {
                                        szObj = gTab.SystemTables.Structure.ID.ToString().PadLeft(6, '0');
                                    }
                                    string szColor = "";
                                    if (szVer != jup["Ver"].Value) {
                                        szColor = "color:#900;";
                                    } else if (szOAVer != jup["Ver"].Value) {
                                        szColor = "color:#090;";
                                    }
                    %>
                    <tr id="DB_<%=jup.Name%>" onclick="Page.Functions.DBManager.Select('<%=jup.Name%>');" style="cursor: default; <%=szColor%>">
                        <td><%=i + 1%></td>
                        <td><%=jup.Name%></td>
                        <td><%=jup["Text"].Value%></td>
                        <td style="text-align: center;"><%=szObj%></td>
                        <td style="text-align: center;"><%=szVer%></td>
                        <td style="text-align: center;"><%=szOAVer%></td>
                        <td style="text-align: center;"><%=jup["Ver"].Value%></td>
                        <td><%=jup["Description"].Value%></td>
                    </tr>
                    <%
                                }
                            }
                        }
                    %>
                </table>
            </div>
            <%
                }
            %>
            <%pg.Dispose();%>
        </div>
    </form>
</body>
</html>
