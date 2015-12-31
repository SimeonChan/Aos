using System;
using System.Collections.Generic;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class Files_App_UIDesigner_SystemTable : ClsPage {

    protected String gszConnString;
    protected string gszTable;
    protected int gnTableID;
    //protected Ly.DB.Dream.AzTables gTab;
    protected String gszColPath;
    protected String gszUIPath;
    protected dyk.DB.Base.SystemTables.ExecutionExp gSystemTables;
    protected dyk.DB.Base.SystemColumns.ExecutionExp gSystemColumns;

    protected string gszJsonUI;
    //protected string gszJsonCol;

    protected Ly.Formats.Json gJsonCol;
    protected Ly.Formats.Json gJsonUI;

    protected const string gszProName = "联谊·云台专用界面设计器";
    protected const string gszVersion = "1.01.1511.0801";

    protected void Page_Load(object sender, EventArgs e) {
        gszTable = this["Table"];
        gnTableID = Ly.String.Source(this["ID"]).toInteger;
        //gszConnString = Pub.IO.ReadAllText(Server.MapPath(this.WebConfig.ConnectStringPath));
        //gTab = new Ly.DB.Dream.AzTables(gszConnString);

        gszConnString = this.BaseConnectString;

        //检测登录状态
        if (this.UserInfo.ID <= 0) Response.Redirect("/Default.aspx");

        gSystemTables = new dyk.DB.Base.SystemTables.ExecutionExp(gszConnString);
        gSystemColumns = new dyk.DB.Base.SystemColumns.ExecutionExp(gszConnString);

        if (gnTableID > 0) {
            if (gSystemTables.GetDataByID(gnTableID)) {
                gSystemColumns.GetDatasByParentID(gnTableID);
                gszTable = gSystemTables.Structure.Text;
            }
        }

        gszUIPath = gSystemTables.Structure.SavePath + "/UI.json";

        //if (gSystemTables.Structure.ID > 0) {
        //    gszUIPath = this.WebConfig.SharePath + "/" + gSystemTables.Structure.Name + "/UI.json";
        //} else {
        //    gszUIPath = this.WebConfig.SharePath + "/" + gszTable + "/UI.json";
        //}


        //gszColPath = Server.MapPath(this.WebConfig.SystemColumnsSettingPath + "/" + gszTable + ".json");

        //if (System.IO.File.Exists(gszColPath))
        //{
        //    gszJsonCol = Pub.IO.ReadAllEncryptionText(gszColPath);
        //}
        //else
        //{
        //    gszJsonCol = "{}";
        //    Pub.IO.WriteAllEncryptionText(gszColPath, gszJsonCol);
        //}

        if (System.IO.File.Exists(Server.MapPath(gszUIPath))) {
            gszJsonUI = Pub.IO.ReadAllEncryptionText(Server.MapPath(gszUIPath));
        } else {
            gszJsonUI = "{}";
            Pub.IO.WriteAllEncryptionText(Server.MapPath(gszUIPath), gszJsonUI);
        }

        //gJsonCol = new Ly.Formats.Json(Pub.IO.ReadAllEncryptionText(gszColPath));
        gJsonUI = new Ly.Formats.Json(gszJsonUI);
    }
}