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
            <%ClsAjaxPage pg = new ClsAjaxPage(this); %>
            <%
                string szFile = Server.MapPath(this.WebConfig.UserPath + "/Order.json");
                //pg.OutPutAsText("Manager:" + this.Session.Manager);
                //pg.OutPut("<br />");
                //pg.OutPutAsText(szFile);
                string szJson = Pub.IO.ReadAllEncryptionText(szFile);
                Ly.Formats.Json2 Json = new Ly.Formats.Json2(szJson);
                int nTable = Ly.String.Source(pg.PageArgs.Table).toInteger;
                //pg.OutPutAsText(szJson);
            %>
            <table style="width: 100%; border-collapse: collapse; background: #fff;">
                <tr>
                    <th style="width: 50%; background: #0094ff; border-right: 1px solid #fff; color: #fff; padding: 5px">字段名称</th>
                    <th style="width: 30%; background: #0094ff; border-right: 1px solid #fff; color: #fff; padding: 5px">排序选项</th>
                    <th style="background: #0094ff; color: #fff; padding: 5px">顺序</th>
                </tr>
                <%
                    Ly.Formats.JsonObject obj = Json["Table_" + nTable];
                    for (int i = 0; i < obj.Count; i++) {
                        string szName = obj[i]["Name"].Value;
                        string szOrder = obj[i]["Order"].Value;
                        using (Ly.DB.Dream.SystemColumns.ExecutionExp sc = new Ly.DB.Dream.SystemColumns.ExecutionExp(this.ConnectString)) {
                            sc.GetDataByParentIDAndName(nTable, szName);
                %>
                <tr>
                    <td style="border-right: 1px solid #ddd; border-bottom: 1px solid #ddd; color: #222; padding: 5px;"><%=sc.Structure.Text%></td>
                    <%if (szOrder == "asc") { %>
                    <td style="border-right: 1px solid #ddd; border-bottom: 1px solid #ddd; color: #222; padding: 5px; text-align: center;"><span style="color: #090; padding: 1px; border: 1px solid #090;">&nbsp;◆&nbsp;升序&nbsp;</span>&nbsp;&nbsp;&nbsp;<span style="color: #222; padding: 1px; border: 1px solid #fff;">&nbsp;<a href="javascript:;" onclick="Page.Functions.OA.Table.OrderSave('<%=pg.PageArgs.UID%>',{Arg_Column:'<%=sc.Structure.Name%>',Arg_Order:'desc'});">◇&nbsp;降序</a>&nbsp;</span>&nbsp;&nbsp;&nbsp;<span style="color: #222; padding: 1px; border: 1px solid #fff;">&nbsp;<a href="javascript:;" onclick="Page.Functions.OA.Table.OrderDelete('<%=pg.PageArgs.UID%>',{Arg_Column:'<%=sc.Structure.Name%>',Arg_Order:'asc'});">◇&nbsp;无</a>&nbsp;</span></td>
                    <%} else { %>
                    <td style="border-right: 1px solid #ddd; border-bottom: 1px solid #ddd; color: #222; padding: 5px; text-align: center;"><span style="color: #222; padding: 1px; border: 1px solid #fff;">&nbsp;<a href="javascript:;" onclick="Page.Functions.OA.Table.OrderSave('<%=pg.PageArgs.UID%>',{Arg_Column:'<%=sc.Structure.Name%>',Arg_Order:'asc'});">◇&nbsp;升序</a>&nbsp;</span>&nbsp;&nbsp;&nbsp;<span style="color: #090; padding: 1px; border: 1px solid #090;">&nbsp;◆&nbsp;降序&nbsp;</span>&nbsp;&nbsp;&nbsp;<span style="color: #222; padding: 1px; border: 1px solid #fff;">&nbsp;<a href="javascript:;" onclick="Page.Functions.OA.Table.OrderDelete('<%=pg.PageArgs.UID%>',{Arg_Column:'<%=sc.Structure.Name%>',Arg_Order:'asc'});">◇&nbsp;无</a>&nbsp;</span></td>
                    <%} %>
                    <td style="border-bottom: 1px solid #ddd; color: #222; padding: 5px; text-align: center;"><a href="javascript:;" onclick="Page.Functions.OA.Table.OrderUp('<%=pg.PageArgs.UID%>',{Arg_Column:'<%=sc.Structure.Name%>'});">↑&nbsp;上移</a>&nbsp;&nbsp;&nbsp;&nbsp;<a href="javascript:;" onclick="Page.Functions.OA.Table.OrderDown('<%=pg.PageArgs.UID%>',{Arg_Column:'<%=sc.Structure.Name%>'});">↓&nbsp;下移</a></td>
                </tr>
                <%
                        }
                    }
                %>
                <%
                    using (Ly.DB.Dream.SystemColumns.ExecutionExp sc = new Ly.DB.Dream.SystemColumns.ExecutionExp(this.ConnectString)) {
                        sc.GetDatasByParentID(nTable);
                        for (int i = 0; i < sc.StructureCollection.Count; i++) {
                            bool bFound = false;
                            for (int j = 0; j < obj.Count; j++) {
                                string szName = obj[j]["Name"].Value;
                                if (szName == sc.StructureCollection[i].Name) {
                                    bFound = true;
                                    break;
                                }
                            }
                            if (!bFound) {
                %>
                <tr>
                    <td style="border-right: 1px solid #ddd; border-bottom: 1px solid #ddd; color: #222; padding: 5px;"><%=sc.StructureCollection[i].Text%></td>
                    <td style="border-right: 1px solid #ddd; border-bottom: 1px solid #ddd; color: #222; padding: 5px; text-align: center;"><span style="color: #222; padding: 1px; border: 1px solid #fff;">&nbsp;<a href="javascript:;" onclick="Page.Functions.OA.Table.OrderSave('<%=pg.PageArgs.UID%>',{Arg_Column:'<%=sc.StructureCollection[i].Name%>',Arg_Order:'asc'});">◇&nbsp;升序</a>&nbsp;</span>&nbsp;&nbsp;&nbsp;<span style="color: #222; padding: 1px; border: 1px solid #fff;">&nbsp;<a href="javascript:;" onclick="Page.Functions.OA.Table.OrderSave('<%=pg.PageArgs.UID%>',{Arg_Column:'<%=sc.StructureCollection[i].Name%>',Arg_Order:'desc'});">◇&nbsp;降序</a>&nbsp;</span>&nbsp;&nbsp;&nbsp;<span style="color: #090; padding: 1px; border: 1px solid #090;">&nbsp;◆&nbsp;无&nbsp;</span></td>
                    <td style="border-bottom: 1px solid #ddd; color: #222; padding: 5px; text-align: center;">-</td>
                </tr>
                <%
                            }
                        }
                    }
                %>
            </table>
            <%pg.Dispose();%>
        </div>
    </form>
</body>
</html>
