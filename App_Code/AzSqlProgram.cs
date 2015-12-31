using System;
using System.Collections.Generic;
using System.Web;

/// <summary>
/// AzSqlProgram 的摘要说明
/// </summary>
public class AzSqlProgram : IDisposable {

    Ly.ZBox.Program gPro;

    public AzSqlProgram(ClsPage owner, string connstr, Ly.Formats.Json json) {
        //
        // TODO: 在此处添加构造函数逻辑
        //
        gPro = new Ly.ZBox.Program("", new AzSqlLibrary(owner, connstr, json));
    }

    /// <summary>
    /// 获取虚拟机执行器
    /// </summary>
    public Ly.ZBox.Program Program { get { return gPro; } }

    public void Dispose() {
        //throw new NotImplementedException();
    }

    /// <summary>
    /// 调试器
    /// </summary>
    /// <param name="sql"></param>
    /// <returns></returns>
    public string Test(string sql) {
        string res = sql;

        int nLeft = res.IndexOf("<%");
        int nRight = res.IndexOf("%>");

        if (nLeft >= 0) {
            if (nLeft + 2 > nRight) throw new Exception("意外多余的\"%>\"关键字。");
            string szScript = res.Substring(nLeft + 2, nRight - nLeft - 2);
            gPro.LoadScript(szScript);
            res = res.Replace("<%" + szScript + "%>", "");
            res = Test(res);
        } else if (nRight >= 0) {
            throw new Exception("意外多余的\"%>\"关键字。");
        }


        res = gPro.MainFunction.ToString();
        return res;
    }

    /// <summary>
    /// 解析AzSQL为普通SQL
    /// </summary>
    /// <param name="sql"></param>
    /// <returns></returns>
    public string ExecuteString(string sql) {
        string res = sql;

        int nLeft = res.IndexOf("<%");
        int nRight = res.IndexOf("%>");

        if (nLeft >= 0) {
            if (nLeft + 2 > nRight) throw new Exception("意外多余的\"%>\"关键字。");
            string szScript = res.Substring(nLeft + 2, nRight - nLeft - 2);
            string szTemp = res.Substring(0, nLeft) + gPro.Execute(szScript) + res.Substring(nRight + 2);
            //res = res.Replace("<%" + szScript + "%>", gPro.Execute(szScript));
            res = ExecuteString(szTemp);
        } else if (nRight >= 0) {
            throw new Exception("意外多余的\"%>\"关键字。");
        }

        return res;
    }
}