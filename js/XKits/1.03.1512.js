/// <reference path="/js/jquery-1.10.2.min.js" />

/*
联谊网络科技X套件
主要用于扩展Javascript脚本及JQ套件(Ver:1.10.2)
*/
var X = {};

/*
套件版本
*/
X["Version"] = "1.03.1512";


/*
初设置项定义
*/
X["Configs"] = {
    host: "",
    Completed: {}
};


/*
页面自定义接口
*/
X["Custom"] = function () { }
///页面自定义变量
X.Custom.Variables = {}



/*
进程函数类
*/
X["Process"] = {}
///私有的函数池
X.Process["Funs"] = new Array();



/*
进程函数注册
*/
X["ready"] = function (fun) {
    X.Process.Funs[X.Process.Funs.length] = fun;
}


/*
套件初始化并执行所有X.ready注册的函数
*/
X["Initialize"] = {}

///组件加载等待时间设定,单位为白毫秒
X.Initialize["WaitTime"] = 500;

///组件加载已经等待时间,单位为白毫秒
X.Initialize["Waited"] = 0;

///当前加载组件名称
X.Initialize["KitName"] = "";

///当前加载组件后执行的函数
X.Initialize["KitFunction"] = null;

///当前加载组件失败后执行的函数
X.Initialize["KitFunctionError"] = null;

///脚本加载标志
X.Initialize["Imports"] = new Array();

///初始化自定义JS文件
X.Initialize["ImportLoadCheck"] = function () {
    var bLoad = true;
    //console.log(X.Initialize.KitName + ":" + X.Page.Scripts[X.Initialize.KitName]);
    if (X.Page.Scripts[X.Initialize.KitName]) {
        if (X.Initialize.KitFunction) X.Initialize.KitFunction();
    } else {
        X.Initialize.Waited++;
        if (X.Initialize.Waited < X.Initialize.WaitTime) {
            setTimeout(X.Initialize.ImportLoadCheck, 10);
        } else {
            if (X.Initialize.KitFunctionError) X.Initialize.KitFunctionError();
        }
    }
}

///初始化自定义JS文件
X.Initialize["ImportLoad"] = function (id, path, fun, errfun) {
    X.Initialize.Waited = 0;
    X.Initialize.KitName = id;
    X.Initialize.KitFunction = fun;
    X.Initialize.KitFunctionError = errfun;
    X.Page.loadImport(id, path);
    X.Initialize.ImportLoadCheck();
}

///加载用户自定义JS文件
X.Initialize["LoadImport"] = function (index) {
    if (index < X.Initialize.Imports.length) {
        var obj = X.Initialize.Imports[index];
        X.Initialize.ImportLoad(obj.ID, obj.Path, function () {
            X.Initialize.LoadImport(index + 1);
        }, function () {
            X.Initialize.LoadImport(index + 1);
        });
    } else { //组件加载已经完成

        //alert("Completed");

        //初始化客户端组件
        X.Client.Init();


        //执行所有由X.ready方法定义的函数集合
        //alert(X.Process.Funs.length);
        for (var i = 0; i < X.Process.Funs.length; i++) {
            X.Process.Funs[i]();
        }
    }
}


/*
JS文件加载申请
*/
X["Import"] = function (id, path) {
    var obj = {};
    obj["ID"] = id;
    obj["Path"] = path;
    X.Initialize.Imports[X.Initialize.Imports.length] = obj;
}



/*
初始化设定
*/
$(document).ready(function () {

    //初始化客户端组件
    X.Client.Init();

    //加载用户自定义JS文件
    X.Initialize.LoadImport(0);

});






﻿/// <reference path="/js/jquery-1.10.2.min.js" />
/// <reference path="X.js" />

/*
联谊网络科技X套件中的局部刷新子套件
版本号:1.0.15.10
*/

///本地存储类
X["Ajax"] = {};

///执行页面Ajax加载
X.Ajax["Execute"] = function (url, arg, type, async, fsuccess, ferror) {

    if (arg == null) arg = {};

    arg["X_SessionID"] = X.Storage.Get("Azalea_SessionID");
    arg["X_Rnd"] = Math.random();

    $.ajax({
        url: url,
        headers: { "X_SessionID": X.Storage.Get("X_SessionID") },
        data: arg,
        type: type,
        async: async,  //设置请求方式为同步
        success: function (responseText, textStatus) {
            //$.Console.log("页面[" + url + "]加载完成!");
            if (fsuccess) fsuccess(responseText);
        },
        error: function (XMLHttpRequest, textStatus, errorThrown) {
            //$.Console.log("页面[" + url + "]加载失败!");
            if (ferror) ferror(XMLHttpRequest);
        }
    });
}

///同步数据提交
X.Ajax["PostData"] = function (url, arg, fsuccess, ferror) {
    X.Ajax.Execute(url, arg, "post", false, fsuccess, ferror);
}

///异步数据提交
X.Ajax["PostDataAsync"] = function (url, arg, fsuccess, ferror) {
    X.Ajax.Execute(url, arg, "post", true, fsuccess, ferror);
}

///同步数据获取
X.Ajax["GetData"] = function (url, arg, fsuccess, ferror) {
    X.Ajax.Execute(url, arg, "get", false, fsuccess, ferror);
}

///异步数据获取
X.Ajax["GetDataAsync"] = function (url, arg, fsuccess, ferror) {
    X.Ajax.Execute(url, arg, "get", true, fsuccess, ferror);
}
﻿/// <reference path="/js/jquery-1.10.2.min.js" />
/// <reference path="X.0000.js" />

/*
联谊网络科技X套件中的客户端相关函数
版本号:1.01.1510
*/

/*
客户端操作类
*/
X["Client"] = {};

///客户端类初始化
X.Client["Init"] = function () { }

///客户端版本
X.Client["Version"] = "";

///当前是否在客户端模式下工作
X.Client["Enabled"] = false;

///获取客户端版本
X.Client["GetVersion"] = function () {
    try {
        return window.external.GetVersion();
    } catch (e) {
        //alert(e)
        return "";
    }
}

///设置窗体标题
X.Client["SetTitle"] = function (value) { }

///设置本地化存储
X.Client["SetStorage"] = function (key, value) { }

///读取本地化存储
X.Client["GetStorage"] = function (key) { }

///读取本地化存储
X.Client["Upload"] = function (fun, arg) { }

///读取本地化存储
X.Client["Debug"] = function (cnt) { }

///弹出对话框
X.Client["MsgBox"] = function (cnt) { }

///设置提示信息
X.Client["SetInfo"] = function (cnt, fun, arg) { }

///客户端操作初始化
X.Client.Init = function (success, error) {
    //alert("EXT:" + window.external);
    X.Client.Version = X.Client.GetVersion();
    if (X.Client.Version != "" && X.Client.Version != undefined) {

        //alert(X.Client.Version);

        //函数重载
        X.Client.SetTitle = function (value) { return window.external.SetTitle(value); }
        X.Client.SetStorage = function (key, value) { return window.external.SetStorage(key, value); }
        X.Client.GetStorage = function (key) { return window.external.GetStorage(key); }
        X.Client.Upload = function (fun, arg) { return window.external.Upload(fun, arg); }
        X.Client.Debug = function (cnt) { return window.external.Debug(cnt); }
        X.Client.MsgBox = function (cnt) { return window.external.MsgBox(cnt); }
        X.Client.SetInfo = function (cnt, fun, arg) { return window.external.SetInfo(cnt, fun, arg); }

        X.Client.Enabled = true;
        if (success) success();
    } else {
        if (error) error();
    }
}
﻿/// <reference path="/js/jquery-1.10.2.min.js" />
/// <reference path="X.js" />

/*
联谊网络科技X套件中的页面相关函数
版本号:1.01.1510
*/

/*
页面函数类
*/
X["Page"] = {};

///动态加载一个图像
X.Page["loadImage"] = function (url, fun, errfun) { }

///获取页面宽度
X.Page["Width"] = 0;

///获取页面高度
X.Page["Height"] = 0;

///获取页面区域信息
X.Page["getArea"] = function () { }

///设置窗口全屏
X.Page["setFullScreen"] = function () { }

///加载一个套件脚本文件
X.Page["loadKits"] = function (name) {
    var id = "X_" + name
    var js = document.getElementById(id);
    if (!js) {
        js = document.createElement("script");
        js.id = id
        js.src = "http://js.dyksoft.com/XKits/" + X.Version + "/X." + name + ".js?rnd=" + Math.random();
        document.body.appendChild(js);
        //while (!X.Configs.Completed[name]) { }
    }
}

///加载一个套件脚本文件
X.Page["loadImport"] = function (id, path) {
    //var id = "X_" + name
    var js = document.getElementById(id);
    if (!js) {
        js = document.createElement("script");
        js.id = id
        js.src = path + "?rnd=" + Math.random();
        document.body.appendChild(js);
        //while (!X.Configs.Completed[name]) { }
    }
}

///加载一个套件脚本文件
X.Page["loadKitsByConfig"] = function (name) {
    if (X.Configs.Kits[name]) {
        X.Page.loadKits(name);
    }
}

///脚本加载标志
X.Page["Scripts"] = {};

///脚本加载超时时间，单位十毫秒
X.Page["WaitTime"] = 500;

///动态加载图片
X.Page.loadImage = function (url, fun, errfun) {
    var Img = new Image();

    Img.onerror = function () {
        if (errfun) errfun(url);
        if (fun) fun(url);
    };

    Img.onload = function () {
        if (fun) fun(url);
    };

    Img.src = url;
}

///获取页面区域信息
X.Page.getArea = function () {
    //return document.documentElement.clientWidth;
    X.Page.Width = document.documentElement.clientWidth;
    X.Page.Height = document.documentElement.clientHeight;
}

///设置窗口全屏
X.Page.setFullScreen = function () {
    var docElm = document.documentElement;
    if (docElm.requestFullscreen) {
        docElm.requestFullscreen();
    } else if (docElm.msRequestFullscreen) {
        docElm.msRequestFullscreen();
    } else if (docElm.mozRequestFullScreen) {
        docElm.mozRequestFullScreen();
    } else if (docElm.webkitRequestFullScreen) {
        docElm.webkitRequestFullScreen();
    }
}

///动态加载脚本检测
X.Page["loadScriptCheck"] = function (id, cnt, fun, funerr) {
    if (X.Page.Scripts[id]) {
        if (fun) fun();
    } else {
        cnt++;
        if (cnt < X.Page.WaitTime) {
            setTimeout(function () {
                X.Page.loadScriptCheck(id, cnt, fun, funerr);
            }, 10);
        } else {
            if (funerr) funerr();
        }
    }
}

///加载一个Js脚本文件
X.Page["loadScript"] = function (id, src, fun, funerr) {
    var js = document.getElementById(id);
    if (!js) {
        js = document.createElement("script");
        js.id = id
        js.src = src + "?rnd=" + Math.random();
        document.body.appendChild(js);
        //X.FunsExecute();
        X.Page.loadScriptCheck(id, 0, fun, funerr);
    }
}
﻿/// <reference path="/js/jquery-1.10.2.min.js" />
/// <reference path="X.0000.js" />

/*
联谊网络科技X套件中的右键禁止兼容包
版本号:1.01.1510
*/

X["RightBan"] = {}

X.RightBan["Execute"] = function () {
    document.body.oncontextmenu = function (event) {
        if (event) {
            if (event.target.tagName != "INPUT" && event.target.tagName != "TEXTAREA") {
                return false;
            }
        } else {
            return false;
        }
    };
    //= document.body.ondragstart = document.body.onselectstart = document.body.onbeforecopy
    //document.body.onselect = document.body.oncopy = document.body.onmouseup = function () { try { document.selection.empty(); } catch (e) { } };
}
﻿/// <reference path="/js/jquery-1.10.2.min.js" />
/// <reference path="X.0000.js" />
/// <reference path="X.Client.js" />
/// <reference path="X.Page.js" />

/*
联谊网络科技X套件中的服务器交互端口数据接口
版本号:1.0.15.10
*/
X["ServerPort"] = {};

X.ServerPort["SetInfo"] = function (cnt) { }

///执行服务器端口指令
X.ServerPort["Execute"] = function (data) {
    try {
        var Obj = eval('(' + data + ')');

        if (Obj.Message != "") alert(Obj.Message);

        //提示信息
        if (Obj.Information != "") {
            if (X.Client.Enabled) {
                X.Client.SetInfo(Obj.Information);
            } else {
                X.ServerPort.SetInfo(Obj.Information);
            }
        }

        //刷新处理
        if (Obj.Refresh == 1) {
            location.reload();
            return 0;
        }

        //动态加载JS
        for (i = 0; i < Obj.Scripts.length; i++) {
            //alert(Obj.Styles[i].ID + ":" + Obj.Styles[i].Key + ":" + Obj.Styles[i].Value);
            //$("#" + Obj.Script[i].ID).css(Obj.Script[i].Key, Obj.Styles[i].Value);
            Page.LoadScript(Obj.Scripts[i].ID, Obj.Scripts[i].Src + "?rnd=" + Math.random());
        }

        //设定ID对应样式
        for (i = 0; i < Obj.Storage.length; i++) {
            //alert(Obj.Styles[i].ID + ":" + Obj.Styles[i].Key + ":" + Obj.Styles[i].Value);
            Page.Storage.Set(Obj.Storage[i].Key, Obj.Storage[i].Value);
        }

        //设定ID对应的值
        //alert(Obj.Values.length);
        for (i = 0; i < Obj.Values.length; i++) {
            switch (Obj.Values[i].Type) {
                case "text":
                    //alert(Obj.Values[i].ID + ":" + Obj.Values[i].Value);
                    $("#" + Obj.Values[i].ID).html(Obj.Values[i].Value);
                    break;
                case "value":
                    $("#" + Obj.Values[i].ID).val(Obj.Values[i].Value);
                    break;
            }
        }

        //设定ID对应样式
        for (i = 0; i < Obj.Styles.length; i++) {
            //alert(Obj.Styles[i].ID + ":" + Obj.Styles[i].Key + ":" + Obj.Styles[i].Value);
            $("#" + Obj.Styles[i].ID).css(Obj.Styles[i].Key, Obj.Styles[i].Value);
        }

        //设定ID对应样式
        for (i = 0; i < Obj.Debug.length; i++) {
            //alert(Obj.Styles[i].ID + ":" + Obj.Styles[i].Key + ":" + Obj.Styles[i].Value);
            if (Obj.Debug[i].Line == "true") {
                Console.Writeln(Obj.Debug[i].Content);
            } else {
                Console.Write(Obj.Debug[i].Content);
            }
        }

        ////处理指令请求
        //for (var i = 0; i < Obj.Scripts.length; i++) {

        //}

        //处理Ajax请求
        for (var i = 0 ; i < Obj.Ajax.length; i++) {
            switch (Obj.Ajax[i].Type) {
                case "Load":
                    if (Obj.Ajax[i].Status != "") Console.Write(Obj.Ajax[i].Status);

                    var arg = Obj.Ajax[i].Arg;
                    if (Obj.Ajax[i].TarID != "") arg = Page.UI.UpdateArgs(Obj.Ajax[i].TarID, arg);

                    Page.Ajax(Obj.Ajax[i].Url, arg, false, function (responseText) {
                        $("#" + Obj.Ajax[i].ID).html(responseText);
                        if (Obj.Ajax[i].Status != "") Console.Writeln("OK");
                    });

                    //$.ajax({
                    //    url: Obj.Ajax[i].Url,
                    //    data: Obj.Ajax[i].Arg,
                    //    async: false,  //设置请求方式为同步
                    //    success: function (responseText) {
                    //        //$("#div2").html("这里没效果" + responseText)
                    //        //alert(Obj.Ajax[i].Status);
                    //        $("#" + Obj.Ajax[i].ID).html(responseText);
                    //        if (Obj.Ajax[i].Status != "") Console.Writeln("OK");
                    //    }
                    //});
                    //$.ajax({
                    //});
                    //$("#" + Obj.Ajax[i].ID).load(Obj.Ajax[i].Url, Obj.Ajax[i].Arg, function (responseText, Status, xhr) {
                    //    Console.Writeln(Status);
                    //    Console.Writeln(responseText);
                    //    Console.Writeln(xhr);
                    //});
                    break;
                case "Script":
                    var arg = Obj.Ajax[i].Arg;
                    if (Obj.Ajax[i].TarID != "") arg = Page.UI.UpdateArgs(Obj.Ajax[i].TarID, arg);
                    Page.Ajax(Obj.Ajax[i].Url, arg, true, function (responseText, textStatus) {
                        //alert(responseText);
                        $.AjaxRequest.Execute(responseText);
                    });
                    //$.post(Obj.Ajax[i].Url, Obj.Ajax[i].Arg, function (data) {
                    //    $.AjaxRequest.Execute(data);
                    //});
                    break;
                case "UI":
                    Page.UI.Open(Obj.Ajax[i].ID, Obj.Ajax[i].TarID, Obj.Ajax[i].Title, Obj.Ajax[i].Path, Obj.Ajax[i].Page, Obj.Ajax[i].Arg);
                    //Page.UI.Open(id, tarid, title, path, page, arg);
                    break;
                case "Dialog":
                    Page.UI.Dialog(Obj.Ajax[i].ID, Obj.Ajax[i].TarID, Obj.Ajax[i].Title, Obj.Ajax[i].Width, Obj.Ajax[i].Height, Obj.Ajax[i].Path, Obj.Ajax[i].Page, Obj.Ajax[i].Arg);
                    //Page.UI.Dialog(id, tarid, title, width, height, path, page, arg);
                    break;
                case "Page":
                    window.open(Obj.Ajax[i].Url);
                    break;
                case "Close":
                    $.Dialog.Close(Obj.Ajax[i].ID);
                    break;
            }
        }

    } catch (e) {
        alert("服务器返回数据异常!" + e.toString());
    }
}

///从网址获取并执行服务器端口指令，此函数需要Ajax套件支持
X.ServerPort["ExecuteUrl"] = function (url, arg, ferror) {
    X.Ajax.PostData(url, arg, X.ServerPort.Execute, ferror);
}

///从网址获取并执行服务器端口指令，此函数需要Ajax套件支持
X.ServerPort["ExecuteUrlAsync"] = function (url, arg, ferror) {
    X.Ajax.PostDataAsync(url, arg, X.ServerPort.Execute, ferror);
}
﻿/// <reference path="/js/jquery-1.10.2.min.js" />
/// <reference path="X.js" />

/*
联谊网络科技X套件中的本地化存储相关函数
本类必须同时加载X.Client套件
版本号:1.0.15.10
*/

///本地存储类
X["Storage"] = {};

///临时性本地类存储
X.Storage["Items"] = {};

X.Storage["Set"] = function (key, value) {
    if (X.Client.Enabled) {
        return X.Client.SetStorage(key, value);
    } else {
        if (window.localStorage) {
            window.localStorage.setItem(key, value);
        } else {
            X.Storage.Items[key] = value;
        }
    }
}

///获取本地存储数据
X.Storage["Get"] = function (key) {
    var res;
    if (X.Client.Enabled) {
        res = X.Client.GetStorage(key);
    } else {
        if (window.localStorage) {
            res = window.localStorage.getItem(key);
        } else {
            res = X.Storage.Items[key];
        }
    }
    if (res == null) res = "";
    return res;
}

///获取本地存储数据
X.Storage["GetNumber"] = function (key) {
    var res;
    try {
        res = parseFloat(X.Storage.Get(key));
        if (isNaN(res)) {
            res = 0;
        }
    } catch (e) {
        res = 0;
    }
    return res;
}
﻿/// <reference path="/js/jquery-1.10.2.min.js" />
/// <reference path="X.js" />
/// <reference path="X.WindowControl.js" />
/// <reference path="X.WindowForm.js" />

/*
联谊网络科技X套件中的本地图形化工作套件
版本号:1.01.1511
*/

///本地图形化工作套件
X["Window"] = {};

///本地图形化工作主体元素
X.Window["Body"] = document.getElementById("");

///初始化事件
X.Window["Init"] = function (id) {

    var obj = document.getElementById(id);
    if (!obj) {
        //创建图形化工作区域
        obj = document.createElement("div");
        obj.style.position = "absolute";
        obj.style.left = "0px";
        obj.style.top = "0px";
        obj.style.width = "100%";
        obj.style.height = "100%";
        document.body.appendChild(obj);
    }

    //创建图形化工作主体元素
    var objNew = document.createElement("div");
    objNew.style.position = "absolute";
    objNew.style.width = "100%";
    objNew.style.height = "100%";

    obj.appendChild(objNew);

    X.Window.Body = objNew;

}

///图形化控件集
X.Window["Controls"] = new Array();

///添加窗体
X.Window["AddForm"] = function () {
    var nLen = X.Window.Controls.length;
    var f = new xForm(nLen);
    X.Window.Controls[nLen] = f;
    //f.Handle.Get();
    return f;
}

///图形化控件属性
function xProperty(v, funchange) {
    var proValue = v;

    ///获取属性值
    xProperty.prototype.Get = function () { return proValue; }

    ///设置属性值
    xProperty.prototype.Set = function (value) {
        proValue = value;
        if (funchange) funchange();
    }
}

///图形化控件属性
function xReadOnlyProperty(v) {
    var proValue = v;

    ///获取属性值
    xReadOnlyProperty.prototype.Get = function () { return proValue; }
}


﻿/// <reference path="/js/jquery-1.10.2.min.js" />
/// <reference path="X.js" />

/*
联谊网络科技X套件中的本地图形化工作套件中的控件基类
版本号:1.01.1511
*/
function xControl(handle, parent, form) {

    ///相关句柄
    xControl.prototype.getHandle = function () { return handle; }

    ///父对象
    xControl.prototype.getParent = function () { return parent; }

    ///父窗体
    xControl.prototype.getForm = function () { return form; }

    //位置变更事件
    var eventHandlersSiteChange = new Array();
    var executeSiteChange = function () {
        for (var i = 0; i < eventHandlersSiteChange.length; i++) {
            if (eventHandlersSiteChange[i]) eventHandlersSiteChange[i]();
        }
    }
    xControl.prototype.addSiteChangeEvent = function (fun) {
        var nLen = eventHandlersSiteChange.length;
        eventHandlersSiteChange[nLeft] = fun;
    }

    ///左边距
    var nLeft = 0;
    xControl.prototype.getLeft = function () { return nLeft; }
    xControl.prototype.setLeft = function (val) {
        if (nLeft != val) {
            nLeft = val;
            executeSiteChange();
        }
    }

    ///上边距
    var nTop = 0;
    xControl.prototype.getTop = function () { return nTop; }
    xControl.prototype.setTop = function (val) {
        if (nTop != val) {
            nTop = val;
            executeSiteChange();
        }
    }

    ///设置位置
    xControl.prototype.setLocation = function (x, y) {
        if (nLeft != x || nTop != y) {
            nLeft = x;
            nTop = y;
            executeSiteChange();
        }
    }

    //位置变更事件
    var eventHandlersSizeChange = new Array();
    var executeSizeChange = function () {
        for (var i = 0; i < eventHandlersSizeChange.length; i++) {
            if (eventHandlersSizeChange[i]) eventHandlersSizeChange[i]();
        }
    }
    xControl.prototype.addSizeChangeEvent = function (fun) {
        var nLen = eventHandlersSizeChange.length;
        eventHandlersSizeChange[nLeft] = fun;
    }

    ///宽度
    var nWidth = 0;
    xControl.prototype.getWidth = function () { return nWidth; }
    xControl.prototype.setWidth = function (val) {
        if (nWidth != val) {
            nWidth = val;
            executeSizeChange();
        }
    }

    ///高度
    var nHeight = 0;
    xControl.prototype.getHeight = function () { return nHeight; }
    xControl.prototype.setHeight = function (val) {
        if (nHeight != val) {
            nHeight = val;
            executeSizeChange();
        }
    }

    ///设置位置
    xControl.prototype.setSize = function (w, h) {
        if (nWidth != w || nHeight != h) {
            nWidth = w;
            nHeight = h;
            executeSizeChange();
        }
    }
}
﻿/// <reference path="/js/jquery-1.10.2.min.js" />
/// <reference path="X.js" />
/// <reference path="X.Window.js" />
/// <reference path="X.WindowControl.js" />

/*
联谊网络科技X套件中的本地图形化工作套件中的窗体
版本号:1.01.1511
*/
function xForm(handle) {

    ///相关句柄
    xForm.prototype.Control = new xControl(handle, null, null);

    //界面生成
    var obj = document.createElement("div");
    obj.style.position = "absolute";
    obj.style.left = "0px";
    obj.style.top = "0px";
    X.Window.Body.appendChild(obj);

    ///标题文本
    var szText = "";
    xForm.prototype.getText = function () { return szText; }
    xForm.prototype.setText = function (val) { szText = val; }

    ///处理位置变更事件
    xForm.prototype.Control.addSiteChangeEvent(function () {
        //alert(xForm.prototype.Control.getLeft() + ":" + xForm.prototype.Control.getTop())
        var ctl = xForm.prototype.Control;
        obj.style.left = ctl.getLeft() + "px";
        obj.style.top = ctl.getTop() + "px";
    });

    ///处理位置变更事件
    xForm.prototype.Control.addSizeChangeEvent(function () {
        //alert(xForm.prototype.Control.getLeft() + ":" + xForm.prototype.Control.getTop())
        var ctl = xForm.prototype.Control;
        obj.style.width = ctl.getWidth() + "px";
        obj.style.height = ctl.getHeight() + "px";
    });

}
