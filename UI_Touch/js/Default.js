/// <reference path="../../js/jquery-1.10.2.min.js" />
/// <reference path="../../js/Page.js" />
/// <reference path="../../js/Default.js" />

Page.UI.LoginHide = function (fun) {
    $.Card.Remove("Card_UserLogin", fun);
}

Page.UI.Login = function () {
    var cd = $.Card.Add("Card_UserLogin", 0, 400);
    cd.LoadFromUrl("/Files/App/System/Login/Main.aspx", {});
    cd.SetTitle("用户登录");
    //Page.UI.Open("Card_UserLogin", "", "用户登录", "/Files/App/System/Login/", "Main.aspx", {});
}

Page.UI.ResetLocation = function () {
    var nRatio = parseFloat(window.devicePixelRatio);
    var nSWidth = document.documentElement.clientWidth;
    var nSHeight = document.documentElement.clientHeight;

    Console.Writeln("Reset desktop size : " + nSWidth + " * " + nSHeight);

    $(Page.Element.Window).css({ width: nSWidth, height: nSHeight });
    $(Page.Element.ToolTask).css({ width: 80 });
    $(Page.Element.Desktop).css({ width: nSWidth - 80 });

    //$("#Console").css({ left: 50, top: nSHeight - 80, width: nSWidth - 305 });
    //$("#Menu").css({ left: nSWidth - 240, height: nSHeight - 100 });

    //$("#Main").css({ width: nSWidth + Console.Width });
    //$("#Desktop").css({ width: nSWidth, height: nSHeight });
    //$("#Window").css({ width: nSWidth - 295, height: nSHeight - 170 });
    //$("#Window_Rect").css({ width: nSWidth - 295, height: nSHeight - 170 });
    //$("#Window_Bg").css({ width: nSWidth - 295, height: nSHeight - 170 });
    //$("#Window_Title").css({ width: nSWidth - 300 });
    //$("#Window_Frame").css({ width: nSWidth - 295, height: nSHeight - 135 });

    //if (Console.Element != null) $(Console.Element).css({ height: Console.Height, width: nSWidth - 100 });
    if (Taskbar.Element != null) $(Taskbar.Element).css({ width: nSWidth });
    if (Page.Desktop.BackgroudImage != null) {
        Page.Desktop.BackgroudImage.height = nSHeight;
        Page.Desktop.BackgroudImage.width = nSWidth;
    }
}

Page.UI.Open = function (id, tarid, title, path, page, arg) {
    //$.post(url, arg, $.AjaxRequest.Execute);
    var nIndex = -1;
    if (tarid != "") {
        nIndex = $.Card.GetIndex(tarid);
    }
    var cd = $.Card.Add(id, nIndex + 1, 600);
    cd.SetTitle(title);
    //cd.LoadFromUrl("/Files/App/Com_Application/Process.aspx");
    if (arg == null) arg = {}
    arg["Path"] = path;
    arg["UI_ID"] = cd.ID;
    arg["UI_Tool"] = cd.ToolElement.id;
    arg["UI_Main"] = cd.MainElement.id;
    arg["UI_Title"] = title;
    arg["UI"] = "Touch";

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

}

Page.UI.Init = function () {
    var ms = document.getElementsByTagName('meta');
    var p = ms[0].parentNode;
    var m = document.createElement('meta');
    //m.content = node.Name + ',' + node.Name;
    var scale = 1 / parseFloat(window.devicePixelRatio);
    m.name = 'viewport';
    m.content = "width=device-width,target-densitydpi=device-dpi,initial-scale=" + scale + ", minimum-scale=" + scale + ", maximum-scale=" + scale + ", user-scalable=no";
    p.appendChild(m);

    var nRatio = parseFloat(window.devicePixelRatio);
    var nSWidth = document.documentElement.clientWidth;
    var nSHeight = document.documentElement.clientHeight;

    //alert(nSWidth);

    //if (nSWidth < 1000) {
    //    nSWidth = 1000;
    //    nSHeight = 1000 * (nSHeight / nSWidth);
    //}
    Page.Element.Window = document.getElementById("WorkWindow");
    Page.Element.Desktop = document.getElementById("Desktop");
    Page.Element.ToolTask = document.getElementById("ToolTask");

    $(Page.Element.Window).css({ width: nSWidth, height: nSHeight });
    $(Page.Element.ToolTask).css({ width: 80 });
    $(Page.Element.Desktop).css({ width: nSWidth - 80 });

    $.Card.Init("CardPanel");

    //卡片管理模式
    //Card.ManageModeStart();

    Console.Enabled = true;
    //Console.Enabled = false;

    if (Console.Enabled) {
        var cDebug = $.Card.Add("Card_Debug", 0, 500);
        //Page.DatePicker.Load(cDebug.MainElement);
        //Console.Height = "100%";
        Console.Height = "";
        //Console.Width = document.documentElement.clientWidth - 100;
        Console.Width = "100%";
        Console.Load(cDebug.MainElement);
    }
}