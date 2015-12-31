<%@ Page Language="C#" ValidateRequest="false" Inherits="ClsPage" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<script runat="server">
    protected String gszConnString;
    protected string gszTable;
    protected int gnTableID;
    //protected Ly.DB.Dream.AzTables gTab;
    protected String gszColPath;
    protected String gszUIPath;

    protected string gszJsonUI;
    //protected string gszJsonCol;

    protected Ly.Formats.Json gJsonCol;
    protected Ly.Formats.Json gJsonUI;

    protected dyk.DB.Base.SystemTables.ExecutionExp gSystemTables;
    protected dyk.DB.Base.SystemColumns.ExecutionExp gSystemColumns;
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
                string szJson = pg["Json"];
                gszTable = this["Table"];
                gnTableID = Ly.String.Source(this["ID"]).toInteger;

                gSystemTables = new dyk.DB.Base.SystemTables.ExecutionExp(this.ConnectString);
                gSystemColumns = new dyk.DB.Base.SystemColumns.ExecutionExp(this.ConnectString);

                //gTab = new Ly.DB.Dream.AzTables(this.ConnectString);

                if (gnTableID > 0) {
                    if (gSystemTables.GetDataByID(gnTableID)) {
                        gSystemColumns.GetDatasByParentID(gnTableID);
                    }
                }

                gszUIPath = gSystemTables.Structure.SavePath + "/UI.json";

                //if (gTab.SystemTables.Structure.ID > 0) {
                //    gszUIPath = this.WebConfig.SharePath + "/" + gTab.SystemTables.Structure.Name + "/UI.json";
                //} else {
                //    gszUIPath = this.WebConfig.SharePath + "/" + gszTable + "/UI.json";
                //}

                //gszUIPath = Server.MapPath(this.WebConfig.SystemUISettingPath + "/" + gszTable + ".json");



                using (ClsAjaxRequest js = new ClsAjaxRequest()) {
                    try {

                        string szJsonOut = "{\n";
                        gJsonUI = new Ly.Formats.Json(szJson);

                        for (int i = 0; i < gJsonUI.Object.Count; i++) {
                            Ly.Formats.JsonUnitPoint pObj = gJsonUI.Object[i];

                            if (pObj["ID"].Value.StartsWith("Auto_")) {
                                pObj["ID"].Value = "";
                            }

                            pObj["Padding"].Value = pObj["PaddingTop"].Value + "," + pObj["PaddingRight"].Value + "," + pObj["PaddingBottom"].Value + "," + pObj["PaddingLeft"].Value;

                            szJsonOut += "  " + pObj.Name + ":" + pObj.ToJsonString();
                            if (i < gJsonUI.Object.Count - 1) szJsonOut += ",";
                            szJsonOut += "\n";
                        }

                        szJsonOut += "}";
                        //pg.OutPutAsText(gJsonUI.Object.ToJsonString(0, 2, " "));
                        Pub.IO.WriteAllEncryptionText(Server.MapPath(gszUIPath), szJsonOut);
                        js.Message = "保存成功!";
                    } catch (Exception ex) {
                        js.Message = "保存失败:\\n\\n" + ex.Message;
                    }
                    pg.OutPutAsText(js.ToString());
                }
            %>
            <%pg.Dispose();%>
        </div>
    </form>
</body>
</html>
