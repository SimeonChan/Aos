<%@ Page Language="C#" ValidateRequest="false" Inherits="ClsPage" %>

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
                //string sPath = pg["Setting_Background"];

                string szPath = Server.MapPath(this.WebConfig.SharePath + "/App_Loaded.azs");
                string szCnt = Pub.IO.ReadAllText(szPath);

                using (ClsAjaxRequest js = new ClsAjaxRequest()) {
                    using (AzSqlProgram Asm = new AzSqlProgram(this, this.ConnectString, null)) {
                        try {
                            szCnt = Asm.ExecuteString(szCnt);
                            //char cUtf = (char)0xFF;
                            //string szUtf = "";
                            //szUtf += cUtf;
                            szCnt = szCnt.Replace("\n", "").Replace("\r", "").Replace("\"", "&quot;").Replace((char)0xFF, ' ').Trim();
                            //string szAsc = "";
                            //for (int i = 0; i < szCnt.Length; i++) {
                            //    szAsc += "0x" + Ly.Integer.Source((byte)szCnt[i]).toHex.PadLeft(2, '0');
                            //}
                            //js.Message = szCnt + "<br />" + szAsc;
                            js.Message = szCnt;
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
                    pg.OutPut(js.ToString());
                }
            %>
            <%pg.Dispose();%>
        </div>
    </form>
</body>
</html>
