<%@ Page Language="C#" ValidateRequest="false" Inherits="ClsPage" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<script runat="server">
    protected int gintTable;
    protected String gstrConnString;
</script>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
    <title></title>
</head>
<body>
    <form id="form1" runat="server">
        <div>
            <%ClsAjaxPage pg = new ClsAjaxPage(this);%>
            <%
                string szPath = pg["Arg_Path"];
                string szCnt = pg["Arg_Cnt"];
                string szCntTest=pg["Arg_Test_Cnt"];

                if (szPath.StartsWith("/") || szPath.IndexOf("..") >= 0) {
                    pg.OutPut("不是合法的路径!");
                    pg.Dispose();
                }

                string szFullPath = "/" + szPath;
                string szTestPath = "/" + szPath + ".test.json";

                try {
                    Pub.IO.WriteAllText(Server.MapPath(szFullPath), szCnt);
                    Pub.IO.WriteAllEncryptionText(Server.MapPath(szTestPath), szCntTest);
                    pg.PageRequest.Message = "保存成功!";
                } catch (Exception ex) {
                    pg.PageRequest.Message = "保存失败:" + ex.Message;
                }
 
                pg.OutPutJsonRequest();
            %>
            <%pg.Dispose();%>
        </div>
    </form>
</body>
</html>
