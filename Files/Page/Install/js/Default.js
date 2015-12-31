/// <reference path="http://js.dyksoft.com/jq/jquery-1.11.3.js" />
/// <reference path="http://js.dyksoft.com/XKits/1.02.1511/X.js" />
/// <reference path="http://js.dyksoft.com/XKits/1.02.1511/X.Ajax.js" />
/// <reference path="http://js.dyksoft.com/XKits/1.02.1511/X.ServerPort.js" />
/// <reference path="../../../js/Controls/AjaxRequest.js" />

$(document).ready(function () {
    //$("#TextArea").css({ height: document.documentElement.clientHeight - 85 });

    //$(window).resize(function () {
    //alert("OK");
    //$("#TextArea").css({ height: document.documentElement.clientHeight - 85 });
    //});
});

///保存Aos_Manage数据库设置
X.Custom.SaveAosManage = function () {
    var arg = {};
    arg["dbRootPwd"] = $("#dbRootPwd").val();
    arg["dbRootPwdRe"] = $("#dbRootPwdRe").val();

    X.ServerPort.ExecuteUrl("Ajax/SaveAosManage.aspx", arg);
}

///保存Aos数据库设置
X.Custom.SaveAos = function () {
    var arg = {};
    arg["dbPath"] = $("#dbPath").val();

    X.ServerPort.ExecuteUrl("Ajax/SaveAos.aspx", arg);
}

///保存数据库设置
X.Custom.SaveDBConn = function () {
    var arg = {};
    arg["dbHost"] = $("#dbHost").val();
    arg["dbName"] = $("#dbName").val();
    arg["dbPwd"] = $("#dbPwd").val();

    X.ServerPort.ExecuteUrl("Ajax/SaveDBConn.aspx", arg);
}

var Page = function () { }

Page.UpdateData = function (file, name) {
    $.post("Update.aspx", { Arg_File: file, Arg_Name: name }, function (data) {
        //alert(e);
        $.AjaxRequest.Execute(data);
    });
}

Page.SetPwd = function () {

    var pwd = $("#pwd").val();

    $.post("Pwd.aspx", { Arg_Pwd: pwd }, function (data) {
        //alert(e);
        $.AjaxRequest.Execute(data);
    });
}

///用户登录
Page.UserLogin = function () {
    $.post("Login.aspx", { Username: $("#Username").val(), Password: $("#Password").val() }, function (data) {
        $.AjaxRequest.Execute(data);
    });
}