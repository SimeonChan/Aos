/// <reference path="http://js.dyksoft.com/jq/jquery-1.11.3.js" />
/// <reference path="http://js.dyksoft.com/XKits/1.01.1510/X.js" />
/// <reference path="http://js.dyksoft.com/XKits/1.01.1510/X.Client.js" />
/// <reference path="http://js.dyksoft.com/XKits/1.01.1510/X.Storage.js" />
/// <reference path="../../../../../js/Page.js" />
/// <reference path="/js/Controls/AjaxRequest.js" />

//Page.Functions.OA = function () { }

Page.Functions.Process = function () { }

///加载页面
Page.Functions.Process.Load = function (id, arg) {

    var NewArg = Page.UI.UpdateArgs(id, arg);

    var szPath = Page.Storage.Get("OA_" + id + "_UIPath");
    var szTitle = Page.Storage.Get("OA_" + id + "_UITitle");

    Page.UI.Open(id, "", szTitle, "/Files/App/OA/Process/", "Process.aspx", NewArg);

    //Page.Ajax(szPath + "Process.aspx", arg, false, function (responseText, textStatus) {
    //    $.AjaxRequest.Execute(responseText);
    //});

}

Page.Functions.Table = function () { }

Page.Functions.Table.CheckClick = function (id, arg) {
    var NewArg = Page.UI.UpdateArgs(id, arg);
    var szPath = X.Storage.Get("OA_" + id + "_Path");

    //alert(szPath);

    Page.Ajax("/Files/App/OA/UI/CheckSave.aspx", NewArg, true, function (responseText, textStatus) {
        $.AjaxRequest.Execute(responseText);
    })
}

///提交信息
Page.Functions.Table.Submit = function (id, page, arg) {
    if (!arg["Arg_Table"]) arg["Arg_Table"] = Page.Storage.Get("OA_" + id + "_Arg_Table");
    if (!arg["Arg_Page"]) arg["Arg_Page"] = Page.Storage.Get("OA_" + id + "_Arg_Page");
    if (!arg["Arg_Table_Date"]) arg["Arg_Table_Date"] = Page.Storage.Get("OA_" + id + "_Arg_Table_Date");
    if (!arg["Arg_Table_Key"]) arg["Arg_Table_Key"] = Page.Storage.Get("OA_" + id + "_Arg_Table_Key");
    if (!arg["Arg_ID"]) arg["Arg_ID"] = Page.Storage.Get("OA_" + id + "_Arg_ID");
    if (!arg["Arg_Relation"]) arg["Arg_Relation"] = Page.Storage.Get("OA_" + id + "_Arg_Relation");
    if (!arg["Arg_Index"]) arg["Arg_Index"] = Page.Storage.Get("OA_" + id + "_Arg_Index");
    if (!arg["Arg_RelationText"]) arg["Arg_RelationText"] = Page.Storage.Get("OA_" + id + "_Arg_RelationText");

    var szPath = Page.Storage.Get("OA_" + id + "_UIPath");
    var szTitle = Page.Storage.Get("OA_" + id + "_UITitle");

    Page.UI.Open(id, "", szTitle, szPath, page, arg);
}

///加载页面
Page.Functions.Table.Load = function (id, arg) {

    var NewArg = Page.UI.UpdateArgs(id, arg);

    //var szPath = Page.Storage.Get("OA_" + id + "_UIPath");
    var szPath = "/Files/App/OA/Process/";
    var szTitle = Page.Storage.Get("OA_" + id + "_UITitle");

    Page.UI.Open(id, "", szTitle, szPath, "Process.aspx", NewArg);

    //Page.Ajax(szPath + "Process.aspx", arg, false, function (responseText, textStatus) {
    //    $.AjaxRequest.Execute(responseText);
    //});

}

///选择一行数据
Page.Functions.Table.KeySearchClear = function (id) {
    //var szKey = $("#" + id + "_Key").val();
    Page.Storage.Set("OA_" + id + "_Arg_Table_Key", "");
    Page.Functions.Table.Load(id, { Arg_Table_Key: "" });
    //Page.UI.Open('" + pg.PageArgs.UID + "', '', '" + pg.PageArgs.UITitle + "', '" + pg.PageArgs.Path + "', 'Process.aspx', { Arg_Table: '" + sTable + "', Arg_Table_Date: '" + szDate + "', Arg_Page: 1, Arg_Table_Key: aDate });
}

///选择一行数据
Page.Functions.Table.KeySearch = function (id) {
    var szKey = $("#" + id + "_Key").val();
    Page.Functions.Table.Load(id, { Arg_Table_Key: szKey });
    //Page.UI.Open('" + pg.PageArgs.UID + "', '', '" + pg.PageArgs.UITitle + "', '" + pg.PageArgs.Path + "', 'Process.aspx', { Arg_Table: '" + sTable + "', Arg_Table_Date: '" + szDate + "', Arg_Page: 1, Arg_Table_Key: aDate });
}

///选择一行数据
Page.Functions.Table.Select = function (id, name) {
    var szName = Page.Storage.Get("OA_Table_Select_" + id);
    if (szName != "") {
        $("#" + id + "_tr_line_" + szName).css({ backgroundColor: "" });
    }
    Page.Storage.Set("OA_Table_Select_" + id, name);
    $("#" + id + "_tr_line_" + +name).css({ backgroundColor: "#ffd58d" });
}

///数据保存
Page.Functions.Table.Save = function (id, arg) {

    if (!arg["Arg_Table"]) arg["Arg_Table"] = Page.Storage.Get("OA_" + id + "_Arg_Table");
    if (!arg["Arg_Page"]) arg["Arg_Page"] = Page.Storage.Get("OA_" + id + "_Arg_Page");
    if (!arg["Arg_Table_Date"]) arg["Arg_Table_Date"] = Page.Storage.Get("OA_" + id + "_Arg_Table_Date");
    if (!arg["Arg_Table_Key"]) arg["Arg_Table_Key"] = Page.Storage.Get("OA_" + id + "_Arg_Table_Key");
    if (!arg["Arg_ID"]) arg["Arg_ID"] = Page.Storage.Get("OA_" + id + "_Arg_ID");
    if (!arg["Arg_Relation"]) arg["Arg_Relation"] = Page.Storage.Get("OA_" + id + "_Arg_Relation");
    if (!arg["Arg_Index"]) arg["Arg_Index"] = Page.Storage.Get("OA_" + id + "_Arg_Index");
    if (!arg["Arg_RelationText"]) arg["Arg_RelationText"] = Page.Storage.Get("OA_" + id + "_Arg_RelationText");

    var szPath = Page.Storage.Get("OA_" + id + "_UIPath");
    var szTitle = Page.Storage.Get("OA_" + id + "_UITitle");

    //Page.UI.Open(id, "", szTitle, szPath, "AddSave.aspx", arg);
    var argNew = Page.UI.UpdateArgs(id, arg);

    Page.Ajax(szPath + "AddSave.aspx", argNew, false, function (responseText, textStatus) {
        $.AjaxRequest.Execute(responseText);
    });

}

///弹出窗口
Page.Functions.Table.Dialog = function (id, tarid, title, width, height, path, page, arg) {

    var argNew = Page.UI.UpdateArgs(tarid, arg);

    //$.Dialog.ShowFromUrl(id, title, width + 1, height + 1, path, arg);
    Page.UI.Dialog(id, tarid, title, width, height, path, page, argNew)
}

///添加
Page.Functions.Table.Add = function (path, id, title, width, height, arg) {
    Page.Functions.Table.Dialog(id + "_Edit", id, "[" + title + "] - 添加记录", width + 1, height + 1, "/Files/App/OA/UI/", "Add.aspx", arg);
}

///修改
Page.Functions.Table.Edit = function (path, id, title, width, height, arg) {

    var szName = Page.Storage.Get("OA_Table_Select_" + id);

    if (szName == "") {
        alert('请先选择一行数据!')
        return;
    }

    arg["Key_ID"] = szName;

    Page.Functions.Table.Dialog(id + "_Edit", id, "[" + title + "] - 修改记录", width + 1, height + 1, "/Files/App/OA/UI/", "Add.aspx", arg);
}

///查看
Page.Functions.Table.View = function (path, id, title, width, height, arg) {

    var szName = Page.Storage.Get("OA_Table_Select_" + id);

    if (szName == "") {
        alert('请先选择一行数据!')
        return;
    }

    arg["Key_ID"] = szName;
    arg["Key_View"] = 1;

    Page.Functions.Table.Dialog(id + "_Edit", id, "[" + title + "] - 查看记录", width + 1, height + 1, "/Files/App/OA/UI/", "Add.aspx", arg);
}

///删除
Page.Functions.Table.Delete = function (id, path, arg) {
    var szName = Page.Storage.Get("OA_Table_Select_" + id);

    if (szName == "") {
        alert('请先选择一行数据!')
        return;
    }

    arg["Key_ID"] = szName;

    var NewArg = Page.UI.UpdateArgs(id, arg);

    Page.Ajax(path + "Ajax/Delete.aspx", NewArg, false, function (responseText, textStatus) {
        $.AjaxRequest.Execute(responseText);
    });

}

///筛选
Page.Functions.Table.FilterReLoad = function (id, arg) {
    var szPath = Page.Storage.Get("OA_" + id + "_Path");
    //Page.Ajax(szPath + "Ajax/Filter.aspx",id + "_Filter", id, "列[" + title + "] - 数据筛选", width + 1, height + 1, , arg);

    Page.Ajax(szPath + "Ajax/Filter.aspx", arg, false, function (responseText, textStatus) {
        //$.AjaxRequest.Execute(responseText);
        $("#Dialog_" + id + "_Filter_Content").html(responseText);
    });
}

///排序
Page.Functions.Table.Order = function (id, arg) {

    var NewArg = Page.UI.UpdateArgs(id, arg);

    var szPath = Page.Storage.Get("OA_" + id + "_Path");

    Page.Functions.Table.Dialog(id + "_Order", id, "数据排序", 641, 480, szPath, "Ajax/Order.aspx", NewArg);
}

///排序保存
Page.Functions.Table.OrderDelete = function (id, arg) {

    var NewArg = Page.UI.UpdateArgs(id, arg);

    var szPath = Page.Storage.Get("OA_" + id + "_Path");

    Page.Ajax(szPath + "Ajax/Order_Del.aspx", NewArg, false, function (responseText, textStatus) {
        $.AjaxRequest.Execute(responseText);
    });

}

///排序上移
Page.Functions.Table.OrderUp = function (id, arg) {

    var NewArg = Page.UI.UpdateArgs(id, arg);

    var szPath = Page.Storage.Get("OA_" + id + "_Path");

    Page.Ajax(szPath + "Ajax/Order_Up.aspx", NewArg, false, function (responseText, textStatus) {
        $.AjaxRequest.Execute(responseText);
    });

}

///排序下移
Page.Functions.Table.OrderDown = function (id, arg) {

    var NewArg = Page.UI.UpdateArgs(id, arg);

    var szPath = Page.Storage.Get("OA_" + id + "_Path");

    Page.Ajax(szPath + "Ajax/Order_Down.aspx", NewArg, false, function (responseText, textStatus) {
        $.AjaxRequest.Execute(responseText);
    });

}

///排序保存
Page.Functions.Table.OrderSave = function (id, arg) {

    var NewArg = Page.UI.UpdateArgs(id, arg);

    var szPath = Page.Storage.Get("OA_" + id + "_Path");

    Page.Ajax(szPath + "Ajax/Order_Save.aspx", NewArg, false, function (responseText, textStatus) {
        $.AjaxRequest.Execute(responseText);
    });

}

///筛选
Page.Functions.Table.Filter = function (path, id, title, width, height, arg) {

    var NewArg = Page.UI.UpdateArgs(id, arg);

    Page.Functions.Table.Dialog(id + "_Filter", id, "数据筛选", width + 1, height + 1, path, "Ajax/Filter.aspx", NewArg);
}

///关联
Page.Functions.Table.Command = function (id, path, arg) {
    var szName = Page.Storage.Get("OA_Table_Select_" + id);

    if (szName == "") {
        alert('请先选择一行数据!')
        return;
    }

    arg["Arg_ID"] = szName;

    //var szPath = Page.Storage.Get("OA_" + id + "_Path");
    var szPath = "/Files/App/OA/Process/";
    var szTitle = Page.Storage.Get("OA_" + id + "_UITitle");

    Page.UI.Open(id, "", szTitle, szPath, "Relation.aspx", arg);

    //Page.Ajax(path + "Relation.aspx", arg, false, function (responseText, textStatus) {
    //    $.AjaxRequest.Execute(responseText);
    //});
    //if($.Process.Values['<%=sID%>']!=''){$.post('<%=sPath%>Relation.aspx', { Path: '<%=sPath%>', ID: '<%=pg.PageArgs.Process_ElementID%>',Table:<%=sTable%>,ViewTable:<%=gintTable%>,Arg_ID:$.Process.Values['<%=sID%>'],Arg_Index:<%=gintIndex + 1%>,Arg_Relation:'<%=sRelations[i]%>'},$.AjaxRequest.Execute);}else{alert('请先选择一行数据!')};
}

///关联
Page.Functions.Table.History = function (path, arg) {

    Page.Ajax(path + "Process.aspx", arg, false, function (responseText, textStatus) {
        $.AjaxRequest.Execute(responseText);
    });
    //if($.Process.Values['<%=sID%>']!=''){$.post('<%=sPath%>Relation.aspx', { Path: '<%=sPath%>', ID: '<%=pg.PageArgs.Process_ElementID%>',Table:<%=sTable%>,ViewTable:<%=gintTable%>,Arg_ID:$.Process.Values['<%=sID%>'],Arg_Index:<%=gintIndex + 1%>,Arg_Relation:'<%=sRelations[i]%>'},$.AjaxRequest.Execute);}else{alert('请先选择一行数据!')};
}