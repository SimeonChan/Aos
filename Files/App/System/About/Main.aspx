<%@ Page Language="C#" Inherits="ClsPage" %>

<!DOCTYPE html>

<script runat="server">
    protected String gstrConnString;
    protected long gintTable;
    protected long glngRelation;
    protected long glngID;
    protected int gintIndex;
    protected string gstrArgs;

    protected Ly.DB.Dream.AzTables gTab;
    protected String gstrFullPath;
    protected Ly.IO.Json gJson;
    protected int gintWidth;
    protected int gintHeight;
    protected int gintLines;
    protected int gintPage;
    protected string gstrSQL;
    protected Ly.IO.Json gAddJson;
    protected string gstrRelation;
</script>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
    <title></title>
    <link href="../../../../css/Plug.css" rel="stylesheet" />
</head>
<body>
    <form id="form1" runat="server">
        <div>
            <%ClsAjaxPage pg = new ClsAjaxPage(this); %>
            <%
            %>
            <div style="position: absolute; top: 0px; left: 0px; z-index: 1; width: 100%; height: 100%; overflow: auto; color: #222; font-size: 14px; background: #fff;">
                <div style="padding: 15px 20px 10px 15px; color: #0026ff; font-size: 22px; font-weight: bold;">
                    <div style="float: left; padding: 0px;">
                        <img src="<%=pg.PageArgs.UIPath%>logo.png" alt="" title="" width="36" />
                    </div>
                    <div style="float: left; padding: 4px 0px 0px 5px;">关于 云谊通</div>
                    <div style="clear: both;"></div>
                </div>
                <div style="width: 100%; background: #0094ff; padding: 10px 15px; font-size: 18px; font-weight: bold; color: #fff; box-sizing: border-box; -moz-box-sizing: border-box; -webkit-box-sizing: border-box;">基本信息</div>
                <div style="padding: 10px 20px; line-height: 24px;">
                    <div style="float: left; padding: 20px 30px 0px 10px;">
                        <img alt="" src="<%=pg.XPortArgs.UI_Path%>images/trademark.png" />
                    </div>
                    <div style="float: left;">
                        <span style="font-size: 18px; color: #0094ff;"><%=ClsSite.AppProduceName%></span>&nbsp;<span style="font-size: 12px;">版本号&nbsp;<%=ClsSite.AppVersion%></span><br />
                        官方网站：<a href="<%=ClsSite.AppTechnicalUrl%>" target="_blank"><%=ClsSite.AppTechnicalUrl%></a><br />
                        产品基于&nbsp;<a href="<%=ClsSite.AppKernelUrl%>" target="_blank"><%=ClsSite.AppKernelName%></a>&nbsp;技术二次构架<br />
                        Copyright&nbsp;©&nbsp;<%=DateTime.Now.Year%>&nbsp;<a href="<%=ClsSite.AppProduceCompanyUrl%>" target="_blank"><%=ClsSite.AppProduceCompany%></a>&nbsp;版权所有<br />
                    </div>
                    <div style="clear: both;"></div>
                </div>
                <%
                    using (dyk.DB.Aos.AosAuthorize.ExecutionExp sa = new dyk.DB.Aos.AosAuthorize.ExecutionExp(this.AosConnectString)) {
                        sa.GetDataByID(this.AuthorizeID);
                %>
                <div style="width: 100%; background: #0094ff; padding: 10px 15px; font-size: 18px; font-weight: bold; color: #fff; box-sizing: border-box; -moz-box-sizing: border-box; -webkit-box-sizing: border-box;">激活信息</div>
                <div style="padding: 10px 20px; line-height: 24px;">
                    版本：<%=ClsSite.AppAuType%><br />
                    授权对象：<%=sa.Structure.Name%><br />
                    序列号：<%=sa.Structure.Code%><br />
                </div>
                <%
                    }
                %>
                <div style="width: 100%; background: #0094ff; padding: 10px 15px; font-size: 18px; font-weight: bold; color: #fff; box-sizing: border-box; -moz-box-sizing: border-box; -webkit-box-sizing: border-box;">更新日志</div>
                <div style="padding: 10px 20px;">
                    <%
                        dyk.WebSite.UpdateInfo uInfo = new dyk.WebSite.UpdateInfo();
                    %>
                    <%for (int i = 0; i < uInfo.Items.Count; i++) { %>
                    <div style="font-size: 16px; font-weight: bold;">Version&nbsp;<%=uInfo.Items[i].Version%></div>
                    <%for (int j = 0; j < uInfo.Items[i].Items.Count; j++) { %>
                    <div style="text-indent: 14px; line-height: 24px;"><%=j+1%>、<%=uInfo.Items[i].Items[j]%></div>
                    <%} %>
                    <%} %>
                </div>
            </div>
            <%pg.Dispose();%>
        </div>
    </form>
</body>
</html>
