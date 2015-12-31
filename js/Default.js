/// <reference path="jquery-1.10.2.min.js" />
/// <reference path="../XKits/X.Ajax.js" />
/// <reference path="Class.js" />
/// <reference path="Controls/Console.js" />
/// <reference path="Default_Desktop.js" />
/// <reference path="Default_Init.js" />
/// <reference path="Controls/Tip.js" />
/// <reference path="Controls/Taskbar.js" />
/// <reference path="jq-Dialog.js" />
/// <reference path="Controls/AjaxRequest.js" />
/// <reference path="Controls/DatePicker.js" />
/// <reference path="Page.js" />
/// <reference path="jq-Card.js" />

//是否已经获取了交互识标
X.Custom.Variables["Session"] = false;

///获取验证码
X.Custom.getCode = function () {

    if (!X.Custom.Variables.Session) {
        //X.Custom.changeCode();

        Page.Ajax("/Ajax/Status/Session.aspx", {}, false, function (responseText, status) {

            $.AjaxRequest.Execute(responseText);

            //var szSessionID = Page.Storage.Get("Azalea_SessionID");
            //var szUrl = "/VerificationCode.aspx?id=login&Azalea_SessionID=" + szSessionID + "&rnd=" + Math.random();
            var szHtml = "<img id=\"VerificationCodeImg\" alt=\"\" src=\"\" onclick=\"X.Custom.changeCode();\" style=\"cursor: pointer;\" /><div><a href=\"javascript:;\" onclick=\"X.Custom.changeCode();\">看不清楚,换一张</a></div>";
            $("#td_Login_Code").html(szHtml);

            X.Custom.Variables.Session = true;

            X.Custom.changeCode();

        });

    }

}



///更改验证码
X.Custom.changeCode = function () {
    var szSessionID = Page.Storage.Get("Azalea_SessionID");
    var szAuthID = Page.Storage.Get("Azalea_AuthID");
    var szUrl = "/VerificationCode.aspx?id=login&Azalea_SessionID=" + szSessionID + "&Azalea_AuthID=" + szAuthID + "&rnd=" + Math.random();

    X.Page.loadImage(szUrl, function () {
        var obj = document.getElementById("VerificationCodeImg")
        if (obj) obj.src = szUrl;
    });

}

function alert(str) {
    if (X.Client.Enabled) {
        X.Client.MsgBox(str);
    } else {
        $.Dialog.ShowMessage("系统提示", str);
    }
}

$.Debug = function (data) {
    Console.Write(data);
}

///重新设置界面布局
Page.ResetLocation = function () {

    Page.UI.ResetLocation();

}

///显示上传对话框
Page.ShowUpload = function (Id) {
    if (X.Client.Enabled) {
        var arg = {};
        arg["id"] = Id;
        var szJson = JSON.stringify(Page.UpdateArgs(arg));
        //alert(szJson);
        X.Client.Upload("ClientRequest", szJson);
    } else {
        Page.UploadID = Id;
        $("#UploadDialog").css({ opacity: 0, display: "", left: (document.documentElement.clientWidth - 360) / 2, zIndex: 10000 }).animate({ opacity: 1 }, 300);
        var arg = Page.UpdateArgs({});
        document.getElementById("UploadDialog_Frame").src = "/Upload.aspx?Azalea_SessionID=" + arg.Azalea_SessionID + "&Azalea_AuthID=" + arg.Azalea_AuthID;
    }
}

//HTML编辑器绑定对象
Page.UEditorID = "";

///显示上传对话框
Page.ShowUEditor = function (Id) {
    Page.UEditorID = Id;
    //document.getElementById("UploadDialog_Frame").
    if (Page.UEditorID != "") {
        var cnt = $("#" + Page.UEditorID).val();
        UE.getEditor('editor').setContent(cnt, false);
    }

    $("#UEditorDialog").css({ display: "" });
    //$("#UploadDialog").css({ opacity: 0, display: "", left: (document.documentElement.clientWidth - 360) / 2, zIndex: 10000 }).animate({ opacity: 1 }, 300);
    //var arg = Page.UpdateArgs({});
    //document.getElementById("UploadDialog_Frame").src = "/Upload.aspx?Azalea_SessionID=" + arg.Azalea_SessionID + "&Azalea_AuthID=" + arg.Azalea_AuthID;
}

///显示上传对话框
Page.CloseUEditor = function () {
    //Page.UEditorID = "";
    //document.getElementById("UploadDialog_Frame").
    if (Page.UEditorID != "") {
        var cnt = UE.getEditor('editor').getContent();
        //alert(cnt);
        $("#" + Page.UEditorID).val(cnt);
        //alert(window.frames("UploadDialog_Frame").getContent());
    }
    $("#UEditorDialog").css({ display: "none" });
}

//客户端返回
function ClientRequest(postArg, requestArg) {
    //alert(postArg);
    $.Console.log("ClientResult");
    $.Console.log("Post:" + postArg);
    $.Console.log("Request:" + requestArg);

    var ObjPost = eval('(' + postArg + ')');
    var Obj = eval('(' + requestArg + ')');
    var sPath = Obj.File.Path;

    alert(sPath);

    if (sPath == "") {
        $("#UploadDialog_Info").html("<font color='#990000'>请先上传一个文件!</font>");
        return 0;
    }
    $("#" + ObjPost.id).val(sPath);
    $("#" + ObjPost.id + "_Div").html(sPath);
    $("#" + ObjPost.id + "_Img").attr("src", sPath);
}

///确认上传文件
Page.SubmitUpload = function () {
    var sPath = $("#UploadDialog_Path").val();
    if (sPath == "") {
        $("#UploadDialog_Info").html("<font color='#990000'>请先上传一个文件!</font>");
        return 0;
    }
    $("#" + Page.UploadID).val(sPath);
    $("#" + Page.UploadID + "_Div").html(sPath);
    $("#" + Page.UploadID + "_Img").attr("src", sPath);
    $("#UploadDialog").animate({ opacity: 0 }, 500, function () {
        $("#UploadDialog").css({ display: "none" });
    });
}

Page.Logout = function () {
    Page.Ajax("/Ajax/User/Logout.aspx", {}, false, function (responseText, status) {
        $.AjaxRequest.Execute(responseText);
    });
    //$.post("/Ajax/User/Logout.aspx", {}, $.AjaxRequest.Execute);
}

//用户登陆
Page.Login = function () {
    //$("#Login").animate({ opacity: 0 }, 500, function () {
    var szName = $("#Login_UserName").val();
    var szPwd = $("#Login_Password").val();
    var szCode = $("#Login_Code").val();
    //alert(szName);
    Page.UI.LoginHide(function () {

        Page.Ajax("/Ajax/User/Login.aspx", { Name: szName, Pwd: szPwd, Code: szCode }, false, function (responseText, status) {
            try {
                var Obj = eval('(' + responseText + ')');
                if (Obj.Flag != 1) {
                    alert(Obj.Message);
                }
            } catch (e) {
                alert("服务器返回数据异常!");
            }
            Page.CheckLogin();
        });

        //$.post("/Ajax/User/Login.aspx", { Name: szName, Pwd: szPwd }, function (data) {
        //    try {
        //        var Obj = eval('(' + data + ')');
        //        if (Obj.Flag != 1) {
        //            alert(Obj.Message);
        //        }
        //    } catch (e) {
        //        alert("服务器返回数据异常!");
        //    }
        //    Page.CheckLogin();
        //});

    });
    //$.Card.Remove("Card_UserLogin", function () {

    //    $.post("/Ajax/User/Login.aspx", { Name: szName, Pwd: szPwd }, function (data) {
    //        try {
    //            var Obj = eval('(' + data + ')');
    //            if (Obj.Flag != 1) {
    //                alert(Obj.Message);
    //            }
    //        } catch (e) {
    //            alert("服务器返回数据异常!");
    //        }
    //        Page.CheckLogin();
    //    });

    //});

    //$("#Login").css({ display: "none" });



    //$("#Console").animate({ top: (document.documentElement.clientHeight - 30) / 2 - 60 }, 500, function () {
    //    //Page.CheckLogin();

    //});
    //});
}


//检测是否登录
Page.CheckLogin = function () {
    Console.Writeln("Chcek login status :");

    setTimeout(function () {

        Page.Ajax("/Ajax/Status/Login.aspx", {}, false, function (responseText, status) {
            try {
                var Obj = eval('(' + responseText + ')');
                if (Obj.Flag == 1) {
                    Console.Writeln(Obj.Message);
                    Page.BackgroundSrc = Obj.Background;
                    $("#Windows_User").html(Obj.Message);
                    //setTimeout(Page.Inits.Screen, 100);
                    setTimeout(X.Custom.loadScreen, 100);
                } else {
                    Console.Writeln(Obj.Message);
                    X.Custom.changeCode();
                    Page.UI.Login();
                    //$("#Console").animate({ top: (document.documentElement.clientHeight - 330) / 2 - 80 }, 500, function () {
                    //    $("#Login").css({ left: (document.documentElement.clientWidth - 468) / 2 - 108, top: (document.documentElement.clientHeight - 330) / 2 - 156, display: "", opacity: 0 });
                    //    $("#Login").animate({ opacity: 1 }, 500, function () { });
                    //});
                    //$.Card.Remove("Card_UserLogin");
                }
            } catch (e) {
                alert("服务器返回数据异常!");
            }
        });

        //$.get("/Ajax/Status/Login.aspx", function (data) {
        //    try {
        //        var Obj = eval('(' + data + ')');
        //        if (Obj.Flag == 1) {
        //            Console.Writeln(Obj.Message);
        //            Page.BackgroundSrc = Obj.Background;
        //            $("#Windows_User").html(Obj.Message);
        //            setTimeout(Page.Inits.Screen, 100);
        //        } else {
        //            Console.Writeln(Obj.Message);
        //            Page.UI.Login();
        //            //$("#Console").animate({ top: (document.documentElement.clientHeight - 330) / 2 - 80 }, 500, function () {
        //            //    $("#Login").css({ left: (document.documentElement.clientWidth - 468) / 2 - 108, top: (document.documentElement.clientHeight - 330) / 2 - 156, display: "", opacity: 0 });
        //            //    $("#Login").animate({ opacity: 1 }, 500, function () { });
        //            //});
        //            //$.Card.Remove("Card_UserLogin");
        //        }
        //    } catch (e) {
        //        alert("服务器返回数据异常!");
        //    }
        //    //setTimeout(Page.Desktop.Init, 100);
        //});
    }, 500);
}

Page.Loaded = function () {

    X.Custom.Variables.LogoNow++;
    X.Custom.setLogoPoint();

    //alert(X.Custom.Variables.LogoNow + "/" + X.Custom.Variables.LogoFull);

    Console.Writeln("Initialization is complete!");
    //setTimeout(function () {
    //$("#Main").animate({ marginLeft: 0 - Console.Width }, 1000, function () {
    Page.UILoaded = true;
    //Taskbar.Load(Page.Element.Menu);
    Console.Writeln("UILoaded : " + Page.UILoaded);
    //alert("顺利完成");

    Console.Writeln("正在打开默认应用...");

    //X.Custom.Variables.LogoNow++;
    //X.Custom.setLogoPoint();
    $("#Launch").animate({ opacity: 0 }, 500, function () {
        $("#Launch").css({ display: "none" });

        $(Page.Element.Desktop).css({ top: -10, display: "" }).animate({ opacity: 100, top: 0 }, 200, function () {

            Page.ResetLocation();
            Page.UI.Open("Home", "", "主页", "/Files/App/System/Home/", "Process.aspx", { Arg_Path: "/Files/App/System/Home/", ID: "Home" });

            //初始化HTML编辑器
            //var arg = Page.UpdateArgs({});
            //document.getElementById("UEditorDialog_Frame").src = "/UEditor/1.4.3.1/Default.aspx?Azalea_SessionID=" + arg.Azalea_SessionID + "&Azalea_AuthID=" + arg.Azalea_AuthID;
            //$.Process.Add("AppManager", "我的应用", "/Files/App/Com_Application/", "Process.aspx", { Path: "/Files/App/Com_Application/", ID: "Win_AppManager" });
            //cd.MainElement.id
            Page.HeartBeat();

        });

    });
    // });
    // }, 100);
}

///心跳
Page.HeartBeat = function () {

    var arg = Page.UpdateArgs({});

    X.Ajax.GetData("/Ajax/User/Message.aspx", arg, function (data) {
        X.ServerPort.Execute(data);
        setTimeout(Page.HeartBeat, 10000);
    });

    //Page.Ajax("/Ajax/User/Message.aspx", {}, true, function (data) {
    //    $.AjaxRequest.Execute(data);
    //    setTimeout(Page.HeartBeat, 10000);
    //});
    //$.post("/Ajax/User/Message.aspx", {}, function (data) {
    //    $.AjaxRequest.Execute(data);
    //    setTimeout(Page.HeartBeat, 10000);
    //});
}

Page.NavigatePage = "";

Page.Navigate = function (url) {
    $("#Window_Frame")[0].src = "about:blank";
    $("#Window").css({ display: "" });
    $("#Window").animate({ opacity: 0 }, 100, function () {
        $("#Window_Frame")[0].src = url;
        $("#Window").animate({ opacity: 1 }, 500);
    });
}

///设置动态加载标志
X.Page.Scripts["Page_Main"] = true;