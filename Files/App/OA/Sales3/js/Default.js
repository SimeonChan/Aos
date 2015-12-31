/// <reference path="http://js.dyksoft.com/jq/jquery-1.11.3.js" />
/// <reference path="http://js.dyksoft.com/XKits/1.01.1510/X.js" />
/// <reference path="http://js.dyksoft.com/XKits/1.01.1510/X.Client.js" />
/// <reference path="http://js.dyksoft.com/XKits/1.01.1510/X.Storage.js" />
/// <reference path="../../../../../js/Page.js" />
/// <reference path="/js/Controls/AjaxRequest.js" />

Page.Functions.Sales3 = function () { }

///弹出窗口
Page.Functions.Sales3.Dialog = function (id, tarid, title, width, height, path, page, arg) {

    var argNew = Page.UI.UpdateArgs(tarid, arg);

    //$.Dialog.ShowFromUrl(id, title, width + 1, height + 1, path, arg);
    Page.UI.Dialog(id, tarid, title, width, height, path, page, argNew)
}

///添加
Page.Functions.Sales3.Add = function (path, id, title, width, height, arg) {
    Page.Functions.Sales3.Dialog(id + "_Edit", id, "[" + title + "] - 添加记录", width + 1, height + 1, "/Files/App/OA/UI/", "Add.aspx", arg);
}