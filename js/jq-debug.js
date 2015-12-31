/// <reference path="jquery-1.10.2.min.js" />
/// <reference path="X.js" />
/// <reference path="../XKits/X.js" />
/// <reference path="../XKits/X.Client.js" />

$.Console = function () { };

$.Console.group = function (cnt) {
    if (X.Client.Enabled) {
        X.Client.Debug("Group " + cnt);
    } else {
        if (window.console) {
            if (window.console["group"]) {
                window.console.group(cnt);
            }
        }
    }
}

$.Console.debug = function (cnt) {
    if (X.Client.Enabled) {
        X.Client.Debug(cnt);
    } else {
        if (window.console) {
            if (window.console["debug"]) {
                window.console.debug(cnt);
            }
        }
    }
}

$.Console.info = function (cnt) {
    if (X.Client.Enabled) {
        X.Client.Debug("  " + cnt);
    } else {
        if (window.console) {
            if (window.console["info"]) {
                window.console.info(cnt);
            }
        }
    }
}

$.Console.log = function (cnt) {
    if (X.Client.Enabled) {
        X.Client.Debug("log\>" + cnt);
    } else {
        if (window.console) {
            if (window.console["log"]) {
                window.console.log(cnt);
            }
        }
    }
}

$.Console.groupEnd = function () {
    if (X.Client.Enabled) {
        X.Client.Debug("End Group");
    } else {
        if (window.console) {
            if (window.console["groupEnd"]) {
                window.console.groupEnd();
            }
        }
    }
}

$(function () {

    //alert($.Console);

    //if ((!$.Console || $.Console == null) || $.Console == "undefined") {
    //    $.Console = {}
    //}
    //var funcs = ['assert', 'clear', 'count', 'debug', 'dir', 'dirxml',
    //         'error', 'exception', 'group', 'groupCollapsed', 'groupEnd',
    //         'info', 'log', 'markTimeline', 'profile', 'profileEnd',
    //         'table', 'time', 'timeEnd', 'timeStamp', 'trace', 'warn'];
    //for (var i = 0, l = funcs.length; i < l; i++) {
    //    var func = funcs[i];
    //    if (!$.Console[func])
    //        $.Console[func] = function () { };
    //}
    //if (!$.Console.memory) $.Console.memory = {};

    var obj = "";
    obj += "仰天大笑出门去，我辈岂是蓬蒿人。\n";
    obj += "可能我们感到孤独；\n";
    obj += "可能我们承受压力；\n";
    obj += "但是我们拥有荣耀；\n";
    obj += "同时我们拥有骄傲；\n";
    obj += "我们绝不是一个人在战斗；\n";
    obj += "在同一片夜空下，共码新章。\n";
    obj += "QQ:651737378\n";

    $.Console.debug(obj);

    var myDate = new Date();
    $.Console.group("开发商信息");
    $.Console.debug("开发商:联谊网络科技");
    $.Console.debug("官方网站:http://www.lianyi.biz");
    $.Console.debug("版权所有:Copyright © 温岭联谊网络科技有限公司 2014-" + myDate.getFullYear());
    $.Console.groupEnd();

    $.Console.group("核心技术信息");
    $.Console.info("内核:Azalea Web OS");
    $.Console.info("开发:D.Y.K Software Studio");
    $.Console.info("代号:Red");
    $.Console.info("版本:1.03.001.1510");
    $.Console.groupEnd();
})

///设置动态加载标志
X.Page.Scripts["Page_Debug"] = true;