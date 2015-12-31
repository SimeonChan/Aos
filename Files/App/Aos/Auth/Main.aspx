<%@ Page Language="C#" Inherits="ClsPage" ValidateRequest="false" %>

<!DOCTYPE html>

<script runat="server">
    protected String gstrConnString;
    protected long gintTable;
    protected long glngRelation;
    protected long glngID;
    protected int gintIndex;
    protected string gstrArgs;

    //protected Ly.DB.Dream.AzTables gTab;
    protected String gstrFullPath;
    protected Ly.Formats.JsonObject gJson;
    protected int gintWidth;
    protected int gintHeight;

    protected int gintLines;
    protected int gintPage;
    protected int gnLineCount;
    protected int gnPageCount;

    protected string gstrSQL;
    protected string gszCountSQL;
    protected Ly.IO.Json gAddJson;
    protected string gstrRelation;

    protected string gszWaitHtml = "正在加载页面...";

    protected dyk.DB.Base.SystemTables.ExecutionExp gSystemTables;
    protected dyk.DB.Base.SystemColumns.ExecutionExp gSystemColumns;
    protected dyk.DB.OA.SystemRelation.ExecutionExp gSystemRelation;
    protected dyk.DB.OA.SystemHistory.ExecutionExp gSystemHistory;
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
            <div style="width: 100%; border-top: 1px solid #eee;">
                <table id="Aos_Auth_Table" style="width: 100%; border-collapse: collapse;">
                    <tr style="background: #ccc; color: #222;">
                        <th style="width: 40px; border-right: 1px solid #eee; padding: 6px;">序号</th>
                        <th style="width: 200px; border-right: 1px solid #eee; padding: 6px;">授权对象</th>
                        <th style="width: 130px; border-right: 1px solid #eee; padding: 6px;">授权码</th>
                        <th style="width: 50px; border-right: 1px solid #eee; padding: 6px;">授权等级</th>
                        <th style="width: 100px; border-right: 1px solid #eee; padding: 6px;">数据库名称</th>
                        <th style="width: 200px; border-right: 1px solid #eee; padding: 6px;">数据库地址</th>
                        <th style="width: 100px; border-right: 1px solid #eee; padding: 6px;">数据库用户</th>
                        <th style="width: 100px; border-right: 1px solid #eee; padding: 6px;">数据库密码</th>
                        <th style="width: 40px; border-right: 1px solid #eee; padding: 6px;">状态</th>
                        <th style="padding: 6px;">&nbsp;</th>
                    </tr>
                    <%

                        //读取数据库连接设定
                        string szConnJson = dyk.IO.File.DisplacementUTF8.ReadAllText(Server.MapPath(WebConfig.SZ_FILE_CONNECTION), true);

                        string szHost = "";
                        string szName = "";
                        string szPwd = "";

                        using (dyk.Format.XML json = new dyk.Format.XML(szConnJson)) {
                            szHost = json["sqlserver.source"].InnerText;
                            szName = json["sqlserver.user"].InnerText;
                            szPwd = json["sqlserver.password"].InnerText;
                        }

                        using (dyk.DB.Aos.AosAuthorize.ExecutionExp aa = new dyk.DB.Aos.AosAuthorize.ExecutionExp(this.AosConnectString)) {
                            aa.GetDatas();
                            for (int i = 0; i < aa.StructureCollection.Count; i++) {
                                dyk.DB.Aos.AosAuthorize.StructureExp st = aa.StructureCollection[i];

                                string szConnString = "data source=" + szHost + ";user id=" + szName + ";Password=" + szPwd + ";Initial Catalog=master";
                                if (st.DBIP != "") {
                                    szConnString = "data source=" + st.DBIP + ";user id=" + st.DBUser + ";Password=" + st.DBPwd + ";Initial Catalog=master";
                                }

                                bool bCreate = false;

                                using (Ly.Data.SQLClient Conn = new Ly.Data.SQLClient(szConnString)) {
                                    Conn.ExecuteReader("select * from sysdatabases where name='Aos_" + st.DBSign + "'");
                                    bCreate = Conn.DataReader.Read();
                                }

                    %>
                    <tr id="Aos_Auth_tr_<%=st.ID%>">
                        <td style="border-right: 1px solid #eee; border-bottom: 1px solid #eee; padding: 3px; text-align: right;" onclick="X.Custom.AosAuth.Select(<%=st.ID%>);"><%=i+1%></td>
                        <td id="Aos_Auth_tr_<%=st.ID%>_td_Name" style="border-right: 1px solid #eee; border-bottom: 1px solid #eee; padding: 3px;">
                            <div style="width: 100%;" onclick="X.Custom.AosAuth.Edit(<%=st.ID%>,'Name');"><%=st.Name!=""?st.Name:"&nbsp;"%></div>
                        </td>
                        <td id="Aos_Auth_tr_<%=st.ID%>_td_Code" style="border-right: 1px solid #eee; border-bottom: 1px solid #eee; padding: 3px; text-align: center;"><%=st.Code%></td>
                        <td id="Aos_Auth_tr_<%=st.ID%>_td_Lv" style="border-right: 1px solid #eee; border-bottom: 1px solid #eee; padding: 3px; text-align: center;">
                            <div style="width: 100%;" onclick="X.Custom.AosAuth.Edit(<%=st.ID%>,'Lv');"><%=st.Lv!=""?st.Lv:"&nbsp;"%></div>
                        </td>
                        <td id="Aos_Auth_tr_<%=st.ID%>_td_DBSign" style="border-right: 1px solid #eee; border-bottom: 1px solid #eee; padding: 3px; text-align: center;">
                            <div style="width: 100%;" onclick="X.Custom.AosAuth.Edit(<%=st.ID%>,'DBSign');"><%=st.DBSign!=""?st.DBSign:"&nbsp;"%></div>
                        </td>
                        <td id="Aos_Auth_tr_<%=st.ID%>_td_DBIP" style="border-right: 1px solid #eee; border-bottom: 1px solid #eee; padding: 3px;">
                            <div style="width: 100%;" onclick="X.Custom.AosAuth.Edit(<%=st.ID%>,'DBIP');"><%=st.DBIP!=""?st.DBIP:"&nbsp;"%></div>
                        </td>
                        <td id="Aos_Auth_tr_<%=st.ID%>_td_DBUser" style="border-right: 1px solid #eee; border-bottom: 1px solid #eee; padding: 3px;">
                            <div style="width: 100%;" onclick="X.Custom.AosAuth.Edit(<%=st.DBUser%>,'Lv');"><%=st.DBUser!=""?st.DBUser:"&nbsp;"%></div>
                        </td>
                        <td id="Aos_Auth_tr_<%=st.ID%>_td_DBPwd" style="border-right: 1px solid #eee; border-bottom: 1px solid #eee; padding: 3px;">
                            <div style="width: 100%;" onclick="X.Custom.AosAuth.Edit(<%=st.ID%>,'DBPwd');"><%=st.DBPwd!=""?st.DBPwd:"&nbsp;"%></div>
                        </td>
                        <td id="Aos_Auth_tr_<%=st.ID%>_td_Status" style="border-right: 1px solid #eee; border-bottom: 1px solid #eee; padding: 3px; text-align: center;"><%if (bCreate) {%><span style="color: #009900;">√</span><%} else {%><span style="color: #CCC;">×</span><%}%></td>
                        <td style="border-bottom: 1px solid #eee; padding: 4px;">&nbsp;</td>
                    </tr>
                    <%
                            }
                        }
                    %>
                </table>
            </div>

            <% pg.Dispose();%>
        </div>
    </form>
</body>
</html>
