/// <reference path="../jquery-1.10.2.min.js" />
/// <reference path="AjaxRequest.js" />
/// <reference path="Default.js" />
/// <reference path="Page.js" />

$.Process = function () { }

$.Process.Count = 0;
$.Process.Items = new Array();
$.Process.SelectedIndex = -1;

$.Process.ParentElement = null;
$.Process.TitleElement = null;
$.Process.MenuElement = null;

$.Process.Values = {};

///进程初始化
$.Process.Init = function (Id, TitleId, MenuId) {
    $.Process.ParentElement = document.getElementById(Id);
    $.Process.TitleElement = document.getElementById(TitleId);
    $.Process.MenuElement = document.getElementById(MenuId);
    $.Process.Count = 0;
}

///刷新显示
$.Process.Refresh = function () {

    var divHtml = "";

    for (var i = $.Process.Count - 1; i >= 0; i--) {
        var pid = "Process_" + i;
        var pDiv = document.createElement("div");
        pDiv.id = pid;

        var obj = $.Process.Items[i];

        if (obj.Id != "Home" && obj.Id != "DataManager") {
            var html = "";
            html += "<div";
            html += i == $.Process.SelectedIndex ? " class=\"page-menu-item-select\"" : " class=\"page-menu-item\"";
            if (i != $.Process.SelectedIndex) html += " onclick=\"$.Process.Show('" + obj.Id + "')\" onmousemove=\"$(this).css({ backgroundColor: '#888888', color: '#000099' });\" onmouseout=\"$(this).css({ backgroundColor: '', color: '' });\"";
            html += ">\n";
            html += "<img alt=\"\" width=\"24\" height=\"24\" src=\"" + obj.Path + "logo.png\" class=\"pub-left\">\n";
            html += "<div class=\"page-menu-text\">" + obj.Name + "</div>\n";
            html += "<div class=\"pub-clear\"></div>\n";
            html += "</div>\n";

            divHtml += html;
        }

    }

    $($.Process.MenuElement).html(divHtml);
}

$.Process.Show = function (Id) {
    for (var i = 0; i < $.Process.Count; i++) {
        //alert($.Process.Items[i].Id + ":" + Id);
        if ($.Process.Items[i].Id == Id) {
            $("#Win_" + $.Process.Items[$.Process.SelectedIndex].Id).css({ opacity: 0, display: "none" });
            var obj = $.Process.Items[i];
            $($.Process.TitleElement).html(obj.Name);
            $("#Win_" + obj.Id).css({ width: document.documentElement.clientWidth - 305, height: document.documentElement.clientHeight - 180, zIndex: $.Process.Count - 1, display: "" }).animate({ opacity: 1 }, 500);
            $.Process.SelectedIndex = i;
            $.Process.Refresh();
            return true;
        }
    }
    return false;
}

///激活已有线程
$.Process.Active = function (Id) {
    //alert($.Process.Count);
    //检测进程是否存在
    for (var i = 0; i < $.Process.Count; i++) {
        //alert($.Process.Items[i].Id + ":" + Id);
        if ($.Process.Items[i].Id == Id) {
            $("#Win_" + $.Process.Items[$.Process.SelectedIndex].Id).css({ opacity: 0, display: "none" });
            var obj = $.Process.Items[i];
            $($.Process.TitleElement).html(obj.Name);
            $("#Win_" + obj.Id).css({ width: document.documentElement.clientWidth - 305, height: document.documentElement.clientHeight - 180, zIndex: $.Process.Count - 1, display: "" }).animate({ opacity: 1 }, 500);
            for (var j = i; j < $.Process.Count - 1; j++) {
                $.Process.Items[j] = $.Process.Items[j + 1];
            }
            $.Process.Items[$.Process.Count - 1] = obj;
            $.Process.SelectedIndex = $.Process.Count - 1;
            $.Process.Refresh();
            return true;
        }
    }
    return false;
}

///添加一个进程
$.Process.Add = function (Id, Name, path, page, Arg) {
    var found = $.Process.Active(Id);

    //alert(found);

    if (!found) {

        if ($.Process.Count > 0) $("#Win_" + $.Process.Items[$.Process.SelectedIndex].Id).css({ opacity: 0, display: "none" });

        var myDate = new Date();
        var obj = { Id: Id, Name: Name, Page: page, Path: path, Arg: Arg, Time: myDate.getTime() };
        $.Process.Count++;
        $.Process.Items[$.Process.Count - 1] = obj;
        $.Process.SelectedIndex = $.Process.Count - 1;
        $.Process.Values["Win_" + Id] = "";

        var div = document.createElement("div");
        var $div = $(div);
        div.id = "Win_" + Id;
        $div.css({ position: "absolute", overflow: "auto", left: 5, top: 5, width: document.documentElement.clientWidth - 305, height: document.documentElement.clientHeight - 180, zIndex: $.Process.Count - 1 }).html("<div style=\"padding:10px 20px 10px 20px;\">正在加载....</div>");

        var html = "";
        html += "<div style=\"position: relative; overflow: hidden; width: 100%; height: 100%;\">";
        html += "<div id=\"Win_" + Id + "_Tool\" class=\"Process_Tool\" style=\"position: absolute; left: 0px; top:0px; z-index: 1; width: 100%; height: 36px; padding: 5px 0px 0px 5px; box-sizing: border-box; -moz-box-sizing: border-box; -webkit-box-sizing: border-box;\">";
        html += "</div>";
        html += "<div style=\"position: absolute; left: 0px; top:0px; z-index: 0; width: 100%; height: 100%; padding-top: 36px; box-sizing: border-box; -moz-box-sizing: border-box; -webkit-box-sizing: border-box;\">";
        //if (navigator.appName == "Microsoft Internet Explorer") {
        //    html += "<div id=\"Win_" + Id + "_Main\" style=\"position: relative; overflow: scroll; width: 100%; height: 100%;\">";
        //} else {
        //    html += "<div id=\"Win_" + Id + "_Main\" style=\"position: relative; overflow: auto; width: 100%; height: 100%;\">";
        //}
        html += "<div id=\"Win_" + Id + "_Main\" style=\"position: relative;overflow: hidden; width: 100%; height: 100%;\">";
        html += "<div style=\"padding:10px 20px 10px 20px;\">正在加载....</div>";
        html += "</div>";
        html += "</div>";
        html += "</div>";

        $div.html(html);

        $($.Process.TitleElement).html(Name);

        if ($.Process.ParentElement != null) {
            $.Process.ParentElement.appendChild(div);

            $.Debug("正在打开[" + Name + "]...");

            setTimeout(function () {
                Arg["Process_ID"] = Id;
                Arg["Process_ElementID"] = "Win_" + Id;

                Page.Ajax(path + page, Arg, true, function (responseText, status) {
                    //$("#Desktop_Main").html(responseText);
                    $.AjaxRequest.Execute(responseText);
                    $.Process.Refresh();
                });

                //$.post(Path + Page, Arg, function (data) {
                //    $.AjaxRequest.Execute(data);
                //    $.Process.Refresh();
                //});
            }, 100);
        }

    } else {

        setTimeout(function () {
            Arg["Process_ID"] = Id;
            Arg["Process_ElementID"] = "Win_" + Id;
            Page.Ajax(path + page, Arg, true, function (responseText, status) {
                //$("#Desktop_Main").html(responseText);
                $.AjaxRequest.Execute(responseText);
                $.Process.Refresh();
            });
        }, 100);

    }
}

///设置动态加载标志
X.Page.Scripts["Page_Process"] = true;
