<%@ Page Language="C#" Inherits="ClsPage" ValidateRequest="false" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<script runat="server">
    protected int gintTable;
    //protected int gintColumn;
    protected String gstrColumn;
    protected String gstrConnString;
    protected String gstrFullPath;
    protected Ly.Formats.Json gJson;
    protected string gstrFormStyle;
    protected string gstrFormContent;
    protected string gstrFormScript;
    protected Ly.IO.Json gCache = new Ly.IO.Json();

    protected string gszSql;
</script>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
    <title></title>
    <link href="/css/Page.css" rel="stylesheet" />
    <link href="Css/Default.css" rel="stylesheet" />
</head>
<body>
    <form id="form1" runat="server">
        <div>
            <table>

                <%ClsAjaxPage pg = new ClsAjaxPage(this); %>
                <%
                    string szKey = "0123456789";
                    string szCode = "";
                    Random rnd = new Random();
                    bool bFound = false;

                    while (!bFound) {
                        szCode = "";
                        for (int i = 0; i < 4; i++) {
                            if (i > 0) szCode += "-";
                            for (int j = 0; j < 4; j++) {
                                char chr = szKey[rnd.Next(szKey.Length)];
                                szCode += chr;
                            }
                        }
                        using (dyk.DB.Aos.AosAuthorize.ExecutionExp aa = new dyk.DB.Aos.AosAuthorize.ExecutionExp(this.AosConnectString)) {
                            bFound = !aa.GetDataByCode(szCode);
                        }
                    }

                    using (dyk.DB.Aos.AosAuthorize.ExecutionExp aa = new dyk.DB.Aos.AosAuthorize.ExecutionExp(this.AosConnectString)) {
                        aa.Structure.Code = szCode;
                        aa.Add();
                    }

                    using (dyk.DB.Aos.AosAuthorize.ExecutionExp aa = new dyk.DB.Aos.AosAuthorize.ExecutionExp(this.AosConnectString)) {
                        aa.GetDataByCode(szCode);
                %>
                <tr id="Aos_Auth_tr_<%=aa.Structure.ID%>">
                    <td style="border-right: 1px solid #eee; border-bottom: 1px solid #eee; padding: 3px; text-align: right;" onclick="X.Custom.AosAuth.Select(<%=aa.Structure.ID%>);">-</td>
                    <td id="Aos_Auth_tr_<%=aa.Structure.ID%>_td_Name" style="border-right: 1px solid #eee; border-bottom: 1px solid #eee; padding: 3px;">
                        <div style="width: 100%;" onclick="X.Custom.AosAuth.Edit(<%=aa.Structure.ID%>,'Name');"><%=aa.Structure.Name!=""?aa.Structure.Name:"&nbsp;"%></div>
                    </td>
                    <td id="Aos_Auth_tr_<%=aa.Structure.ID%>_td_Code" style="border-right: 1px solid #eee; border-bottom: 1px solid #eee; padding: 3px; text-align: center;"><%=aa.Structure.Code%></td>
                    <td id="Aos_Auth_tr_<%=aa.Structure.ID%>_td_Lv" style="border-right: 1px solid #eee; border-bottom: 1px solid #eee; padding: 3px; text-align: center;">
                        <div style="width: 100%;" onclick="X.Custom.AosAuth.Edit(<%=aa.Structure.ID%>,'Lv');"><%=aa.Structure.Lv!=""?aa.Structure.Lv:"&nbsp;"%></div>
                    </td>
                    <td id="Aos_Auth_tr_<%=aa.Structure.ID%>_td_DBSign" style="border-right: 1px solid #eee; border-bottom: 1px solid #eee; padding: 3px; text-align: center;">
                        <div style="width: 100%;" onclick="X.Custom.AosAuth.Edit(<%=aa.Structure.ID%>,'DBSign');"><%=aa.Structure.DBSign!=""?aa.Structure.DBSign:"&nbsp;"%></div>
                    </td>
                    <td id="Aos_Auth_tr_<%=aa.Structure.ID%>_td_DBIP" style="border-right: 1px solid #eee; border-bottom: 1px solid #eee; padding: 3px;">
                        <div style="width: 100%;" onclick="X.Custom.AosAuth.Edit(<%=aa.Structure.ID%>,'DBIP');"><%=aa.Structure.DBIP!=""?aa.Structure.DBIP:"&nbsp;"%></div>
                    </td>
                    <td id="Aos_Auth_tr_<%=aa.Structure.ID%>_td_DBUser" style="border-right: 1px solid #eee; border-bottom: 1px solid #eee; padding: 3px;">
                        <div style="width: 100%;" onclick="X.Custom.AosAuth.Edit(<%=aa.Structure.DBUser%>,'Lv');"><%=aa.Structure.DBUser!=""?aa.Structure.DBUser:"&nbsp;"%></div>
                    </td>
                    <td id="Aos_Auth_tr_<%=aa.Structure.ID%>_td_DBPwd" style="border-right: 1px solid #eee; border-bottom: 1px solid #eee; padding: 3px;">
                        <div style="width: 100%;" onclick="X.Custom.AosAuth.Edit(<%=aa.Structure.ID%>,'DBPwd');"><%=aa.Structure.DBPwd!=""?aa.Structure.DBPwd:"&nbsp;"%></div>
                    </td>
                    <td id="Aos_Auth_tr_<%=aa.Structure.ID%>_td_Status" style="border-right: 1px solid #eee; border-bottom: 1px solid #eee; padding: 3px; text-align: center;"><span style="color: #CCC;">×</span></td>
                    <td style="border-bottom: 1px solid #eee; padding: 4px;">&nbsp;</td>
                </tr>
                <%
                    }
                %>
                <%pg.Dispose();%>
            </table>
        </div>
    </form>
</body>
</html>
