/// <reference path="/js/jquery-1.10.2.min.js" />
/// <reference path="../../../../js/Controls/AjaxRequest.js" />

var Page = function () { }

Page.Add = function (path) {
    var szName = $("#txtName").val();
    var szType = $("#selType").val();

    $.post("Add.aspx", { path: path, name: szName, type: szType }, $.AjaxRequest.Execute);
}