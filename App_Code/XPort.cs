using System;
using System.Collections.Generic;
using System.Web;

/// <summary>
/// X 的摘要说明
/// </summary>
public class XPort : dyk.Format.Json {

    public class UIArgs : dyk.Format.Json {

        private ClsPage gParent;
        //        ID:
        //public string ID { get { return base["ID"]} }
        //UI:Window
        public string UI { get { return base["UI"].Value; } set { base["UI"].Value = value; } }
        //UI_ID:Auth
        public string UI_ID { get { return base["UI_ID"].Value; } set { base["UI_ID"].Value = value; } }
        //UI_Tool:Win_Auth_Tool
        public string UI_Tool { get { return base["UI_Tool"].Value; } set { base["UI_Tool"].Value = value; } }
        //UI_Main:Win_Auth_Main
        public string UI_Main { get { return base["UI_Main"].Value; } set { base["UI_Main"].Value = value; } }
        //UI_Title:我的应用
        public string UI_Title { get { return base["UI_Title"].Value; } set { base["UI_Title"].Value = value; } }
        //UI_Path:/Files/App/Aos/Auth/
        public string UI_Path { get { return base["UI_Path"].Value; } set { base["UI_Path"].Value = value; } }
        //UI_Page:
        public string UI_Page { get { return base["UI_Page"].Value; } set { base["UI_Page"].Value = value; } }
        //Process_ElementID:Win_Auth
        public string Process_ElementID { get { return base["Process_ElementID"].Value; } set { base["Process_ElementID"].Value = value; } }
        //Process_ID:Auth
        public string Process_ID { get { return base["Process_ID"].Value; } set { base["Process_ID"].Value = value; } }
        //Dialog_ElementID:
        public string Dialog_ElementID { get { return base["Dialog_ElementID"].Value; } set { base["Dialog_ElementID"].Value = value; } }
        //Dialog_ID:
        public string Dialog_ID { get { return base["Dialog_ID"].Value; } set { base["Dialog_ID"].Value = value; } }
        //Arg_Path:/Files/App/Aos/Auth/
        public string Arg_Path { get { return base["Arg_Path"].Value; } set { base["Arg_Path"].Value = value; } }
        //Azalea_SessionID:2b919d2701c242de99893f6214ce5863
        public string Azalea_SessionID { get { return base["Azalea_SessionID"].Value; } set { base["Azalea_SessionID"].Value = value; } }
        //Azalea_AuthID:1
        public string Azalea_AuthID { get { return base["Azalea_AuthID"].Value; } set { base["Azalea_AuthID"].Value = value; } }
        //Azalea_Rnd:0.5295852662529796
        public string Azalea_Rnd { get { return base["Azalea_Rnd"].Value; } set { base["Azalea_Rnd"].Value = value; } }

        private void Init() {
            gParent = null;
            this.UI = "";
            this.UI_ID = "";
            this.UI_Main = "";
            this.UI_Page = "";
            this.UI_Path = "";
            this.UI_Title = "";
            this.UI_Tool = "";
            this.Arg_Path = "";
            this.Azalea_AuthID = "";
            this.Azalea_Rnd = "";
            this.Azalea_SessionID = "";
            this.Dialog_ElementID = "";
            this.Dialog_ID = "";
            this.Process_ElementID = "";
            this.Process_ID = "";
        }

        public UIArgs(ClsPage parent) {
            Init();
            gParent = parent;

            for (int i = 0; i < base.Count; i++) {
                base[i].Value = parent[base[i].Name];
            }
        }
    }

    public XPort() {
        //
        // TODO: 在此处添加构造函数逻辑
        //
        this.Message = "";
        this.Refresh = 0;
        this.Flag = 0;
        this.Page = "";
        this.Information = "";
        base["Values"].Value = "";
        base["Styles"].Value = "";
        base["Ajax"].Value = "";
        base["Debug"].Value = "";
        base["Storage"].Value = "";
        base["Scripts"].Value = "";
    }

    /// <summary>
    /// 获取子对象
    /// </summary>
    /// <param name="name"></param>
    /// <returns></returns>
    public dyk.Format.JsonObject GetChild(string name) {
        return base[name];
    }

    public int Flag
    {
        get { return Ly.String.Source(base["Flag"].Value).toInteger; }
        set { base["Flag"].Value = value.ToString(); }
    }

    public String Message
    {
        get { return base["Message"].Value; }
        set { base["Message"].Value = value; }
    }

    /// <summary>
    /// 获取或设置提示信息
    /// </summary>
    public String Information
    {
        get { return base["Information"].Value; }
        set { base["Information"].Value = value; }
    }

    public int Refresh
    {
        get { return Ly.String.Source(base["Refresh"].Value).toInteger; }
        set { base["Refresh"].Value = value.ToString(); }
    }

    public String Page
    {
        get { return base["Page"].Value; }
        set { base["Page"].Value = value; }
    }

    /// <summary>
    /// 设置存储数据
    /// </summary>
    /// <param name="Content"></param>
    public void SetUIStorage(UIArgs Args) {
        base["Storage"].IsArray = true;
        string szUID = Args.UI_ID;
        for (int i = 0; i < Args.Count; i++) {
            dyk.Format.JsonObject obj = base["Storage"].AppendChild("");
            obj["Key"].Value = szUID + "_" + Args[i].Name;
            obj["Value"].Value = Args[i].Value;
        }
        //dyk.Format.JsonObject obj = base["Storage"].AppendChild("");
        //obj["Key"].Value = key;
        //obj["Value"].Value = value;
        //base["Storage"].AppendChild(key, value);
    }

    /// <summary>
    /// 设置存储数据
    /// </summary>
    /// <param name="Content"></param>
    public void SetStorage(string key, string value) {
        base["Storage"].IsArray = true;
        dyk.Format.JsonObject obj = base["Storage"].AppendChild("");
        obj["Key"].Value = key;
        obj["Value"].Value = value;
        //base["Storage"].AppendChild(key, value);
    }

    /// <summary>
    /// 设置存储数据
    /// </summary>
    /// <param name="Content"></param>
    public void SetScript(string id, string src) {
        base["Scripts"].IsArray = true;
        dyk.Format.JsonObject obj = base["Scripts"].AppendChild("");
        obj["ID"].Value = id;
        obj["Src"].Value = src;
        //using (Ly.IO.Json js = new Ly.IO.Json()) {
        //    js.Items["ID"].Value = id;
        //    js.Items["Src"].Value = src;
        //    if (gszScripts != "") gszScripts += ",";
        //    gszScripts += js.Object.ToString();
        //    base.Items["Scripts"].Value = "[" + gszScripts + "]";
        //}
    }

    /// <summary>
    /// 设置调试输出
    /// </summary>
    /// <param name="Content"></param>
    public void SetDebug(String Content) {
        base["Debug"].IsArray = true;
        dyk.Format.JsonObject obj = base["Debug"].AppendChild("");
        obj["Content"].Value = Content;
        obj["Line"].Value = "false";
    }

    public void SetDebugLine(String Content) {
        base["Debug"].IsArray = true;
        dyk.Format.JsonObject obj = base["Debug"].AppendChild("");
        obj["Content"].Value = Content;
        obj["Line"].Value = "true";
    }

    public void SetStyle(String EId, String key, String value) {
        base["Styles"].IsArray = true;
        dyk.Format.JsonObject obj = base["Styles"].AppendChild("");
        obj["ID"].Value = EId;
        obj["Key"].Value = key;
        obj["Value"].Value = value;
    }

    public void SetText(String key, String value) {
        base["Values"].IsArray = true;
        dyk.Format.JsonObject obj = base["Values"].AppendChild("");
        obj["Type"].Value = "text";
        obj["ID"].Value = key;
        obj["Value"].Value = value;
    }

    public void SetValue(String key, String value) {
        base["Values"].IsArray = true;
        dyk.Format.JsonObject obj = base["Values"].AppendChild("");
        obj["Type"].Value = "value";
        obj["ID"].Value = key;
        obj["Value"].Value = value;
    }

    public void SetAjaxLoad(String Id, String Url, dyk.Format.Json Arg) {
        SetAjaxLoad(Id, Url, Arg, "");
    }

    public void SetDialogClose(String Id) {
        base["Ajax"].IsArray = true;
        dyk.Format.JsonObject obj = base["Ajax"].AppendChild("");
        obj["Type"].Value = "Close";
        obj["ID"].Value = Id;
        obj["Url"].Value = "";
        obj["Status"].Value = "";
    }

    public void SetPageOpen(String Url) {
        base["Ajax"].IsArray = true;
        dyk.Format.JsonObject obj = base["Ajax"].AppendChild("");
        obj["Type"].Value = "Page";
        obj["ID"].Value = "";
        obj["Url"].Value = Url;
        obj["Status"].Value = "";
    }

    public void SetAjaxDialog(String ID, String TarID, String Title, String Width, String Height, String Path, String Page, dyk.Format.Json Arg) {
        base["Ajax"].IsArray = true;
        dyk.Format.JsonObject obj = base["Ajax"].AppendChild("");
        obj["Arg"].InnerJson = Arg.OuterJson;
        obj["Type"].Value = "UI";
        obj["ID"].Value = ID;
        obj["TarID"].Value = TarID;
        obj["Title"].Value = Title;
        obj["Width"].Value = Width;
        obj["Height"].Value = Height;
        obj["Path"].Value = Path;
        obj["Page"].Value = Page;
        //Page.UI.Open(Obj.Ajax[i].ID, Obj.Ajax[i].TarID, Obj.Ajax[i].Title, Obj.Ajax[i].Path, Obj.Ajax[i].Page, Obj.Ajax[i].Arg);
    }

    public void SetAjaxUI(String ID, String TarID, String Title, String Path, String Page, dyk.Format.Json Arg) {
        base["Ajax"].IsArray = true;
        dyk.Format.JsonObject obj = base["Ajax"].AppendChild("");
        obj["Arg"].InnerJson = Arg.OuterJson;
        obj["Type"].Value = "UI";
        obj["ID"].Value = ID;
        obj["TarID"].Value = TarID;
        obj["Title"].Value = Title;
        obj["Path"].Value = Path;
        obj["Page"].Value = Page;
        //Page.UI.Open(Obj.Ajax[i].ID, Obj.Ajax[i].TarID, Obj.Ajax[i].Title, Obj.Ajax[i].Path, Obj.Ajax[i].Page, Obj.Ajax[i].Arg);
    }

    public void SetAjaxLoad(String TarID, String Id, String Url, dyk.Format.Json Arg, string Status) {
        base["Ajax"].IsArray = true;
        dyk.Format.JsonObject obj = base["Ajax"].AppendChild("");
        obj["Arg"].InnerJson = Arg.OuterJson;
        obj["Type"].Value = "Load";
        obj["ID"].Value = Id;
        obj["TarID"].Value = TarID;
        obj["Url"].Value = Url;
        obj["Status"].Value = Status;
    }

    public void SetAjaxLoad(String Id, String Url, dyk.Format.Json Arg, string Status) {
        base["Ajax"].IsArray = true;
        dyk.Format.JsonObject obj = base["Ajax"].AppendChild("");
        obj["Arg"].InnerJson = Arg.OuterJson;
        obj["Type"].Value = "Load";
        obj["ID"].Value = Id;
        obj["TarID"].Value = "";
        obj["Url"].Value = Url;
        obj["Status"].Value = Status;
    }

    public void SetAjaxScript(String Url, dyk.Format.Json Arg) {
        base["Ajax"].IsArray = true;
        dyk.Format.JsonObject obj = base["Ajax"].AppendChild("");
        obj["Arg"].InnerJson = Arg.OuterJson;
        obj["Type"].Value = "Script";
        obj["ID"].Value = "";
        obj["TarID"].Value = "";
        obj["Url"].Value = Url;
        obj["Status"].Value = "";
    }

    public void SetAjaxScript(String TarID, String Url, dyk.Format.Json Arg) {
        base["Ajax"].IsArray = true;
        dyk.Format.JsonObject obj = base["Ajax"].AppendChild("");
        obj["Arg"].InnerJson = Arg.OuterJson;
        obj["Type"].Value = "Script";
        obj["ID"].Value = "";
        obj["TarID"].Value = TarID;
        obj["Url"].Value = Url;
        obj["Status"].Value = "";
    }

    public new string ToString() {
        return base.OuterJson;
    }
}