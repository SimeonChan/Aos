/// <reference path="/js/jquery-1.10.2.min.js" />
/// <reference path="../../../../js/Controls/AjaxRequest.js" />

var Page = function () { }

Page.Add = function (path) {
    var szName = $("#txtName").val();
    var szType = $("#selType").val();

    $.post("Add.aspx", { path: path, name: szName, type: szType }, $.AjaxRequest.Execute);
}

Page.SendFile = function (sign) {
    var $ObjStatus = $("#Chat_Status");
    $ObjStatus.css({ color: "#000099" }).html("正在发送信息...");

    var szCnt = $("#UploadDialog_Path").val();
    if (szCnt == "") {
        $ObjStatus.css({ color: "#990000" }).html("未发现需要发送的文件!");
        return;
    }
    $.post("SaveFile.aspx", { sign: sign, content: szCnt }, function (result) {
        //$("#Chat_Status").css({ color: "#990000" }).html("发送失败,请稍后重试!");
        $("#Chat_Status").css({ color: "#009900" }).html("发送成功!");
        Page.AjaxRequest(result);
    }).error(function () {
        $("#Chat_Status").css({ color: "#990000" }).html("发送失败,请稍后重试!");
    });
}

Page.SendExpression = function (sign, id) {
    var $ObjStatus = $("#Chat_Status");
    $ObjStatus.css({ color: "#000099" }).html("正在发送信息...");
    //$.post("Save.aspx", { sign: sign, content: "<img src='/Files/System/Image/Expression/" + id + ".gif' alt='表情' title='表情' width='24' height='24' />" }, function (result) {
    if (id == "") {
        $ObjStatus.css({ color: "#990000" }).html("请不要发送空消息!");
        return;
    }

    $.post("SaveImage.aspx", { sign: sign, content: "/Files/System/Image/Expression/" + id + ".gif" }, function (result) {
        //$("#Chat_Status").css({ color: "#990000" }).html("发送失败,请稍后重试!");
        $("#Chat_Status").css({ color: "#009900" }).html("发送成功!");
        Page.AjaxRequest(result);
    }).error(function () {
        $("#Chat_Status").css({ color: "#990000" }).html("发送失败,请稍后重试!");
    });
}

Page.SaveChat = function (sign) {
    var $ObjStatus = $("#Chat_Status");
    $ObjStatus.css({ color: "#000099" }).html("正在发送信息...");

    var szCnt = $("#Chat_Content").val();
    if (szCnt == "") {
        $ObjStatus.css({ color: "#990000" }).html("请不要发送空消息!");
        return;
    }
    $.post("Save.aspx", { sign: sign, content: szCnt }, function (result) {
        //$("#Chat_Status").css({ color: "#990000" }).html("发送失败,请稍后重试!");
        $("#Chat_Status").css({ color: "#009900" }).html("发送成功!");
        $("#Chat_Content").val("");
        Page.AjaxRequest(result);
    }).error(function () {
        $("#Chat_Status").css({ color: "#990000" }).html("发送失败,请稍后重试!");
    });
}

Page.GetChat = function (sign) {
    $.post("Get.aspx", { sign: sign, content: $("#Chat_Content").val() }, function (result) {
        //$("#Chat_Status").css({ color: "#990000" }).html("发送失败,请稍后重试!");
        Page.AjaxRequest(result);
        setTimeout(function () { Page.GetChat(sign) }, 1000);
    }).error(function (result) {
        //$("#Chat_Status").css({ color: "#990000" }).html("发送失败,请稍后重试!");
        setTimeout(function () { Page.GetChat(sign) }, 1000);
    });
}

Page.ShowFileUpload = function () {
    $("#UploadDialog_Frame")[0].src = "/Upload.aspx";
    $("#UploadDialog_Info").html("");
    $("#UploadDialog_Path").val("");
    $(".Line-Center-D").css({ display: "" });
}

Page.CloseFileUpload = function () {
    $(".Line-Center-D").css({ display: "none" });
}

Page.ShowExpression = function () {
    $(".Line-Center-C").css({ display: "" });
}

Page.CloseExpression = function () {
    $(".Line-Center-C").css({ display: "none" });
}

Page.GetHistory = function (sign, pg) {
    $(".Line-Center-B").css({ display: "" });
    $(".Line-History").html("").load("History.aspx", { sign: sign, pg: pg });
}

Page.CloseHistory = function () {
    $(".Line-Center-B").css({ display: "none" });
}

Page.AjaxRequest = function (data) {

    var Obj = eval('(' + data + ')');

    var $chat = $(".Line-Chat");
    var bScroll = false;
    var nSTop = $chat.scrollTop();
    var nHeight = $chat.height();
    var nSHeight = $chat[0].scrollHeight;

    //alert(nSTop + "+" + nHeight + "=" + (nSTop + nHeight) + ":" + nSHeight - 10);

    if (nSTop + nHeight >= nSHeight - 15) {
        bScroll = true;
    }

    //设定ID对应的值
    //alert(Obj.Values.length);
    for (i = 0; i < Obj.Chats.length; i++) {

        var dt = document.createElement("dt");
        dt.innerHTML = Obj.Chats[i].Nick;

        var dd = document.createElement("dd");
        dd.innerHTML = Obj.Chats[i].Content;

        var dl = document.getElementById("Chat_List");
        dl.appendChild(dt);
        dl.appendChild(dd);

        if (bScroll) $chat.scrollTop($chat[0].scrollHeight);

    }

    //$("#Chat_Status").html(Obj.NewMessage.length);
    //设定新消息提示
    for (i = 0; i < Obj.NewMessage.length; i++) {
        //$("#Chat_Status").html(i + ":" + Obj.NewMessage[i].Name);
        var objTarget = document.getElementById(Obj.NewMessage[i].Name);

        if (objTarget) {
            $(objTarget).html(Obj.NewMessage[i].Count > 0 ? "[" + Obj.NewMessage[i].Count + "]" : "");
        } else if (Obj.NewMessage[i].Parent != "" && Obj.NewMessage[i].Count > 0) {
            var objParent = document.getElementById(Obj.NewMessage[i].Parent);
            var li = document.createElement("li");
            li.innerHTML = "<a href=\"Default.aspx?Type=4&ID=" + Obj.NewMessage[i].Name.replace("_", ":") + "\">临时访客[" + Obj.NewMessage[i].Name.substr(Obj.NewMessage[i].Name.length - 6) + "]</a><span id=\"" + Obj.NewMessage[i].Name + "\"></span>";
            objParent.appendChild(li);
        }
    }

    $.AjaxRequest.Execute(data);


}