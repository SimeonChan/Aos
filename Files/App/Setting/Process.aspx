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
                gintTable = Ly.String.Source(Pub.Request(this, "Table")).toInteger;
                gstrConnString = Pub.IO.ReadAllText(Server.MapPath(this.WebConfig.ConnectStringPath));
                Ly.DB.Dream.Tables gTabs = new Ly.DB.Dream.Tables(gstrConnString);

                using (ClsAjaxRequest js = new ClsAjaxRequest()) {
                    //js.Message = "Test";
                    //js.SetText("MsgNav_Info", "<font color='#990000'>保存失败!<font>");
                    string sPath = Pub.Request(this, "Path");
                    string sID = Pub.Request(this, "ID");
                    string sTable = Pub.Request(this, "Table");
                    //js.SetStyle(sID, "backgroundColor", "");
                    js.SetText("div_Console", "就绪!");
                    using (ClsAjaxRequest.Arg arg = new ClsAjaxRequest.Arg()) {
                        arg["Path"] = sPath;
                        arg["ID"] = sID;
                        arg["Table"] = sTable;
                        //arg["Dialog_ElementIDID"] = pg.DialogElementID;
                        //arg["Dialog_ID"] = pg.DialogID;
                        arg["Process_ElementID"] = pg.XPortArgs.Process_ElementID;
                        arg["Process_ID"] = pg.XPortArgs.Process_ID;
                        js.SetAjaxLoad(sID, sPath + "Main.aspx", arg);
                    }
                    Response.Write(js.ToString());
                }
            %>
            <%pg.Dispose();%>
        </div>
    </form>
</body>
</html>
