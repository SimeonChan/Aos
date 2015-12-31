<%@ Page Language="C#" ValidateRequest="false" Inherits="ClsPage" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<script runat="server">
    protected int gintTable;
    protected String gstrConnString;

    protected Ly.Formats.JsonObject GetObject(ClsAjaxPage pg, Ly.Formats.JsonObject Obj, string[] szObjs, int index) {

        if (index >= szObjs.Length) return null;

        string szObjsTrim = szObjs[index].Trim();
        if (szObjsTrim == "") return Obj;

        int nIndex = Ly.String.Source(szObjsTrim).toInteger;
        Ly.Formats.JsonObject jup = Obj[nIndex];

        if (index == szObjs.Length - 1) {
            return jup;
        } else {
            index++;
            return GetObject(pg, jup, szObjs, index);
        }

    }

</script>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
    <title></title>
</head>
<body>
    <form id="form1" runat="server">
        <div>
            <%ClsAjaxPage pg = new ClsAjaxPage(this);%>
            <%
                string szPath = pg["Arg_Path"];
                string szObj = pg["Arg_ObjectPath"];
                string szCnt = pg["Arg_Cnt"].Trim();
                string[] szObjs = szObj.Split('|');

                if (szPath.StartsWith("/") || szPath.IndexOf("..") >= 0) {
                    pg.OutPut("不是合法的路径!");
                    pg.Dispose();
                }

                string szFullPath = "/" + szPath;

                string szJson = Pub.IO.ReadAllEncryptionText(Server.MapPath(szFullPath));

                //设置Json内容
                try {
                    bool bChanged = false;
                    using (Ly.Formats.JsonObject json = new Ly.Formats.JsonObject()) {
                        json.InnerJson = szJson;
                        Ly.Formats.JsonObject jup = GetObject(pg, json, szObjs, 0);
                        double dbTemp = 0;
                        if (double.TryParse(szCnt, out dbTemp)) {
                            jup.ValueAsDouble = dbTemp;
                            bChanged = true;
                        } else {
                            try {
                                jup.InnerJson = szCnt;
                                bChanged = true;
                            } catch {
                                pg.PageRequest.Message = "输入的语句不是合法的Json语句!";
                            }
                        }
                        //保存到文件
                        if (bChanged) {
                            Pub.IO.WriteAllEncryptionText(Server.MapPath(szFullPath), json.OuterJson);
                            pg.PageRequest.Message = "保存成功";
                        }
                    }
                } catch {
                    if (szObj != "") {
                        pg.PageRequest.Message = "原Json文件加载失败!";
                    } else {
                        Pub.IO.WriteAllEncryptionText(Server.MapPath(szFullPath), szCnt);
                        pg.PageRequest.Message = "保存成功";
                    }
                }

                pg.OutPutJsonRequest();
            %>
            <%pg.Dispose();%>
        </div>
    </form>
</body>
</html>
