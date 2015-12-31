<%@ Page Language="C#" Inherits="ClsPage" %>

<!DOCTYPE html>

<script runat="server">
    protected String gstrFullPath;
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
                string szPath = Pub.Request(this, "Path");
                string szName = Pub.Request(this, "Name");
                int nType = Ly.String.Source(Pub.Request(this, "Type")).toInteger;

                //处理目录
                if (Request["Path"] != null) szPath = Request["Path"].ToString().Trim().Replace("\\", "/");
                if (szPath.StartsWith("/") || szPath.IndexOf("..") >= 0) szPath = "";
                if (szPath != "" && !szPath.EndsWith("/")) szPath += "/";
                gstrFullPath = "/" + szPath;

                using (ClsAjaxRequest js = new ClsAjaxRequest()) {

                    if (szName == "") {
                        js.Message = "名称不能为空!";
                    } else {
                        gstrFullPath += szName;
                        string szFilePath = Server.MapPath(gstrFullPath);
                        if (System.IO.Directory.Exists(szFilePath)) {
                            js.Message = "已经存在同名文件夹!";
                        } else if (System.IO.File.Exists(szFilePath)) {
                            js.Message = "已经存在同名文件!";
                        } else {
                            if (nType == 1) {
                                System.IO.Directory.CreateDirectory(szFilePath);
                                js.Refresh = 1;
                            } else {
                                System.IO.StreamWriter sw = System.IO.File.CreateText(szFilePath);
                                sw.Close();
                                sw.Dispose();
                                js.Refresh = 1;
                            }
                            js.Message = "执行成功!";
                        }
                    }

                    pg.OutPutAsText(js.ToString());
                }
            %>
            <%pg.Dispose();%>
        </div>
    </form>
</body>
</html>
