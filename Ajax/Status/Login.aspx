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
            <%ClsAjaxPage pg = new ClsAjaxPage(this); %>
            <%
                using (ClsAjaxRequest js = new ClsAjaxRequest()) {
                    string sName = pg.Session.Manager;
                    if (sName != "") {

                        //String szConnstr = Pub.IO.ReadAllText(Server.MapPath(this.WebConfig.ConnectStringPath));
                        String szConnstr = this.BaseConnectString;

                        using (Ly.DB.Dream.AzTables gTabs = new Ly.DB.Dream.AzTables(szConnstr)) {
                            if (gTabs.SystemUsers.GetDataByName(sName)) {
                                js.Flag = 1;
                                js.Message = "欢迎您," + gTabs.SystemUsers.Structure.Nick + "&nbsp;[<a href='/Files/Page/Chat/Default.aspx' class='a-white' target='_blank'>新消息<span id='chat_msg_count' style='color:#009900;font-weight:bold;'>0</span>条</a>]&nbsp;|&nbsp;[<a href='javascript:;' onclick='location.reload();' class='a-white'>刷新页面</a>]";

                                string szUserPath = Server.MapPath(this.WebConfig.UserPath);
                                if (!System.IO.Directory.Exists(szUserPath)) System.IO.Directory.CreateDirectory(szUserPath);

                                Ly.Formats.Json jSon = new Ly.Formats.Json();

                                string szUserSettingPath = Server.MapPath(this.WebConfig.UserSettingPath);
                                //如果配置文件不存在，则创建
                                if (!System.IO.File.Exists(szUserSettingPath)) {
                                    jSon["Background"].Value = this.WebConfig.DefaultBackgroundPath;
                                    Pub.IO.WriteAllEncryptionText(szUserSettingPath, jSon.ToString());
                                } else {
                                    string szJson = Pub.IO.ReadAllEncryptionText(szUserSettingPath);
                                    jSon.Object.SetChildrenByJsonString(szJson);
                                }
                                //js.Object["Background"].Value = jSon["Background"].Value;
                                js["Background"].Value = jSon["Background"].Value;
                            } else {
                                js.Flag = 0;
                                js.Message = "请先进行登录";
                            }
                        }
                    } else {
                        js.Flag = 0;
                        js.Message = "请先进行登录";
                    }
                    //js.Flag = 1;

                    Response.Write(js.ToString());
                }
                //Response.Write("Login Access!");
            %>
            <%pg.Dispose();%>
        </div>
    </form>
</body>
</html>
