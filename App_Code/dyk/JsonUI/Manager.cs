using System;
using System.Collections.Generic;
using System.Web;

namespace dyk.JsonUI {

  /// <summary>
  /// Manager 的摘要说明
  /// </summary>
  public class Manager : IDisposable {

    private dyk.Format.Json gJson;
    private dyk.Format.Json gCache;
    private ClsAjaxPage gPage;

    //UI界面信息
    private int gnWidth;
    private int gnHeight;
    private string gszOverflow;

    public Manager(ClsAjaxPage pg, string json) {
      //
      // TODO: 在此处添加构造函数逻辑
      //

      gPage = pg;

      //建立json对象
      gJson = new Format.Json(json);
      gCache = new Format.Json();

      UIInit();
    }

    /// <summary>
    /// 获取管理数据缓存
    /// </summary>
    public dyk.Format.Json Cache { get { return gCache; } }

    /// <summary>
    /// 获取或设置高度
    /// </summary>
    public int UIHeight { get { return gnHeight; } set { gnHeight = value; } }

    /// <summary>
    /// 获取或设置宽度
    /// </summary>
    public int UIWidth { get { return gnWidth; } set { gnWidth = value; } }

    /// <summary>
    /// 获取或设置超出部分处理
    /// </summary>
    public string UIOverflow { get { return gszOverflow; } set { gszOverflow = value; } }

    /// <summary>
    /// 界面初始化
    /// </summary>
    public void UIInit() {
      gCache.InnerJson = "";
      gnWidth = 0;
      gnHeight = 0;
      gszOverflow = "";
    }



    #region [=====各控件处理代码=====]

    /// <summary>
    /// 获取线条
    /// </summary>
    /// <param name="obj"></param>
    /// <returns></returns>
    private string GetLine(dyk.Format.JsonObject obj) {
      string res = "";

      res = "<div style=\"position:absolute;";
      if (obj["Left"].Value != "") res += "left:" + Ly.String.Source(obj["Left"].Value).toInteger + "px;";
      if (obj["Top"].Value != "") res += "top:" + Ly.String.Source(obj["Top"].Value).toInteger + "px;";
      if (obj["Width"].Value != "") res += "width:" + Ly.String.Source(obj["Width"].Value).toInteger + "px;";
      if (obj["Height"].Value != "") res += "height:" + Ly.String.Source(obj["Height"].Value).toInteger + "px;";
      res += "background:" + obj["Color"].Value + ";";
      res += "\"></div>";

      return res;
    }

    /// <summary>
    /// 获取标签
    /// </summary>
    /// <param name="obj"></param>
    /// <param name="cache"></param>
    /// <param name="lm"></param>
    /// <returns></returns>
    private string GetLabel(dyk.Format.JsonObject obj) {
      string res = "";

      string szID = obj["ID"].Value;
      string szText = obj["Text"].Value;

      if (szID != "") {
        int nIDIndex = gCache.GetIndex(szID);
        if (nIDIndex >= 0) szText = gCache.Children[nIDIndex]["Content"].Value;
      }

      res = "<div style=\"position:absolute;";
      if (obj["Left"].Value != "") res += "left:" + Ly.String.Source(obj["Left"].Value).toInteger + "px;";
      if (obj["Top"].Value != "") res += "top:" + Ly.String.Source(obj["Top"].Value).toInteger + "px;";
      if (obj["Width"].Value != "") res += "width:" + Ly.String.Source(obj["Width"].Value).toInteger + "px;";
      if (obj["Height"].Value != "") res += "height:" + Ly.String.Source(obj["Height"].Value).toInteger + "px;";
      if (obj["Align"].Value != "") res += "text-align:" + obj["Align"].Value + ";";
      res += obj["Style"].Value;
      res += "\">" + szText + "</div>";

      return res;
    }

    #endregion

    /// <summary>
    /// 获取标准的HTML代码
    /// </summary>
    /// <returns></returns>
    public string GetHTML(int nTableID, bool bEditLimit) {
      string res = "";
      string szFormStyle = "";
      string szFormContent = "";
      string szFormScript = "";
      string sTemp = "";

      //定义保存交互的相关参数
      //szFormScript = "$.Dialog.Form.DataClear();";
      //szFormScript += "$.Dialog.Form.DataSet('Arg_Table','" + sTable + "');";
      //szFormScript += "$.Dialog.Form.DataSet('Arg_ViewTable','" + gintTable + "');";
      //szFormScript += "$.Dialog.Form.DataSet('Arg_Path','" + pg.PageArgs.Path + "');";
      //szFormScript += "$.Dialog.Form.DataSet('ID','" + sID + "');";
      //szFormScript += "$.Dialog.Form.DataSet('Dialog_ElementID','" + pg.PageArgs.Dialog_ElementID + "');";
      //szFormScript += "$.Dialog.Form.DataSet('Dialog_ID','" + pg.PageArgs.Dialog_ID + "');";
      //szFormScript += "$.Dialog.Form.DataSet('Process_ElementID','" + pg.PageArgs.Process_ElementID + "');";
      //szFormScript += "$.Dialog.Form.DataSet('Process_ID','" + pg.PageArgs.Process_ID + "');";
      //szFormScript += "$.Dialog.Form.DataSet('Arg_ID','" + glngID + "');";
      //szFormScript += "$.Dialog.Form.DataSet('Arg_Relation','" + glngRelation + "');";
      //szFormScript += "$.Dialog.Form.DataSet('Arg_Index','" + gintIndex + "');";
      //szFormScript += "$.Dialog.Form.DataSet('Arg_RelationText','" + pg["Arg_RelationText"] + "');";
      //szFormScript += "$.Dialog.Form.DataSet('UI','" + pg.PageArgs.UI + "');";
      //szFormScript += "$.Dialog.Form.DataSet('UI_ID','" + pg.PageArgs.UID + "');";
      //szFormScript += "$.Dialog.Form.DataSet('UI_Main','" + pg.PageArgs.UIMain + "');";
      //szFormScript += "$.Dialog.Form.DataSet('UI_Title','" + pg.PageArgs.UITitle + "');";
      //szFormScript += "$.Dialog.Form.DataSet('UI_Tool','" + pg.PageArgs.UITool + "');";
      ///if (lngID > 0) gstrFormScript += "$.Dialog.Form.DataSet('Key_ID','" + lngID + "');";

      for (int i = 0; i < gJson.Children.Count; i++) {
        dyk.Format.JsonObject obj = (dyk.Format.JsonObject)gJson.Children[i];
        switch (obj.Name.ToLower()) {
          case "form"://窗口相关设定
            #region [=====窗口相关设定处理=====]
            for (int j = 0; j < obj.Count; j++) {
              switch (obj[j].Name) {
                case "Width":
                  //gstrFormStyle += "width:" + Ly.String.Source(obj[j].Value).toInteger + "px;";
                  gnWidth = (int)dyk.Type.String.New(obj[j].Value).ToNumber;
                  break;
                case "Height":
                  //gstrFormStyle += "height:" + (Ly.String.Source(obj[j].Value).toInteger - 30) + "px;";
                  gnHeight = (int)dyk.Type.String.New(obj[j].Value).ToNumber;
                  break;
                case "Overflow":
                  //gstrFormStyle += "overflow:" + obj[j].Value + ";";
                  gszOverflow = obj[j].Value;
                  break;
              }
            }
            break;
            #endregion
          case "label"://标签内容
            #region [=====标签相关设定处理=====]
            //gstrFormContent += sTemp;
            szFormContent += GetLabel(obj);
            break;
            #endregion
          case "line":
            #region [=====线条处理=====]
            szFormContent += GetLine(obj);
            break;
            #endregion
          case "textbox"://输入框内容
            #region [=====输入框相关设定处理=====]

            string txtName = obj["Name"].Value;
            string txtValue = "";
            string txtID = "";
            string szType = obj["Type"].Value.ToLower();
            //bool bEditLimit = true;
            string szID = obj["ID"].Value;
            //if (nView == 1) bEditLimit = false;

            #region [=====值初始处理=====]

            //if (txtName == gstrRelationColumn) txtValue = gstrRelation;
            //Ly.Formats.JsonUnitPoint jup = gCache.Object.FindChild(szID);
            dyk.Format.JsonObject jup = gCache.FindChild(szID);
            if (jup != null) {
              obj.Coalition(jup);
            }

            txtValue = obj["Content"].Value;

            #endregion

            txtID = gPage.XPortArgs.Dialog_ElementID + "_" + obj["ID"].Value;

            #region [=====存储表单缓存=====]
            if (txtName != "") {
              //    //存储原始表单内容
              szFormScript += "$.Dialog.Form.DataSetByValue('" + txtName + "','" + txtID + "');";
              //    gTabs.SystemColumns.GetDataByParentIDAndName(gintTable, txtName);
              //if (gTabs.SystemColumns.Structure.Type == "int") {
              //  gCache[txtName].Value = Ly.String.Source(txtValue).toInteger.ToString();
              //} else if (gTabs.SystemColumns.Structure.Type.StartsWith("numeric")) {
              //  gCache[txtName].Value = Ly.String.Source(txtValue).toDouble.ToString();
              //} else {
              //gCache[txtName]["Content"].Value = txtValue;
              //}
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
            sTemp += " onfocus=\"$('#" + gPage.XPortArgs.Dialog_ElementID + "_Info').html('<font color=#000099>提示:" + obj["InputTip"].Value + "</font>');\"";


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

              ////读取SQL脚本内容
              ////string szSql = Pub.IO.ReadAllText(Server.MapPath(this.WebConfig.SharePath + "/" + gSystemTables.Structure.Name + "/" + obj["ID"].Value + "_OnLeave.azsql"));
              //string szSql = Pub.IO.ReadAllText(Server.MapPath(gSystemTables.Structure.SavePath + "/" + obj["ID"].Value + "_OnLeave.azsql"));
              //using (AzSqlProgram Asm = new AzSqlProgram(this, gstrConnString, null)) {
              //  try {
              //    szSql = Asm.ExecuteString(szSql);
              //  } catch (Exception ex) {
              //    pg.OutPut("脚本执行发生异常:" + ex.Message + "<br><br>");
              //    pg.OutPut(Asm.Program.Debug().Replace("\r\n", "<br>").Replace("\n", "<br>").Replace(" ", "&nbsp;"));
              //  } finally {
              //    //pg.OutPut(Asm.Program.Debug().Replace("\r\n", "<br>").Replace("\n", "<br>").Replace(" ", "&nbsp;"));
              //  }
              //  //pg.OutPutAsText(Asm.Test(gszSql));
              //  //pg.Dispose();
              //}
              //sTemp += " onblur=\"" + szSql.Replace("\r\n", "").Replace("\n", "") + "\"";
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
                  sClick += "Form_" + gCache[c].Name + ":$('#" + gPage.XPortArgs.Dialog_ElementID + "_" + gCache[c].Name + "').val()";
                }

                sTemp += "<div style=\"float:left;padding:0px 5px;height:22px;line-height:22px;border:1px solid #222;cursor:pointer;\" onclick=\"Page.Functions.Table.Dialog('" + txtID + "_Select','" + gPage.XPortArgs.UI_ID + "', '选择一条内容', 640, 480, '" + gPage.XPortArgs.UI_Path + "','Select.aspx', {Arg_Select_InputID: '" + gPage.XPortArgs.Dialog_ElementID + "',Arg_Select_ID:'" + obj["ID"].Value + "',Arg_Select_Table:" + nTableID + sClick + " });\">";
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
                sTemp += "<input id=\"" + txtID + "_Select\" type=\"button\" value=\"选择\" style=\"padding-top: 2px; width: 60px; height: 22px\" onclick=\"$.Dialog.ShowFromUrl('" + txtID + "_Select', '选择一条内容', 640, 480, '" + gPage.XPortArgs.Arg_Path + "Ajax/Select.aspx', {Path: '/Files/App/System/Select/', InputID: '" + gPage.XPortArgs.Dialog_ElementID + "',Arg_ID:'" + obj["ID"].Value + "',Arg_Table:" + nTableID + " });\" />";
                sTemp += "</div>";

                //读取SQL脚本内容
                //string szSql = Pub.IO.ReadAllText(Server.MapPath(gSystemTables.Structure.SavePath + "/" + obj["ID"].Value + "_JsAdd.azsql"));
                //using (AzSqlProgram Asm = new AzSqlProgram(this, gstrConnString, null)) {
                //  try {
                //    szSql = Asm.ExecuteString(szSql);
                //  } catch (Exception ex) {
                //    pg.OutPut("脚本执行发生异常:" + ex.Message + "<br><br>");
                //    pg.OutPut(Asm.Program.Debug().Replace("\r\n", "<br>").Replace("\n", "<br>").Replace(" ", "&nbsp;"));
                //  } finally {
                //    //pg.OutPut(szSql);
                //    //pg.OutPut("<br>");
                //    //pg.OutPut(Asm.Program.Debug().Replace("\r\n", "<br>").Replace("\n", "<br>").Replace(" ", "&nbsp;"));
                //  }
                //  //pg.OutPutAsText(Asm.Test(gszSql));
                //  //pg.Dispose();
                //}

                //sTemp += "<div style=\"float:left;padding-left:5px;\">";
                //sTemp += "<input id=\"" + txtID + "_Add\" type=\"button\" value=\"添加\" style=\"padding-top: 2px; width: 60px; height: 22px\" onclick=\"" + szSql.Replace("\r\n", "").Replace("\n", "") + "\" />";
                //sTemp += "</div>";
              }

            }

            sTemp += "<div style=\"clear:both;\"></div>";

            sTemp += "</div>";
            //if sTemp += " value=\"" + obj.Items["Text"].Value + "\"";
            //gstrFormContent += sTemp;
            szFormContent += sTemp;
            break;
            #endregion
        }
      }
      //gstrFormScript += "$.Dialog.Form.Submit('" + pg.PageArgs.UID + "','" + pg.PageArgs.UIPath + "AddSave.aspx');";
      szFormScript += "$.Dialog.Form.Submit('" + gPage.XPortArgs.UI_ID + "','" + gPage.XPortArgs.UI_Path + "AddSave.aspx');";

      //      <div style="position: relative; <%=gstrFormStyle%>">
      //    <%=gstrFormContent%>
      //</div>
      res = "<div style=\"position: relative; width:" + gnWidth + "px; height:" + gnHeight + "px;" + (gszOverflow != "" ? " Overflow:" + gszOverflow : "") + "\">";
      res += szFormContent;
      res += "</div>";

      return res;
    }

    /// <summary>
    /// 获取纯输出的HTML代码
    /// </summary>
    /// <returns></returns>
    public string GetOutputHTML() {
      string res = "";
      //string szFormStyle = "";
      string szFormContent = "";
      string szFormScript = "";
      string sTemp = "";

      for (int i = 0; i < gJson.Children.Count; i++) {
        dyk.Format.JsonObject obj = (dyk.Format.JsonObject)gJson.Children[i];
        switch (obj.Name.ToLower()) {
          case "form"://窗口相关设定
            #region [=====窗口相关设定处理=====]
            for (int j = 0; j < obj.Count; j++) {
              switch (obj[j].Name) {
                case "Width":
                  //gstrFormStyle += "width:" + Ly.String.Source(obj[j].Value).toInteger + "px;";
                  gnWidth = (int)dyk.Type.String.New(obj[j].Value).ToNumber;
                  break;
                case "Height":
                  //gstrFormStyle += "height:" + (Ly.String.Source(obj[j].Value).toInteger - 30) + "px;";
                  gnHeight = (int)dyk.Type.String.New(obj[j].Value).ToNumber;
                  break;
                case "Overflow":
                  //gstrFormStyle += "overflow:" + obj[j].Value + ";";
                  gszOverflow = obj[j].Value;
                  break;
              }
            }
            break;
            #endregion
          case "label"://标签内容
            #region [=====标签相关设定处理=====]
            //gstrFormContent += sTemp;
            szFormContent += GetLabel(obj);
            break;
            #endregion
          case "line":
            #region [=====线条处理=====]
            szFormContent += GetLine(obj);
            break;
            #endregion
          case "textbox"://输入框内容
            #region [=====输入框相关设定处理=====]

            string txtName = obj["Name"].Value;
            string txtValue = "";
            string txtID = "";
            string szType = obj["Type"].Value.ToLower();
            //bool bEditLimit = true;
            string szID = obj["ID"].Value;
            //if (nView == 1) bEditLimit = false;

            if (szType == "hidden") break;

            #region [=====值初始处理=====]

            //if (txtName == gstrRelationColumn) txtValue = gstrRelation;
            //Ly.Formats.JsonUnitPoint jup = gCache.Object.FindChild(szID);
            dyk.Format.JsonObject jup = gCache.FindChild(szID);
            if (jup != null) {
              obj.Coalition(jup);
            }

            txtValue = obj["Content"].Value;

            #endregion

            txtID = gPage.XPortArgs.Dialog_ElementID + "_" + obj["ID"].Value;

            #region [=====存储表单缓存=====]
            if (txtName != "") {
              //    //存储原始表单内容
              szFormScript += "$.Dialog.Form.DataSetByValue('" + txtName + "','" + txtID + "');";
              //    gTabs.SystemColumns.GetDataByParentIDAndName(gintTable, txtName);
              //if (gTabs.SystemColumns.Structure.Type == "int") {
              //  gCache[txtName].Value = Ly.String.Source(txtValue).toInteger.ToString();
              //} else if (gTabs.SystemColumns.Structure.Type.StartsWith("numeric")) {
              //  gCache[txtName].Value = Ly.String.Source(txtValue).toDouble.ToString();
              //} else {
              //gCache[txtName]["Content"].Value = txtValue;
              //}
            }
            #endregion

            if (obj["Format"].Value != "") {

            }

            sTemp = "<div style=\"position:absolute; border:1px solid #222; padding:0px 3px;";
            if (szType == "") szType = "text";
            if (obj["Left"].Value != "") sTemp += "left:" + Ly.String.Source(obj["Left"].Value).toInteger + "px;";
            if (obj["Top"].Value != "") sTemp += "top:" + Ly.String.Source(obj["Top"].Value).toInteger + "px;";
            sTemp += "\">";

            sTemp += "<div style=\"float:left;\">";

            sTemp += "<div";

            //switch (szType.Trim().ToLower()) {
            //  case "textarea":
            //    sTemp += "<textarea cols=\"20\" rows=\"2\"";
            //    sTemp += " id=\"" + txtID + "\"";
            //    break;
            //  case "html":
            //    sTemp += "<div";
            //    break;
            //  default:
            //    sTemp += "<input";
            //    sTemp += " id=\"" + txtID + "\"";
            //    break;
            //}
            //sTemp += "<" + (szType != "textarea" ? "input" : "textarea cols=\"20\" rows=\"2\"");
            //sTemp += " name=\"" + txtName + "\"";
            //sTemp += " onfocus=\"$('#" + gPage.XPortArgs.Dialog_ElementID + "_Info').html('<font color=#000099>提示:" + obj["InputTip"].Value + "</font>');\"";


            //非textarea模式时值在Value属性中
            //if (szType != "textarea") sTemp += " value=\"" + txtValue.Replace("\"", "&quot;") + "\"";

            //if (!bEditLimit) {
            //  sTemp += " readonly=\"readonly\"";
            //} else {
            //  //文件、日期选择器时，比为只读
            //  if (obj["ReadOnly"].Value.Trim().ToLower() == "true" || szType == "file" || szType == "date") sTemp += " readonly=\"readonly\"";
            //}

            sTemp += " style=\"";
            sTemp += obj["Style"].Value;
            sTemp += "width:" + (obj["Width"].Value == "" ? "100" : obj["Width"].Value) + "px;";
            if (obj["Height"].Value != "") sTemp += "height:" + Ly.String.Source(obj["Height"].Value).toInteger + "px;";
            if (obj["LineHeight"].Value != "") sTemp += "line-height:" + Ly.String.Source(obj["LineHeight"].Value).toInteger + "px;";
            if (szType != "textarea") sTemp += " overflow-y:auto";

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

              ////读取SQL脚本内容
              ////string szSql = Pub.IO.ReadAllText(Server.MapPath(this.WebConfig.SharePath + "/" + gSystemTables.Structure.Name + "/" + obj["ID"].Value + "_OnLeave.azsql"));
              //string szSql = Pub.IO.ReadAllText(Server.MapPath(gSystemTables.Structure.SavePath + "/" + obj["ID"].Value + "_OnLeave.azsql"));
              //using (AzSqlProgram Asm = new AzSqlProgram(this, gstrConnString, null)) {
              //  try {
              //    szSql = Asm.ExecuteString(szSql);
              //  } catch (Exception ex) {
              //    pg.OutPut("脚本执行发生异常:" + ex.Message + "<br><br>");
              //    pg.OutPut(Asm.Program.Debug().Replace("\r\n", "<br>").Replace("\n", "<br>").Replace(" ", "&nbsp;"));
              //  } finally {
              //    //pg.OutPut(Asm.Program.Debug().Replace("\r\n", "<br>").Replace("\n", "<br>").Replace(" ", "&nbsp;"));
              //  }
              //  //pg.OutPutAsText(Asm.Test(gszSql));
              //  //pg.Dispose();
              //}
              //sTemp += " onblur=\"" + szSql.Replace("\r\n", "").Replace("\n", "") + "\"";
            }

            sTemp += ">" + txtValue + "</div>";

            //switch (szType) {
            //  case "textarea":
            //    sTemp += ">" + txtValue + "</textarea>";
            //    break;
            //  case "html":
            //    sTemp += ">";
            //    sTemp += "<div style=\"position: relative; width: 100%; height: 100%;\">";
            //    sTemp += "<div style=\"position: absolute; left: 0px; top: 0px; padding-top: 30px; width:100%; height:100%; overflow:hidden; box-sizing: border-box; -moz-box-sizing: border-box; -webkit-box-sizing: border-box;\">";
            //    sTemp += "<textarea id=\"" + txtID + "\" cols=\"20\" rows=\"2\" readonly=\"readonly\" style=\"width:100%; height:100%; border:0px;\">" + txtValue + "</textarea>";
            //    sTemp += "</div>";
            //    sTemp += "<div style=\"position: absolute; left: 0px; top: 0px; width: 100%; height: 30px; padding: 5px; background:#ccc; box-sizing: border-box; -moz-box-sizing: border-box; -webkit-box-sizing: border-box;\"><a href=\"javascript:;\" onclick=\"Page.ShowUEditor('" + txtID + "');\">点击使用HTML编辑器编辑</a></div>";
            //    sTemp += "</div>";
            //    sTemp += "</div>";
            //    break;
            //  case "file":
            //  case "date":
            //    sTemp += " type=\"text\" />";
            //    break;
            //  default:
            //    sTemp += " type=\"" + szType + "\" />";
            //    break;
            //}


            sTemp += "</div>";

            //if (bEditLimit) {

            //  //上传文件
            //  if (szType == "file") {
            //    sTemp += "<div style=\"float:left;padding:0px 5px;height:22px;line-height:22px;border:1px solid #222;cursor:pointer;\" onclick=\"Page.ShowUpload('" + txtID + "');\">";
            //    sTemp += "...";
            //    sTemp += "</div>";
            //    //sTemp += "<div style=\"float:left;padding-left:5px;\">";
            //    //sTemp += "<input id=\"" + txtID + "_Upload\" type=\"button\" value=\"选择\" style=\"padding-top: 2px; width: 60px; height: 22px\" onclick=\"Page.ShowUpload('" + txtID + "');\" />";
            //    //sTemp += "</div>";
            //  }

            //  //内容选择器
            //  if (obj["Value"]["Type"].Value == "Select") {

            //    string sClick = "";
            //    for (int c = 0; c < gCache.Count; c++) {
            //      sClick += ",";
            //      sClick += "Form_" + gCache[c].Name + ":$('#" + gPage.XPortArgs.Dialog_ElementID + "_" + gCache[c].Name + "').val()";
            //    }

            //    sTemp += "<div style=\"float:left;padding:0px 5px;height:22px;line-height:22px;border:1px solid #222;cursor:pointer;\" onclick=\"Page.Functions.Table.Dialog('" + txtID + "_Select','" + gPage.XPortArgs.UI_ID + "', '选择一条内容', 640, 480, '" + gPage.XPortArgs.UI_Path + "','Select.aspx', {Arg_Select_InputID: '" + gPage.XPortArgs.Dialog_ElementID + "',Arg_Select_ID:'" + obj["ID"].Value + "',Arg_Select_Table:" + nTableID + sClick + " });\">";
            //    sTemp += "...";
            //    sTemp += "</div>";

            //    //sTemp += "<div style=\"float:left;padding-left:5px;\">";
            //    //sTemp += "<input id=\"" + txtID + "_Select\" type=\"button\" value=\"选择\" style=\"padding-top: 2px; width: 60px; height: 22px\" onclick=\"Page.Functions.Table.Dialog('" + txtID + "_Select','" + pg.PageArgs.UID + "', '选择一条内容', 640, 480, '" + pg.PageArgs.UIPath + "','Select.aspx', {Arg_Select_InputID: '" + pg.PageArgs.Dialog_ElementID + "',Arg_Select_ID:'" + obj["ID"].Value + "',Arg_Select_Table:" + gintTable + sClick + " });\" />";
            //    //sTemp += "</div>";
            //  }

            //  //日期选择器
            //  if (szType == "date" && obj["ReadOnly"].Value != "True") {
            //    sTemp += "<div style=\"float:left;padding:0px 5px;height:22px;line-height:22px;border:1px solid #222;cursor:pointer;\" onclick=\"DatePicker.Move((document.documentElement.clientWidth - 434) / 2, 209);DatePicker.DayPicker('" + txtID + "','" + txtValue + "');\">";
            //    sTemp += "...";
            //    sTemp += "</div>";
            //  }

            //  //内容选择器
            //  if (obj["Value"]["Type"].Value == "SelectAndInsert") {
            //    sTemp += "<div style=\"float:left;padding-left:5px;\">";
            //    sTemp += "<input id=\"" + txtID + "_Select\" type=\"button\" value=\"选择\" style=\"padding-top: 2px; width: 60px; height: 22px\" onclick=\"$.Dialog.ShowFromUrl('" + txtID + "_Select', '选择一条内容', 640, 480, '" + gPage.XPortArgs.Arg_Path + "Ajax/Select.aspx', {Path: '/Files/App/System/Select/', InputID: '" + gPage.XPortArgs.Dialog_ElementID + "',Arg_ID:'" + obj["ID"].Value + "',Arg_Table:" + nTableID + " });\" />";
            //    sTemp += "</div>";

            //    //读取SQL脚本内容
            //    //string szSql = Pub.IO.ReadAllText(Server.MapPath(gSystemTables.Structure.SavePath + "/" + obj["ID"].Value + "_JsAdd.azsql"));
            //    //using (AzSqlProgram Asm = new AzSqlProgram(this, gstrConnString, null)) {
            //    //  try {
            //    //    szSql = Asm.ExecuteString(szSql);
            //    //  } catch (Exception ex) {
            //    //    pg.OutPut("脚本执行发生异常:" + ex.Message + "<br><br>");
            //    //    pg.OutPut(Asm.Program.Debug().Replace("\r\n", "<br>").Replace("\n", "<br>").Replace(" ", "&nbsp;"));
            //    //  } finally {
            //    //    //pg.OutPut(szSql);
            //    //    //pg.OutPut("<br>");
            //    //    //pg.OutPut(Asm.Program.Debug().Replace("\r\n", "<br>").Replace("\n", "<br>").Replace(" ", "&nbsp;"));
            //    //  }
            //    //  //pg.OutPutAsText(Asm.Test(gszSql));
            //    //  //pg.Dispose();
            //    //}

            //    //sTemp += "<div style=\"float:left;padding-left:5px;\">";
            //    //sTemp += "<input id=\"" + txtID + "_Add\" type=\"button\" value=\"添加\" style=\"padding-top: 2px; width: 60px; height: 22px\" onclick=\"" + szSql.Replace("\r\n", "").Replace("\n", "") + "\" />";
            //    //sTemp += "</div>";
            //  }

            //}

            sTemp += "<div style=\"clear:both;\"></div>";

            sTemp += "</div>";
            //if sTemp += " value=\"" + obj.Items["Text"].Value + "\"";
            //gstrFormContent += sTemp;
            szFormContent += sTemp;
            break;
            #endregion
        }
      }
      //gstrFormScript += "$.Dialog.Form.Submit('" + pg.PageArgs.UID + "','" + pg.PageArgs.UIPath + "AddSave.aspx');";
      //szFormScript += "$.Dialog.Form.Submit('" + gPage.XPortArgs.UI_ID + "','" + gPage.XPortArgs.UI_Path + "AddSave.aspx');";

      //      <div style="position: relative; <%=gstrFormStyle%>">
      //    <%=gstrFormContent%>
      //</div>
      res = "<div style=\"position: relative; width:" + gnWidth + "px; height:" + gnHeight + "px;" + (gszOverflow != "" ? " overflow:" + gszOverflow : "") + "\">";
      res += szFormContent;
      res += "</div>";

      return res;
    }

    public void Dispose() {
      //throw new NotImplementedException();
      if (gJson != null) gJson.Dispose();
    }
  }

}