<%@ Page Language="C#" Inherits="ClsPage" %>

<!DOCTYPE html>

<script runat="server">
    protected String gstrPath;
    protected String gstrFullPath;
    protected Ly.IO.JsonFile gJson;
</script>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
    <title></title>
</head>
<body>
    <form id="form1" runat="server">
        <div>
            <%ClsAjaxPage pg = new ClsAjaxPage(this); %>
            <%
                string szClickScript = "";
            %>
            <div style="position: absolute; left: 0px; top: 0px; color: #fff; height: 30px; width: 100%; padding: 5px; z-index: 3; font-weight: bold; font-size: 14px;">我的应用列表</div>
            <div style="position: absolute; left: 0px; top: 30px; color: #fff; height: 100px; width: 100%; z-index: 3;  overflow-x: auto; overflow-y: hidden;">
                <div>
                    <%
                        //加载应用列表
                        using (dyk.DB.Aos.AosApps.ExecutionExp aa = new dyk.DB.Aos.AosApps.ExecutionExp(this.AosConnectString)) {
                            aa.GetDatas();
                            for (int i = 0; i < aa.StructureCollection.Count; i++) {
                                dyk.DB.Aos.AosApps.StructureExp st = aa.StructureCollection[i];
                                szClickScript = "Page.UI.Open('" + st.Name + "','','" + st.Text + "','" + st.Path + "','Process.aspx', {});";

                                dyk.Format.Limits lm = dyk.Format.Limits.NoLimits();
                                using (dyk.DB.Base.SystemUserAppLimits.ExecutionExp sua = new dyk.DB.Base.SystemUserAppLimits.ExecutionExp(this.BaseConnectString)) {
                                    sua.GetDatasByUserAndTable(this.UserInfo.ID, st.ID);
                                    for (int j = 0; j < sua.StructureCollection.Count; j++) {
                                        lm.AddLimitsByString(sua.StructureCollection[j].Limits);
                                    }
                                }

                                if (lm.Read) {
                    %>
                    <div style="float: left; width: 100px; text-align: center; padding: 5px;">
                        <div style="width: 100%; padding: 5px; cursor: pointer;"
                            onclick="<%=szClickScript%>"
                            onmousemove="$(this).css({ border: '1px solid #000', backgroundColor: '#111' ,opacity: 0.8});"
                            onmouseout="$(this).css({ border: '0px solid #000', backgroundColor: '',opacity: 1 });">
                            <div style="width: 100%;">
                                <img src="<%=st.Path%>logo.png" height="48" />
                            </div>
                            <div style="width: 100%; word-break: break-all; word-wrap: break-word;"><%=st.Text%></div>
                        </div>
                    </div>
                    <%
                                }
                            }
                        }
                    %>
                    <div style="clear: both;"></div>
                </div>
            </div>
            <div style="position: absolute; left: 0px; top: 130px; color: #fff; height: 30px; width: 100%; padding: 5px; z-index: 2; font-weight: bold; font-size: 14px;">我的常用数据表</div>
            <div style="position: absolute; left: 0px; top: 160px; color: #fff; height: 100px; width: 100%; z-index: 2; overflow-x: auto; overflow-y: hidden;">
                <div>
                    <%
                        using (dyk.DB.Base.SystemUserTableVisits.ExecutionExp sutv = new dyk.DB.Base.SystemUserTableVisits.ExecutionExp(this.BaseConnectString)) {
                            sutv.GetDatasByUserOrderByVisits(this.UserInfo.ID);
                            if (sutv.StructureCollection.Count > 0) {
                                int nCnt = 0;
                                for (int i = 0; i < sutv.StructureCollection.Count; i++) {
                                    dyk.DB.Base.SystemUserTableVisits.StructureExp st = sutv.StructureCollection[i];
                                    //加载应用列表
                                    using (dyk.DB.Base.SystemTables.ExecutionExp aa = new dyk.DB.Base.SystemTables.ExecutionExp(this.BaseConnectString)) {
                                        if (aa.GetDataByID(st.TableID)) {
                                            //加载常用表格
                                            szClickScript = "Page.UI.Open('Table_" + aa.Structure.ID + "','','" + aa.Structure.Text + "','/Files/App/OA/Process/','Process.aspx', {Arg_Table:" + aa.Structure.ID + "});X.Custom.Home.SetVisit(" + aa.Structure.ID + ");";
                    %>
                    <div style="float: left; width: 100px; text-align: center; padding: 5px;">
                        <div style="width: 100%; padding: 5px; cursor: pointer;"
                            onclick="<%=szClickScript%>"
                            onmousemove="$(this).css({ border: '1px solid #000', backgroundColor: '#111' ,opacity: 0.8});"
                            onmouseout="$(this).css({ border: '0px solid #000', backgroundColor: '',opacity: 1 });">
                            <div style="width: 100%;">
                                <img src="/Files/App/OA/Process/logo.png" height="48" />
                            </div>
                            <div style="width: 100%; word-break: break-all; word-wrap: break-word;"><%=aa.Structure.Text%></div>
                        </div>
                    </div>
                    <%
                                        nCnt++;
                                        if (nCnt >= 10) break;
                                    }
                                }
                            }
                        } else {
                            //加载常用表格
                            szClickScript = "";
                    %>
                    <div style="float: left; width: 100px; text-align: center; padding: 5px;">
                        <div style="width: 100%; padding: 5px; cursor: pointer;">
                            <div style="width: 100%;">
                                <div style="width: 48px; height: 48px; padding-top: 16px; border: 1px solid #fff; margin: 0 auto;">无</div>
                            </div>
                        </div>
                    </div>
                    <%
                            }
                        }
                    %>
                    <div style="clear: both;"></div>
                </div>
            </div>
            <div style="position: absolute; left: 0px; top: 260px; color: #fff; height: 30px; width: 100%; padding: 5px; z-index: 2; font-weight: bold; font-size: 14px;">我的系统信息</div>
            <div style="position: absolute; left: 0px; top: 0px; color: #fff; height: 100%; width: 100%; padding: 290px 0px 0px 0px; z-index: 1;">
                <div style="width: 100%; height: 100%; overflow: auto; padding: 5px;">
                    <%
                        string szSharePath = Server.MapPath(this.WebConfig.SharePath);
                        if (!System.IO.Directory.Exists(szSharePath)) System.IO.Directory.CreateDirectory(szSharePath);

                        string szPath = Server.MapPath(this.WebConfig.SharePath + "/App_Loaded.azs");
                        string szCnt = Pub.IO.ReadAllText(szPath);

                        using (ClsAjaxRequest js = new ClsAjaxRequest()) {
                            using (AzSqlProgram Asm = new AzSqlProgram(this, this.ConnectString, null)) {
                                try {
                                    szCnt = Asm.ExecuteString(szCnt);
                                    //char cUtf = (char)0xFF;
                                    //string szUtf = "";
                                    //szUtf += cUtf;
                                    //szCnt = szCnt.Replace("\n", "").Replace("\r", "").Replace("\"", "&quot;").Replace((char)0xFF, ' ').Trim();
                                    //string szAsc = "";
                                    //for (int i = 0; i < szCnt.Length; i++) {
                                    //    szAsc += "0x" + Ly.Integer.Source((byte)szCnt[i]).toHex.PadLeft(2, '0');
                                    //}
                                    //js.Message = szCnt + "<br />" + szAsc;
                                    //js.Message = szCnt;
                                    pg.OutPut(szCnt);
                                } catch (Exception ex) {
                                    js.Message = "脚本发生异常:" + ex.Message.Replace("\"", "\\\"");
                                    //pg.OutPut("脚本执行发生异常:" + ex.Message + "<br><br>");
                                    //pg.OutPut(Asm.Program.Debug().Replace("\r\n", "<br>").Replace("\n", "<br>").Replace(" ", "&nbsp;"));
                                } finally {
                                    //pg.OutPut(Asm.Program.Debug().Replace("\r\n", "<br>").Replace("\n", "<br>").Replace(" ", "&nbsp;"));
                                }
                                //pg.OutPutAsText(Asm.Test(gszSql));
                                //pg.Dispose();
                            }
                            //pg.OutPut(js.ToString());
                        }
                    %>
                </div>
            </div>
            <%pg.Dispose();%>
        </div>
    </form>
</body>
</html>
