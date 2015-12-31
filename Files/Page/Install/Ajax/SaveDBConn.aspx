<%@ Page Language="C#" %>

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
            <%
                Response.Clear();

                //string szName = Pub.Request(this, "Arg_Name");
                string dbHost = Pub.Request(this, "dbHost");// pg["Arg_File"];
                string dbName = Pub.Request(this, "dbName");// pg["Arg_File"];
                string dbPwd = Pub.Request(this, "dbPwd");// pg["Arg_File"];

                XPort xp = new XPort();

                string szConnString = "data source=" + dbHost + ";user id=" + dbName + ";Password=" + dbPwd + ";Initial Catalog=master";

                try {
                    using (dyk.Database.SQLClient Conn = new dyk.Database.SQLClient(szConnString)) {
                        Conn.ExecuteReader("select 1");
                        //string szSql = "if not exists(select * from sysdatabases where name='Aos')";
                        //szSql += "create database [Aos]";
                        //szSql += "on  primary {";
                        //szSql += "name='Aos_data',";
                        //szSql += "filename='" + WebConfig.SZ_DIR_DATABASE + "\\Aos_data.mdf',";
                        //szSql += "create database [Aos]";
                        //szSql += "create database [Aos]";
                        //szSql += "create database [Aos]";
                        //szSql += "create database [Aos]";
                        //szSql += "create database [Aos]";
                        //szSql += "create database [Aos]";
                        //Conn.ExecuteNonQuery(szSql);
                    }
                } catch (Exception ex) {
                    xp.Message = "数据库连接设置失败:" + ex.Message;
                    Response.Write(xp.ToString());
                    Response.End();
                }

                string szFileConnection = Server.MapPath(WebConfig.SZ_FILE_CONNECTION);
                string szConnJson = dyk.IO.File.DisplacementUTF8.ReadAllText(szFileConnection, true);

                using (dyk.Format.XML json = new dyk.Format.XML(szConnJson)) {

                    string szHost = json["sqlserver.source"].Value;

                    if (szHost != "") {
                        xp.Message = "数据库连接设置失败:配置文件不为空，如需要重新设置，请先删除网站下的数据库连接配置文件。";
                        Response.Write(xp.ToString());
                        Response.End();
                    }

                    json["sqlserver.source"].InnerXML = dbHost;
                    json["sqlserver.user"].InnerXML = dbName;
                    json["sqlserver.password"].InnerXML = dbPwd;

                    dyk.IO.File.DisplacementUTF8.WriteAllText(szFileConnection, json.ToString());
                }

                //pg.OutPutJsonRequest();
                xp.Refresh = 1;
                Response.Write(xp.ToString());
                Response.End();
            %>
        </div>
    </form>
</body>
</html>
