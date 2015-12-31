/// <reference path="http://js.dyksoft.com/jq/jquery-1.11.3.js" />
/// <reference path="http://js.dyksoft.com/XKits/1.01.1510/X.js" />
/// <reference path="http://js.dyksoft.com/XKits/1.01.1510/X.Client.js" />
/// <reference path="http://js.dyksoft.com/XKits/1.01.1510/X.Storage.js" />
/// <reference path="http://js.dyksoft.com/XKits/1.01.1510/X.ServerPort.js" />
/// <reference path="../../../../../js/Page.js" />
/// <reference path="/js/Controls/AjaxRequest.js" />

//Page.Functions.OA = function () { }

X.Custom.AosAuth = function () { }

///添加一条新的数据
X.Custom.AosAuth.Add = function () {
    var arg = {};

    var szPath = X.Storage.Get("Aos_Auth_UIPath");
    arg["UI_Path"] = szPath;

    X.Ajax.PostDataAsync(szPath + "Ajax/Add.aspx", Page.UpdateArgs(arg), function (data) {
        //$("#DataManager_List").html(data);
        var obj = document.getElementById("Aos_Auth_Table");
        var tr = document.createElement("tr");
        //div.innerHTML = data;
        //var tr = div.getElementsByTagName("tr");
        obj.appendChild(tr);
        tr.outerHTML = data;
    });
}

///选择一条数据
X.Custom.AosAuth.Select = function (id) {
    var nIDTemp = X.Storage.Get("Auth_ID");
    $("#Aos_Auth_tr_" + nIDTemp).css({ backgroundColor: "" });

    X.Storage.Set("Auth_ID", id);
    $("#Aos_Auth_tr_" + id).css({ backgroundColor: "#ffc8a1" });
}

///选择一条数据
X.Custom.AosAuth.Delete = function () {
    var nID = X.Storage.Get("Auth_ID");
    var arg = {};

    arg["Arg_ID"] = nID;

    var szPath = X.Storage.Get("Auth_UI_Path");

    X.ServerPort.ExecuteUrl(szPath + "Ajax/Delete.aspx", Page.UIUpdateArgs("Auth", arg));

}

///建立数据库
X.Custom.AosAuth.CreatDB = function () {
    var nID = X.Storage.Get("Auth_ID");
    var arg = {};

    arg["Arg_ID"] = nID;

    var szPath = X.Storage.Get("Auth_UI_Path");

    X.ServerPort.ExecuteUrl(szPath + "Ajax/SaveDatabase.aspx", Page.UIUpdateArgs("Auth", arg));

}

///编辑一个数据
X.Custom.AosAuth.Edit = function (id, name) {
    var arg = {};

    arg["Arg_ID"] = id;
    arg["Arg_Name"] = name;

    var szPath = X.Storage.Get("Auth_UI_Path");
    arg["UI_Path"] = szPath;

    X.Ajax.PostDataAsync(szPath + "Ajax/Edit.aspx", Page.UpdateArgs(arg), function (data) {
        //$("#DataManager_List").html(data);
        var obj = document.getElementById("Aos_Auth_tr_" + id + "_td_" + name);
        obj.innerHTML = data;
        //tr.outerHTML = data;
        document.getElementById("Aos_Auth_tr_" + id + "_td_" + name + "_input").focus();
    });
}

///编辑一个数据
X.Custom.AosAuth.EditSave = function (id, name) {
    var arg = {};

    arg["Arg_ID"] = id;
    arg["Arg_Name"] = name
    arg["Arg_Value"] = $("#Aos_Auth_tr_" + id + "_td_" + name + "_input").val();

    var szPath = X.Storage.Get("Auth_UI_Path");
    arg["UI_Path"] = szPath;

    X.Ajax.PostDataAsync(szPath + "Ajax/EditSave.aspx", Page.UpdateArgs(arg), function (data) {
        //$("#DataManager_List").html(data);
        var obj = document.getElementById("Aos_Auth_tr_" + id + "_td_" + name);
        obj.innerHTML = "<div style=\"width: 100%;\" onclick=\"X.Custom.AosAuth.Edit(" + id + ",'" + name + "');\">" + data + "</div>";
        //tr.outerHTML = data;
    });
}


