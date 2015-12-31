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

                string szName = Pub.Request(this, "Arg_Name");
                string szFile = Pub.Request(this, "Arg_File");// pg["Arg_File"];

                string gstrConnString = Pub.IO.ReadAllText(Server.MapPath(WebConfig.SZ_PATH_CONNECTSTRING));

                ClsAjaxRequest ar = new ClsAjaxRequest();

                //读取基础数据库配置文件
                string szJson = Pub.IO.ReadAllEncryptionText(Server.MapPath(WebConfig.SZ_DB_PATH + "/" + szFile + ".json"));

                try {
                    #region [=====处理主体=====]
                    Ly.DB.Dream.Tables gTab = new Ly.DB.Dream.Tables(gstrConnString);
                    using (Ly.Formats.JsonObject json = new Ly.Formats.JsonObject()) {
                        json.InnerJson = szJson;
                        //for (int i = 0; i < json.Object.Count; i++) {
                        Ly.Formats.JsonObject jup = json[szName];
                        if (jup["Ver"].Value != "") {

                            using (Ly.Data.SQLClient Conn = new Ly.Data.SQLClient(gstrConnString)) {
                                Conn.NewCmd("select ID from sysobjects where type='U' and name=@Name");
                                Conn.AddParameter("@Name", jup.Name, System.Data.SqlDbType.VarChar, 50);
                                Conn.ExecuteReader();
                                if (Conn.DataReader.Read()) {
                                    #region [=====更新表结构=====]
                                    for (int j = 0; j < jup["Columns"].Count; j++) {

                                        Ly.Formats.JsonObject jObj = jup["Columns"][j];
                                        string szType = jObj["Type"].Value;
                                        if (szType == "") szType = jObj.Value;

                                        using (Ly.Data.SQLClient ConnNew = new Ly.Data.SQLClient(gstrConnString)) {
                                            ConnNew.NewCmd("select * from syscolumns where id=@ID and name=@Name");
                                            ConnNew.AddParameter("@ID", Conn.DataReader["ID"], System.Data.SqlDbType.Decimal);
                                            ConnNew.AddParameter("@Name", jup["Columns"][j].Name, System.Data.SqlDbType.VarChar, 50);
                                            ConnNew.ExecuteReader();
                                            if (ConnNew.DataReader.Read()) {
                                                #region [=====更新字段=====]
                                                using (Ly.Data.SQLClient ConnAlter = new Ly.Data.SQLClient(gstrConnString)) {
                                                    string szAlter = "alter table [" + jup.Name + "] alter column [" + jObj.Name + "] " + szType;
                                                    //pg.OutPut(szAlter + "<br />");
                                                    ConnAlter.ExecuteNonQuery(szAlter);
                                                }
                                                #endregion
                                            } else {
                                                #region [=====添加字段=====]
                                                using (Ly.Data.SQLClient ConnAlter = new Ly.Data.SQLClient(gstrConnString)) {
                                                    string szAlter = "alter table [" + jup.Name + "] add [" + jObj.Name + "] " + szType;
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
                                    using (Ly.Data.SQLClient ConnAlter = new Ly.Data.SQLClient(gstrConnString)) {
                                        string szAlter = "create table [" + jup.Name + "](";
                                        szAlter += "[ID] numeric(18,0) identity(1,1) PRIMARY KEY";
                                        for (int j = 0; j < jup["Columns"].Count; j++) {

                                            Ly.Formats.JsonObject jObj = jup["Columns"][j];
                                            string szType = jObj["Type"].Value;
                                            if (szType == "") szType = jObj.Value;

                                            szAlter += ",[" + jup["Columns"][j].Name + "] " + szType;
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

                            ar.Message = "更新成功!";
                            ar.Refresh = 1;

                            //pg.PageRequest.Message = "更新成功!";
                            //pg.PageRequest.Refresh = 1;
                            //using (ClsAjaxRequest.Arg arg = new ClsAjaxRequest.Arg(pg)) {
                            //    arg["Arg_Name"] = szFile;
                            //    pg.PageRequest.SetAjaxLoad(pg.PageArgs.UIMain, pg.PageArgs.Path + "Main.aspx", arg, "刷新主界面...");
                            //}
                        } else {
                            ar.Message = "未找到[" + szName + "]表的设置内容!";
                            //pg.PageRequest.Message = "未找到[" + szName + "]表的设置内容!";
                        }
                        //}
                    }
                    #endregion
                } catch (Exception ex) {
                    ar.Message = "更新失败:" + ex.Message;
                    //pg.PageRequest.Message = "更新失败:" + ex.Message;
                }

                //pg.OutPutJsonRequest();
                Response.Write(ar.ToString());
                Response.End();
            %>
        </div>
    </form>
</body>
</html>
