/// <reference path="http://js.dyksoft.com/jq/jquery-1.11.3.js" />
/// <reference path="http://js.dyksoft.com/XKits/1.03.1512.js" />
/// <reference path="/js/Page.js" />
/// <reference path="/js/Class.js" />
/// <reference path="/js/Controls/Tip.js" />
/// <reference path="/js/Controls/Taskbar.js" />
/// <reference path="/js/jq-Dialog.js" />
/// <reference path="/js/Controls/AjaxRequest.js" />
/// <reference path="/js/Controls/DatePicker.js" />
/// <reference path="../../XKits/X.Page.js" />

//重写交互中的信息提示函数
X.ServerPort.SetInfo = function (data) {
    alert(data);
}

X.Custom.Variables["LogoFull"] = 100;
X.Custom.Variables["LogoNow"] = 0;

X.Custom.Application = {};
X.Custom.Application["Name"] = "";
X.Custom.Application["Version"] = "";
X.Custom.Application["Text"] = "";

///授权初始化
X.Custom.AuthInit = function () { }

///添加授权
X.Custom.AddAuth = function (id, name, key) {
    var nLen = X.Storage.GetNumber("Azalea_Auth_Len");
    //alert(nLen);
    var bFound = false;
    for (var i = 0; i < nLen; i++) {
        var szKey = X.Storage.Get("Azalea_Auth_" + i + "_Key");
        if (szKey == key) {
            X.Storage.Set("Azalea_Auth_" + i + "_ID", id);
            X.Storage.Set("Azalea_Auth_" + i + "_Name", name);
            bFound = true;
            break;
        }
    }
    if (!bFound) {
        X.Storage.Set("Azalea_Auth_" + nLen + "_ID", id);
        X.Storage.Set("Azalea_Auth_" + nLen + "_Name", name);
        X.Storage.Set("Azalea_Auth_" + nLen + "_Key", key);
        X.Storage.Set("Azalea_Auth_Len", nLen + 1);
    }
}

///设置Logo动画的当前进度
X.Custom.setLogoPoint = function () {
    var nPoint = X.Custom.Variables.LogoNow * 100 / X.Custom.Variables.LogoFull;
    $("#Logo_Full").css({ width: nPoint + "%" });
}

///初始化桌面后加载桌面
X.Custom.loadDesktopBg = function () {

    X.Custom.Variables.LogoNow++;
    X.Custom.setLogoPoint();

    Console.Write("Loading the desktop background ...");

    //$("#Desktop").css({ backgroundColor: "#eeeeee" });
    var img = document.createElement("img");
    img.src = Page.BackgroundSrc;
    //img.height = document.documentElement.clientHeight;
    //img.width = document.documentElement.clientWidth;
    $(img).css({ zIndex: -1, opacity: 0, position: "absolute", left: 0, top: 0, width: "100%", height: "100%" });
    //$("#Desktop")[0].appendChild(img);
    //document.body.appendChild(img);
    Page.Element.Desktop.appendChild(img);
    //Page.Element.Desktop.BackgroudImage = img;

    //$(img).animate({ opacity: 1 }, 1000, function () {
    //    Console.Writeln(" OK");
    //    Page.UI.Show();
    //});
    $(img).css({ opacity: 1 });
    Console.Writeln(" OK");
    Page.UI.Show();
}

///初始化进程后初始化桌面
X.Custom.loadDesktop = function () {

    X.Custom.Variables.LogoNow++;
    X.Custom.setLogoPoint();
    Console.Writeln("Loading the desktop :");

    //setTimeout(X.Custom.loadDesktopBg, 100);
    X.Custom.loadDesktopBg();
}


///预载图片后进行初始化进程加载
X.Custom.loadProcess = function () {
    X.Custom.Variables.LogoNow++;
    X.Custom.setLogoPoint();

    Console.Writeln("->Loading process manager...");

    //加载进程管理器
    X.Page.loadScript("Page_Process", "/js/jq-Process.js", function () {
        X.Custom.Variables.LogoNow++;
        X.Custom.setLogoPoint();

        $.Process.Init("Window_Rect", "Windows_Name", "Menu_Main");

        //setTimeout(X.Custom.loadDesktop, 100);
        X.Custom.loadDesktop();
    });
    //setTimeout(Page.Desktop.Init, 100);
}

///载入屏幕后预加载图片
X.Custom.loadImages = function () {

    Console.Writeln("Load image files :");

    X.Custom.Variables.LogoNow++;
    X.Custom.setLogoPoint();

    ///加载背景图片
    X.Page.loadImage(Page.BackgroundSrc, function () {

        Console.Writeln("->Image[" + Page.BackgroundSrc + "] is loaded");
        X.Custom.Variables.LogoNow++;
        X.Custom.setLogoPoint();

        Console.Writeln("->Images all loaded!");
        X.Custom.loadProcess();
    })
}

///登陆后载入屏幕设定
X.Custom.loadScreen = function () {
    X.Custom.Variables.LogoFull = 11;
    X.Custom.Variables.LogoNow = 0;
    X.Custom.setLogoPoint();

    Console.Writeln("Load screen info :");
    //setTimeout(X.Custom.loadImages, 100);
    X.Custom.loadImages();
}

///初始化第四部，选定授权
X.Custom.AuthCheck = function (id) {
    X.Storage.Set("Azalea_AuthID", id);

    $("#CompanyList").css({ display: "none" });

    //setTimeout(Page.CheckLogin, 100);
    Page.CheckLogin();
}

///初始化第三步，加载授权
X.Custom.loadAuth = function () {
    X.Custom.AuthInit();

    var nLen = X.Storage.GetNumber("Azalea_Auth_Len");
    var Obj = document.getElementById("Company_List");
    for (var i = 0; i < nLen; i++) {
        var szID = X.Storage.Get("Azalea_Auth_" + i + "_ID");
        var szName = X.Storage.Get("Azalea_Auth_" + i + "_Name");
        var szKey = X.Storage.Get("Azalea_Auth_" + i + "_Key");
        var li = document.createElement("li");
        li.innerHTML = "&nbsp;<a href=\"javascript:;\" onClick=\"X.Custom.AuthCheck(" + szID + ");\">" + szName + "</a>";
        Obj.appendChild(li);
    }
}

///初始化第二步，加载内核
X.Custom.loadKernel = function () {

    //加载调试脚本
    X.Page.loadScript("Page_Debug", "/js/jq-debug.js", function () {
        X.Custom.Variables.LogoNow++;
        X.Custom.setLogoPoint();

        //加载控制台脚本
        X.Page.loadScript("Page_Console", "/js/Controls/Console.js", function () {

            Console.Color = "#ddd";
            Console.Height = 20;
            $("#Console").css({ left: (document.documentElement.clientWidth - 468) / 2, top: (document.documentElement.clientHeight - 30) / 2 - 60, display: "none", opacity: 0, height: 20, width: 468, overflow: "hidden" }).animate({ opacity: 0.8 }, 500);
            Console.Load(Page.Element.Console);
            X.Custom.Variables.LogoNow++;
            X.Custom.setLogoPoint();

            Console.Write("Load kernel files ...");

            //加载日期选择框
            X.Page.loadScript("Page_DatePicker", "/js/Controls/DatePicker.js", function () {

                Page.DatePicker = DatePicker;
                Page.DatePicker.Load("DateDialog");

                X.Custom.Variables.LogoNow++;
                X.Custom.setLogoPoint();

                //加载悬浮提示框
                X.Page.loadScript("Page_Tip", "/js/Controls/Tip.js", function () {

                    Tip.Load();

                    X.Custom.Variables.LogoNow++;
                    X.Custom.setLogoPoint();

                    Page.UI.Load();

                    Console.Writeln(" OK");

                    //加载交互脚本
                    X.Page.loadScript("Page_AjaxRequest", "/js/Controls/AjaxRequest.js", function () {
                        X.Custom.Variables.LogoNow++;
                        X.Custom.setLogoPoint();

                        //加载对话框脚本
                        X.Page.loadScript("Page_Dialog", "/js/jq-Dialog.js", function () {
                            X.Custom.Variables.LogoNow++;
                            X.Custom.setLogoPoint();

                            $.Dialog.Parent = document.getElementById("Main");

                            //加载主脚本
                            X.Page.loadScript("Page_Main", "/js/Default.js", function () {
                                X.Custom.Variables.LogoNow++;
                                X.Custom.setLogoPoint();

                                var nLeft = (X.Page.Width - 360) / 2;
                                var nTop = (X.Page.Height - 200) / 2;
                                $("#CompanyList").css({ left: nLeft, top: nTop, display: "" });

                                //alert(X.Custom.Variables.LogoNow);
                                //setTimeout(Page.CheckLogin, 100);
                                //setTimeout(X.Custom.loadAuth, 100);
                                X.Custom.loadAuth();
                            });

                        });

                    });

                });

            });

        });
    });
    //$.Card.Add("TestCard001", 0, 500);
    //$.Card.Add("TestCard002", 0, 500);
    //$.Card.Add("TestCard003", 1, 500);

    //Page.DatePicker.DayPicker();
    //Page.DatePicker.Month = 2;
    //Page.DatePicker.ShowDay();



}

X.Import("Page", "/js/Page.js");
X.Import("Page_Default", "js/Default.js");
X.Import("Page_Taskbar", "/js/Controls/Taskbar.js");

///初始化第一步，准备加载
X.Custom.Init = function () {

    X.Custom.Variables.LogoFull = 11;
    X.Custom.Variables.LogoNow = 0;

    X.Page.loadScript("Page", "/js/Page.js", function () {
        X.Custom.Variables.LogoNow++;
        X.Page.loadScript("Page_Default", "js/Default.js", function () {
            Page.UI.Init();
            X.Custom.Variables.LogoNow++;
            X.Custom.setLogoPoint();

            //加载进程管理器
            X.Page.loadScript("Page_Taskbar", "/js/Controls/Taskbar.js", function () {
                X.Custom.Variables.LogoNow++;
                X.Custom.setLogoPoint();
            });
        });
    });

}

////套件设置初始化时执行
//X.WebConfig.Init(function () {
//    X.Configs.Kits.RightBan = false;
//    X.Custom.Init();
//});

//套件加载完成后执行
X.ready(function () {

    if (X.Custom.Application.Text != "") {
        X.Client.SetTitle(X.Custom.Application.Text + " [基于 " + X.Custom.Application.Name + " V" + X.Custom.Application.Version + "]");
    } else {
        X.Client.SetTitle(X.Custom.Application.Name + " V" + X.Custom.Application.Version);
    }


    $(".page-menu-item").hover(function () {
        $(this).css({ backgroundColor: "#888888", color: "#000099" });
    }, function () {
        $(this).css({ backgroundColor: "", color: "" });
    });

    $(window).resize(function () {
        //alert("OK");

        if (Page.UILoaded) {
            Page.ResetLocation();
        }

    });

    X.Custom.Variables.LogoFull = 11;
    X.Custom.Variables.LogoNow = 0;
    Page.UI.Init();

    X.Custom.Variables.LogoNow++;
    X.Custom.setLogoPoint();
    X.Custom.loadKernel();
    //setTimeout(Page.Init, 10);

});
