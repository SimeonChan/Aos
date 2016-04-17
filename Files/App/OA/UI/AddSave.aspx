<%@ Page Language="C#" ValidateRequest="false" Inherits="ClsPage" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<script runat="server">
    protected long gintTable;
    protected String gstrConnString;

    //存储表单内容缓存
    protected dyk.Format.Json gCache = new dyk.Format.Json();

    protected long glngRelation;
    protected long glngID;
    protected int gintIndex;
</script>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
    <title></title>
</head>
<body>
    <form id="form1" runat="server">
        <div>
            <%ClsAjaxPage pg = new ClsAjaxPage(this); %>
            <%
                string sPath = pg["Arg_Path"];
                string sID = pg["ID"];
                string sTable = pg["Arg_Table"];

                bool bSuccess = true;//是否成功执行

                long lngID = Ly.String.Source(pg["Key_ID"]).toLong;

                glngID = Ly.String.Source(pg["Arg_ID"]).toLong;
                glngRelation = Ly.String.Source(pg["Arg_Relation"]).toLong;
                gintIndex = Ly.String.Source(pg["Arg_Index"]).toInteger;

                gintTable = Ly.String.Source(Pub.Request(this, "Arg_ViewTable")).toLong;

                gstrConnString = this.BaseConnectString;
                //gstrConnString = Pub.IO.ReadAllText(Server.MapPath(this.WebConfig.ConnectStringPath));
                //Ly.DB.Dream.Tables gTabs = new Ly.DB.Dream.Tables(gstrConnString);
                //gTabs.SystemTables.GetDataByID(gintTable);
                //gTabs.SystemColumns.GetDatasByParentID(gintTable);

                dyk.DB.Base.SystemTables.ExecutionExp SystemTables = new dyk.DB.Base.SystemTables.ExecutionExp(gstrConnString);
                dyk.DB.Base.SystemColumns.ExecutionExp SystemColumns = new dyk.DB.Base.SystemColumns.ExecutionExp(gstrConnString);
                dyk.DB.OA.SystemEvents.ExecutionExp SystemEvents = new dyk.DB.OA.SystemEvents.ExecutionExp(gstrConnString);

                SystemTables.GetDataByID(gintTable);
                SystemColumns.GetDatasByParentID(gintTable);

                //获取用户针对本表的所有权限
                //string szUserLimits = "";

                #region [=====加载初始化内容=====]

                //建立文件夹
                //string szSettingDir = Server.MapPath(this.WebConfig.SharePath + "/" + SystemTables.Structure.Name);
                string szSettingDir = Server.MapPath(SystemTables.Structure.SavePath);
                if (!System.IO.Directory.Exists(szSettingDir)) System.IO.Directory.CreateDirectory(szSettingDir);

                for (int i = 0; i < SystemColumns.StructureCollection.Count; i++) {
                    dyk.DB.Base.SystemColumns.StructureExp st = SystemColumns.StructureCollection[i];
                    gCache[st.Name].Value = this[st.Name];
                }

                ////设定脚本路径
                //string szScriptFile = szSettingDir + "\\Add_OnSaving.ds";

                //if (lngID > 0) {
                //    szScriptFile = szSettingDir + "\\Edit_OnSaving.ds";
                //}

                ////读取初始化脚本
                //string szPageScript = Pub.IO.ReadAllText(szScriptFile);

                //从数据库中读取脚本信息
                string szPageScript = "";

                if (lngID > 0) {
                    using (dyk.DB.OA.SystemEvents.ExecutionExp se = new dyk.DB.OA.SystemEvents.ExecutionExp(this.BaseConnectString)) {
                        if (se.GetDataByTableIDAndName(gintTable, "Edit_OnSaving")) {
                            szPageScript = se.Structure.DScript;
                        }
                    }
                } else {
                    using (dyk.DB.OA.SystemEvents.ExecutionExp se = new dyk.DB.OA.SystemEvents.ExecutionExp(this.BaseConnectString)) {
                        if (se.GetDataByTableIDAndName(gintTable, "Add_OnSaving")) {
                            szPageScript = se.Structure.DScript;
                        }
                    }
                }

                if (szPageScript != "") {
                    //执行Saving事件脚本
                    DsLibrary lib = new DsLibrary(this, this.BaseConnectString, gCache);
                    using (dyk.Script.Code.Program.Actuator act = new dyk.Script.Code.Program.Actuator(szPageScript, lib)) {
                        act.Execute();
                    }
                }

                #endregion

                #region [=====获取用户权限=====]

                //dyk.Format.Limits slm = dyk.Format.Limits.NoLimits();
                dyk.Format.Limits slm = Pub.DB.GetTableLimits(this, gintTable);
                //slm.SetAllLimits();

                #endregion

                string szEventSql = "";

                using (ClsAjaxRequest js = new ClsAjaxRequest()) {
                    string sql = "";

                    #region [=====检测数据合法性=====]
                    if (SystemTables.Structure.SaveCheck == 1) {
                        //string szCheck = Pub.IO.ReadAllText(Server.MapPath(this.WebConfig.SharePath + "/" + gTabs.SystemTables.Structure.Name + "/OnSaveCheck.azs"));

                        //从数据库中读取检测脚本
                        string szCheckScript = "";

                        if (lngID > 0) {
                            using (dyk.DB.OA.SystemEvents.ExecutionExp se = new dyk.DB.OA.SystemEvents.ExecutionExp(this.BaseConnectString)) {
                                if (se.GetDataByTableIDAndName(gintTable, "Edit_OnSaveCheck")) {
                                    szCheckScript = se.Structure.DScript;
                                }
                            }
                        } else {
                            using (dyk.DB.OA.SystemEvents.ExecutionExp se = new dyk.DB.OA.SystemEvents.ExecutionExp(this.BaseConnectString)) {
                                if (se.GetDataByTableIDAndName(gintTable, "Add_OnSaveCheck")) {
                                    szCheckScript = se.Structure.DScript;
                                }
                            }
                        }

                        //SaveCheck事件返回值
                        string szCheck = "";

                        if (szCheckScript != "") {
                            //执行SaveCheck事件脚本
                            DsLibrary lib = new DsLibrary(this, this.BaseConnectString, gCache);
                            using (dyk.Script.Code.Program.Actuator act = new dyk.Script.Code.Program.Actuator(szCheckScript, lib)) {
                                act.Execute();
                                szCheck = act.OutString;
                            }
                        }

                        //判断SaveCheck事件返回值，不为空则未通过检测，弹出返回的字符串
                        if (szCheck != "") {
                            js.Message = szCheck;
                            pg.OutPut(js.ToString());
                            pg.Dispose();
                        }
                    }
                    #endregion

                    string szDScript = "";

                    if (lngID > 0) {
                        #region [=====修改模式=====]

                        string strSet = "";
                        for (int i = 0; i < SystemColumns.StructureCollection.Count; i++) {
                            dyk.DB.Base.SystemColumns.StructureExp st = SystemColumns.StructureCollection[i];
                            if (st.Name != "ID") {
                                string sType = st.Type.ToLower();
                                string sValue = gCache[st.Name].Value;

                                //检测字段是否有编辑权限
                                //bool bLimit = slm.CheckLimit("[" + st.Limit + "]");
                                //if (st.Limit != "") bLimit = Limits.CheckLimit(szUserLimits, "[" + st.Limit + "]");
                                bool bLimit = slm.Edit;

                                if (bLimit) {

                                    //执行列修改事件
                                    //if (st.EventEdit == 1) {
                                    //    //读取SQL脚本内容
                                    //    //string szSql = Pub.IO.ReadAllText(Server.MapPath(this.WebConfig.SharePath + "/" + gTabs.SystemTables.Structure.Name + "/" + st.Name + "_OnEditSave.azsql"));
                                    //    string szSql = Pub.IO.ReadAllText(Server.MapPath(SystemTables.Structure.SavePath + "/" + st.Name + "_OnEditSave.azsql"));
                                    //    using (AzSqlProgram Asm = new AzSqlProgram(this, gstrConnString, null)) {
                                    //        try {
                                    //            szSql = Asm.ExecuteString(szSql);
                                    //            sValue = szSql;
                                    //        } catch (Exception ex) {
                                    //            pg.OutPut("脚本执行发生异常:" + ex.Message + "<br><br>");
                                    //            pg.OutPut(Asm.Program.Debug().Replace("\r\n", "<br>").Replace("\n", "<br>").Replace(" ", "&nbsp;"));
                                    //        } finally {
                                    //            //pg.OutPut(Asm.Program.Debug().Replace("\r\n", "<br>").Replace("\n", "<br>").Replace(" ", "&nbsp;"));
                                    //        }
                                    //        //pg.OutPutAsText(Asm.Test(gszSql));
                                    //        //pg.Dispose();
                                    //    }
                                    //}

                                    if (strSet != "") strSet += ",";
                                    strSet += "[" + st.Name + "]=";
                                    if (sType == "int") {
                                        strSet += Ly.String.Source(sValue).toInteger;
                                    } else if (sType.StartsWith("numeric")) {
                                        strSet += Ly.String.Source(sValue).toDouble;
                                    } else {
                                        strSet += "'" + sValue.Replace("'", "''") + "'";
                                    }
                                }

                            }
                        }
                        sql = "Update [" + SystemTables.Structure.Name + "] set " + strSet + "  where [ID]=" + lngID;

                        //if (SystemTables.Structure.EventEdit == 1) szEventSql = Pub.IO.ReadAllText(Server.MapPath(this.WebConfig.SharePath + "/" + gTabs.SystemTables.Structure.Name + "/OnEditSave.azsql"));
                        //if (SystemTables.Structure.EventEdit == 1) {
                        //szEventSql = Pub.IO.ReadAllText(Server.MapPath(SystemTables.Structure.SavePath + "/OnEditSave.azsql"));
                        //设定保存结束后的脚本
                        using (dyk.DB.OA.SystemEvents.ExecutionExp se = new dyk.DB.OA.SystemEvents.ExecutionExp(this.BaseConnectString)) {
                            if (se.GetDataByTableIDAndName(gintTable, "Edit_OnSaved")) {
                                szDScript = se.Structure.DScript;
                            }
                        }
                        //}
                        #endregion
                    } else {
                        #region [=====添加模式=====]

                        string sColumns = "";
                        string sValues = "";

                        for (int i = 0; i < SystemColumns.StructureCollection.Count; i++) {
                            dyk.DB.Base.SystemColumns.StructureExp st = SystemColumns.StructureCollection[i];
                            if (st.Name != "ID") {
                                string sType = st.Type.ToLower();
                                string sValue = gCache[st.Name].Value;

                                ////执行添加事件
                                //if (st.EventAdd == 1) {
                                //    //读取SQL脚本内容
                                //    //string szSql = Pub.IO.ReadAllText(Server.MapPath(this.WebConfig.SharePath + "/" + gTabs.SystemTables.Structure.Name + "_" + st.Name + "/OnAddSave.azsql"));

                                //    string szSql = Pub.IO.ReadAllText(Server.MapPath(SystemTables.Structure.SavePath + "/" + st.Name + "_OnAddSave.azsql"));
                                //    using (AzSqlProgram Asm = new AzSqlProgram(this, gstrConnString, null)) {
                                //        try {
                                //            szSql = Asm.ExecuteString(szSql);
                                //            sValue = szSql;
                                //        } catch (Exception ex) {
                                //            pg.OutPut("脚本执行发生异常:" + ex.Message + "<br><br>");
                                //            pg.OutPut(Asm.Program.Debug().Replace("\r\n", "<br>").Replace("\n", "<br>").Replace(" ", "&nbsp;"));
                                //        } finally {
                                //            //pg.OutPut(Asm.Program.Debug().Replace("\r\n", "<br>").Replace("\n", "<br>").Replace(" ", "&nbsp;"));
                                //        }
                                //        //pg.OutPutAsText(Asm.Test(gszSql));
                                //        //pg.Dispose();
                                //    }
                                //}

                                if (sColumns != "") {
                                    sColumns += ",";
                                    sValues += ",";
                                }
                                sColumns += "[" + st.Name + "]";
                                if (sType == "int") {
                                    sValues += Ly.String.Source(sValue).toInteger;
                                } else if (sType.StartsWith("numeric")) {
                                    sValues += Ly.String.Source(sValue).toDouble;
                                } else {
                                    sValues += "'" + sValue.Replace("'", "''") + "'";
                                }
                            }
                        }
                        sql = "INSERT INTO [" + SystemTables.Structure.Name + "] (" + sColumns + ")  VALUES (" + sValues + ")";
                        //if (SystemTables.Structure.EventAdd == 1) szEventSql = Pub.IO.ReadAllText(Server.MapPath(this.WebConfig.SharePath + "/" + gTabs.SystemTables.Structure.Name + "/OnAddSave.azsql"));
                        //if (SystemTables.Structure.EventAdd == 1) {
                        using (dyk.DB.OA.SystemEvents.ExecutionExp se = new dyk.DB.OA.SystemEvents.ExecutionExp(this.BaseConnectString)) {
                            if (se.GetDataByTableIDAndName(gintTable, "Add_OnSaved")) {
                                szDScript = se.Structure.DScript;
                            }
                        }
                        //}
                        #endregion
                    }

                    //执行数据保存
                    try {
                        using (Ly.Data.SQLClient conn = new Ly.Data.SQLClient(gstrConnString)) {
                            conn.ExecuteNonQuery(sql);
                        }

                        js.Message = "信息保存成功!";
                        js.SetText("div_Console", "信息保存成功!");
                        js.SetText(pg.PageArgs.Dialog_ElementID + "_Info", "<font color='#009900'>信息保存成功!<font>");

                    } catch (Exception ex) {
                        js.SetText(pg.PageArgs.Dialog_ElementID + "_Info", "<font color='#990000'>保存失败!" + ex.Message + "<font>");
                        js.SetText("div_Console", "信息保存失败!");
                        js.Message = sql;
                        bSuccess = false;
                    }

                    //执行保存后脚本
                    if (szDScript != "") {
                        DsLibrary lib = new DsLibrary(this, this.BaseConnectString, gCache);
                        using (dyk.Script.Code.Program.Actuator act = new dyk.Script.Code.Program.Actuator(szDScript, lib)) {
                            act.Execute();
                        }
                    }

                    //js.SetText("MsgNav_Info", "<font color='#009900'>保存成功!<font>");
                    //js.SetStyle(sID, "backgroundColor", "");

                    //using (ClsAjaxRequest.Arg arg = new ClsAjaxRequest.Arg()) {
                    //    arg["Path"] = sPath;
                    //    arg["ID"] = sID;
                    //    arg["Arg_Table"] = sTable;
                    //    arg["Dialog_ElementID"] = pg.PageArgs.Dialog_ElementID;
                    //    arg["Dialog_ID"] = pg.PageArgs.Dialog_ID;
                    //    arg["Process_ElementID"] = pg.PageArgs.Process_ElementID;
                    //    arg["Process_ID"] = pg.PageArgs.Process_ID;
                    //    arg["Arg_ID"] = glngID.ToString();
                    //    arg["Arg_Relation"] = glngRelation.ToString();
                    //    arg["Arg_Index"] = gintIndex.ToString();
                    //    js.SetAjaxLoad(pg.PageArgs.Process_ElementID, sPath + "Main.aspx", arg);
                    //}

                    if (bSuccess) {
                        using (ClsAjaxRequest.Arg arg = new ClsAjaxRequest.Arg(pg)) {
                            //                                UI:Window
                            //UI_ID:Table_30
                            //UI_Tool:Win_Table_30_Tool
                            //UI_Main:Win_Table_30_Main
                            //UI_Title:OA表格对象
                            //arg["Arg_Path"] = pg.;
                            arg["ID"] = sID;
                            //arg["Arg_Table"] = gTabs.SystemRelation.Structure.RelationTableID.ToString();
                            arg["Arg_Table"] = sTable;
                            arg["Dialog_ElementID"] = pg.PageArgs.Dialog_ElementID;
                            arg["Dialog_ID"] = pg.PageArgs.Dialog_ID;
                            arg["Process_ElementID"] = pg.PageArgs.Process_ElementID;
                            arg["Process_ID"] = pg.PageArgs.Process_ID;
                            arg["Arg_ID"] = glngID.ToString();
                            arg["Arg_Relation"] = glngRelation.ToString();
                            arg["Arg_Index"] = gintIndex.ToString();
                            //js.SetAjaxLoad(pg.PageArgs.Process_ElementID, sPath + "Main.aspx", arg);
                            js.SetAjaxScript(pg.PageArgs.Path + "Process.aspx", arg);
                            js.SetDialogClose(pg.PageArgs.Dialog_ID);
                        }
                    }


                    // js.Refresh = 1;
                    //js.SetText("MsgNav_Info", "<font color='#990000'>保存失败!<font>");
                    Response.Write(js.ToString());
                }
            %>
            <%pg.Dispose();%>
        </div>
    </form>
</body>
</html>
