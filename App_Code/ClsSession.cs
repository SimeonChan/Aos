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
/// ClsSession 的摘要说明
/// </summary>
public class ClsSession : IDisposable {
    public const int TimeOut = 60;
    private string gstrSessionID;
    private string gstrConnectString;
    private long glngAuthorizeID;
    private string gszIP;

    public ClsSession(string connstr, string SessionID, long AuthorizeID, string IP) {
        //
        // TODO: 在此处添加构造函数逻辑
        //
        gstrConnectString = connstr;
        gstrSessionID = SessionID;
        glngAuthorizeID = AuthorizeID;
        gszIP = IP;

    }

    /// <summary>
    /// 创建新的SessionID
    /// </summary>
    /// <returns></returns>
    public string CreateNewSessionID() {
        gstrSessionID = Guid.NewGuid().ToString().Replace("-", "");
        return gstrSessionID;
    }

    public string this[string name] {
        get { return GetValue(name); }
        set { SetValue(name, value); }
    }

    public string Manager {
        get { return GetValue("Manager"); }
        set { SetValue("Manager", value); }
    }

    /// <summary>
    /// 获取Session内容
    /// </summary>
    /// <param name="name"></param>
    /// <returns></returns>
    private string GetValue(string name) {
        string res = "";
        using (dyk.DB.Aos.AosSessions.ExecutionExp su = new dyk.DB.Aos.AosSessions.ExecutionExp(gstrConnectString)) {
            if (su.GetSessionData(glngAuthorizeID, gstrSessionID, gszIP, name)) {
                string sTime = su.Structure.Time;
                string sValue = su.Structure.Value;
                DateTime dt = DateTime.Now;
                if (DateTime.TryParse(sTime, out dt)) {
                    TimeSpan ts = DateTime.Now - dt;
                    if (ts.TotalMinutes <= TimeOut) {
                        res = sValue;
                        su.Structure.Time = dyk.Type.Time.Now.ToString;
                        su.UpdateByID();
                    } else {
                        su.DeleteByID();
                    }
                } else {
                    su.DeleteByID();
                }
            }
            return res;
        }
    }

    /// <summary>
    /// 设置Session内容
    /// </summary>
    /// <param name="name"></param>
    /// <param name="value"></param>
    private void SetValue(string name, string value) {

        using (dyk.DB.Aos.AosSessions.ExecutionExp su = new dyk.DB.Aos.AosSessions.ExecutionExp(gstrConnectString)) {
            if (su.GetSessionData(glngAuthorizeID, gstrSessionID, gszIP, name)) {
                su.Structure.Time = dyk.Type.Time.Now.ToString;
                su.Structure.Value = value;
                su.UpdateByID();
            } else {
                su.Structure.AuthID = glngAuthorizeID;
                su.Structure.Name = name;
                su.Structure.SessionID = gstrSessionID;
                su.Structure.Time = dyk.Type.Time.Now.ToString;
                su.Structure.Value = value;
                su.Structure.IP = gszIP;
                su.Add();
            }
        }

    }

    #region IDisposable 成员

    public void Dispose() {
        //throw new Exception("The method or operation is not implemented.");
    }

    #endregion
}
