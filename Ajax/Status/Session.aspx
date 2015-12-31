<%@ Page Language="C#" Inherits="ClsPage" %>

<!DOCTYPE html>

<script runat="server">

</script>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
    <title></title>
</head>
<body>
    <form id="form1" runat="server">
        <div>
            <%this.CreateNewSessionID();%>
            <%ClsAjaxPage pg = new ClsAjaxPage(this); %>
            <%
                using (dyk.DB.Aos.AosLog.ExecutionExp sl = new dyk.DB.Aos.AosLog.ExecutionExp(this.AosConnectString)) {
                    sl.Structure.AuthID = this.AuthorizeID;
                    sl.Structure.CreateTime = dyk.Type.Time.Now.ToString;
                    sl.Structure.Lv = 0;
                    sl.Structure.SessionID = this.SessionID;
                    sl.Structure.Type = "交互操作";
                    sl.Structure.Summary = "申请一个新的交互识标";
                    sl.Structure.Detail = "IP:" + this.IPAddress;
                    sl.Add();
                }
                pg.PageRequest.SetStorage("Azalea_SessionID", this.SessionID);
                pg.OutPutJsonRequest();
            %>
            <%pg.Dispose();%>
        </div>
    </form>
</body>
</html>
