<%@ Page Language="C#" Inherits="ClsPage" %>

<!DOCTYPE html>

<script runat="server">
    protected Ly.DB.Dream.Tables gTab;
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
                string szSign = Pub.Request(this, "Sign");

                string szChats = "";
                int nMessage = 0;

                //检测登录状态
                if (this.UserInfo.ID <= 0) {
                    //丢失登录状态
                    pg.XPort.Message = "丢失登录状态，请保存当前工作内容并重新登陆!";
                    //pg.XPort.Refresh = 1;
                } else {
                    #region [=====检测异地登陆=====]
                    #endregion

                    #region [=====获取系统信息=====]

                    using (dyk.DB.Base.SystemMessages.ExecutionExp sm = new dyk.DB.Base.SystemMessages.ExecutionExp(this.BaseConnectString)) {
                        if (sm.GetNewDataByUserID(this.UserInfo.ID)) {
                            //设置提示信息
                            pg.XPort.Information = sm.Structure.Msg;
                            //更新系统消息为已读
                            sm.Structure.Status = 1;
                            sm.UpdateByID();
                        }
                    }

                    #endregion
                }

                pg.OutPutXPort();

                using (ClsAjaxRequest js = new ClsAjaxRequest()) {

                    //using (Ly.DB.Dream.Tables gTabs = new Ly.DB.Dream.Tables(this.ConnectString)) {

                    //    if (gTabs.SystemUserChats.GetDataByUserAndSign(this.UserInfo.ID, szSign)) {

                    //        long lBeforeID = gTabs.SystemUserChats.Structure.ChatID;

                    //        if (this.UserInfo.ID <= 0) {
                    //            lBeforeID = Ly.String.Source(this.Session["CheckID"]).toLong;
                    //        }

                    //        if (szSign.StartsWith("User:")) {
                    //            long nChat = Ly.String.Source(szSign.Split(':')[1]).toLong;
                    //            if (this.UserInfo.ID > 0) {
                    //                gTabs.SystemChats.GetDatasByUserAndID(this.UserInfo.ID, nChat, lBeforeID);
                    //            } else {
                    //                gTabs.SystemChats.GetDatasByTempUserAndID("Temp:" + this.SessionID, nChat, lBeforeID);
                    //            }
                    //        } else if (szSign.StartsWith("Temp:")) {
                    //            gTabs.SystemChats.GetDatasByTempUserAndID(szSign, this.UserInfo.ID, lBeforeID);
                    //        } else {
                    //            gTabs.SystemChats.GetDatasBySignAndID(szSign, lBeforeID);
                    //        }

                    //        long lCheckID = lBeforeID;

                    //        js["Chats"].IsArray = true;

                    //        for (int i = 0; i < gTabs.SystemChats.StructureCollection.Count; i++) {

                    //            string szTime = gTabs.SystemChats.StructureCollection[i].DoTime;

                    //            Ly.Formats.JsonObject json = js["Chats"].AppendChild("");
                    //            json["Nick"].Value = gTabs.SystemChats.StructureCollection[i].FromUserName + " " + (szTime.StartsWith(Ly.Time.Now.toCommonFormatDateString) ? DateTime.Parse(szTime).ToString("HH:mm:ss") : szTime);
                    //            json["Content"].Value = gTabs.SystemChats.StructureCollection[i].Content;
                    //            //if (szChats != "") szChats += ",";
                    //            //szChats += json.ToString();

                    //            if (gTabs.SystemChats.StructureCollection[i].ID > lCheckID) lCheckID = gTabs.SystemChats.StructureCollection[i].ID;
                    //        }

                    //        if (this.UserInfo.ID <= 0) {
                    //            this.Session["CheckID"] = lCheckID.ToString();
                    //        } else {
                    //            //更新用户读取标志
                    //            gTabs.SystemUserChats.Structure.ChatID = lCheckID;
                    //            gTabs.SystemUserChats.UpdateByID();
                    //        }

                    //    }


                    //    gTabs.SystemUsers.GetDataByID(this.UserInfo.ID);
                    //    gTabs.SystemUsers.Structure.ChatLastRead = Ly.Time.Now.toCommonFormatString;
                    //    gTabs.SystemUsers.UpdateByID();
                    //}

                    //// js["Chats"].Value = "[" + szChats + "]";

                    ////string szNewMessage = "";

                    //js["NewMessage"].IsArray = true;

                    //if (this.UserInfo.ID > 0) {

                    //    using (Ly.DB.Dream.Tables gTabs = new Ly.DB.Dream.Tables(this.ConnectString)) {

                    //        //部门通讯
                    //        Ly.Formats.JsonObject jsonDepartment = js["NewMessage"].AppendChild("");
                    //        string szDepartment = "Department:" + this.UserInfo.Department;
                    //        jsonDepartment["Name"].Value = "Department_" + this.UserInfo.Department;
                    //        jsonDepartment["Parent"].Value = "";
                    //        if (gTabs.SystemUserChats.GetDataByUserAndSign(this.UserInfo.ID, szDepartment)) {
                    //            nMessage += gTabs.SystemChats.GetUnreadMeaageCount(szDepartment, gTabs.SystemUserChats.Structure.ChatID);
                    //        } else {
                    //            nMessage += gTabs.SystemChats.GetUnreadMeaageCount(szDepartment, 0);
                    //        }
                    //        //if (szNewMessage != "") szNewMessage += ",";
                    //        //szNewMessage += jsonDepartment.ToString();

                    //        //个人通讯
                    //        int nChat = 0;
                    //        using (Ly.Data.SQLClient Conn = new Ly.Data.SQLClient(this.ConnectString)) {
                    //            Conn.NewCmd("Select * from [SystemUsers] where ([Department]=@Department or ID in (Select [UserID] From SystemUserGroups where GroupID in  (Select SystemGroups.[ID] from SystemGroups,SystemUserGroups where SystemGroups.[ID]=SystemUserGroups.[GroupID] and [SystemUserGroups].[UserID]=@UserID)))  and ID<>@UserID");
                    //            Conn.AddParameter("@Department", this.UserInfo.Department, System.Data.SqlDbType.Decimal);
                    //            Conn.AddParameter("@UserID", this.UserInfo.ID, System.Data.SqlDbType.Decimal);
                    //            Conn.ExecuteReader();
                    //            while (Conn.DataReader.Read()) {
                    //                //Ly.Formats.Json json = new Ly.Formats.Json();
                    //                Ly.Formats.JsonObject json = js["NewMessage"].AppendChild("");
                    //                nChat = Ly.String.Source(Conn.DataReader["ID"].ToString()).toInteger;
                    //                string szSignTemp = "User:" + nChat;
                    //                json["Name"].Value = "User_" + nChat;
                    //                json["Parent"].Value = "";
                    //                if (gTabs.SystemUserChats.GetDataByUserAndSign(this.UserInfo.ID, szSignTemp)) {
                    //                    nMessage += gTabs.SystemChats.GetUnreadUserMeaageCount(this.UserInfo.ID, nChat, gTabs.SystemUserChats.Structure.ChatID);
                    //                } else {
                    //                    nMessage += gTabs.SystemChats.GetUnreadUserMeaageCount(this.UserInfo.ID, nChat, 0);
                    //                }
                    //                //if (szNewMessage != "") szNewMessage += ",";
                    //                //szNewMessage += json.ToString();
                    //            }
                    //        }

                    //        //组通讯
                    //        using (Ly.Data.SQLClient Conn = new Ly.Data.SQLClient(this.ConnectString)) {
                    //            Conn.NewCmd("Select SystemGroups.* from SystemGroups,SystemUserGroups where SystemGroups.[ID]=SystemUserGroups.[GroupID] and [SystemUserGroups].[UserID]=@UserID");
                    //            Conn.AddParameter("@UserID", this.UserInfo.ID, System.Data.SqlDbType.Decimal);
                    //            Conn.ExecuteReader();
                    //            while (Conn.DataReader.Read()) {
                    //                nChat = Ly.String.Source(Conn.DataReader["ID"].ToString()).toInteger;
                    //                //Ly.Formats.Json json = new Ly.Formats.Json();
                    //                Ly.Formats.JsonObject json = js["NewMessage"].AppendChild("");
                    //                string szSignTemp = "Group:" + nChat;
                    //                json["Name"].Value = "Group_" + nChat;
                    //                json["Parent"].Value = "";
                    //                if (gTabs.SystemUserChats.GetDataByUserAndSign(this.UserInfo.ID, szSignTemp)) {
                    //                    nMessage += gTabs.SystemChats.GetUnreadMeaageCount(szSignTemp, gTabs.SystemUserChats.Structure.ChatID);
                    //                } else {
                    //                    nMessage += gTabs.SystemChats.GetUnreadMeaageCount(szSignTemp, 0);
                    //                }
                    //                //if (szNewMessage != "") szNewMessage += ",";
                    //                //szNewMessage += json.ToString();
                    //            }
                    //        }

                    //        //临时通讯
                    //        gTabs.SystemGroups.GetDataByName("游客资讯");
                    //        if (gTabs.SystemUserGroups.GetDataByUserAndGroup(this.UserInfo.ID, gTabs.SystemGroups.Structure.ID)) {

                    //            using (Ly.Data.SQLClient Conn = new Ly.Data.SQLClient(this.ConnectString)) {
                    //                Conn.NewCmd("Select [FromUserName],Max([DoTime]) as LastTime from SystemChats where ChatSign=@UserSign and  FromUserID=0 group by FromUserName");
                    //                Conn.AddParameter("@UserSign", "User:" + this.UserInfo.ID, System.Data.SqlDbType.VarChar, 50);
                    //                Conn.ExecuteReader();
                    //                while (Conn.DataReader.Read()) {
                    //                    string szSignTemp = Conn.DataReader["FromUserName"].ToString();
                    //                    //string szLastTime = Conn.DataReader["LastTime"].ToString();
                    //                    //Ly.Formats.Json json = new Ly.Formats.Json();
                    //                    Ly.Formats.JsonObject json = js["NewMessage"].AppendChild("");
                    //                    json["Name"].Value = szSignTemp.Replace(":", "_");
                    //                    json["Parent"].Value = "Chat_Temp";
                    //                    if (gTabs.SystemUserChats.GetDataByUserAndSign(this.UserInfo.ID, szSignTemp)) {
                    //                        nMessage += gTabs.SystemChats.GetUnreadTempMeaageCount(szSignTemp, this.UserInfo.ID, gTabs.SystemUserChats.Structure.ChatID);
                    //                    } else {
                    //                        nMessage += gTabs.SystemChats.GetUnreadTempMeaageCount(szSignTemp, this.UserInfo.ID, 0);
                    //                    }
                    //                    //if (szNewMessage != "") szNewMessage += ",";
                    //                    //szNewMessage += json.ToString();
                    //                }
                    //            }

                    //        }

                    //    }
                    //}

                    //js["NewMessage"].Value = "[" + szNewMessage + "]";
                    //js.SetText("chat_msg_count", nMessage.ToString());

                    //pg.OutPut(js.ToString());
                }
            %>
            <%pg.Dispose();%>
        </div>
    </form>
</body>
</html>
