using System;
using System.Collections.Generic;
using System.Web;
using System.Web.UI;
using Ly.ZBox;

/// <summary>
/// ZManager 的摘要说明
/// </summary>
public class AzSqlLibrary : Ly.ZBox.LibraryNomal {

    private Ly.DB.Dream.Tables gTab;
    private int gnTable;
    private bool gbTable;
    private Ly.Formats.Json gJson;
    private ClsPage gParent;
    private string gszConnString;

    public AzSqlLibrary(ClsPage owner, string connstr, Ly.Formats.Json json) {
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

    protected override string OnExecuteLibraryFuntion(LibraryArgs e) {
        switch (e.Name.Trim().ToLower()) {
            case "table"://表查找函数
                return Fun_Table(e.ArgStorageUnits, e.StoragePool);
            case "tablebyid"://表查找函数
                return Fun_TableByID(e.ArgStorageUnits, e.StoragePool);
            case "tableid"://表查找函数
                return Fun_TableID(e.ArgStorageUnits, e.StoragePool);
            case "column"://字段查找函数
                return Fun_Column(e.ArgStorageUnits, e.StoragePool);
            case "tablecolumn"://表字段查找函数
                return Fun_TableColumn(e.ArgStorageUnits, e.StoragePool);
            case "user": //用户信息查找函数
                return Fun_User(e.ArgStorageUnits, e.StoragePool);
            case "form"://当前表单信息查找函数
                return Fun_Form(e.ArgStorageUnits, e.StoragePool);
            case "request"://当前页面交互信息查找函数
                return Fun_Request(e.ArgStorageUnits, e.StoragePool);
            case "numrequest"://当前页面交互信息查找函数
                return Fun_NumRequest(e.ArgStorageUnits, e.StoragePool);
            case "sqlread"://当前页面交互信息查找函数
                return Fun_SqlRead(e.ArgStorageUnits, e.StoragePool);
            case "sqlexecute"://当前页面交互信息查找函数
                return Fun_SqlExecute(e.ArgStorageUnits, e.StoragePool);
            case "autonum"://获取自动编号
                return Fun_AutoNum(e.ArgStorageUnits, e.StoragePool);
            case "char"://获取一个字符
                return Fun_Char(e.ArgStorageUnits, e.StoragePool);
            default:
                return base.OnExecuteLibraryFuntion(e);
        }
    }

    //执行SQL语句并返回首行的第一个值
    private string Fun_Char(List<StorageUnit> list, StoragePool pool) {
        switch (list.Count) {
            case 1:
                int szArg0 = Ly.ZBox.StorageUnit.GetIntegerValue(list[0], pool);
                string res = "";
                res += (char)szArg0;

                return res;
            default:
                throw new Exception("参数数量不正确，未找到" + list.Count + "参数的定义。");
        }
    }

    //执行SQL语句并返回首行的第一个值
    private string Fun_AutoNum(List<StorageUnit> list, StoragePool pool) {
        switch (list.Count) {
            case 1:
                string szArg0 = Ly.ZBox.StorageUnit.GetStringValue(list[0], pool);
                string res = "";

                using (Ly.DB.Dream.SystemAutomatic.ExecutionExp st = new Ly.DB.Dream.SystemAutomatic.ExecutionExp(gszConnString)) {
                    res = st.GetNewAutomatic(szArg0).ToString();
                }

                return res;
            default:
                throw new Exception("参数数量不正确，未找到" + list.Count + "参数的定义。");
        }
    }

    //执行SQL语句并返回首行的第一个值
    private string Fun_SqlExecute(List<StorageUnit> list, StoragePool pool) {
        switch (list.Count) {
            case 1:
                string szArg0 = Ly.ZBox.StorageUnit.GetStringValue(list[0], pool);
                string res = "";

                using (Ly.Data.SQLClient Conn = new Ly.Data.SQLClient(gszConnString)) {
                    Conn.ExecuteNonQuery(szArg0);
                }

                return res;
            default:
                throw new Exception("参数数量不正确，未找到" + list.Count + "参数的定义。");
        }
    }

    //执行SQL语句并返回首行的第一个值
    private string Fun_SqlRead(List<StorageUnit> list, StoragePool pool) {
        switch (list.Count) {
            case 1:
                string szArg0 = Ly.ZBox.StorageUnit.GetStringValue(list[0], pool);
                string res = "";

                using (Ly.Data.SQLClient Conn = new Ly.Data.SQLClient(gszConnString)) {
                    Conn.ExecuteReader(szArg0);
                    if (Conn.DataReader.Read()) {
                        res = Conn.DataReader[0].ToString();
                    }
                }

                return res;
            default:
                throw new Exception("参数数量不正确，未找到" + list.Count + "参数的定义。");
        }
    }

    //表识标查找函数
    private string Fun_TableID(List<StorageUnit> list, StoragePool pool) {
        switch (list.Count) {
            case 1:
                string szArg0 = Ly.ZBox.StorageUnit.GetStringValue(list[0], pool);
                if (gTab.SystemTables.GetDataByText(szArg0)) {

                    //如只有一个表，则附带默认表功能
                    if (gbTable) {
                        gnTable = 0;
                    } else {
                        gnTable = (int)gTab.SystemTables.Structure.ID;
                        gbTable = true;
                    }

                    return gTab.SystemTables.Structure.ID.ToString();
                } else {
                    throw new Exception("未找到表\"" + szArg0 + "\"。");
                }
            default:
                throw new Exception("参数数量不正确，未找到" + list.Count + "参数的定义。");
        }
    }

    //当前表单信息查找函数
    private string Fun_NumRequest(List<StorageUnit> list, StoragePool pool) {
        switch (list.Count) {
            case 1:
                string szArg0 = Ly.ZBox.StorageUnit.GetStringValue(list[0], pool);
                double res = 0;
                double.TryParse(gParent[szArg0], out res);
                return res.ToString();
            default:
                throw new Exception("参数数量不正确，未找到" + list.Count + "参数的定义。");
        }
    }

    //当前表单信息查找函数
    private string Fun_Request(List<StorageUnit> list, StoragePool pool) {
        switch (list.Count) {
            case 1:
                string szArg0 = Ly.ZBox.StorageUnit.GetStringValue(list[0], pool);
                return gParent[szArg0];
            default:
                throw new Exception("参数数量不正确，未找到" + list.Count + "参数的定义。");
        }
    }

    //当前表单信息查找函数
    private string Fun_Form(List<StorageUnit> list, StoragePool pool) {
        switch (list.Count) {
            case 1:
                string szArg0 = Ly.ZBox.StorageUnit.GetStringValue(list[0], pool);
                return gJson[szArg0].Value;
            case 2:
                int nStep = 0;
                try {
                    nStep++;
                    szArg0 = Ly.ZBox.StorageUnit.GetStringValue(list[0], pool);
                    nStep++;
                    string szArg1 = Ly.ZBox.StorageUnit.GetStringValue(list[1], pool);
                    nStep++;
                    gJson[szArg0].Value = szArg1;
                    nStep++;
                    return gJson[szArg0].Value;
                } catch (Exception ex) {
                    throw new Exception(ex.Message + "\r\n[0]:" + list[0].Type + ",[1]:" + list[1].Type + ",Pool:" + pool + ",Step:" + nStep);
                }
            default:
                throw new Exception("参数数量不正确，未找到" + list.Count + "参数的定义。");
        }
    }

    //用户信息查找函数
    private string Fun_User(List<StorageUnit> list, StoragePool pool) {
        switch (list.Count) {
            case 1:
                string szArg0 = Ly.ZBox.StorageUnit.GetStringValue(list[0], pool);
                switch (szArg0.ToLower()) {
                    case "id":
                        return gParent.UserInfo.ID.ToString();
                    case "department":
                        return gParent.UserInfo.Department.ToString();
                    case "auth":
                        return gParent.AuthorizeID.ToString();
                    default:
                        throw new Exception("未找到登录用户的\"" + szArg0 + "\"属性。");
                }
            default:
                throw new Exception("参数数量不正确，未找到" + list.Count + "参数的定义。");
        }
    }

    //字段查找函数
    private string Fun_Column(List<StorageUnit> list, StoragePool pool) {
        switch (list.Count) {
            case 1:
                string szArg0 = Ly.ZBox.StorageUnit.GetStringValue(list[0], pool);
                if (gnTable > 0) {
                    if (gTab.SystemColumns.GetDataByParentIDAndText(gnTable, szArg0)) {
                        return gTab.SystemColumns.Structure.Name;
                    } else {
                        throw new Exception("未在表中找到\"" + szArg0 + "\"字段。");
                    }
                } else {
                    throw new Exception("多表情况下，查询字段必须加上表名称参数。");
                }
            case 2:
                int nArg0 = Ly.ZBox.StorageUnit.GetIntegerValue(list[0], pool); ;
                string szArg1 = Ly.ZBox.StorageUnit.GetStringValue(list[1], pool); ;
                if (gTab.SystemColumns.GetDataByParentIDAndText(nArg0, szArg1)) {
                    return gTab.SystemColumns.Structure.Name;
                } else {
                    throw new Exception("未在表中找到\"" + szArg1 + "\"字段。");
                }
            default:
                throw new Exception("参数数量不正确，未找到" + list.Count + "参数的定义。");
        }
    }

    //字段查找函数
    private string Fun_TableColumn(List<StorageUnit> list, StoragePool pool) {
        switch (list.Count) {
            case 2:
                string szArg0 = Ly.ZBox.StorageUnit.GetStringValue(list[0], pool); ;
                string szArg1 = Ly.ZBox.StorageUnit.GetStringValue(list[1], pool); ;
                if (gTab.SystemTables.GetDataByText(szArg0)) {
                    if (gTab.SystemColumns.GetDataByParentIDAndText(gTab.SystemTables.Structure.ID, szArg1)) {
                        return "[" + gTab.SystemTables.Structure.Name + "].[" + gTab.SystemColumns.Structure.Name + "]";
                    } else {
                        throw new Exception("未在表中找到\"" + szArg0 + "\"字段。");
                    }
                } else {
                    throw new Exception("未找到表\"" + szArg0 + "\"。");
                }
            default:
                throw new Exception("参数数量不正确，未找到" + list.Count + "参数的定义。");
        }
    }

    //表查找函数
    private string Fun_TableByID(List<StorageUnit> list, StoragePool pool) {
        switch (list.Count) {
            case 1:
                int szArg0 = Ly.ZBox.StorageUnit.GetIntegerValue(list[0], pool);
                if (gTab.SystemTables.GetDataByID(szArg0)) {

                    //如只有一个表，则附带默认表功能
                    if (gbTable) {
                        gnTable = 0;
                    } else {
                        gnTable = (int)gTab.SystemTables.Structure.ID;
                        gbTable = true;
                    }

                    return gTab.SystemTables.Structure.Name;
                } else {
                    throw new Exception("未找到表\"" + szArg0 + "\"。");
                }
            default:
                throw new Exception("参数数量不正确，未找到" + list.Count + "参数的定义。");
        }
    }


    //表查找函数
    private string Fun_Table(List<StorageUnit> list, StoragePool pool) {
        switch (list.Count) {
            case 1:
                string szArg0 = Ly.ZBox.StorageUnit.GetStringValue(list[0], pool);
                if (gTab.SystemTables.GetDataByText(szArg0)) {

                    //如只有一个表，则附带默认表功能
                    if (gbTable) {
                        gnTable = 0;
                    } else {
                        gnTable = (int)gTab.SystemTables.Structure.ID;
                        gbTable = true;
                    }

                    return "[" + gTab.SystemTables.Structure.Name + "]";
                } else {
                    throw new Exception("未找到表\"" + szArg0 + "\"。");
                }
            default:
                throw new Exception("参数数量不正确，未找到" + list.Count + "参数的定义。");
        }
    }

}