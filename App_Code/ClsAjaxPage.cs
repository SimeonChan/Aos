using System;
using System.Collections.Generic;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

/// <summary>
/// AjaxPage 的摘要说明
/// </summary>
public class ClsAjaxPage : IDisposable {
    private ClsPage gOwer;
    private bool gFinish;

    private string gszSessionID;

    private ClsAjaxPageArgs gPageArgs;
    private ClsAjaxRequest gPageRequest;
    private XPort gXPort;
    private XPort.UIArgs gXPortArgs;

    public ClsAjaxPage(ClsPage owner) {
        //
        // TODO: 在此处添加构造函数逻辑
        //
        gOwer = owner;
        gFinish = false;
        gOwer.Response.Clear();

        gPageArgs = new ClsAjaxPageArgs();

        for (int i = 0; i < gPageArgs.Object.Count; i++) {
            gPageArgs.Object[i].Value = gOwer[gPageArgs.Object[i].Name];
        }

        gPageRequest = new ClsAjaxRequest();

        gXPort = new XPort();
        gXPortArgs = new XPort.UIArgs(owner);

        gszSessionID = gPageArgs.SessionID;

        if (gszSessionID == "") {
            gszSessionID = Guid.NewGuid().ToString();
            gPageRequest.SetStorage("Azalea_SessionID", gszSessionID);
        }

    }

    /// <summary>
    /// 获取页面参数信息
    /// </summary>
    public XPort.UIArgs XPortArgs
    {
        get { return gXPortArgs; }
    }

    /// <summary>
    /// 获取页面反馈对象
    /// </summary>
    public XPort XPort
    {
        get { return gXPort; }
    }

    /// <summary>
    /// 获取页面参数信息
    /// </summary>
    public ClsAjaxPageArgs PageArgs
    {
        get { return gPageArgs; }
    }

    /// <summary>
    /// 获取页面反馈对象
    /// </summary>
    public ClsAjaxRequest PageRequest
    {
        get { return gPageRequest; }
    }

    /// <summary>
    /// 获取临时会话信息管理
    /// </summary>
    public ClsSession Session
    {
        get { return gOwer.Session; }
    }

    /// <summary>
    /// 获取页面Request的值
    /// </summary>
    /// <param name="name"></param>
    /// <returns></returns>
    public string this[string name]
    {
        get { return Pub.Request(gOwer, name); }
    }

    public Page Page
    {
        get { return gOwer; }
    }

    /// <summary>
    /// 输出Json交互字符串
    /// </summary>
    public void OutPutJsonRequest() {
        gOwer.Response.Write(gPageRequest.ToString());
    }

    /// <summary>
    /// 输出XPort交互字符串
    /// </summary>
    public void OutPutXPort() {
        gOwer.Response.Write(gXPort.ToString());
    }

    public void OutPutAsText(String cnt) {
        this.OutPut(cnt.Replace("<", "&lt;").Replace(">", "&gt;"));
    }

    public void OutPut(String cnt) {
        gOwer.Response.Write(cnt);
    }

    public void Finish() {
        gOwer.Response.End();
        gFinish = true;
    }

    public void Dispose() {
        if (!gFinish) gOwer.Response.End();
        //throw new NotImplementedException();
    }
}