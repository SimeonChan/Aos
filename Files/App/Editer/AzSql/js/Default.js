/// <reference path="../../../../../js/jquery-1.10.2.min.js" />
/// <reference path="../../../../../js/Page.js" />
/// <reference path="../../../../../js/Controls/AjaxRequest.js" />

Page.Functions.TextEditer = function () { }

Page.Functions.TextEditer.Save = function (path, taid, savepath) {
    var arg = {}
    arg["Arg_Cnt"] = $("#" + taid).val();
    arg["Arg_Test_Cnt"] = $("#" + taid + "_Test").val();
    arg["Arg_Path"] = savepath;
    Page.Ajax(path + "Save.aspx", arg, false, $.AjaxRequest.Execute);
}