using System;
using System.Collections.Generic;
using System.Web;

namespace dyk.WebSite {

    /// <summary>
    /// Table2D 的摘要说明
    /// </summary>
    public class Table2D {

        private ClsPage gPage;

        private long gnTableID;

        public Table2D(ClsPage pg) {
            //
            // TODO: 在此处添加构造函数逻辑
            //
            gPage = pg;
            gnTableID = dyk.Type.String.New(gPage["Arg_Table"]).ToNumber;
        }

        /// <summary>
        /// 获取字符串定义信息内容
        /// </summary>
        /// <param name="str"></param>
        /// <returns></returns>
        public bool GetCompare(string cType, string str1, string str2) {
            //bool res = true;
            double db1 = 0;
            double db2 = 0;

            switch (cType.ToLower()) {
                case "=":
                    return (str1 == str2);
                case "!=":
                    return (str1 != str2);
                case ">":
                    if (!double.TryParse(str1, out db1)) return false;
                    if (!double.TryParse(str2, out db2)) return false;
                    return (db1 > db2);
                case ">=":
                    if (!double.TryParse(str1, out db1)) return false;
                    if (!double.TryParse(str2, out db2)) return false;
                    return (db1 >= db2);
                case "<":
                    if (!double.TryParse(str1, out db1)) return false;
                    if (!double.TryParse(str2, out db2)) return false;
                    return (db1 < db2);
                case "<=":
                    if (!double.TryParse(str1, out db1)) return false;
                    if (!double.TryParse(str2, out db2)) return false;
                    return (db1 <= db2);
                case "$":
                    return (str1.IndexOf(str2) >= 0);
                case "$-":
                    return str1.StartsWith(str2);
                case "-$":
                    return str1.EndsWith(str2);
                default:
                    throw new Exception("不支持的运算符!");
            }
            //return res;
        }

        /// <summary>
        /// 获取字符串定义信息内容
        /// </summary>
        /// <param name="str"></param>
        /// <returns></returns>
        public string GetStringInfo(string str) {
            string res = "";
            str = str.Trim();
            if (str.StartsWith("{") && str.EndsWith("}")) {
                str = str.Substring(1, str.Length - 2).Trim();
                if (str == "") throw new Exception("定义字符不能为空!");
                if (str.StartsWith("{") && str.EndsWith("}")) {
                    res = str;
                } else {
                    string[] szArr = str.Split('.');
                    switch (szArr[0].Trim().ToLower()) {
                        case "user":
                            if (szArr.Length != 2) throw new Exception("User必须并只能拥有一个参数!");
                            res = gPage.UserInfo[szArr[1].Trim()].Value;
                            break;
                    }
                }
            } else {
                res = str;
            }
            return res;
        }

        /// <summary>
        /// 获取筛选定义
        /// </summary>
        /// <returns></returns>
        public string GetTableFilters() {
            string res = "";
            using (dyk.DB.OA.TabFilter.ExecutionExp tf = new DB.OA.TabFilter.ExecutionExp(gPage.BaseConnectString)) {
                tf.GetDatasByTableIDAndType(gnTableID, 0);
                for (int i = 0; i < tf.StructureCollection.Count; i++) {
                    dyk.DB.OA.TabFilter.StructureExp tfst = tf.StructureCollection[i];
                    if (tfst.IsScript > 0) {
                        #region [=====脚本模式=====]
                        using (DsLibrary lib = new DsLibrary(gPage, gPage.BaseConnectString, null)) {
                            using (dyk.Script.Code.Program.Actuator act = new Script.Code.Program.Actuator(tfst.DScript, lib)) {
                                act.Execute();
                                res = act.OutString;
                            }
                        }
                        #endregion
                    } else {
                        #region [=====设置模式=====]
                        bool bTrigger = true;

                        //读取筛选触发定义
                        #region [=====设定是否触发筛选=====]
                        using (dyk.DB.OA.TabFilterTrigger.ExecutionExp tfr = new DB.OA.TabFilterTrigger.ExecutionExp(gPage.BaseConnectString)) {
                            tfr.GetDatasByFilterIDOrderByIndex(tfst.ID);

                            for (int j = 0; j < tfr.StructureCollection.Count; j++) {
                                dyk.DB.OA.TabFilterTrigger.StructureExp tfrst = tfr.StructureCollection[j];
                                bool bTemp = GetCompare(tfrst.PremiseType, GetStringInfo(tfrst.ObjectName), GetStringInfo(tfrst.Value));
                                if (tfrst.GroupType.Trim().ToLower() == "or") {
                                    bTrigger = bTrigger | bTemp;
                                } else {
                                    bTrigger = bTrigger & bTemp;
                                }
                            }
                        }
                        #endregion

                        if (bTrigger) {
                            //读取筛选内容
                            using (dyk.DB.OA.TabFilterPremises.ExecutionExp tfp = new DB.OA.TabFilterPremises.ExecutionExp(gPage.BaseConnectString)) {
                                tfp.GetDatasByFilterIDOrderByIndex(tfst.ID);

                                string szFilterTemp = "";

                                for (int j = 0; j < tfp.StructureCollection.Count; j++) {
                                    dyk.DB.OA.TabFilterPremises.StructureExp tfpst = tfp.StructureCollection[j];
                                    if (szFilterTemp != "")
                                    {
                                        szFilterTemp += " " + tfpst.GroupType + " ";
                                    }
                                    szFilterTemp += "[" + tfpst.ColumnName + "] " + tfpst.PremiseType + " '" + GetStringInfo(tfpst.Value) + "'";
                                }

                                if (szFilterTemp != "") {
                                    if (res != "") res += " and ";
                                    res += "(" + szFilterTemp + ")";
                                }
                            }
                        }
                        #endregion
                    }
                }
            }
            //if (res != "") res = "(" + res + ")";
            return res;
        }


    }

}
