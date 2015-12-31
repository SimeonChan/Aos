using System;
using System.Collections.Generic;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class Upload : ClsPage {
    protected string gstrMessage;
    protected string gstrPath;
    protected string gstrType;
    protected string gszName;

    protected void Page_Load(object sender, EventArgs e) {
        gstrType = "";
        //gstrMessage = "<font color='#0000FF'>等待文件上传...</font>";

        String savePath = this.WebConfig.UserPath + "/Upload";
        string szPath = Server.MapPath(savePath);

        if (!System.IO.Directory.Exists(szPath)) System.IO.Directory.CreateDirectory(szPath);

        if (FileUpload1.HasFile) {
            String filename;
            Random Rnd = new Random();
            filename = "F" + Ly.Time.Now.toCommonFormatString.Replace("-", "").Replace(":", "").Replace(" ", "") + Rnd.Next(10000).ToString().PadLeft(4, '0') + System.IO.Path.GetExtension(FileUpload1.FileName);
            savePath += "/" + filename;
            FileUpload1.SaveAs(Server.MapPath(savePath));
            gstrMessage = "<font color='#009900'>文件[Size:" + FileUpload1.PostedFile.ContentLength + "B]上传成功!</font>";
            gstrPath = savePath;
            gstrType = FileUpload1.PostedFile.ContentType.ToLower();
            gszName = FileUpload1.FileName;
        } else {
            gstrMessage = "<font color='#0000FF'>等待文件上传...</font>";
        }

    }
    protected void Button1_Click(object sender, EventArgs e) {

    }
}