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
                string dbRootPwd = Pub.Request(this, "dbRootPwd");// pg["Arg_File"];
                string dbRootPwdRe = Pub.Request(this, "dbRootPwdRe");// pg["Arg_File"];
                //string dbName = Pub.Request(this, "dbName");// pg["Arg_File"];
                string dbPath = "";// pg["Arg_File"];

                XPort xp = new XPort();

                if (dbRootPwd == "") {
                    xp.Message = "保存失败:Root密码不能为空!";
                    Response.Write(xp.ToString());
                    Response.End();
                }

                if (dbRootPwd != dbRootPwdRe) {
                    xp.Message = "保存失败:两次输入的Root密码不一致!";
                    Response.Write(xp.ToString());
                    Response.End();
                }

                //读取数据库保存地址
                string szFileSetting = Server.MapPath(WebConfig.SZ_FILE_SETTING);
                string szSetting = dyk.IO.File.UTF8.ReadAllText(szFileSetting, true);
                using (dyk.Format.XML xml = new dyk.Format.XML(szSetting)) {
                    dbPath = xml["Database.SavePath"].InnerText;
                }

                string szFileConnection = Server.MapPath(WebConfig.SZ_FILE_CONNECTION);
                string szConnJson = dyk.IO.File.DisplacementUTF8.ReadAllText(szFileConnection, true);

                //Response.Write(szConnJson);

                string szHost = "";
                string szName = "";
                string szPwd = "";

                using (dyk.Format.XML json = new dyk.Format.XML(szConnJson)) {
                    szHost = json["sqlserver.source"].InnerText;
                    szName = json["sqlserver.user"].InnerText;
                    szPwd = json["sqlserver.password"].InnerText;
                }

                gstrConnString = "data source=" + szHost + ";user id=" + szName + ";Password=" + szPwd + ";Initial Catalog=master";

                //string szConnString = "data source=" + dbHost + ";user id=" + dbName + ";Password=" + dbPwd + ";Initial Catalog=master";

                try {

                    //生成Aos库
                    using (dyk.Database.SQLClient Conn = new dyk.Database.SQLClient(gstrConnString)) {
                        string szSql = "if not exists(select * from sysdatabases where name='Aos_Manage')";
                        szSql += "create database [Aos_Manage]";
                        szSql += "on  primary (";
                        szSql += "name='Aos_Manage_data',";
                        szSql += "filename='" + dbPath + "\\Aos_Manage.mdf',";
                        szSql += "size=5mb,";
                        szSql += "filegrowth=15%)";
                        szSql += "log on (";
                        szSql += "name='Aos_Manage_log',";
                        szSql += "filename='" + dbPath + "\\Aos_Manage_log.ldf',";
                        szSql += "size=2mb,";
                        szSql += "filegrowth=1mb)";
                        Conn.ExecuteNonQuery(szSql);
                    }


                } catch (Exception ex) {
                    xp.Message = "Aos_Manage数据库设置失败:" + ex.Message;
                    Response.Write(xp.ToString());
                    Response.End();
                }


                try {

                    //重新设置连接数据库，将库设置为Aos_Manage
                    gstrConnString = "data source=" + szHost + ";user id=" + szName + ";Password=" + szPwd + ";Initial Catalog=Aos_Manage";

                    //读取基础数据库配置文件,添加数据表
                    string szJsBase = Pub.IO.ReadAllEncryptionText(Server.MapPath(WebConfig.SZ_FILE_DB_BASE));
                    using (dyk.Format.Json json = new dyk.Format.Json(szJsBase)) {
                        for (int i = 0; i < json.Children.Count; i++) {
                            dyk.Format.JsonObject jup = (dyk.Format.JsonObject)json.Children[i];
                            if (jup.Children.Count > 0) {
                                string szTabName = jup.Name;
                                string szVersion = jup["Ver"].Value;
                                string szSql = "if not exists(select ID from sysobjects where type='U' and name='" + szTabName + "')";
                                szSql += "create table [" + szTabName + "](";
                                szSql += "[ID] numeric(18,0) identity(1,1) PRIMARY KEY";

                                //添加字段信息
                                for (int j = 0; j < jup["Columns"].Children.Count; j++) {
                                    dyk.Format.JsonObject jObj = (dyk.Format.JsonObject)jup["Columns"][j];
                                    string szColName = jObj.Name;
                                    string szColType = jObj["Type"].Value;
                                    szSql += ",[" + szColName + "] " + szColType;
                                }
                                szSql += ")";

                                //执行添加语句
                                using (dyk.Database.SQLClient Conn = new dyk.Database.SQLClient(gstrConnString)) {
                                    Conn.ExecuteNonQuery(szSql);
                                }

                                //添加系统对象
                                using (dyk.DB.Base.SystemObjects.ExecutionExp ao = new dyk.DB.Base.SystemObjects.ExecutionExp(gstrConnString)) {
                                    if (ao.GetDataByName(szTabName)) {
                                        ao.Structure.Version = szVersion;
                                        ao.UpdateByID();
                                    } else {
                                        ao.Structure.Name = szTabName;
                                        ao.Structure.Version = szVersion;
                                        ao.Add();
                                    }
                                }

                            }
                        }
                    }

                } catch (Exception ex) {
                    xp.Message = "数据表添加失败:" + ex.Message;
                    Response.Write(xp.ToString());
                    Response.End();
                }

                //添加Root用户
                using (dyk.DB.Base.SystemUsers.ExecutionExp su = new dyk.DB.Base.SystemUsers.ExecutionExp(gstrConnString)) {
                    if (!su.GetDataByName("root")) {
                        su.Structure.Name = "root";
                        su.Structure.Nick = "系统管理员";
                        su.Structure.Pwd = Ly.String.Source(dbRootPwd).md5;
                        su.Add();
                        su.GetDataByName("root");

                        //添加root用户的访问权限
                        dyk.DB.OA.SystemLimits.LimitMgr lm = dyk.DB.OA.SystemLimits.LimitMgr.New();
                        lm.SetAllLimits();
                        string szAosConnString = "data source=" + szHost + ";user id=" + szName + ";Password=" + szPwd + ";Initial Catalog=Aos";
                        using (dyk.DB.Aos.AosApps.ExecutionExp aa = new dyk.DB.Aos.AosApps.ExecutionExp(szAosConnString)) {
                            aa.GetDatas();
                            for (int i = 0; i < aa.StructureCollection.Count; i++) {
                                using (dyk.DB.Base.SystemUserAppLimits.ExecutionExp sual = new dyk.DB.Base.SystemUserAppLimits.ExecutionExp(gstrConnString)) {
                                    sual.Structure.AppID = aa.StructureCollection[i].ID;
                                    sual.Structure.Limits = lm.ToString();
                                    sual.Structure.UserID = su.Structure.ID;
                                    sual.Add();
                                }
                            }
                        }

                    }
                }

                try {

                    //执行数据初始化
                    string szSqlBase = dyk.IO.File.UTF8.ReadAllText(Server.MapPath(WebConfig.SZ_FILE_SQL_BASE), true);
                    using (dyk.Database.SQLClient Conn = new dyk.Database.SQLClient(gstrConnString)) {
                        Conn.ExecuteNonQuery(szSqlBase);
                    }

                } catch (Exception ex) {
                    xp.Message = "数据初始化失败:" + ex.Message;
                    Response.Write(xp.ToString());
                    Response.End();
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
