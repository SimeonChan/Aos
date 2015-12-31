/// <reference path="jquery-1.10.2.min.js" />

/*
jq下的对话框类;
*/

///jq对话框
$.MessageBox = function () { } //new MessageBoxClass("jq-messagebox");

$.MessageBox.Element = null;

$.MessageBox.Show = function (text, caption) {
    var f = new MessageBoxClass("jq-messagebox");
    $.MessageBox.Element = f.Element;
    $(f.Element).css("width", 330);
    f.Show();

    var title = f.getTitleElement();
    $(title).html(caption);

    var newHTML = "";
    newHTML += "<div style=\"padding: 10px 5px 5px 10px;\">";
    newHTML += text;
    newHTML += "</div>";
    newHTML += "<div style=\"padding:5px 10px 10px 5px;\">";
    newHTML += "<div style=\"float:right;padding:3px 3px 3px 3px;border: 1px solid #0f5599;background-color:#0094ff;cursor: pointer;width:50px;text-align:center;\" onclick=\"var f = new MessageBoxClass('jq-messagebox');f.Close();\">";
    newHTML += "确定";
    newHTML += "</div>";
    newHTML += "<div style=\"clear: both;\"></div>";
    newHTML += "</div>";

    $(f.getContentElement()).html(newHTML);
}

$.MessageBox.Close = function () {
    var f = new MessageBoxClass("jq-messagebox");
    f.Close();
    $.MessageBox.Element = null;
}

$.Window = function () { }

//打开一个新的窗口
$.Window.Open = function (id, title, width, url, args) {
    var f = new MessageBoxClass(id);
    $(f.Element).css({ width: width + 10, left: (document.documentElement.clientWidth - width - 10) / 2 });
    f.Show();

    var newHTML = "";
    newHTML += "<div style=\"padding: 10px 5px 10px 10px;\">";
    newHTML += "正在加载，请稍后...";
    newHTML += "</div>";
    var cnt = f.getContentElement();
    $(cnt).html(newHTML);

    setTimeout(function () {
        var etitle = f.getTitleElement();
        $(etitle).html(title);

        var cnt = f.getContentElement();
        $(cnt).load(url, args);
    }, 10);

}

function MessageBoxClass(ID) {

    var div = document.getElementById(ID);

    if (!div) {

        div = document.createElement("div");
        var $div = $(div);
        div.id = ID;
        $div.css("position", "absolute").css("left", 100).css("top", 100);

        var newHTML = "";
        var borderColor = "#0f5599";
        var headColor = "#0094ff";
        var shadowColor = "#0094ff";
        var opacity = 0.4;
        var opacity_Title = 0.92;
        newHTML += "<table width='100%' border='0' align='left' cellpadding='0' cellspacing='0' style='border-collapse: collapse;'>";
        newHTML += "<tr>";
        newHTML += "<td style='width: 3px; height: 3px; filter: alpha(opacity=" + (opacity * 100) + "); opacity: " + opacity + "; background-color: " + shadowColor + "; overflow: hidden;'></td>";
        newHTML += "<td style='filter: alpha(opacity=" + (opacity * 100) + "); opacity: " + opacity + "; background-color: " + shadowColor + "; overflow: hidden;'></td>";
        newHTML += "<td style='width: 3px; filter: alpha(opacity=" + (opacity * 100) + "); opacity: " + opacity + "; background-color: " + shadowColor + "; overflow: hidden;'></td>";
        newHTML += "</tr>";
        newHTML += "<tr>";
        newHTML += "<td style='filter: alpha(opacity=" + (opacity * 100) + "); opacity: " + opacity + "; background-color: " + shadowColor + ";'></td>";
        newHTML += "<td align='left' valign='top' style=' border-left-width: 1px; border-right-width: 1px; border-top-width: 1px; border-bottom-width:0px; border-color: " + borderColor + "; border-style: solid;'>";
        newHTML += "<table width='100%' border='0' cellspacing='0' cellpadding='5' >";
        newHTML += "<tr>";
        newHTML += "<td align='left' valign='bottom' id='" + ID + "_Title' style='background-color: " + headColor + ";color: #222; font-size: 12px; font-weight: bold; filter: alpha(opacity=" + (opacity_Title * 100) + "); opacity: " + opacity_Title + ";'>&nbsp;</td>";
        newHTML += "<td width='60' align='right' valign='bottom' id='" + ID + "_Close'style='background-color: " + headColor + "; filter: alpha(opacity=" + (opacity_Title * 100) + "); opacity: " + opacity_Title + ";'><span onmouseover=\"this.style.color='" + borderColor + "'\" onmouseout=\"this.style.color='#FFF'\" onclick=\"var f = new MessageBoxClass('" + ID + "');f.Close();\" style='cursor:pointer;font-size: 12px; color:#FFF;'>[关闭]</span></td>";
        newHTML += "</tr>";
        newHTML += "</table>";
        newHTML += "</td>";
        newHTML += "<td style='filter: alpha(opacity=" + (opacity * 100) + "); opacity: " + opacity + "; background-color: " + shadowColor + ";'></td>";
        newHTML += "</tr>";
        newHTML += "<tr>";
        newHTML += "<td style='filter: alpha(opacity=" + (opacity * 100) + "); opacity: " + opacity + "; background-color: " + shadowColor + ";'></td>";
        newHTML += "<td align='left' id='" + ID + "_Content' style='background-color: #FFF; border-top-width:0px; border-left-width: 1px; border-right-width: 1px; border-bottom-width: 1px; border-color: " + borderColor + "; border-style: solid; font-size: 12px;'>&nbsp;</td>";
        newHTML += "<td style='filter: alpha(opacity=" + (opacity * 100) + "); opacity: " + opacity + "; background-color: " + shadowColor + ";'></td>";
        newHTML += "</tr>";
        newHTML += "<tr>";
        newHTML += "<td style='height: 3px; filter: alpha(opacity=" + (opacity * 100) + "); opacity: " + opacity + "; background-color: " + shadowColor + ";'></td>";
        newHTML += "<td style='filter: alpha(opacity=" + (opacity * 100) + "); opacity: " + opacity + "; background-color: " + shadowColor + ";'></td>";
        newHTML += "<td style='filter: alpha(opacity=" + (opacity * 100) + "); opacity: " + opacity + "; background-color: " + shadowColor + ";'></td>";
        newHTML += "</tr>";
        newHTML += "</table>";

        $div.html(newHTML);

    }

    MessageBoxClass.prototype.getTitleElement = function () {
        return document.getElementById(ID + "_Title");
    }

    MessageBoxClass.prototype.getContentElement = function () {
        return document.getElementById(ID + "_Content");
    }

    MessageBoxClass.prototype.Element = div;

    MessageBoxClass.prototype.Show = function () {
        if (document.getElementById(ID)) {
            $(div).css({ display: "" });
        } else {
            document.body.appendChild(div);
        }
    }

    MessageBoxClass.prototype.Close = function () {
        document.body.removeChild(div);
    }
}