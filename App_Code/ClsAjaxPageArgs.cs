using System;
using System.Collections.Generic;
using System.Web;

/// <summary>
/// ClsPageArgs 的摘要说明
/// </summary>
public class ClsAjaxPageArgs : Ly.Formats.Json {

    public ClsAjaxPageArgs(ClsAjaxPageArgs arg) : base(arg.ToString()) { }

    public ClsAjaxPageArgs(string arg) : base(arg) { }

    public ClsAjaxPageArgs() {
        //
        // TODO: 在此处添加构造函数逻辑
        //
        //gstrArgs = "Path:'" + sPath + "'";
        //gstrArgs += ",ID:'" + sID + "'";
        //gstrArgs += ",Table:'" + sTable + "'";
        //gstrArgs += ",ViewTable:'" + gintTable + "'";
        //gstrArgs += ",Arg_ID:'" + glngID + "'";
        //gstrArgs += ",Arg_Relation:'" + glngRelation + "'";
        //gstrArgs += ",Arg_Index:'" + gintIndex + "'";
        //gstrArgs += "," + pg.ArgsInJson;
        this.Arg_ID = 0;
        this.Arg_Index = 0;
        this.Arg_Relation = 0;
        this.Arg_Table_Date = "";
        this.Arg_Table_Key = "";
        this.Arg_Table_Filters = "";

        this.Dialog_ElementID = "";
        this.Dialog_ID = "";
        this.ID = "";
        this.Page = 0;
        this.Path = "";
        this.Process_ElementID = "";
        this.Process_ID = "";
        this.Table = "";
        this.ViewTable = 0;

        this.UI = "";
        this.UID = "";
        this.UIMain = "";
        this.UITitle = "";
        this.UITool = "";
        this.UIPath = "";

        this.SessionID = "";
    }

    /// <summary>
    /// 表格级参数：关键字
    /// </summary>
    public String Arg_Table_Filters { get { return this["Arg_Table_Filters"].Value; } set { this["Arg_Table_Filters"].Value = value; } }

    /// <summary>
    /// 表格级参数：关键字
    /// </summary>
    public String Arg_Table_Key { get { return this["Arg_Table_Key"].Value; } set { this["Arg_Table_Key"].Value = value; } }

    /// <summary>
    /// 表格级参数：日期
    /// </summary>
    public String Arg_Table_Date { get { return this["Arg_Table_Date"].Value; } set { this["Arg_Table_Date"].Value = value; } }

    /// <summary>
    /// 关联参数：关联识别号
    /// </summary>
    public int Page { get { return Ly.String.Source(this["UI_Page"].Value).toInteger; } set { this["UI_Page"].Value = value.ToString(); } }

    /// <summary>
    /// 对话框识别号
    /// </summary>
    public String Dialog_ID { get { return this["Dialog_ID"].Value; } set { this["Dialog_ID"].Value = value; } }

    /// <summary>
    /// 对话框元素识别号
    /// </summary>
    public String Dialog_ElementID { get { return this["Dialog_ElementID"].Value; } set { this["Dialog_ElementID"].Value = value; } }

    /// <summary>
    /// 进程识别号
    /// </summary>
    public String Process_ID { get { return this["Process_ID"].Value; } set { this["Process_ID"].Value = value; } }

    /// <summary>
    /// 进程元素识别号
    /// </summary>
    public String Process_ElementID { get { return this["Process_ElementID"].Value; } set { this["Process_ElementID"].Value = value; } }

    /// <summary>
    /// 关联参数：关联索引
    /// </summary>
    public int Arg_Index { get { return Ly.String.Source(this["Arg_Index"].Value).toInteger; } set { this["Arg_Index"].Value = value.ToString(); } }

    /// <summary>
    /// 关联参数：关联识别号
    /// </summary>
    public int Arg_Relation { get { return Ly.String.Source(this["Arg_Relation"].Value).toInteger; } set { this["Arg_Relation"].Value = value.ToString(); } }

    /// <summary>
    /// 关联参数：表格识别号
    /// </summary>
    public int Arg_ID { get { return Ly.String.Source(this["Arg_ID"].Value).toInteger; } set { this["Arg_ID"].Value = value.ToString(); } }

    /// <summary>
    /// 表识别
    /// </summary>
    public int ViewTable { get { return Ly.String.Source(this["Arg_ViewTable"].Value).toInteger; } set { this["Arg_ViewTable"].Value = value.ToString(); } }

    /// <summary>
    /// 表
    /// </summary>
    public String Table { get { return this["Arg_Table"].Value; } set { this["Arg_Table"].Value = value; } }

    /// <summary>
    /// 路径
    /// </summary>
    public String Path { get { return this["Arg_Path"].Value; } set { this["Arg_Path"].Value = value; } }

    /// <summary>
    /// 识别号
    /// </summary>
    public String ID { get { return this["ID"].Value; } set { this["ID"].Value = value; } }

    /// <summary>
    /// UI类型
    /// </summary>
    public String UI { get { return this["UI"].Value; } set { this["UI"].Value = value; } }

    /// <summary>
    /// 所属线程相关的界面识标符
    /// </summary>
    public String UID { get { return this["UI_ID"].Value; } set { this["UI_ID"].Value = value; } }

    /// <summary>
    /// 所属线程相关的界面工具栏识标符
    /// </summary>
    public String UITool { get { return this["UI_Tool"].Value; } set { this["UI_Tool"].Value = value; } }

    /// <summary>
    /// 所属线程相关的界面显示区域识标符
    /// </summary>
    public String UIMain { get { return this["UI_Main"].Value; } set { this["UI_Main"].Value = value; } }

    /// <summary>
    /// 所属线程相关的界面显示区域识标符
    /// </summary>
    public string UITitle { get { return this["UI_Title"].Value; } set { this["UI_Title"].Value = value; } }

    /// <summary>
    /// 所属线程相关的界面显示区域识标符
    /// </summary>
    public string UIPath { get { return this["UI_Path"].Value; } set { this["UI_Path"].Value = value; } }

    /// <summary>
    /// 获取页面交互识标
    /// </summary>
    public string SessionID { get { return this["Azalea_SessionID"].Value; } set { this["Azalea_SessionID"].Value = value; } }
}