/// <reference path="../jquery-1.10.2.min.js" />
/// <reference path="AjaxRequest.js" />
/// <reference path="Default.js" />

$.Dialog = function () { }
$.Dialog.Top = 0;
$.Dialog.zIndex = 100;

$.Dialog.ActiveForm = "";
$.Dialog.ActivePoint = function () { }
$.Dialog.ActivePoint.X = 0;
$.Dialog.ActivePoint.Y = 0;
$.Dialog.ActivePoint.Left = 0;
$.Dialog.ActivePoint.Top = 0;
$.Dialog.MousePoint = function () { }
$.Dialog.MousePoint.X = 0;
$.Dialog.MousePoint.Y = 0;

$.Dialog.Parent = null;

$.Dialog.MoveInit = function (id) {
    $.Dialog.ActivePoint.X = $.Dialog.MousePoint.X;
    $.Dialog.ActivePoint.Y = $.Dialog.MousePoint.Y;
    $.Dialog.ActiveForm = "Dialog_" + id;

    var div = document.getElementById($.Dialog.ActiveForm);
    $.Dialog.ActivePoint.Left = $(div).position().left;
    $.Dialog.ActivePoint.Top = $(div).position().top;
}

$(document).ready(function () {
    $(document).mousemove(function (e) {
        //alert("$.Dialog is ready!")
        $.Dialog.MousePoint.X = e.pageX;
        $.Dialog.MousePoint.Y = e.pageY;
        if ($.Dialog.ActiveForm != "") {
            var div = document.getElementById($.Dialog.ActiveForm);
            $(div).css({ left: $.Dialog.ActivePoint.Left + $.Dialog.MousePoint.X - $.Dialog.ActivePoint.X, top: $.Dialog.ActivePoint.Top + $.Dialog.MousePoint.Y - $.Dialog.ActivePoint.Y });
            $.Console.log("Pos:(" + $.Dialog.ActivePoint.Left + "," + $.Dialog.ActivePoint.Top + "),MousePos:(" + $.Dialog.ActivePoint.X + "," + $.Dialog.ActivePoint.Y + "),MouseMove:(" + $.Dialog.MousePoint.X + "," + $.Dialog.MousePoint.Y + ")");
        }
    });
    $(document).mouseup(function () {
        $.Dialog.ActiveForm = "";
    });
})

///创建一个对话框,
function DialogClass(Id, top, w, h, z) {

    DialogClass.prototype.Element = null;
    DialogClass.prototype.HeadElement = null;
    DialogClass.prototype.TitleElement = null;
    DialogClass.prototype.ContentElement = null;
    DialogClass.prototype.RectElement = null;
    DialogClass.prototype.zIndex = 0;
    DialogClass.prototype.ID = "";
    DialogClass.prototype.TopInsider = 0;

    var divId = "Dialog_" + Id;
    var div = document.getElementById(divId);

    if (!div) {
        div = document.createElement("div");
        div.id = divId;
        div.style.position = "absolute";
        div.style.zIndex = z;

        var html = "";
        html += "<div id=\"" + divId + "_Rect\"  style=\"position: relative; width: " + (w + 10) + "px; height: " + (h + top + 30) + "px;\">\n";
        html += "  <div  id=\"" + divId + "_Body\"  style=\"position: absolute; left: 0px; top: 0px; width: " + (w + 10) + "px; height: " + (h + top + 30) + "px; background: #000; filter: alpha(opacity=80); -moz-opacity: 0.8; opacity: 0.8;overflow:auto;\"></div>\n";
        html += "  <div id=\"" + divId + "_Head\" onmousedown=\"$.Dialog.MoveInit('" + Id + "');\" style=\"position: absolute; left: 5px; top: " + top + "px; color: #fff;width:" + w + "px;cursor:move;\">\n";
        html += "  <div id=\"" + divId + "_Title\" style=\"float:left;\"></div>\n";
        html += "  <div id=\"" + divId + "_Close\" style=\"float:right;width:20px;height:20px;text-align:center;cursor: pointer;padding:0px;vertical-align:middle;\" onmousemove=\"this.style.backgroundColor='#990000';\" onmouseout=\"this.style.backgroundColor='';\" onclick=\"$.Dialog.Close('" + Id + "');\">×</div>\n";
        html += "  </div>\n";
        html += "  <div id=\"" + divId + "_Content\" style=\"position: absolute; left: 5px; top: " + (top + 25) + "px; color: #000; background: #fff; width: " + w + "px; height: " + h + "px;overflow: auto;\">\n";
        html += "  </div>\n";
        html += "</div>\n";

        div.innerHTML = html;

        //document.body.appendChild(div);
        if ($.Dialog.Parent != null) {
            $.Dialog.Parent.appendChild(div);
        } else {
            document.body.appendChild(div);
        }
        //document.getElementById("Main").appendChild(div);
    }

    this.Element = div;
    this.HeadElement = document.getElementById(divId + "_Head");
    this.TitleElement = document.getElementById(divId + "_Title");
    this.ContentElement = document.getElementById(divId + "_Content");
    this.BodyElement = document.getElementById(divId + "_Body");
    this.RectElement = document.getElementById(divId + "_Rect");
    this.zIndex = z;
    this.ID = divId;
    this.TopInsider = top;

    DialogClass.prototype.SetZIndex = function (z) {
        this.Element.style.zIndex = z;
        this.zIndex = z;
    }

    DialogClass.prototype.SetSize = function (w, h) {
        $(this.RectElement).css({ width: w + 10, height: h + top + 30 });
        $(this.ContentElement).css({ width: w, height: h });
        //$(this.TitleElement).css({ width: w });
        $(this.HeadElement).css({ width: w });
        w = parseInt(w) + 10;
        h = parseInt(h) + this.TopInsider + 30;
        $(this.BodyElement).css({ width: w, height: h });
    }

    DialogClass.prototype.SetWidth = function (w) {
        $(this.ContentElement).css({ width: w });
        //$(this.TitleElement).css({ width: w });
        $(this.HeadElement).css({ width: w });
        w = parseInt(w) + 10;
        $(this.BodyElement).css({ width: w });
    }

    DialogClass.prototype.SetHeight = function (h) {
        $(this.ContentElement).css({ height: h });
        h = parseInt(h) + this.TopInsider + 30;
        $(this.BodyElement).css({ height: h });
    }

    ///设置窗体位置
    DialogClass.prototype.SetLocation = function (top, left) {
        $(this.Element).css({ top: top, left: left });
    }

    ///设置窗体左边距位置
    DialogClass.prototype.SetLeft = function (left) {
        $(this.Element).css({ left: left });
    }

    ///设置窗体上边距位置
    DialogClass.prototype.SetTop = function (top) {
        $(this.Element).css({ top: top });
    }
}

$.Dialog.Form = function () { };

//表单数据
$.Dialog.Form.Data = {};

//表单数据清空
$.Dialog.Form.DataClear = function () {
    $.Dialog.Form.Data = {};
}

//表单数据设置
$.Dialog.Form.DataSet = function (name, value) {
    $.Dialog.Form.Data[name] = value;
}

//通过绑定数据设置表单数据
$.Dialog.Form.DataSetByValue = function (name, id) {
    $.Dialog.Form.Data[name] = $("#" + id).val();
}

$.Dialog.Form.Submit = function (id, url) {

    var arg = $.Dialog.Form.Data;
    arg = Page.UI.UpdateArgs(id, arg);

    Page.Ajax(url, arg, false, function (responseText, textStatus) {
        $.AjaxRequest.Execute(responseText);
    });
    //$.post(url, arg, function (data) {
    //    //alert(data);
    //    $.AjaxRequest.Execute(data);
    //});
}

$.Dialog.Close = function (Id) {
    var divId = "Dialog_" + Id;
    var div = document.getElementById(divId);
    if (div) {
        $(div).animate({ opacity: 0 }, 500, function () {
            //document.body.removeChild(div);
            if ($.Dialog.Parent != null) {
                $.Dialog.Parent.removeChild(div);
            } else {
                document.body.removeChild(div);
            }
            //document.getElementById("Main").removeChild(div);
        });
    }
}

///显示一个对话框对象
$.Dialog.Show = function (Id, title, w, h) {
    var obj = new DialogClass(Id, 5, w, h, 0);
    obj.SetZIndex($.Dialog.zIndex);
    $(obj.Element).css({ left: (document.documentElement.clientWidth - w - 10) / 2, top: 100 + ((800 - h) / 10) });
    //alert(obj.TitleElement.outerHTML);
    $(obj.TitleElement).html(title);
    return obj;
}

///显示一个对话框,并以HTML内容填充
$.Dialog.ShowWithHtml = function (Id, title, w, h, html) {
    var obj = $.Dialog.Show(Id, title, w, h);
    $(obj.ContentElement).html(html);
}

///显示一个消息对话框
$.Dialog.ShowMessage = function (title, cnt) {
    var obj = $.Dialog.Show("Message", title, 360, 100);

    var html = "";
    html += "<div style=\"padding: 10px 10px 0px 10px; height: 57px; word-break: break-all;\">\n";
    html += cnt;
    html += "</div>\n";
    html += "<div style=\"float : right; padding: 5px 10px 0px 0px;\">\n";
    html += "  <input id=\"Message_OK\" type=\"button\" value=\"确定\"  style=\"padding-top: 2px; width: 60px; height: 22px\" onclick=\"$.Dialog.Close('Message');\"/>\n";
    html += "</div>\n";
    html += "<div style=\"clear:both;\"></div>\n";

    $(obj.ContentElement).html(html);

    $(obj.Element).css({ opacity: 0 }).animate({ opacity: 1 }, 500);
}

///显示一个对话框,并从网络加载内容
$.Dialog.ShowFromUrl = function (Id, title, w, h, url, arg) {
    var obj = $.Dialog.Show(Id, title, w, h);

    $(obj.ContentElement).html("<div style=\"padding:10px 20px 10px 20px;\">正在加载....</div>");

    $(obj.Element).css({ opacity: 0 }).animate({ opacity: 1 }, 200, function () {
        arg["Dialog_ElementID"] = obj.ID;
        arg["Dialog_ID"] = Id;
        $(obj.ContentElement).load(url, arg);
    });
}

///设置动态加载标志
X.Page.Scripts["Page_Dialog"] = true;