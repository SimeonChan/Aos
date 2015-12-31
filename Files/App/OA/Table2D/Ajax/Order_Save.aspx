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
                string szFile = Server.MapPath(this.WebConfig.UserPath + "/Order.json");
                string szJson = Pub.IO.ReadAllEncryptionText(szFile);
                Ly.Formats.Json2 Json = new Ly.Formats.Json2(szJson);
                int nTable = Ly.String.Source(pg.PageArgs.Table).toInteger;

                string szColumn = pg["Arg_Column"];
                string szOrder = pg["Arg_Order"];
                string szType = "";

                using (Ly.DB.Dream.SystemColumns.ExecutionExp sc = new Ly.DB.Dream.SystemColumns.ExecutionExp(this.ConnectString)) {
                    sc.GetDataByParentIDAndName(nTable, szColumn);
                    if (sc.Structure.Type.Trim().ToLower() == "text") {
                        szType = "Text";
                    }
                }

                Ly.Formats.JsonObject obj = Json["Table_" + pg.PageArgs.Table];
                obj.IsArray = true;
                bool bFound = false;
                for (int i = 0; i < obj.Count; i++) {
                    string szName = obj[i]["Name"].Value;
                    if (szName == szColumn) {
                        obj[i]["Type"].Value = szType;
                        obj[i]["Order"].Value = szOrder;
                        bFound = true;
                        break;
                    }
                }
                if (!bFound) {
                    Ly.Formats.JsonObject objNew = obj.AppendChild("");
                    objNew["Name"].Value = szColumn;
                    objNew["Order"].Value = szOrder;
                    objNew["Type"].Value = szType;
                    obj.IsArray = true;
                }

                Pub.IO.WriteAllEncryptionText(szFile, Json.OuterJson);

                using (ClsAjaxRequest js = new ClsAjaxRequest()) {
                    using (ClsAjaxRequest.Arg arg = new ClsAjaxRequest.Arg()) {
                        js.SetAjaxLoad(pg.PageArgs.UID, "Dialog_" + pg.PageArgs.UID + "_Order_Content", pg.PageArgs.Path + "Ajax/Order.aspx", arg, "");
                        js.SetAjaxScript(pg.PageArgs.UID, pg.PageArgs.Path + "Process.aspx", arg);
                    }
                    Response.Write(js.ToString());
                }
            %>
            <%pg.Dispose();%>
        </div>
    </form>
</body>
</html>
