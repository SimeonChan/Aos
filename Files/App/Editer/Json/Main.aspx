<%@ Page Language="C#" Inherits="ClsPage" %>

<!DOCTYPE html>

<script runat="server">
    protected String gstrConnString;
    protected long gintTable;
    protected long glngRelation;
    protected long glngID;
    protected int gintIndex;
    protected string gstrArgs;

    protected Ly.DB.Dream.AzTables gTab;
    protected String gstrFullPath;
    protected Ly.IO.Json gJson;
    protected int gintWidth;
    protected int gintHeight;
    protected int gintLines;
    protected int gintPage;
    protected string gstrSQL;
    protected Ly.IO.Json gAddJson;
    protected string gstrRelation;

    protected string GetPathHTML(ClsAjaxPage pg, Ly.Formats.JsonObject Obj, string[] szObjs, int index, string szObj) {
        string res = "";
        if (index >= szObjs.Length) return res;

        string szObjsTrim = szObjs[index].Trim();
        if (szObjsTrim == "") return res;

        int nIndex = Ly.String.Source(szObjsTrim).toInteger;

        Ly.Formats.JsonObject jup = Obj[nIndex];
        res = "&nbsp;▶&nbsp;{" + nIndex + "}" + jup.Name;
        index++;
        res += GetPathHTML(pg, jup, szObjs, index, szObj);
        return res;
    }

    protected string GetTreeHTML(ClsAjaxPage pg, Ly.Formats.JsonObject Obj, string[] szObjs, int index, string szObj) {
        string res = "";

        ///生成空格
        string szSpace = "";
        for (int i = 0; i <= index; i++) {
            szSpace += "︱";
        }

        int nIndex = -1;
        if (index < szObjs.Length) {
            if (szObjs[index] != "") {
                nIndex = Ly.String.Source(szObjs[index]).toInteger;
            }
        }

        string szObjNew = szObj;
        if (szObjNew != "") szObjNew += "|";

        string szPath = pg["Arg_Path"];

        if (Obj.Count > 0) {
            for (int i = 0; i < Obj.Count; i++) {
                Ly.Formats.JsonObject jup = Obj[i];
                if (nIndex == i) {
                    string szClick = "Page.UI.Open('" + pg.PageArgs.UID + "','','Json编辑器','" + pg.PageArgs.UIPath + "','Process.aspx', {Arg_Path:'" + szPath + "',Arg_ObjectPath:'" + szObj + "'});";
                    res += "<div>" + szSpace + "▼&nbsp;<a href=\"javascript:;\" onclick=\"" + szClick + "\">{" + i + "}" + jup.Name + "</a></div>";
                    index++;
                    res += GetTreeHTML(pg, jup, szObjs, index, szObjNew + i);
                } else {
                    string szClick = "Page.UI.Open('" + pg.PageArgs.UID + "','','Json编辑器','" + pg.PageArgs.UIPath + "','Process.aspx', {Arg_Path:'" + szPath + "',Arg_ObjectPath:'" + (szObjNew + i) + "'});";
                    res += "<div>" + szSpace + "▶&nbsp;<a href=\"javascript:;\" onclick=\"" + szClick + "\">{" + i + "}" + jup.Name + "</a></div>";
                }
            }
        } else {
            res = "<div>" + szSpace + "(无子对象)</div>";
        }


        return res;
    }

    protected string GetValue(ClsAjaxPage pg, Ly.Formats.JsonObject Obj, string[] szObjs, int index, string szObj) {

        if (index >= szObjs.Length) return "";

        string szObjsTrim = szObjs[index].Trim();
        if (szObjsTrim == "") return Obj.InnerJsonToStandardString();

        int nIndex = Ly.String.Source(szObjsTrim).toInteger;
        Ly.Formats.JsonObject jup = Obj[nIndex];

        if (index == szObjs.Length - 1) {
            return jup.InnerJsonToStandardString();
        } else {
            index++;
            return GetValue(pg, jup, szObjs, index, "");
        }

    }

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
                string szPath = pg["Arg_Path"];
                string szObj = pg["Arg_ObjectPath"];
                string[] szObjs = szObj.Split('|');

                if (szPath.StartsWith("/") || szPath.IndexOf("..") >= 0) {
                    pg.OutPut("不是合法的路径!");
                    pg.Dispose();
                }
                //szPath = "";
                //if (szPath != "" && !szPath.EndsWith("/")) szPath += "/";
                string szFullPath = "/" + szPath;
            %>
            <div style="position: absolute; left: 0px; top: 0px; padding: 5px; width: 100%; height: 30px; z-index: 2; border-bottom: 1px solid #333; box-sizing: border-box; -moz-box-sizing: border-box; -webkit-box-sizing: border-box;">文件路径：我的云存储&nbsp;▶&nbsp;<%=szPath.Replace("/","&nbsp;▶&nbsp;")%></div>
            <div style="position: absolute; left: 0px; top: 0px; width: 220px; height: 100%; padding-top: 30px; box-sizing: border-box; -moz-box-sizing: border-box; -webkit-box-sizing: border-box; z-index: 1; overflow: hidden;">
                <div style="width: 100%; height: 100%; padding: 5px; box-sizing: border-box; -moz-box-sizing: border-box; -webkit-box-sizing: border-box; overflow: auto; border-right: 1px solid #333;">
                    <%
                        string szClick = "Page.UI.Open('" + pg.PageArgs.UID + "','','Json编辑器','" + pg.PageArgs.UIPath + "','Process.aspx', {Arg_Path:'" + szPath + "',Arg_ObjectPath:''});";
                    %>
                    <div>▼&nbsp;<a href="javascript:;" onclick="<%=szClick%>">根对象</a></div>
                    <%

                        string szJson = Pub.IO.ReadAllEncryptionText(Server.MapPath(szFullPath));
                        string szObjectPath = "";
                        string szObjectValue = "";

                        //设置Json内容
                        try {
                            using (Ly.Formats.JsonObject json = new Ly.Formats.JsonObject()) {
                                json.InnerJson = szJson;
                                pg.OutPut(GetTreeHTML(pg, json, szObjs, 0, ""));
                                szObjectPath = GetPathHTML(pg, json, szObjs, 0, "");
                                szObjectValue = GetValue(pg, json, szObjs, 0, "");
                            }
                        } catch {
                            pg.OutPut("<div>加载发生异常</div>");
                            szObjectValue = szJson;
                        }

                    %>
                </div>
            </div>
            <div style="position: absolute; left: 0px; top: 0px; width: 100%; height: 100%; padding: 30px 0px 0px 220px; box-sizing: border-box; -moz-box-sizing: border-box; -webkit-box-sizing: border-box; z-index: 0; overflow: hidden;">
                <div style="position: relative; width: 100%; height: 100%; padding: 0px; box-sizing: border-box; -moz-box-sizing: border-box; -webkit-box-sizing: border-box; z-index: 0; overflow: hidden;">
                    <div style="position: absolute; left: 0px; top: 0px; width: 100%; padding: 5px; box-sizing: border-box; -moz-box-sizing: border-box; -webkit-box-sizing: border-box; z-index: 1; border-bottom: 1px solid #333;">
                        <%
                            szClick = "Page.Functions.JsonEditer.Save('" + pg.PageArgs.UIPath + "','" + pg.PageArgs.UID + "_TextArea','" + szPath + "','" + szObj + "');";
                        %>
                        <a href="javascript:;" onclick="<%=szClick%>">
                            <img src="<%=pg.PageArgs.UIPath%>images/Tool_Save.png" alt="" title="" height="24" /></a>
                    </div>
                    <div style="position: absolute; left: 0px; top: 38px; width: 100%; height: 30px; padding: 5px; box-sizing: border-box; -moz-box-sizing: border-box; -webkit-box-sizing: border-box; z-index: 1; border-bottom: 1px solid #333;">当前对象：<a href="javascript:;" onclick="<%=szClick%>">根对象</a><%=szObjectPath%></div>
                    <div style="position: absolute; left: 0px; top: 0px; width: 100%; height: 100%; padding-top: 68px; box-sizing: border-box; -moz-box-sizing: border-box; -webkit-box-sizing: border-box; z-index: 0; border-bottom: 1px solid #333;">
                        <textarea id="<%=pg.PageArgs.UID%>_TextArea" cols="20" rows="2" style="width: 100%; height: 100%; border: 0px; padding: 5px; box-sizing: border-box; -moz-box-sizing: border-box; -webkit-box-sizing: border-box;"><%=szObjectValue%></textarea>
                    </div>
                </div>
            </div>
            <%pg.Dispose();%>
        </div>
    </form>
</body>
</html>
