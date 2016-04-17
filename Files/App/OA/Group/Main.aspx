<%@ Page Language="C#" Inherits="ClsPage" ValidateRequest="false" %>

<!DOCTYPE html>

<script runat="server">
  protected String gstrConnString;
  protected long gintTable;
  protected long glngRelation;//关联编号
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

  protected string gszParentHTML;//父对象界面
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
      <%dyk.WebSite.Table2D gTable2D = new dyk.WebSite.Table2D(this); %>
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

        gintLines = 10;
        gintPage = Ly.String.Source(this["Arg_Page"]).toInteger;
        if (gintPage < 1) gintPage = 1;

        //gstrConnString = Pub.IO.ReadAllText(Server.MapPath(this.WebConfig.ConnectStringPath));

        gstrConnString = this.BaseConnectString;

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

        //读取相应的字段结构
        gSystemColumns.GetDatasByParentID(gintTable);


        //pg.OutPut("<div>" + glngRelation + "</div>");

        //关联表处理
        if (gSystemRelation.GetDataByID(glngRelation)) {


          #region [=====处理关联表====]

          using (Ly.DB.Dream.SystemTables.ExecutionExp st = new Ly.DB.Dream.SystemTables.ExecutionExp(gstrConnString)) {
            using (Ly.DB.Dream.SystemColumns.ExecutionExp sc = new Ly.DB.Dream.SystemColumns.ExecutionExp(gstrConnString)) {
              st.GetDataByID(gSystemRelation.Structure.TableID);

              sc.GetDataByParentIDAndName(gSystemRelation.Structure.TableID, gSystemRelation.Structure.Column);
              using (Ly.Data.SQLClient Conn = new Ly.Data.SQLClient(gstrConnString)) {
                Conn.ExecuteReader("Select * from [" + st.Structure.Name + "] where [ID]=" + glngID);
                if (Conn.DataReader.Read()) {

                  //读取选择的值和显示的路径名称
                  SelVal = Conn.DataReader[gSystemRelation.Structure.Column].ToString();
                  gstrRelation = Conn.DataReader[gSystemRelation.Structure.PathColumn].ToString();

                  #region [=====读取父对象信息并生成代码=====]

                  using (dyk.DB.Base.SystemTables.ExecutionExp sTab = new dyk.DB.Base.SystemTables.ExecutionExp(this.BaseConnectString)) {
                    sTab.GetDataByID(gSystemRelation.Structure.TableID);

                    string szParentPath = Server.MapPath(sTab.Structure.SavePath);
                    if (!System.IO.Directory.Exists(szParentPath)) System.IO.Directory.CreateDirectory(szParentPath);
                    string szParentFile = szParentPath + "/UI.json";
                    string szParentJson = Pub.IO.ReadAllEncryptionText(szParentFile);

                    //pg.OutPutAsText(szParentJson);

                    using (dyk.JsonUI.Manager mgr = new dyk.JsonUI.Manager(pg, szParentJson)) {
                      for (int i = 0; i < Conn.DataReader.FieldCount; i++) {
                        string szName = Conn.DataReader.GetName(i);
                        string szValue = Conn.DataReader[i].ToString();
                        mgr.Cache[szName]["Content"].Value = szValue;
                      }

                      //加载初始化脚本并执行
                      using (dyk.DB.OA.SystemEvents.ExecutionExp se = new dyk.DB.OA.SystemEvents.ExecutionExp(this.BaseConnectString)) {
                        if (se.GetDataByTableIDAndName(gSystemRelation.Structure.TableID, "Edit_OnLoad")) {
                          //szPageScript = se.Structure.DScript;

                          using (DsLibrary lib = new DsLibrary(this, this.BaseConnectString, mgr.Cache)) {
                            using (dyk.Script.Code.Program.Actuator act = new dyk.Script.Code.Program.Actuator(se.Structure.DScript, lib)) {
                              act.Execute();
                            }
                          }

                        }
                      }

                      gszParentHTML = mgr.GetOutputHTML();
                    }

                  }

                  #endregion
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
          pg.OutPut("组合信息必须在关联模式中打开!");
          pg.Dispose();
        }

      %>

      <%

        //获取用户针对本表的所有权限
        //string szUserLimits = "";
        dyk.Format.Limits slm = Pub.DB.GetTableLimits(this, gintTable);
        ////slm.SetAllLimits();

        #region [=====获取用户权限=====]

        ////读取用户权限
        //using (dyk.DB.Base.SystemUserLimits.ExecutionExp gl = new dyk.DB.Base.SystemUserLimits.ExecutionExp(this.ConnectString)) {
        //    gl.GetDataByUserAndTable(this.UserInfo.ID, gintTable);
        //    for (int m = 0; m < gl.StructureCollection.Count; m++) {
        //        //szUserLimits += gl.StructureCollection[m].Limits;
        //        slm.SetLimitsByString(gl.StructureCollection[m].Limits);
        //    }
        //}

        //读取部门权限
        //using (Ly.DB.Dream.SystemLimits.ExecutionExp gl = new Ly.DB.Dream.SystemLimits.ExecutionExp(this.ConnectString)) {
        //    gl.GetDatasByDepartmentID(this.UserInfo.Department, gintTable);
        //    for (int m = 0; m < gl.StructureCollection.Count; m++) {
        //        szUserLimits += gl.StructureCollection[m].Limits;
        //    }
        //}

        //读取用户组权限
        //using (Ly.DB.Dream.SystemLimits.ExecutionExp gl = new Ly.DB.Dream.SystemLimits.ExecutionExp(this.ConnectString)) {
        //    gl.GetDatasByUserGroups(this.UserInfo.ID, gintTable);
        //    for (int m = 0; m < gl.StructureCollection.Count; m++) {
        //        szUserLimits += gl.StructureCollection[m].Limits;
        //    }
        //}

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
      <div style="position: absolute; top: 30px; left: 0px; z-index: 1; height: 30px; width: 100%; box-sizing: border-box; -moz-box-sizing: border-box; -webkit-box-sizing: border-box; padding: 6px 0px 0px 6px; background: #DDDDDD; overflow: hidden; border-bottom: 1px solid #ccc;">

        <!--工具栏|添加-->
        <%if (slm.Add) { %>
        <%szScript = "Page.Functions.Table.Add('" + pg.PageArgs.Path + "','" + pg.PageArgs.UID + "','" + gSystemTables.Structure.Text + "'," + gintWidth + "," + gintHeight + ",{" + gstrArgs + "," + gAddJson.Object.ToString().Substring(1, gAddJson.Object.ToString().Length - 2).Replace("\"", "'") + "});"; %>
        <div class="pub-left" style="padding: 0px 3px 0px 5px;">
          <a href="javascript:;" onclick="<%=szScript%>">
            <img src="<%=pg.PageArgs.Path%>images/Tool_Add.gif" width="16" height="16" alt="" style="padding-top: 0px;" /></a>
        </div>
        <div class="pub-left" style="margin-right: 5px;"><a href="javascript:;" onclick="<%=szScript%>">回复</a></div>
        <%} else { %>
        <div class="pub-left" style="border-left: 1px solid #CCCCCC; margin-left: 5px; padding: 0px 3px 0px 10px;">
          <img src="<%=pg.PageArgs.Path%>images/Tool_Add.gif" width="16" height="16" alt="" style="padding-top: 0px;" />
        </div>
        <div class="pub-left" style="margin-right: 5px;"><span style="color: #808080">回复</span></div>
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
      <div style="position: absolute; top: 0px; left: 0px; padding: 6px; z-index: 1; width: 100%; height: 30px; background: #eee; border-bottom: 1px solid #ccc;">
        <div style="float: left;">当前路径:</div>
        <%
          szClick = "Page.UI.Open('DataManager','','数据管理','/Files/App/System/DataManager/','Process.aspx', {});";
                                    //Page.UI.Open('AppManager','','我的应用','/Files/App/System/Applications/','Process.aspx',{Path:'/Files/App/Com_Application/',ID:'AppManager'});
        %>
        <div style="float: left;"><a href="javascript:;" onclick="<%=szClick%>">数据管理</a></div>
        <%
          gSystemHistory.GetDatasByNameAndIndex(pg.PageArgs.UID, gintIndex);
          for (int i = 0; i < gSystemHistory.StructureCollection.Count; i++) {
        %>
        <%szScript = "Page.Functions.Table.Load('" + pg.PageArgs.UID + "',{Arg_Table:" + gSystemHistory.StructureCollection[i].TableID + ",Arg_Index:" + gSystemHistory.StructureCollection[i].Index + ",Arg_Relation:'" + gSystemHistory.StructureCollection[i].RelationID + "',Arg_RelationText:'" + gSystemHistory.StructureCollection[i].Text + "'});"; %>
        <div style="float: left;">&gt;</div>
        <div style="float: left;"><a href="javascript:;" onclick="<%=szScript%>"><%=gSystemHistory.StructureCollection[i].Text%></a></div>
        <%} %>
        <div style="clear: both"></div>
      </div>

      <!--父表格信息-->
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
                  szth += "<a href=\"javascript:;\" onclick=\"Page.Functions.Table.Filter('" + pg.PageArgs.Path + "','" + pg.PageArgs.UID + "', '" + st.Text + "', 800, 480, " + Arg.ToString().Replace("\"#", "").Replace("#\"", "").Replace("\"", "'") + ");\">" + gSystemColumns.StructureCollection[i].Text + "</a>";
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

      <!--主体表格-->
      <div style="position: absolute; top: 0px; padding: 65px 5px 30px 5px; width: 100%; height: 100%; overflow: hidden; box-sizing: border-box; -moz-box-sizing: border-box; -webkit-box-sizing: border-box; z-index: 0;">
        <div style="width: 100%; height: 100%; overflow: auto">

          <div style="width: 100%; padding: 5px; background: #0094ff; color: #fff; font-weight: bold;">主体信息</div>

          <!--父表格信息-->
          <div style="background: #f1f9ff;">
            <%=gszParentHTML %>
          </div>

          <div style="width: 100%; padding: 5px; background: #0094ff; color: #fff; font-weight: bold;">回复列表</div>

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

              string szTabSavePath = Server.MapPath(gSystemTables.Structure.SavePath);
              if (!System.IO.Directory.Exists(szTabSavePath)) System.IO.Directory.CreateDirectory(szTabSavePath);
              string szTabJson = Pub.IO.ReadAllEncryptionText(szTabSavePath + "/UI.json");

              //加载初始化脚本
              string szTabScript = "";
              using (dyk.DB.OA.SystemEvents.ExecutionExp se = new dyk.DB.OA.SystemEvents.ExecutionExp(this.BaseConnectString)) {
                if (se.GetDataByTableIDAndName(gSystemTables.Structure.ID, "Edit_OnLoad")) {
                  szTabScript = se.Structure.DScript;
                }
              }

              using (dyk.JsonUI.Manager mgr = new dyk.JsonUI.Manager(pg, szTabJson)) {

                while (Conn.DataReader.Read()) {

                  cnt++;

                  mgr.UIInit();

                  for (int i = 0; i < Conn.DataReader.FieldCount; i++) {
                    string szName = Conn.DataReader.GetName(i);
                    string szValue = Conn.DataReader[i].ToString();
                    mgr.Cache[szName]["Content"].Value = szValue;
                  }


                  //执行数据初始化脚本
                  using (DsLibrary lib = new DsLibrary(this, this.BaseConnectString, mgr.Cache)) {
                    using (dyk.Script.Code.Program.Actuator act = new dyk.Script.Code.Program.Actuator(szTabScript, lib)) {
                      act.Execute();
                    }
                  }

                  pg.OutPut("<div style=\"border-bottom: 1px dashed #ccc;" + (cnt % 2 == 0 ? "background:#fcfcfc;" : "") + "\">");
                  pg.OutPut("<div style=\"padding-left:3px;\">#" + cnt + "</div>");
                  pg.OutPut(mgr.GetOutputHTML());
                  pg.OutPut("</div>");
                  //gszParentHTML = mgr.GetOutputHTML();
                  //cnt++;
                  //String strID = Conn.DataReader["ID"].ToString();
                  //if (cnt % 2 == 0) LineColor = "background:#eef8ff;";
                }

              }


            }
          %>
        </div>
      </div>

      <!--分页信息-->
      <%
        szClick = "Page.UI.Open('" + pg.PageArgs.UID + "','','" + pg.PageArgs.UITitle + "','" + pg.PageArgs.Path + "','Process.aspx', {Arg_Table:'" + sTable + "',Arg_Table_Date:'" + szDate + "',Arg_Table_Key:'" + szKey.Replace("\"", "\\\"").Replace("'", "\\'") + "'";
      %>
      <div style="position: absolute; top: 100%; margin-top: -30px; left: 0px; z-index: 1; height: 30px; width: 100%; box-sizing: border-box; -moz-box-sizing: border-box; -webkit-box-sizing: border-box; padding: 6px 0px 0px 6px;">
        <%if (gintPage > 1) { %>
        <div style="float: left; margin-right: 5px;" onclick="Page.Functions.Table.Load('<%=pg.PageArgs.UID%>',{Arg_Page:1});"><a href="javascript:;">[首页]</a></div>
        <%} %>
        <%if (gintPage > 1) { %>
        <div style="float: left; margin-right: 5px;" onclick="Page.Functions.Table.Load('<%=pg.PageArgs.UID%>',{Arg_Page:<%=gintPage-1%>});"><a href="javascript:;">[上一页]</a></div>
        <%} %>
        <%for (int i = gintPage - 5; i < gintPage; i++) {%>
        <%if (i > 0) { %>
        <div style="float: left; margin-right: 5px;" onclick="Page.Functions.Table.Load('<%=pg.PageArgs.UID%>',{Arg_Page:<%=i%>});"><a href="javascript:;">[<%=i%>]</a></div>
        <%} %>
        <%} %>
        <div style="float: left; margin-right: 5px; color: #0094ff;">[<%=gintPage%>]</div>
        <%for (int i = gintPage + 1; i <= gintPage + 5; i++) {%>
        <%if (i <= gnPageCount) { %>
        <div style="float: left; margin-right: 5px;" onclick="Page.Functions.Table.Load('<%=pg.PageArgs.UID%>',{Arg_Page:<%=i%>});"><a href="javascript:;">[<%=i%>]</a></div>
        <%} %>
        <%} %>
        <%if (gintPage < gnPageCount) { %>
        <div style="float: left; margin-right: 5px;" onclick="Page.Functions.Table.Load('<%=pg.PageArgs.UID%>',{Arg_Page:<%=gintPage+1%>});"><a href="javascript:;">[下一页]</a></div>
        <%} %>
        <%if (gintPage < gnPageCount) { %>
        <div style="float: left; margin-right: 5px;" onclick="Page.Functions.Table.Load('<%=pg.PageArgs.UID%>',{Arg_Page:<%=gnPageCount%>});"><a href="javascript:;">[末页]</a></div>
        <%} %>
        <div style="clear: both;"></div>
      </div>
      <%pg.Dispose();%>
    </div>
  </form>
</body>
</html>
