<%@ Page Language="C#" AutoEventWireup="true" CodeFile="SystemTable.aspx.cs" Inherits="Files_App_UIDesigner_SystemTable" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
    <title>设计器 - [<%=gszTable%>]</title>
    <link href="/css/Page.css" rel="stylesheet" />
    <link href="Css.css" rel="stylesheet" />
</head>
<body>
    <script language="javascript" type="text/javascript" src="/js/jq/jquery-1.11.3.js"></script>
    <script language="javascript" type="text/javascript" src="/js/XKits/1.03.1512.js"></script>
    <script language="javascript" type="text/javascript" src="js/Default.js"></script>
    <div class="FullArea">
        <div class="Head"><%=gszProName%>&nbsp;V<%=gszVersion%>&nbsp;-&nbsp;[<%=gszTable%>&nbsp;:&nbsp;<%=gszUIPath%>]</div>
        <div class="Work">
            <div class="FullArea">
                <div class="Work-Left">
                    <div class="FullArea">
                        <div class="Work-List">
                            <div class="FullArea">
                                <div class="Work-Title">表结构</div>
                                <div class="Work-Main">
                                    <div class="FullArea">
                                        <div style="overflow: auto; width: 100%; height: 100%; position: absolute; left: 0px; top: 0px;">
                                            <ul id="ColsPan">
                                                <%
                                                    if (gSystemTables.Structure.ID > 0) {
                                                        for (int i = 0; i < gSystemColumns.StructureCollection.Count; i++) {
                                                            string szName = gSystemColumns.StructureCollection[i].Name;
                                                %>
                                                <li id="Col_Name_<%=szName%>"><%=gSystemColumns.StructureCollection[i].Text%>[<%=gSystemColumns.StructureCollection[i].Name%>]<span id="Col_Name_<%=szName%>_Span"></span></li>
                                                <%
                                                        }
                                                    } else {
                                                        using (Ly.Data.SQLClient Conn = new Ly.Data.SQLClient(gszConnString)) {
                                                            Conn.ExecuteReader("Select * From [" + gszTable + "]");
                                                            for (int i = 0; i < Conn.DataReader.FieldCount; i++) {
                                                                string szName = Conn.DataReader.GetName(i);
                                                                if (szName != "ID") {
                                                %>
                                                <li id="Col_Name_<%=szName%>"><%=szName%></li>
                                                <%
                                                                }
                                                            }
                                                        }
                                                    }
                                                %>
                                            </ul>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                        <div class="Work-Properties">
                            <div class="FullArea">
                                <div class="Work-Title">属性 - [<span id="UIProTitle"></span>]</div>
                                <div class="Work-Main">
                                    <div class="FullArea">
                                        <div style="overflow: auto; width: 100%; height: 100%; position: absolute; left: 0px; top: 0px;" id="UIProperty"></div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
                <div class="Work-Right">
                    <div class="FullArea">
                        <div class="Work-Title">设计板</div>
                        <div class="Work-Main">
                            <div class="FullArea">
                                <div class="Work-Tool">
                                    <div>
                                        <div class="pub-left" style="padding: 2px 3px 0px 0px;">
                                            <a href="javascript:;" onclick="Page.OneKey();">
                                                <img alt="" src="Image/OneKey.gif" /></a>
                                        </div>
                                        <div class="pub-left">
                                            <a href="javascript:;" onclick="Page.OneKey();">一键界面生成</a>
                                        </div>
                                        <div class="pub-left" style="padding: 2px 3px 0px 15px;">
                                            <a href="javascript:;" onclick="Page.Save();">
                                                <img alt="" src="Image/Save.gif" /></a>
                                        </div>
                                        <div class="pub-left">
                                            <a href="javascript:;" onclick="Page.Save();">保存</a>
                                        </div>
                                        <div class="pub-clear"></div>
                                    </div>
                                    <div style="padding-top: 10px;">
                                        <div class="pub-left" style="padding: 2px 3px 0px 0px;">
                                            <a href="javascript:;" onclick="Page.AddLable();">
                                                <img alt="" src="Image/Label.gif" /></a>
                                        </div>
                                        <div class="pub-left">
                                            <a href="javascript:;" onclick="Page.AddLable();">添加标签</a>
                                        </div>
                                        <div class="pub-left" style="padding: 2px 3px 0px 15px;">
                                            <a href="javascript:;" onclick="Page.AddTextBox();">
                                                <img alt="" src="Image/TextBox.gif" /></a>
                                        </div>
                                        <div class="pub-left">
                                            <a href="javascript:;" onclick="Page.AddTextBox();">添加文本框</a>
                                        </div>
                                        <div class="pub-left" style="padding: 2px 3px 0px 15px;">
                                            <a href="javascript:;" onclick="Page.AddLine();">
                                                <img alt="" src="Image/Line.gif" /></a>
                                        </div>
                                        <div class="pub-left">
                                            <a href="javascript:;" onclick="Page.AddLine();">添加线条</a>
                                        </div>
                                        <div class="pub-clear"></div>
                                    </div>
                                </div>
                                <div class="Work-Window">
                                    <div class="FullArea">
                                        <div style="overflow: auto; height: 100%; width: 100%; position: absolute; left: 0px; top: 0px;" id="UIMain">
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
    <script language="javascript" type="text/javascript">
        <%
        for (int i = 0; i < gJsonUI.Object.Count; i++) {
            if (gJsonUI.Object[i].Count <= 0) {
                gJsonUI.Object[i]["Value"].Value = gJsonUI.Object[i].Value;
                gJsonUI.Object[i].Value = "";
            }
            gJsonUI.Object[i]["ObjectType"].Value = gJsonUI.Object[i].Name;
            gJsonUI.Object[i]["PaddingTop"].Value = "0";
            gJsonUI.Object[i]["PaddingRight"].Value = "0";
            gJsonUI.Object[i]["PaddingBottom"].Value = "0";
            gJsonUI.Object[i]["PaddingLeft"].Value = "0";
            if (gJsonUI.Object[i]["Padding"].Value != "") {
                string sTemp = gJsonUI.Object[i]["Padding"].Value;
                string[] sPad = sTemp.Split(',');
                if (sPad.Length == 1) {
                    gJsonUI.Object[i]["PaddingTop"].Value = Ly.String.Source(sTemp).toInteger.ToString();
                    gJsonUI.Object[i]["PaddingRight"].Value = Ly.String.Source(sTemp).toInteger.ToString();
                    gJsonUI.Object[i]["PaddingBottom"].Value = Ly.String.Source(sTemp).toInteger.ToString();
                    gJsonUI.Object[i]["PaddingLeft"].Value = Ly.String.Source(sTemp).toInteger.ToString();
                }
                if (sPad.Length == 4) {
                    gJsonUI.Object[i]["PaddingTop"].Value = Ly.String.Source(sPad[0]).toInteger.ToString();
                    gJsonUI.Object[i]["PaddingRight"].Value = Ly.String.Source(sPad[1]).toInteger.ToString();
                    gJsonUI.Object[i]["PaddingBottom"].Value = Ly.String.Source(sPad[2]).toInteger.ToString();
                    gJsonUI.Object[i]["PaddingLeft"].Value = Ly.String.Source(sPad[3]).toInteger.ToString();
                }
            }
            %>
        Page.InitJsonString[<%=i%>] = "<%=gJsonUI.Object[i].ToJsonString().Replace("\"", "\\\"")%>";
        <%
        }
        %>
        Page.ObjCount = <%=gJsonUI.Object.Count%>;
        Page.TableName = "<%=gszTable%>";
        Page.TableID = <%=gSystemTables.Structure.ID%>;
    </script>
</body>
</html>
