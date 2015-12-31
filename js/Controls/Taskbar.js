/// <reference path="../jquery-1.10.2.min.js" />
/// <reference path="Tip.js" />

/*
模拟控制台类
*/

var Taskbar = function () { }

Taskbar.Element = null;

Taskbar.Load = function (parent) {
    var div = document.getElementById("div_Taskbar");
    if (!div) {
        div = document.createElement("div");
        div.id = "div_Taskbar";
        $(div).css({ fontSize: "12px", color: "#fff", overflow: "hidden", position: "absolute", left: -200, top: 0, backgroundRepeat: "repeat-x", opacity: 0 });
        parent.appendChild(div);
    }
    // $(div).css({ height: 58, width: document.documentElement.clientWidth });
    Taskbar.Element = div;

    Taskbar.LoadMenu();
}

Taskbar.ObjectsJson = null;
Taskbar.SelectedID = -1;

Taskbar.LoadMenu = function () {
    var div = Taskbar.Element;

    //var menuStr = "{Array:[{text:\"系统设置\",cmd:\"001\",name:\"Com_Setting\"},{text:\"应用程序\",cmd:\"002\",name:\"Com_Application\"},{text:\"云文件存储\",cmd:\"003\",name:\"Com_File\"},{text:\"网址书签\",cmd:\"004\",name:\"Com_Link\"}]}"
    //var menuObj = eval('(' + menuStr + ')');

    if (Taskbar.ObjectsJson == null) {
        alert("加载应用列表失败，请稍后重试!");
        return;
    }

    var menuObj = eval('(' + Taskbar.ObjectsJson + ')');

    for (i = 0; i < menuObj.Array.length; i++) {
        var pid = "Taskbar_Menu_" + i;
        var pDiv = document.createElement("div");
        pDiv.id = pid;
        div.appendChild(pDiv);

        $("#" + pid).css({ marginTop: "5px", cursor: "default", width: 190, padding: 5 })
            .hover(function () {
                var pName = $("#" + this.id + "_image")[0].name;
                if (pName == Taskbar.SelectedID) return;
                $("#" + this.id).css({ backgroundColor: "#888888", color: "#000099" });
                //this.bgColor = "#FFFFFF";
            }, function () {
                //Tip.Hide();
                var pName = $("#" + this.id + "_image")[0].name;
                if (pName == Taskbar.SelectedID) return;
                $("#" + this.id).css({ backgroundColor: "", color: "" });
                //this.src = "/Files/App/" + menuObj.Array[this.name].name + "/logo.png";
            }).click(function () {
                var pName = $("#" + this.id + "_image")[0].name;
                if (pName == Taskbar.SelectedID) return;
                $("#Taskbar_Menu_" + Taskbar.SelectedID).css({ backgroundColor: "", color: "" });
                $("#" + this.id).css({ backgroundColor: "#DDDDDD", color: "#000099" });
                Taskbar.SelectedID = pName;
                Page.Navigate(menuObj.Array[pName].url);
            }).mousemove(function (e) {
                //alert(e.pageX);
                //Tip.Show(e.pageX + 16, e.pageY + 16, menuObj.Array[this.name].text);
                this.bgColor = "#FFFFFF";
            });

        var menuDiv = document.createElement("img");
        menuDiv.id = pid + "_image";
        menuDiv.width = 24;
        menuDiv.height = 24;
        menuDiv.src = menuObj.Array[i].logo;
        menuDiv.name = i;
        pDiv.appendChild(menuDiv);

        $("#" + pid + "_image").css({ float: "left" });

        var tDiv = document.createElement("div");
        tDiv.id = pid + "_text";

        pDiv.appendChild(tDiv);

        $("#" + pid + "_text").css({ float: "left", paddingLeft: 5, paddingTop: 2 }).html(menuObj.Array[i].text);

        var cDiv = document.createElement("div");
        cDiv.id = pid + "_clear";

        pDiv.appendChild(cDiv);

        $("#" + pid + "_clear").css({ clear: "both" });
        //var sLogo =
        //var sLogoOver = "/Files/App/" + menuObj.Array[i].name + "/logo_over.png";

    }

    var menuClear = document.createElement("div");
    $(menuClear).css({ clear: "both" });
    div.appendChild(menuClear);

    $(div).animate({ left: 0, opacity: 0.8 }, 500);
}

///设置动态加载标志
X.Page.Scripts["Page_Taskbar"] = true;