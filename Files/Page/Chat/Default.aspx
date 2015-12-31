<%@ Page Language="C#" AutoEventWireup="true" CodeFile="Default.aspx.cs" Inherits="Files_App_Com_Setting_Default" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
    <title>闪信通(Web) - 专业企业即时通讯工具</title>
    <link href="../../../css/Page.css" rel="stylesheet" />
    <link href="Default.css" rel="stylesheet" />
</head>
<body>
    <script language="javascript" type="text/javascript" src="/js/jquery-1.10.2.min.js"></script>
    <script language="javascript" type="text/javascript" src="/js/Controls/AjaxRequest.js"></script>
    <script language="javascript" type="text/javascript" src="js/Default.js"></script>
    <form id="form1" runat="server">
        <div class="Line">
            <div class="pub-left">
                <div class="Line-Title">通讯列表</div>
                <div class="Line-Left">
                    <%if (this.UserInfo.ID > 0) { %>
                    <ul>
                        <li class="li-title">部门通讯</li>
                        <%
                            //Response.End();
                            int nChat = 0;
                            using (Ly.Data.SQLClient Conn = new Ly.Data.SQLClient(this.ConnectString)) {
                                Conn.NewCmd("Select * from SystemDepartments where [ID]=@ID");
                                Conn.AddParameter("@ID", this.UserInfo.Department, System.Data.SqlDbType.Decimal);
                                Conn.ExecuteReader();
                                while (Conn.DataReader.Read()) {
                                    nChat = Ly.String.Source(Conn.DataReader["ID"].ToString()).toInteger;
                        %>
                        <%if (gnType == 1 && gnChat == nChat) {%>
                        <li class="li-select"><%=Conn.DataReader["Name"].ToString()%></li>
                        <%} else { %>
                        <li><a href="Default.aspx?Type=1&ID=<%=nChat%>"><%=Conn.DataReader["Name"].ToString()%></a><span id="Department_<%=nChat%>"></span></li>
                        <%} %>
                        <%
                                }
                            }
                        %>
                        <li class="li-title">个人通讯</li>
                        <%
                            using (Ly.Data.SQLClient Conn = new Ly.Data.SQLClient(this.ConnectString)) {
                                Conn.NewCmd("Select * from [SystemUsers] where ([Department]=@Department or ID in (Select [UserID] From SystemUserGroups where GroupID in  (Select SystemGroups.[ID] from SystemGroups,SystemUserGroups where SystemGroups.[ID]=SystemUserGroups.[GroupID] and [SystemUserGroups].[UserID]=@UserID)))  and ID<>@UserID");
                                Conn.AddParameter("@Department", this.UserInfo.Department, System.Data.SqlDbType.Decimal);
                                Conn.AddParameter("@UserID", this.UserInfo.ID, System.Data.SqlDbType.Decimal);
                                Conn.ExecuteReader();
                                while (Conn.DataReader.Read()) {
                                    nChat = Ly.String.Source(Conn.DataReader["ID"].ToString()).toInteger;
                        %>
                        <%if (gnType == 2 && gnChat == nChat) {%>
                        <li class="li-select"><%=Conn.DataReader["Nick"].ToString()%></li>
                        <%} else { %>
                        <li><a href="Default.aspx?Type=2&ID=<%=nChat%>"><%=Conn.DataReader["Nick"].ToString()%></a><span id="User_<%=nChat%>"></span></li>
                        <%} %>
                        <%
                                }
                            }
                        %>
                        <li class="li-title">组通讯</li>
                        <%
                            using (Ly.Data.SQLClient Conn = new Ly.Data.SQLClient(this.ConnectString)) {
                                Conn.NewCmd("Select SystemGroups.* from SystemGroups,SystemUserGroups where SystemGroups.[ID]=SystemUserGroups.[GroupID] and [SystemUserGroups].[UserID]=@UserID and (SystemGroups.[Name] not like '%客户%')");
                                Conn.AddParameter("@UserID", this.UserInfo.ID, System.Data.SqlDbType.Decimal);
                                Conn.ExecuteReader();
                                while (Conn.DataReader.Read()) {
                                    nChat = Ly.String.Source(Conn.DataReader["ID"].ToString()).toInteger;
                        %>
                        <%if (gnType == 3 && gnChat == nChat) {%>
                        <li class="li-select"><%=Conn.DataReader["Name"].ToString()%></li>
                        <%} else { %>
                        <li><a href="Default.aspx?Type=3&ID=<%=nChat%>"><%=Conn.DataReader["Name"].ToString()%></a><span id="Group_<%=nChat%>"></span></li>
                        <%} %>
                        <%
                                }
                            }
                        %>
                    </ul>
                    <ul id="Chat_Temp">
                        <%
                            gTabs.SystemGroups.GetDataByName("游客资讯");
                            if (gTabs.SystemUserGroups.GetDataByUserAndGroup(this.UserInfo.ID, gTabs.SystemGroups.Structure.ID)) {
                        %>
                        <li class="li-title">临时通讯</li>
                        <%
                            using (Ly.Data.SQLClient Conn = new Ly.Data.SQLClient(this.ConnectString)) {
                                Conn.NewCmd("Select [FromUserName],Max([DoTime]) as LastTime from SystemChats where (ChatSign=@UserSign and  FromUserID=0) and (left([DoTime],10)=@Day1 or left([DoTime],10)=@Day2) group by FromUserName");
                                Conn.AddParameter("@UserSign", "User:" + this.UserInfo.ID, System.Data.SqlDbType.VarChar, 50);
                                Conn.AddParameter("@Day1", Ly.Time.Now.toCommonFormatDateString, System.Data.SqlDbType.VarChar, 50);
                                Conn.AddParameter("@Day2", Ly.Time.Source(DateTime.Now.AddDays(-1)).toCommonFormatDateString, System.Data.SqlDbType.VarChar, 50);
                                Conn.ExecuteReader();
                                while (Conn.DataReader.Read()) {
                                    string szSign = Conn.DataReader["FromUserName"].ToString();
                                    string szLastTime = Conn.DataReader["LastTime"].ToString();
                        %>
                        <%if (gnType == 4 && gszSign == szSign) {%>
                        <li class="li-select">临时访客[<%=szSign.Substring(szSign.Length - 6)%>]</li>
                        <%} else { %>
                        <li><a href="Default.aspx?Type=4&Sign=<%=szSign%>">临时访客[<%=szSign.Substring(szSign.Length - 6)%>]</a><span id="<%=szSign.Replace(":", "_")%>"></span></li>
                        <%} %>
                        <%
                                    }
                                }
                            }
                        %>
                    </ul>
                    <%} else {%>
                    <%
                        if (gnType != 2) {
                            gnType = 2;
                            gnChat = 0;
                        }
                    %>
                    <ul>
                        <li class="li-title">资讯客服</li>
                        <%
                            gTabs.SystemGroups.GetDataByName("游客资讯");
                            gTabs.SystemUsers.GetDatasByGroup((int)gTabs.SystemGroups.Structure.ID);
                            for (int i = 0; i < gTabs.SystemUsers.StructureCollection.Count; i++) {
                                int nChat = (int)gTabs.SystemUsers.StructureCollection[i].ID;
                        %>
                        <%if (i == 0) {%>
                        <%
                            if (gnChat == 0) {
                                gnChat = nChat;
                                gszSign = "User:" + gnChat;
                            }
                        %>
                        <li class="li-select"><%=gTabs.SystemUsers.StructureCollection[i].Nick%></li>
                        <%} else { %>
                        <li><a href="Default.aspx?Type=2&ID=<%=nChat%>"><%=gTabs.SystemUsers.StructureCollection[i].Nick%></a></li>
                        <%} %>
                        <%
                            }
                        %>
                    </ul>
                    <%} %>
                </div>
            </div>
            <div class="pub-left Line-Center">
                <div class="Line-Center-A">
                    <div class="Line-Chat">
                        <dl id="Chat_List">
                            <%
                                //建立用户读取标志
                                if (!gTabs.SystemUserChats.GetDataByUserAndSign(this.UserInfo.ID, gszSign)) {
                                    if (this.UserInfo.ID > 0) {
                                        gTabs.SystemUserChats.Structure.ChatSign = gszSign;
                                        gTabs.SystemUserChats.Structure.UserID = this.UserInfo.ID;
                                        gTabs.SystemUserChats.Structure.ChatID = 0;
                                        gTabs.SystemUserChats.Add();

                                        gTabs.SystemUserChats.GetDataByUserAndSign(this.UserInfo.ID, gszSign);
                                    }
                                }

                                if (gnType == 2) {
                                    if (this.UserInfo.ID > 0) {
                                        gTabs.SystemChats.GetDatasByUser(this.UserInfo.ID, gnChat, 20);
                                    } else {
                                        gTabs.SystemChats.GetDatasByTempUser("Temp:" + this.SessionID, gnChat, 20);
                                    }
                                } else if (gnType == 4) {
                                    gTabs.SystemChats.GetDatasByTempUser(gszSign, this.UserInfo.ID, 20);
                                } else {
                                    gTabs.SystemChats.GetDatasBySign(gszSign, 20);
                                }

                                long lCheckID = 0;

                                for (int i = 0; i < gTabs.SystemChats.StructureCollection.Count; i++) {

                                    if (gTabs.SystemChats.StructureCollection[i].ID > lCheckID) lCheckID = gTabs.SystemChats.StructureCollection[i].ID;

                                    ////更新用户读取标志
                                    //if (i == gTabs.SystemChats.StructureCollection.Count - 1) {
                                    //    gTabs.SystemUserChats.Structure.ChatID = gTabs.SystemChats.StructureCollection[i].ID;
                                    //    gTabs.SystemUserChats.UpdateByID();
                                    //}

                                    string szTime = gTabs.SystemChats.StructureCollection[i].DoTime;

                                    string szContent = gTabs.SystemChats.StructureCollection[i].Content;

                                    switch (gTabs.SystemChats.StructureCollection[i].ChatType) {
                                        case 1://图像模式
                                            szContent = "<img src='" + szContent + "' alt='' title='' />";
                                            break;
                                        case 2://文件模式
                                            String FileExp = System.IO.Path.GetExtension(szContent).Replace(".", "");
                                            String FileType = gJson[FileExp]["Name"].Value;
                                            String FileIcon = gJson[FileExp]["Icon"].Value;
                                            if (FileType == "") {
                                                FileType = FileExp + " 文件";
                                                FileIcon = gJson["Unknow"]["Icon"].Value;
                                            }
                                            szContent = "<div>";
                                            szContent += "<div style='float:left;'>";
                                            szContent += "<img src='" + FileIcon + "' alt='' title='' width='48' height='48' />";
                                            szContent += "</div>";
                                            szContent += "<div style='float:left;padding:0px 0px 0px 3px;'>";
                                            szContent += "<div style='padding:4px 0px 0px 0px;'>";
                                            szContent += FileType;
                                            szContent += "</div>";
                                            szContent += "<div>";
                                            szContent += "<a href='Down.aspx?ID=" + gTabs.SystemChats.StructureCollection[i].ID + "' target='_blank'>点击下载</a>";
                                            szContent += "</div>";
                                            szContent += "</div>";
                                            szContent += "<div style='clear:both;'></div>";
                                            szContent += "</div>";
                                            break;
                                    }
                            %>
                            <dt><%=gTabs.SystemChats.StructureCollection[i].FromUserName%>&nbsp;<%=szTime.StartsWith(Ly.Time.Now.toCommonFormatDateString) ? DateTime.Parse(szTime).ToString("HH:mm:ss") : szTime%></dt>
                            <dd><%=szContent%></dd>
                            <%
                                    if (this.UserInfo.ID <= 0) {
                                        this.Session["CheckID"] = lCheckID.ToString();
                                    } else {
                                        //更新用户读取标志
                                        gTabs.SystemUserChats.Structure.ChatID = lCheckID;
                                        gTabs.SystemUserChats.UpdateByID();
                                    }
                                }
                            %>
                            <dt></dt>
                            <dd></dd>
                        </dl>
                    </div>
                    <div class="Line-Tool">
                        <ul>
                            <li style="">
                                <img src="/Files/System/Image/Expression/14.gif" alt="发送表情" title="发送表情" width="24" height="24" style="cursor: pointer;" onmousemove="this.style.backgroundColor='#dddddd';" onmouseout="this.style.backgroundColor='';" onclick="Page.ShowExpression()" /></li>
                            <li style="">
                                <img src="/images/Icon/txt.png" alt="发送文件" title="发送文件" width="24" height="24" style="cursor: pointer;" onmousemove="this.style.backgroundColor='#dddddd';" onmouseout="this.style.backgroundColor='';" onclick="Page.ShowFileUpload()" /></li>
                            <li style="padding-top: 4px;">当前设定:&nbsp;#FFFFFF&nbsp;12px&nbsp;normal</li>
                        </ul>
                        <div class="pub-clear"></div>
                    </div>
                    <div class="Line-Input">
                        <textarea id="Chat_Content" name="Chat_Content" rows="0" cols="0"></textarea>
                        <div class="pub-left Line-Status" id="Chat_Status"></div>
                        <div class="pub-right">
                            <input type="button" value="发送" onclick="Page.SaveChat(<%="'" + gszSign + "'"%>);" />
                        </div>
                        <div class="pub-right Line-Status"><a href="javascript:;" onclick="Page.GetHistory(<%="'" + gszSign + "'"%>,1);">查看聊天记录</a></div>
                        <div class="pub-clear"></div>
                    </div>
                </div>
                <div class="Line-Center-C" style="display: none;">
                    <div class="Line-History-Head">
                        <div class="pub-left">发送表情</div>
                        <div class="pub-right"><a href="javascript:;" onclick="Page.CloseExpression();">[关闭]</a></div>
                        <div class="pub-clear"></div>
                    </div>
                    <div class="Line-Expression">
                        <%for (int i = 1; i <= 129; i++) { %>
                        <a href="javascript:;" onclick="Page.CloseExpression();Page.SendExpression(<%="'" + gszSign + "'"%>,<%=i%>);">
                            <img src="/Files/System/Image/Expression/<%=i%>.gif" alt="点击发送该表情" title="点击发送该表情" width="24" height="24" /></a>
                        <%} %>
                        <div style="clear: both;"></div>
                    </div>
                </div>
                <div class="Line-Center-D" style="display: none;">
                    <div class="Line-History-Head">
                        <div class="pub-left">发送文件</div>
                        <div class="pub-right"><a href="javascript:;" onclick="Page.CloseFileUpload();">[关闭]</a></div>
                        <div class="pub-clear"></div>
                    </div>
                    <iframe id="UploadDialog_Frame" src="/Upload.aspx" frameborder="0" style="width: 325px; height: 45px;"></iframe>
                    <div>
                        <div class="pub-left" id="UploadDialog_Info" style="padding: 8px 0px 0px 10px;"></div>
                        <div class="pub-right" style="padding: 5px 10px 0px 0px;">
                            <input id="UploadDialog_OK" type="button" value="发送" onclick="Page.CloseFileUpload();Page.SendFile(<%="'" + gszSign + "'"%>);" />
                            <input id="UploadDialog_Path" type="hidden" />
                        </div>
                        <div class="pub-clear"></div>
                    </div>
                </div>
                <div class="Line-Center-B" style="display: none;">
                    <div class="Line-History-Head">
                        <div class="pub-left">聊天记录查看</div>
                        <div class="pub-right"><a href="javascript:;" onclick="Page.CloseHistory();">[关闭]</a></div>
                        <div class="pub-clear"></div>
                    </div>
                    <div class="Line-History"></div>
                </div>
            </div>
            <div class="pub-right">
                <div class="Line-Title">当前通讯对象</div>
                <div class="Line-Left">
                    <ul>
                        <%switch (gnType) { %>
                        <%case 1: %>
                        <%
                            gTabs.SystemDepartments.GetDataByID(gnChat);
                        %>
                        <li class="li-title">部门[<%=gTabs.SystemDepartments.Structure.Name%>]</li>
                        <%
                            gTabs.SystemUsers.GetDatasByDepartment(gnChat);
                            for (int i = 0; i < gTabs.SystemUsers.StructureCollection.Count; i++) {
                                if (gTabs.SystemUsers.StructureCollection[i].ID != this.UserInfo.ID) {
                        %>
                        <li><a href="Default.aspx?Type=2&ID=<%=gTabs.SystemUsers.StructureCollection[i].ID%>">&lt;成员&gt;<%=gTabs.SystemUsers.StructureCollection[i].Nick%></a></li>
                        <%
                                }
                            }
                        %>
                        <%break; %>
                        <%case 2: %>
                        <%
                            gTabs.SystemUsers.GetDataByID(gnChat);
                        %>
                        <li class="li-title">个人[<%=gTabs.SystemUsers.Structure.Nick%>]</li>
                        <%break; %>
                        <%case 3: %>
                        <%
                            gTabs.SystemGroups.GetDataByID(gnChat);
                        %>
                        <li class="li-title">组[<%=gTabs.SystemGroups.Structure.Name%>]</li>
                        <%
                            gTabs.SystemUsers.GetDatasByGroup(gnChat);
                            for (int i = 0; i < gTabs.SystemUsers.StructureCollection.Count; i++) {
                                if (gTabs.SystemUsers.StructureCollection[i].ID != this.UserInfo.ID) {
                        %>
                        <li><a href="Default.aspx?Type=2&ID=<%=gTabs.SystemUsers.StructureCollection[i].ID%>">&lt;成员&gt;<%=gTabs.SystemUsers.StructureCollection[i].Nick%></a></li>
                        <%
                                }
                            }
                        %>
                        <%break; %>
                        <%case 4: %>
                        <li class="li-title">临时访客</li>
                        <%break; %>
                        <%default: %>
                        <li class="li-title">未知</li>
                        <%break; %>
                        <%} %>
                    </ul>
                </div>
            </div>
            <div class="pub-clear"></div>
        </div>

    </form>
    <script language="javascript" type="text/javascript">
        $(function(){
            Page.GetChat('<%=gszSign%>');
        });
    </script>
</body>
</html>
