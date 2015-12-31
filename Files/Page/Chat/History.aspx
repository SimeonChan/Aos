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
            <div style="height: 530px; padding: 5px; overflow-wrap: break-word; overflow-y: scroll;">
                <dl id="Chat_List">
                    <%
                        string szSign = Pub.Request(this, "Sign");
                        int nPage = Ly.String.Source(this["pg"]).toInteger;
                        int nPageSize = 15;
                        int nPageAll = 0;

                        //计算总页数
                        using (Ly.Data.SQLClient Conn = new Ly.Data.SQLClient(this.ConnectString)) {

                            if (szSign.StartsWith("User:")) {
                                long nChat = Ly.String.Source(szSign.Split(':')[1]).toLong;
                                Conn.NewCmd("SELECT count(*) as AllCount FROM [SystemChats] where ((ChatSign=@ToSign and [FromUserID]=@SendUserID) or ([ChatSign]=@SendSign and [FromUserID]=@ToUserID))");
                                Conn.AddParameter("@ToSign", "User:" + nChat, System.Data.SqlDbType.VarChar, 50);
                                Conn.AddParameter("@SendSign", "User:" + this.UserInfo.ID, System.Data.SqlDbType.VarChar, 50);
                                Conn.AddParameter("@SendUserID", this.UserInfo.ID, System.Data.SqlDbType.Decimal);
                                Conn.AddParameter("@ToUserID", nChat, System.Data.SqlDbType.Decimal);
                            } else if (szSign.StartsWith("Temp:")) {
                                Conn.NewCmd("SELECT count(*) as AllCount FROM [SystemChats] where ((ChatSign=@ToSign and [FromUserName]=@SendUser) or ([ChatSign]=@SendSign and [FromUserID]=@ToUserID))");
                                Conn.AddParameter("@ToSign", "User:" + this.UserInfo.ID, System.Data.SqlDbType.VarChar, 50);
                                Conn.AddParameter("@SendSign", szSign, System.Data.SqlDbType.VarChar, 50);
                                Conn.AddParameter("@SendUser", szSign, System.Data.SqlDbType.VarChar, 50);
                                Conn.AddParameter("@ToUserID", this.UserInfo.ID, System.Data.SqlDbType.Decimal);
                            } else {
                                Conn.NewCmd("SELECT count(*) as AllCount FROM [SystemChats] where ChatSign=@ToSign");
                                Conn.AddParameter("@ToSign", szSign, System.Data.SqlDbType.VarChar, 50);
                            }

                            Conn.ExecuteReader();
                            if (Conn.DataReader.Read()) {
                                int nAllCount = Ly.String.Source(Conn.DataReader["AllCount"].ToString()).toInteger;
                                nPageAll = nAllCount / nPageSize;
                                if (nAllCount % nPageSize != 0) nPageAll++;
                            }
                        }

                        if (nPageAll < 1) nPageAll = 1;
                        if (nPage <= 0) nPage = 1;
                        if (nPage > nPageAll) nPage = nPageAll;

                        using (Ly.Data.SQLClient Conn = new Ly.Data.SQLClient(this.ConnectString)) {

                            if (szSign.StartsWith("User:")) {
                                long nChat = Ly.String.Source(szSign.Split(':')[1]).toLong;
                                Conn.NewCmd("SELECT Top " + nPageSize + " * FROM [SystemChats] where ((ChatSign=@ToSign and [FromUserID]=@SendUserID) or ([ChatSign]=@SendSign and [FromUserID]=@ToUserID)) and [ID] not in (SELECT Top " + (nPageSize * (nPage - 1)) + " [ID] FROM [SystemChats] where (ChatSign=@ToSign and [FromUserID]=@SendUserID) or ([ChatSign]=@SendSign and [FromUserID]=@ToUserID) order by [DoTime] asc) order by [DoTime] asc");
                                Conn.AddParameter("@ToSign", "User:" + nChat, System.Data.SqlDbType.VarChar, 50);
                                Conn.AddParameter("@SendSign", "User:" + this.UserInfo.ID, System.Data.SqlDbType.VarChar, 50);
                                Conn.AddParameter("@SendUserID", this.UserInfo.ID, System.Data.SqlDbType.Decimal);
                                Conn.AddParameter("@ToUserID", nChat, System.Data.SqlDbType.Decimal);
                            } else if (szSign.StartsWith("Temp:")) {
                                Conn.NewCmd("SELECT Top " + nPageSize + " * FROM [SystemChats] where ((ChatSign=@ToSign and [FromUserName]=@SendUser) or ([ChatSign]=@SendSign and [FromUserID]=@ToUserID)) and [ID] not in (SELECT Top " + (nPageSize * (nPage - 1)) + " [ID] FROM [SystemChats] where (ChatSign=@ToSign and [FromUserID]=@SendUserID) or ([ChatSign]=@SendSign and [FromUserID]=@ToUserID) order by [DoTime] asc) order by [DoTime] asc");
                                Conn.AddParameter("@ToSign", "User:" + this.UserInfo.ID, System.Data.SqlDbType.VarChar, 50);
                                Conn.AddParameter("@SendSign", szSign, System.Data.SqlDbType.VarChar, 50);
                                Conn.AddParameter("@SendUser", szSign, System.Data.SqlDbType.VarChar, 50);
                                Conn.AddParameter("@ToUserID", this.UserInfo.ID, System.Data.SqlDbType.Decimal);
                            } else {
                                Conn.NewCmd("SELECT Top " + nPageSize + " * FROM [SystemChats] where ChatSign=@ToSign and [ID] not in (SELECT Top " + (nPageSize * (nPage - 1)) + " [ID] FROM [SystemChats] where ChatSign=@ToSign order by [DoTime] asc) order by [DoTime] asc");
                                Conn.AddParameter("@ToSign", szSign, System.Data.SqlDbType.VarChar, 50);
                            }

                            Conn.ExecuteReader();
                            while (Conn.DataReader.Read()) {
                                string szTime = Conn.DataReader["DoTime"].ToString();
                    %>
                    <dt><%=Conn.DataReader["FromUserName"].ToString()%>&nbsp;<%=szTime.StartsWith(Ly.Time.Now.toCommonFormatDateString)? DateTime.Parse(szTime).ToString("HH:mm:ss"):szTime%></dt>
                    <dd><%=Conn.DataReader["Content"].ToString()%></dd>
                    <%
                            }
                        }
                    %>
                </dl>
            </div>
            <div style="height: 20px;">
                <%if (nPage > 1) { %>
                <div style="float: left;" onclick="Page.GetHistory(<%="'" + szSign + "'"%>,1);"><a href="javascript:;">[首页]</a></div>
                <%} %>
                <%if (nPage > 1) { %>
                <div style="float: left;" onclick="Page.GetHistory(<%="'" + szSign + "'"%>,<%=nPage-1%>);"><a href="javascript:;">[上一页]</a></div>
                <%} %>
                <%for (int i = nPage - 5; i < nPage; i++) {%>
                <%if (i > 0) { %>
                <div style="float: left;" onclick="Page.GetHistory(<%="'" + szSign + "'"%>,<%=i%>);"><a href="javascript:;">[<%=i%>]</a></div>
                <%} %>
                <%} %>
                <div style="float: left; padding-top: 2px;">[<%=nPage%>]</div>
                <%for (int i = nPage + 1; i <= nPage + 5; i++) {%>
                <%if (i <= nPageAll) { %>
                <div style="float: left;" onclick="Page.GetHistory(<%="'" + szSign + "'"%>,<%=i%>);"><a href="javascript:;">[<%=i%>]</a></div>
                <%} %>
                <%} %>
                <%if (nPage < nPageAll) { %>
                <div style="float: left;" onclick="Page.GetHistory(<%="'" + szSign + "'"%>,<%=nPage+1%>);"><a href="javascript:;">[下一页]</a></div>
                <%} %>
                <%if (nPage < nPageAll) { %>
                <div style="float: left;" onclick="Page.GetHistory(<%="'" + szSign + "'"%>,<%=nPageAll%>);"><a href="javascript:;">[末页]</a></div>
                <%} %>
            </div>
            <%pg.Dispose();%>
        </div>
    </form>
</body>
</html>
