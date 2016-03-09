<%@ Page Language="C#" Inherits="ClsPage" %>

<!DOCTYPE html>

<script runat="server">
    protected String gstrPath;
    protected String gstrFullPath;
    protected Ly.IO.JsonFile gJson;
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
                long lngID = dyk.Type.String.New(this["Key_ID"]).ToNumber;
            %>
            <%
                using (dyk.DB.Kernel.SystemCatalog.ExecutionExp sc = new dyk.DB.Kernel.SystemCatalog.ExecutionExp(this.BaseConnectString)) {
                    sc.GetDatasByBelong(lngID);
                    for (int i = 0; i < sc.StructureCollection.Count; i++) {
                        dyk.DB.Kernel.SystemCatalog.StructureExp st = sc.StructureCollection[i];
                        string szClickScript = "X.Custom.DataManager.GetTreeNode(" + st.ID + ");";
                        if (st.Type == 0) { 
            %>
            <div style="margin-left: 12px;">
                <div style="float: left; margin: 1px 0px 0px 0px;">
                    <a href="javascript:;" onclick="<%=szClickScript%>">
                        <img id="DataManager_Dir_<%=st.ID%>_Sign" src="<%=pg.PageArgs.UIPath%>Images/Close.jpg" height="12" /></a>
                </div>
                <%
                            szClickScript = "X.Custom.DataManager.GetTree(" + st.ID + ");X.Custom.DataManager.GetList(" + st.ID + ");";
                %>
                <div style="float: left; margin: 2px 0px 0px 6px;">
                    <a href="javascript:;" onclick="<%=szClickScript%>">
                        <img src="<%=pg.PageArgs.UIPath%>Images/Dir.png" height="16" /></a>
                </div>
                <div style="float: left; padding: 0px 0px 0px 5px;"><a href="javascript:;" onclick="<%=szClickScript%>"><%=st.Name%></a></div>
                <div style="clear: both;"></div>
            </div>
            <div style="margin-left: 12px; display: none;" id="DataManager_Dir_<%=st.ID%>"></div>
            <%
                        }
                    }
                }
            %>
            <%pg.Dispose();%>
        </div>
    </form>
</body>
</html>
