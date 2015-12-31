using System;
using System.Collections.Generic;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class Files_App_Install_Install : Page {
    protected String gstrPath;
    protected String gstrFullPath;
    protected Ly.IO.JsonFile gJson;
    protected int gintDB;
    protected Ly.Data.SQLClient gConn;
    protected String gstrConnString;
    protected Ly.Formats.Json gJsonList;

    protected int gnStep;

    protected void Page_Load(object sender, EventArgs e) {

        gnStep = 0;

        #region [=====读取数据库连接，如无法连接，则进入第一步=====]

        string szFileConnection = Server.MapPath(WebConfig.SZ_FILE_CONNECTION);
        string szConnJson = dyk.IO.File.DisplacementUTF8.ReadAllText(szFileConnection, true);

        //Response.Write(szConnJson);

        string szHost = "";
        string szName = "";
        string szPwd = "";

        using (dyk.Format.XML json = new dyk.Format.XML(szConnJson)) {
            szHost = json["sqlserver.source"].InnerText;
            szName = json["sqlserver.user"].InnerText;
            szPwd = json["sqlserver.password"].InnerText;
        }

        gstrConnString = "data source=" + szHost + ";user id=" + szName + ";Password=" + szPwd + ";Initial Catalog=master";

        if (szHost == "") {
            gnStep = 1;
            return;
        }

        try {
            using (dyk.Database.SQLClient Conn = new dyk.Database.SQLClient(gstrConnString)) {
                Conn.ExecuteReader("select 1");
            }
        } catch {
            gnStep = 1;
            return;
        }

        #endregion

        #region [=====读取Aos数据库设置，如无则进入第二步=====]

        using (dyk.Database.SQLClient Conn = new dyk.Database.SQLClient(gstrConnString)) {
            Conn.ExecuteReader("select * from sysdatabases where name='Aos'");
            if (!Conn.DataReader.Read()) {
                gnStep = 2;
                return;
            }
        }

        #endregion

        #region [=====读取Aos_Manage数据库设置，如无则进入第二步=====]

        using (dyk.Database.SQLClient Conn = new dyk.Database.SQLClient(gstrConnString)) {
            Conn.ExecuteReader("select * from sysdatabases where name='Aos_Manage'");
            if (!Conn.DataReader.Read()) {
                gnStep = 3;
                return;
            }
        }

        #endregion
    }
}