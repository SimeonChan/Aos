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
                string szName = pg["name"];

                //读取基础数据库配置文件
                string szJson = Pub.IO.ReadAllEncryptionText(Server.MapPath(WebConfig.SZ_DB_PATH));

                try {
                    #region [=====处理主体=====]
                    Ly.DB.Dream.Tables gTab = new Ly.DB.Dream.Tables(this.ConnectString);
                    using (Ly.Formats.Json json = new Ly.Formats.Json(szJson)) {
                        for (int i = 0; i < json.Object.Count; i++) {
                            Ly.Formats.JsonUnitPoint jup = json.Object[i];
                            if (jup.Name == szName) {
                                using (Ly.Data.SQLClient Conn = new Ly.Data.SQLClient(this.ConnectString)) {
                                    Conn.NewCmd("select ID from sysobjects where type='U' and name=@Name");
                                    Conn.AddParameter("@Name", jup.Name, System.Data.SqlDbType.VarChar, 50);
                                    Conn.ExecuteReader();
                                    if (Conn.DataReader.Read()) {
                                        #region [=====更新表结构=====]
                                        for (int j = 0; j < jup["Columns"].Count; j++) {
                                            using (Ly.Data.SQLClient ConnNew = new Ly.Data.SQLClient(this.ConnectString)) {
                                                ConnNew.NewCmd("select * from syscolumns where id=@ID and name=@Name");
                                                ConnNew.AddParameter("@ID", Conn.DataReader["ID"], System.Data.SqlDbType.Decimal);
                                                ConnNew.AddParameter("@Name", jup["Columns"][j].Name, System.Data.SqlDbType.VarChar, 50);
                                                ConnNew.ExecuteReader();
                                                if (ConnNew.DataReader.Read()) {
                                                    #region [=====更新字段=====]
                                                    using (Ly.Data.SQLClient ConnAlter = new Ly.Data.SQLClient(this.ConnectString)) {
                                                        string szAlter = "alter table [" + jup.Name + "] alter column [" + jup["Columns"][j].Name + "] " + jup["Columns"][j].Value;
                                                        //pg.OutPut(szAlter + "<br />");
                                                        ConnAlter.ExecuteNonQuery(szAlter);
                                                    }
                                                    #endregion
                                                } else {
                                                    #region [=====添加字段=====]
                                                    using (Ly.Data.SQLClient ConnAlter = new Ly.Data.SQLClient(this.ConnectString)) {
                                                        string szAlter = "alter table [" + jup.Name + "] add [" + jup["Columns"][j].Name + "] " + jup["Columns"][j].Value;
                                                        //pg.OutPut(szAlter + "<br />");
                                                        ConnAlter.ExecuteNonQuery(szAlter);
                                                    }
                                                    #endregion
                                                }
                                            }
                                        }
                                        #endregion
                                    } else {
                                        #region [=====添加表=====]
                                        using (Ly.Data.SQLClient ConnAlter = new Ly.Data.SQLClient(this.ConnectString)) {
                                            string szAlter = "create table [" + jup.Name + "](";
                                            szAlter += "[ID] numeric(18,0) identity(1,1) PRIMARY KEY";
                                            for (int j = 0; j < jup["Columns"].Count; j++) {
                                                szAlter += ",[" + jup["Columns"][j].Name + "] " + jup["Columns"][j].Value;
                                            }
                                            szAlter += ")";
                                            //pg.OutPut(szAlter + "<br />");
                                            ConnAlter.ExecuteNonQuery(szAlter);
                                        }
                                        #endregion
                                    }
                                }
                                if (gTab.SystemObjects.GetDataByName(jup.Name)) {
                                    gTab.SystemObjects.Structure.Version = jup["Ver"].Value;
                                    gTab.SystemObjects.UpdateByID();
                                } else {
                                    gTab.SystemObjects.Structure.Name = jup.Name;
                                    gTab.SystemObjects.Structure.Version = jup["Ver"].Value;
                                    gTab.SystemObjects.Add();
                                }
                            }
                        }
                    }
                    #endregion
                    pg.PageRequest.Message = "更新成功!";
                    using (ClsAjaxRequest.Arg arg = new ClsAjaxRequest.Arg(pg)) {
                        pg.PageRequest.SetAjaxLoad(pg.PageArgs.UIMain, pg.PageArgs.Path + "Main.aspx", arg, "刷新主界面...");
                    }
                } catch (Exception ex) {
                    pg.PageRequest.Message = "更新成功:" + ex.Message;
                }

                pg.OutPutJsonRequest();
            %>
            <%pg.Dispose();%>
        </div>
    </form>
</body>
</html>
