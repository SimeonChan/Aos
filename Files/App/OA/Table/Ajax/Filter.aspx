<%@ Page Language="C#" Inherits="ClsPage" ValidateRequest="false" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<script runat="server">
    protected int gintTable;
    //protected int gintColumn;
    protected String gstrColumn;
    protected String gstrConnString;
    protected String gstrFullPath;
    protected Ly.Formats.Json gJson;
    protected string gstrFormStyle;
    protected string gstrFormContent;
    protected string gstrFormScript;
    protected Ly.IO.Json gCache = new Ly.IO.Json();

    protected string gszSql;
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
                string sInpuntID = Pub.Request(this, "InputID");

                int nColumn = Ly.String.Source(this["Column"]).toInteger;
                pg.PageArgs["Column"].Value = nColumn.ToString();

                //gstrConnString = Pub.IO.ReadAllText(Server.MapPath("Conn.txt"));
                //gintTable = Ly.String.Source(Pub.Request(this, "Table")).toInteger;
                gintTable = Ly.String.Source(pg.PageArgs.Table).toInteger;
                //gintColumn = Ly.String.Source(Pub.Request(this, "Column")).toInteger;
                //gintDB = Ly.String.Source(Pub.Request(this, "DB")).toInteger;
                gstrColumn = Pub.Request(this, "Property");
                gstrConnString = this.ConnectString;
                Ly.DB.Dream.AzTables gTabs = new Ly.DB.Dream.AzTables(gstrConnString);
                gTabs.SystemTables.GetDataByID(gintTable);

                if (gTabs.SystemTables.Structure.InheritTable > 0) {
                    gintTable = (int)gTabs.SystemTables.Structure.InheritTable;
                    gTabs.SystemTables.GetDataByID(gintTable);
                }

                gTabs.SystemColumns.GetDatasByParentID(gintTable);
                gTabs.SystemColumns.GetDataByID(nColumn);

                Ly.Formats.XML Xml = new Ly.Formats.XML(pg.PageArgs.Arg_Table_Filters);
                Ly.Formats.Json2 Json2 = new Ly.Formats.Json2(pg.PageArgs.ToString());

                //for (int i = 0; i < gTabs.SystemColumns.StructureCollection.Count; i++) {
                //    Ly.DB.Dream.SystemColumns.Structure st = gTabs.SystemColumns.StructureCollection[i];
                //    pg.PageArgs["Table_Filters_" + st.Name].Value = pg["Table_Filters_" + st.Name];
                //}

                string szFilterName = "Table_Filters_" + gTabs.SystemColumns.Structure.Name;

                Ly.Formats.Json gJson = new Ly.Formats.Json();

            %>
            <div style="width: 100%; height: 100%;">
                <div style="float: left; width: 20%; height: 100%; background: #9dd6ff;">
                    <div style="padding: 7px 5px; background: #0094ff; font-weight: bold; color: #fff; font-size: 16px; text-align: center;">可筛选项目</div>
                    <%
                        using (Ly.Formats.XML xml = Xml.Clone()) {
                            using (Ly.DB.Dream.SystemColumns.ExecutionExp sc = new Ly.DB.Dream.SystemColumns.ExecutionExp(this.ConnectString)) {
                                sc.GetDatasByParentID(gintTable);
                                for (int i = 0; i < sc.StructureCollection.Count; i++) {
                                    Ly.DB.Dream.SystemColumns.Structure st = sc.StructureCollection[i];
                                    string szGou = "<span style=\"color:#222;\">☆</span>";
                                    if (xml[st.Name].Children.Count > 0) szGou = "<span style=\"color:#090;\">★</span>";
                                    if (st.IsFilter != 0) {
                                        if (nColumn <= 0) {
                                            nColumn = (int)st.ID;
                                            gTabs.SystemColumns.GetDataByID(nColumn);
                                        }
                                        if (st.ID == nColumn) {
                    %>
                    <div style="padding: 5px; background: #fff; font-weight: bold; color: #222; font-size: 14px;"><%=szGou%>&nbsp;<%=st.Text%></div>
                    <%
                        } else {
                            using (Ly.Formats.Json2 json = Json2.Clone()) {
                                json["Column"].Value = st.ID.ToString();
                    %>
                    <div style="padding: 5px; color: #000; cursor: pointer; font-size: 13px;" onmousemove="this.style.backgroundColor='#6cc1ff';" onmouseout="this.style.backgroundColor='';" onclick="Page.Functions.OA.Table.FilterReLoad('<%=pg.PageArgs.UID%>',<%=json.OuterJson.Replace("\"", "'")%>);"><%=szGou%>&nbsp;<%=st.Text%></div>
                    <%
                                            }
                                        }
                                    }
                                }
                            }
                        }
                    %>
                </div>
                <% 
                    if (gTabs.SystemColumns.Structure.Format != "") gJson.Object.SetChildrenByJsonString(gTabs.SystemColumns.Structure.Format);

                    gszSql = "Select [" + gTabs.SystemColumns.Structure.Name + "] From [" + gTabs.SystemTables.Structure.Name + "] group by [" + gTabs.SystemColumns.Structure.Name + "] order by [" + gTabs.SystemColumns.Structure.Name + "]";
                %>
                <div style="float: right; width: 80%; height: 100%; position: relative;">
                    <div style="position: absolute; left: 0px; top: 0px; width: 100%; height: 23px; padding-top: 5px; background: #DDDDDD; z-index: 1;">
                        <%using (Ly.Formats.Json2 json = Json2.Clone()) {%>
                        <%using (Ly.Formats.XML xml = Xml.Clone()) { %>
                        <%
                            xml[gTabs.SystemColumns.Structure.Name].Children.Clear();
                            json["Arg_Table_Filters"].Value = xml.ToString();
                        %>
                        <% string szScript = "Page.Functions.OA.Table.Load('" + pg.PageArgs.UID + "'," + json.OuterJson.Replace("\"", "'") + ");Page.Functions.OA.Table.FilterReLoad('" + pg.PageArgs.UID + "'," + json.OuterJson.Replace("\"", "'") + ");";%>
                        <div class="pub-left" style="padding: 0px 3px 0px 5px;">
                            <a href="javascript:;" onclick="<%=szScript%>">
                                <img src="<%=pg.PageArgs.Path%>images/Tool_Delete.gif" width="16" height="16" alt="" style="padding-top: 0px;" /></a>
                        </div>
                        <div class="pub-left" style="margin-right: 5px;"><a href="javascript:;" onclick="<%=szScript%>">取消全部选择</a></div>
                        <%
                                }
                            }
                        %>
                        <div style="clear: both;"></div>
                    </div>
                    <div style="position: absolute; left: 0px; top: 0px; width: 100%; height: 100%px; padding-top: 28px; box-sizing: border-box; -moz-box-sizing: border-box; -webkit-box-sizing: border-box;">
                        <div style="position: relative; overflow-x: auto; padding: 5px 5px 5px 5px; <%=gstrFormStyle%>">
                            <%
                                using (Ly.Data.SQLClient Conn = new Ly.Data.SQLClient(gstrConnString)) {
                                    try {
                                        Conn.ExecuteReader(gszSql);
                                    } catch (Exception ex) {
                                        //异常情况下输出调试信息
                                        pg.OutPutAsText("Error:" + ex.Message);
                                        pg.OutPut("<br>");
                                        pg.OutPutAsText(gszSql);
                                        pg.Dispose();
                                    }
                            %>
                            <% while (Conn.DataReader.Read()) {%>
                            <%string szValue = Conn.DataReader[0].ToString(); %>
                            <%using (Ly.Formats.Json2 json = Json2.Clone()) {%>
                            <%using (Ly.Formats.XML xml = Xml.Clone()) { %>
                            <%
                                json.InnerJson = pg.PageArgs.ToString();
                                int nIndex = -1;
                                Ly.Formats.XMLUnitPoint xup = xml[gTabs.SystemColumns.Structure.Name];
                                for (int i = 0; i < xup.Children.Count; i++) {
                                    if (xup[i].Name == "item") {
                                        if (xup[i].InnerXML == szValue) {
                                            nIndex = i;
                                            break;
                                        }
                                    }
                                }
                            %>
                            <%if (nIndex >= 0) { %>
                            <%
                                xup.Children.RemoveAt(nIndex);
                                json["Arg_Table_Filters"].Value = xml.ToString();
                                //json[szFilterName].Value = szFilter;
                                szValue = Pub.ValueFormat.getValue(this, this.ConnectString, szValue, gTabs.SystemColumns.Structure.Format, Server.MapPath(this.WebConfig.SharePath + "/" + gTabs.SystemTables.Structure.Name + "/" + gTabs.SystemColumns.Structure.Name + "_Format.azsql"));
                            %>
                            <div style="float: left; margin: 0px 5px 5px 0px;">
                                <div style="float: left; padding: 4px; border: 1px solid #009900; border-right: 0px; height: 12px; width: 145px; color: #009900; line-height: 12px; overflow: hidden; white-space: nowrap;"><%=szValue%></div>
                                <div style="float: left; padding: 4px; border: 1px solid #009900; color: #fff; background: #009900; height: 12px; cursor: pointer; line-height: 12px; width: 40px; text-align: center;" onmousemove="this.style.backgroundColor='#ff6a00';" onmouseout="this.style.backgroundColor='#009900';" onclick="Page.Functions.OA.Table.Load('<%=pg.PageArgs.UID%>', <%=json.OuterJson.Replace("\"","'")%>);Page.Functions.OA.Table.FilterReLoad('<%=pg.PageArgs.UID%>',<%=json.OuterJson.Replace("\"","'")%>);">取消</div>
                                <div style="clear: both;"></div>
                            </div>
                            <%} else { %>
                            <%
                                //if (szFilter != "") szFilter += "|";
                                //szFilter += szValue;
                                //json[szFilterName].Value = szFilter;
                                xup.AppendChild("item", szValue);
                                json["Arg_Table_Filters"].Value = xml.ToString();
                                //pg.OutPutAsText(json.InnerJson);
                                //pg.Dispose();
                                szValue = Pub.ValueFormat.getValue(this, this.ConnectString, szValue, gTabs.SystemColumns.Structure.Format, Server.MapPath(this.WebConfig.SharePath + "/" + gTabs.SystemTables.Structure.Name + "/" + gTabs.SystemColumns.Structure.Name + "_Format.azsql"));
                            %>
                            <div style="float: left; margin: 0px 5px 5px 0px;">
                                <div style="float: left; padding: 4px; border: 1px solid #CCCCCC; border-right: 0px; height: 12px; width: 145px; line-height: 12px; overflow: hidden; white-space: nowrap;"><%=szValue%></div>
                                <div style="float: left; padding: 4px; border: 1px solid #0094ff; color: #fff; background: #0094ff; height: 12px; cursor: pointer; line-height: 12px; width: 40px; text-align: center;" onmousemove="this.style.backgroundColor='#ff6a00';" onmouseout="this.style.backgroundColor='#0094ff';" onclick="Page.Functions.OA.Table.Load('<%=pg.PageArgs.UID%>',<%=json.OuterJson.Replace("\"","'")%>);Page.Functions.OA.Table.FilterReLoad('<%=pg.PageArgs.UID%>',<%=json.OuterJson.Replace("\"","'")%>);">选择</div>
                                <div style="clear: both;"></div>
                            </div>
                            <%} %>
                            <%} %>
                            <%} %>
                            <%} %>
                            <div style="clear: both;"></div>
                            <%} %>
                        </div>
                    </div>
                </div>
            </div>
            <%pg.Dispose();%>
        </div>
    </form>
</body>
</html>
