/// <reference path="../jquery-1.10.2.min.js" />
/// <reference path="Console.js" />
/// <reference path="../Page.js" />
/// <reference path="../jq-debug.js" />
/// <reference path="../jq-Dialog.js" />

///用于处理服务器交互信息
$.AjaxRequest = function () { }

$.AjaxRequest.Interface = function () { }

//交互使用的函数指令集合
$.AjaxRequest.Interface.Function = {}

//交互使用的变量集合
$.AjaxRequest.Interface.Variable = {}

///执行Json语句
$.AjaxRequest.Execute = function (data) {
    try {
        var Obj = eval('(' + data + ')');

        if (Obj.Message != "") alert(Obj.Message);

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

///设置动态加载标志
X.Page.Scripts["Page_AjaxRequest"] = true;
