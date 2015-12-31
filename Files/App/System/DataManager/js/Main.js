/// <reference path="http://js.dyksoft.com/jq/jquery-1.11.3.js" />
/// <reference path="http://js.dyksoft.com/XKits/1.01.1510/X.js" />
/// <reference path="http://js.dyksoft.com/XKits/1.01.1510/X.Ajax.js" />
/// <reference path="http://js.dyksoft.com/XKits/1.01.1510/X.Client.js" />
/// <reference path="http://js.dyksoft.com/XKits/1.01.1510/X.Storage.js" />
/// <reference path="/js/Page.js" />

X.Custom.DataManager = function () { }

//获取列表信息
X.Custom.DataManager.SetVisit = function (id) {
    var arg = {};
    arg["Arg_Table"] = id;

    var szPath = X.Storage.Get("DataManager_UIPath");
    arg["UI_Path"] = szPath;

    X.Ajax.PostDataAsync(szPath + "Ajax/Visit.aspx", Page.UpdateArgs(arg));
}

//获取列表信息
X.Custom.DataManager.GetList = function (id) {
    var arg = {};
    arg["Key_ID"] = id;

    var szPath = X.Storage.Get("DataManager_UIPath");
    arg["UI_Path"] = szPath;

    X.Ajax.PostDataAsync(szPath + "List.aspx", Page.UpdateArgs(arg), function (data) {
        $("#DataManager_List").html(data);
    });
}

//获取树形列表信息
X.Custom.DataManager.GetTree = function (id) {
    var arg = {};
    arg["Key_ID"] = id;

    var szPath = X.Storage.Get("DataManager_UIPath");
    arg["UI_Path"] = szPath;

    X.Ajax.PostDataAsync(szPath + "Tree.aspx", Page.UpdateArgs(arg), function (data) {
        $("#DataManager_Dir_" + id).html(data);
        $("#DataManager_Dir_" + id).css({ display: "" });

        X.Page.loadImage(szPath + "Images/Open.jpg", function () {
            var obj = document.getElementById("DataManager_Dir_" + id + "_Sign");
            if (obj) obj.src = szPath + "Images/Open.jpg";
        });
    });
}

//获取树形列表信息
X.Custom.DataManager.GetTreeNode = function (id) {
    var arg = {};
    arg["Key_ID"] = id;

    var szPath = X.Storage.Get("DataManager_UIPath");
    arg["UI_Path"] = szPath;

    if ($("#DataManager_Dir_" + id).html() == "") {
        X.Ajax.PostDataAsync(szPath + "Tree.aspx", Page.UpdateArgs(arg), function (data) {
            $("#DataManager_Dir_" + id).html(data);
            $("#DataManager_Dir_" + id).css({ display: "" });

            X.Page.loadImage(szPath + "Images/Open.jpg", function () {
                document.getElementById("DataManager_Dir_" + id + "_Sign").src = szPath + "Images/Open.jpg";
            });

        });
    } else {
        $("#DataManager_Dir_" + id).html("");
        $("#DataManager_Dir_" + id).css({ display: "none" });

        X.Page.loadImage(szPath + "Images/Close.jpg", function () {
            document.getElementById("DataManager_Dir_" + id + "_Sign").src = szPath + "Images/Close.jpg";
        });
    }

}