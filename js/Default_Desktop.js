/// <reference path="jquery-1.10.2.min.js" />
/// <reference path="Controls/Console.js" />
/// <reference path="Default.js" />

///桌面相关函数
Page.Desktop = function () { }
Page.Desktop.BackgroudImage = null;

Page.Desktop.Init = function () {
    Console.Writeln("Loading the desktop :");
    //$("#Console").animate({ top: document.documentElement.clientHeight - 80, left: 50, width: document.documentElement.clientWidth - 305 }, 500, function () {
    //    setTimeout(Page.Desktop.LoadBg, 100);
    //});
    setTimeout(Page.Desktop.LoadBg, 100);
}

Page.Desktop.LoadBg = function () {
    Console.Write("Loading the desktop background ...");
    //$("#Desktop").css({ backgroundColor: "#eeeeee" });
    var img = document.createElement("img");
    img.src = Page.BackgroundSrc;
    img.height = document.documentElement.clientHeight;
    img.width = document.documentElement.clientWidth;
    $(img).css({ zIndex: -1, opacity: 0, position: "absolute", left: 0, top: 0 });
    //$("#Desktop")[0].appendChild(img);
    document.body.appendChild(img);
    Page.Desktop.BackgroudImage = img;
    $(img).animate({ opacity: 1 }, 1000, function () {
        Console.Writeln(" OK");
        Page.UI.Show();
        //setTimeout(Page.Loaded, 100);
        //$("#Window_Title").css({ opacity: 0, display: "" });
        //$("#Window_Title").animate({ opacity: 0.8 }, 500, function () {
        //    $("#Window").css({ opacity: 0, display: "" });
        //    $("#Window").animate({ opacity: 1 }, 500, function () {
        //        $("#Menu").css({ opacity: 0, display: "" });
        //        $("#Menu").animate({ opacity: 0.8 }, 500, function () {
        //            setTimeout(Page.Loaded, 100);
        //        });
        //    });
        //});
    });
}