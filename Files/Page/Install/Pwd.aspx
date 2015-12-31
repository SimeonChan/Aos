<%@ Page Language="C#" %>

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
            <%
                Response.Clear();

                //string szName = Pub.Request(this, "Arg_Name");
                string szPwd = Pub.Request(this, "Arg_Pwd");// pg["Arg_File"];

                string gstrConnString = Pub.IO.ReadAllText(Server.MapPath(WebConfig.SZ_PATH_CONNECTSTRING));

                ClsAjaxRequest ar = new ClsAjaxRequest();

                //读取基础数据库配置文件
                //string szJson = Pub.IO.ReadAllEncryptionText(Server.MapPath(WebConfig.SZ_DB_PATH + "/" + szFile + ".json"));

                Ly.DB.Dream.Tables gTab = new Ly.DB.Dream.Tables(gstrConnString);

                if (!gTab.SystemUsers.GetDataByName("admin")) {
                    gTab.SystemUsers.Structure.Name = "admin";
                    gTab.SystemUsers.Structure.Pwd = Ly.String.Source(szPwd).md5;
                    gTab.SystemUsers.Add();
                    ar.Message = "密码设置成功!";
                } else {
                    ar.Message = "密码已经设置，无法重复设置!";
                }

                //pg.OutPutJsonRequest();
                Response.Write(ar.ToString());
                Response.End();
            %>
        </div>
    </form>
</body>
</html>
