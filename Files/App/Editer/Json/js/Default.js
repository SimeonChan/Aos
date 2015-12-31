/// <reference path="../../../../../js/jquery-1.10.2.min.js" />
/// <reference path="../../../../../js/Page.js" />
/// <reference path="../../../../../js/Controls/AjaxRequest.js" />

Page.Functions.JsonEditer = function () { }

Page.Functions.JsonEditer.Save = function (path, taid, savepath, objpath) {
    var arg = {}
    arg["Arg_Cnt"] = $("#" + taid).val();
    arg["Arg_Path"] = savepath;
    arg["Arg_ObjectPath"] = objpath;
    Page.Ajax(path + "Save.aspx", arg, false, $.AjaxRequest.Execute);
}