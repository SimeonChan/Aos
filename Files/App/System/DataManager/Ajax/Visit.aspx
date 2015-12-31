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

                    long lngTableID = dyk.Type.String.New(this["Arg_Table"]).ToNumber;

                    using (dyk.DB.Base.SystemUserTableVisits.ExecutionExp sutv = new dyk.DB.Base.SystemUserTableVisits.ExecutionExp(this.BaseConnectString)) {
                        if (sutv.GetDataByUserAndTable(this.UserInfo.ID, lngTableID)) {
                            sutv.Structure.LastVisitTime = dyk.Type.Time.Now.ToTimeString();
                            sutv.Structure.Visits++;
                            sutv.UpdateByID();
                        } else {
                            sutv.Structure.LastVisitTime = dyk.Type.Time.Now.ToString;
                            sutv.Structure.TableID = lngTableID;
                            sutv.Structure.UserID = this.UserInfo.ID;
                            sutv.Structure.Visits = 1;
                            sutv.Add();
                        }
                    }

                %>
                <%pg.Dispose();%>
            </table>
        </div>
    </form>
</body>
</html>
