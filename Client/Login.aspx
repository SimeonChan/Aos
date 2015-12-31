<%@ Page Language="C#" Inherits="ClsPage" %>

<!DOCTYPE html>

<script runat="server">
    protected Ly.DB.Dream.Tables gTab;
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
                //String Connstr = Pub.IO.ReadAllText(Server.MapPath("/Files/System/Conn.txt"));
                gTab = new Ly.DB.Dream.Tables(this.ConnectString);
                using (ClsAjaxRequest js = new ClsAjaxRequest()) {
                    string sName = Pub.Request(this, "user");
                    string sPwd =Pub.Request(this, "Pwd");
                    js.Flag = 0;
                    if (gTab.SystemUsers.GetDataByName(sName)) {
                        if (gTab.SystemUsers.Structure.Pwd == sPwd || gTab.SystemUsers.Structure.Pwd == "") {
                            js.Flag = 1;
                            //Pub.Session.SetManager(this, sName);
                            pg.Session.Manager = sName;
                            Response.Cookies["UserName"].Value = sName;
                            Response.Cookies["UserName"].Expires = DateTime.Now.AddMonths(1);

                            Response.Redirect("/Files/Page/Chat/Default.aspx");
                        } else {
                            pg.OutPutAsText("密码错误!");
                        }
                    } else {
                        pg.OutPutAsText("用户不存在!");
                    }
                    //Response.Write(js.Object.ToString());
                }
            %>
        </div>
    </form>
</body>
</html>
