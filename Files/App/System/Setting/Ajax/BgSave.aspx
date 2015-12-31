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

                using (ClsAjaxRequest js = new ClsAjaxRequest()) {
                    try {
                        string szUserSettingPath = Server.MapPath(this.WebConfig.UserSettingPath);
                        string szJson = Pub.IO.ReadAllEncryptionText(szUserSettingPath);
                        Ly.Formats.Json jSon = new Ly.Formats.Json(szJson);

                        jSon["Background"].Value = sPath;

                        Pub.IO.WriteAllEncryptionText(szUserSettingPath, jSon.ToString(2));

                        js.Message = "保存成功!";

                        using (ClsAjaxRequest.Arg arg = new ClsAjaxRequest.Arg()) {
                            arg["Path"] = this.WebConfig.AppPath + "/Setting/";
                            arg["Process_ElementID"] = pg.PageArgs.Process_ElementID;
                            arg["Process_ID"] = pg.PageArgs.Process_ID;
                            arg["Table"] = this.WebConfig.AppPath + "Setting";
                            js.SetAjaxLoad(pg.PageArgs.Process_ElementID, this.WebConfig.AppPath + "/Setting/Main.aspx", arg);
                        }

                    } catch (Exception ex) {
                        js.Message = "保存失败:" + ex.Message.Replace("\"", "\\\"");
                    }
                    pg.OutPut(js.ToString());
                }
            %>
            <%pg.Dispose();%>
        </div>
    </form>
</body>
</html>
