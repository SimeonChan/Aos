<%@ Page Language="C#" ValidateRequest="false" Inherits="ClsPage" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<script runat="server">
    protected int gintTable;
    //protected String gstrConnString;

    protected long glngRelation;
    protected long glngID;
    protected int gintIndex;
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
                string sPath = pg["Path"];
                string sID = pg["ID"];
                string sTable = pg["Table"];

                glngID = Ly.String.Source(pg["Arg_ID"]).toLong;
                glngRelation = Ly.String.Source(pg["Arg_Relation"]).toLong;
                gintIndex = Ly.String.Source(pg["Arg_Index"]).toInteger;

                gintTable = Ly.String.Source(Pub.Request(this, "ViewTable")).toInteger;
                //gstrConnString = Pub.IO.ReadAllText(Server.MapPath("/Files/System/Conn.txt"));
                Ly.DB.Dream.Tables gTabs = new Ly.DB.Dream.Tables(this.ConnectString);
                gTabs.SystemTables.GetDataByID(gintTable);
                gTabs.SystemColumns.GetDatasByParentID(gintTable);

                using (ClsAjaxRequest js = new ClsAjaxRequest()) {

                    string sql = "";

                    try {
                        using (Ly.Data.SQLClient conn = new Ly.Data.SQLClient(this.ConnectString)) {
                            sql = "delete from [" + gTabs.SystemTables.Structure.Name + "] where [ID]=" + Ly.String.Source(pg["Key_ID"]).toLong;
                            conn.ExecuteNonQuery(sql);
                        }
                        //js.SetText("MsgNav_Info", "<font color='#009900'>保存成功!<font>");
                        js.Message = "信息删除成功!";

                        //js.SetStyle(sID, "backgroundColor", "");
                        js.SetText("div_Console", "就绪!" + sql);
                        using (ClsAjaxRequest.Arg arg = new ClsAjaxRequest.Arg(pg)) {
                            arg["Path"] = sPath;
                            arg["ID"] = sID;
                            arg["Table"] = sTable;
                            arg["Dialog_ElementID"] = pg.PageArgs.Dialog_ElementID;
                            arg["Dialog_ID"] = pg.PageArgs.Dialog_ID;
                            arg["Process_ElementID"] = pg.PageArgs.Process_ElementID;
                            arg["Process_ID"] = pg.PageArgs.Process_ID;
                            arg["Arg_ID"] = glngID.ToString();
                            arg["Arg_Relation"] = glngRelation.ToString();
                            arg["Arg_Index"] = gintIndex.ToString();
                            js.SetAjaxScript(pg.PageArgs.UID, pg.PageArgs.Path + "Process.aspx", arg);
                        }
                        // js.Refresh = 1;
                    } catch (Exception ex) {
                        js.Message = ex.Message;
                    }

                    //js.SetText("MsgNav_Info", "<font color='#990000'>保存失败!<font>");
                    Response.Write(js.ToString());
                }
            %>
            <%pg.Dispose();%>
        </div>
    </form>
</body>
</html>
