<%@ Page Language="C#" Inherits="ClsPage" %>

<!DOCTYPE html>

<script runat="server">
//protected Ly.DB.Dream.Tables gTab;
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
                using (dyk.DB.Aos.AosLog.ExecutionExp sl = new dyk.DB.Aos.AosLog.ExecutionExp(this.AosConnectString)) {
                    sl.Structure.AuthID = this.AuthorizeID;
                    sl.Structure.CreateTime = dyk.Type.Time.Now.ToString;
                    sl.Structure.Lv = 1;
                    sl.Structure.SessionID = this.SessionID;
                    sl.Structure.Type = "用户操作";
                    sl.Structure.Summary = "退出登录";
                    sl.Structure.Detail = "用户[" + pg.Session.Manager + "]";
                    sl.Add();
                }
                using (ClsAjaxRequest js = new ClsAjaxRequest()) {
                    pg.Session.Manager = "";
                    js.Message = "用户退出登录成功!";
                    js.Refresh = 1;
                    Response.Write(js.ToString());
                }
            %>
            <%pg.Dispose();%>
        </div>
    </form>
</body>
</html>
