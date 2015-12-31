using System;
using System.Collections.Generic;
using System.Web;
using System.Web.UI;

/// <summary>
/// DS函数库
/// </summary>
public class DsLibrary : dyk.Script.Code.Library.Standard {

    public Ly.DB.Dream.Tables gTab;
    public int gnTable;
    public bool gbTable;
    public dyk.Format.Json gJson;
    public ClsPage gParent;
    public string gszConnString;

    public DsLibrary(ClsPage owner, string connstr, dyk.Format.Json json) {
        //
        // TODO: 在此处添加构造函数逻辑
        //
        gTab = new Ly.DB.Dream.Tables(connstr);
        gnTable = 0;
        gbTable = false;
        gParent = owner;
        gJson = json;
        gszConnString = connstr;
    }

    /// <summary>
    /// 返回字符
    /// </summary>
    /// <param name="list"></param>
    /// <param name="pool"></param>
    /// <returns></returns>
    [dyk.Script.Code.Library.Dyk(dyk.Script.Code.Library.AttributeTypes.Function, 1)]
    public string Char(dyk.Script.Code.Variable.Number num) {
        string res = "";
        res += (char)num.Value;
        return res;
    }


    /// <summary>
    /// 获取自动编号
    /// </summary>
    /// <param name="str"></param>
    /// <returns></returns>
    [dyk.Script.Code.Library.Dyk(dyk.Script.Code.Library.AttributeTypes.Function, 1)]
    public int AutoNum(dyk.Script.Code.Variable.String str) {
        int res = 0;

        using (Ly.DB.Dream.SystemAutomatic.ExecutionExp st = new Ly.DB.Dream.SystemAutomatic.ExecutionExp(gszConnString)) {
            res = st.GetNewAutomatic(str.Value);
        }

        return res;
    }

    /// <summary>
    /// 执行SQL语句
    /// </summary>
    /// <param name="list"></param>
    /// <param name="pool"></param>
    /// <returns></returns>
    [dyk.Script.Code.Library.Dyk(dyk.Script.Code.Library.AttributeTypes.Sub, 1)]
    public void SqlExecute(dyk.Script.Code.Variable.String str) {
        try {
            using (Ly.Data.SQLClient Conn = new Ly.Data.SQLClient(gszConnString)) {
                Conn.ExecuteNonQuery(str.Value);
            }
        } catch (Exception ex) {
            throw new Exception("数据库执行发生异常:" + ex.Message + ";执行语句:" + str.Value);
        }
    }

    /// <summary>
    /// 执行SQL语句并返回首行的第一个值
    /// </summary>
    /// <param name="str"></param>
    /// <returns></returns>
    [dyk.Script.Code.Library.Dyk(dyk.Script.Code.Library.AttributeTypes.Function, 1)]
    public string SqlRead(dyk.Script.Code.Variable.String str) {
        string res = "";

        using (Ly.Data.SQLClient Conn = new Ly.Data.SQLClient(gszConnString)) {
            Conn.ExecuteReader(str.Value);
            if (Conn.DataReader.Read()) {
                res = Conn.DataReader[0].ToString();
            }
        }

        return res;
    }

    //表识标查找函数
    [dyk.Script.Code.Library.Dyk(dyk.Script.Code.Library.AttributeTypes.Function, 1)]
    public long TableID(dyk.Script.Code.Variable.String str) {
        if (gTab.SystemTables.GetDataByText(str.Value)) {

            //如只有一个表，则附带默认表功能
            if (gbTable) {
                gnTable = 0;
            } else {
                gnTable = (int)gTab.SystemTables.Structure.ID;
                gbTable = true;
            }

            return gTab.SystemTables.Structure.ID;
        } else {
            throw new Exception("未找到表\"" + str.Value + "\"。");
        }
    }

    //当前表单信息查找函数
    [dyk.Script.Code.Library.Dyk(dyk.Script.Code.Library.AttributeTypes.Function, 1)]
    public double NumRequest(dyk.Script.Code.Variable.String str) {
        double res = 0;
        double.TryParse(gParent[str.Value], out res);
        return res;
    }

    //当前表单信息查找函数
    [dyk.Script.Code.Library.Dyk(dyk.Script.Code.Library.AttributeTypes.Function, 1)]
    public string Request(dyk.Script.Code.Variable.String str) {
        return gParent[str.Value];
    }

    //当前表单信息查找函数
    [dyk.Script.Code.Library.Dyk(dyk.Script.Code.Library.AttributeTypes.Function, 1)]
    public string GetForm(dyk.Script.Code.Variable.String str) {
        return gJson[str.Value].Value;
    }

    //设置当前表单信息
    [dyk.Script.Code.Library.Dyk(dyk.Script.Code.Library.AttributeTypes.Sub, 2)]
    public void SetForm(dyk.Script.Code.Variable.String strVar, dyk.Script.Code.Variable.String strVal) {
        gJson[strVar.Value].Value = strVal.Value;
    }

    //用户信息查找函数
    [dyk.Script.Code.Library.Dyk(dyk.Script.Code.Library.AttributeTypes.Function, 1)]
    public string User(dyk.Script.Code.Variable.String str) {
        switch (str.Value.ToLower()) {
            case "id":
                return gParent.UserInfo.ID.ToString();
            case "department":
                return gParent.UserInfo.Department.ToString();
            case "auth":
                return gParent.AuthorizeID.ToString();
            default:
                throw new Exception("未找到登录用户的\"" + str.Value + "\"属性。");
        }
    }

    //字段查找函数
    [dyk.Script.Code.Library.Dyk(dyk.Script.Code.Library.AttributeTypes.Function, 1)]
    public string Column(dyk.Script.Code.Variable.String str) {
        if (gnTable > 0) {
            if (gTab.SystemColumns.GetDataByParentIDAndText(gnTable, str.Value)) {
                return gTab.SystemColumns.Structure.Name;
            } else {
                throw new Exception("未在表中找到\"" + str.Value + "\"字段。");
            }
        } else {
            throw new Exception("多表情况下，查询字段必须加上表名称参数。");
        }
    }

    //字段查找函数
    [dyk.Script.Code.Library.Dyk(dyk.Script.Code.Library.AttributeTypes.Function, 2)]
    public string Column(dyk.Script.Code.Variable.Number strTab, dyk.Script.Code.Variable.String strCol) {
        if (gTab.SystemColumns.GetDataByParentIDAndText(strTab.Value, strCol.Value)) {
            return gTab.SystemColumns.Structure.Name;
        } else {
            throw new Exception("未在表中找到\"" + strCol.Value + "\"字段。");
        }
    }

    //表查找函数
    [dyk.Script.Code.Library.Dyk(dyk.Script.Code.Library.AttributeTypes.Function, 1)]
    public string TableByID(dyk.Script.Code.Variable.Number num) {
        if (gTab.SystemTables.GetDataByID(num.Value)) {
            //如只有一个表，则附带默认表功能
            if (gbTable) {
                gnTable = 0;
            } else {
                gnTable = (int)gTab.SystemTables.Structure.ID;
                gbTable = true;
            }

            return gTab.SystemTables.Structure.Name;
        } else {
            throw new Exception("未找到表\"" + num.Value + "\"。");
        }
    }


    //表查找函数
    [dyk.Script.Code.Library.Dyk(dyk.Script.Code.Library.AttributeTypes.Function, 1)]
    public string Table(dyk.Script.Code.Variable.String str) {
        if (gTab.SystemTables.GetDataByText(str.Value)) {

            //如只有一个表，则附带默认表功能
            if (gbTable) {
                gnTable = 0;
            } else {
                gnTable = (int)gTab.SystemTables.Structure.ID;
                gbTable = true;
            }

            return "[" + gTab.SystemTables.Structure.Name + "]";
        } else {
            throw new Exception("未找到表\"" + str.Value + "\"。");
        }
    }

}