<%@ Page Language="C#" Inherits="ClsPage" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<script runat="server">
    protected int gintTable;
    protected String gstrConnString;

    //protected string gstrRelation;
    protected long glngID;
    protected int gintIndex;
    protected long glngRelation;
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
                string sPath = pg["Path"];
                string sID = pg["ID"];
                string sTable = pg["Table"];

                glngID = Ly.String.Source(pg["Arg_ID"]).toLong;
                //gstrRelation = pg["Arg_Relation"];
                gintIndex = Ly.String.Source(pg["Arg_Index"]).toInteger;
                long lngRelationID = Ly.String.Source(pg["Arg_Relation"]).toLong;

                gintTable = Ly.String.Source(Pub.Request(this, "ViewTable")).toInteger;

                using (ClsAjaxRequest js = new ClsAjaxRequest()) {

                    //连接数据库，读取数据
                    Ly.DB.Dream.Tables gTabs = new Ly.DB.Dream.Tables(base.ConnectString);
                    //gTabs.SystemTables.GetDataByID(gintTable);
                    //gTabs.SystemColumns.GetDatasByParentID(gintTable);
                    //gTabs.SystemRelation.GetDatasByTableIDAndName(gintTable, gstrRelation);
                    if (!gTabs.SystemRelation.GetDataByID(lngRelationID)) {
                        pg.PageRequest.Message = "未找到表关联信息!";
                        pg.OutPutJsonRequest();
                        pg.Dispose();
                    }

                    dyk.DB.OA.SystemRelation.ExecutionExp gSystemRelation = new dyk.DB.OA.SystemRelation.ExecutionExp(this.BaseConnectString);
                    gSystemRelation.GetDataByID(lngRelationID);
                    //string sMsg = "Count:" + gTabs.SystemRelation.StructureCollection.Count + "<br />";

                    switch (gTabs.SystemRelation.Structure.Type) {
                        case 1://Page模式
                            #region [=====Page模式=====]
                            if (gTabs.SystemRelation.Structure.Column == "ID") {
                                pg.PageRequest.SetPageOpen(gTabs.SystemRelation.Structure.Path + "?ID=" + glngID);
                            } else {
                                using (Ly.DB.Dream.SystemTables.ExecutionExp st = new Ly.DB.Dream.SystemTables.ExecutionExp(base.ConnectString)) {
                                    //获取主表信息
                                    st.GetDataByID(gTabs.SystemRelation.Structure.TableID);
                                    using (Ly.Data.SQLClient Conn = new Ly.Data.SQLClient(base.ConnectString)) {
                                        //生成查询SQL
                                        string sql = "Select * From [" + st.Structure.Name + "] where [ID]=" + glngID;
                                        Conn.ExecuteReader(sql);
                                        if (Conn.DataReader.Read()) {
                                            string sValue = Conn.DataReader[gTabs.SystemRelation.Structure.Column].ToString();
                                            pg.PageRequest.SetPageOpen(gTabs.SystemRelation.Structure.Path + "?" + gTabs.SystemRelation.Structure.Column + "=" + sValue);
                                        } else {
                                            pg.PageRequest.Message = "未找到数据信息!";
                                            pg.OutPutJsonRequest();
                                            pg.Dispose();
                                        }
                                    }
                                }
                            }
                            pg.OutPutJsonRequest();
                            break;
                        #endregion
                        case 2://DS脚本模式
                            #region [=====DS脚本模式=====]

                            using (dyk.DB.Base.SystemTables.ExecutionExp st = new dyk.DB.Base.SystemTables.ExecutionExp(this.BaseConnectString)) {
                                using (DsLibrary lib = new DsLibrary(this, this.BaseConnectString, pg.XPort)) {
                                    using (dyk.Script.Code.Program.Actuator act = new dyk.Script.Code.Program.Actuator(gSystemRelation.Structure.DScript, lib)) {
                                        act.Execute();
                                    }
                                }
                            }

                            pg.OutPutXPort();

                            break;
                        #endregion
                        case 3://带条件选择关联模式
                            #region [=====带条件选择关联模式=====]
                            //条件筛选合适的关联
                            for (int i = 0; i < gTabs.SystemRelation.StructureCollection.Count; i++) {
                                using (Ly.DB.Dream.SystemTables.ExecutionExp st = new Ly.DB.Dream.SystemTables.ExecutionExp(base.ConnectString)) {
                                    using (Ly.DB.Dream.SystemPremises.ExecutionExp sp = new Ly.DB.Dream.SystemPremises.ExecutionExp(base.ConnectString)) {
                                        if (st.GetDataByID(gTabs.SystemRelation.StructureCollection[i].TableID)) {
                                            sp.GetDatasByRelationID(gTabs.SystemRelation.StructureCollection[i].ID);
                                            bool bMeet = true;
                                            if (sp.StructureCollection.Count > 0) {
                                                using (Ly.Data.SQLClient Conn = new Ly.Data.SQLClient(base.ConnectString)) {
                                                    string sql = "Select * From [" + st.Structure.Name + "] where [ID]=" + glngID;
                                                    Conn.ExecuteReader(sql);
                                                    if (Conn.DataReader.Read()) {
                                                        for (int j = 0; j < sp.StructureCollection.Count; j++) {
                                                            string sValue = Conn.DataReader[sp.StructureCollection[j].Column].ToString();
                                                            string spValue = sp.StructureCollection[j].Value;
                                                            using (AzJsonScript ajs = new AzJsonScript(this, base.ConnectString, "{}")) {
                                                                spValue = ajs.RepalceKey(spValue);
                                                            }
                                                            //sMsg += sValue + " " + sp.StructureCollection[i].PremiseType + " " + spValue + "<br />";
                                                            switch (sp.StructureCollection[j].PremiseType) {
                                                                case "等于":
                                                                    bMeet = (sValue == spValue) && bMeet;
                                                                    break;
                                                                case "不等于":
                                                                    bMeet = (sValue != spValue) && bMeet;
                                                                    break;
                                                                case "大于":
                                                                    bMeet = (Ly.String.Source(sValue).toDouble > Ly.String.Source(spValue).toDouble) && bMeet;
                                                                    break;
                                                                case "大于等于":
                                                                    bMeet = (Ly.String.Source(sValue).toDouble >= Ly.String.Source(spValue).toDouble) && bMeet;
                                                                    break;
                                                                case "小于":
                                                                    bMeet = (Ly.String.Source(sValue).toDouble < Ly.String.Source(spValue).toDouble) && bMeet;
                                                                    break;
                                                                case "小于等于":
                                                                    bMeet = (Ly.String.Source(sValue).toDouble <= Ly.String.Source(spValue).toDouble) && bMeet;
                                                                    break;
                                                                case "包含":
                                                                    bMeet = (sValue.IndexOf(spValue) >= 0) && bMeet;
                                                                    break;
                                                                case "开始于":
                                                                    bMeet = (sValue.StartsWith(spValue)) && bMeet;
                                                                    break;
                                                                case "结束于":
                                                                    bMeet = (sValue.EndsWith(spValue)) && bMeet;
                                                                    break;
                                                            }
                                                        }
                                                    }
                                                }
                                            }
                                            if (bMeet) {
                                                glngRelation = gTabs.SystemRelation.StructureCollection[i].ID;
                                                sTable = gTabs.SystemRelation.StructureCollection[i].RelationTableID.ToString();
                                                break;
                                            }
                                        }
                                    }
                                }
                            }



                            //js.Message = sMsg;
                            //js.SetStyle(sID, "backgroundColor", "");
                            //js.SetText("div_Console", "就绪!" + sql);
                            using (ClsAjaxRequest.Arg arg = new ClsAjaxRequest.Arg()) {
                                arg["Path"] = sPath;
                                arg["ID"] = sID;
                                arg["Table"] = sTable;
                                arg["Dialog_ElementID"] = pg.PageArgs.Dialog_ElementID;
                                arg["Dialog_ID"] = pg.PageArgs.Dialog_ID;
                                arg["Process_ElementID"] = pg.PageArgs.Process_ElementID;
                                arg["Process_ID"] = pg.PageArgs.Process_ID;
                                arg["Arg_ID"] = glngID.ToString();
                                arg["Arg_Relation"] = lngRelationID.ToString();
                                arg["Arg_Index"] = gintIndex.ToString();
                                js.SetAjaxLoad(pg.PageArgs.Process_ElementID, sPath + "Main.aspx", arg);
                            }

                            //js.SetText("MsgNav_Info", "<font color='#990000'>保存失败!<font>");
                            Response.Write(js.ToString());
                            break;
                        #endregion
                        default://标准单关联模式
                            #region [=====标准单关联模式=====]
                            //条件筛选合适的关联

                            //读取关联字段的值
                            string szValue = "";
                            string szTitle = "";
                            using (Ly.DB.Dream.SystemTables.ExecutionExp st = new Ly.DB.Dream.SystemTables.ExecutionExp(base.ConnectString)) {
                                //获取主表信息
                                st.GetDataByID(gTabs.SystemRelation.Structure.TableID);
                                using (Ly.Data.SQLClient Conn = new Ly.Data.SQLClient(base.ConnectString)) {
                                    //生成查询SQL
                                    string sql = "Select * From [" + st.Structure.Name + "] where [ID]=" + glngID;
                                    Conn.ExecuteReader(sql);
                                    if (Conn.DataReader.Read()) {
                                        szValue = Conn.DataReader[gTabs.SystemRelation.Structure.Column].ToString();
                                        szTitle = Conn.DataReader[gTabs.SystemRelation.Structure.PathColumn].ToString();
                                    } else {
                                        pg.PageRequest.Message = "未找到数据信息!";
                                        pg.OutPutJsonRequest();
                                        pg.Dispose();
                                    }
                                }
                            }


                            /////获取目标表格信息及关键ID
                            //using (Ly.DB.Dream.SystemTables.ExecutionExp st = new Ly.DB.Dream.SystemTables.ExecutionExp(base.ConnectString)) {
                            //    //获取主表信息
                            //    st.GetDataByID(gTabs.SystemRelation.Structure.RelationTableID);
                            //    sTable = gTabs.SystemRelation.Structure.RelationTableID.ToString();
                            //    using (Ly.Data.SQLClient Conn = new Ly.Data.SQLClient(base.ConnectString)) {
                            //        //生成查询SQL
                            //        string sql = "Select * From [" + st.Structure.Name + "] where [" + gTabs.SystemRelation.Structure.RelationColumn + "]=@Value";
                            //        Conn.NewCmd(sql);
                            //        Conn.AddParameter("@Value", szValue, System.Data.SqlDbType.VarChar, 500);
                            //        Conn.ExecuteReader();
                            //        if (Conn.DataReader.Read()) {
                            //            //glngID = Ly.String.Source(Conn.DataReader["ID"].ToString()).toLong;
                            //        } else {
                            //            pg.PageRequest.Message = "未找到数据信息!";
                            //            pg.OutPutJsonRequest();
                            //            pg.Dispose();
                            //        }
                            //    }
                            //}

                            //js.Message = sMsg;
                            //js.SetStyle(sID, "backgroundColor", "");
                            //js.SetText("div_Console", "就绪!" + sql);
                            using (ClsAjaxRequest.Arg arg = new ClsAjaxRequest.Arg(pg)) {
                                //                                UI:Window
                                //UI_ID:Table_30
                                //UI_Tool:Win_Table_30_Tool
                                //UI_Main:Win_Table_30_Main
                                //UI_Title:OA表格对象
                                //arg["Arg_Path"] = pg.;
                                arg["UI_Title"] = szTitle;
                                arg["ID"] = sID;
                                arg["Arg_Table"] = gTabs.SystemRelation.Structure.RelationTableID.ToString();
                                arg["Dialog_ElementID"] = pg.PageArgs.Dialog_ElementID;
                                arg["Dialog_ID"] = pg.PageArgs.Dialog_ID;
                                arg["Process_ElementID"] = pg.PageArgs.Process_ElementID;
                                arg["Process_ID"] = pg.PageArgs.Process_ID;
                                arg["Arg_ID"] = glngID.ToString();
                                arg["Arg_Relation"] = lngRelationID.ToString();
                                arg["Arg_Index"] = gintIndex.ToString();
                                arg["Arg_RelationText"] = szTitle;
                                //js.SetAjaxLoad(pg.PageArgs.Process_ElementID, sPath + "Main.aspx", arg);
                                js.SetAjaxScript(pg.PageArgs.Path + "Process.aspx", arg);
                            }

                            //js.SetText("MsgNav_Info", "<font color='#990000'>保存失败!<font>");
                            Response.Write(js.ToString());
                            break;
                            #endregion
                    }
                }
            %>
            <%pg.Dispose();%>
        </div>
    </form>
</body>
</html>
