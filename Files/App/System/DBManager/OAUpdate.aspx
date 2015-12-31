<%@ Page Language="C#" Inherits="ClsPage" %>

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
                string szName = pg["Arg_Name"];
                string szFile = pg["Arg_File"];

                //读取基础数据库配置文件
                string szPath = Server.MapPath(WebConfig.SZ_PLUG + "/" + szFile + "/db.json");
                //string szJson = Pub.IO.ReadAllEncryptionText(Server.MapPath(WebConfig.SZ_DB_PATH + "/" + szFile + ".json"));
                string szJson = Pub.IO.ReadAllEncryptionText(szPath);

                try {
                    #region [=====处理主体=====]
                    //Ly.DB.Dream.Tables gTab = new Ly.DB.Dream.Tables(this.ConnectString);
                    using (Ly.Formats.JsonObject json = new Ly.Formats.JsonObject()) {
                        json.InnerJson = szJson;
                        //for (int i = 0; i < json.Object.Count; i++) {
                        Ly.Formats.JsonObject jup = json[szName];
                        if (jup["Ver"].Value != "") {

                            string szText = jup["Text"].Value;

                            if (szText == "") szText = szName;

                            //创建表管理信息
                            using (dyk.DB.Base.SystemTables.ExecutionExp st = new dyk.DB.Base.SystemTables.ExecutionExp(this.ConnectString)) {
                                if (st.GetDataByName(jup.Name)) {
                                    st.Structure.Text = szText;
                                    st.Structure.Visible = 1;
                                    st.Structure.Lv = 99;
                                    st.Structure.SavePath = WebConfig.SZ_PLUG + "/" + szFile + "/" + szName;
                                    st.UpdateByID();
                                } else {
                                    st.Structure.Name = jup.Name;
                                    st.Structure.Text = szText;
                                    using (dyk.DB.Kernel.SystemAutomatic.ExecutionExp sa = new dyk.DB.Kernel.SystemAutomatic.ExecutionExp(this.ConnectString)) {
                                        st.Structure.Index = sa.GetNewAutomatic("Table.Index");
                                    }
                                    // = gTab.SystemAutomatic.GetNewAutomatic("Table.Index");
                                    st.Structure.SavePath = WebConfig.SZ_PLUG + "/" + szFile + "/" + szName;
                                    st.Structure.Visible = 1;
                                    st.Structure.Lv = 99;
                                    st.Structure.CatalogID = 0;
                                    st.Add();
                                    st.GetDataByName(jup.Name);
                                    string szSavePath = Server.MapPath(st.Structure.SavePath);
                                    if (!System.IO.Directory.Exists(szSavePath)) System.IO.Directory.CreateDirectory(szSavePath);
                                }

                                long lngID = st.Structure.ID;

                                //创建Admin权限
                                #region [=====创建Admin权限=====]

                                long lngAdminID = 0;

                                using (dyk.DB.Base.SystemUsers.ExecutionExp su = new dyk.DB.Base.SystemUsers.ExecutionExp(this.ConnectString)) {
                                    if (su.GetDataByName("root")) {
                                        lngAdminID = su.Structure.ID;
                                    }
                                }

                                using (dyk.DB.Base.SystemUserLimits.ExecutionExp sl = new dyk.DB.Base.SystemUserLimits.ExecutionExp(this.ConnectString)) {
                                    if (lngAdminID > 0) {
                                        if (sl.GetDataByUserAndTable(lngAdminID, lngID)) {
                                            sl.Structure.Limits = dyk.Format.Limits.AllLimits().ToString();
                                            sl.UpdateByID();
                                        } else {
                                            sl.Structure.TableID = lngID;
                                            sl.Structure.UserID = lngAdminID;
                                            sl.Structure.Limits = dyk.Format.Limits.AllLimits().ToString();
                                            sl.Add();
                                        }
                                    }
                                }

                                #endregion

                                #region [=====更新ID字段管理=====]

                                //更新ID字段管理
                                using (dyk.DB.Base.SystemColumns.ExecutionExp sc = new dyk.DB.Base.SystemColumns.ExecutionExp(this.ConnectString)) {
                                    if (sc.GetDataByParentIDAndName(lngID, "ID")) {
                                        sc.Structure.Type = "numeric(18,0)";
                                        sc.Structure.Text = "编号";
                                        sc.UpdateByID();
                                    } else {
                                        sc.Structure.ParentID = lngID;
                                        sc.Structure.Name = "ID";
                                        sc.Structure.Text = "编号";
                                        sc.Structure.Type = "numeric(18,0)";
                                        using (dyk.DB.Kernel.SystemAutomatic.ExecutionExp sa = new dyk.DB.Kernel.SystemAutomatic.ExecutionExp(this.ConnectString)) {
                                            st.Structure.Index = sa.GetNewAutomatic(jup.Name + ".Index");
                                        }
                                        //sc.Structure.Index = gTab.SystemAutomatic.GetNewAutomatic(jup.Name + ".Index");
                                        sc.Structure.Visible = 1;
                                        sc.Structure.Width = 100;
                                        sc.Add();
                                    }


                                    #region [=====更新字段管理信息=====]
                                    //更新字段管理信息
                                    for (int j = 0; j < jup["Columns"].Count; j++) {
                                        Ly.Formats.JsonObject jObj = jup["Columns"][j];

                                        string szType = jObj["Type"].Value;
                                        string szShowText = jObj["Text"].Value;

                                        if (szType == "") szType = jObj.Value;
                                        if (szShowText == "") szShowText = jObj.Name;

                                        if (sc.GetDataByParentIDAndName(lngID, jObj.Name)) {
                                            sc.Structure.Type = szType;
                                            sc.Structure.Text = szShowText;
                                            sc.UpdateByID();
                                        } else {
                                            sc.Structure.ParentID = lngID;
                                            sc.Structure.Name = jObj.Name;
                                            sc.Structure.Text = szShowText;
                                            sc.Structure.Type = szType;
                                            using (dyk.DB.Kernel.SystemAutomatic.ExecutionExp sa = new dyk.DB.Kernel.SystemAutomatic.ExecutionExp(this.ConnectString)) {
                                                sc.Structure.Index = sa.GetNewAutomatic(jup.Name + ".Index");
                                            }
                                            //sc.Structure.Index = gTab.SystemAutomatic.GetNewAutomatic(jup.Name + ".Index");
                                            sc.Structure.Visible = 1;
                                            sc.Structure.Width = 100;
                                            sc.Add();
                                        }

                                    }

                                    #endregion

                                }

                                #endregion

                                #region [=====更新状态=====]

                                //更新状态
                                using (dyk.DB.Base.SystemObjects.ExecutionExp so = new dyk.DB.Base.SystemObjects.ExecutionExp(this.ConnectString)) {
                                    if (so.GetDataByName(jup.Name)) {
                                        so.Structure.OAVersion = jup["Ver"].Value;
                                        so.UpdateByID();
                                    } else {
                                        so.Structure.Name = jup.Name;
                                        so.Structure.OAVersion = jup["Ver"].Value;
                                        so.Add();
                                    }
                                }

                                #endregion

                            }



                            pg.PageRequest.Message = "更新成功!";
                            using (ClsAjaxRequest.Arg arg = new ClsAjaxRequest.Arg(pg)) {
                                arg["Arg_Name"] = szFile;
                                pg.PageRequest.SetAjaxLoad(pg.PageArgs.UIMain, pg.PageArgs.Path + "Main.aspx", arg, "刷新主界面...");
                            }
                        } else {
                            pg.PageRequest.Message = "未找到[" + szName + "]表的设置内容!";
                        }
                        //}
                    }
                    #endregion
                } catch (Exception ex) {
                    pg.PageRequest.Message = "更新失败:" + ex.Message;
                }

                pg.OutPutJsonRequest();
            %>
            <%pg.Dispose();%>
        </div>
    </form>
</body>
</html>
