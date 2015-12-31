using System;
using System.Collections.Generic;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class Files_App_Com_Setting_Default : ClsPage {
    protected String gstrPath;
    protected String gstrFullPath;
    protected Ly.Formats.Json gJson;

    protected int gnType;
    protected int gnChat;
    protected string gszSign;
    protected string gszTempSign;

    protected Ly.DB.Dream.Tables gTabs;

    protected void Page_Load(object sender, EventArgs e) {

        gTabs = new Ly.DB.Dream.Tables(this.ConnectString);

        gstrPath = "";
        if (Request["Path"] != null) gstrPath = Request["Path"].ToString().Trim().Replace("\\", "/");
        if (gstrPath.StartsWith("/") || gstrPath.IndexOf("..") >= 0) gstrPath = "";
        if (gstrPath != "" && !gstrPath.EndsWith("/")) gstrPath += "/";
        gstrFullPath = "/" + gstrPath;
        gJson = new Ly.Formats.Json(Pub.IO.ReadAllText(Server.MapPath(this.WebConfig.SystemExtensionPath)));

        gnType = Ly.String.Source(this["Type"]).toInteger;
        gnChat = Ly.String.Source(this["ID"]).toInteger;
        gszTempSign = this["Sign"];

        if (gnType <= 0 || gnType > 4) {
            gnType = 1;
            gnChat = (int)this.UserInfo.Department;
        }



        gszSign = "";

        switch (gnType) {
            case 1:
                gszSign = "Department:" + gnChat;
                break;
            case 2:
                gszSign = "User:" + gnChat;
                break;
            case 3:
                gszSign = "Group:" + gnChat;
                break;
            case 4:
                gszSign = gszTempSign;
                gnChat = 0;
                break;
        }

        if (gszSign == "") gszSign = "Unknow";

    }
}