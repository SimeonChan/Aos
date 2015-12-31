/// <reference path="../jquery-1.10.2.min.js" />

/*
Tip
*/

var Tip = function () { }

Tip.Element = null;

Tip.Load = function () {
    var div = document.getElementById("div_Tip");
    if (!div) {
        div = document.createElement("div");
        div.id = "div_Tip";
        $(div).css({ fontSize: "12px", color: "#fff", position: "absolute", left: 0, top: 0, display: "none", opacity: 0.8, border: "1px solid #222222", background: "#888888", padding: "3px" });
        document.body.appendChild(div);
    }
    Tip.Element = div;

    //Taskbar.LoadMenu();
}

Tip.Show = function (x, y, cnt) {
    var div = document.getElementById("div_Tip");
    //alert(cnt);
    if (div) {
        $(div).css({ left: x, top: y, display: "" }).html(cnt);
    }
}

Tip.Hide = function () {
    var div = document.getElementById("div_Tip");
    if (div) {
        $(div).css({ display: "none" });
    }
}

///设置动态加载标志
X.Page.Scripts["Page_Tip"] = true;