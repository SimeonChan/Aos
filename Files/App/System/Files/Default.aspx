<%@ Page Language="C#" AutoEventWireup="true" CodeFile="Default.aspx.cs" Inherits="Files_App_Com_Setting_Default" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
    <title>文档管理器 - <%=gstrPath%></title>
    <link href="Default.css" rel="stylesheet" />
</head>
<body>
    <script language="javascript" type="text/javascript" src="/js/jquery-1.10.2.min.js"></script>
    <script language="javascript" type="text/javascript" src="/js/Controls/AjaxRequest.js"></script>
    <script language="javascript" type="text/javascript" src="js/Default.js"></script>
    <form id="form1" runat="server">
        <div class="Nav">
            <div style="float: left;">当前路径:</div>
            <ul>
                <li><a href="Default.aspx">我的云存储</a></li>
                <%
                    string[] paths = gstrPath.Split('/');
                    string fullpath = "";
                    for (int i = 0; i < paths.Length; i++) {
                        if (paths[i] != "") {
                            fullpath += (fullpath == "") ? paths[i] : "/" + paths[i];
                %>
                <li>&gt;</li>
                <li><a href="Default.aspx?path=<%=fullpath %>"><%=paths[i]%></a></li>
                <%
                        }
                    }
                %>
            </ul>
            <div style="clear: both"></div>
        </div>
        <div class="ListView">
            <table>
                <tr>
                    <th style="width: 16px; padding: 0px; border-right: 0px;">&nbsp;</th>
                    <th style="width: 280px; border-left: 0px;">名称</th>
                    <th style="width: 120px;">类型</th>
                    <th style="width: 80px;">大小</th>
                    <th style="width: 150px;">修改日期</th>
                    <th style="width: 150px;">相关操作</th>
                </tr>
                <tr>
                    <td style="padding: 0px;">&nbsp;</td>
                    <td>
                        <input id="txtName" type="text" style="width: 280px;" />
                    </td>
                    <td>
                        <select id="selType">
                            <option value="0" selected="selected">文件</option>
                            <option value="1">文件夹</option>
                        </select>
                    </td>
                    <td>&nbsp;</td>
                    <td>&nbsp;</td>
                    <td>
                        <ul>
                            <li><a href="javascript:;" onclick="Page.Add('<%=gstrPath%>');">保存</a></li>
                        </ul>
                        <div style="clear: both"></div>
                    </td>
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
                    <td style="padding: 0px;">
                        <img alt="" src="/images/Icon/Folder.png" width="16" height="16" /></td>
                    <td><a href="Default.aspx?path=<%=gstrPath+DirName%>"><%=DirName%></a></td>
                    <td>文件夹</td>
                    <td>&nbsp;</td>
                    <td>&nbsp;</td>
                    <td>&nbsp;</td>
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
                    <td style="padding: 0px;">
                        <img alt="" src="<%=FileIcon %>" width="16" height="16" /></td>
                    <td><a href="<%=OpenUrl%>" target="_blank"><%=FileName%></a></td>
                    <td><%=FileType!=""?FileType:FileExp+"文件" %></td>
                    <td style="text-align: right;"><%=FileLen%></td>
                    <td style="text-align: center;"><%=Ly.Time.Source( fInfo.LastAccessTime).toCommonFormatString%></td>
                    <td>&nbsp;</td>
                </tr>
                <%
                    }
                %>
            </table>
        </div>
    </form>
</body>
</html>
