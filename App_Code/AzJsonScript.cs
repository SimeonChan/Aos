/*
 * Azalea Web OS Json脚本执行专用类
 * 当前版本:1.0.003
 * 更新日期:2014-12-19
 */


using System;
using System.Collections.Generic;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

/// <summary>
/// AzSQLScript 的摘要说明
/// </summary>
public class AzJsonScript : Ly.DB.Dream.AzTables {
    //Azalea平台专用Json类
    public class AzJson : Ly.Formats.Json {
        public class AzFormValues {
            private AzJson gJson;

            public AzFormValues(AzJson json) {
                gJson = json;
            }

            public string this[string name] {
                get { return gJson.Object["AzFormValues"][name].Value; }
                set { gJson.Object["AzFormValues"][name].Value = value; }
            }
        }

        private AzFormValues gForm;

        public AzJson() {
            this.Init();
        }

        public AzJson(string str) {
            base.Object.SetChildrenByJsonString(str);
            this.Init();
        }

        private void Init() {
            gForm = new AzFormValues(this);
        }

        /// <summary>
        /// 获取表单数据获取器
        /// </summary>
        public AzFormValues FormValues {
            get { return gForm; }
        }

        public Ly.Formats.JsonUnitPoint Bindings {
            get { return this["Bindings"]; }
        }

        /// <summary>
        /// 未读取值时的选值
        /// </summary>
        public string Null {
            get { return this["Null"].Value; }
            set { this["Null"].Value = value; }
        }

        /// <summary>
        /// 执行类型
        /// </summary>
        public string Type {
            get { return this["Type"].Value; }
            set { this["Type"].Value = value; }
        }

        /// <summary>
        /// 绑定数据
        /// </summary>
        public string Binding {
            get { return this["Binding"].Value; }
            set { this["Binding"].Value = value; }
        }

        /// <summary>
        /// 默认表
        /// </summary>
        public string DefaultTable {
            get { return this["DefaultTable"].Value; }
            set { this["DefaultTable"].Value = value; }
        }

        /// <summary>
        /// 表集合
        /// </summary>
        public string Tables {
            get { return this["Tables"].Value; }
            set { this["Tables"].Value = value; }
        }

        /// <summary>
        /// 列集合
        /// </summary>
        public string Columns {
            get { return this["Columns"].Value; }
            set { this["Columns"].Value = value; }
        }

        /// <summary>
        /// 条件
        /// </summary>
        public string Premise {
            get { return this["Premise"].Value; }
            set { this["Premise"].Value = value; }
        }

        /// <summary>
        /// 排序方式
        /// </summary>
        public string Order {
            get { return this["Order"].Value; }
            set { this["Order"].Value = value; }
        }

        public new string ToString() {
            return base.Object.ToString();
        }
    }

    private Page gOwer;
    private AzJson gJson;
    private string gstrConn;
    private StructureCollection gSC;
    private AzValues gVal;
    //private string gstrDefaultTable;
    //private long glngDefaultTable;
    private Ly.IO.Json gCache;

    #region <==========实例化==========>
    public AzJsonScript(Page owner, string connstr, AzJson json)
        : base(connstr) {
        //
        // TODO: 在此处添加构造函数逻辑
        //

        gJson = json;
        gOwer = owner;
        gstrConn = connstr;
        this.Init();
    }

    public AzJsonScript(Page owner, string connstr, string json)
        : base(connstr) {
        //
        // TODO: 在此处添加构造函数逻辑
        //

        gJson = new AzJson(json);
        gOwer = owner;
        gstrConn = connstr;
        this.Init();
    }

    private void Init() {
        gSC = new StructureCollection();
        gVal = new AzValues(gOwer);
        base.SystemUsers.GetDataByName(Pub.Session.GetManager(gOwer));
        //gstrDefaultTable = "";
        gCache = new Ly.IO.Json();
    }

    #endregion

    /// <summary>
    /// 
    /// </summary>
    public new AzJson Json {
        get { return gJson; }
    }

    public StructureCollection Data {
        get { return gSC; }
    }

    public string GetValue() {
        switch (gJson.Type.Trim().ToLower()) {
            case "text":
                return RepalceKey(gJson.Binding);
            case "read":
                if (gJson.Binding == "") throw new Exception("\"Read\"类型必须为绑定模式，\"Binding\"不能为空。");
                if (this.Execute() > 0) {
                    return gSC[0][gJson.Binding];
                } else {
                    return gJson.Null;
                }
        }
        return "";
    }

    public string GetTableName(string name) {
        name = name.Trim();
        if (gCache.Objects[name].Items["ID"].Value != "") {
            return "[" + gCache.Objects[name].Items["Name"].Value + "]";
        }
        if (base.SystemTables.GetDataByText(name.Trim())) {
            gCache.Objects[name].Items["ID"].Value = base.SystemTables.Structure.ID.ToString();
            gCache.Objects[name].Items["Name"].Value = base.SystemTables.Structure.Name;
            return "[" + base.SystemTables.Structure.Name + "]";
        }
        return "";
    }

    public string GetColumnName(string tabname, string colname) {
        tabname = tabname.Trim();
        if (gCache.Objects["<" + tabname + ">"].Items["Text"].Value != "") {
            tabname = gCache.Objects["<" + tabname + ">"].Items["Text"].Value;
        }

        colname = colname.Trim();
        long lngID = 0;
        string res = "";


        if (gCache.Objects[tabname].Items["ID"].Value != "") {
            lngID = Ly.String.Source(gCache.Objects[tabname].Items["ID"].Value).toLong;
            res += "[" + gCache.Objects[tabname].Items["Name"].Value + "]";
        }

        if (lngID == 0) {
            if (base.SystemTables.GetDataByText(tabname)) {
                lngID = base.SystemTables.Structure.ID;
                gCache.Objects[tabname].Items["ID"].Value = base.SystemTables.Structure.ID.ToString();
                gCache.Objects[tabname].Items["Name"].Value = base.SystemTables.Structure.Name;
                res += "[" + gCache.Objects[tabname].Items["Name"].Value + "]";
            }
        }

        if (lngID > 0) {
            if (base.SystemColumns.GetDataByParentIDAndText(lngID, colname)) {
                res += ".[" + base.SystemColumns.Structure.Name + "]";
                return res;
            }
        }
        return "";
    }

    public String RepalceKey(string str) {
        String res = str;
        int iRight = res.IndexOf(">");
        if (iRight < 0) {
            if (res.IndexOf("<") >= 0) throw new Exception("意外多余的\"<\"符号。");
            return res.Replace("&lt;", "<").Replace("&gt;", ">").Replace("&amp;", "&").Replace("!=", "<>");
        }
        int iLeft = res.Substring(0, iRight).LastIndexOf("<");
        if (iLeft < 0) throw new Exception("意外多余的\">\"符号。");

        String sName = res.Substring(iLeft + 1, iRight - iLeft - 1);
        if (sName == "") throw new Exception("关键字不能为空。");

        String[] sabNames = sName.Split(':');
        String[] saNames = sabNames[0].Trim().Split('.');

        if (sabNames.Length > 2) throw new Exception("\"" + sName + "\"不是合法的关键字。");
        if (sabNames.Length == 2) {
            if (sabNames[1].Trim() == "") throw new Exception("\"" + sName + "\"：替代字符不允许为空。");
        }

        switch (saNames[0].Trim()) {
            case "$":
                //if (sabNames.Length > 1) throw new Exception("系统关键字不允许替代字符。");
                if (saNames.Length < 2) throw new Exception("系统关键字不能为空。");
                switch (saNames[1].Trim().ToLower()) {
                    case "location":
                        if (saNames.Length < 3) throw new Exception("系统本地信息关键字不能为空。");
                        if (sabNames.Length > 1) throw new Exception("系统本地信息关键字不允许替代字符。");
                        res = res.Replace("<" + sName + ">", gVal.GetLoaction(saNames[2]));
                        break;
                    case "request":
                        if (saNames.Length < 3) throw new Exception("系统交互信息关键字不能为空。");
                        string sRequest = gVal.GetRequest(saNames[2]);
                        if (sabNames.Length > 1) {
                            if (sRequest == "") sRequest = sabNames[1].Trim();
                        }
                        res = res.Replace("<" + sName + ">", sRequest);
                        break;
                    case "form":
                        if (saNames.Length < 3) throw new Exception("系统表单信息关键字不能为空。");
                        //res = res.Replace("<" + sName + ">", gJson.FormValues[saNames[2].Trim()]);
                        string sForm = gJson.FormValues[saNames[2].Trim()];
                        if (sabNames.Length > 1) {
                            if (sForm == "") sForm = sabNames[1].Trim();
                        }
                        res = res.Replace("<" + sName + ">", sForm);
                        break;
                    case "user":
                        if (sabNames.Length > 1) throw new Exception("系统登录用户信息关键字不允许替代字符。");
                        if (saNames.Length < 3) throw new Exception("系统登录用户信息关键字不能为空。");
                        res = res.Replace("<" + sName + ">", base.SystemUsers.Structure[saNames[2].Trim()]);
                        break;
                }
                break;
            default:
                switch (saNames.Length) {
                    case 1:
                        string sTab = GetTableName(saNames[0]);
                        if (sTab != "") {
                            res = res.Replace("<" + sName + ">", sTab);
                            if (sabNames.Length == 2) {
                                gCache.Objects["<" + sabNames[1].Trim() + ">"].Items["Text"].Value = saNames[0].Trim();
                            }
                        } else {
                            if (gCache.Objects["<Def>"].Items["Text"].Value != "") {
                                string sCol = GetColumnName(gCache.Objects["<Def>"].Items["Text"].Value, saNames[0]);
                                if (sCol != "") {
                                    if (sabNames.Length == 2) {
                                        sCol += " As " + sabNames[1];
                                    }
                                    res = res.Replace("<" + sName + ">", sCol);
                                } else {
                                    throw new Exception("未找到表\"" + saNames[0] + "\"或未在默认中找到\"" + saNames[0] + "\"字段。");
                                }
                            } else {
                                throw new Exception("未找到表\"" + saNames[0] + "\"。");
                            }
                        }
                        break;
                    case 2:
                        if (saNames[0] == "") saNames[0] = gCache.Objects["<Def>"].Items["Text"].Value;
                        string sCol2 = GetColumnName(saNames[0], saNames[1]);
                        if (sCol2 != "") {
                            if (sabNames.Length == 2) {
                                sCol2 += " As [" + sabNames[1].Trim() + "]";
                            }
                            res = res.Replace("<" + sName + ">", sCol2);
                        } else {
                            throw new Exception("未在表\"" + saNames[0] + "\"中找到\"" + saNames[1] + "\"字段。");
                        }
                        break;
                    default:
                        throw new Exception("未知的关键字");
                }
                break;
        }

        return RepalceKey(res);
    }

    /// <summary>
    /// 获取标准SQL字符串
    /// </summary>
    /// <returns></returns>
    public String GetNormalSQLString() {
        //绑定模式
        if (gJson.Binding != "") {
            string strtemp = gJson.Binding.Trim();
            if (strtemp.StartsWith("<") && strtemp.EndsWith(">")) {
                string[] sBinding = strtemp.Substring(1, strtemp.Length - 2).Split('.');
                if (sBinding.Length != 2) throw new Exception("绑定模式\"Binding\"字段必须为\"表名.字段名\"为格式。");
                if (sBinding[0].Trim() == "" || sBinding[1].Trim() == "") throw new Exception("绑定模式\"Binding\"字段必须为\"表名.字段名\"为格式。");

                string sTab = GetTableName(sBinding[0]);
                if (sTab == "") throw new Exception("未找到表\"" + sBinding[0].Trim() + "\"。");
                gCache.Objects["<Def>"].Items["Text"].Value = sBinding[0].Trim();
                gCache.Objects["<Def>"].Items["Name"].Value = sTab;
                gCache.Objects["<Def>"].Items["ID"].Value = gCache.Objects[sBinding[0]].Items["ID"].Value;

                string sCol = GetColumnName(sBinding[0].Trim(), sBinding[1].Trim());
                if (sCol == "") throw new Exception(strtemp + "：未在表\"" + sBinding[0] + "(" + sTab + ")" + "\"中找到\"" + sBinding[1].Trim() + "\"字段。");
                gCache.Objects["<Def.Col>"].Items["Text"].Value = sBinding[1].Trim();

                if (gJson.Tables != "") gJson.Tables += ",";
                gJson.Tables += sTab;

                if (gJson.Columns != "") gJson.Columns += ",";
                gJson.Columns += sCol + " As [" + sBinding[1].Trim() + "]";

                gJson.Binding = sBinding[1].Trim();
            } else {
                string[] sBinding = strtemp.Split('.');
                if (sBinding.Length != 2) throw new Exception("绑定模式\"Binding\"字段必须为\"表名.字段名\"为格式。");
                if (sBinding[0].Trim() == "" || sBinding[1].Trim() == "") throw new Exception("绑定模式\"Binding\"字段必须为\"表名.字段名\"为格式。");

                if (gJson.Tables != "") gJson.Tables += ",";
                gJson.Tables += sBinding[0].Trim();

                if (gJson.Columns != "") gJson.Columns += ",";
                gJson.Columns += strtemp;

                string ColName = sBinding[1].Trim();
                gCache.Objects["<Def.Col>"].Items["Text"].Value = ColName;

                if (ColName.StartsWith("[") && ColName.EndsWith("]")) ColName = ColName.Substring(1, ColName.Length - 2);
                gJson.Binding = ColName;
            }
        } else {
            //默认表模式
            if (gJson.DefaultTable != "") {
                string DTab = gJson.DefaultTable.Trim();
                string sTab = GetTableName(DTab);
                if (sTab == "") throw new Exception("未找到表\"" + DTab + "\"。");
                gCache.Objects["<Def>"].Items["Text"].Value = DTab;
                gCache.Objects["<Def>"].Items["Name"].Value = sTab;
                gCache.Objects["<Def>"].Items["ID"].Value = gCache.Objects[DTab].Items["ID"].Value;

                if (gJson.Tables != "") gJson.Tables += ",";
                gJson.Tables += sTab;

                if (gJson.Columns.IndexOf("*") >= 0) {
                    long lngID = Ly.String.Source(gCache.Objects["<Def>"].Items["ID"].Value).toLong;
                    base.SystemColumns.GetDatasByParentID(lngID);
                    string sColumns = "";
                    string sColumnsCN = "";
                    for (int i = 0; i < base.SystemColumns.StructureCollection.Count; i++) {
                        if (sColumns != "") sColumns += ",";
                        if (sColumnsCN != "") sColumnsCN += ",";
                        sColumns += sTab + ".[" + base.SystemColumns.StructureCollection[i].Name + "]";
                        sColumns += sTab + ".[" + base.SystemColumns.StructureCollection[i].Name + "] As [" + base.SystemColumns.StructureCollection[i].Text + "]";
                    }
                    gJson.Columns.Replace("<*.*>", sColumnsCN).Replace("<*>", sColumns);
                }
            }
        }

        string sql = "Select " + (gJson.Type == "Read" ? "Top 1 " : "") + gJson.Columns + " From " + gJson.Tables + (gJson.Premise == "" ? "" : " where " + gJson.Premise) + (gJson.Order == "" ? "" : " order by " + gJson.Order);
        sql = RepalceKey(sql);
        return sql;
    }

    /// <summary>
    /// 执行Json脚本
    /// </summary>
    /// <returns></returns>
    public int Execute() {
        string sql = GetNormalSQLString();

        gSC.Clear();

        using (Ly.Data.SQLClient Conn = new Ly.Data.SQLClient(gstrConn)) {
            Conn.ExecuteReader(sql);
            while (Conn.DataReader.Read()) {
                Structure st = new Structure();
                for (int i = 0; i < Conn.DataReader.FieldCount; i++) {
                    string sName = Conn.DataReader.GetName(i);
                    st[sName] = Conn.DataReader[i].ToString();
                }
                gSC.Add(st);
            }
        }

        return gSC.Count;
    }
}