/// <reference path="../jquery-1.10.2.min.js" />
/// <reference path="../jq-debug.js" />

/*
模拟控制台类
*/

var Console = function () { }

Console.Enabled = true;
Console.Element = null;
Console.Width = 500;
Console.Height = 500;
Console.Color = "#000";
Console.ParentElement = null;

Console.Load = function (parent) {
    var div = document.getElementById("div_Console");
    if (!div) {
        div = document.createElement("div");
        div.id = "div_Console";
        $(div).css({ fontSize: "14px", color: Console.Color, overflow: "auto" });

        //alert(parent);
        parent.appendChild(div);
    }
    $(div).css({ height: Console.Height, width: Console.Width });
    Console.Element = div;
    Console.ParentElement = parent;
}

Console.Write = function (data) {
    if (!Console.Enabled) return;
    //var div = document.getElementById("div_Console");
    $.Console.log(data);
    $(Console.Element).html($(Console.Element).html() + data);
    //$(div).html($(div).html() + data);
    //window.scrollTo(0, document.body.scrollHeight);
    Console.Element.scrollTop = Console.Element.scrollHeight;
    Console.ParentElement.scrollTop = Console.ParentElement.scrollHeight;
}

Console.Writeln = function (data) {
    if (!Console.Enabled) return;
    //var div = document.getElementById("div_Console");
    $.Console.log(data);
    $(Console.Element).html($(Console.Element).html() + data + "<br />");
    //$(div).html($(div).html() + data);
    //window.scrollTo(0, document.body.scrollHeight);
    Console.Element.scrollTop = Console.Element.scrollHeight;
    Console.ParentElement.scrollTop = Console.ParentElement.scrollHeight;
    //Console.Write(data + "<br>");
}

///设置动态加载标志
X.Page.Scripts["Page_Console"] = true;