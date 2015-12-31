<%@ Page Language="C#" ValidateRequest="false" Inherits="ClsPage" %>

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
            <%ClsAjaxPage pg = new ClsAjaxPage(this); %>
            <%
                string sPath = pg["Setting_Background"];
                string szPwdOld = Ly.String.Source(pg["Pwd_Old"]).md5;
                string szPwdNew = Ly.String.Source(pg["Pwd_New"]).md5;
                string szPwdNewRe = Ly.String.Source(pg["Pwd_NewRe"]).md5;



                using (ClsAjaxRequest js = new ClsAjaxRequest()) {
                    if (this.UserInfo.Pwd == szPwdOld || this.UserInfo.Pwd == "") {
                        if (szPwdNew == szPwdNewRe) {
                            using (Ly.DB.Dream.SystemUsers.ExecutionExp gu = new Ly.DB.Dream.SystemUsers.ExecutionExp(this.ConnectString)) {
                                if (gu.GetDataByID(this.UserInfo.ID)) {
                                    gu.Structure.Pwd = szPwdNew;
                                    gu.UpdateByID();
                                }
                            }
                            js.Message = "密码修改成功!";
                            js.SetValue("Pwd_Old", "");
                            js.SetValue("Pwd_New", "");
                            js.SetValue("Pwd_NewRe", "");
                        } else {
                            js.Message = "两次输入的密码不一致!";
                        }
                    } else {
                        js.Message = "密码错误!";
                    }
                    pg.OutPut(js.ToString());
                }
            %>
            <%pg.Dispose();%>
        </div>
    </form>
</body>
</html>
