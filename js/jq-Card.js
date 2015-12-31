/// <reference path="../jquery-1.10.2.min.js" />
/// <reference path="AjaxRequest.js" />
/// <reference path="Default.js" />
/// <reference path="Page.js" />

var Card = function () { }

///卡片数量
Card.Count = 0;

///卡片管理池
Card.Pool = new Array();

///卡片容器元素
Card.ParentElement = null;

///卡片容器结束元素
Card.CloseElement = null;

///开片宽度
Card.AllWidth = 0;

///管理卡片
Card.ManageCard = null;

///打开管理模式
Card.ManageModeStart = function () {
    Card.ManageCard = $.Card.Add("CardManager", 0, 300);
    Card.ManageCard.SetTitle("卡片信息查看器");
    Card.ManageInfoUpdate();
}

///更新卡片管理信息
Card.ManageInfoUpdate = function () {
    if (Card.ManageCard != null) {
        var html = "";
        html += "<div style=\"padding:5px;\">"
        html += "<div style=\"padding-bottom:5px;\"><a href=\"javascript:;\" onclick=\"Card.ManageInfoUpdate()\">刷新[卡片数量:" + Card.Count + "]</a></div>"
        for (var i = 0; i < Card.Count; i++) {
            html += "<div style=\"padding-bottom:5px;\">[" + i + "]:" + JSON.stringify(Card.Pool[i]) + "</div>"
        }
        html += "</div>";
        Card.ManageCard.MainElement.innerHTML = html;
    }
}

///卡片统一操作入口
$.Card = function () { }

///卡片管理初始化
$.Card.Init = function (parentID) {
    Card.ParentElement = document.getElementById(parentID);
    Card.CloseElement = document.getElementById(parentID + "_Clear");
}

///新建一个卡片
$.Card.Add = function (ID, Index, Width, r) {
    var cd = new CardClass(ID, Index, Width);
    if (r) {
        $(cd.Element).css({ width: 0 }).animate({ width: Width }, 500, r);
    } else {
        $(cd.Element).css({ width: 0 }).animate({ width: Width }, 500);
    }
    return cd;
}

///新建一个卡片并使用Url进行内容填充
$.Card.AddWithUrl = function (ID, Index, Width, Url, Args) {
    var cd = new CardClass(ID, Index, Width);
    $(cd.Element).css({ width: 0 }).animate({ width: Width }, 500, function () {
        cd.LoadFromUrl(Url, Args);
    });
    return cd;
}

///根据ID获取管理池索引
$.Card.GetIndex = function (ID) {
    for (var i = 0; i < Card.Count; i++) {
        if (Card.Pool[i].ID == ID) return i;
    }
    return -1;
}

///根据索引号来移除一个卡片
$.Card.RemoveAt = function (index, r) {
    if (index >= 0 && index < Card.Count) {
        var szId = Card.Pool[index].ID;
        var div = document.getElementById(szId);
        $(div).animate({ width: 0 }, 500, function () {
            div.parentNode.removeChild(div);
            Card.AllWidth -= Card.Pool[nIndex].Width;
            for (var i = index; i < Card.Count - 1; i++) {
                Card.Pool[i].ID = Card.Pool[i + 1].ID
                Card.Pool[i].Width = Card.Pool[i + 1].Width
            }
            Card.Count--;
            Card.ManageInfoUpdate();
            if (r) r();
        });
    }
}

///移除一个卡片
$.Card.Remove = function (Id, r) {
    var nIndex = $.Card.GetIndex(Id);
    $.Card.RemoveAt(nIndex, r);
}

function CardClass(Id, Index, Width) {

    ///获取卡片元素
    CardClass.prototype.Element = null;

    ///获取卡片主体元素
    CardClass.prototype.MainElement = null;

    ///获取卡片主体元素
    CardClass.prototype.TitleElement = null;

    ///获取卡片工具栏元素
    CardClass.prototype.ToolElement = null;

    ///获取卡片识标符
    CardClass.prototype.ID = "";

    var div = document.getElementById(Id);
    this.ID = Id;

    if (!div) {

        div = document.createElement("div");
        var $div = $(div);
        div.id = Id;
        //$div.css("position", "absolute").css("left", 100).css("top", 100);
        div.className = "card";
        $div.css({ width: Width });
        Card.AllWidth += parseInt(Width) + 3;
        $(Card.ParentElement).css({ width: Card.AllWidth });
        //alert(Card.AllWidth);

        var newHTML = "";
        var borderColor = "#0f5599";
        var headColor = "#0094ff";
        var shadowColor = "#0094ff";
        var opacity = 0.4;
        var opacity_Title = 0.92;
        newHTML += "<div id=\"" + Id + "_form\" class=\"card-form\">";
        newHTML += "<div id=\"" + Id + "_head\" class=\"card-head\">";
        newHTML += "<div class=\"card-ico\">";
        newHTML += "<img id=\"" + Id + "_ico\" alt=\"\" title=\"\" src=\"/images/Icon/Azs.png\" width=\"30\" />";
        newHTML += "</div>";
        newHTML += "<div id=\"" + Id + "_title\" class=\"card-title\">测试输出</div>";
        newHTML += "<div id=\"" + Id + "_close\" class=\"card-close\"><a href=\"javascript:;\" onclick=\"$.Card.Remove('" + Id + "');\">X</a></div>";
        newHTML += "<div style=\"clear:both;\"></div>";
        newHTML += "<div id=\"" + Id + "_tool\" class=\"card-tool\"></div>";
        newHTML += "</div>";
        newHTML += "<div id=\"" + Id + "_body\" class=\"card-body\">";
        newHTML += "<div id=\"" + Id + "_main\" class=\"card-main\">";
        newHTML += "</div>";
        newHTML += "</div>";
        newHTML += "</div>";

        $div.html(newHTML);

        InsertBefore(Index, div, Width);

        //alert(this.MainElement);

        //$div.animate({ width: Width }, 500);
    } else {

    }

    this.Element = div;
    this.MainElement = document.getElementById(Id + "_main");
    this.TitleElement = document.getElementById(Id + "_title");
    this.ToolElement = document.getElementById(Id + "_tool");

    ///从URL地址中加载内容
    CardClass.prototype.SetTitle = function (title) {
        $(this.TitleElement).html(title);
    }

    ///从URL地址中加载内容
    CardClass.prototype.LoadFromUrl = function (url, arg) {
        if (!arg) arg = {};
        arg["Process_ID"] = this.ID;

        //$(this.MainElement).load(url, arg);

        Page.Ajax(url, arg, {}, false, function (responseText, status) {
            $(this.MainElement).html(responseText);
        });
    }

    //指定位置插入元素
    function InsertBefore(Index, div, width) {

        if (Index < Card.Count) {
            var eDiv = document.getElementById(Card.Pool[Index].ID);
            eDiv.parentNode.insertBefore(div, eDiv);

            for (var i = Card.Count; i > Index; i--) {
                if (Card.Pool[i]) {
                    Card.Pool[i].ID = Card.Pool[i - 1].ID;
                    Card.Pool[i].Width = Card.Pool[i - 1].Width;
                } else {
                    Card.Pool[i] = {};
                    Card.Pool[i]["ID"] = Card.Pool[i - 1].ID;
                    Card.Pool[i]["Width"] = Card.Pool[i - 1].Width;
                }
            }

            Card.Pool[Index].ID = div.id;
            Card.Pool[Index].Width = width;
        } else {
            Card.CloseElement.parentNode.insertBefore(div, Card.CloseElement);
            //Card.ParentElement.appendChild(div);
            Card.Pool[Index] = {};
            Card.Pool[Index]["ID"] = div.id;
            Card.Pool[Index]["Width"] = width;
        }

        Card.Count++;
        Card.ManageInfoUpdate();
    }

}