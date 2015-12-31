<%@ Page Language="C#" Inherits="ClsPage" %>

<!DOCTYPE html>

<script runat="server">
    protected String gstrPath;
    protected String gstrFullPath;
    protected Ly.IO.JsonFile gJson;

    /// <summary>
    /// 获取路径地址
    /// </summary>
    /// <param name="szPath"></param>
    /// <param name="lngID"></param>
    /// <returns></returns>
    protected string GetDirPath(string szPath, long lngID) {
        string szUIPath = this["UI_Path"];
        if (lngID > 0) {
            string szPathTemp = "";
            using (dyk.DB.Kernel.SystemCatalog.ExecutionExp sc = new dyk.DB.Kernel.SystemCatalog.ExecutionExp(this.BaseConnectString)) {
                if (sc.GetDataByID(lngID)) {
                    string szClickScript = "X.Custom.DataManager.GetList(" + sc.Structure.ID + ");";
                    szPathTemp += "<div style=\"float: left; padding: 0px 3px; \">&gt;</div>";
                    szPathTemp += "<div style=\"float: left;\">";
                    szPathTemp += "<img src=\"" + szUIPath + "Images/Dir.png\" height=\"16\" />";
                    szPathTemp += "</div>";
                    szPathTemp += "<div style=\"float: left; padding-left: 3px;\"><a href=\"javascript:;\" onclick=\"" + szClickScript + "\">" + sc.Structure.Name + "</a></div>";
                    szPath = szPathTemp + szPath;
                    return GetDirPath(szPath, sc.Structure.Belong);
                } else {
                    return szPath;
                }
            }
        } else {
            return szPath;
        }
    }
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
                string szClickScript = "";
                string szSiteName = "";
                long lngID = dyk.Type.String.New(this["Key_ID"]).ToNumber;

                using (dyk.DB.Aos.AosAuthorize.ExecutionExp aa = new dyk.DB.Aos.AosAuthorize.ExecutionExp(this.AosConnectString)) {
                    if (aa.GetDataByID(this.AuthorizeID)) {
                        szSiteName = aa.Structure.Name;
                    } else {
                        szSiteName = "未命名";
                    }
                }
            %>
            <div style="position: absolute; left: 0px; top: 0px; color: #222; height: 30px; width: 100%; padding: 6px 0px 0px 6px; z-index: 2; background: #ccc;">
                <div style="float: left;">当前路径：</div>
                <div style="float: left;">
                    <img src="<%=pg.PageArgs.UIPath%>Images/Database.png" height="16" />
                </div>
                <div style="float: left; padding-left: 3px;"><a href="javascript:;" onclick="X.Custom.DataManager.GetList(0);"><%=szSiteName%></a></div>
                <%=GetDirPath("",lngID)%>
                <div style="clear: both;"></div>
            </div>
            <div style="position: absolute; left: 0px; top: 0px; color: #222; height: 100%; width: 100%; padding: 30px 0px 0px 0px; z-index: 1;">
                <div style="width: 100%; height: 100%; overflow-y: auto; overflow-x: hidden; padding: 5px;">
                    <%
                        using (dyk.DB.Kernel.SystemCatalog.ExecutionExp sc = new dyk.DB.Kernel.SystemCatalog.ExecutionExp(this.BaseConnectString)) {
                            sc.GetDatasByBelong(lngID);
                            for (int i = 0; i < sc.StructureCollection.Count; i++) {
                                dyk.DB.Kernel.SystemCatalog.StructureExp st = sc.StructureCollection[i];
                                szClickScript = "X.Custom.DataManager.GetList(" + st.ID + ");";
                    %>
                    <div style="float: left; width: 100px; height: 100px; text-align: center; padding: 5px;">
                        <div style="width: 100%; padding: 5px; cursor: pointer;"
                            onclick="<%=szClickScript%>"
                            onmousemove="$(this).css({ border: '1px solid #0094ff', backgroundColor: '#5fbcff', color:'#000', opacity: 0.8});"
                            onmouseout="$(this).css({ border: '0px solid #0094ff', backgroundColor: '', color:'', opacity: 1 });">
                            <div style="width: 100%;">
                                <img src="<%=pg.PageArgs.UIPath%>Images/Dir.png" height="48" />
                            </div>
                            <div style="width: 100%; word-break: break-all; word-wrap: break-word;"><%=st.Name%></div>
                        </div>
                    </div>
                    <%
                            }
                        }
                    %>
                    <%
                        //加载应用列表
                        using (dyk.DB.Base.SystemTables.ExecutionExp aa = new dyk.DB.Base.SystemTables.ExecutionExp(this.BaseConnectString)) {
                            aa.GetDatasByCatalogID(lngID);
                            for (int i = 0; i < aa.StructureCollection.Count; i++) {
                                dyk.DB.Base.SystemTables.StructureExp st = aa.StructureCollection[i];

                                dyk.Format.Limits lm = Pub.DB.GetTableLimits(this, st.ID);

                                if (lm.Read) {
                                    szClickScript = "Page.UI.Open('Table_" + st.ID + "','','" + st.Text + "','/Files/App/OA/Process/','Process.aspx', {Arg_Table:" + st.ID + "});";
                    %>
                    <div style="float: left; width: 100px; height: 100px; text-align: center; padding: 5px;">
                        <div style="width: 100%; padding: 5px; cursor: pointer;"
                            onclick="<%=szClickScript%>"
                            onmousemove="$(this).css({ border: '1px solid #0094ff', backgroundColor: '#5fbcff', color:'#000', opacity: 0.8});"
                            onmouseout="$(this).css({ border: '0px solid #0094ff', backgroundColor: '', color:'', opacity: 1 });">
                            <div style="width: 100%;">
                                <img src="/Files/App/OA/Process/logo.png" height="48" />
                            </div>
                            <div style="width: 100%; word-break: break-all; word-wrap: break-word;"><%=st.Text%></div>
                        </div>
                    </div>
                    <%
                                }
                            }
                        }
                    %>
                    <div style="clear: both;"></div>
                </div>
            </div>
            <%pg.Dispose();%>
        </div>
    </form>
</body>
</html>
