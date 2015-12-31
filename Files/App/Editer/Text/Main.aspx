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

                if (szPath.StartsWith("/") || szPath.IndexOf("..") >= 0) {
                    pg.OutPut("不是合法的路径!");
                    pg.Dispose();
                }
                //szPath = "";
                //if (szPath != "" && !szPath.EndsWith("/")) szPath += "/";
                string szFullPath = "/" + szPath;

                //pg.OutPut(Server.MapPath(szFullPath));
                //pg.Dispose();

                string szJson = Pub.IO.ReadAllText(Server.MapPath(szFullPath));
                string szClick;

            %>
            <div style="position: absolute; top: 0px; left: 0px; z-index: 1; width: 100%;">
                <div style="padding: 6px;">
                    <div style="float: left;" class="Title">文本路径：</div>
                    <!--当前路径-->
                    <%
                        szClick = "Page.UI.Open('" + pg.PageArgs.UID + "','','文档管理器','/Files/App/System/Files/','Process.aspx', {Arg_Path:''});";
                    %>
                    <div style="float: left;"><a href="javascript:;" onclick="<%=szClick%>">我的云存储</a></div>
                    <%
                        string[] paths = szPath.Split('/');
                        string fullpath = "";
                        for (int i = 0; i < paths.Length; i++) {
                            if (paths[i] != "") {
                                if (i == paths.Length - 1) {
                    %>
                    <div style="float: left;">&gt;</div>
                    <div style="float: left;"><%=paths[i]%></div>
                    <%
                        } else {
                            fullpath += (fullpath == "") ? paths[i] : "/" + paths[i];
                            szClick = "Page.UI.Open('" + pg.PageArgs.UID + "','','文档管理器','/Files/App/System/Files/','Process.aspx', {Arg_Path:'" + fullpath + "'});";
                    %>
                    <div style="float: left;">&gt;</div>
                    <div style="float: left;"><a href="javascript:;" onclick="<%=szClick%>"><%=paths[i]%></a></div>
                    <%
                                }
                            }
                        }
                    %>
                    <div style="clear: both"></div>
                </div>
            </div>
            <div style="position: absolute; top: 0px; padding: 30px 3px 3px 3px; width: 100%; height: 100%; overflow: hidden; box-sizing: border-box; -moz-box-sizing: border-box; -webkit-box-sizing: border-box; z-index: 0;">
                <textarea id="<%=pg.PageArgs.UID%>_TextArea" cols="20" rows="2" style="width: 100%; height: 100%; border-top: 0px; border: 1px solid #DDDDDD; border-right: 1px solid #DDDDDD; border-bottom: 1px solid #DDDDDD; box-sizing: border-box; -moz-box-sizing: border-box; -webkit-box-sizing: border-box;"><%=szJson%></textarea>
            </div>
            <%pg.Dispose();%>
        </div>
    </form>
</body>
</html>
