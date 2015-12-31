<%@ Page Language="C#" Inherits="ClsPage" %>

<!DOCTYPE html>

<script runat="server">

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
                string gstrMessage;
                string gstrPath;
                string gstrType;
                string gszName;

                gstrType = "";
                //gstrMessage = "<font color='#0000FF'>等待文件上传...</font>";

                if (this.UserInfo.ID <= 0) {
                    pg.PageRequest.Message = "上传失败:用户登录状态无效!";
                     pg.OutPutJsonRequest();
                }

                String savePath = this.WebConfig.UserPath + "/Upload";
                string szPath = Server.MapPath(savePath);

                if (!System.IO.Directory.Exists(szPath)) System.IO.Directory.CreateDirectory(szPath);

                //如果提交的文件名是空，则不处理
                if (Context.Request.Files.Count == 0) {
                    pg.PageRequest.Message = "未发现上传文件";
                    pg.OutPutJsonRequest();
                    pg.Dispose();
                } else if (Context.Request.Files[0].FileName.Trim() == "") {
                    pg.PageRequest.Message = "未发现上传文件";
                    pg.OutPutJsonRequest();
                    pg.Dispose();
                }

                //if (FileUpload1.HasFile) {
                String filename;
                string szFileName = Context.Request.Files[0].FileName;
                Random Rnd = new Random();
                filename = "F" + Ly.Time.Now.toCommonFormatString.Replace("-", "").Replace(":", "").Replace(" ", "") + Rnd.Next(10000).ToString().PadLeft(4, '0') + System.IO.Path.GetExtension(szFileName);
                savePath += "/" + filename;
                Context.Request.Files[0].SaveAs(Server.MapPath(savePath));
                pg.PageRequest.Message = "文件[Size:" + Context.Request.Files[0].ContentLength + "B]上传成功!";
                gstrPath = savePath;
                pg.PageRequest.GetChild("File")["Type"].Value = Context.Request.Files[0].ContentType.ToLower();
                pg.PageRequest.GetChild("File")["Name"].Value = szFileName;
                pg.PageRequest.GetChild("File")["Path"].Value = savePath;
                //} else {
                //gstrMessage = "<font color='#0000FF'>等待文件上传...</font>";
                //}
                pg.PageRequest.Message = "";
                pg.OutPutJsonRequest();
            %>
            <%pg.Dispose();%>
        </div>
    </form>
</body>
</html>
