/*
AzaleaOS专用脚本库
*/

///脚本入口
var Az = function () { }

///客户端交互专用类
Az.Client = function () { }

///客户端版本
Az.Client.Version = "";

///当前是否在客户端模式下工作
Az.Client.Enabled = false;

///获取客户端版本
Az.Client.GetVersion = function () { return ""; }

///设置本地化存储
Az.Client.SetStorage = function (key, value) { }

///读取本地化存储
Az.Client.GetStorage = function (key) { }

///读取本地化存储
Az.Client.Upload = function (fun, arg) { }

///读取本地化存储
Az.Client.Debug = function (cnt) { }

///弹出对话框
Az.Client.MsgBox = function (cnt) { }

///客户端操作初始化
Az.Client.Init = function (success, error) {
    //alert("EXT:" + window.external);
    if (window.external["toString"]) {
        if (window.external.toString() == "CytCloud.ClsJsTrans") {

            //函数重载
            Az.Client.GetVersion = function () { return window.external.GetVersion(); }
            Az.Client.SetStorage = function (key, value) { return window.external.SetStorage(key, value); }
            Az.Client.GetStorage = function (key) { return window.external.GetStorage(key); }
            Az.Client.Upload = function (fun, arg) { return window.external.Upload(fun, arg); }
            Az.Client.Debug = function (cnt) { return window.external.Debug(cnt); }
            Az.Client.MsgBox = function (cnt) { return window.external.MsgBox(cnt); }

            Az.Client.Version = Az.Client.GetVersion();
            Az.Client.Enabled = true;
            if (success) success();
        } else {
            if (error) error();
        }
    } else {
        if (error) error();
    }
}