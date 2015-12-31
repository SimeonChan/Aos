<%@ Page Language="C#" ValidateRequest="false" Inherits="ClsPage" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<script runat="server">
    protected long gintTable;
    protected String gstrConnString;

    //存储表单内容缓存
    protected Ly.Formats.Json gCache = new Ly.Formats.Json();

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

                //bool bSuccess = true;//是否成功执行

                long lngID = Ly.String.Source(pg["Arg_Key_ID"]).toLong;
                string szName = pg["Arg_Key_Name"];

                glngID = Ly.String.Source(pg["Arg_ID"]).toLong;
                glngRelation = Ly.String.Source(pg["Arg_Relation"]).toLong;
                gintIndex = Ly.String.Source(pg["Arg_Index"]).toInteger;

                gintTable = Ly.String.Source(Pub.Request(this, "Arg_Table")).toLong;
                gstrConnString = Pub.IO.ReadAllText(Server.MapPath(this.WebConfig.ConnectStringPath));
                Ly.DB.Dream.Tables gTabs = new Ly.DB.Dream.Tables(gstrConnString);
                gTabs.SystemTables.GetDataByID(gintTable);
                gTabs.SystemColumns.GetDataByParentIDAndName(gintTable, szName);

                //获取用户针对本表的所有权限

                #region [=====获取用户权限=====]

                dyk.Format.Limits lm = Pub.DB.GetTableLimits(this, gintTable);
                //dyk.DB.OA.SystemLimits.LimitMgr lm = new dyk.DB.OA.SystemLimits.LimitMgr();
                //lm.SetNoLimits();

                ////读取用户权限
                //using (dyk.DB.OA.SystemLimits.ExecutionExp gl = new dyk.DB.OA.SystemLimits.ExecutionExp(this.ConnectString)) {
                //    gl.GetDatasByUser(this.UserInfo.ID, gintTable);
                //    for (int m = 0; m < gl.StructureCollection.Count; m++) {
                //        //szUserLimits += gl.StructureCollection[m].Limits;
                //        lm.AddLimitsByString(gl.StructureCollection[m].Limits);
                //    }
                //}

                ////读取部门权限
                //using (dyk.DB.OA.SystemLimits.ExecutionExp gl = new dyk.DB.OA.SystemLimits.ExecutionExp(this.ConnectString)) {
                //    gl.GetDatasByDepartment(this.UserInfo.Department, gintTable);
                //    for (int m = 0; m < gl.StructureCollection.Count; m++) {
                //        //szUserLimits += gl.StructureCollection[m].Limits;
                //        lm.AddLimitsByString(gl.StructureCollection[m].Limits);
                //    }
                //}

                ////读取用户组权限
                //using (dyk.DB.OA.SystemLimits.ExecutionExp gl = new dyk.DB.OA.SystemLimits.ExecutionExp(this.ConnectString)) {
                //    gl.GetDatasByUserGroup(this.UserInfo.ID, gintTable);
                //    for (int m = 0; m < gl.StructureCollection.Count; m++) {
                //        //szUserLimits += gl.StructureCollection[m].Limits;
                //        lm.AddLimitsByString(gl.StructureCollection[m].Limits);
                //    }
                //}

                #endregion

                string szEventSql = "";

                using (ClsAjaxRequest js = new ClsAjaxRequest()) {
                    string sql = "";

                    if (lngID > 0) {

                        if (szName != "ID" && szName != "") {

                            if (lm.Edit) {

                                long lngValue = 0;

                                using (Ly.Data.SQLClient conn = new Ly.Data.SQLClient(gstrConnString)) {
                                    conn.NewCmd("Select [" + szName + "] From [" + gTabs.SystemTables.Structure.Name + "] where [ID]=@ID");
                                    conn.AddParameter("@ID", lngID, System.Data.SqlDbType.Decimal);
                                    conn.ExecuteReader();
                                    if (conn.DataReader.Read()) {
                                        lngValue = dyk.Type.String.New(conn.DataReader[szName].ToString()).ToNumber;
                                        lngValue = lngValue > 0 ? 0 : 1;
                                    }
                                }

                                sql = "Update [" + gTabs.SystemTables.Structure.Name + "] set [" + szName + "]=" + lngValue + "  where [ID]=" + lngID;

                                using (Ly.Data.SQLClient conn = new Ly.Data.SQLClient(gstrConnString)) {
                                    conn.ExecuteNonQuery(sql);
                                }

                                js.SetText(pg.PageArgs.UID + "_Check_" + lngID + "_" + szName, lngValue > 0 ? "√" : "");

                                if (gTabs.SystemTables.Structure.EventEdit == 1) szEventSql = Pub.IO.ReadAllText(Server.MapPath(this.WebConfig.SharePath + "/" + gTabs.SystemTables.Structure.Name + "/OnEditSave.azsql"));

                            } else {
                                //bSuccess = false;
                                js.Message = "您无修改权限！您的权限为:" + lm.ToString();
                            }

                        } else {
                            //bSuccess = false;
                            js.Message = "列名称不正确！";
                        }
                    } else {
                        //bSuccess = false;
                        js.Message = "请先选择一条数据！";
                    }

                    if (szEventSql != "") {
                        //处理保存事件
                        using (AzSqlProgram Asm = new AzSqlProgram(this, gstrConnString, null)) {
                            try {
                                szEventSql = Asm.ExecuteString(szEventSql);
                            } catch (Exception ex) {
                                pg.OutPut("脚本执行发生异常:" + ex.Message + "<br><br>");
                                pg.OutPut(Asm.Program.Debug().Replace("\r\n", "<br>").Replace("\n", "<br>").Replace(" ", "&nbsp;"));
                            } finally {
                                //pg.OutPut(Asm.Program.Debug().Replace("\r\n", "<br>").Replace("\n", "<br>").Replace(" ", "&nbsp;"));
                            }
                            //pg.OutPutAsText(Asm.Test(gszSql));
                            //pg.Dispose();
                        }

                        //pg.OutPutAsText(szEventSql);
                        //pg.Dispose();

                        using (Ly.Data.SQLClient conn = new Ly.Data.SQLClient(gstrConnString)) {
                            try {
                                conn.ExecuteNonQuery(szEventSql);
                            } catch (Exception ex) {
                                js.SetText(pg.PageArgs.Dialog_ElementID + "_Info", "<font color='#990000'>保存失败!" + ex.Message + "<font>");
                                js.Message = szEventSql.Replace("\r\n", "<br>").Replace("\n", "<br>").Replace(" ", "&nbsp;");
                                js.SetText("div_Console", "信息保存失败!");
                                //bSuccess = false;
                            }
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
