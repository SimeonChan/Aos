<%@ Page Language="C#" Inherits="ClsPage" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<script runat="server">

</script>

<%Response.Clear();%>
<%

    string szID = this["ID"];
    string szKeys = "0123456789";
    string szCode = "";

    Random rnd = new Random();
    int nKeyLen = rnd.Next(3, 7);

    int nWidth = 200;
    int nHeight = 50;
    int nKeyUnit = nWidth / nKeyLen;

    using (System.IO.MemoryStream ms = new System.IO.MemoryStream()) {
        using (System.Drawing.Bitmap bmp = new System.Drawing.Bitmap(nWidth, nHeight)) {
            using (System.Drawing.Graphics g = System.Drawing.Graphics.FromImage(bmp)) {
                g.Clear(System.Drawing.Color.White);

                //生成验证码
                for (int i = 0; i < nKeyLen; i++) {
                    int nIndex = rnd.Next(szKeys.Length);
                    szCode += szKeys[nIndex];
                    System.Drawing.Color color1 = System.Drawing.Color.FromArgb(rnd.Next(200), rnd.Next(200), rnd.Next(200));
                    System.Drawing.Color color2 = System.Drawing.Color.FromArgb(rnd.Next(200), rnd.Next(200), rnd.Next(200));
                    int nTop = rnd.Next(6);
                    int nLeft = i * nKeyUnit + rnd.Next(10);
                    float nFontSize = rnd.Next(160, 250) / 10.0f;
                    System.Drawing.Font font = new System.Drawing.Font("Verdana", nFontSize, System.Drawing.FontStyle.Bold);
                    using (System.Drawing.Drawing2D.LinearGradientBrush lgb = new System.Drawing.Drawing2D.LinearGradientBrush(new System.Drawing.PointF(0, 0), new System.Drawing.PointF(0, 50), color1, color2)) {
                        g.DrawString(szKeys[nIndex].ToString(), font, lgb, nLeft, nTop);
                    }
                }

                string szName = "VerificationCode";
                if (szID != "") szName += "_" + szID;
                //Session[szName] = szCode;
                this.Session[szName] = szCode;

                //随机生成干扰线
                int nLines = rnd.Next(10, 20);
                for (int i = 0; i < nLines; i++) {
                    System.Drawing.Color color1 = System.Drawing.Color.FromArgb(rnd.Next(200), rnd.Next(200), rnd.Next(200));
                    System.Drawing.Color color2 = System.Drawing.Color.FromArgb(rnd.Next(200), rnd.Next(200), rnd.Next(200));
                    System.Drawing.Point p1 = new System.Drawing.Point(rnd.Next(nWidth), rnd.Next(nHeight));
                    System.Drawing.Point p2 = new System.Drawing.Point(rnd.Next(nWidth), rnd.Next(nHeight));
                    float fSize = rnd.Next(10, 20) / 10.0f;
                    using (System.Drawing.Drawing2D.LinearGradientBrush lgb = new System.Drawing.Drawing2D.LinearGradientBrush(new System.Drawing.PointF(0, 0), new System.Drawing.PointF(0, 50), color1, color2)) {
                        System.Drawing.Pen pen = new System.Drawing.Pen(lgb, fSize);
                        g.DrawLine(pen, p1, p2);
                    }
                }

            }
            bmp.Save(ms, System.Drawing.Imaging.ImageFormat.Gif);
            Response.ClearContent();
            Response.ContentType = "image/Gif";
            Response.BinaryWrite(ms.ToArray());
        }
    }

%>
<%Response.End();%>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
    <title></title>
</head>
<body>
    <form id="form1" runat="server">
        <div>
        </div>
    </form>
</body>
</html>
