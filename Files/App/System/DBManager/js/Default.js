/// <reference path="../../../../../js/jquery-1.10.2.min.js" />
/// <reference path="../../../../../js/Page.js" />
/// <reference path="../../../../../js/Controls/AjaxRequest.js" />

Page.Functions.DBManager = function () { }

Page.Functions.DBManager.Name = "";

Page.Functions.DBManager.Update = function (path, arg) {
    if (Page.Functions.DBManager.Name == "") {
        alert("请先选择一行数据!");
        return;
    }
    if (arg == null) arg = {}
    arg["Arg_Name"] = Page.Functions.DBManager.Name;
    Page.Ajax(path + "Update.aspx", arg, false, $.AjaxRequest.Execute);
}

Page.Functions.DBManager.OAUpdate = function (path, arg) {
    if (Page.Functions.DBManager.Name == "") {
        alert("请先选择一行数据!");
        return;
    }
    if (arg == null) arg = {}
    arg["Arg_Name"] = Page.Functions.DBManager.Name;
    Page.Ajax(path + "OAUpdate.aspx", arg, false, $.AjaxRequest.Execute);
}

Page.Functions.DBManager.Select = function (name) {
    if (Page.Functions.DBManager.Name != "") {
        $("#DB_" + Page.Functions.DBManager.Name).css({ backgroundColor: "" });
    }
    Page.Functions.DBManager.Name = name;
    $("#DB_" + Page.Functions.DBManager.Name).css({ backgroundColor: "#ffd58d" });
}

///数据库内容初始化
Page.Functions.DBManager.Init = function (path) {
    Page.Ajax(path + "Init.aspx", {}, false, $.AjaxRequest.Execute);
}