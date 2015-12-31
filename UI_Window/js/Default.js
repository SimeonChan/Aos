/// <reference path="http://js.dyksoft.com/jq/jquery-1.11.3.js" />
/// <reference path="http://js.dyksoft.com/XKits/1.03.1512.js" />
/// <reference path="../../js/Az.js" />
/// <reference path="../../js/jquery-1.10.2.min.js" />
/// <reference path="../../XKits/X.js" />
/// <reference path="../../js/Page.js" />
/// <reference path="../../js/Default.js" />
/// <reference path="../../js/Page/Initialize.js" />

///Logo动画测试
X.Custom.testLogo = function () {
    X.Custom.Variables.LogoNow++;
    X.Custom.setLogoPoint();
    if (X.Custom.Variables.LogoNow < X.Custom.Variables.LogoFull) {
        setTimeout(X.Custom.testLogo, 100);
    }
}

X.ready(function () {

    //$("#Login_UserName").click(function () {
    //    //$("#Login_UserName").focus();
    //    //alert("OK");
    //    document.getElementById("Login_UserName").focus();
    //});

});

Page.UI.LoginHide = function (fun) {
    //Page.Functions.Test.Msg("Test OK");
    $("#Login").animate({ opacity: 0 }, 500, function () {
        $("#Login").css({ display: "none" });
        $("#Console").animate({ top: (document.documentElement.clientHeight - 30) / 2 - 60 }, 500, fun);
    });
}

Page.UI.Login = function () {
    var nLeft = (X.Page.Width - 393) / 2;
    var nTop = (X.Page.Height - 550) / 2;
    $("#Login").css({ left: nLeft, top: nTop, display: "", opacity: 0 });
    $("#Login").animate({ opacity: 1 }, 200, function () { });
    //$("#Console").animate({ top: (document.documentElement.clientHeight - 330) / 2 - 80 }, 500, function () {

    //});
}

Page.UI.ResetLocation = function () {

    X.Page.getArea();

    //$("#Main").css({ width: X.Page.Width, height: X.Page.Height });
    $(Page.Element.Desktop).css({ width: X.Page.Width, height: X.Page.Height });

    $("#Console").css({ left: 50, top: document.documentElement.clientHeight - 80, width: document.documentElement.clientWidth - 305 });
    $("#Menu").css({ left: document.documentElement.clientWidth - 240, height: document.documentElement.clientHeight - 100 });

    //$("#Main").css({ width: document.documentElement.clientWidth + Console.Width });
    //$("#Desktop").css({ width: document.documentElement.clientWidth, height: document.documentElement.clientHeight });
    $("#Window").css({ width: document.documentElement.clientWidth - 295, height: document.documentElement.clientHeight - 170 });
    $("#Window_Rect").css({ width: document.documentElement.clientWidth - 295, height: document.documentElement.clientHeight - 170 });
    $("#Window_Bg").css({ width: document.documentElement.clientWidth - 295, height: document.documentElement.clientHeight - 170 });
    $("#Window_Title").css({ width: document.documentElement.clientWidth - 300 });
    $("#Window_Frame").css({ width: document.documentElement.clientWidth - 295, height: document.documentElement.clientHeight - 135 });

    if (Console.Element != null) $(Console.Element).css({ height: Console.Height, width: document.documentElement.clientWidth - 100 });
    if (Taskbar.Element != null) $(Taskbar.Element).css({ width: document.documentElement.clientWidth });
    if (Page.Element.Desktop.BackgroudImage != null) {
        Page.Element.Desktop.BackgroudImage.height = document.documentElement.clientHeight;
        Page.Element.Desktop.BackgroudImage.width = document.documentElement.clientWidth;
    }

    if ($.Process.Count > 0) {
        $("#Win_" + $.Process.Items[$.Process.SelectedIndex].Id).css({ width: document.documentElement.clientWidth - 305, height: document.documentElement.clientHeight - 180 });
    }
}

Page.UI.Dialog = function (id, tarid, title, width, height, path, page, arg) {

    if (arg == null) arg = {}

    arg["UI_Path"] = path;
    arg["UI"] = "Window";
    arg["UI_ID"] = tarid;
    arg["UI_Tool"] = "Win_" + tarid + "_Tool";
    arg["UI_Main"] = "Win_" + tarid + "_Main";
    arg["UI_Title"] = title;

    $.Dialog.ShowFromUrl(id, title, width + 1, height + 1, path + page, arg);
}

Page.UI.Open = function (id, tarid, title, path, page, arg) {
    //$.post(url, arg, $.AjaxRequest.Execute);
    if (arg == null) arg = {}
    arg["UI_Path"] = path;
    arg["UI"] = "Window";
    arg["UI_ID"] = id;
    arg["UI_Tool"] = "Win_" + id + "_Tool";
    arg["UI_Main"] = "Win_" + id + "_Main";
    arg["UI_Title"] = title;
    $.Process.Add(id, title, path, page, arg);

    //alert($("#Win_" + id).height() + ":" + $("#Win_" + id + "_Main").height());

}

Page.UI.Show = function () {
    $("#Window_Title").css({ opacity: 0.8, display: "" });
    //$("#Window_Title").animate({ opacity: 0.8 }, 500, function () {
    X.Custom.Variables.LogoNow++;
    X.Custom.setLogoPoint();

    $("#Window").css({ opacity: 1, display: "" });
    //$("#Window").animate({ opacity: 1 }, 500, function () {
    X.Custom.Variables.LogoNow++;
    X.Custom.setLogoPoint();

    $("#Menu").css({ opacity: 0.8, display: "" });
    //$("#Menu").animate({ opacity: 0.8 }, 500, function () {
    X.Custom.Variables.LogoNow++;
    X.Custom.setLogoPoint();

    $("#Console").css({ top: document.documentElement.clientHeight - 80, left: 50, width: document.documentElement.clientWidth - 305, display: "", opacity: 0.8 });
    //$("#Console").animate({ opacity: 0.8 }, 500, function () {
    X.Custom.Variables.LogoNow++;
    X.Custom.setLogoPoint();

    //setTimeout(Page.Loaded, 100);
    Page.Loaded();
    //});
    //});
    //});
    //});
}

Page.UI.Load = function () {

    //

    //alert("Page.UI.Load");

    //$("#Main").css({ width: document.documentElement.clientWidth + Console.Width });
    //$("#Desktop").css({ width: document.documentElement.clientWidth, height: document.documentElement.clientHeight });
    $("#Window").css({ width: document.documentElement.clientWidth - 295, height: document.documentElement.clientHeight - 170 });
    $("#Window_Rect").css({ width: document.documentElement.clientWidth - 295, height: document.documentElement.clientHeight - 170 });
    $("#Window_Bg").css({ width: document.documentElement.clientWidth - 295, height: document.documentElement.clientHeight - 170 });
    $("#Window_Title").css({ width: document.documentElement.clientWidth - 300 });

    $("#Window_Frame").css({ width: document.documentElement.clientWidth - 295, height: document.documentElement.clientHeight - 135 });

    $("#Menu").css({ left: document.documentElement.clientWidth - 240, height: document.documentElement.clientHeight - 100 });

}

Page.UI.Init = function () {

    X.Page.setFullScreen();
    //Page.LoadScript("js_test", "/js/Test.js");

    X.Page.getArea();

    Page.Element.Console = document.getElementById("Console");
    Page.Element.Desktop = document.getElementById("Desktop");
    Page.Element.Menu = document.getElementById("Menu_Main");

    //$("#Main").css({ width: X.Page.Width, height: X.Page.Height });
    $(Page.Element.Desktop).css({ width: X.Page.Width, height: X.Page.Height, opacity: 0 });
    $("#Launch").css({ width: X.Page.Width, height: X.Page.Height });

    var nLeft = (X.Page.Width - 73) / 2;
    var nTop = (X.Page.Height - 200) / 2 - 80;
    //alert(nLeft + ":" + nTop);
    $("#Logo").css({ left: nLeft, top: nTop });
    //setTimeout(X.Custom.testLogo, 100);

    Console.Color = "#fff";
    Console.Height = 20;
    Console.Width = document.documentElement.clientWidth - 100;

    //Console.Load(Page.Element.Console);
    //setTimeout(Page.Init, 10);

    //alert(X.Page.getArea);

}

///设置动态加载标志
X.Page.Scripts["Page_Default"] = true;