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
                gintTable = Ly.String.Source(Pub.Request(this, "Arg_Table")).toInteger;
                //Ly.DB.Dream.Tables gTabs = new Ly.DB.Dream.Tables(this.ConnectString);
                dyk.DB.Base.SystemTables.ExecutionExp gSystemTables = new dyk.DB.Base.SystemTables.ExecutionExp(this.ConnectString);
                gSystemTables.GetDataByID(gintTable);

                dyk.DB.Base.SystemTableTypes.ExecutionExp gSystemTableTypes = new dyk.DB.Base.SystemTableTypes.ExecutionExp(this.ConnectString);
                gSystemTableTypes.GetDataByID(gSystemTables.Structure.TableTypeID);

                int gnPage = Ly.String.Source(this["Arg_Page"]).toInteger;
                string szTable = Pub.Request(this, "Arg_Table");
                string szTableKey = this["Arg_Table_Key"].Replace("&", "&#38;").Replace("\"", "&#34;").Replace("'", "&#39;");
                string szTableFilters = this["Arg_Table_Filters"].Replace("&", "&#38;").Replace("\"", "&#34;").Replace("'", "&#39;");

                //添加、修改界面的应用地址
                string szUIPath = "/Files/App/OA/UI/";

                using (ClsAjaxRequest js = new ClsAjaxRequest()) {
                    js.SetStyle(pg.PageArgs.UIMain, "backgroundColor", "#fff");
                    js.SetStyle(pg.PageArgs.UIMain, "width", "100%");
                    js.SetStyle(pg.PageArgs.UIMain, "height", "100%");
                    js.SetScript("Js_OA_Process", "/Files/App/OA/Process/js/Process.js");
                    js.SetScript("Js_OA_Table", gSystemTableTypes.Structure.AppPath + "js/Default.js");
                    js.SetStorage("OA_Table_Select_" + pg.PageArgs.UID, "");

                    //储存页面基本参数
                    js.SetStorage("OA_" + pg.PageArgs.UID + "_UITitle", pg.PageArgs.UITitle);
                    js.SetStorage("OA_" + pg.PageArgs.UID + "_UIPath", szUIPath);
                    js.SetStorage("OA_" + pg.PageArgs.UID + "_Path", gSystemTableTypes.Structure.AppPath);

                    //储存页面专用参数
                    js.SetStorage("OA_" + pg.PageArgs.UID + "_Arg_Table", szTable);
                    js.SetStorage("OA_" + pg.PageArgs.UID + "_Arg_Page", gnPage.ToString());
                    js.SetStorage("OA_" + pg.PageArgs.UID + "_Arg_Table_Date", this["Arg_Table_Date"]);
                    js.SetStorage("OA_" + pg.PageArgs.UID + "_Arg_Table_Key", szTableKey);
                    js.SetStorage("OA_" + pg.PageArgs.UID + "_Arg_Table_Filters", szTableFilters);
                    js.SetStorage("OA_" + pg.PageArgs.UID + "_Arg_ID", this["Arg_ID"]);
                    js.SetStorage("OA_" + pg.PageArgs.UID + "_Arg_Relation", this["Arg_Relation"]);
                    js.SetStorage("OA_" + pg.PageArgs.UID + "_Arg_Index", this["Arg_Index"]);

                    js.SetDebugLine("正在加载数据表格:");
                    using (ClsAjaxRequest.Arg arg = new ClsAjaxRequest.Arg()) {
                        arg.Path = gSystemTableTypes.Structure.AppPath;
                        arg["Arg_Table"] = szTable;
                        arg["Arg_Page"] = gnPage.ToString();
                        arg["Arg_Table_Date"] = this["Arg_Table_Date"];
                        arg["Arg_Table_Key"] = szTableKey;
                        arg["Arg_ID"] = this["Arg_ID"];
                        arg["Arg_Relation"] = this["Arg_Relation"];
                        arg["Arg_Index"] = this["Arg_Index"];
                        arg["Arg_RelationText"] = this["Arg_RelationText"];
                        js.SetAjaxLoad(pg.PageArgs.UID, pg.PageArgs.UITool, gSystemTableTypes.Structure.AppPath + "Tool.aspx", arg, "->(1/2)加载工具栏...");
                        js.SetAjaxLoad(pg.PageArgs.UID, pg.PageArgs.UIMain, gSystemTableTypes.Structure.AppPath + "Main.aspx", arg, "->(2/2)加载主界面...");
                    }
                    Response.Write(js.ToString());
                }
            %>
            <%pg.Dispose();%>
        </div>
    </form>
</body>
</html>
