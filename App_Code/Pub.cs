using System;
using System.Collections.Generic;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

/// <summary>
/// Site 的摘要说明
/// </summary>
public class Pub {

    public Pub() {
        //
        // TODO: 在此处添加构造函数逻辑
        //
    }

    /// <summary>
    /// 界面生成相关类
    /// </summary>
    public class UI {

        /// <summary>
        /// 获取线条
        /// </summary>
        /// <param name="obj"></param>
        /// <param name="cache"></param>
        /// <param name="lm"></param>
        /// <returns></returns>
        public static string GetLine(dyk.Format.JsonObject obj, dyk.Format.Json cache, dyk.Format.Limits lm) {
            string res = "";

            res = "<div style=\"position:absolute;";
            if (obj["Left"].Value != "") res += "left:" + Ly.String.Source(obj["Left"].Value).toInteger + "px;";
            if (obj["Top"].Value != "") res += "top:" + Ly.String.Source(obj["Top"].Value).toInteger + "px;";
            if (obj["Width"].Value != "") res += "width:" + Ly.String.Source(obj["Width"].Value).toInteger + "px;";
            if (obj["Height"].Value != "") res += "height:" + Ly.String.Source(obj["Height"].Value).toInteger + "px;";
            res += "background:" + obj["Color"].Value + ";";
            res += "\"></div>";

            return res;
        }

        /// <summary>
        /// 获取标签
        /// </summary>
        /// <param name="obj"></param>
        /// <param name="cache"></param>
        /// <param name="lm"></param>
        /// <returns></returns>
        public static string GetLabel(dyk.Format.JsonObject obj, dyk.Format.Json cache, dyk.Format.Limits lm) {
            string res = "";

            string szID = obj["ID"].Value;
            string szText = obj["Text"].Value;

            if (szID != "") {
                int nIDIndex = cache.GetIndex(szID);
                if (nIDIndex >= 0) szText = cache.Children[nIDIndex].Value;
            }

            res = "<div style=\"position:absolute;";
            if (obj["Left"].Value != "") res += "left:" + Ly.String.Source(obj["Left"].Value).toInteger + "px;";
            if (obj["Top"].Value != "") res += "top:" + Ly.String.Source(obj["Top"].Value).toInteger + "px;";
            if (obj["Width"].Value != "") res += "width:" + Ly.String.Source(obj["Width"].Value).toInteger + "px;";
            if (obj["Height"].Value != "") res += "height:" + Ly.String.Source(obj["Height"].Value).toInteger + "px;";
            if (obj["Align"].Value != "") res += "text-align:" + obj["Align"].Value + ";";
            res += obj["Style"].Value;
            res += "\">" + szText + "</div>";

            return res;
        }

    }

    /// <summary>
    /// 数据库相关类
    /// </summary>
    public class DB {

        /// <summary>
        /// 获取用户关于表的权限
        /// </summary>
        /// <param name="UserID"></param>
        /// <param name="TableID"></param>
        /// <returns></returns>
        public static dyk.Format.Limits GetTableLimits(ClsPage pg, long TableID) {
            dyk.Format.Limits res = dyk.Format.Limits.NoLimits();

            #region [=====获取个人权限=====]

            using (dyk.DB.Base.SystemUserLimits.ExecutionExp sul = new dyk.DB.Base.SystemUserLimits.ExecutionExp(pg.BaseConnectString)) {
                sul.GetDatasByUserAndTable(pg.UserInfo.ID, TableID);
                for (int i = 0; i < sul.StructureCollection.Count; i++) {
                    dyk.DB.Base.SystemUserLimits.StructureExp st = sul.StructureCollection[i];
                    res.AddLimitsByString(st.Limits);
                }
            }

            #endregion

            #region [=====获取部门权限=====]

            using (dyk.DB.Kernel.SystemDepartmentLimits.ExecutionExp sul = new dyk.DB.Kernel.SystemDepartmentLimits.ExecutionExp(pg.BaseConnectString)) {
                sul.GetDatasByDepartmentAndTable(pg.UserInfo.Department, TableID);
                for (int i = 0; i < sul.StructureCollection.Count; i++) {
                    dyk.DB.Kernel.SystemDepartmentLimits.StructureExp st = sul.StructureCollection[i];
                    res.AddLimitsByString(st.Limits);
                }
            }

            #endregion

            #region [=====获取用户组权限=====]

            using (dyk.DB.Kernel.SystemGroupLimits.ExecutionExp sul = new dyk.DB.Kernel.SystemGroupLimits.ExecutionExp(pg.BaseConnectString)) {
                sul.GetDatasByUserAndTable(pg.UserInfo.ID, TableID);
                for (int i = 0; i < sul.StructureCollection.Count; i++) {
                    dyk.DB.Kernel.SystemGroupLimits.StructureExp st = sul.StructureCollection[i];
                    res.AddLimitsByString(st.Limits);
                }
            }

            #endregion

            return res;
        }
    }

    /// <summary>
    /// 值格式
    /// </summary>
    public class ValueFormat {

        public static string getValue(ClsPage owner, string connstr, string value, string format, string formatpath) {
            return getValue(owner, connstr, 0, "", value, format, formatpath);
        }

        public static string getValue(ClsPage owner, string connstr, int id, string name, string value, string format, string formatpath) {
            if (format != "") {

                ClsAjaxPageArgs gPageArgs = new ClsAjaxPageArgs();

                for (int i = 0; i < gPageArgs.Object.Count; i++) {
                    gPageArgs.Object[i].Value = owner[gPageArgs.Object[i].Name];
                }

                using (Ly.Formats.Json json = new Ly.Formats.Json(format)) {
                    switch (json["Type"].Value) {
                        case "Month":
                            string sMonth = value + "-01";
                            DateTime dtMonth = DateTime.Now;
                            if (DateTime.TryParse(sMonth, out dtMonth)) {
                                //sValue = dtMonth.ToString(jValue["Binding"].Value);
                                return dtMonth.ToString(json["Binding"].Value);
                            }
                            break;
                        case "Date":
                            string sDate = value;
                            DateTime dtDate = DateTime.Now;
                            if (DateTime.TryParse(sDate, out dtDate)) {
                                //sValue = dtDate.ToString(json["Binding"].Value);
                                return dtDate.ToString(json["Binding"].Value);
                            }
                            break;
                        case "File":
                            switch (json["Binding"].Value) {
                                case "Image":
                                    break;
                                default:
                                    //sValue = "<a href=\"" + sValue + "\" target=\"_blank\">下载</a>";
                                    return "<a href=\"" + value + "\" target=\"_blank\">下载</a>";
                                    //break;
                            }
                            break;
                        case "Number":
                            double dbTemp = 0;
                            if (double.TryParse(value, out dbTemp)) {
                                //sValue = dbTemp.ToString(json["Binding"].Value);
                                return dbTemp.ToString(json["Binding"].Value);
                            } else {
                                //sValue = "&nbsp;";
                                return "&nbsp;";
                            }
                        //break;
                        case "Check":
                            #region [=====选择框模式=====]
                            int nTemp = 0;
                            string szValue = "";
                            if (int.TryParse(value, out nTemp)) {
                                //sValue = dbTemp.ToString(json["Binding"].Value);
                                //return nTemp.ToString(json["Binding"].Value);
                                if (nTemp > 0) szValue = "√";
                            }
                            //ClsAjaxPage pg = new ClsAjaxPage(owner);
                            return "<div id=\"" + gPageArgs.UID + "_Check_" + id + "_" + name + "\" style=\"margin: 0 auto; width:14px;height:14px; line-height:14px; border:1px solid #ddd;text-align: center; vertical-align: middle; color:#090; font-weight: bold; background: #fff;cursor:pointer;\" onclick=\"Page.Functions.Table.CheckClick('" + gPageArgs.UID + "',{Arg_Key_ID: " + id + ",Arg_Key_Name: '" + name + "'});\">" + szValue + "</div>";
                        #endregion
                        case "Read":
                            #region [=====数据库读取模式=====]
                            //string szSql = Pub.IO.ReadAllText(Server.MapPath(this.WebConfig.ShareSQLSettingPath + "/" + gTab.SystemTables.Structure.Name + "_" + st.Name + "_Format.azsql"));
                            string szSql = Pub.IO.ReadAllText(formatpath);

                            using (Ly.Formats.Json jSql = new Ly.Formats.Json()) {
                                jSql["Value"].Value = value;
                                using (AzSqlProgram Asm = new AzSqlProgram(owner, connstr, jSql)) {
                                    try {
                                        szSql = Asm.ExecuteString(szSql);
                                    } catch (Exception ex) {
                                        //pg.OutPut("脚本执行发生异常:" + ex.Message + "<br><br>");
                                        //pg.OutPut(Asm.Program.Debug().Replace("\r\n", "<br>").Replace("\n", "<br>").Replace(" ", "&nbsp;"));
                                        string szError = "脚本执行发生异常:" + ex.Message;
                                        //szError += ";Sql:" + szSql;
                                        return szError;
                                    } finally {
                                        //pg.OutPut(Asm.Program.Debug().Replace("\r\n", "<br>").Replace("\n", "<br>").Replace(" ", "&nbsp;"));
                                    }
                                    //pg.OutPutAsText(Asm.Test(gszSql));
                                    //pg.Dispose();
                                }
                            }

                            using (Ly.Data.SQLClient ConnValue = new Ly.Data.SQLClient(connstr)) {

                                try {
                                    ConnValue.ExecuteReader(szSql);
                                } catch (Exception ex) {
                                    //pg.OutPutAsText("错误信息:" + ex.Message);
                                    //pg.OutPut("<br>");
                                    //pg.OutPutAsText("Sql:" + szSql);
                                    //pg.Dispose();
                                    string szError = "错误信息:" + ex.Message;
                                    szError += ";Sql:" + szSql;
                                    return szError;
                                }

                                if (ConnValue.DataReader.Read()) {
                                    //sValue = ConnValue.DataReader[0].ToString();
                                    return ConnValue.DataReader[0].ToString();
                                } else {
                                    //sValue = "";
                                    return "&nbsp;";
                                }
                            }
                            //break;
                            #endregion
                    }
                }
            }
            return value;
        }
    }

    public class IO {
        public static String ReadAllText(String Path) {
            String res = "";
            if (System.IO.File.Exists(Path)) {
                using (System.IO.FileStream fs = System.IO.File.Open(Path, System.IO.FileMode.Open, System.IO.FileAccess.Read)) {
                    byte[] bs = new byte[fs.Length];
                    fs.Read(bs, 0, (int)fs.Length);
                    res = System.Text.Encoding.UTF8.GetString(bs);
                    fs.Close();
                }
            } else {
                WriteAllText(Path, "");
            }
            return res;
        }

        public static String ReadAllEncryptionText(String Path) {
            String res = "";
            if (System.IO.File.Exists(Path)) {
                using (System.IO.FileStream fs = System.IO.File.Open(Path, System.IO.FileMode.Open, System.IO.FileAccess.Read)) {
                    byte[] bs = new byte[fs.Length];
                    fs.Read(bs, 0, (int)fs.Length);
                    Pub.Encryption(ref bs);
                    res = System.Text.Encoding.UTF8.GetString(bs);
                    fs.Close();
                }
            } else {
                WriteAllEncryptionText(Path, "");
            }
            return res;
        }

        public static void WriteAllText(String Path, String cnt) {
            using (System.IO.FileStream fs = System.IO.File.Open(Path, System.IO.FileMode.Create, System.IO.FileAccess.Write, System.IO.FileShare.ReadWrite)) {
                byte[] bs = System.Text.Encoding.UTF8.GetBytes(cnt);
                fs.Position = 0;
                fs.Write(bs, 0, bs.Length);
            }
        }

        public static void WriteAllEncryptionText(String Path, String cnt) {
            using (System.IO.FileStream fs = System.IO.File.Open(Path, System.IO.FileMode.Create, System.IO.FileAccess.Write, System.IO.FileShare.ReadWrite)) {
                byte[] bs = System.Text.Encoding.UTF8.GetBytes(cnt);
                Pub.Encryption(ref bs);
                fs.Position = 0;
                fs.Write(bs, 0, bs.Length);
            }
        }
    }

    public static void CheckLogin(ClsPage owner, String Url) {
        CheckLogin(owner, "", Url);
    }

    public static void CheckLogin(ClsPage owner, String Key, String Url) {
        String LoginName = Key == "" ? owner.Session.Manager : owner.Session[Key];
        if (LoginName == "") owner.Response.Redirect(Url);
    }

    public class Session {

        public static void SetLoginInfo(Page owner, String Key, String Value) {
            owner.Session["Login_" + Key] = Value;
        }

        public static string GetLoginInfo(Page owner, String Key) {
            if (owner.Session["Login_" + Key] != null) {
                return owner.Session["Login_" + Key].ToString();
            }
            return "";
        }

        public static string GetValue(Page owner, String Key) {
            if (owner.Session[Key] != null) {
                return owner.Session[Key].ToString();
            }
            return "";
        }

        public static string GetManager(Page owner) {
            if (owner.Session["Manager"] != null) {
                return owner.Session["Manager"].ToString();
            }
            return "";
        }

        public static void SetManager(Page owner, string value) {
            owner.Session["Manager"] = value;
        }
    }

    public class ConnectionStrings {
        public static string GetConnectionString(string name) {
            return System.Configuration.ConfigurationManager.ConnectionStrings[name].ToString();
        }

        public static string Lianyi
        {
            get
            {
                return System.Configuration.ConfigurationManager.ConnectionStrings["Lianyi"].ToString();
            }
        }

        public static string lyt
        {
            get
            {
                return System.Configuration.ConfigurationManager.ConnectionStrings["lyt"].ToString();
            }
        }
    }

    public static string Request(Page owner, string key, string def) {
        if (owner.Request[key] == null) {
            return def;
        }
        return owner.Request[key].ToString() == "" ? def : owner.Request[key].ToString();
    }

    public static string Request(Page owner, string key) {
        if (owner.Request[key] == null) {
            return "";
        }
        return owner.Request[key].ToString();
    }

    public static bool isMobile(string userAgent) {
        userAgent = userAgent.ToLower();
        if (userAgent.IndexOf("mobile") >= 0) return true;
        return false;
    }

    public static string ConnectionString
    {
        get
        {
            return System.Configuration.ConfigurationManager.ConnectionStrings["Lianyi"].ToString();
        }
    }

    public static void Encryption(ref Byte[] theBytes) {
        for (int i = 0; i < theBytes.Length; i++) {
            if (theBytes[i] % 2 == 0) {
                theBytes[i]++;
            } else {
                theBytes[i]--;
            }
        }
    }

    public static bool CheckInstall(string szConn) {
        using (Ly.Data.SQLClient Conn = new Ly.Data.SQLClient(szConn)) {
            return Conn.TableExist("SystemObjects") && Conn.TableExist("SystemSessions") && Conn.TableExist("SystemUsers") && Conn.TableExist("SystemTables");
        }
    }
}