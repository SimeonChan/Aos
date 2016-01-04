<%@ Page Language="C#" Inherits="ClsPage" ValidateRequest="false" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<script runat="server">
    protected int gintTable;
    protected int gintColumn;
    protected String gstrColumn;
    protected String gstrConnString;
    protected String gstrFullPath;
    protected dyk.Format.Json gJson;
    protected string gstrFormStyle;
    protected string gstrFormContent;
    protected string gstrFormScript;

    //存储表单内容缓存
    protected dyk.Format.Json gCache = new dyk.Format.Json();

    protected long glngRelation;
    protected long glngID;
    protected int gintIndex;
    protected string gstrRelation;
    protected string gstrRelationColumn;
    protected Ly.DB.Dream.AzTables gTab;

    protected dyk.DB.Base.SystemTables.ExecutionExp gSystemTables;
</script>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
    <title></title>
    <link href="/css/Page.css" rel="stylesheet" />
    <link href="Css/Default.css" rel="stylesheet" />
</head>
<body>
    <form id="form1" runat="server">
        <div>
            <%ClsAjaxPage pg = new ClsAjaxPage(this); %>
            <%
                string sPath = Pub.Request(this, "Path");
                string sID = Pub.Request(this, "ID");
                string sTable = Pub.Request(this, "Table");

                //Ly.Formats.Json gFormValue = new Ly.Formats.Json();//

                glngID = Ly.String.Source(pg["Arg_ID"]).toLong;
                glngRelation = Ly.String.Source(pg["Arg_Relation"]).toLong;
                gintIndex = Ly.String.Source(pg["Arg_Index"]).toInteger;

                //gstrConnString = Pub.IO.ReadAllText(Server.MapPath(this.WebConfig.ConnectStringPath));

                gstrConnString = this.BaseConnectString;

                gTab = new Ly.DB.Dream.AzTables(gstrConnString);

                gSystemTables = new dyk.DB.Base.SystemTables.ExecutionExp(gstrConnString);

                #region [=====获取表关联设定=====]

                //获取表关联设定
                if (gTab.SystemRelation.GetDataByID(glngRelation)) {
                    gstrRelationColumn = gTab.SystemRelation.Structure.RelationColumn;
                    using (Ly.DB.Dream.SystemTables.ExecutionExp st = new Ly.DB.Dream.SystemTables.ExecutionExp(gstrConnString)) {
                        using (Ly.DB.Dream.SystemColumns.ExecutionExp sc = new Ly.DB.Dream.SystemColumns.ExecutionExp(gstrConnString)) {
                            st.GetDataByID(gTab.SystemRelation.Structure.TableID);
                            sc.GetDataByParentIDAndName(gTab.SystemRelation.Structure.TableID, gTab.SystemRelation.Structure.Column);
                            using (Ly.Data.SQLClient ConnRelation = new Ly.Data.SQLClient(gstrConnString)) {
                                ConnRelation.ExecuteReader("Select * from [" + st.Structure.Name + "] where [ID]=" + glngID);
                                if (ConnRelation.DataReader.Read()) {
                                    gstrRelation = ConnRelation.DataReader[gTab.SystemRelation.Structure.Column].ToString();
                                }
                            }
                            if (sc.Structure.Type == "int") {
                                gstrRelation = Ly.String.Source(gstrRelation).toInteger.ToString();
                            } else if (sc.Structure.Type.StartsWith("numeric")) {
                                gstrRelation = Ly.String.Source(gstrRelation).toDouble.ToString();
                            }
                            gCache[gTab.SystemRelation.Structure.RelationColumn]["Content"].Value = gstrRelation;
                            //pg.OutPutAsText(gstrRelationColumn + ":" + gstrRelation);
                        }
                    }
                }

                #endregion

                //gstrConnString = Pub.IO.ReadAllText(Server.MapPath("Conn.txt"));
                gintTable = Ly.String.Source(Pub.Request(this, "ViewTable")).toInteger;
                gintColumn = Ly.String.Source(Pub.Request(this, "Column")).toInteger;
                //gintDB = Ly.String.Source(Pub.Request(this, "DB")).toInteger;
                gstrColumn = Pub.Request(this, "Property");
                Ly.DB.Dream.AzTables gTabs = new Ly.DB.Dream.AzTables(gstrConnString);
                gSystemTables.GetDataByID(gintTable);
                //gTabs.SystemColumns.GetDatasByParentID(gintTable);

                //读取配置中的Form信息
                //string szSettingPath = Server.MapPath(this.WebConfig.SharePath + "/" + gSystemTables.Structure.Name);
                string szSettingPath = Server.MapPath(gSystemTables.Structure.SavePath);
                if (!System.IO.Directory.Exists(szSettingPath)) System.IO.Directory.CreateDirectory(szSettingPath);
                gstrFullPath = szSettingPath + "/UI.json";
                string sJson = Pub.IO.ReadAllEncryptionText(gstrFullPath);
                gJson = new dyk.Format.Json(sJson);

                //gJson.LoadFromString(sJson);

                long lngID = Ly.String.Source(pg["Key_ID"]).toLong;
                int nView = Ly.String.Source(pg["Key_View"]).toInteger;
                bool hasData = false;
                Ly.Data.SQLClient Conn = new Ly.Data.SQLClient(gstrConnString);

                //获取用户针对本表的所有权限
                //string szUserLimits = "";

                #region [=====加载初始化内容=====]

                //建立文件夹
                //string szSettingDir = Server.MapPath(this.WebConfig.SharePath + "/" + gSystemTables.Structure.Name);
                string szSettingDir = Server.MapPath(gSystemTables.Structure.SavePath);
                if (!System.IO.Directory.Exists(szSettingDir)) System.IO.Directory.CreateDirectory(szSettingDir);

                //读取初始化脚本
                string szPageScript = ""; //Pub.IO.ReadAllText(szScriptFile);

                //string szScriptFile = szSettingDir + "\\Add_OnLoad.ds";

                if (lngID > 0) {
                    //szScriptFile = szSettingDir + "\\Edit_OnLoad.ds";

                    using (dyk.DB.OA.SystemEvents.ExecutionExp se = new dyk.DB.OA.SystemEvents.ExecutionExp(this.BaseConnectString)) {
                        if (se.GetDataByTableIDAndName(gintTable, "Edit_OnLoad")) {
                            szPageScript = se.Structure.DScript;
                        }
                    }

                    string sql = "Select * from [" + gSystemTables.Structure.Name + "] where [ID]=" + lngID;
                    Conn.ExecuteReader(sql);
                    if (Conn.DataReader.Read()) {
                        for (int i = 0; i < Conn.DataReader.FieldCount; i++) {
                            gCache[Conn.DataReader.GetName(i)]["Content"].Value = Conn.DataReader[i].ToString();
                        }
                    }
                } else {
                    using (dyk.DB.OA.SystemEvents.ExecutionExp se = new dyk.DB.OA.SystemEvents.ExecutionExp(this.BaseConnectString)) {
                        if (se.GetDataByTableIDAndName(gintTable, "Add_OnLoad")) {
                            szPageScript = se.Structure.DScript;
                        }
                    }
                }



                using (DsLibrary lib = new DsLibrary(this, this.BaseConnectString, gCache)) {
                    using (dyk.Script.Code.Program.Actuator act = new dyk.Script.Code.Program.Actuator(szPageScript, lib)) {
                        act.Execute();
                    }
                }

                //using (AzSqlProgram Asm = new AzSqlProgram(this, gstrConnString, gCache)) {
                //    try {
                //        szPageScript = Asm.ExecuteString(szPageScript);
                //    } catch (Exception ex) {
                //        pg.OutPut("脚本文件:" + szScriptFile + "<br>");
                //        pg.OutPut("脚本执行发生异常:" + ex.Message + "<br><br>");
                //        pg.OutPut(Asm.Program.Debug().Replace("\r\n", "<br>").Replace("\n", "<br>").Replace(" ", "&nbsp;"));
                //    } finally {
                //        pg.OutPutAsText(szPageScript);
                //        //pg.OutPut(Asm.Program.Debug().Replace("\r\n", "<br>").Replace("\n", "<br>").Replace(" ", "&nbsp;"));
                //    }
                //    //pg.OutPutAsText(szPageScript);
                //    //pg.Dispose();
                //}

                #endregion

                //读取用户权限
                dyk.Format.Limits slm = Pub.DB.GetTableLimits(this, gintTable);

                //定义保存交互的相关参数
                gstrFormScript = "$.Dialog.Form.DataClear();";
                gstrFormScript += "$.Dialog.Form.DataSet('Arg_Table','" + sTable + "');";
                gstrFormScript += "$.Dialog.Form.DataSet('Arg_ViewTable','" + gintTable + "');";
                gstrFormScript += "$.Dialog.Form.DataSet('Arg_Path','" + pg.PageArgs.Path + "');";
                gstrFormScript += "$.Dialog.Form.DataSet('ID','" + sID + "');";
                gstrFormScript += "$.Dialog.Form.DataSet('Dialog_ElementID','" + pg.PageArgs.Dialog_ElementID + "');";
                gstrFormScript += "$.Dialog.Form.DataSet('Dialog_ID','" + pg.PageArgs.Dialog_ID + "');";
                gstrFormScript += "$.Dialog.Form.DataSet('Process_ElementID','" + pg.PageArgs.Process_ElementID + "');";
                gstrFormScript += "$.Dialog.Form.DataSet('Process_ID','" + pg.PageArgs.Process_ID + "');";
                gstrFormScript += "$.Dialog.Form.DataSet('Arg_ID','" + glngID + "');";
                gstrFormScript += "$.Dialog.Form.DataSet('Arg_Relation','" + glngRelation + "');";
                gstrFormScript += "$.Dialog.Form.DataSet('Arg_Index','" + gintIndex + "');";
                gstrFormScript += "$.Dialog.Form.DataSet('Arg_RelationText','" + pg["Arg_RelationText"] + "');";
                gstrFormScript += "$.Dialog.Form.DataSet('UI','" + pg.PageArgs.UI + "');";
                gstrFormScript += "$.Dialog.Form.DataSet('UI_ID','" + pg.PageArgs.UID + "');";
                gstrFormScript += "$.Dialog.Form.DataSet('UI_Main','" + pg.PageArgs.UIMain + "');";
                gstrFormScript += "$.Dialog.Form.DataSet('UI_Title','" + pg.PageArgs.UITitle + "');";
                gstrFormScript += "$.Dialog.Form.DataSet('UI_Tool','" + pg.PageArgs.UITool + "');";
                if (lngID > 0) gstrFormScript += "$.Dialog.Form.DataSet('Key_ID','" + lngID + "');";

                string sTemp;
                for (int i = 0; i < gJson.Children.Count; i++) {
                    dyk.Format.JsonObject obj = (dyk.Format.JsonObject)gJson.Children[i];
                    switch (obj.Name.ToLower()) {
                        case "form"://窗口相关设定
                            #region [=====窗口相关设定处理=====]
                            for (int j = 0; j < obj.Count; j++) {
                                switch (obj[j].Name) {
                                    case "Width":
                                        gstrFormStyle += "width:" + Ly.String.Source(obj[j].Value).toInteger + "px;";
                                        break;
                                    case "Height":
                                        gstrFormStyle += "height:" + (Ly.String.Source(obj[j].Value).toInteger - 30) + "px;";
                                        break;
                                    case "Overflow":
                                        gstrFormStyle += "overflow:" + obj[j].Value + ";";
                                        break;
                                }
                            }
                            break;
                        #endregion
                        case "label"://标签内容
                            #region [=====标签相关设定处理=====]
                            //gstrFormContent += sTemp;
                            gstrFormContent += Pub.UI.GetLabel(obj, gCache, slm);
                            break;
                        #endregion
                        case "line":
                            #region [=====线条处理=====]
                            gstrFormContent += Pub.UI.GetLine(obj, gCache, slm);
                            break;
                        #endregion
                        case "textbox"://输入框内容
                            #region [=====输入框相关设定处理=====]

                            string txtName = obj["Name"].Value;
                            string txtValue = "";
                            string txtID = "";
                            string szType = obj["Type"].Value.ToLower();
                            bool bEditLimit = true;
                            string szID = obj["ID"].Value;

                            //当前是否具有编辑权限
                            //if (obj["Limit"].Value != "") {
                            //    bEditLimit = Limits.CheckLimit(szUserLimits, "[" + obj["Limit"].Value + "]");
                            //}
                            if (lngID > 0) {
                                bEditLimit = slm.Edit;
                            }else{
                                bEditLimit = slm.Add;
                            }
                            

                            if (nView == 1) bEditLimit = false;

                            #region [=====值初始处理=====]

                            if (txtName == gstrRelationColumn) txtValue = gstrRelation;
                            //Ly.Formats.JsonUnitPoint jup = gCache.Object.FindChild(szID);
                            dyk.Format.JsonObject jup = gCache.FindChild(szID);
                            if (jup != null) {
                                obj.Coalition(jup);
                            }

                            dyk.Format.JsonObject pCnt = obj.FindChild("Content");
                            if (pCnt != null) txtValue = pCnt.Value;

                            if (gCache[szID].Value != "") {
                                txtValue = gCache[szID].Value;
                            }


                            //if (lngID > 0) {
                            //    if (hasData) {
                            //        if (txtName != "") {
                            //            txtValue = Conn.DataReader[txtName].ToString();
                            //        }
                            //    }
                            //}

                            //if (txtValue == "") {
                            //    //执行Json脚本获得内容
                            //    string json = obj["Value"].ToJsonString();
                            //    //pg.OutPut(txtName + ":" + json + "<br/>");
                            //    try {
                            //        using (AzJsonScript ajs = new AzJsonScript(this, gstrConnString, json)) {
                            //            for (int x = 0; x < gCache.Object.Count; x++) {
                            //                ajs.Json.FormValues[gCache.Object[x].Name] = gCache.Object[x].Value;
                            //            }
                            //            //pg.OutPut("<栏目管理.根栏目>=\"" + ajs.GetColumnName("栏目管理", "根栏目") + "\"<br />\n");
                            //            //pg.OutPut(txtName + ":" + ajs.Json.ToString() + ":" + ajs.Json.Binding + ":" + ajs.Json["Binding"] + (ajs.Json.Type == "Read" ? ajs.GetNormalSQLString() : "") + "<br />\n");
                            //            //pg.OutPut(txtName + ":" + ajs.GetNormalSQLString() + "<br />\n");
                            //            txtValue = ajs.GetValue();
                            //            //pg.OutPut(txtName + ":" + ajs.Json.Binding + "<br />\n");
                            //        }
                            //    } catch (Exception ex) {
                            //        pg.OutPut(txtName + ":" + json + "<br/>\n");
                            //        pg.OutPut("[Error:" + ex.Message + "]<br />\n");
                            //    }

                            //}

                            //#region [=====View对象处理=====]
                            ////显示处理
                            //switch (obj["View"]["Type"].Value) {
                            //    case "Read":
                            //        //读取SQL脚本内容
                            //        string szFileName = gSystemTables.Structure.Name + "_" + obj["ID"].Value + "_View.azsql";
                            //        string szSql = Pub.IO.ReadAllText(Server.MapPath(this.WebConfig.ShareSQLSettingPath + "/" + szFileName));
                            //        using (AzSqlProgram Asm = new AzSqlProgram(this, gstrConnString, gCache)) {
                            //            try {
                            //                szSql = Asm.ExecuteString(szSql);
                            //            } catch (Exception ex) {
                            //                pg.OutPut("脚本文件:" + szFileName + "<br>");
                            //                pg.OutPut("脚本执行发生异常:" + ex.Message + "<br><br>");
                            //                pg.OutPut(Asm.Program.Debug().Replace("\r\n", "<br>").Replace("\n", "<br>").Replace(" ", "&nbsp;"));
                            //            } finally {
                            //                //pg.OutPut(Asm.Program.Debug().Replace("\r\n", "<br>").Replace("\n", "<br>").Replace(" ", "&nbsp;"));
                            //            }
                            //            //pg.OutPutAsText(Asm.Test(gszSql));
                            //            //pg.Dispose();
                            //        }
                            //        using (Ly.Data.SQLClient ConnView = new Ly.Data.SQLClient(this.ConnectString)) {
                            //            try {
                            //                ConnView.ExecuteReader(szSql);
                            //                if (ConnView.DataReader.Read()) {
                            //                    txtValue = ConnView.DataReader[0].ToString();
                            //                }
                            //            } catch (Exception ex) {
                            //                pg.OutPutAsText("Sql:" + szSql);
                            //                pg.OutPut("<br>");
                            //                pg.OutPutAsText("Error:" + ex.Message);
                            //            }
                            //        }
                            //        break;
                            //}
                            //#endregion

                            #endregion

                            txtID = pg.PageArgs.Dialog_ElementID + "_" + obj["ID"].Value;

                            #region [=====存储表单缓存=====]
                            if (txtName != "") {
                                //    //存储原始表单内容
                                gstrFormScript += "$.Dialog.Form.DataSetByValue('" + txtName + "','" + txtID + "');";
                                //    gTabs.SystemColumns.GetDataByParentIDAndName(gintTable, txtName);
                                if (gTabs.SystemColumns.Structure.Type == "int") {
                                    gCache[txtName].Value = Ly.String.Source(txtValue).toInteger.ToString();
                                } else if (gTabs.SystemColumns.Structure.Type.StartsWith("numeric")) {
                                    gCache[txtName].Value = Ly.String.Source(txtValue).toDouble.ToString();
                                } else {
                                    gCache[txtName].Value = txtValue;
                                }
                            }
                            #endregion

                            if (obj["Format"].Value != "") {

                            }

                            sTemp = "<div style=\"position:absolute;";
                            if (szType == "") szType = "text";
                            if (obj["Left"].Value != "") sTemp += "left:" + Ly.String.Source(obj["Left"].Value).toInteger + "px;";
                            if (obj["Top"].Value != "") sTemp += "top:" + Ly.String.Source(obj["Top"].Value).toInteger + "px;";
                            sTemp += "\">";

                            sTemp += "<div style=\"float:left;\">";

                            switch (szType.Trim().ToLower()) {
                                case "textarea":
                                    sTemp += "<textarea cols=\"20\" rows=\"2\"";
                                    sTemp += " id=\"" + txtID + "\"";
                                    break;
                                case "html":
                                    sTemp += "<div";
                                    break;
                                default:
                                    sTemp += "<input";
                                    sTemp += " id=\"" + txtID + "\"";
                                    break;
                            }
                            //sTemp += "<" + (szType != "textarea" ? "input" : "textarea cols=\"20\" rows=\"2\"");
                            sTemp += " name=\"" + txtName + "\"";
                            sTemp += " onfocus=\"$('#" + pg.PageArgs.Dialog_ElementID + "_Info').html('<font color=#000099>提示:" + gTabs.SystemColumns.Structure.Text + "</font>');\"";


                            //非textarea模式时值在Value属性中
                            if (szType != "textarea") sTemp += " value=\"" + txtValue.Replace("\"", "&quot;") + "\"";

                            if (!bEditLimit) {
                                sTemp += " readonly=\"readonly\"";
                            } else {
                                //文件、日期选择器时，比为只读
                                if (obj["ReadOnly"].Value.Trim().ToLower() == "true" || szType == "file" || szType == "date") sTemp += " readonly=\"readonly\"";
                            }

                            sTemp += " style=\"";
                            sTemp += obj["Style"].Value;
                            sTemp += "width:" + (obj["Width"].Value == "" ? "100" : obj["Width"].Value) + "px;";
                            if (obj["Height"].Value != "") sTemp += "height:" + Ly.String.Source(obj["Height"].Value).toInteger + "px;";
                            if (obj["LineHeight"].Value != "") sTemp += "line-height:" + Ly.String.Source(obj["LineHeight"].Value).toInteger + "px;";

                            //添加Padding属性
                            if (obj["Padding"].Value != "") {
                                string[] sPad = obj["Padding"].Value.Split(',');
                                if (sPad.Length == 4) {
                                    sTemp += "padding:";
                                    for (int sp = 0; sp < sPad.Length; sp++) {
                                        sTemp += " " + Ly.String.Source(sPad[sp].Trim()).toInteger + "px";
                                    }
                                    sTemp += ";";
                                }
                            }

                            sTemp += " \"";

                            if (obj["OnLeave"].Value == "True") {

                                //读取SQL脚本内容
                                //string szSql = Pub.IO.ReadAllText(Server.MapPath(this.WebConfig.SharePath + "/" + gSystemTables.Structure.Name + "/" + obj["ID"].Value + "_OnLeave.azsql"));
                                string szSql = Pub.IO.ReadAllText(Server.MapPath(gSystemTables.Structure.SavePath + "/" + obj["ID"].Value + "_OnLeave.azsql"));
                                using (AzSqlProgram Asm = new AzSqlProgram(this, gstrConnString, null)) {
                                    try {
                                        szSql = Asm.ExecuteString(szSql);
                                    } catch (Exception ex) {
                                        pg.OutPut("脚本执行发生异常:" + ex.Message + "<br><br>");
                                        pg.OutPut(Asm.Program.Debug().Replace("\r\n", "<br>").Replace("\n", "<br>").Replace(" ", "&nbsp;"));
                                    } finally {
                                        //pg.OutPut(Asm.Program.Debug().Replace("\r\n", "<br>").Replace("\n", "<br>").Replace(" ", "&nbsp;"));
                                    }
                                    //pg.OutPutAsText(Asm.Test(gszSql));
                                    //pg.Dispose();
                                }
                                sTemp += " onblur=\"" + szSql.Replace("\r\n", "").Replace("\n", "") + "\"";
                            }

                            switch (szType) {
                                case "textarea":
                                    sTemp += ">" + txtValue + "</textarea>";
                                    break;
                                case "html":
                                    sTemp += ">";
                                    sTemp += "<div style=\"position: relative; width: 100%; height: 100%;\">";
                                    sTemp += "<div style=\"position: absolute; left: 0px; top: 0px; padding-top: 30px; width:100%; height:100%; overflow:hidden; box-sizing: border-box; -moz-box-sizing: border-box; -webkit-box-sizing: border-box;\">";
                                    sTemp += "<textarea id=\"" + txtID + "\" cols=\"20\" rows=\"2\" readonly=\"readonly\" style=\"width:100%; height:100%; border:0px;\">" + txtValue + "</textarea>";
                                    sTemp += "</div>";
                                    sTemp += "<div style=\"position: absolute; left: 0px; top: 0px; width: 100%; height: 30px; padding: 5px; background:#ccc; box-sizing: border-box; -moz-box-sizing: border-box; -webkit-box-sizing: border-box;\"><a href=\"javascript:;\" onclick=\"Page.ShowUEditor('" + txtID + "');\">点击使用HTML编辑器编辑</a></div>";
                                    sTemp += "</div>";
                                    sTemp += "</div>";
                                    break;
                                case "file":
                                case "date":
                                    sTemp += " type=\"text\" />";
                                    break;
                                default:
                                    sTemp += " type=\"" + szType + "\" />";
                                    break;
                            }


                            sTemp += "</div>";

                            if (bEditLimit) {

                                //上传文件
                                if (szType == "file") {
                                    sTemp += "<div style=\"float:left;padding:0px 5px;height:22px;line-height:22px;border:1px solid #222;cursor:pointer;\" onclick=\"Page.ShowUpload('" + txtID + "');\">";
                                    sTemp += "...";
                                    sTemp += "</div>";
                                    //sTemp += "<div style=\"float:left;padding-left:5px;\">";
                                    //sTemp += "<input id=\"" + txtID + "_Upload\" type=\"button\" value=\"选择\" style=\"padding-top: 2px; width: 60px; height: 22px\" onclick=\"Page.ShowUpload('" + txtID + "');\" />";
                                    //sTemp += "</div>";
                                }

                                //内容选择器
                                if (obj["Value"]["Type"].Value == "Select") {

                                    string sClick = "";
                                    for (int c = 0; c < gCache.Count; c++) {
                                        sClick += ",";
                                        sClick += "Form_" + gCache[c].Name + ":$('#" + pg.PageArgs.Dialog_ElementID + "_" + gCache[c].Name + "').val()";
                                    }

                                    sTemp += "<div style=\"float:left;padding:0px 5px;height:22px;line-height:22px;border:1px solid #222;cursor:pointer;\" onclick=\"Page.Functions.Table.Dialog('" + txtID + "_Select','" + pg.PageArgs.UID + "', '选择一条内容', 640, 480, '" + pg.PageArgs.UIPath + "','Select.aspx', {Arg_Select_InputID: '" + pg.PageArgs.Dialog_ElementID + "',Arg_Select_ID:'" + obj["ID"].Value + "',Arg_Select_Table:" + gintTable + sClick + " });\">";
                                    sTemp += "...";
                                    sTemp += "</div>";

                                    //sTemp += "<div style=\"float:left;padding-left:5px;\">";
                                    //sTemp += "<input id=\"" + txtID + "_Select\" type=\"button\" value=\"选择\" style=\"padding-top: 2px; width: 60px; height: 22px\" onclick=\"Page.Functions.Table.Dialog('" + txtID + "_Select','" + pg.PageArgs.UID + "', '选择一条内容', 640, 480, '" + pg.PageArgs.UIPath + "','Select.aspx', {Arg_Select_InputID: '" + pg.PageArgs.Dialog_ElementID + "',Arg_Select_ID:'" + obj["ID"].Value + "',Arg_Select_Table:" + gintTable + sClick + " });\" />";
                                    //sTemp += "</div>";
                                }

                                //日期选择器
                                if (szType == "date" && obj["ReadOnly"].Value != "True") {
                                    sTemp += "<div style=\"float:left;padding:0px 5px;height:22px;line-height:22px;border:1px solid #222;cursor:pointer;\" onclick=\"DatePicker.Move((document.documentElement.clientWidth - 434) / 2, 209);DatePicker.DayPicker('" + txtID + "','" + txtValue + "');\">";
                                    sTemp += "...";
                                    sTemp += "</div>";
                                }

                                //内容选择器
                                if (obj["Value"]["Type"].Value == "SelectAndInsert") {
                                    sTemp += "<div style=\"float:left;padding-left:5px;\">";
                                    sTemp += "<input id=\"" + txtID + "_Select\" type=\"button\" value=\"选择\" style=\"padding-top: 2px; width: 60px; height: 22px\" onclick=\"$.Dialog.ShowFromUrl('" + txtID + "_Select', '选择一条内容', 640, 480, '" + sPath + "Ajax/Select.aspx', {Path: '/Files/App/System/Select/', InputID: '" + pg.PageArgs.Dialog_ElementID + "',Arg_ID:'" + obj["ID"].Value + "',Arg_Table:" + gintTable + " });\" />";
                                    sTemp += "</div>";

                                    //读取SQL脚本内容
                                    string szSql = Pub.IO.ReadAllText(Server.MapPath(gSystemTables.Structure.SavePath + "/" + obj["ID"].Value + "_JsAdd.azsql"));
                                    using (AzSqlProgram Asm = new AzSqlProgram(this, gstrConnString, null)) {
                                        try {
                                            szSql = Asm.ExecuteString(szSql);
                                        } catch (Exception ex) {
                                            pg.OutPut("脚本执行发生异常:" + ex.Message + "<br><br>");
                                            pg.OutPut(Asm.Program.Debug().Replace("\r\n", "<br>").Replace("\n", "<br>").Replace(" ", "&nbsp;"));
                                        } finally {
                                            //pg.OutPut(szSql);
                                            //pg.OutPut("<br>");
                                            //pg.OutPut(Asm.Program.Debug().Replace("\r\n", "<br>").Replace("\n", "<br>").Replace(" ", "&nbsp;"));
                                        }
                                        //pg.OutPutAsText(Asm.Test(gszSql));
                                        //pg.Dispose();
                                    }

                                    sTemp += "<div style=\"float:left;padding-left:5px;\">";
                                    sTemp += "<input id=\"" + txtID + "_Add\" type=\"button\" value=\"添加\" style=\"padding-top: 2px; width: 60px; height: 22px\" onclick=\"" + szSql.Replace("\r\n", "").Replace("\n", "") + "\" />";
                                    sTemp += "</div>";
                                }

                            }

                            sTemp += "<div style=\"clear:both;\"></div>";

                            sTemp += "</div>";
                            //if sTemp += " value=\"" + obj.Items["Text"].Value + "\"";
                            gstrFormContent += sTemp;
                            break;
                            #endregion
                    }
                }
                gstrFormScript += "$.Dialog.Form.Submit('" + pg.PageArgs.UID + "','" + pg.PageArgs.UIPath + "AddSave.aspx');";
                //gstrFormScript += "alert(JSON.stringify($.Dialog.Form.Data));";
            %>
            <%
//Ly.DB.Dream.AzTables.Json js = new Ly.DB.Dream.AzTables.Json("{Binding:\"栏目管理.栏目名称\"}");
//js.Tables = "sssss";
//Response.Write(gTabs.ChangeJsonToSql(js.Object.ToString()));
            %>
            <div class="plug-MsgNav">
                <div id="<%=pg.PageArgs.Dialog_ElementID%>_Info" style="float: left; padding: 2px 3px 0px 3px;"><%=lngID > 0 && !hasData ? "未找到相应数据" : "输入完成后点击右侧的[保存]按钮→"%></div>
                <%if (nView != 1) { %>
                <div style="float: right; padding-right: 5px;">
                    <input id="<%=pg.PageArgs.Dialog_ElementID%>_OK" type="button" value="保存" onclick="<%=gstrFormScript%>" />
                </div>
                <%} %>
                <div class="pub-clear"></div>
            </div>
            <div style="position: relative; <%=gstrFormStyle%>">
                <%=gstrFormContent%>
            </div>
            <%pg.Dispose();%>
        </div>
    </form>
</body>
</html>
