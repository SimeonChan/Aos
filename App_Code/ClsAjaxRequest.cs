using System;
using System.Collections.Generic;
using System.Web;

/// <summary>
/// ClsAjaxRequest 的摘要说明
/// </summary>
public class ClsAjaxRequest : Ly.Formats.JsonObject {

    public class Arg : Ly.Formats.JsonObject {
        Ly.Formats.JsonObject Obj;

        /// <summary>
        /// 获取参数主对象
        /// </summary>
        public Ly.Formats.JsonObject Object { get { return Obj; } }

        private int gnID;
        private int gnUI;
        private int gnUID;
        private int gnUITool;
        private int gnUIMain;
        private int gnUITitle;
        private int gnUIPath;
        private int gnUIPage;

        private int gnProElementID;
        private int gnProID;

        private int gnDigElementID;
        private int gnDigID;

        private int gnPath;

        private void Init() {

            //Ly.Formats.JsonObject obj = base["Arg"];
            Obj["ID"].Value = "";
            Obj["UI"].Value = "";
            Obj["UI_ID"].Value = "";
            Obj["UI_Tool"].Value = "";
            Obj["UI_Main"].Value = "";
            Obj["UI_Title"].Value = "";
            Obj["UI_Path"].Value = "";
            Obj["UI_Page"].Value = "";

            Obj["Process_ElementID"].Value = "";
            Obj["Process_ID"].Value = "";
            Obj["Dialog_ElementID"].Value = "";
            Obj["Dialog_ID"].Value = "";

            Obj["Arg_Path"].Value = "";

            gnID = Obj.GetIndex("ID");
            gnUI = Obj.GetIndex("UI");
            gnUID = Obj.GetIndex("UI_ID");
            gnUITool = Obj.GetIndex("UI_Tool");
            gnUIMain = Obj.GetIndex("UI_Main");
            gnUITitle = Obj.GetIndex("UI_Title");
            gnUIPath = Obj.GetIndex("UI_Path");
            gnUIPage = Obj.GetIndex("UI_Page");

            gnProElementID = Obj.GetIndex("Process_ElementID");
            gnProID = Obj.GetIndex("Process_ID");
            gnDigElementID = Obj.GetIndex("Dialog_ElementID");
            gnDigID = Obj.GetIndex("Dialog_ID");

            gnPath = Obj.GetIndex("Arg_Path");
        }

        public Arg() {
            base["Arg"]["ID"].Value = "";
            Obj = base["Arg"];

            Init();

            this.Process_ElementID = "";
            this.Process_ID = "";
        }

        public Arg(ClsAjaxPage parent) {
            //parent.["Arg"]["ID"].Value = "";
            base["Arg"]["ID"].Value = "";
            Obj = base["Arg"];

            Init();

            this.Process_ElementID = parent.PageArgs.Process_ElementID;
            this.Process_ID = parent.PageArgs.Process_ID;

            this.Dialog_ElementID = parent.PageArgs.Dialog_ElementID;
            this.Dialog_ID = parent.PageArgs.Dialog_ID;

            this.UI = parent.PageArgs.UI;
            this.UID = parent.PageArgs.UID;
            this.UIMain = parent.PageArgs.UIMain;
            this.UITool = parent.PageArgs.UITool;
            this.UITitle = parent.PageArgs.UITitle;
            this.UIPath = parent.PageArgs.UIPath;

            this.Path = parent.PageArgs.Path;
        }

        public new string this[string name] {
            get { return Obj[name].Value; }
            set { Obj[name].Value = value; }
        }

        public new string this[int index] {
            get { return Obj[index].Value; }
            set { Obj[index].Value = value; }
        }

        public new string ToString() {
            return base.InnerJson;
        }

        /// <summary>
        /// 所属线程相关的界面类型
        /// </summary>
        public string UIPath {
            get { return this[gnUIPath]; }
            set { this[gnUIPath] = value; }
        }

        /// <summary>
        /// 所属线程相关的界面类型
        /// </summary>
        public string Path {
            get { return this[gnPath]; }
            set { this[gnPath] = value; }
        }

        /// <summary>
        /// 所属线程相关的界面类型
        /// </summary>
        public string Page {
            get { return this[gnUIPage]; }
            set { this[gnUIPage] = value; }
        }

        /// <summary>
        /// 所属线程相关的界面类型
        /// </summary>
        public string UI {
            get { return this[gnUI]; }
            set { this[gnUI] = value; }
        }

        /// <summary>
        /// 所属线程相关的界面识标符
        /// </summary>
        public string UID {
            get { return this[gnUID]; }
            set { this[gnUID] = value; }
        }

        /// <summary>
        /// 所属线程相关的界面工具栏识标符
        /// </summary>
        public string UITool {
            get { return this[gnUITool]; }
            set { this[gnUITool] = value; }
        }

        /// <summary>
        /// 所属线程相关的界面显示区域识标符
        /// </summary>
        public string UIMain {
            get { return this[gnUIMain]; }
            set { this[gnUIMain] = value; }
        }

        /// <summary>
        /// 所属线程相关的界面显示区域识标符
        /// </summary>
        public string UITitle {
            get { return this[gnUITitle]; }
            set { this[gnUITitle] = value; }
        }

        /// <summary>
        /// 进程识别号
        /// </summary>
        public String Process_ID { get { return this[gnProID]; } set { this[gnProID] = value; } }

        /// <summary>
        /// 进程元素识别号
        /// </summary>
        public String Process_ElementID { get { return this[gnProElementID]; } set { this[gnProElementID] = value; } }

        /// <summary>
        /// 进程识别号
        /// </summary>
        public String Dialog_ID { get { return this[gnDigID]; } set { this[gnDigID] = value; } }

        /// <summary>
        /// 进程元素识别号
        /// </summary>
        public String Dialog_ElementID { get { return this[gnDigElementID]; } set { this[gnDigElementID] = value; } }
    }

    public class TableArg : Arg {

        private int gnArgID;
        private int gnArgTable;
        private int gnArgTableDate;
        private int gnArgTableKey;
        private int gnArgRelation;
        private int gnArgRelationText;
        private int gnArgIndex;

        private void Init() {

            //Ly.Formats.JsonObject obj = base["Arg"];
            base.Object["Arg_ID"].Value = "";
            base.Object["Arg_Table"].Value = "";
            base.Object["Arg_Table_Date"].Value = "";
            base.Object["Arg_Table_Key"].Value = "";
            base.Object["Arg_Relation"].Value = "";
            base.Object["Arg_RelationText"].Value = "";
            base.Object["Arg_Index"].Value = "";

            gnArgID = base.Object.GetIndex("Arg_ID");
            gnArgTable = base.Object.GetIndex("Arg_Table");
            gnArgTableDate = base.Object.GetIndex("Arg_Table_Date");
            gnArgTableKey = base.Object.GetIndex("Arg_Table_Key");
            gnArgRelation = base.Object.GetIndex("Arg_Relation");
            gnArgRelationText = base.Object.GetIndex("Arg_RelationText");
            gnArgIndex = base.Object.GetIndex("Arg_Index");

        }

        public TableArg() {
            Init();
        }

        public TableArg(ClsAjaxPage parent) {
            Init();
            this.ArgID = parent.PageArgs.Arg_ID;
        }

        /// <summary>
        /// 参数：相关索引
        /// </summary>
        public string ArgIndex { get { return base.Object[gnArgIndex].Value; } set { base.Object[gnArgIndex].Value = value; } }

        /// <summary>
        /// 参数：相关表格关联名称
        /// </summary>
        public string ArgRelationText { get { return base.Object[gnArgRelationText].Value; } set { base.Object[gnArgRelationText].Value = value; } }

        /// <summary>
        /// 参数：相关表格关联
        /// </summary>
        public string ArgRelation { get { return base.Object[gnArgRelation].Value; } set { base.Object[gnArgRelation].Value = value; } }

        /// <summary>
        /// 参数：相关搜索关键字
        /// </summary>
        public string ArgTableKey { get { return base.Object[gnArgTableKey].Value; } set { base.Object[gnArgTableKey].Value = value; } }

        /// <summary>
        /// 参数：相关日期
        /// </summary>
        public string ArgTableDate { get { return base.Object[gnArgTableDate].Value; } set { base.Object[gnArgTableDate].Value = value; } }

        /// <summary>
        /// 参数：相关表格
        /// </summary>
        public string ArgTable { get { return base.Object[gnArgTable].Value; } set { base.Object[gnArgTable].Value = value; } }

        /// <summary>
        /// 参数：相关编号
        /// </summary>
        public int ArgID { get { return base.Object[gnArgID].ValueAsInteger; } set { base.Object[gnArgID].ValueAsInteger = value; } }
    }

    private String gstrValues = "";
    private String gstrStyles = "";
    private String gstrAjax = "";
    private string gszDebug = "";
    private string gszStorage = "";
    private string gszScripts = "";

    public ClsAjaxRequest() {
        //
        // TODO: 在此处添加构造函数逻辑
        //
        this.Message = "";
        this.Refresh = 0;
        this.Flag = 0;
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
    public Ly.Formats.JsonObject GetChild(string name) {
        return base[name];
    }

    public int Flag {
        get { return Ly.String.Source(base["Flag"].Value).toInteger; }
        set { base["Flag"].Value = value.ToString(); }
    }

    public String Message {
        get { return base["Message"].Value; }
        set { base["Message"].Value = value; }
    }

    public int Refresh {
        get { return Ly.String.Source(base["Refresh"].Value).toInteger; }
        set { base["Refresh"].Value = value.ToString(); }
    }

    /// <summary>
    /// 设置存储数据
    /// </summary>
    /// <param name="Content"></param>
    public void SetStorage(string key, string value) {
        base["Storage"].IsArray = true;
        Ly.Formats.JsonObject obj = base["Storage"].AppendChild("");
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
        Ly.Formats.JsonObject obj = base["Scripts"].AppendChild("");
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
        Ly.Formats.JsonObject obj = base["Debug"].AppendChild("");
        obj["Content"].Value = Content;
        obj["Line"].Value = "false";
        //using (Ly.IO.Json js = new Ly.IO.Json()) {
        //    js.Items["Content"].Value = Content;
        //    js.Items["Line"].Value = "false";
        //    if (gszDebug != "") gszDebug += ",";
        //    gszDebug += js.Object.ToString();
        //    base.Items["Debug"].Value = "[" + gszDebug + "]";
        //}
    }

    public void SetDebugLine(String Content) {
        base["Debug"].IsArray = true;
        Ly.Formats.JsonObject obj = base["Debug"].AppendChild("");
        obj["Content"].Value = Content;
        obj["Line"].Value = "true";
        //using (Ly.IO.Json js = new Ly.IO.Json()) {
        //    js.Items["Content"].Value = Content;
        //    js.Items["Line"].Value = "true";
        //    if (gszDebug != "") gszDebug += ",";
        //    gszDebug += js.Object.ToString();
        //    base.Items["Debug"].Value = "[" + gszDebug + "]";
        //}
    }

    public void SetStyle(String EId, String key, String value) {
        base["Styles"].IsArray = true;
        Ly.Formats.JsonObject obj = base["Styles"].AppendChild("");
        obj["ID"].Value = EId;
        obj["Key"].Value = key;
        obj["Value"].Value = value;
        //using (Ly.IO.Json js = new Ly.IO.Json()) {
        //    js.Items["ID"].Value = EId;
        //    js.Items["Key"].Value = key;
        //    js.Items["Value"].Value = value;
        //    if (gstrStyles != "") gstrStyles += ",";
        //    gstrStyles += js.Object.ToString();
        //    base.Items["Styles"].Value = "[" + gstrStyles + "]";
        //}
    }

    public void SetText(String key, String value) {
        base["Values"].IsArray = true;
        Ly.Formats.JsonObject obj = base["Values"].AppendChild("");
        obj["Type"].Value = "text";
        obj["ID"].Value = key;
        obj["Value"].Value = value;
        //using (Ly.IO.Json js = new Ly.IO.Json()) {
        //    js.Items["Type"].Value = "text";
        //    js.Items["ID"].Value = key;
        //    js.Items["Value"].Value = value;
        //    if (gstrValues != "") gstrValues += ",";
        //    gstrValues += js.Object.ToString();
        //    base.Items["Values"].Value = "[" + gstrValues + "]";
        //}
    }

    public void SetValue(String key, String value) {
        base["Values"].IsArray = true;
        Ly.Formats.JsonObject obj = base["Values"].AppendChild("");
        obj["Type"].Value = "value";
        obj["ID"].Value = key;
        obj["Value"].Value = value;
        //using (Ly.IO.Json js = new Ly.IO.Json()) {
        //    js.Items["Type"].Value = "value";
        //    js.Items["ID"].Value = key;
        //    js.Items["Value"].Value = value;
        //    if (gstrValues != "") gstrValues += ",";
        //    gstrValues += js.Object.ToString();
        //    base.Items["Values"].Value = "[" + gstrValues + "]";
        //}
    }

    public void SetAjaxLoad(String Id, String Url, Arg Arg) {
        SetAjaxLoad(Id, Url, Arg, "");
    }

    public void SetDialogClose(String Id) {
        base["Ajax"].IsArray = true;
        Ly.Formats.JsonObject obj = base["Ajax"].AppendChild("");
        obj["Type"].Value = "Close";
        obj["ID"].Value = Id;
        obj["Url"].Value = "";
        obj["Status"].Value = "";
        //using (Ly.IO.Json js = new Ly.IO.Json()) {
        //    js.Items["Type"].Value = "Page";
        //    js.Items["ID"].Value = "";
        //    js.Items["Url"].Value = Url;
        //    js.Items["Status"].Value = "";
        //    if (gstrAjax != "") gstrAjax += ",";
        //    gstrAjax += js.Object.ToString();
        //    base.Items["Ajax"].Value = "[" + gstrAjax + "]";
        //}
    }

    public void SetPageOpen(String Url) {
        base["Ajax"].IsArray = true;
        Ly.Formats.JsonObject obj = base["Ajax"].AppendChild("");
        obj["Type"].Value = "Page";
        obj["ID"].Value = "";
        obj["Url"].Value = Url;
        obj["Status"].Value = "";
        //using (Ly.IO.Json js = new Ly.IO.Json()) {
        //    js.Items["Type"].Value = "Page";
        //    js.Items["ID"].Value = "";
        //    js.Items["Url"].Value = Url;
        //    js.Items["Status"].Value = "";
        //    if (gstrAjax != "") gstrAjax += ",";
        //    gstrAjax += js.Object.ToString();
        //    base.Items["Ajax"].Value = "[" + gstrAjax + "]";
        //}
    }

    public void SetAjaxDialog(String ID, String TarID, String Title, String Width, String Height, String Path, String Page, Arg Arg) {
        base["Ajax"].IsArray = true;
        Ly.Formats.JsonObject obj = base["Ajax"].AppendChild("");
        obj.InnerJson = Arg.OuterJson;
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

    public void SetAjaxUI(String ID, String TarID, String Title, String Path, String Page, Arg Arg) {
        base["Ajax"].IsArray = true;
        Ly.Formats.JsonObject obj = base["Ajax"].AppendChild("");
        obj.InnerJson = Arg.OuterJson;
        obj["Type"].Value = "UI";
        obj["ID"].Value = ID;
        obj["TarID"].Value = TarID;
        obj["Title"].Value = Title;
        obj["Path"].Value = Path;
        obj["Page"].Value = Page;
        //Page.UI.Open(Obj.Ajax[i].ID, Obj.Ajax[i].TarID, Obj.Ajax[i].Title, Obj.Ajax[i].Path, Obj.Ajax[i].Page, Obj.Ajax[i].Arg);
    }

    public void SetAjaxLoad(String TarID, String Id, String Url, Arg Arg, string Status) {
        base["Ajax"].IsArray = true;
        Ly.Formats.JsonObject obj = base["Ajax"].AppendChild("");
        obj.InnerJson = Arg.OuterJson;
        obj["Type"].Value = "Load";
        obj["ID"].Value = Id;
        obj["TarID"].Value = TarID;
        obj["Url"].Value = Url;
        obj["Status"].Value = Status;
    }

    public void SetAjaxLoad(String Id, String Url, Arg Arg, string Status) {
        base["Ajax"].IsArray = true;
        Ly.Formats.JsonObject obj = base["Ajax"].AppendChild("");
        obj.InnerJson = Arg.OuterJson;
        obj["Type"].Value = "Load";
        obj["ID"].Value = Id;
        obj["TarID"].Value = "";
        obj["Url"].Value = Url;
        obj["Status"].Value = Status;
        //using (Ly.IO.Json js = new Ly.IO.Json()) {
        //    js.LoadFromString(Arg.ToString());
        //    js.Items["Type"].Value = "Load";
        //    js.Items["ID"].Value = Id;
        //    js.Items["Url"].Value = Url;
        //    js.Items["Status"].Value = Status;
        //    if (gstrAjax != "") gstrAjax += ",";
        //    gstrAjax += js.Object.ToString();
        //    base.Items["Ajax"].Value = "[" + gstrAjax + "]";
        //}
    }

    public void SetAjaxScript(String Url, Arg Arg) {
        base["Ajax"].IsArray = true;
        Ly.Formats.JsonObject obj = base["Ajax"].AppendChild("");
        obj.InnerJson = Arg.OuterJson;
        obj["Type"].Value = "Script";
        obj["ID"].Value = "";
        obj["TarID"].Value = "";
        obj["Url"].Value = Url;
        obj["Status"].Value = "";
    }

    public void SetAjaxScript(String TarID, String Url, Arg Arg) {
        base["Ajax"].IsArray = true;
        Ly.Formats.JsonObject obj = base["Ajax"].AppendChild("");
        obj.InnerJson = Arg.OuterJson;
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