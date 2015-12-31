/// <reference path="http://js.dyksoft.com/jq/jquery-1.11.3.js" />
/// <reference path="http://js.dyksoft.com/XKits/1.03.1512.js" />
/// <reference path="jq-debug.js" />
/// <reference path="../XKits/X.js" />
/// <reference path="../XKits/X.Page.js" />

var Page = function () { }

Page.Element = function () { }
Page.Element.Window = null;
Page.Element.Console = null;
Page.Element.Desktop = null;
Page.Element.Menu = null;
Page.Element.ToolTask = null;

///独立UI脚本申明,各个UI界面单独重载
Page.UI = function () { }

Page.UI.Init = function () { }
Page.UI.Show = function () { }
Page.UI.Load = function () { }
Page.UI.Login = function () { }
Page.UI.LoginHide = function (fun) { }
Page.UI.Open = function (id, tarid, title, path, page, arg) { }
Page.UI.Dialog = function (id, tarid, title, width, height, path, page, arg) { }
Page.UI.ResetLocation = function () { }

///更新提交参数
Page.UpdateArgs = function (arg) {
    if (arg == null) arg = {}

    arg["Azalea_SessionID"] = Page.Storage.Get("Azalea_SessionID");
    arg["Azalea_AuthID"] = Page.Storage.Get("Azalea_AuthID");
    arg["Azalea_Rnd"] = Math.random();

    return arg;
}

///更新提交参数
Page.UIUpdateArgs = function (id, arg) {
    if (arg == null) arg = {}

    //arg["UI_Path"] = path;
    if (!arg["UI"]) arg["UI"] = "Window";
    if (arg["UI"] == "") arg["UI"] = "Window";

    if (!arg["UI_ID"]) arg["UI_ID"] = id;
    if (arg["UI_ID"] == "") arg["UI_ID"] = id;

    if (!arg["UI_Tool"]) arg["UI_Tool"] = "Win_" + id + "_Tool";
    if (arg["UI_Tool"] == "") arg["UI_Tool"] = "Win_" + id + "_Tool";

    if (!arg["UI_Main"]) arg["UI_Main"] = "Win_" + id + "_Main";
    if (arg["UI_Main"] == "") arg["UI_Main"] = "Win_" + id + "_Main";
    //arg["UI_Title"] = title;

    if (!arg["UI_Path"]) arg["UI_Path"] = Page.Storage.Get(id + "_UI_Path");
    if (arg["UI_Path"] == "") arg["UI_Path"] = Page.Storage.Get(id + "_UI_Path");

    if (!arg["UI_Page"]) arg["UI_Page"] = Page.Storage.Get(id + "_UI_Page");
    if (arg["UI_Page"] == "") arg["UI_Page"] = Page.Storage.Get(id + "_UI_Page");

    if (!arg["UI_Title"]) arg["UI_Title"] = Page.Storage.Get(id + "_UI_Title");
    if (arg["UI_Title"] == "") arg["UI_Title"] = Page.Storage.Get(id + "_UI_Title");

    if (!arg["Arg_ID"]) arg["Arg_ID"] = Page.Storage.Get(id + "_Arg_ID");
    if (arg["Arg_ID"] == "") arg["Arg_ID"] = Page.Storage.Get(id + "_Arg_ID");

    if (!arg["Arg_Path"]) arg["Arg_Path"] = Page.Storage.Get(id + "_Arg_Path");
    if (arg["Arg_Path"] == "") arg["Arg_Path"] = Page.Storage.Get(id + "_Arg_Path");

    return Page.UpdateArgs(arg);

}
///更新OA专用提交参数
Page.UI.UpdateArgs = function (id, arg) {
    if (arg == null) arg = {}

    //arg["UI_Path"] = path;
    if (!arg["UI"]) arg["UI"] = "Window";
    if (arg["UI"] == "") arg["UI"] = "Window";

    if (!arg["UI_ID"]) arg["UI_ID"] = id;
    if (arg["UI_ID"] == "") arg["UI_ID"] = id;

    if (!arg["UI_Tool"]) arg["UI_Tool"] = "Win_" + id + "_Tool";
    if (arg["UI_Tool"] == "") arg["UI_Tool"] = "Win_" + id + "_Tool";

    if (!arg["UI_Main"]) arg["UI_Main"] = "Win_" + id + "_Main";
    if (arg["UI_Main"] == "") arg["UI_Main"] = "Win_" + id + "_Main";
    //arg["UI_Title"] = title;

    if (!arg["UI_Path"]) arg["UI_Path"] = Page.Storage.Get("OA_" + id + "_UIPath");
    if (arg["UI_Path"] == "") arg["UI_Path"] = Page.Storage.Get("OA_" + id + "_UIPath");

    if (!arg["UI_Page"]) arg["UI_Page"] = Page.Storage.Get("OA_" + id + "_UIPage");
    if (arg["UI_Page"] == "") arg["UI_Page"] = Page.Storage.Get("OA_" + id + "_UIPage");

    if (!arg["UI_Title"]) arg["UI_Title"] = Page.Storage.Get("OA_" + id + "_UITitle");
    if (arg["UI_Title"] == "") arg["UI_Title"] = Page.Storage.Get("OA_" + id + "_UITitle");

    if (!arg["Arg_ID"]) arg["Arg_ID"] = Page.Storage.Get("OA_" + id + "_Arg_ID");
    if (arg["Arg_ID"] == "") arg["Arg_ID"] = Page.Storage.Get("OA_" + id + "_Arg_ID");

    if (!arg["Arg_Path"]) arg["Arg_Path"] = Page.Storage.Get("OA_" + id + "_Path");
    if (arg["Arg_Path"] == "") arg["Arg_Path"] = Page.Storage.Get("OA_" + id + "_Path");

    if (!arg["Arg_Page"]) arg["Arg_Page"] = Page.Storage.Get("OA_" + id + "_Arg_Page");
    if (arg["Arg_Page"] == "") arg["Arg_Page"] = Page.Storage.Get("OA_" + id + "_Arg_Page");

    if (!arg["Arg_Index"]) arg["Arg_Index"] = Page.Storage.Get("OA_" + id + "_Arg_Index");
    if (arg["Arg_Index"] == "") arg["Arg_Index"] = Page.Storage.Get("OA_" + id + "_Arg_Index");

    if (!arg["Arg_Table"]) arg["Arg_Table"] = Page.Storage.Get("OA_" + id + "_Arg_Table");
    if (arg["Arg_Table"] == "") arg["Arg_Table"] = Page.Storage.Get("OA_" + id + "_Arg_Table");

    if (!arg["Arg_Table_Date"]) arg["Arg_Table_Date"] = Page.Storage.Get("OA_" + id + "_Arg_Table_Date");
    if (arg["Arg_Table_Date"] == "") arg["Arg_Table_Date"] = Page.Storage.Get("OA_" + id + "_Arg_Table_Date");

    if (!arg["Arg_Table_Key"]) arg["Arg_Table_Key"] = Page.Storage.Get("OA_" + id + "_Arg_Table_Key");
    if (arg["Arg_Table_Key"] == "") arg["Arg_Table_Key"] = Page.Storage.Get("OA_" + id + "_Arg_Table_Key");

    if (!arg["Arg_Table_Filters"]) arg["Arg_Table_Filters"] = Page.Storage.Get("OA_" + id + "_Arg_Table_Filters");
    if (arg["Arg_Table_Filters"] == "") arg["Arg_Table_Filters"] = Page.Storage.Get("OA_" + id + "_Arg_Table_Filters");

    if (!arg["Arg_Relation"]) arg["Arg_Relation"] = Page.Storage.Get("OA_" + id + "_Arg_Relation");
    if (arg["Arg_Relation"] == "") arg["Arg_Relation"] = Page.Storage.Get("OA_" + id + "_Arg_Relation");

    if (!arg["Arg_RelationText"]) arg["Arg_RelationText"] = Page.Storage.Get("OA_" + id + "_Arg_RelationText");
    if (arg["Arg_RelationText"] == "") arg["Arg_RelationText"] = Page.Storage.Get("OA_" + id + "_Arg_RelationText");

    return Page.UpdateArgs(arg);
}

Page.UILoaded = false;

Page.UploadID = "";
Page.BackgroundSrc = "";

Page.DatePicker = null;

//设置信息提示
Page.SetInfo = function (cnt) {
    //if(X.Client)
    if (X.Client.Enabled) {
        X.Client.SetInfo(cnt, "", "");
    }
}

///兼容非HTML本地数据临时存储
Page.LocalStorage = {};

///本地存储方法
Page.Storage = function () { }

///获取本地存储数据
Page.Storage.Get = function (key) {
    return X.Storage.Get(key);
}

///设置本地存储数据
Page.Storage.Set = function (key, value) {
    X.Storage.Set(key, value);
}

///页面Ajax加载
Page.Ajax = function (url, arg, async, fsuccess, ferror) {

    if (arg == null) arg = {};
    arg["Azalea_SessionID"] = X.Storage.Get("Azalea_SessionID");
    arg["Azalea_AuthID"] = X.Storage.Get("Azalea_AuthID");
    arg["Azalea_Rnd"] = Math.random();

    $.Console.log("正在加载页面:" + url + " ...");
    //$.Console.debug("页面参数:" + $.parseJSON(arg));

    //var head = document.cookie;
    //head += ";Azalea_SessionID=" + Page.Storage.Get("Azalea_SessionID");
    ////head["Azalea_SessionID"] = Page.Storage.Get("Azalea_SessionID");
    //alert(head);

    $.ajax({
        url: url,
        headers: { "Azalea_SessionID": Page.Storage.Get("Azalea_SessionID") },
        data: arg,
        type: "post",
        async: async,  //设置请求方式为同步
        success: function (responseText, textStatus) {
            $.Console.log("页面[" + url + "]加载完成!");
            if (fsuccess) fsuccess(responseText, textStatus);
        },
        error: function (XMLHttpRequest, textStatus, errorThrown) {
            $.Console.log("页面[" + url + "]加载失败!");
            if (ferror) ferror(XMLHttpRequest, textStatus, errorThrown);
        }
    });
}

///加载一个Js脚本文件
Page.LoadScript = function (id, src) {
    var js = document.getElementById(id);
    if (!js) {
        js = document.createElement("script");
        js.id = id
        js.src = src;
        document.body.appendChild(js);
    }
}

///页面定义函数
Page.Functions = function () { }

///设置动态加载标志
X.Page.Scripts["Page"] = true;