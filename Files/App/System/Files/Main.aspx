<%@ Page Language="C#" Inherits="ClsPage" %>

<!DOCTYPE html>

<script runat="server">
    protected String gstrConnString;
    protected long gintTable;
    protected long glngRelation;
    protected long glngID;
    protected int gintIndex;
    protected string gstrArgs;

    protected Ly.DB.Dream.AzTables gTab;
    protected String gstrFullPath;
    protected dyk.Format.Json gJson;
    protected int gintWidth;
    protected int gintHeight;
    protected int gintLines;
    protected int gintPage;
    protected string gstrSQL;
    protected Ly.IO.Json gAddJson;
    protected string gstrRelation;
</script>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
    <title></title>
    <link href="../../../../css/Plug.css" rel="stylesheet" />
    <link href="../../../../css/Default.css" rel="stylesheet" />
    <link href="../../../../css/Page.css" rel="stylesheet" />
    <link href="../../../../css/Card.css" rel="stylesheet" />
</head>
<body>
    <form id="form1" runat="server">
        <div>
            <%ClsAjaxPage pg = new ClsAjaxPage(this); %>
            <%
                string szClick;
                string gstrPath = "";
                if (Request["Arg_Path"] != null) gstrPath = Request["Arg_Path"].ToString().Trim().Replace("\\", "/");
                if (gstrPath.StartsWith("/") || gstrPath.IndexOf("..") >= 0) gstrPath = "";
                if (gstrPath != "" && !gstrPath.EndsWith("/")) gstrPath += "/";
                gstrFullPath = "/" + gstrPath;
                //gJson = new Ly.IO.JsonFile(Server.MapPath(WebConfig.SystemExtensionPath), System.Text.Encoding.UTF8);
                string szJson = Pub.IO.ReadAllText(Server.MapPath(WebConfig.SystemExtensionPath));
                gJson = new dyk.Format.Json(szJson);
                //pg.OutPutAsText(gJson.Object.ToString());
            %>
            <%
                string szScript = "";
            %>
            <!--工具栏-->
            <div style="position: absolute; top: 0px; left: 0px; z-index: 1; height: 30px; width: 100%; box-sizing: border-box; -moz-box-sizing: border-box; -webkit-box-sizing: border-box; padding: 6px 0px 0px 6px; background: #DDDDDD;">
                <div class="pub-left">
                    <a href="javascript:;" onclick="<%=szScript%>">
                        <img src="<%=pg.PageArgs.UIPath%>images/update.png" width="16" height="16" alt="" style="padding-top: 0px;" /></a>
                </div>
                <div class="pub-left"><a href="javascript:;" onclick="<%=szScript%>">上传文件</a></div>
                <div class="pub-left" style="border-left: 1px solid #CCCCCC; padding-left: 10px; margin-left: 10px;">
                    <a href="javascript:;" onclick="<%=szScript%>">
                        <img src="<%=pg.PageArgs.UIPath%>images/update.png" width="16" height="16" alt="" style="padding-top: 0px;" /></a>
                </div>
                <div class="pub-left"><a href="javascript:;" onclick="<%=szScript%>">添加文件夹</a></div>
                <div class="pub-left" style="margin-left: 8px;">
                    <a href="javascript:;" onclick="<%=szScript%>">
                        <img src="<%=pg.PageArgs.UIPath%>images/update.png" width="16" height="16" alt="" style="padding-top: 0px;" /></a>
                </div>
                <div class="pub-left"><a href="javascript:;" onclick="<%=szScript%>">添加空文件</a></div>
                <div class="pub-clear"></div>
            </div>
            <!--当前路径-->
            <div style="position: absolute; top: 30px; left: 0px; padding: 6px; z-index: 1;">
                <div style="float: left;">当前路径:</div>
                <%
                    szClick = "Page.UI.Open('" + pg.PageArgs.UID + "','','文档管理器','" + pg.PageArgs.UIPath + "','Process.aspx', {Arg_Path:''});";
                %>
                <div style="float: left;"><a href="javascript:;" onclick="<%=szClick%>">我的云存储</a></div>
                <%
                    string[] paths = gstrPath.Split('/');
                    string fullpath = "";
                    for (int i = 0; i < paths.Length; i++) {
                        if (paths[i] != "") {
                            fullpath += (fullpath == "") ? paths[i] : "/" + paths[i];
                            szClick = "Page.UI.Open('" + pg.PageArgs.UID + "','','文档管理器','" + pg.PageArgs.UIPath + "','Process.aspx', {Arg_Path:'" + fullpath + "'});";
                %>
                <div style="float: left;">&gt;</div>
                <div style="float: left;"><a href="javascript:;" onclick="<%=szClick%>"><%=paths[i]%></a></div>
                <%
                        }
                    }
                %>
                <div style="clear: both"></div>
            </div>
            <div style="position: absolute; top: 0px; padding-top: 60px; width: 100%; height: 100%; overflow: hidden; box-sizing: border-box; -moz-box-sizing: border-box; -webkit-box-sizing: border-box; z-index: 0;">
                <div style="position: relative; width: 100%; height: 100%; overflow-x: auto;">
                    <!--单独的表格列-->
                    <div style="position: absolute; top: 0px; left: 0px; z-index: 1;">
                        <table style="width: 917px; border-collapse: collapse; border-spacing: 0px;">
                            <tr style="background: #0094ff; color: #ffffff;">
                                <th style="width: 366px; border-right: 1px solid #fff; height: 30px;">名称</th>
                                <th style="width: 150px; border-right: 1px solid #fff; height: 30px;">类型</th>
                                <th style="width: 80px; border-right: 1px solid #fff; height: 30px;">大小</th>
                                <th style="width: 150px; border-right: 1px solid #fff; height: 30px;">修改日期</th>
                                <th style="border-right: 1px solid #fff; height: 30px;">相关操作</th>
                                <th style="width: 17px; padding: 0px; height: 30px;"></th>
                            </tr>
                        </table>
                    </div>
                    <!--完整的表格体-->
                    <div style="position: absolute; top: 0px; left: 0px; padding-top: 30px; height: 100%; overflow: hidden; box-sizing: border-box; -moz-box-sizing: border-box; -webkit-box-sizing: border-box; z-index: 0;">
                        <div style="height: 100%; overflow-y: scroll; overflow-x: hidden;">
                            <table style="width: 900px; border-collapse: collapse; border-spacing: 0px;">
                                <tr style="">
                                    <th style="width: 16px; height: 1px;"></th>
                                    <th style="width: 350px; height: 1px;"></th>
                                    <th style="width: 150px; height: 1px;"></th>
                                    <th style="width: 80px; height: 1px;"></th>
                                    <th style="width: 150px; height: 1px;"></th>
                                    <th style="height: 1px;"></th>
                                </tr>
                                <%
                                    int Line = 0;
                                    String[] Dirs = System.IO.Directory.GetDirectories(Server.MapPath(gstrFullPath));
                                    for (int i = 0; i < Dirs.Length; i++) {
                                        String[] DirNames = Dirs[i].Split('\\');
                                        String DirName = DirNames[DirNames.Length - 1];
                                        Line++;
                                        String LineColor = "background:#fff;";
                                        if (Line % 2 == 0) LineColor = "background:#eef8ff;";
                                        szClick = "Page.UI.Open('" + pg.PageArgs.UID + "','','文档管理器','" + pg.PageArgs.UIPath + "','Process.aspx', {Arg_Path:'" + gstrPath + DirName + "'});";
                                %>
                                <tr style="<%=LineColor%>">
                                    <td style="padding: 3px 0px 0px 0px; width: 16px;">
                                        <img alt="" src="/images/Icon/Folder.png" width="16" height="16" /></td>
                                    <td style="padding: 3px 0px;"><a href="javascript:;" onclick="<%=szClick%>"><%=DirName%></a></td>
                                    <td style="padding: 3px; text-align: center;">文件夹</td>
                                    <td style="padding: 3px;">&nbsp;</td>
                                    <td style="padding: 3px;">&nbsp;</td>
                                    <td style="padding: 3px; text-align: center;">重命名&nbsp;删除</td>
                                </tr>
                                <%
                                    }
                                %>
                                <%
                                    String[] Files = System.IO.Directory.GetFiles(Server.MapPath(gstrFullPath));
                                    for (int i = 0; i < Files.Length; i++) {
                                        String FileName = System.IO.Path.GetFileName(Files[i]);
                                        String FileExp = System.IO.Path.GetExtension(Files[i]).Replace(".", "");
                                        String FileType = gJson[FileExp]["Name"].Value;
                                        String FileIcon = gJson[FileExp]["Icon"].Value;
                                        String FileApp = gJson[FileExp]["App"].Value;
                                        String FileDir = gJson[FileExp]["Dir"].Value;
                                        String OpenType = gJson[FileExp]["Type"].Value;
                                        String FilePath = gstrPath + FileName;
                                        String FileLen = "";
                                        System.IO.FileInfo fInfo = new System.IO.FileInfo(Files[i]);
                                        String OpenUrl = "javascript:;";
                                        String szTarget = "";
                                        szClick = "alert('此文件无法直接打开!');";
                                        //pg.OutPutAsText(FileExp + ":" + FileType);
                                        if (FileType == "") {
                                            //FileType = gJson.Objects["Unknow"].Items["Name"].Value;
                                            FileIcon = gJson["Unknow"]["Icon"].Value;
                                        }

                                        if (FileApp != "") {
                                            if (OpenType == "Ajax") {
                                                OpenUrl = "javascript:;";
                                                szClick = "Page.UI.Open('File_" + FilePath.Replace("/", "_").Replace(".", "_") + "','','" + FileType + "[" + FileName + "]" + "','" + FileDir + "','Process.aspx', {Arg_Path:'" + FilePath + "'});";
                                            } else {
                                                szClick = "";
                                                szTarget = "_blank";
                                                OpenUrl = FileApp + "?Path=" + FilePath;
                                            }

                                        }

                                        Line++;
                                        String LineColor = "background:#fff;";
                                        if (Line % 2 == 0) LineColor = "background:#eef8ff;";

                                        double fLen = fInfo.Length;

                                        if (fLen > 1024 * 1024 * 1024) {
                                            fLen = fLen / (1024 * 1024 * 1024);
                                            fLen = (int)(fLen * 100);
                                            fLen /= 100;
                                            FileLen = fLen + "&nbsp;GB";
                                        } else if (fLen > 1024 * 1024) {
                                            fLen = fLen / (1024 * 1024);
                                            fLen = (int)(fLen * 100);
                                            fLen /= 100;
                                            FileLen = fLen + "&nbsp;MB";
                                        } else if (fLen > 1024) {
                                            fLen = fLen / 1024;
                                            fLen = (int)(fLen * 100);
                                            fLen /= 100;
                                            FileLen = fLen + "&nbsp;KB";
                                        } else {
                                            FileLen = fLen + "&nbsp;B";
                                        }
                                %>
                                <tr style="<%=LineColor%>">
                                    <td style="padding: 4px 0px 0px 0px; width: 16px; text-align: right;">
                                        <img alt="" src="<%=FileIcon %>" width="16" height="16" /></td>
                                    <td style="padding: 3px 0px;"><a href="<%=OpenUrl%>" onclick="<%=szClick%>" target="<%=szTarget%>"><%=FileName%></a></td>
                                    <td style="padding: 3px; text-align: center;"><%=FileType!=""?FileType:FileExp+"文件" %></td>
                                    <td style="padding: 3px; text-align: right;"><%=FileLen%></td>
                                    <td style="padding: 3px; text-align: center;"><%=Ly.Time.Source( fInfo.LastAccessTime).toCommonFormatString%></td>
                                    <td style="padding: 3px; text-align: center;">下载&nbsp;重命名&nbsp;删除</td>
                                </tr>
                                <%
                                    }
                                %>
                            </table>
                        </div>
                    </div>
                </div>
            </div>
            <%pg.Dispose();%>
        </div>
    </form>
</body>
</html>
