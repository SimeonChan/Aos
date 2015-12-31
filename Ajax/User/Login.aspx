<%@ Page Language="C#" Inherits="ClsPage" %>

<!DOCTYPE html>

<script runat="server">
    //protected Ly.DB.Dream.Tables gTab;
    protected dyk.DB.Base.SystemUsers.ExecutionExp gSystemUsers;
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
                //gTab = new Ly.DB.Dream.Tables(this.ConnectString);
                gSystemUsers = new dyk.DB.Base.SystemUsers.ExecutionExp(this.ConnectString);
                using (ClsAjaxRequest js = new ClsAjaxRequest()) {
                    string sName = Pub.Request(this, "Name");
                    string sPwd = Ly.String.Source(Pub.Request(this, "Pwd")).md5;
                    string szCode = Pub.Request(this, "Code");
                    string szVCode = this.Session["VerificationCode_login"];
                    js.Flag = 0;
                    if (szCode == "" || szCode != szVCode) {
                        js.Message = "验证码错误!";
                        using (dyk.DB.Aos.AosLog.ExecutionExp sl = new dyk.DB.Aos.AosLog.ExecutionExp(this.AosConnectString)) {
                            sl.Structure.AuthID = this.AuthorizeID;
                            sl.Structure.CreateTime = dyk.Type.Time.Now.ToString;
                            sl.Structure.Lv = 2;
                            sl.Structure.SessionID = this.SessionID;
                            sl.Structure.Type = "用户操作";
                            sl.Structure.Summary = "登录失败:验证码错误!";
                            sl.Structure.Detail = "用户[" + sName + "]";
                            sl.Add();
                        }
                    } else {
                        if (gSystemUsers.GetDataByName(sName)) {
                            if (gSystemUsers.Structure.Pwd == sPwd || gSystemUsers.Structure.Pwd == "") {
                                js.Flag = 1;
                                //Pub.Session.SetManager(this, sName);
                                pg.Session.Manager = sName;
                                Response.Cookies["UserName"].Value = sName;
                                Response.Cookies["UserName"].Expires = DateTime.Now.AddMonths(1);
                                using (dyk.DB.Aos.AosLog.ExecutionExp sl = new dyk.DB.Aos.AosLog.ExecutionExp(this.AosConnectString)) {
                                    sl.Structure.AuthID = this.AuthorizeID;
                                    sl.Structure.CreateTime = dyk.Type.Time.Now.ToString;
                                    sl.Structure.Lv = 3;
                                    sl.Structure.SessionID = this.SessionID;
                                    sl.Structure.Type = "用户操作";
                                    sl.Structure.Summary = "登录";
                                    sl.Structure.Detail = "用户[" + sName + "]";
                                    sl.Add();
                                }
                            } else {
                                js.Message = "密码错误,请确认是否开启了大写锁定!";
                                using (dyk.DB.Aos.AosLog.ExecutionExp sl = new dyk.DB.Aos.AosLog.ExecutionExp(this.AosConnectString)) {
                                    sl.Structure.AuthID = this.AuthorizeID;
                                    sl.Structure.CreateTime = dyk.Type.Time.Now.ToString;
                                    sl.Structure.Lv = 2;
                                    sl.Structure.SessionID = this.SessionID;
                                    sl.Structure.Type = "用户操作";
                                    sl.Structure.Summary = "登录失败:密码错误!";
                                    sl.Structure.Detail = "用户[" + sName + "]";
                                    sl.Add();
                                }
                            }
                        } else {
                            js.Message = "用户不存在,请检查输入!";
                            using (dyk.DB.Aos.AosLog.ExecutionExp sl = new dyk.DB.Aos.AosLog.ExecutionExp(this.AosConnectString)) {
                                sl.Structure.AuthID = this.AuthorizeID;
                                sl.Structure.CreateTime = dyk.Type.Time.Now.ToString;
                                sl.Structure.Lv = 2;
                                sl.Structure.SessionID = this.SessionID;
                                sl.Structure.Type = "用户操作";
                                sl.Structure.Summary = "登录失败:用户不存在!";
                                sl.Structure.Detail = "用户[" + sName + "]";
                                sl.Add();
                            }
                        }
                    }

                    Response.Write(js.ToString());
                }
            %>
            <%pg.Dispose();%>
        </div>
    </form>
</body>
</html>
