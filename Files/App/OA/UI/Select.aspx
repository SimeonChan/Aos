<%@ Page Language="C#" Inherits="ClsPage" ValidateRequest="false" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<script runat="server">
    protected int gintTable;
    //protected int gintColumn;
    protected String gstrColumn;
    protected String gstrConnString;
    protected String gstrFullPath;
    protected Ly.Formats.Json gJson;
    protected string gstrFormStyle;
    protected string gstrFormContent;
    protected string gstrFormScript;
    protected Ly.IO.Json gCache = new Ly.IO.Json();

    protected string gszSql;
</script>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
    <title></title>
    <link href="/css/Page.css" rel="stylesheet" />
    <link href="Css/Default.css" rel="stylesheet" />
</head>
<body>
    <form id="form1" runat="server">
        <div>
            <%ClsAjaxPage pg = new ClsAjaxPage(this); %>
            <%
                string sPath = Pub.Request(this, "Arg_Select_Path");
                string sID = Pub.Request(this, "Arg_Select_ID");
                string sInpuntID = Pub.Request(this, "Arg_Select_InputID");

                //gstrConnString = Pub.IO.ReadAllText(Server.MapPath("Conn.txt"));
                gintTable = Ly.String.Source(Pub.Request(this, "Arg_Select_Table")).toInteger;
                //gintColumn = Ly.String.Source(Pub.Request(this, "Column")).toInteger;
                //gintDB = Ly.String.Source(Pub.Request(this, "DB")).toInteger;
                gstrColumn = Pub.Request(this, "Arg_Select_Property");
                gstrConnString = this.ConnectString;
                //Ly.DB.Dream.AzTables gTabs = new Ly.DB.Dream.AzTables(gstrConnString);

                dyk.DB.Base.SystemTables.ExecutionExp gSystemTables = new dyk.DB.Base.SystemTables.ExecutionExp(gstrConnString);

                gSystemTables.GetDataByID(gintTable);

                //读取SQL脚本内容
                //string szSettingPath = Server.MapPath(this.WebConfig.SharePath + "/" + gSystemTables.Structure.Name);
                string szSettingPath = Server.MapPath(gSystemTables.Structure.SavePath);
                if (!System.IO.Directory.Exists(szSettingPath)) System.IO.Directory.CreateDirectory(szSettingPath);
                gszSql = Pub.IO.ReadAllText(szSettingPath + "/" + sID + "_Value.azsql");

                using (AzSqlProgram Asm = new AzSqlProgram(this, gstrConnString, null)) {
                    try {
                        gszSql = Asm.ExecuteString(gszSql);
                    } catch (Exception ex) {
                        pg.OutPut("脚本执行发生异常:" + ex.Message + "<br><br>");
                        pg.OutPut(Asm.Program.Debug().Replace("\r\n", "<br>").Replace("\n", "<br>").Replace(" ", "&nbsp;"));
                    } finally {
                        //pg.OutPut(Asm.Program.Debug().Replace("\r\n", "<br>").Replace("\n", "<br>").Replace(" ", "&nbsp;"));
                    }
                    //pg.OutPutAsText(Asm.Test(gszSql));
                    //pg.Dispose();
                }

                //读取配置中的Form信息
                //gstrFullPath = Server.MapPath(this.WebConfig.SharePath + "/" + gTabs.SystemTables.Structure.Name + "/UI.json");
                gstrFullPath = Server.MapPath(gSystemTables.Structure.SavePath + "/UI.json");
                string sJson = Pub.IO.ReadAllEncryptionText(gstrFullPath);
                gJson = new Ly.Formats.Json(sJson);

                //找到相应的Value设置
                Ly.Formats.Json jBindings = new Ly.Formats.Json(); ;
                for (int i = 0; i < gJson.Object.Count; i++) {
                    Ly.Formats.JsonUnitPoint obj = gJson.Object[i];
                    if (obj.Name == "TextBox") {
                        if (obj["ID"].Value == sID) {
                            using (AzSqlProgram Asm = new AzSqlProgram(this, gstrConnString, null)) {
                                string szTemp = Asm.ExecuteString(obj["Value"]["Bindings"].ToJsonString());
                                jBindings.Object.SetChildrenByJsonString(szTemp);
                            }
                        }
                    }
                }

            %>
            <div class="plug-MsgNav">
                <div id="<%=pg.PageArgs.Dialog_ElementID%>_Info" style="float: left; padding: 2px 3px 0px 3px;">从以下列表中选择一个项目</div>
                <div style="float: right;">
                    <input id="<%=pg.PageArgs.Dialog_ElementID%>_Canel" type="button" value="取消选择" onclick="$.Dialog.Close(<%="'"+pg.PageArgs.Dialog_ID+"'"%>);" />
                </div>
            </div>
            <div class="plug-NavLine" style="position: relative; <%=gstrFormStyle%>">
                <%
                    using (Ly.Data.SQLClient Conn = new Ly.Data.SQLClient(gstrConnString)) {
                        try {
                            Conn.ExecuteReader(gszSql);
                        } catch (Exception ex) {
                            //异常情况下输出调试信息
                            pg.OutPutAsText("Error:" + ex.Message);
                            pg.OutPut("<br>");
                            pg.OutPutAsText(gszSql);
                            pg.Dispose();
                        }
                %>
                <table>
                    <tr>
                        <%
                            for (int i = 0; i < Conn.DataReader.FieldCount; i++) {
                        %>
                        <th><%=Conn.DataReader.GetName(i)%></th>
                        <%
                            }
                        %>
                        <th>操作</th>
                        <% while (Conn.DataReader.Read()) {%>
                        <tr>
                            <%for (int i = 0; i < Conn.DataReader.FieldCount; i++) { %>
                            <td><%=Conn.DataReader[i].ToString()%></td>
                            <%} %>
                            <%
                                string szSaveScript = "";
                                for (int j = 0; j < jBindings.Object.Count; j++) {
                                    Ly.Formats.JsonUnitPoint jup = jBindings.Object[j];
                                    szSaveScript += "$('#" + sInpuntID + "_" + jup.Name + "').val('" + Conn.DataReader[jup.Value].ToString() + "');";
                                }
                            %>
                            <td><a href="javascript:;" onclick="<%=szSaveScript%>$.Dialog.Close(<%="'" + pg.PageArgs.Dialog_ID + "'"%>);">选择</a></td>
                        </tr>
                        <%} %>
                    </tr>
                </table>
                <%} %>
            </div>
            <%pg.Dispose();%>
        </div>
    </form>
</body>
</html>
