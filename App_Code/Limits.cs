using System;
using System.Collections.Generic;
using System.Web;

/// <summary>
/// Limits 的摘要说明
/// </summary>
public class Limits {
    /// <summary>
    /// 读取标志，访问的首要标志
    /// </summary>
    public const string SZ_LIMIT_READ = "r";

    /// <summary>
    /// 添加标志
    /// </summary>
    public const string SZ_LIMIT_ADD = "a";

    /// <summary>
    /// 修改标志
    /// </summary>
    public const string SZ_LIMIT_EDIT = "e";

    /// <summary>
    /// 删除标志
    /// </summary>
    public const string SZ_LIMIT_DELETE = "d";

    /// <summary>
    /// 文件在线查阅标志
    /// </summary>
    public const string SZ_LIMIT_VIEW = "v";

    /// <summary>
    /// 文件下载标志
    /// </summary>
    public const string SZ_LIMIT_DOWN = "dl";

    public Limits() {
        //
        // TODO: 在此处添加构造函数逻辑
        //

    }

    /// <summary>
    /// 检查下载权限
    /// </summary>
    /// <param name="szLimitStr"></param>
    /// <returns></returns>
    public static bool CheckDownLimit(string szLimitStr) {
        return CheckLimit(szLimitStr, SZ_LIMIT_DOWN);
    }

    /// <summary>
    /// 检查文件在线查阅权限
    /// </summary>
    /// <param name="szLimitStr"></param>
    /// <returns></returns>
    public static bool CheckViewLimit(string szLimitStr) {
        return CheckLimit(szLimitStr, SZ_LIMIT_VIEW);
    }

    /// <summary>
    /// 检查删除权限
    /// </summary>
    /// <param name="szLimitStr"></param>
    /// <returns></returns>
    public static bool CheckDelLimit(string szLimitStr) {
        return CheckLimit(szLimitStr, SZ_LIMIT_DELETE);
    }


    /// <summary>
    /// 检查修改权限
    /// </summary>
    /// <param name="szLimitStr"></param>
    /// <returns></returns>
    public static bool CheckEditLimit(string szLimitStr) {
        return CheckLimit(szLimitStr, SZ_LIMIT_EDIT);
    }


    /// <summary>
    /// 检查添加权限
    /// </summary>
    /// <param name="szLimitStr"></param>
    /// <returns></returns>
    public static bool CheckAddLimit(string szLimitStr) {
        return CheckLimit(szLimitStr, SZ_LIMIT_ADD);
    }

    /// <summary>
    /// 检查读取权限
    /// </summary>
    /// <param name="szLimitStr"></param>
    /// <returns></returns>
    public static bool CheckReadLimit(string szLimitStr) {
        return CheckLimit(szLimitStr, SZ_LIMIT_READ);
    }

    /// <summary>
    /// 检查权限
    /// </summary>
    /// <param name="szLimitStr"></param>
    /// <param name="szLimitFlag"></param>
    /// <returns></returns>
    public static bool CheckLimit(string szLimitStr, string szLimitFlag) {
        return (szLimitStr.IndexOf("-" + szLimitFlag + "-") >= 0);
    }
}