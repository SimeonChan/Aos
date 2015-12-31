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
    protected Ly.IO.Json gJson;
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
                string gstrPath = "";
                if (Request["Path"] != null) gstrPath = Request["Path"].ToString().Trim().Replace("\\", "/");
                if (gstrPath.StartsWith("/") || gstrPath.IndexOf("..") >= 0) gstrPath = "";
                if (gstrPath != "" && !gstrPath.EndsWith("/")) gstrPath += "/";
                gstrFullPath = "/" + gstrPath;
                gJson = new Ly.IO.JsonFile(Server.MapPath(WebConfig.SystemExtensionPath), System.Text.Encoding.UTF8);
            %>
            <%
                string szScript = "";
            %>
            <div class="plug-Nav">
                <ul>
                    <li>
                        <div class="pub-left">
                            <a href="javascript:;" onclick="<%=szScript%>">
                                <img src="<%=pg.PageArgs.Path%>images/update.png" width="16" height="16" alt="" style="padding-top: 0px;" /></a>
                        </div>
                        <div class="pub-left"><a href="javascript:;" onclick="<%=szScript%>">上传文件</a></div>
                        <div class="pub-left" style="border-left: 1px solid #CCCCCC; padding-left: 10px; margin-left: 10px;">
                            <a href="javascript:;" onclick="<%=szScript%>">
                                <img src="<%=pg.PageArgs.Path%>images/update.png" width="16" height="16" alt="" style="padding-top: 0px;" /></a>
                        </div>
                        <div class="pub-left"><a href="javascript:;" onclick="<%=szScript%>">添加文件夹</a></div>
                        <div class="pub-left" style="margin-left: 8px;">
                            <a href="javascript:;" onclick="<%=szScript%>">
                                <img src="<%=pg.PageArgs.Path%>images/update.png" width="16" height="16" alt="" style="padding-top: 0px;" /></a>
                        </div>
                        <div class="pub-left"><a href="javascript:;" onclick="<%=szScript%>">添加空文件</a></div>
                        <div class="pub-clear"></div>
                    </li>
                </ul>
                <div style="clear: both;"></div>
            </div>
            <div style="padding: 5px;">
                <div style="float: left;">当前路径:</div>
                <div style="float: left;"><a href="Default.aspx">我的云存储</a></div>
                <%
                    string[] paths = gstrPath.Split('/');
                    string fullpath = "";
                    for (int i = 0; i < paths.Length; i++) {
                        if (paths[i] != "") {
                            fullpath += (fullpath == "") ? paths[i] : "/" + paths[i];
                %>
                <div style="float: left;">&gt;</div>
                <div style="float: left;"><a href="Default.aspx?path=<%=fullpath %>"><%=paths[i]%></a></div>
                <%
                        }
                    }
                %>
                <div style="clear: both"></div>
            </div>
            <div>
                <table style="width: 800px; border-collapse: collapse; border-spacing: 0px;">
                    <tr style="background: #0094ff;">
                        <th colspan="2" style="width: 300px; border-right: 1px solid #fff;">名称</th>
                        <th style="width: 120px; border-right: 1px solid #fff;">类型</th>
                        <th style="width: 80px; border-right: 1px solid #fff;">大小</th>
                        <th style="width: 150px; border-right: 1px solid #fff;">修改日期</th>
                        <th style="">相关操作</th>
                    </tr>
                    <%
                        int Line = 0;
                        String[] Dirs = System.IO.Directory.GetDirectories(Server.MapPath(gstrFullPath));
                        for (int i = 0; i < Dirs.Length; i++) {
                            String[] DirNames = Dirs[i].Split('\\');
                            String DirName = DirNames[DirNames.Length - 1];
                            Line++;
                            String LineColor = "";
                            if (Line % 2 == 0) LineColor = "background:#eef8ff;";
                    %>
                    <tr style="<%=LineColor%>">
                        <td style="padding: 3px 0px; width: 16px;">
                            <img alt="" src="/images/Icon/Folder.png" width="16" height="16" /></td>
                        <td style="padding: 3px 0px;"><a href="Default.aspx?path=<%=gstrPath+DirName%>"><%=DirName%></a></td>
                        <td style="padding: 3px;">文件夹</td>
                        <td style="padding: 3px;">&nbsp;</td>
                        <td style="padding: 3px;">&nbsp;</td>
                        <td style="padding: 3px;">重命名&nbsp;删除</td>
                    </tr>
                    <%
                        }
                    %>
                    <%
                        String[] Files = System.IO.Directory.GetFiles(Server.MapPath(gstrFullPath));
                        for (int i = 0; i < Files.Length; i++) {
                            String FileName = System.IO.Path.GetFileName(Files[i]);
                            String FileExp = System.IO.Path.GetExtension(Files[i]).Replace(".", "");
                            String FileType = gJson.Objects[FileExp].Items["Name"].Value;
                            String FileIcon = gJson.Objects[FileExp].Items["Icon"].Value;
                            String FileApp = gJson.Objects[FileExp].Items["App"].Value;
                            String FileLen = "";
                            System.IO.FileInfo fInfo = new System.IO.FileInfo(Files[i]);
                            String OpenUrl = "javascript:alert('此文件无法直接打开!');";
                            if (FileType == "") {
                                //FileType = gJson.Objects["Unknow"].Items["Name"].Value;
                                FileIcon = gJson.Objects["Unknow"].Items["Icon"].Value;
                            }

                            if (FileApp != "") OpenUrl = FileApp + "?Path=" + gstrPath + FileName;
                            Line++;
                            String LineColor = "";
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
                        <td style="padding: 3px 0px; width: 16px; text-align: right;">
                            <img alt="" src="<%=FileIcon %>" width="16" height="16" /></td>
                        <td style="padding: 3px 0px;"><a href="<%=OpenUrl%>" target="_blank"><%=FileName%></a></td>
                        <td style="padding: 3px;"><%=FileType!=""?FileType:FileExp+"文件" %></td>
                        <td style="padding: 3px; text-align: right;"><%=FileLen%></td>
                        <td style="padding: 3px; text-align: center;"><%=Ly.Time.Source( fInfo.LastAccessTime).toCommonFormatString%></td>
                        <td>下载&nbsp;重命名&nbsp;删除</td>
                    </tr>
                    <%
                        }
                    %>
                </table>
            </div>
            <%pg.Dispose();%>
        </div>
    </form>
</body>
</html>
