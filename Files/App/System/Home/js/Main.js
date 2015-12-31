/// <reference path="http://js.dyksoft.com/jq/jquery-1.11.3.js" />
/// <reference path="http://js.dyksoft.com/XKits/1.01.1510/X.js" />
/// <reference path="http://js.dyksoft.com/XKits/1.01.1510/X.Ajax.js" />
/// <reference path="http://js.dyksoft.com/XKits/1.01.1510/X.Client.js" />
/// <reference path="http://js.dyksoft.com/XKits/1.01.1510/X.Storage.js" />
/// <reference path="/js/Page.js" />

X.Custom.Home = function () { }

//获取列表信息
X.Custom.Home.SetVisit = function (id) {
    var arg = {};
    arg["Arg_Table"] = id;

    var szPath = X.Storage.Get("DataManager_UIPath");
    arg["UI_Path"] = szPath;

    X.Ajax.PostDataAsync(szPath + "Ajax/Visit.aspx", Page.UpdateArgs(arg));
}