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

                string szColor = "color: #fff; text-shadow: 1px 1px 3px #000;";
                if (pg.PageArgs.UI == "Touch") szColor = "color: #222; text-shadow: 1px 1px 3px #bbb;";

                string szUserLimitAll = "|*|";//访问权限设定，设定此项，代表任何用户名默认允许访问
                string szUserLimitPass = "|" + this.Session.Manager + "|";//单用户访问权限设定，设定此项，代表任何该用户名允许访问
                string szUserLimitStop = "|-" + this.Session.Manager + "|";//单用户阻止访问权限设定，设定此项，代表任何该用户名不允许访问

                gstrPath = "";
                if (Request["Path"] != null) gstrPath = Request["Path"].ToString().Trim().Replace("\\", "/");
                if (gstrPath.StartsWith("/") || gstrPath.IndexOf("..") >= 0) gstrPath = "";
                if (gstrPath != "" && !gstrPath.EndsWith("/")) gstrPath += "/";
                gstrFullPath = "/" + gstrPath;
                gJson = new Ly.IO.JsonFile(Server.MapPath(this.WebConfig.AppsSettingPath), System.Text.Encoding.UTF8);

                string szClickScript;
            %>
            <%
                for (int i = 0; i < gJson.Objects.Count; i++) {
                    Ly.IO.Json.ObjectIntegrated Obj = gJson.Objects[i];
                    string szUserLimit = Obj.Items["User"].Value;
                    string szGroupLimit = Obj.Items["Group"].Value;

                    //判断是否拥有访问权限
                    bool bUserLimit = ((szUserLimit.IndexOf(szUserLimitAll) >= 0) || (szUserLimit.IndexOf(szUserLimitPass) >= 0)) && (szUserLimit.IndexOf(szUserLimitStop) < 0);

                    //读取组权限，方式与用户类似
                    if (!bUserLimit) {
                        using (Ly.DB.Dream.SystemGroups.ExecutionExp sg = new Ly.DB.Dream.SystemGroups.ExecutionExp(this.ConnectString)) {
                            sg.GetDatasByUserIDNoDepartment(this.UserInfo.ID);
                            for (int m = 0; m < sg.StructureCollection.Count; m++) {
                                if (szGroupLimit.IndexOf("|" + sg.StructureCollection[m].Name + "|") >= 0) {
                                    bUserLimit = true;
                                    break;
                                }
                            }
                        }
                    }

                    if (bUserLimit) {
                        if (Obj.Name == "App") {
                            if (gJson.Objects[i].Items["Name"].Value == "#(TableList)") {
                                String Connstr = Pub.IO.ReadAllText(Server.MapPath(this.WebConfig.ConnectStringPath));
                                using (Ly.DB.Dream.Tables gTab = new Ly.DB.Dream.Tables(Connstr)) {
                                    gTab.SystemTables.GetDatasOrderByIndex();
                                    for (int j = 0; j < gTab.SystemTables.StructureCollection.Count; j++) {
                                        if (gTab.SystemTables.StructureCollection[j].Visible == 1) {
                                            long lngID = gTab.SystemTables.StructureCollection[j].ID;

                                            bool bLimit = false;

                                            //检测用户权限
                                            using (Ly.DB.Dream.SystemLimits.ExecutionExp gl = new Ly.DB.Dream.SystemLimits.ExecutionExp(this.ConnectString)) {
                                                gl.GetDatasByUserID(this.UserInfo.ID, lngID);
                                                for (int m = 0; m < gl.StructureCollection.Count; m++) {
                                                    //pg.OutPut("<div>" + gTab.SystemTables.StructureCollection[j].Text + ":" + gl.StructureCollection[m].Limits + "</div>");
                                                    bLimit = Limits.CheckReadLimit(gl.StructureCollection[m].Limits);
                                                    if (bLimit) break;
                                                }
                                            }

                                            //检测部门权限
                                            if (!bLimit && this.UserInfo.Department != 0) {
                                                using (Ly.DB.Dream.SystemLimits.ExecutionExp gl = new Ly.DB.Dream.SystemLimits.ExecutionExp(this.ConnectString)) {
                                                    gl.GetDatasByDepartmentID(this.UserInfo.Department, lngID);
                                                    for (int m = 0; m < gl.StructureCollection.Count; m++) {
                                                        //pg.OutPut("<div>" + gTab.SystemTables.StructureCollection[j].Text + ":" + gl.StructureCollection[m].Limits + "</div>");
                                                        bLimit = Limits.CheckReadLimit(gl.StructureCollection[m].Limits);
                                                        if (bLimit) break;
                                                    }
                                                }
                                            }

                                            //检测用户组权限
                                            if (!bLimit) {
                                                using (Ly.DB.Dream.SystemLimits.ExecutionExp gl = new Ly.DB.Dream.SystemLimits.ExecutionExp(this.ConnectString)) {
                                                    gl.GetDatasByUserGroups(this.UserInfo.ID, lngID);
                                                    for (int m = 0; m < gl.StructureCollection.Count; m++) {
                                                        bLimit = Limits.CheckReadLimit(gl.StructureCollection[m].Limits);
                                                        if (bLimit) break;
                                                    }
                                                }
                                            }

                                            if (bLimit) {
                                                String sName = gTab.SystemTables.StructureCollection[j].Text;
                                                String sIcon = this.WebConfig.AppPath + "/System/Manager/Logo.png";
                                                String sPath = this.WebConfig.AppPath + "/OA/Table/Default.aspx?Table=" + gTab.SystemTables.StructureCollection[j].ID;
                                                szClickScript = "Page.UI.Open('Table_" + lngID + "','" + pg.PageArgs.UID + "','" + sName + "','/Files/App/OA/Process/','Process.aspx', { Arg_Table:" + lngID + "});";
            %>
            <div style="float: left; width: 76px; height: 76px; font-size: 12px; padding: 4px; margin: 8px 0px 0px 6px; text-align: center;"
                onmousemove="$(this).css({ border: '1px solid #0094ff', backgroundColor: '#62bdff' ,padding:'3px',opacity: 0.8});"
                onmouseout="$(this).css({ border: '0px solid #0094ff', backgroundColor: '',padding:'4px',opacity: 1 });">
                <div>
                    <a href="javascript:;" onclick="<%=szClickScript%>"
                        title="<%=sName%>">
                        <img alt="<%=sName%>" title="<%=sName%>" src="<%=sIcon%>" width="48" height="48" /></a>
                </div>
                <div>
                    <a href="javascript:;" onclick="<%=szClickScript%>"
                        title="<%=sName%>" style="<%=szColor%>text-wrap: normal;">
                        <%=sName%>
                    </a>
                </div>
            </div>
            <%
                                }
                            }
                        }
                    }
                } else {
                    String sName = Obj.Items["Name"].Value;
                    String sIcon = Obj.Items["Icon"].Value;
                    String sPath = Obj.Items["App"].Value;
                    String sDir = Obj.Items["Dir"].Value;
                    String sID = Obj.Items["ID"].Value;
                    int nWidth = Ly.String.Source(Obj.Items["Width"].Value).toInteger;
                    switch (Obj.Items["Type"].Value) {
                        case "Page":
            %>
            <div style="float: left; width: 76px; height: 76px; font-size: 12px; padding: 4px; margin: 8px 0px 0px 6px; text-align: center;"
                onmousemove="$(this).css({ border: '1px solid #0094ff', backgroundColor: '#62bdff' ,padding:'3px',opacity: 0.8});"
                onmouseout="$(this).css({ border: '0px solid #0094ff', backgroundColor: '',padding:'4px',opacity: 1 });">
                <div>
                    <a href="<%=sPath%>" target="_blank" title="<%=sName%>">
                        <img alt="<%=sName%>" title="<%=sName%>" src="<%=sIcon%>" width="48" height="48" /></a>
                </div>
                <div>
                    <a href="<%=sPath%>" target="_blank" title="<%=sName%>" style="<%=szColor%>text-wrap: normal;">
                        <%=sName%>
                    </a>
                </div>
            </div>
            <%
                    break;
                case "Ajax":
                    szClickScript = "Page.UI.Open('Page_" + sID + "','" + pg.PageArgs.UID + "','" + sName + "','/Files/App/" + sDir + "/','Process.aspx', { UI_Path: '/Files/App/" + sDir + "/', Table:'" + sID + "',ID:'Card_" + sID + "_main' });";
            %>
            <div style="float: left; width: 76px; height: 76px; font-size: 12px; padding: 4px; margin: 8px 0px 0px 6px; text-align: center;"
                onmousemove="$(this).css({ border: '1px solid #0094ff', backgroundColor: '#62bdff' ,padding:'3px',opacity: 0.8});"
                onmouseout="$(this).css({ border: '0px solid #0094ff', backgroundColor: '',padding:'4px',opacity: 1 });">
                <div>
                    <a href="javascript:;" onclick="<%=szClickScript%>" title="<%=sName%>">
                        <img alt="<%=sName%>" title="<%=sName%>" src="<%=sIcon%>" width="48" height="48" /></a>
                </div>
                <div>
                    <a href="javascript:;" onclick="<%=szClickScript%>" title="<%=sName%>" style="<%=szColor%>text-wrap: normal;">
                        <%=sName%>
                    </a>
                </div>
            </div>
            <%
                                    break;
                                }
                            }
                        }
                    }
                }
            %>
            <%pg.Dispose();%>
        </div>
    </form>
</body>
</html>
