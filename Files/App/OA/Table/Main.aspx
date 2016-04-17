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
            <%
                string szClick = "";
                string gstrPath = "";
                string szScript = "";

                string sPath = Pub.Request(this, "Path");
                string sID = Pub.Request(this, "ID");
                string sTable = Pub.Request(this, "Arg_Table");
                string szDate = this["Arg_Table_Date"];
                string szKey = this["Arg_Table_Key"];
                bool bDate = false;
                string szDateScript = "";
                string szSharePath = this.WebConfig.SharePath;
                Ly.Formats.XML Xml = new Ly.Formats.XML(pg.PageArgs.Arg_Table_Filters);

                gAddJson = new Ly.IO.Json();

                gintWidth = 300;
                gintHeight = 200;

                gintLines = 50;
                gintPage = Ly.String.Source(this["Arg_Page"]).toInteger;
                if (gintPage < 1) gintPage = 1;

                gstrConnString = Pub.IO.ReadAllText(Server.MapPath(this.WebConfig.ConnectStringPath));
                gintTable = Ly.String.Source(Pub.Request(this, "Arg_Table")).toLong;
                glngID = Ly.String.Source(pg["Arg_ID"]).toLong;
                glngRelation = Ly.String.Source(pg["Arg_Relation"]).toLong;
                gintIndex = Ly.String.Source(pg["Arg_Index"]).toInteger;
                //gTab = new Ly.DB.Dream.AzTables(gstrConnString);

                if (gintIndex < 1) gintIndex = 1;

                gSystemTables = new dyk.DB.Base.SystemTables.ExecutionExp(this.ConnectString);
                gSystemColumns = new dyk.DB.Base.SystemColumns.ExecutionExp(this.ConnectString);
                gSystemRelation = new dyk.DB.OA.SystemRelation.ExecutionExp(this.ConnectString);
                gSystemHistory = new dyk.DB.OA.SystemHistory.ExecutionExp(this.ConnectString);

                gSystemTables.GetDataByID(gintTable);
                gstrRelation = gSystemTables.Structure.Text;
                //gstrRelation = pg["Arg_RelationText"];

            %>

            <% 

                //查询表处理
                if (gSystemTables.Structure.Type == "查询表") {

                    #region [=====处理查询表====]

                    gintTable = 0;

                    //string szSelectPath = Server.MapPath(this.WebConfig.SharePath + "/" + gSystemTables.Structure.Name);
                    string szSelectPath = Server.MapPath(gSystemTables.Structure.SavePath);
                    if (!System.IO.Directory.Exists(szSelectPath)) System.IO.Directory.CreateDirectory(szSelectPath);
                    gstrFullPath = szSelectPath + "/UI.json";

                    string sJson = Pub.IO.ReadAllEncryptionText(gstrFullPath);

                    using (Ly.IO.Json js = new Ly.IO.Json()) {
                        js.LoadFromString(sJson);
                        string sTabText = js.Objects["Data"].Items["DefaultTable"].Value;

                        if (gSystemTables.GetDataByText(sTabText)) {
                            gintTable = gSystemTables.Structure.ID;
                            gstrRelation = gSystemTables.Structure.Text;
                        }
                        //gstrSQL = gChangeJsonToSql("{" + js.Objects["Data"].Items.ToString() + "}");

                        string json = "{" + js.Objects["Data"].Items.ToString() + "}";
                        //pg.OutPut(txtName + ":" + json + "<br/>");
                        using (AzJsonScript ajs = new AzJsonScript(this, gstrConnString, json)) {
                            gstrSQL = ajs.GetNormalSQLString();
                        }

                        Ly.IO.Json.ObjectIntegrated objAdd = js.Objects["Add"];
                        for (int i = 0; i < objAdd.Objects.Count; i++) {
                            Ly.IO.Json.ObjectIntegrated obj = objAdd.Objects[i];
                            switch (obj.Items["Type"].Value) {
                                case "Text":
                                    gAddJson.Items[obj.Name].Value = obj.Items["Binging"].Value;
                                    break;
                            }
                        }
                    }

                    //读取相应的字段结构
                    gSystemColumns.GetDatasByParentID(gintTable);

                    #endregion

                }
                if (gSystemTables.Structure.Type == "日数据表" || gSystemTables.Structure.Type == "月数据表" || gSystemTables.Structure.Type == "年数据表") {

                    #region [=====处理日期数据表====]

                    //读取相应的字段结构
                    gSystemColumns.GetDatasByParentID(gintTable);

                    //string szDate = this["date"].Trim();

                    switch (gSystemTables.Structure.Type) {
                        case "年数据表":
                            if (szDate == "") szDate = DateTime.Now.ToString("yyyy");
                            szDateScript = "DatePicker.YearPicker('" + sID + "_Date',$('#" + sID + "_Date').val());";
                            break;
                        case "月数据表":
                            if (szDate == "") szDate = DateTime.Now.ToString("yyyy-MM");
                            szDateScript = "DatePicker.MonthPicker('" + sID + "_Date',$('#" + sID + "_Date').val());";
                            break;
                        default:
                            if (szDate == "") szDate = DateTime.Now.ToString("yyyy-MM-dd");
                            szDateScript = "DatePicker.DayPicker('" + sID + "_Date',$('#" + sID + "_Date').val());";
                            break;
                    }

                    bDate = true;

                    Ly.Formats.Json js = new Ly.Formats.Json();
                    js["date"].Value = szDate;
                    js["pagesize"].Value = gintLines.ToString();
                    js["page"].Value = gintPage.ToString();

                    string szSqlCount = Pub.IO.ReadAllText(Server.MapPath(this.WebConfig.SharePath + "/" + gSystemTables.Structure.Name + "/Count.azsql"));
                    using (AzSqlProgram Asm = new AzSqlProgram(this, gstrConnString, js)) {
                        try {
                            gszCountSQL = Asm.ExecuteString(szSqlCount);
                        } catch (Exception ex) {
                            pg.OutPut("脚本执行发生异常:" + ex.Message + "<br><br>");
                            pg.OutPut(Asm.Program.Debug().Replace("\r\n", "<br>").Replace("\n", "<br>").Replace(" ", "&nbsp;"));
                        } finally {
                            //pg.OutPut(Asm.Program.Debug().Replace("\r\n", "<br>").Replace("\n", "<br>").Replace(" ", "&nbsp;"));
                        }
                        //pg.OutPutAsText(Asm.Test(gszSql));
                        //pg.Dispose();
                    }

                    string szSql = Pub.IO.ReadAllText(Server.MapPath(this.WebConfig.SharePath + "/" + gSystemTables.Structure.Name + "/Load.azsql"));
                    using (AzSqlProgram Asm = new AzSqlProgram(this, gstrConnString, js)) {
                        try {
                            gstrSQL = Asm.ExecuteString(szSql);
                        } catch (Exception ex) {
                            pg.OutPut("脚本执行发生异常:" + ex.Message + "<br><br>");
                            pg.OutPut(Asm.Program.Debug().Replace("\r\n", "<br>").Replace("\n", "<br>").Replace(" ", "&nbsp;"));
                        } finally {
                            //pg.OutPut(Asm.Program.Debug().Replace("\r\n", "<br>").Replace("\n", "<br>").Replace(" ", "&nbsp;"));
                        }
                        //pg.OutPutAsText(Asm.Test(gszSql));
                        //pg.Dispose();
                    }

                    #endregion

                } else if (gSystemTables.Structure.InheritTable > 0) {

                    #region [=====处理继承表====]

                    gintTable = (long)gSystemTables.Structure.InheritTable;
                    //读取相应的字段结构
                    gSystemColumns.GetDatasByParentID(gintTable);

                    string KeyOptions = "";

                    //读取相应的字段结构
                    gSystemColumns.GetDatasByParentID(gintTable);

                    ///生成快速查询语句
                    if (pg.PageArgs.Arg_Table_Key != "") {
                        for (int i = 0; i < gSystemColumns.StructureCollection.Count; i++) {
                            dyk.DB.Base.SystemColumns.StructureExp st = gSystemColumns.StructureCollection[i];
                            if (KeyOptions != "") KeyOptions += " or ";
                            switch (st.Type.ToLower()) {
                                case "text":
                                    KeyOptions += "cast([" + st.Name + "] as varchar) like '%" + pg.PageArgs.Arg_Table_Key + "%'";
                                    break;
                                default:
                                    KeyOptions += "[" + st.Name + "] like '%" + pg.PageArgs.Arg_Table_Key + "%'";
                                    break;
                            }
                        }
                        if (KeyOptions != "") KeyOptions = "(" + KeyOptions + ")";
                    }

                    #region [=====获取筛选数据=====]

                    string szFilters = "";

                    for (int i = 0; i < gSystemColumns.StructureCollection.Count; i++) {
                        dyk.DB.Base.SystemColumns.StructureExp st = gSystemColumns.StructureCollection[i];
                        string szFilterValue = pg["Table_Filters_" + st.Name];
                        pg.PageArgs["Table_Filters_" + st.Name].Value = szFilterValue;
                        if (szFilterValue != "") {
                            string szFilterTemps = "";
                            string[] szFilterValues = szFilterValue.Split('|');
                            for (int j = 0; j < szFilterValues.Length; j++) {
                                if (szFilterTemps != "") szFilterTemps += " or ";
                                szFilterTemps += "[" + st.Name + "]='" + szFilterValues[j] + "'";
                            }
                            if (szFilters != "") szFilters += " and ";
                            szFilters += "(" + szFilterTemps + ")";
                        }
                    }

                    if (szFilters != "") {
                        if (KeyOptions != "") {
                            KeyOptions += " and (" + szFilters + ")";
                        } else {
                            KeyOptions = "(" + szFilters + ")";
                        }
                    }

                    #endregion

                    string szInherit = Pub.IO.ReadAllText(Server.MapPath(this.WebConfig.SharePath + "/" + gSystemTables.Structure.Name + "/Inherit.azsql"));
                    using (Ly.Formats.Json json = new Ly.Formats.Json()) {
                        using (AzSqlProgram Asm = new AzSqlProgram(this, gstrConnString, json)) {
                            try {
                                szInherit = Asm.ExecuteString(szInherit);
                            } catch (Exception ex) {
                                pg.OutPut("脚本执行发生异常:" + ex.Message + "<br><br>");
                                pg.OutPut(Asm.Program.Debug().Replace("\r\n", "<br>").Replace("\n", "<br>").Replace(" ", "&nbsp;"));
                                pg.Dispose();
                            } finally {
                                //pg.OutPut(Asm.Program.Debug().Replace("\r\n", "<br>").Replace("\n", "<br>").Replace(" ", "&nbsp;"));
                            }
                            //pg.OutPutAsText(Asm.Test(gszSql));
                            //pg.Dispose();
                        }
                    }

                    gSystemTables.GetDataByID(gintTable);

                    //pg.OutPut(szInherit);
                    //pg.Dispose();
                    //string sJson = Pub.IO.ReadAllEncryptionText(gstrFullPath);
                    Ly.Formats.Json js = new Ly.Formats.Json(szInherit);

                    string szSelStr = "";
                    string szAndStr = "";
                    string szOrderStr = "";
                    if (js["Premise"].Value != "") {
                        szSelStr = " where " + js["Premise"].Value;
                        szAndStr = " and (" + js["Premise"].Value + ")";
                    }
                    if (KeyOptions != "") {
                        if (szSelStr != "") {
                            szSelStr += " and " + KeyOptions;
                        } else {
                            szSelStr = " where " + KeyOptions;
                        }
                    }
                    if (js["Order"].Value != "") szOrderStr = " Order by " + js["Order"].Value;

                    //读取自定义排序信息
                    string szFileOrder = Server.MapPath(this.WebConfig.UserPath + "/Order.json");
                    string szJsonOrder = Pub.IO.ReadAllEncryptionText(szFileOrder);
                    Ly.Formats.Json2 JsonOrder = new Ly.Formats.Json2(szJsonOrder);
                    int nTable = Ly.String.Source(pg.PageArgs.Table).toInteger;
                    Ly.Formats.JsonObject objOrder = JsonOrder["Table_" + nTable];

                    if (objOrder.Count > 0) {
                        szOrderStr = " Order by ";
                        for (int i = 0; i < objOrder.Count; i++) {
                            if (i > 0) szOrderStr += ",";
                            if (objOrder[i]["Type"].Value == "Text") {
                                szOrderStr += "cast([" + objOrder[i]["Name"].Value + "] as varchar) " + objOrder[i]["Order"].Value;
                            } else {
                                szOrderStr += "[" + objOrder[i]["Name"].Value + "] " + objOrder[i]["Order"].Value;
                            }
                        }
                    }

                    gszCountSQL = "Select count(*) as AllCount from [" + gSystemTables.Structure.Name + "]" + szSelStr;
                    gstrSQL = "Select Top " + gintLines + " * from [" + gSystemTables.Structure.Name + "] where [ID] not in (Select Top " + gintLines * (gintPage - 1) + " [ID] from [" + gSystemTables.Structure.Name + "]" + szSelStr + szOrderStr + ")" + szAndStr + szOrderStr;

                    #endregion

                } else {
                    string SelStr = "";
                    string SelVal = "";
                    string KeyOptions = "";
                    string szOrderStr = "";

                    //读取自定义排序信息
                    string szFileOrder = Server.MapPath(this.WebConfig.UserPath + "/Order.json");
                    string szJsonOrder = Pub.IO.ReadAllEncryptionText(szFileOrder);
                    Ly.Formats.Json2 JsonOrder = new Ly.Formats.Json2(szJsonOrder);
                    int nTable = Ly.String.Source(pg.PageArgs.Table).toInteger;
                    Ly.Formats.JsonObject objOrder = JsonOrder["Table_" + nTable];

                    if (objOrder.Count > 0) {
                        szOrderStr = " Order by ";
                        for (int i = 0; i < objOrder.Count; i++) {
                            if (i > 0) szOrderStr += ",";
                            if (objOrder[i]["Type"].Value == "Text") {
                                szOrderStr += "cast([" + objOrder[i]["Name"].Value + "] as varchar) " + objOrder[i]["Order"].Value;
                            } else {
                                szOrderStr += "[" + objOrder[i]["Name"].Value + "] " + objOrder[i]["Order"].Value;
                            }
                        }
                    }

                    //读取相应的字段结构
                    gSystemColumns.GetDatasByParentID(gintTable);

                    ///生成快速查询语句
                    if (pg.PageArgs.Arg_Table_Key != "") {
                        for (int i = 0; i < gSystemColumns.StructureCollection.Count; i++) {
                            dyk.DB.Base.SystemColumns.StructureExp st = gSystemColumns.StructureCollection[i];
                            if (KeyOptions != "") KeyOptions += " or ";
                            switch (st.Type.ToLower()) {
                                case "text":
                                    KeyOptions += "cast([" + st.Name + "] as varchar) like '%" + pg.PageArgs.Arg_Table_Key + "%'";
                                    break;
                                default:
                                    KeyOptions += "[" + st.Name + "] like '%" + pg.PageArgs.Arg_Table_Key + "%'";
                                    break;
                            }
                        }
                        if (KeyOptions != "") KeyOptions = "(" + KeyOptions + ")";
                    }

                    #region [=====获取筛选数据=====]

                    string szFilters = "";
                    using (Ly.Formats.XML xml = Xml.Clone()) {
                        for (int i = 0; i < gSystemColumns.StructureCollection.Count; i++) {
                            dyk.DB.Base.SystemColumns.StructureExp st = gSystemColumns.StructureCollection[i];
                            //string szFilterValue = pg["Table_Filters_" + st.Name];
                            //pg.PageArgs["Table_Filters_" + st.Name].Value = szFilterValue;
                            Ly.Formats.XMLUnitPoint xup = xml[st.Name];

                            if (xup.Children.Count > 0) {
                                string szFilterTemps = "";
                                for (int j = 0; j < xup.Children.Count; j++) {
                                    if (xup[j].Name == "item") {
                                        if (szFilterTemps != "") szFilterTemps += " or ";
                                        szFilterTemps += "[" + st.Name + "]='" + xup[j].InnerText + "'";
                                    }
                                }
                                if (szFilters != "") szFilters += " and ";
                                szFilters += "(" + szFilterTemps + ")";
                            }

                            //if (szFilterValue != "") {
                            //    string szFilterTemps = "";
                            //    string[] szFilterValues = szFilterValue.Split('|');
                            //    for (int j = 0; j < szFilterValues.Length; j++) {
                            //        if (szFilterTemps != "") szFilterTemps += " or ";
                            //        szFilterTemps += "[" + st.Name + "]='" + szFilterValues[j] + "'";
                            //    }

                            //}
                        }
                    }


                    if (szFilters != "") {
                        if (KeyOptions != "") {
                            KeyOptions += " and (" + szFilters + ")";
                        } else {
                            KeyOptions = "(" + szFilters + ")";
                        }
                    }

                    #endregion


                    //pg.OutPut("<div>" + glngRelation + "</div>");

                    //关联表处理
                    if (gSystemRelation.GetDataByID(glngRelation)) {

                        #region [=====处理关联表====]

                        using (Ly.DB.Dream.SystemTables.ExecutionExp st = new Ly.DB.Dream.SystemTables.ExecutionExp(gstrConnString)) {
                            using (Ly.DB.Dream.SystemColumns.ExecutionExp sc = new Ly.DB.Dream.SystemColumns.ExecutionExp(gstrConnString)) {
                                st.GetDataByID((long)gSystemRelation.Structure.TableID);
                                sc.GetDataByParentIDAndName((long)gSystemRelation.Structure.TableID, gSystemRelation.Structure.Column);
                                using (Ly.Data.SQLClient Conn = new Ly.Data.SQLClient(gstrConnString)) {
                                    Conn.ExecuteReader("Select * from [" + st.Structure.Name + "] where [ID]=" + glngID);
                                    if (Conn.DataReader.Read()) {
                                        SelVal = Conn.DataReader[gSystemRelation.Structure.Column].ToString();
                                        gstrRelation = Conn.DataReader[gSystemRelation.Structure.PathColumn].ToString();
                                    }
                                }
                                if (sc.Structure.Type == "int") {
                                    SelStr = "[" + gSystemRelation.Structure.RelationColumn + "]=" + Ly.String.Source(SelVal).toInteger;
                                } else if (sc.Structure.Type.StartsWith("numeric")) {
                                    SelStr = "[" + gSystemRelation.Structure.RelationColumn + "]=" + Ly.String.Source(SelVal).toDouble;
                                } else {
                                    SelStr = "[" + gSystemRelation.Structure.RelationColumn + "]='" + SelVal + "'";
                                }
                            }
                        }
                        gszCountSQL = "Select count(*) as AllCount from [" + gSystemTables.Structure.Name + "] where " + SelStr + (KeyOptions == "" ? "" : " and " + KeyOptions);
                        gstrSQL = "Select Top " + gintLines + " * from [" + gSystemTables.Structure.Name + "] where [ID] not in (Select Top " + gintLines * (gintPage - 1) + " [ID] from [" + gSystemTables.Structure.Name + "] where " + SelStr + (KeyOptions == "" ? "" : " and " + KeyOptions) + szOrderStr + ") and " + SelStr + (KeyOptions == "" ? "" : " and " + KeyOptions) + szOrderStr;

                        #endregion

                    } else {
                        gszCountSQL = "Select count(*) as AllCount from [" + gSystemTables.Structure.Name + "]" + (KeyOptions == "" ? "" : " where " + KeyOptions);
                        gstrSQL = "Select Top " + gintLines + " * from [" + gSystemTables.Structure.Name + "] where [ID] not in (Select Top " + gintLines * (gintPage - 1) + " [ID] from [" + gSystemTables.Structure.Name + "]" + (KeyOptions == "" ? "" : " where " + KeyOptions) + szOrderStr + ")" + (KeyOptions == "" ? "" : " and " + KeyOptions) + szOrderStr;

                        if (gSystemTables.Structure.CustomSQL == 1) {
                            //读取SQL脚本内容
                            string szCountSql = Pub.IO.ReadAllText(Server.MapPath(this.WebConfig.SharePath + "/" + gSystemTables.Structure.Name + "/Count.azsql"));
                            string szSelectSql = Pub.IO.ReadAllText(Server.MapPath(this.WebConfig.SharePath + "/" + gSystemTables.Structure.Name + "/Load.azsql"));

                            Ly.Formats.Json jCountSql = new Ly.Formats.Json();
                            jCountSql["Name"].Value = gSystemTables.Structure.Name;
                            using (AzSqlProgram Asm = new AzSqlProgram(this, gstrConnString, jCountSql)) {
                                try {
                                    gszCountSQL = Asm.ExecuteString(szCountSql);
                                } catch (Exception ex) {
                                    pg.OutPut("脚本执行发生异常:" + ex.Message + "<br><br>");
                                    pg.OutPut(Asm.Program.Debug().Replace("\r\n", "<br>").Replace("\n", "<br>").Replace(" ", "&nbsp;"));
                                } finally {
                                    //pg.OutPut(Asm.Program.Debug().Replace("\r\n", "<br>").Replace("\n", "<br>").Replace(" ", "&nbsp;"));
                                }
                                //pg.OutPutAsText(Asm.Test(gszSql));
                                //pg.Dispose();
                            }

                            Ly.Formats.Json jSelectSql = new Ly.Formats.Json();
                            jSelectSql["Name"].Value = gSystemTables.Structure.Name;
                            jSelectSql["PageSize"].Value = gintLines.ToString();
                            using (AzSqlProgram Asm = new AzSqlProgram(this, gstrConnString, jSelectSql)) {
                                try {
                                    gstrSQL = Asm.ExecuteString(szSelectSql);
                                } catch (Exception ex) {
                                    pg.OutPut("脚本执行发生异常:" + ex.Message + "<br><br>");
                                    pg.OutPut(Asm.Program.Debug().Replace("\r\n", "<br>").Replace("\n", "<br>").Replace(" ", "&nbsp;"));
                                } finally {
                                    //pg.OutPut(Asm.Program.Debug().Replace("\r\n", "<br>").Replace("\n", "<br>").Replace(" ", "&nbsp;"));
                                }
                                //pg.OutPutAsText(Asm.Test(gszSql));
                                //pg.Dispose();
                            }
                        }

                    }

                }

            %>

            <%

                //获取用户针对本表的所有权限
                string szUserLimits = "";

                #region [=====获取用户权限=====]
                //读取用户权限
                using (Ly.DB.Dream.SystemLimits.ExecutionExp gl = new Ly.DB.Dream.SystemLimits.ExecutionExp(this.ConnectString)) {
                    gl.GetDatasByUserID(this.UserInfo.ID, gintTable);
                    for (int m = 0; m < gl.StructureCollection.Count; m++) {
                        szUserLimits += gl.StructureCollection[m].Limits;
                    }
                }

                //读取部门权限
                using (Ly.DB.Dream.SystemLimits.ExecutionExp gl = new Ly.DB.Dream.SystemLimits.ExecutionExp(this.ConnectString)) {
                    gl.GetDatasByDepartmentID(this.UserInfo.Department, gintTable);
                    for (int m = 0; m < gl.StructureCollection.Count; m++) {
                        szUserLimits += gl.StructureCollection[m].Limits;
                    }
                }

                //读取用户组权限
                using (Ly.DB.Dream.SystemLimits.ExecutionExp gl = new Ly.DB.Dream.SystemLimits.ExecutionExp(this.ConnectString)) {
                    gl.GetDatasByUserGroups(this.UserInfo.ID, gintTable);
                    for (int m = 0; m < gl.StructureCollection.Count; m++) {
                        szUserLimits += gl.StructureCollection[m].Limits;
                    }
                }

                #endregion

                #region [=====计算页码=====]

                //计算页码
                using (Ly.Data.SQLClient Conn = new Ly.Data.SQLClient(gstrConnString)) {
                    try {
                        Conn.ExecuteReader(gszCountSQL);
                    } catch (Exception ex) {
                        pg.OutPutAsText("错误信息:" + ex.Message);
                        pg.OutPut("<br>");
                        pg.OutPutAsText("Sql:" + gszCountSQL);
                        pg.Dispose();
                    }
                    //Conn.ExecuteReader(gszCountSQL);
                    if (Conn.DataReader.Read()) {
                        gnLineCount = Ly.String.Source(Conn.DataReader["AllCount"].ToString()).toInteger;
                        gnPageCount = gnLineCount / gintLines;
                        if (gnLineCount % gintLines != 0) gnPageCount++;
                    }
                }

                //当前页面容错处理
                if (gnPageCount < 1) gnPageCount = 1;

                #endregion

                #region [=====读取配置文件=====]

                gJson = new Ly.Formats.JsonObject();

                //string szSettingPath = Server.MapPath(this.WebConfig.SharePath + "/" + gSystemTables.Structure.Name);
                string szSettingPath = Server.MapPath(gSystemTables.Structure.SavePath);
                if (!System.IO.Directory.Exists(szSettingPath)) System.IO.Directory.CreateDirectory(szSettingPath);
                gstrFullPath = szSettingPath + "/UI.json";
                //gstrFullPath = Server.MapPath(this.WebConfig.ShareUISettingPath + "/" + gTab.SystemTables.Structure.Name + ".json");

                gJson.InnerJson = Pub.IO.ReadAllEncryptionText(gstrFullPath);

                for (int i = 0; i < gJson.Count; i++) {
                    Ly.Formats.JsonObject obj = gJson[i];
                    if (obj.Name == "Form") {
                        gintWidth = Ly.String.Source(obj["Width"].Value).toInteger;
                        gintHeight = Ly.String.Source(obj["Height"].Value).toInteger;
                    }
                }

                #endregion

            %>

            <%
                gstrArgs = "Path:'" + sPath + "'";
                gstrArgs += ",ID:'" + sID + "'";
                gstrArgs += ",Table:'" + sTable + "'";
                gstrArgs += ",ViewTable:'" + gintTable + "'";
                gstrArgs += ",Arg_ID:'" + glngID + "'";
                gstrArgs += ",Arg_Relation:'" + glngRelation + "'";
                gstrArgs += ",Arg_Index:'" + gintIndex + "'";
            %>

            <!--工具栏-->
            <div style="position: absolute; top: 0px; left: 0px; z-index: 1; height: 30px; width: 100%; box-sizing: border-box; -moz-box-sizing: border-box; -webkit-box-sizing: border-box; padding: 6px 0px 0px 6px; background: #DDDDDD; overflow: hidden;">

                <%if (!bDate) { %>
                <!--工具栏|查看-->
                <%szScript = "Page.Functions.OA.Table.View('" + pg.PageArgs.Path + "','" + pg.PageArgs.UID + "','" + gSystemTables.Structure.Text + "'," + gintWidth + "," + gintHeight + ",{" + gstrArgs + "," + gAddJson.Object.ToString().Substring(1, gAddJson.Object.ToString().Length - 2).Replace("\"", "'") + "});"; %>
                <div class="pub-left" style="padding: 0px 3px 0px 5px;">
                    <a href="javascript:;" onclick="<%=szScript%>">
                        <img src="<%=pg.PageArgs.Path%>images/Tool_View.png" width="16" height="16" alt="" style="padding-top: 0px;" /></a>
                </div>
                <div class="pub-left" style="margin-right: 5px;"><a href="javascript:;" onclick="<%=szScript%>">查看</a></div>
                <!--工具栏|添加-->
                <%if (Limits.CheckAddLimit(szUserLimits)) { %>
                <%szScript = "Page.Functions.OA.Table.Add('" + pg.PageArgs.Path + "','" + pg.PageArgs.UID + "','" + gSystemTables.Structure.Text + "'," + gintWidth + "," + gintHeight + ",{" + gstrArgs + "," + gAddJson.Object.ToString().Substring(1, gAddJson.Object.ToString().Length - 2).Replace("\"", "'") + "});"; %>
                <div class="pub-left" style="border-left: 1px solid #CCCCCC; margin-left: 5px; padding: 0px 3px 0px 10px;">
                    <a href="javascript:;" onclick="<%=szScript%>">
                        <img src="<%=pg.PageArgs.Path%>images/Tool_Add.gif" width="16" height="16" alt="" style="padding-top: 0px;" /></a>
                </div>
                <div class="pub-left" style="margin-right: 5px;"><a href="javascript:;" onclick="<%=szScript%>">添加</a></div>
                <%} else { %>
                <div class="pub-left" style="border-left: 1px solid #CCCCCC; margin-left: 5px; padding: 0px 3px 0px 10px;">
                    <img src="<%=pg.PageArgs.Path%>images/Tool_Add.gif" width="16" height="16" alt="" style="padding-top: 0px;" />
                </div>
                <div class="pub-left" style="margin-right: 5px;"><span style="color: #808080">添加</span></div>
                <%} %>
                <!--工具栏|修改-->
                <%if (Limits.CheckEditLimit(szUserLimits)) { %>
                <%szScript = "Page.Functions.OA.Table.Edit('" + pg.PageArgs.Path + "','" + pg.PageArgs.UID + "','" + gSystemTables.Structure.Text + "'," + gintWidth + "," + gintHeight + ",{" + gstrArgs + "," + gAddJson.Object.ToString().Substring(1, gAddJson.Object.ToString().Length - 2).Replace("\"", "'") + "});"; %>
                <div class="pub-left" style="padding: 0px 3px 0px 5px;">
                    <a href="javascript:;" onclick="<%=szScript%>">
                        <img src="<%=pg.PageArgs.Path%>images/Tool_Edit.gif" width="16" height="16" alt="" style="padding-top: 0px;" /></a>
                </div>
                <div class="pub-left" style="margin-right: 5px;"><a href="javascript:;" onclick="<%=szScript%>">修改</a></div>
                <%} else { %>
                <div class="pub-left" style="padding: 0px 3px 0px 5px;">
                    <img src="<%=pg.PageArgs.Path%>images/Tool_Edit.gif" width="16" height="16" alt="" style="padding-top: 0px;" />
                </div>
                <div class="pub-left" style="margin-right: 5px;"><span style="color: #808080">修改</span></div>
                <%} %>
                <!--工具栏|删除-->
                <%if (Limits.CheckDelLimit(szUserLimits)) { %>
                <% szScript = "Page.Functions.OA.Table.Delete('" + pg.PageArgs.UID + "','" + pg.PageArgs.Path + "',{" + gstrArgs + "});";%>
                <div class="pub-left" style="padding: 0px 3px 0px 5px;">
                    <a href="javascript:;" onclick="<%=szScript%>">
                        <img src="<%=pg.PageArgs.Path%>images/Tool_Delete.gif" width="16" height="16" alt="" style="padding-top: 0px;" /></a>
                </div>
                <div class="pub-left" style="margin-right: 5px;"><a href="javascript:;" onclick="<%=szScript%>">删除</a></div>
                <%} else { %>
                <div class="pub-left" style="padding: 0px 3px 0px 5px;">
                    <img src="<%=pg.PageArgs.Path%>images/Tool_Delete.gif" width="16" height="16" alt="" style="padding-top: 0px;" />
                </div>
                <div class="pub-left" style="margin-right: 5px;"><span style="color: #808080">删除</span></div>
                <%} %>
                <%szScript = "Page.Functions.OA.Table.Filter('" + pg.PageArgs.Path + "','" + pg.PageArgs.UID + "', '', 800, 480, {});"; %>
                <div class="pub-left" style="border-left: 1px solid #CCCCCC; margin-left: 5px; padding: 0px 3px 0px 10px;">
                    <a href="javascript:;" onclick="<%=szScript%>">
                        <img src="<%=pg.PageArgs.Path%>images/Filter.png" width="16" height="16" alt="" style="padding-top: 0px;" /></a>
                </div>
                <div class="pub-left" style="margin-right: 5px;"><a href="javascript:;" onclick="<%=szScript%>">筛选</a></div>
                <%szScript = "Page.Functions.OA.Table.Order('" + pg.PageArgs.UID + "',{});"; %>
                <div class="pub-left" style="padding: 0px 3px 0px 5px;">
                    <a href="javascript:;" onclick="<%=szScript%>">
                        <img src="<%=pg.PageArgs.Path%>images/Order.png" width="16" height="16" alt="" style="padding-top: 0px;" /></a>
                </div>
                <div class="pub-left" style="margin-right: 5px;"><a href="javascript:;" onclick="<%=szScript%>">排序</a></div>
                <%} %>

                <!--工具栏|关联表项-->
                <%
                    gSystemRelation.GetDatasByTableID(gintTable);
                %>
                <%for (int i = 0; i < gSystemRelation.StructureCollection.Count; i++) { %>
                <%
                    szClick = "javascript:;";
                    szScript = "Page.Functions.OA.Table.Command('" + pg.PageArgs.UID + "','" + pg.PageArgs.Path + "',{Arg_Index:" + (gintIndex + 1) + ",Arg_Relation:'" + gSystemRelation.StructureCollection[i].ID + "'});";
                %>
                <%
                    string szStyle = "padding: 0px 3px 0px 5px;";
                    if (i == 0) szStyle = "border-left: 1px solid #CCCCCC; padding-left: 10px; margin-left: 5px;";
                %>
                <div class="pub-left" style="<%=szStyle%>">
                    <a href="<%=szClick%>" onclick="<%=szScript%>">
                        <img src="<%=pg.PageArgs.Path%>images/re.png" width="16" height="16" alt="" style="padding-top: 0px;" /></a>
                </div>
                <div class="pub-left" style="margin-right: 5px;"><a href="<%=szClick%>" onclick="<%=szScript%>"><%=gSystemRelation.StructureCollection[i].Name%></a></div>
                <%} %>

                <div class="pub-clear"></div>
            </div>

            <%
                if (pg["Arg_RelationText"] != "") gstrRelation = pg["Arg_RelationText"];
                if (gSystemHistory.GetDataByNameAndIndex(pg.PageArgs.UID, gintIndex)) {
                    gSystemHistory.Structure.RelationID = glngRelation;
                    gSystemHistory.Structure.TableID = Ly.String.Source(sTable).toLong;
                    gSystemHistory.Structure.ValueID = glngID;
                    gSystemHistory.Structure.Text = gstrRelation;
                    gSystemHistory.UpdateByID();
                } else {
                    gSystemHistory.Structure.Name = pg.PageArgs.UID;
                    gSystemHistory.Structure.Index = gintIndex;
                    gSystemHistory.Structure.RelationID = glngRelation;
                    gSystemHistory.Structure.TableID = Ly.String.Source(sTable).toLong;
                    gSystemHistory.Structure.ValueID = glngID;
                    gSystemHistory.Structure.Text = gstrRelation;
                    gSystemHistory.Add();
                }
            %>
            <!--当前路径-->
            <div style="position: absolute; top: 30px; left: 0px; padding: 6px; z-index: 1;">
                <div style="float: left;">当前路径:</div>
                <div style="float: left;"><a href="javascript:;" onclick="Page.UI.Open('AppManager','','我的应用','/Files/App/System/Applications/','Process.aspx',{Path:'/Files/App/Com_Application/',ID:'AppManager'});">我的应用</a></div>
                <%
                    gSystemHistory.GetDatasByNameAndIndex(pg.PageArgs.UID, gintIndex);
                    for (int i = 0; i < gSystemHistory.StructureCollection.Count; i++) {
                %>
                <%szScript = "Page.Functions.OA.Table.Load('" + pg.PageArgs.UID + "',{Arg_Table:" + gSystemHistory.StructureCollection[i].TableID + ",Arg_Index:" + gSystemHistory.StructureCollection[i].Index + ",Arg_Relation:'" + gSystemHistory.StructureCollection[i].RelationID + "',Arg_RelationText:'" + gSystemHistory.StructureCollection[i].Text + "'});"; %>
                <div style="float: left;">&gt;</div>
                <div style="float: left;"><a href="javascript:;" onclick="<%=szScript%>"><%=gSystemHistory.StructureCollection[i].Text%></a></div>
                <%} %>
                <div style="clear: both"></div>
            </div>

            <!--搜索栏-->
            <%
                string szth = "";
                string szth2 = "";
                int nTableWidth = 1;

                using (Ly.Formats.XML xml = Xml.Clone()) {
                    using (ClsAjaxPageArgs Arg = new ClsAjaxPageArgs(pg.PageArgs)) {
                        for (int i = 0; i < gSystemColumns.StructureCollection.Count; i++) {
                            dyk.DB.Base.SystemColumns.StructureExp st = gSystemColumns.StructureCollection[i];
                            string sStyle = "";
                            if (st.Visible == 1) {
                                string szGou = "<span style=\"\">☆</span>";
                                if (xml[st.Name].Children.Count > 0) szGou = "<span style=\"color:#090;\">★</span>";
                                nTableWidth += (int)st.Width;
                                sStyle += "width:" + (st.Width) + "px;text-align:center; box-sizing: border-box; -moz-box-sizing: border-box; -webkit-box-sizing: border-box;white-space: normal; word-break: break-all; ";
                                Arg["Column"].Value = st.ID.ToString();
                                //if (gSystemColumns.Structure.Align != "") sStyle += "text-align:" + gSystemColumns.Structure.Align + ";";
                                //using (Ly.Formats.Json json = new Ly.Formats.Json(pg.PageArgs["Filters"].ToJsonString())) {
                                if (st.IsFilter == 1) {
                                    szth += "<th style=\"" + sStyle + "padding:5px;border: 1px solid #9eb6ce;\">";
                                    //szth += "<div>";
                                    //szth += "<div style=\"float:left;padding-right:2px;\" >";
                                    //szth += "<img alt =\"\" width=\"12\" height=\"12\" src=\"/images/Filter.png\" />";
                                    szth += szGou;
                                    //szth += "</div>";
                                    //szth += "<div style=\"float:left;\">";
                                    szth += "<a href=\"javascript:;\" onclick=\"Page.Functions.OA.Table.Filter('" + pg.PageArgs.Path + "','" + pg.PageArgs.UID + "', '" + st.Text + "', 800, 480, " + Arg.ToString().Replace("\"#", "").Replace("#\"", "").Replace("\"", "'") + ");\">" + gSystemColumns.StructureCollection[i].Text + "</a>";
                                    //szth += "<a href=\"javascript:;\" onclick=\"$.Dialog.ShowFromUrl('" + pg.PageArgs.Process_ID + "_Filter', '列[" + st.Text + "]数据筛选', 640, 480, '" + sPath + "Ajax/Filter.aspx', " + Arg.ToString().Replace("\"#", "").Replace("#\"", "").Replace("\"", "'") + ");\">" + gSystemColumns.StructureCollection[i].Text + "</a>";
                                    //szth += "</div>";
                                    //szth += "<div style=\"clear:both;\"></div>";
                                    //szth += "</div>";
                                    szth += "</th>";
                                } else {
                                    szth += "<th style=\"" + sStyle + "padding:3px;border: 1px solid #9eb6ce;\">" + gSystemColumns.StructureCollection[i].Text + "</th>";
                                }

                                szth2 += "<th style=\"" + sStyle + "height: 0px;border-spacing:0px;\">";
                                szth2 += "</th>";

                                //}
                            }
                        }
                    }
                }
                string szTabStyle = "width:" + (nTableWidth + 77) + "px;";
                string szTabStyle2 = "width:" + (nTableWidth + 60) + "px;";
            %>
            <div style="position: absolute; top: 60px; left: 0px; z-index: 1; height: 60px; width: 100%; box-sizing: border-box; -moz-box-sizing: border-box; -webkit-box-sizing: border-box; padding: 6px 0px 0px 6px;">
                <%if (bDate) {%>
                <div style="padding: 0px 0px 5px 0px;">
                    <div style="float: left; padding: 3px 0px 0px 0px;">当前日期:</div>
                    <div style="float: left; padding: 3px 0px 0px 5px;"><%=szDate%></div>
                    <div style="clear: both;"></div>
                </div>
                <div style="padding: 0px 0px 5px 0px;">
                    <div style="float: left; padding: 3px 0px 0px 0px;">日期设定:</div>
                    <div style="float: left; padding: 0px 0px 0px 5px;">
                        <input id="<%=sID%>_Date" type="text" value="<%=szDate%>" readonly="readonly" style="width: 80px; height: 18px;" />
                    </div>
                    <div style="float: left; padding: 0px 0px 0px 5px;">
                        <input id="<%=sID%>_DatePicker" type="button" value="选择" style="width: 60px; height: 24px;" onclick="DatePicker.Move(93, 209);<%=szDateScript%>" />
                    </div>
                    <div style="float: left; padding: 0px 0px 0px 5px;">
                        <%
                            string szSettingScript = "var aDate=$('#" + sID + "_Date').val();$('#" + sID + "').html('" + gszWaitHtml + "').load('" + sPath + "Main.aspx', {pg:" + gintPage + ",Arg_Table_Date: aDate," + gstrArgs + "});$.Process.Values['" + sID + "']='';";
                            //string szSettingScript = "alert($('#" + sID + "_Date').val());";
                            //string szSettingScript = "alert(document.getElementById('" + sID + "_Date').value);";
                        %>
                        <input id="<%=sID%>_DateSubmit" type="button" value="设定" style="width: 60px; height: 24px;" onclick="<%=szSettingScript%>" />
                    </div>
                    <div style="clear: both;"></div>
                </div>
                <%} else { %>
                <div style="padding: 0px 0px 5px 0px;">
                    <div style="float: left; padding: 3px 0px 0px 0px;">快速搜索:</div>
                    <div style="float: left; padding: 0px 0px 0px 5px;">
                        <input id="<%=pg.PageArgs.UID%>_Key" type="text" value="<%=pg.PageArgs.Arg_Table_Key%>" style="width: 200px; height: 18px;" />
                    </div>
                    <div style="float: left; padding: 0px 0px 0px 5px;">
                        <%
                            string szSettingScript = "";
                            using (ClsAjaxPageArgs Arg = new ClsAjaxPageArgs(pg.PageArgs)) {
                                Arg.Arg_Table_Key = "#aDate#";
                                //szSettingScript = "var aDate=$('#" + sID + "_Key').val();$('#" + sID + "').html('" + gszWaitHtml + "').load('" + sPath + "Main.aspx', " + Arg.ToString().Replace("\"#", "").Replace("#\"", "").Replace("\"", "'") + ");$.Process.Values['" + sID + "']='';";
                                szSettingScript = "Page.Functions.OA.Table.KeySearch('" + pg.PageArgs.UID + "');";
                            }
                        %>
                        <input id="<%=pg.PageArgs.UID%>_KeySubmit" type="button" value="搜索" style="width: 60px; height: 24px;" onclick="<%=szSettingScript%>" />
                    </div>
                    <div style="clear: both;"></div>
                </div>
                <%} %>
                <% 
                    bool bDataOptions = false;
                %>
                <div style="padding: 0px 0px 0px 0px;">
                    <div style="float: left; padding: 4px 0px 0px 0px;">数据筛选:</div>
                    <%if (pg.PageArgs.Arg_Table_Date != "") { %>
                    <% bDataOptions = true;%>
                    <div style="float: left; padding: 3px 0px 0px 5px; border: 1px solid #0094ff; border-right: 0px;">日期</div>
                    <div style="float: left; padding: 3px 0px 0px 5px; border: 1px solid #0094ff;"><%=szDate%></div>
                    <%} %>
                    <div style="float: left; background: #fff;">
                        <%if (pg.PageArgs.Arg_Table_Key != "") { %>
                        <% bDataOptions = true;%>
                        <%
                            string szScriptKeyDelete = "";
                            using (ClsAjaxPageArgs Arg = new ClsAjaxPageArgs(pg.PageArgs)) {
                                Arg.Arg_Table_Key = "";
                                //szScriptKeyDelete = "$('#" + sID + "').html('" + gszWaitHtml + "').load('" + sPath + "Main.aspx', " + Arg.ToString().Replace("\"#", "").Replace("#\"", "").Replace("\"", "'") + ");$.Process.Values['" + sID + "']='';";
                                szScriptKeyDelete = "Page.Functions.OA.Table.KeySearchClear('" + pg.PageArgs.UID + "');";
                            }
                        %>
                        <div style="float: left; margin-bottom: 5px;">
                            <div style="float: left; margin-left: 5px; padding: 3px 3px 3px 3px; border: 1px solid #0094ff; border-right: 0px; background: #0094ff; color: #fff;">快速搜索</div>
                            <div style="float: left; padding: 3px 3px 3px 3px; border: 1px solid #0094ff; color: #0094ff; word-break: break-all; word-wrap: break-word;"><%=pg.PageArgs.Arg_Table_Key%>&nbsp;<a href="javascript:;" onclick="<%=szScriptKeyDelete%>">取消</a></div>
                            <div style="clear: both;"></div>
                        </div>
                        <%} else { %>
                        <div style="float: left; margin-bottom: 5px;">
                            <div style="float: left; margin-left: 5px; padding: 3px 3px 3px 3px; border: 1px solid #0094ff; border-right: 0px; background: #0094ff; color: #fff;">快速搜索</div>
                            <div style="float: left; padding: 3px 3px 3px 3px; border: 1px solid #0094ff; color: #0094ff">无</div>
                            <div style="clear: both;"></div>
                        </div>
                        <%} %>
                        <%
                            szClick = "Page.Functions.OA.Table.Filter('" + pg.PageArgs.Path + "','" + pg.PageArgs.UID + "', '', 800, 480, {});";
                        %>
                        <div style="float: left; margin-bottom: 5px;">
                            <div style="float: left; margin-left: 5px; padding: 3px 3px 3px 3px; border: 1px solid #0094ff; color: #0094ff; cursor: pointer;" onmousemove="this.style.backgroundColor='#6cc1ff';this.style.color='#fff';" onmouseout="this.style.backgroundColor='';this.style.color='#0094ff';" onclick="<%=szClick%>">更多筛选&gt;&gt;</div>
                            <div style="clear: both;"></div>
                        </div>
                        <div style="clear: both;"></div>
                    </div>
                    <div style="clear: both;"></div>
                </div>
            </div>

            <!--主体表格-->
            <div style="position: absolute; top: 0px; padding: 125px 5px 30px 5px; width: 100%; height: 100%; overflow: hidden; box-sizing: border-box; -moz-box-sizing: border-box; -webkit-box-sizing: border-box; z-index: 0;">
                <div style="position: relative; width: 100%; height: 100%; overflow-x: auto;">
                    <!--单独的表格列-->
                    <div style="position: absolute; top: 0px; left: 0px; height: 31px; overflow: hidden; z-index: 1;">
                        <table style="<%=szTabStyle%> border-collapse: collapse; border-spacing: 0px;">
                            <tr style="background: #e4ecf7; color: #27413e;">
                                <th style="width: 58px; height: 30px; border: 1px solid #9eb6ce;">序号</th>
                                <%=szth%>
                                <th style="width: 17px; padding: 0px; height: 30px;"></th>
                            </tr>
                        </table>
                    </div>
                    <!--完整的表格体-->
                    <div style="position: absolute; top: 0px; left: 0px; padding-top: 29px; height: 100%; overflow: hidden; box-sizing: border-box; -moz-box-sizing: border-box; -webkit-box-sizing: border-box; z-index: 0;">
                        <div style="height: 100%; overflow-y: scroll; overflow-x: hidden;">
                            <table style="<%=szTabStyle2%> border-collapse: collapse; border-spacing: 0px;">
                                <tr style="">
                                    <th style="width: 60px; padding: 0px; height: 0px;"></th>
                                    <%=szth2%>
                                </tr>
                                <%
                                    int cnt = gintLines * (gintPage - 1);
                                    using (Ly.Data.SQLClient Conn = new Ly.Data.SQLClient(gstrConnString)) {
                                        //string sql = "Select Top " + gintLines + " * from [" + gSystemTables.Structure.Name + "] where [ID] not in (Select Top " + gintLines * (gintPage - 1) + " [ID] from [" + gSystemTables.Structure.Name + "] order by [ID] desc) order by [ID] desc";
                                        //Response.Write(gstrSQL);
                                        //Response.End();
                                        try {
                                            Conn.ExecuteReader(gstrSQL);
                                        } catch (Exception ex) {
                                            pg.OutPutAsText("错误信息:" + ex.Message);
                                            pg.OutPut("<br>");
                                            pg.OutPutAsText("Sql:" + gstrSQL);
                                            pg.Dispose();
                                        }

                                        while (Conn.DataReader.Read()) {
                                            cnt++;
                                            String strID = Conn.DataReader["ID"].ToString();
                                            //if (cnt % 2 == 0) LineColor = "background:#eef8ff;";
                                %>
                                <tr id="<%=pg.PageArgs.UID%>_tr_line_<%=strID%>" onclick="Page.Functions.OA.Table.Select('<%=pg.PageArgs.UID%>','<%=strID%>');">
                                    <td style="padding: 3px; white-space: normal; word-break: break-all; border: 1px solid #d0d7e5; vertical-align: middle; text-align: right;"><%=cnt%></td>
                                    <%
                                        for (int i = 0; i < gSystemColumns.StructureCollection.Count; i++) {
                                            dyk.DB.Base.SystemColumns.StructureExp st = gSystemColumns.StructureCollection[i];
                                            string sStyle = "";
                                            if (st.Visible == 1) {
                                                //sStyle += "width:" + st.Width + "px;";
                                                string sValue = Conn.DataReader[st.Name].ToString().Replace("<", "&lt;").Replace(">", "&gt;");
                                                if (st.Length > 0) { if (sValue.Length > st.Length) sValue = sValue.Substring(0, (int)st.Length) + "..."; }

                                                //设置样式
                                                sStyle += "text-align:" + (st.Align != "" ? st.Align : "left");

                                                //根据格式化Json显示内容
                                                string sFormat = st.Format;
                                                sValue = Pub.ValueFormat.getValue(this, this.ConnectString, (int)dyk.Type.String.New(strID).ToNumber, st.Name, sValue, sFormat, szSettingPath + "/" + st.Name + "_Format.azsql");
                                                //if (gSystemColumns.Structure.Align != "") sStyle += "text-align:" + gSystemColumns.Structure.Align + ";";
                                    %>
                                    <td style="padding: 3px; white-space: normal; word-break: break-all; border: 1px solid #d0d7e5; vertical-align: middle; <%=sStyle%>"><%=sValue!=""?sValue : "&nbsp;"%></td>
                                    <%
                                            }
                                        }
                                    %>
                                </tr>
                                <%
                                        }
                                    }
                                %>
                            </table>
                        </div>
                    </div>
                </div>
            </div>

            <!--分页信息-->
            <%
                szClick = "Page.UI.Open('" + pg.PageArgs.UID + "','','" + pg.PageArgs.UITitle + "','" + pg.PageArgs.Path + "','Process.aspx', {Arg_Table:'" + sTable + "',Arg_Table_Date:'" + szDate + "',Arg_Table_Key:'" + szKey.Replace("\"", "\\\"").Replace("'", "\\'") + "'";
            %>
            <div style="position: absolute; top: 100%; margin-top: -30px; left: 0px; z-index: 1; height: 30px; width: 100%; box-sizing: border-box; -moz-box-sizing: border-box; -webkit-box-sizing: border-box; padding: 6px 0px 0px 6px;">
                <%if (gintPage > 1) { %>
                <div style="float: left; margin-right: 5px;" onclick="Page.Functions.OA.Table.Load('<%=pg.PageArgs.UID%>',{Arg_Page:1});"><a href="javascript:;">[首页]</a></div>
                <%} %>
                <%if (gintPage > 1) { %>
                <div style="float: left; margin-right: 5px;" onclick="Page.Functions.OA.Table.Load('<%=pg.PageArgs.UID%>',{Arg_Page:<%=gintPage-1%>});"><a href="javascript:;">[上一页]</a></div>
                <%} %>
                <%for (int i = gintPage - 5; i < gintPage; i++) {%>
                <%if (i > 0) { %>
                <div style="float: left; margin-right: 5px;" onclick="Page.Functions.OA.Table.Load('<%=pg.PageArgs.UID%>',{Arg_Page:<%=i%>});"><a href="javascript:;">[<%=i%>]</a></div>
                <%} %>
                <%} %>
                <div style="float: left; margin-right: 5px; color: #0094ff;">[<%=gintPage%>]</div>
                <%for (int i = gintPage + 1; i <= gintPage + 5; i++) {%>
                <%if (i <= gnPageCount) { %>
                <div style="float: left; margin-right: 5px;" onclick="Page.Functions.OA.Table.Load('<%=pg.PageArgs.UID%>',{Arg_Page:<%=i%>});"><a href="javascript:;">[<%=i%>]</a></div>
                <%} %>
                <%} %>
                <%if (gintPage < gnPageCount) { %>
                <div style="float: left; margin-right: 5px;" onclick="Page.Functions.OA.Table.Load('<%=pg.PageArgs.UID%>',{Arg_Page:<%=gintPage+1%>});"><a href="javascript:;">[下一页]</a></div>
                <%} %>
                <%if (gintPage < gnPageCount) { %>
                <div style="float: left; margin-right: 5px;" onclick="Page.Functions.OA.Table.Load('<%=pg.PageArgs.UID%>',{Arg_Page:<%=gnPageCount%>});"><a href="javascript:;">[末页]</a></div>
                <%} %>
                <div style="clear: both;"></div>
            </div>
            <%pg.Dispose();%>
        </div>
    </form>
</body>
</html>
