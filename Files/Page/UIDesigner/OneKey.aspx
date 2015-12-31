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

                //gTab = new Ly.DB.Dream.AzTables(this.ConnectString);
                gSystemTables = new dyk.DB.Base.SystemTables.ExecutionExp(this.ConnectString);
                gSystemColumns = new dyk.DB.Base.SystemColumns.ExecutionExp(this.ConnectString);

                if (gnTableID > 0) {
                    if (gSystemTables.GetDataByID(gnTableID)) {
                        gSystemColumns.GetDatasByParentID(gnTableID);
                    }
                }

                //if (gSystemTables.Structure.ID > 0) {
                //    //gszUIPath = Server.MapPath(this.WebConfig.ShareUISettingPath + "/" + gTab.SystemTables.Structure.Name + ".json");
                //    gszUIPath = Server.MapPath(this.WebConfig.SharePath + "/" + gTab.SystemTables.Structure.Name + "/UI.json");
                //} else {
                //    //gszUIPath = Server.MapPath(this.WebConfig.SystemUISettingPath + "/" + gszTable + ".json");
                //    gszUIPath = Server.MapPath(this.WebConfig.SharePath + "/" + gszTable + "/UI.json");
                //}

                 gszUIPath = Server.MapPath(gSystemTables.Structure.SavePath + "/UI.json");

                gJsonUI = new Ly.Formats.Json(Pub.IO.ReadAllEncryptionText(gszUIPath));

                int nTop = 30;

                if (gSystemTables.Structure.ID > 0) {
                    for (int i = 0; i < gSystemColumns.StructureCollection.Count; i++) {
                        string szName = gSystemColumns.StructureCollection[i].Name;
                        if (szName != "ID") {
                            bool bFound = false;

                            for (int j = 0; j < gJsonUI.Object.Count; j++) {
                                if (gJsonUI.Object[j].Name == "TextBox") {
                                    if (gJsonUI.Object[j]["Name"].Value == szName) {
                                        bFound = true;
                                        break;
                                    }
                                }
                            }

                            if (!bFound) {
                                Ly.Formats.JsonUnitPoint newLabel = gJsonUI.Object.AppendChild("Label");
                                newLabel.AppendChild("ID", "lab_" + szName);
                                newLabel.AppendChild("Text", gSystemColumns.StructureCollection[i].Text + ":");
                                newLabel.AppendChild("Left", "30");
                                newLabel.AppendChild("Top", nTop.ToString());
                                newLabel.AppendChild("Width", "100");
                                newLabel.AppendChild("Height", "20");
                                newLabel.AppendChild("Align", "Left");

                                Ly.Formats.JsonUnitPoint newTextbox = gJsonUI.Object.AppendChild("TextBox");
                                newTextbox.AppendChild("ID", szName);
                                newTextbox.AppendChild("Text",gSystemColumns.StructureCollection[i].Text);
                                newTextbox.AppendChild("Name", szName);
                                newTextbox.AppendChild("Left", "100");
                                newTextbox.AppendChild("Top", (nTop - 3).ToString());
                                newTextbox.AppendChild("Width", "100");
                                newTextbox.AppendChild("Height", "20");
                                newTextbox.AppendChild("Align", "Left");
                                newTextbox.AppendChild("Padding", "0,3,0,3");
                                newTextbox.AppendChild("Type", "text");
                                newTextbox.AppendChild("LineHeight", "18");

                                Ly.Formats.JsonUnitPoint newTextboxValue = newTextbox.AppendChild("Value");
                                newTextboxValue.AppendChild("Type", "Text");
                                newTextboxValue.AppendChild("Binding", "");
                            }

                            nTop += 30;
                        }
                    }
                } else {
                    using (Ly.Data.SQLClient Conn = new Ly.Data.SQLClient(this.ConnectString)) {
                        Conn.ExecuteReader("Select * From [" + gszTable + "]");
                        for (int i = 0; i < Conn.DataReader.FieldCount; i++) {
                            string szName = Conn.DataReader.GetName(i);
                            if (szName != "ID") {
                                bool bFound = false;

                                for (int j = 0; j < gJsonUI.Object.Count; j++) {
                                    if (gJsonUI.Object[j].Name == "TextBox") {
                                        if (gJsonUI.Object[j]["Name"].Value == szName) {
                                            bFound = true;
                                            break;
                                        }
                                    }
                                }

                                if (!bFound) {
                                    Ly.Formats.JsonUnitPoint newLabel = gJsonUI.Object.AppendChild("Label");
                                    newLabel.AppendChild("ID", "lab_" + szName);
                                    newLabel.AppendChild("Text", szName + ":");
                                    newLabel.AppendChild("Left", "30");
                                    newLabel.AppendChild("Top", nTop.ToString());
                                    newLabel.AppendChild("Width", "100");
                                    newLabel.AppendChild("Height", "20");
                                    newLabel.AppendChild("Align", "Left");

                                    Ly.Formats.JsonUnitPoint newTextbox = gJsonUI.Object.AppendChild("TextBox");
                                    newTextbox.AppendChild("ID", szName);
                                    newTextbox.AppendChild("Text", szName);
                                    newTextbox.AppendChild("Name", szName);
                                    newTextbox.AppendChild("Left", "100");
                                    newTextbox.AppendChild("Top", (nTop - 3).ToString());
                                    newTextbox.AppendChild("Width", "100");
                                    newTextbox.AppendChild("Height", "20");
                                    newTextbox.AppendChild("Align", "Left");
                                    newTextbox.AppendChild("Padding", "0,3,0,3");
                                    newTextbox.AppendChild("Type", "text");
                                    newTextbox.AppendChild("LineHeight", "18");

                                    Ly.Formats.JsonUnitPoint newTextboxValue = newTextbox.AppendChild("Value");
                                    newTextboxValue.AppendChild("Type", "Text");
                                    newTextboxValue.AppendChild("Binding", "");
                                }

                                nTop += 30;
                            }
                        }
                    }
                }
                //gszUIPath = Server.MapPath(this.WebConfig.SystemUISettingPath + "/" + gszTable + ".json");

                gJsonUI["Form.Height"].Value = (nTop < 300 ? nTop + 50 : 350).ToString();
                gJsonUI["Form.Width"].Value = "480";
                gJsonUI["Form.Overflow"].Value = "auto";

                using (ClsAjaxRequest js = new ClsAjaxRequest()) {
                    try {
                        //pg.OutPutAsText(gJsonUI.Object.ToJsonString(0, 2, " "));
                        Pub.IO.WriteAllEncryptionText(gszUIPath, gJsonUI.ToString(2));
                        js.Refresh = 1;
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
