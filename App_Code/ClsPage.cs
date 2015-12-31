using System;
using System.Data;
using System.Configuration;
using System.Web;
using System.Web.Security;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.UI.WebControls.WebParts;
using System.Web.UI.HtmlControls;

/// <summary>
/// ClsPage 的摘要说明
/// </summary>
public class ClsPage : System.Web.UI.Page {

    private long glngAuthorizeID;
    private string gstrSessionID;

    private string gszBaseConnectString = "";//基础数据库连接，如Aos_Manage
    private string gszDataConnectString = "";//分支数据库连接，如Aos_Manage_2015
    private string gszAosConnectString = "";//系统数据库连接，一般为Aos
    private string gszUpdateConnectString = "";//更新分支数据库连接的临时连接，一般为master

    private ClsSession gSession;
    private WebConfig gConfig;
    //private Ly.DB.Dream.SystemUsers.ExecutionExp gUsers;
    private dyk.DB.Base.SystemUsers.ExecutionExp gUser;
    private string gszIP;

    public ClsPage() {
        //
        // TODO: 在此处添加构造函数逻辑
        //
    }

    /// <summary>
    /// 系统设定集
    /// </summary>
    public WebConfig WebConfig{
        get { return gConfig; }
    }

    protected override void OnInit(EventArgs e) {
        base.OnInit(e);
        gstrSessionID = "";



        //if (base.Request.Cookies["ASP.NET_SessionId"] != null) gstrSessionID = base.Request.Cookies["ASP.NET_SessionId"].Value;
        //base.Response.AddHeader("<Debug>Cookie_Old", SessionID);
        ////base.Response.Cookies["ASP.NET_SessionId_Request"].Value = base.Request.Headers.Count.ToString();
        //for (int i = 0; i < base.Request.Headers.Count; i++) {
        //    string szName = base.Request.Headers.GetKey(i);
        //    string szDebug = "<Debug>" + base.Request.Headers.GetKey(i);
        //    string szValue = "";
        //    if (szName == "Azalea_SessionID") {
        //        for (int j = 0; j < base.Request.Headers.GetValues(i).Length; j++) {
        //            string sVal = base.Request.Headers.GetValues(i)[j];
        //            szValue += sVal;
        //        }
        //        gstrSessionID = szValue;
        //    }
        //    //base.Response.Write(base.Request.Headers.GetKey(i) + ":");

        //    base.Response.AddHeader(szDebug, szValue);
        //}

        if (gstrSessionID == "") {
            gstrSessionID = Pub.Request(this, "Azalea_SessionID");
        }

        glngAuthorizeID = dyk.Type.String.New(Pub.Request(this, "Azalea_AuthID")).ToNumber;

        //    //base.Response.Write(base.Request.Headers.GetKey(i) + ":");
        //    for (int j = 0; j < base.Request.Headers.GetValues(i).Length; j++) {
        //        //base.Response.Write("[" + j + "]" + base.Request.Headers.GetValues(i)[j]);
        //        //base.Response.AddHeader("<Debug>Request_" + base.Request.Headers.GetKey(i) + "[" + j + "]", base.Request.Headers.GetValues(i)[j]);
        //        if (base.Request.Headers.GetKey(i).ToLower() == "cookie") {
        //            //base.Response.AddHeader("<Debug>Cookie", "Found");
        //            string sVal = base.Request.Headers.GetValues(i)[j];
        //            string[] sVals = sVal.Split(';');
        //            //base.Response.AddHeader("<Debug>Cookie", sVals.Length.ToString());
        //            for (int s = 0; s < sVals.Length; s++) {
        //                if (sVals[s].Trim() != "") {
        //                    string[] sSubVals = sVals[s].Split('=');
        //                    if (sSubVals.Length == 2) {
        //                        string sName = sSubVals[0].Trim(',').Trim().ToLower();
        //                        string sTemp = "";
        //                        //base.Response.AddHeader("<Debug>Cookie", "Found\"=\"");
        //                        for (int n = 0; n < sName.Length; n++) {
        //                            sTemp += "[" + sName[n] + "," + (int)sName[n] + "]";
        //                        }
        //                        base.Response.AddHeader("<Debug>Cookie[" + s + "]", sTemp);
        //                        if (sName == "asp.net_sessionid") {
        //                            base.Response.AddHeader("<Debug>Cookie", sSubVals[1].Trim());
        //                            gstrSessionID = sSubVals[1].Trim();
        //                        }
        //                    }
        //                }
        //            }
        //        }
        //    }
        //base.Response.Write("\n");
        //}

        if (gstrSessionID == "") gstrSessionID = Guid.NewGuid().ToString().Replace("-", "");

        //base.Session.SessionID = SessionID;
        //base.Response.Cookies["ASP.NET_SessionId"].Value = gstrSessionID;
        //base.Response.AddHeader("<Debug>Cookie_New", gstrSessionID);

        //gstrConnectString = Pub.IO.ReadAllText(base.Server.MapPath(WebConfig.SZ_PATH_CONNECTSTRING));

        //读取数据库连接设定
        string szConnJson = dyk.IO.File.DisplacementUTF8.ReadAllText(Server.MapPath(WebConfig.SZ_FILE_CONNECTION), true);

        string szHost = "";
        string szName = "";
        string szPwd = "";

        using (dyk.Format.XML json = new dyk.Format.XML(szConnJson)) {
            szHost = json["sqlserver.source"].InnerText;
            szName = json["sqlserver.user"].InnerText;
            szPwd = json["sqlserver.password"].InnerText;
        }

        //gszConnectString = Pub.IO.ReadAllText(base.Server.MapPath(WebConfig.SZ_PATH_CONNECTSTRING));
        gszAosConnectString = "data source=" + szHost + ";user id=" + szName + ";Password=" + szPwd + ";Initial Catalog=Aos";

        //生成数据表连接
        using (dyk.DB.Aos.AosAuthorize.ExecutionExp aa = new dyk.DB.Aos.AosAuthorize.ExecutionExp(gszAosConnectString)) {
            if (aa.GetDataByID(glngAuthorizeID)) {
                if (aa.Structure.DBIP != "") {
                    gszBaseConnectString = "data source=" + aa.Structure.DBIP + ";user id=" + aa.Structure.DBUser + ";Password=" + aa.Structure.DBPwd + ";Initial Catalog=Aos_" + aa.Structure.DBSign;
                    gszDataConnectString = "data source=" + aa.Structure.DBIP + ";user id=" + aa.Structure.DBUser + ";Password=" + aa.Structure.DBPwd + ";Initial Catalog=Aos_" + aa.Structure.DBSign + "_" + DateTime.Now.Year;
                    gszUpdateConnectString = "data source=" + aa.Structure.DBIP + ";user id=" + aa.Structure.DBUser + ";Password=" + aa.Structure.DBPwd + ";Initial Catalog=master";
                } else {
                    gszBaseConnectString = "data source=" + szHost + ";user id=" + szName + ";Password=" + szPwd + ";Initial Catalog=Aos_" + aa.Structure.DBSign;
                    gszDataConnectString = "data source=" + szHost + ";user id=" + szName + ";Password=" + szPwd + ";Initial Catalog=Aos_" + aa.Structure.DBSign + "_" + DateTime.Now.Year;
                    gszUpdateConnectString = "data source=" + szHost + ";user id=" + szName + ";Password=" + szPwd + ";Initial Catalog=master";
                }
            }
        }

        //建立本年份的分支数据库
        string dbPath = "";

        //读取数据库保存地址
        string szFileSetting = Server.MapPath(WebConfig.SZ_FILE_SETTING);
        string szSetting = dyk.IO.File.UTF8.ReadAllText(szFileSetting, true);
        using (dyk.Format.XML xml = new dyk.Format.XML(szSetting)) {
            dbPath = xml["Database.SavePath"].InnerText;
        }

        //生成Aos库
        using (dyk.Database.SQLClient Conn = new dyk.Database.SQLClient(gszUpdateConnectString)) {
            string szSql = "if not exists(select * from sysdatabases where name='Aos_Manage_" + DateTime.Now.Year + "')";
            szSql += "create database [Aos_Manage_" + DateTime.Now.Year + "]";
            szSql += "on  primary (";
            szSql += "name='Aos_Manage_" + DateTime.Now.Year + "_data',";
            szSql += "filename='" + dbPath + "\\Aos_Manage_" + DateTime.Now.Year + ".mdf',";
            szSql += "size=5mb,";
            szSql += "filegrowth=15%)";
            szSql += "log on (";
            szSql += "name='Aos_Manage_" + DateTime.Now.Year + "_log',";
            szSql += "filename='" + dbPath + "\\Aos_Manage_" + DateTime.Now.Year + "_log.ldf',";
            szSql += "size=2mb,";
            szSql += "filegrowth=1mb)";
            Conn.ExecuteNonQuery(szSql);
        }

        gszIP = System.Web.HttpContext.Current.Request.UserHostAddress;

        gSession = new ClsSession(gszAosConnectString, gstrSessionID, glngAuthorizeID, gszIP);

        //gUsers = new Ly.DB.Dream.SystemUsers.ExecutionExp(gstrConnectString);
        gUser = new dyk.DB.Base.SystemUsers.ExecutionExp(gszBaseConnectString);
        gUser.GetDataByName(gSession.Manager);

        gConfig = new WebConfig(this);

    }

    /// <summary>
    /// 申请一个全新的会话识标符
    /// </summary>
    public void CreateNewSessionID() {
        gstrSessionID = gSession.CreateNewSessionID();
    }

    /// <summary>
    /// 当前用户信息
    /// </summary>
    public dyk.DB.Base.SystemUsers.Structrue UserInfo { get { return gUser.Structure; } }

    /// <summary>
    /// 获取临时会话信息管理ID
    /// </summary>
    public String SessionID {
        get { return gstrSessionID; }
    }

    /// <summary>
    /// 获取授权编号
    /// </summary>
    public long AuthorizeID { get { return glngAuthorizeID; } }

    /// <summary>
    /// 获取临时会话信息管理
    /// </summary>
    public new ClsSession Session {
        get { return gSession; }
    }

    /// <summary>
    /// 获取页面Request的值
    /// </summary>
    /// <param name="name"></param>
    /// <returns></returns>
    public string this[string name] {
        get { return Pub.Request(this, name); }
    }

    /// <summary>
    /// 获取基础数据库连接字符串
    /// </summary>
    public string ConnectString {
        get { return gszBaseConnectString; }
    }

    /// <summary>
    /// 获取系统数据库连接字符串
    /// </summary>
    public string AosConnectString {
        get { return gszAosConnectString; }
    }

    /// <summary>
    /// 获取基础数据库连接字符串
    /// </summary>
    public string BaseConnectString {
        get { return gszBaseConnectString; }
    }

    /// <summary>
    /// 获取分支数据库连接字符串
    /// </summary>
    public string DataConnectString {
        get { return gszDataConnectString; }
    }

    /// <summary>
    /// 获取客户端IP地址
    /// </summary>
    public string IPAddress {
        get { return gszIP; }
    }

}
