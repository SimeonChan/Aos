using System;
using System.Collections.Generic;
using System.Web;

/// <summary>
/// Config 的摘要说明
/// </summary>
public class WebConfig : Ly.Formats.Json {

    /// <summary>
    /// Aos数据库配置信息存储地址
    /// </summary>
    public const string SZ_FILE_DB_AOS = "/Files/System/Database/Base.json";

    /// <summary>
    /// Aos数据库初始化脚本存储地址
    /// </summary>
    public const string SZ_FILE_SQL_AOS = "/Files/System/Database/Base.azsql";

    /// <summary>
    /// 基础数据表配置信息存储地址
    /// </summary>
    public const string SZ_FILE_DB_BASE = "/Files/Plug/Base/db.json";

    /// <summary>
    /// 基础数据库初始化脚本存储地址
    /// </summary>
    public const string SZ_FILE_SQL_BASE = "/Files/Plug/Base/db.azsql";

    /// <summary>
    /// 数据库连接配置保存位置
    /// </summary>
    public const string SZ_FILE_CONNECTION = "/Conn.sxml";

    /// <summary>
    /// 配置文件保存位置
    /// </summary>
    public const string SZ_FILE_SETTING = "/Setting.xml";

    /// <summary>
    /// 默认数据库存储路径
    /// </summary>
    public const string SZ_DIR_DATABASE_DEFAULT = "D:\\Aos_Database";

    //用户私有存储位置
    //public const string SZ_PATH_USER = "/Files/User/<UserName>";

    //用户共享存储位置
    //public const string SZ_PATH_SHARE = "/Files/Share";

    //系统文件存储位置，前置引用，不可包含任何<>关键字
    //public const string SZ_PATH_SYSTEM = "/Files/System";

    //系统路径设置文件，前置引用，不可包含任何<>关键字
    public const string SZ_PATH = "/Files/System/Path.txt";

    //应用文件存储位置
    //public const string SZ_PATH_APP = "/Files/App";

    //链接字符串存储位置，前置引用，不可包含任何<>关键字

    /// <summary>
    /// 基础数据库设定文件
    /// </summary>
    public const string SZ_PLUG = "/Files/Plug";

    /// <summary>
    /// 基础数据库设定文件
    /// </summary>
    public const string SZ_DB_BASE = "/Files/System/Database/Base.json";

    /// <summary>
    /// 常规数据库设定文件
    /// </summary>
    public const string SZ_DB_SETTING = "/Files/System/Database/Setting.json";

    /// <summary>
    /// 常规数据库设定文件
    /// </summary>
    public const string SZ_DB_INIT = "/Files/System/Database/Init.txt";

    /// <summary>
    /// 常规数据库设定文件
    /// </summary>
    public const string SZ_DB_PATH = "/Files/System/Database";

    /// <summary>
    /// 链接字符串存储位置
    /// </summary>
    public const string SZ_PATH_CONNECTSTRING = "/Files/Conn.txt";

    /// <summary>
    /// 初始化SQL语句的存放位置
    /// </summary>
    public const string SZ_PATH_INSTALLSQL = "/Files/System/SQL";

    //应用信息存储位置
    //public const string SZ_PATH_APPS = "<SystemPath>/Apps.txt";

    //文件类型信息存储位置
    //public const string SZ_PATH_EXTENSION = "<SystemPath>/Extension.txt";

    //系统表列设置
    //public const string SZ_PATH_SYSTEM_COLUMNS_SETTING = "<SystemPath>";

    //用户表列设置
    //public const string SZ_PATH_COLUMNS_SETTING = "<SystemPath>";

    //系统表界面设置
    //public const string SZ_PATH_SYSTEM_UI_SETTING = "<SystemPath>/UI";

    //用户表界面设置
    //public const string SZ_PATH_IU_SETTING = "<SystemPath>/UI";

    private string gszSystemPath;
    private string gszUserPath;
    private string gszAppPath;
    private string gszSharePath;

    public WebConfig(ClsPage owner) {
        //
        // TODO: 在此处添加构造函数逻辑
        //


        string szName = "";
        if (owner != null) szName = owner.UserInfo.Name;
        if (szName == "") szName = "Guest";

        string szPathStr = Pub.IO.ReadAllText(owner.Server.MapPath(SZ_PATH));
        base.Object.SetChildrenByJsonString(szPathStr);

        string szAuthCode = "";
        using (dyk.DB.Aos.AosAuthorize.ExecutionExp aa = new dyk.DB.Aos.AosAuthorize.ExecutionExp(owner.AosConnectString)) {
            if (aa.GetDataByID(owner.AuthorizeID)) {
                szAuthCode = aa.Structure.Code;
            }
        }

        gszSystemPath = base["SYSTEM"].Value.Replace("<UserName>", szName).Replace("<AuthCode>", szAuthCode);
        gszUserPath = base["USER"].Value.Replace("<UserName>", szName).Replace("<AuthCode>", szAuthCode);
        gszAppPath = base["APP"].Value.Replace("<UserName>", szName).Replace("<AuthCode>", szAuthCode);
        gszSharePath = base["SHARE"].Value.Replace("<UserName>", szName).Replace("<AuthCode>", szAuthCode);

    }

    /// <summary>
    /// 从字符串获得实际路径
    /// </summary>
    /// <param name="str"></param>
    /// <returns></returns>
    public string GetPathString(string str) {
        string sz = str;
        sz = sz.Replace("<AppPath>", gszAppPath);
        sz = sz.Replace("<SharePath>", gszSharePath);
        sz = sz.Replace("<SystemPath>", gszSystemPath);
        sz = sz.Replace("<UserPath>", gszUserPath);
        return sz;
    }

    /// <summary>
    /// 获取设定路径
    /// </summary>
    /// <param name="str"></param>
    /// <returns></returns>
    public string GetPath(string str) {
        return GetPathString(base[str].Value);
    }

    /// <summary>
    /// 系统文件存储位置
    /// </summary>
    public string SystemPath { get { return gszSystemPath; } }

    /// <summary>
    /// 应用文件存储位置
    /// </summary>
    public string AppPath { get { return gszAppPath; } }

    /// <summary>
    /// 用户共享文件存储位置
    /// </summary>
    public string SharePath { get { return gszSharePath; } }

    /// <summary>
    /// 用户私有文件存储位置
    /// </summary>
    public string UserPath { get { return gszUserPath; } }

    /// <summary>
    /// 连接字符串存储位置
    /// </summary>
    public string ConnectStringPath { get { return SZ_PATH_CONNECTSTRING; } }

    /// <summary>
    /// 应用设置
    /// </summary>
    public string AppsSettingPath { get { return GetPath("APPS"); } }

    /// <summary>
    /// 应用设置
    /// </summary>
    public string SystemExtensionPath { get { return GetPath("EXTENSION"); } }

    /// <summary>
    /// 系统表界面设置
    /// </summary>
    public string SystemUISettingPath { get { return GetPath("SYSTEM_UI_SETTING"); } }

    /// <summary>
    /// 用户表列设置
    /// </summary>
    public string SystemColumnsSettingPath { get { return GetPath("SYSTEM_COLUMNS_SETTING"); } }

    /// <summary>
    /// 用户表列设置
    /// </summary>
    public string InstallSqlPath { get { return GetPath("INSTALL_SQL"); } }

    /// <summary>
    /// 默认背景图片
    /// </summary>
    public string DefaultBackgroundPath { get { return GetPath("DEFAULT_BACKGROUND"); } }

    /// <summary>
    /// 默认背景图片
    /// </summary>
    public string SystemBackgroundPath { get { return GetPath("SYSTEM_BACKGROUND"); } }

    /// <summary>
    /// 用户设置路径
    /// </summary>
    public string UserSettingPath { get { return GetPath("USER_SETTING"); } }

    /// <summary>
    /// 系统SQL脚本设置路径
    /// </summary>
    public string SystemSQLSettingPath { get { return GetPath("SYSTEM_SQL_SETTING"); } }
}