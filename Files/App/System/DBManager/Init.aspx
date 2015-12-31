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

                //读取基础数据库配置文件
                string szJson = Pub.IO.ReadAllText(Server.MapPath(WebConfig.SZ_DB_INIT));

                try {
                    #region [=====处理主体=====]
                    using (Ly.Data.SQLClient Conn = new Ly.Data.SQLClient(this.ConnectString)) {
                        Conn.ExecuteNonQuery(szJson);
                    }
                    pg.PageRequest.Message = "更新成功!";
                    #endregion
                } catch (Exception ex) {
                    pg.PageRequest.Message = "更新失败:" + ex.Message;
                }

                pg.OutPutJsonRequest();
            %>
            <%pg.Dispose();%>
        </div>
    </form>
</body>
</html>
