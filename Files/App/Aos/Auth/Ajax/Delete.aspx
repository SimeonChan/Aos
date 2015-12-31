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

                long lngID = dyk.Type.String.New(this["Arg_ID"]).ToNumber;
                //string szName = this["Arg_Name"];
                //string szValue = this["Arg_Value"];
                try {
                    using (dyk.DB.Aos.AosAuthorize.ExecutionExp aa = new dyk.DB.Aos.AosAuthorize.ExecutionExp(this.AosConnectString)) {
                        aa.DeleteByID(lngID);
                    }
                    //pg.OutPutAsText("删除成功");
                    pg.XPort.Message = "删除成功";
                    //pg.XPort.SetAjaxLoad(pg.XPortArgs.UI_Main, pg.XPortArgs.UI_Path + "Main.aspx", pg.XPortArgs, "->(2/2)刷新主界面...");
                    pg.XPort.SetStyle("Aos_Auth_tr_" + lngID, "display", "none");
                } catch (Exception ex) {
                    //pg.OutPutAsText(ex.Message);
                    pg.XPort.Message = ex.Message;
                }
                pg.OutPutXPort();
            %>
            <%pg.Dispose();%>
        </div>
    </form>
</body>
</html>
