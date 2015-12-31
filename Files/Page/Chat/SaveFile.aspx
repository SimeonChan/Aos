<%@ Page Language="C#" Inherits="ClsPage" ValidateRequest="false" %>

<!DOCTYPE html>

<script runat="server">
    protected String gstrFullPath;
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
                string szSign = Pub.Request(this, "Sign");
                string szContent = Pub.Request(this, "content");

                szContent = szContent.Replace("<", "&lt;").Replace(">", "&gt;").Replace("\n", "<br>");
                //szContent = "{Type:\"Normal\",Content:\"" + szContent + "\"}";

                using (ClsAjaxRequest js = new ClsAjaxRequest()) {

                    using (Ly.DB.Dream.Tables gTabs = new Ly.DB.Dream.Tables(this.ConnectString)) {
                        gTabs.SystemChats.Structure.ChatSign = szSign;
                        gTabs.SystemChats.Structure.Content = szContent;
                        gTabs.SystemChats.Structure.ChatType = 2;//文件模式
                        if (this.UserInfo.ID <= 0) {
                            gTabs.SystemChats.Structure.FromUserID = 0;
                            gTabs.SystemChats.Structure.FromUserName = "Temp:" + this.SessionID;
                        } else {
                            gTabs.SystemChats.Structure.FromUserID = this.UserInfo.ID;
                            gTabs.SystemChats.Structure.FromUserName = this.UserInfo.Nick;
                        }
                        gTabs.SystemChats.Structure.DoTime = Ly.Time.Now.toCommonFormatString;
                        gTabs.SystemChats.Structure.IsRead = 0;
                        gTabs.SystemChats.Add();
                    }

                    //Ly.Formats.Json json = new Ly.Formats.Json();
                    //json["Nick"].Value = this.UserInfo.Nick + "&nbsp;" + Ly.Time.Now.toCommonFormatTimeString;
                    //json["Content"].Value = szContent;

                    //js.Items["Chats"].Value = "[" + json.ToString() + "]";

                    pg.OutPutAsText(js.ToString());
                }
            %>
            <%pg.Dispose();%>
        </div>
    </form>
</body>
</html>
