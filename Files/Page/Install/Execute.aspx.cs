using System;
using System.Collections.Generic;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class Files_App_Ly_InformationSystem_Execute : Page {
    protected String gstrTable;
    protected String gstrContext;
    protected int gintDB;
    protected String gstrConnString;

    protected void Page_Load(object sender, EventArgs e) {
        ClsAjaxRequest js = new ClsAjaxRequest();
        gstrTable = Pub.Request(this, "Table");
        gintDB = Ly.String.Source(Pub.Request(this, "DB")).toInteger;

        gstrConnString = Pub.IO.ReadAllText(Server.MapPath(WebConfig.SZ_PATH_CONNECTSTRING));

        try {
            using (System.IO.FileStream fs = System.IO.File.Open(Server.MapPath(WebConfig.SZ_PATH_INSTALLSQL + "/" + gstrTable + ".txt"), System.IO.FileMode.Open, System.IO.FileAccess.Read, System.IO.FileShare.ReadWrite)) {
                byte[] bs = new byte[fs.Length];
                fs.Read(bs, 0, (int)fs.Length);
                gstrContext = System.Text.Encoding.UTF8.GetString(bs);
            }
            using (Ly.Data.SQLClient Conn = new Ly.Data.SQLClient(gstrConnString)) {
                Conn.ExecuteNonQuery(gstrContext);
            }
            js.Message = "执行成功!";
            js.Refresh = 1;
        } catch (Exception ex) {
            js.Message = "执行发生异常:\\n" + ex.Message;
        }
        Response.Write(js.ToString());
        Response.End();
    }
}