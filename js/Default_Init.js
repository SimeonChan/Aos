/// <reference path="jquery-1.10.2.min.js" />
/// <reference path="Controls/Console.js" />
/// <reference path="Class.js" />
/// <reference path="Default.js" />
/// <reference path="jq-Process.js" />
/// <reference path="jq-debug.js" />
/// <reference path="Page.js" />

///界面初始化
Page.Inits = function () { }

Page.Inits.Kernel = function () {
    Console.Write("Load kernel files ...");

    Page.DatePicker = DatePicker;
    Page.DatePicker.Load("DateDialog");

    //$.Card.Add("TestCard001", 0, 500);
    //$.Card.Add("TestCard002", 0, 500);
    //$.Card.Add("TestCard003", 1, 500);

    //Page.DatePicker.DayPicker();
    //Page.DatePicker.Month = 2;
    //Page.DatePicker.ShowDay();

    Tip.Load();

    Page.UI.Load();

    Console.Writeln(" OK");
    setTimeout(Page.CheckLogin, 100);

    //$("#Console").animate({ opacity: 0.8 }, 500, function () {
    //    setTimeout(function () {
    //        Console.Writeln(" OK");
    //        setTimeout(Page.CheckLogin, 100);
    //        //setTimeout(Page.Inits.Screen, 100);
    //    }, 100);
    //});
}

Page.Inits.Screen = function () {
    Console.Writeln("Load screen info :");
    if (Console.Enabled) {
        setTimeout(function () {
            Console.Writeln("->document.body.clientWidth:" + document.body.clientWidth);
            //$.Console.debug("->document.body.clientWidth:" + document.body.clientWidth);
            setTimeout(function () {
                Console.Writeln("->document.body.clientHeight:" + document.body.clientHeight);
                //$.Console.debug("->document.body.clientHeight:" + document.body.clientHeight);
                setTimeout(function () {
                    Console.Writeln("->document.body.offsetWidth:" + document.body.offsetWidth);
                    //$.Console.debug("->document.body.offsetWidth:" + document.body.offsetWidth);
                    setTimeout(function () {
                        Console.Writeln("->document.body.offsetHeight:" + document.body.offsetHeight);
                        //$.Console.debug("->document.body.offsetHeight:" + document.body.offsetHeight);
                        setTimeout(function () {
                            Console.Writeln("->document.body.scrollWidth:" + document.body.scrollWidth);
                            //$.Console.debug("->document.body.scrollWidth:" + document.body.scrollWidth);
                            setTimeout(function () {
                                Console.Writeln("->document.body.scrollHeight:" + document.body.scrollHeight);
                                //$.Console.debug("->document.body.scrollHeight:" + document.body.scrollHeight);
                                setTimeout(function () {
                                    Console.Writeln("->document.body.scrollTop:" + document.body.scrollTop);
                                    //$.Console.debug("->document.body.scrollTop:" + document.body.scrollTop);
                                    setTimeout(function () {
                                        Console.Writeln("->document.body.scrollLeft:" + document.body.scrollLeft);
                                        //$.Console.debug("->document.body.scrollLeft:" + document.body.scrollLeft);
                                        setTimeout(function () {
                                            Console.Writeln("->window.screenTop:" + window.screenTop);
                                            //$.Console.debug("->window.screenTop:" + window.screenTop);
                                            setTimeout(function () {
                                                Console.Writeln("->window.screenLeft:" + window.screenLeft);
                                                //$.Console.debug("->window.screenLeft:" + window.screenLeft);
                                                setTimeout(function () {
                                                    Console.Writeln("->window.screen.height:" + window.screen.height);
                                                    //$.Console.debug("->window.screen.height:" + window.screen.height);
                                                    setTimeout(function () {
                                                        Console.Writeln("->window.screen.width:" + window.screen.width);
                                                        //$.Console.debug("->window.screen.width:" + window.screen.width);
                                                        setTimeout(function () {
                                                            Console.Writeln("->window.screen.availHeight:" + window.screen.availHeight);
                                                            //$.Console.debug("->window.screen.availHeight:" + window.screen.availHeight);
                                                            setTimeout(function () {
                                                                Console.Writeln("->window.screen.availWidth:" + window.screen.availWidth);
                                                                //$.Console.debug("->window.screen.availWidth:" + window.screen.availWidth);
                                                                setTimeout(function () {
                                                                    Console.Writeln("->window.screen.colorDepth:" + window.screen.colorDepth);
                                                                    //$.Console.debug("->window.screen.colorDepth:" + window.screen.colorDepth);
                                                                    setTimeout(function () {
                                                                        Console.Writeln("->window.screen.deviceXDPI:" + window.screen.deviceXDPI);
                                                                        //$.Console.debug("->window.screen.deviceXDPI:" + window.screen.deviceXDPI);
                                                                        setTimeout(function () {
                                                                            Console.Writeln("->document.documentElement.clientWidth:" + document.documentElement.clientWidth);
                                                                            //$.Console.debug("->document.documentElement.clientWidth:" + document.documentElement.clientWidth);
                                                                            setTimeout(function () {
                                                                                Console.Writeln("->document.documentElement.clientHeight:" + document.documentElement.clientHeight);
                                                                                //$.Console.debug("->document.documentElement.clientHeight:" + document.documentElement.clientHeight);
                                                                                setTimeout(function () {
                                                                                    Console.Writeln("->window.devicePixelRatio:" + window.devicePixelRatio);
                                                                                    //$.Console.debug("->window.devicePixelRatio:" + window.devicePixelRatio);
                                                                                    setTimeout(Page.Inits.Images, 100);
                                                                                }, 10);
                                                                            }, 10);
                                                                        }, 10);
                                                                    }, 10);
                                                                }, 10);
                                                            }, 10);
                                                        }, 10);
                                                    }, 10);
                                                }, 10);
                                            }, 10);
                                        }, 10);
                                    }, 10);
                                }, 10);
                            }, 10);
                        }, 10);
                    }, 10);
                }, 10);
            }, 10);
        }, 100);
    } else {
        setTimeout(Page.Inits.Images, 100);
    }
}

Page.Inits.ImageCount = 4;
Page.Inits.ImageLoadCount = 0;

Page.Inits.Process = function () {
    Console.Writeln("->Loading process manager...");
    $.Process.Init("Window_Rect", "Windows_Name", "Menu_Main");
    setTimeout(Page.Desktop.Init, 100);
}

Page.Inits.ImagesLoaded = function (url) {
    Console.Writeln("->(" + Page.Inits.ImageLoadCount + "/" + Page.Inits.ImageCount + ")ImageFile[" + url + "] is loaded");
    Page.Inits.ImageLoadCount++;
    if (Page.Inits.ImageLoadCount >= Page.Inits.ImageCount) {
        Console.Writeln("->Images all loaded!");
        //setTimeout(Page.CheckLogin, 100);
        Page.Inits.Process();
    }
}

Page.Inits.Images = function () {
    Console.Writeln("Load image files :");
    setTimeout(function () {
        //Console.Writeln(" OK");
        //setTimeout(Page.CheckLogin, 100);
        var menuObj = eval('(' + Taskbar.ObjectsJson + ')');

        Page.Inits.ImageLoadCount = 0;
        Page.Inits.ImageCount = menuObj.Array.length + 1;

        for (i = 0; i < menuObj.Array.length; i++) {
            var img01 = new clsImageLoader("/Files/App/" + menuObj.Array[i].name + "/logo.png", Page.Inits.ImagesLoaded);
            img01.load();
        }

        var img02 = new clsImageLoader(Page.BackgroundSrc, Page.Inits.ImagesLoaded);
        img02.load();

    }, 100);
}

