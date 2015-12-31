/// <reference path="../../js/jquery-1.10.2.min.js" />
/// <reference path="../../js/Page.js" />
/// <reference path="../../js/Default.js" />

Page.UI.LoginHide = function (fun) {
    fun();
}

Page.UI.Login = function () {
    //var cd = $.Card.Add("Card_UserLogin", 0, 400);
    //cd.LoadFromUrl("/Files/App/System/Login/Main.aspx", {});
    //cd.SetTitle("用户登录");
    //$("#Desktop_Main").load("/Files/App/System/Login/Main.aspx", {});

    Page.Ajax("/Files/App/System/Login/Main.aspx", {}, true, function (responseText, status) {
        $("#Desktop_Main").html(responseText);
    });
    //Page.UI.Open("Card_UserLogin", "", "用户登录", "/Files/App/System/Login/", "Main.aspx", {});
}

Page.UI.Open = function (id, tarid, title, path, page, arg) {
    if (arg == null) arg = {}
    arg["UI_Path"] = path;
    arg["UI_ID"] = "Desktop";
    arg["UI_Tool"] = "Desktop_Tool";
    arg["UI_Main"] = "Desktop_Main";
    arg["UI_Title"] = title;
    arg["UI"] = "Moblie";

    Page.Ajax(path + page, arg, true, function (responseText, status) {
        //$("#Desktop_Main").html(responseText);
        $.AjaxRequest.Execute(responseText);
    });
    //$.post(path + page, arg, $.AjaxRequest.Execute);
}

Page.UI.Show = function () {
    setTimeout(Page.Loaded, 100);
}

Page.UI.Load = function () {
    $(Page.Element.Desktop).css({ height: "100%" });
}

Page.UI.Init = function () {
    var ms = document.getElementsByTagName('meta');
    var p = ms[0].parentNode;
    var m = document.createElement('meta');
    //m.content = node.Name + ',' + node.Name;
    //var scale = 1 / parseFloat(window.devicePixelRatio);
    var scale = "1.0";
    m.name = 'viewport';
    m.content = "width=device-width,target-densitydpi=device-dpi,initial-scale=" + scale + ", minimum-scale=" + scale + ", maximum-scale=" + scale + ", user-scalable=no";
    p.appendChild(m);

    var nSWidth = document.documentElement.clientWidth;
    var nSHeight = document.documentElement.clientHeight;

    Page.Element.Window = document.getElementById("WorkWindow");
    Page.Element.Console = document.getElementById("Console");
    Page.Element.Desktop = document.getElementById("Desktop");

    $(Page.Element.Console).css({ height: 18 });
    $(Page.Element.Window).css({ width: nSWidth, height: nSHeight - 52 });

    //Console.Enabled = false;

    Console.Color = "#fff";
    Console.Height = "100%";
    Console.Width = "100%";

    Console.Load(Page.Element.Console);
    //setTimeout(Page.Init, 10);

}