using System;
using System.Collections.Generic;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class Files_App_Com_Setting_Default:ClsPage
{
    protected String gstrPath;
    protected String gstrFullPath;
    protected Ly.IO.JsonFile gJson;

    protected void Page_Load(object sender, EventArgs e)
    {
        gstrPath = "";
        if (Request["Path"] != null) gstrPath = Request["Path"].ToString().Trim().Replace("\\", "/");
        if (gstrPath.StartsWith("/") || gstrPath.IndexOf("..") >= 0) gstrPath = "";
        if (gstrPath != "" && !gstrPath.EndsWith("/")) gstrPath += "/";
        gstrFullPath = "/" + gstrPath;
        gJson = new Ly.IO.JsonFile(Server.MapPath("/Files/System/Extension.txt"),System.Text.Encoding.UTF8);
    }
}