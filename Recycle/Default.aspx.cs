using System;
using System.Collections.Generic;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class _Default : ClsPage {
    protected String gstrPath;
    protected String gstrFullPath;
    protected Ly.IO.JsonFile gJson;
    protected string gstrApps = "";

    protected string gszCookieName = "";
    protected Ly.Web.HttpUserAgent gUserAgent;

    protected void Page_Load(object sender, EventArgs e) {
        gstrPath = "";

        if (Request.Cookies["UserName"] != null) {
            gszCookieName = Request.Cookies["UserName"].Value;
        }

        gUserAgent = new Ly.Web.HttpUserAgent(HttpContext.Current.Request.UserAgent);

        //Session["Manager"] = "Admin";

        if (Request["Path"] != null) gstrPath = Request["Path"].ToString().Trim().Replace("\\", "/");
        if (gstrPath.StartsWith("/") || gstrPath.IndexOf("..") >= 0) gstrPath = "";
        if (gstrPath != "" && !gstrPath.EndsWith("/")) gstrPath += "/";
        gstrFullPath = "/" + gstrPath;
        gJson = new Ly.IO.JsonFile(Server.MapPath("/Files/System/Apps.txt"), System.Text.Encoding.UTF8);

        //String Connstr = Pub.IO.ReadAllText(Server.MapPath("/Files/System/Conn.txt"));

        //检测是否安装了数据
        if (!Pub.CheckInstall(this.ConnectString)) Response.Redirect("/Files/App/Install/Install.aspx");

        //gstrApps = "{Array:[";

        for (int i = 0; i < gJson.Objects.Count; i++) {
            if (gJson.Objects[i].Name == "App") {
                if (gJson.Objects[i].Items["Name"].Value == "#(TableList)") {
                    using (Ly.DB.Dream.Tables gTab = new Ly.DB.Dream.Tables(this.ConnectString)) {
                        gTab.SystemTables.GetDatasOrderByIndex();
                        for (int j = 0; j < gTab.SystemTables.StructureCollection.Count; j++) {
                            if (gstrApps != "") {
                                gstrApps += ",";
                            }
                            using (Ly.IO.Json js = new Ly.IO.Json()) {
                                js.Items["text"].Value = gTab.SystemTables.StructureCollection[j].Text;
                                js.Items["name"].Value = "System/Table";
                                js.Items["logo"].Value = "/Files/App/System/Manager/Logo.png";
                                js.Items["url"].Value = "/Files/App/System/Table/Default.aspx?Table=" + gTab.SystemTables.StructureCollection[j].ID;
                                gstrApps += js.Object.ToString().Replace("\"", "\\\"");
                            }
                        }
                    }
                } else {
                    if (gstrApps != "") {
                        gstrApps += ",";
                    }
                    using (Ly.IO.Json js = new Ly.IO.Json()) {
                        js.Items["text"].Value = gJson.Objects[i].Items["Name"].Value;
                        js.Items["name"].Value = gJson.Objects[i].Items["Dir"].Value;
                        js.Items["logo"].Value = gJson.Objects[i].Items["Icon"].Value;
                        js.Items["url"].Value = gJson.Objects[i].Items["App"].Value;
                        gstrApps += js.Object.ToString().Replace("\"", "\\\"");
                    }
                }
            }
        }

        gstrApps = "{Array:[" + gstrApps + "]}";
    }
}