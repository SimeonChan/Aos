<%@ Page Language="C#" Inherits="ClsPage" ValidateRequest="false" %>

<!DOCTYPE html>

<script runat="server">

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

                dyk.DB.Base.SystemTables.ExecutionExp SystemTables = new dyk.DB.Base.SystemTables.ExecutionExp(this.ConnectString);
                SystemTables.GetDataByName("Sales3Users");

                int nSize = 100;
                int nSpace = 40;
                int nUnit = nSize + nSpace;

                int nLeft = nSpace / 2;
                int nLeft2 = nLeft + nSize + nSpace;
                int nLeft3 = nLeft2 + nSize + nSpace;
                int nLeft4 = nLeft3 + nSize + nSpace;

                int nTop1 = nSpace / 2;
                int nTop2 = nTop1 + nSize + nSpace;
                int nTop3 = nTop2 + nSize + nSpace;
                int nTop4 = nTop3 + nSize + nSpace;

                int nPageTop = 20;
                int nTop = nPageTop + 30;

            %>
            <div style="position: absolute; left: 0px; top: 0px; width: 100%; height: 100%;">
                <div style="position: relative; width: 100%; height: 100%; overflow: auto;">
                    <%for (int i = 0; i < 4; i++) { %>
                    <div style="position: absolute; border-top: 1px dashed #ccc; left: 0px; top: <%=(nSize+nSpace)*(i+1)%>px; width: 100%; height: 1px;"></div>
                    <%} %>
                    <div style="position: absolute; left: <%=nLeft%>px; top: <%=nTop1-5%>px; width: 200px; height: 19px; text-align: center; padding-top: 1px; color: #0094ff;">
                        <div style="float: left;">
                            <img alt="" src="<%=pg.PageArgs.Path%>Images/UserB.png" />
                        </div>
                        <div style="float: left; padding: 3px 0px 0px 3px; font-weight: bold;">我的上级</div>
                        <div style="clear: both;"></div>
                        <div style="text-align: left">
                            <div style="color: #000000; padding: 0px 0px 2px 0px;">本层销售后各级提成：</div>
                            <div style="color: #009900; text-indent: 5px;">√&nbsp;我的上级</div>
                            <div style="color: #CCCCCC; text-indent: 5px;">×&nbsp;我</div>
                            <div style="color: #CCCCCC; text-indent: 5px;">×&nbsp;我的下级</div>
                            <div style="color: #CCCCCC; text-indent: 5px;">×&nbsp;我的下下级</div>
                        </div>
                    </div>
                    <div style="position: absolute; left: <%=nLeft%>px; top: <%=nTop2-5%>px; width: 200px; height: 19px; text-align: center; padding-top: 1px; color: #0094ff;">
                        <div style="float: left;">
                            <img alt="" src="<%=pg.PageArgs.Path%>Images/User.png" />
                        </div>
                        <div style="float: left; padding: 3px 0px 0px 3px; font-weight: bold;">我的信息</div>
                        <div style="clear: both;"></div>
                        <div style="text-align: left">
                            <div style="color: #000000; padding: 0px 0px 2px 0px;">本层销售后各级提成：</div>
                            <div style="color: #009900; text-indent: 5px;">√&nbsp;我的上级</div>
                            <div style="color: #009900; text-indent: 5px;">√&nbsp;我</div>
                            <div style="color: #CCCCCC; text-indent: 5px;">×&nbsp;我的下级</div>
                            <div style="color: #CCCCCC; text-indent: 5px;">×&nbsp;我的下下级</div>
                        </div>
                    </div>
                    <div style="position: absolute; left: <%=nLeft%>px; top: <%=nTop3-5%>px; width: 200px; height: 19px; text-align: center; padding-top: 1px; color: #0094ff;">
                        <div style="float: left;">
                            <img alt="" src="<%=pg.PageArgs.Path%>Images/User2.png" />
                        </div>
                        <div style="float: left; padding: 3px 0px 0px 3px; font-weight: bold;">我的下级</div>
                        <div style="clear: both;"></div>
                        <div style="text-align: left">
                            <div style="color: #000000; padding: 0px 0px 2px 0px;">本层销售后各级提成：</div>
                            <div style="color: #009900; text-indent: 5px;">√&nbsp;我的上级</div>
                            <div style="color: #009900; text-indent: 5px;">√&nbsp;我</div>
                            <div style="color: #009900; text-indent: 5px;">√&nbsp;我的下级(本人)</div>
                            <div style="color: #CCCCCC; text-indent: 5px;">×&nbsp;我的下下级</div>
                        </div>
                    </div>
                    <div style="position: absolute; left: <%=nLeft%>px; top: <%=nTop4-5%>px; width: 200px; height: 19px; text-align: center; padding-top: 1px; color: #0094ff;">
                        <div style="float: left;">
                            <img alt="" src="<%=pg.PageArgs.Path%>Images/User3.png" />
                        </div>
                        <div style="float: left; padding: 3px 0px 0px 3px; font-weight: bold;">我的下下级</div>
                        <div style="clear: both;"></div>
                        <div style="text-align: left">
                            <div style="color: #000000; padding: 0px 0px 2px 0px;">本层销售后各级提成：</div>
                            <div style="color: #CCCCCC; text-indent: 5px;">×&nbsp;我的上级</div>
                            <div style="color: #009900; text-indent: 5px;">√&nbsp;我</div>
                            <div style="color: #009900; text-indent: 5px;">√&nbsp;我的下级(销售者上级)</div>
                            <div style="color: #009900; text-indent: 5px;">√&nbsp;我的下下级(本人)</div>
                        </div>
                    </div>
                    <%
                        dyk.DB.Sales3.Sales3Users.ExecutionExp Sales3Users = new dyk.DB.Sales3.Sales3Users.ExecutionExp(this.ConnectString);
                        //获取我的上级信息
                        Sales3Users.GetDataByUserName(this.UserInfo.Name);

                        //获取界面参数，生成添加脚本

                        string szSelectPath = Server.MapPath(SystemTables.Structure.SavePath);
                        if (!System.IO.Directory.Exists(szSelectPath)) System.IO.Directory.CreateDirectory(szSelectPath);
                        string gstrFullPath = szSelectPath + "/UI.json";

                        string szJson = Pub.IO.ReadAllEncryptionText(gstrFullPath);
                        dyk.Format.Json jsonAdd = new dyk.Format.Json(szJson);

                        int gintWidth = 0;
                        int gintHeight = 0;
                        for (int i = 0; i < jsonAdd.Count; i++) {
                            dyk.Format.JsonObject obj = jsonAdd[i];
                            if (obj.Name == "Form") {
                                gintWidth = Ly.String.Source(obj["Width"].Value).toInteger;
                                gintHeight = Ly.String.Source(obj["Height"].Value).toInteger;
                            }
                        }

                        string gstrArgs = "";
                        gstrArgs = "Path:'" + pg.PageArgs.Path + "'";
                        gstrArgs += ",ID:'" + pg.PageArgs.UID + "'";
                        gstrArgs += ",Table:'" + SystemTables.Structure.ID + "'";
                        gstrArgs += ",ViewTable:'" + SystemTables.Structure.ID + "'";
                        gstrArgs += ",Arg_ID:'" + pg.PageArgs.Arg_ID + "'";
                        gstrArgs += ",Arg_Relation:'" + pg.PageArgs.Arg_Relation + "'";
                        gstrArgs += ",Arg_Index:'" + pg.PageArgs.Arg_Index + "'";

                        using (dyk.DB.Sales3.Sales3Users.ExecutionExp s3u = new dyk.DB.Sales3.Sales3Users.ExecutionExp(this.ConnectString)) {
                            s3u.GetDataByUserName(this.UserInfo.Name);
                            gstrArgs += ",Arg_S3U_Parent1:'" + s3u.Structure.ID + "'";
                            gstrArgs += ",Arg_S3U_Parent2:'" + s3u.Structure.ParentID1 + "'";
                        }

                        string szScript = "Page.Functions.Sales3.Add('" + pg.PageArgs.Path + "','" + pg.PageArgs.UID + "','" + SystemTables.Structure.Text + "'," + gintWidth + "," + gintHeight + ",{" + gstrArgs + "});";
                    %>

                    <%
                        //获取下级
                        using (dyk.DB.Sales3.Sales3Users.ExecutionExp s3u = new dyk.DB.Sales3.Sales3Users.ExecutionExp(this.ConnectString)) {
                            s3u.GetDatasByParentID1(Sales3Users.Structure.ID);
                            int nLeftNow = nLeft2;
                            int nLeftLine = nLeftNow + nSize / 2;//上次下级分类时，线的位置
                            int nCnt = 0;
                            for (int i = 0; i < s3u.StructureCollection.Count; i++) {
                                dyk.DB.Sales3.Sales3Users.StructureExp ste = s3u.StructureCollection[i];
                                int nLeftNowTemp = nLeftNow;
                                nCnt++;
                    %>
                    <%
                        //获取下下级
                        using (dyk.DB.Sales3.Sales3Users.ExecutionExp s3u2 = new dyk.DB.Sales3.Sales3Users.ExecutionExp(this.ConnectString)) {
                            s3u2.GetDatasByParentID1(ste.ID);
                            int nCnt2 = 0;
                            for (int j = 0; j < s3u2.StructureCollection.Count; j++) {
                                nCnt2++;
                                if (j > 0) { nCnt++; }
                                dyk.DB.Sales3.Sales3Users.StructureExp ste2 = s3u2.StructureCollection[j];
                    %>
                    <%//显示下下级用户的概括线 %>
                    <%if (j > 0) { %>
                    <div style="position: absolute; left: <%=nLeftNow-nUnit+nSize/2%>px; top: <%=nTop4-nSpace/2%>px; background: #0094ff; width: <%=nUnit%>px; height: 1px;"></div>
                    <%} %>
                    <div style="position: absolute; left: <%=nLeftNow+nSize/2%>px; top: <%=nTop4-nSpace/2%>px; background: #0094ff; width: 1px; height: <%=nSpace/2%>px;"></div>
                    <div style="position: absolute; left: <%=nLeftNow%>px; top: <%=nTop4%>px; border: 1px solid #0094ff; width: <%=nSize%>px; height: <%=nSize-10%>px; padding: 5px 0px; text-align: center;">
                        <%=ste2.Name%><br />
                        产生提成:¥0.00
                    </div>
                    <%
                            nLeftNow += nUnit;
                        }

                        //计算并显示下级用户的显示位置
                        int nLeftLv3 = nLeftNowTemp + (int)(((double)((nCnt2 > 0 ? nCnt2 : 1) - 1) / 2) * nUnit);
                        int nWidthLine = nLeftLv3 + nSize / 2 - nLeftLine;
                    %>
                    <%//显示我的引线 %>
                    <div style="position: absolute; left: <%=nLeftLv3+nSize/2%>px; top: <%=nTop3-nSpace/2%>px; background: #0094ff; width: 1px; height: <%=nSpace/2%>px;"></div>
                    <%//显示我的概括线，第一个用户不用显示 %>
                    <%if (i > 0) { %>
                    <div style="position: absolute; left: <%=nLeftLine%>px; top: <%=nTop3-nSpace/2%>px; background: #0094ff; width: <%=nWidthLine%>px; height: 1px;"></div>
                    <%} %>
                    <%if (nCnt2 > 0) { %>
                    <%//显示下下级用户的展开线，无下下级则不显示 %>
                    <div style="position: absolute; left: <%=nLeftLv3+nSize/2%>px; top: <%=nTop3+nSize+1%>px; background: #0094ff; width: 1px; height: <%=nSpace/2%>px;"></div>
                    <%} %>
                    <div style="position: absolute; left: <%=nLeftLv3%>px; top: <%=nTop3%>px; border: 1px solid #0094ff; width: <%=nSize%>px; height: <%=nSize-10%>px; padding: 5px 0px; text-align: center;">
                        <%=ste.Name%><br />
                        产生提成:¥0.00
                    </div>
                    <%
                                nLeftLine = nLeftLv3 + nSize / 2;//重新记录线的垂直位置
                            }
                        }
                        //计算并显示当前用户信息的位置
                        int nLeftMe = nLeft2 + (int)(((double)((nCnt > 0 ? nCnt : 1) - 1) / 2) * nUnit);

                        if (Sales3Users.Structure.ParentID1 > 0) {
                            using (dyk.DB.Sales3.Sales3Users.ExecutionExp s3up = new dyk.DB.Sales3.Sales3Users.ExecutionExp(this.ConnectString)) {
                                if (s3up.GetDataByID(Sales3Users.Structure.ParentID1)) {
                    %>
                    <div style="position: absolute; left: <%=nLeftMe%>px; top: <%=nTop1%>px; border: 1px solid #0094ff; width: <%=nSize%>px; height: <%=nSize-10%>px; padding: 5px 0px; text-align: center;">
                        <%=s3up.Structure.Name%><br />
                        我的贡献:¥<%=s3up.Structure.Money%>
                    </div>
                    <%
                        } else {
                    %>
                    <div style="position: absolute; left: <%=nLeftMe%>px; top: <%=nTop1%>px; border: 1px solid #0094ff; width: <%=nSize%>px; height: <%=nSize-10%>px; padding: 5px 0px; text-align: center;">无</div>
                    <%
                                }
                            }
                        } else {
                    %>
                    <div style="position: absolute; left: <%=nLeftMe%>px; top: <%=nTop1%>px; border: 1px solid #0094ff; width: <%=nSize%>px; height: <%=nSize-10%>px; padding: 5px 0px; text-align: center;">无</div>
                    <%
                        }
                    %>
                    <%//显示我的信息 %>
                    <div style="position: absolute; left: <%=nLeftMe+nSize/2%>px; top: <%=nTop2-nSpace+1%>px; background: #0094ff; width: 1px; height: <%=nSpace-1%>px;"></div>
                    <%if (nCnt > 0) { %>
                    <%//显示下下级用户的展开线，无下下级则不显示 %>
                    <div style="position: absolute; left: <%=nLeftMe+nSize/2%>px; top: <%=nTop2+nSize+1%>px; background: #0094ff; width: 1px; height: <%=nSpace/2%>px;"></div>
                    <%} %>
                    <div style="position: absolute; border: 1px solid #0094ff; padding: 5px 0px; text-align: center; top: <%=nTop2%>px; left: <%=nLeftMe%>px; width: <%=nSize%>px; height: <%=nSize-10%>px;">
                        <%=this.UserInfo.Nick%><br />
                        销售提成:¥0.00<br />
                        所有收入:¥0.00<br />
                        可提余额:¥0.00
                    </div>
                    <div style="position: absolute; background: #0094ff; left: <%=nLeftMe+nUnit-nSpace+1%>px; top: <%=nTop2+nSize/2%>px; width: <%=nSpace-1%>px; height: 1px;"></div>
                    <div style="position: absolute; border: 1px solid #0094ff; text-align: center; width: <%=nSize%>px; height: 80px; padding: <%=(nSize-80)/2%>px 0px; left: <%=nLeftMe+nUnit%>px; top: <%=nTop2%>px;">
                        <img alt="" src="<%=pg.PageArgs.Path%>Images/Add.jpg" onmouseover="this.src='<%=pg.PageArgs.Path%>Images/Add_Over.jpg';" onmouseout="this.src='<%=pg.PageArgs.Path%>Images/Add.jpg'" style="cursor: pointer;" onclick="<%=szScript%>" />
                    </div>
                    <%
                        }
                    %>
                    <%
                        Sales3Users.Dispose();
                    %>
                </div>
            </div>
            <%pg.Dispose();%>
        </div>
    </form>
</body>
</html>
