/// <reference path="../jquery-1.10.2.min.js" />

$(document).ready(function () {
    document.body.oncontextmenu = document.body.ondragstart = document.body.onselectstart = document.body.onbeforecopy = function (event) {
        if (event.target.tagName != "INPUT"&&event.target.tagName != "TEXTAREA") {
            return false;
        }
    };
    document.body.onselect = document.body.oncopy = document.body.onmouseup = function () { try { document.selection.empty(); } catch (e) { } };
});

//if (typeof (document.onselectstart) != "undefined") {
//    document.onselectstart = function (event) {
//        if (event.target.tagName != "INPUT") {
//            return false;
//        }
//    }
//} else {
//    // firefox下禁止元素被选取的变通办法       
//    document.onmousedown = function (event) {
//        if (event.target.tagName != "INPUT") {
//            return false;
//        }
//    }
//    document.onmouseup = function (event) {
//        if (event.target.tagName != "INPUT") {
//            return false;
//        }
//    }
//}