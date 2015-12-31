/// <reference path="http://js.dyksoft.com/jq/jquery-1.11.3.js" />
/// <reference path="http://js.dyksoft.com/XKits/1.01.1510/X.js" />
/// <reference path="http://js.dyksoft.com/XKits/1.01.1510/X.Client.js" />
/// <reference path="http://js.dyksoft.com/XKits/1.01.1510/X.Storage.js" />
/// <reference path="/js/jq-Dialog.js" />
/// <reference path="/js/Controls/AjaxRequest.js" />
/// <reference path="WebConfig.js" />

var Page = function () { }

Page.InitJsonString = new Array();
Page.UIObject = new Array();
Page.ObjCount = 0;
Page.AutoNumber = 0;
Page.SelectedID = "";
Page.FormObject = {};
Page.TableName = "";
Page.TableID = 0;
Page.UIWindow = null; // new DialogClass("UIDesigner", 3, 100, 100, 0);

//加载页面需要使用的JS文件
X.Import("Page_AjaxRequest", "/js/Controls/AjaxRequest.js");
X.Import("Page_Dialog", "/js/jq-Dialog.js");
X.Import("Page_Config", "js/Config.js");

//X.WebConfig.Init(function () {
//    X.Configs.Kits.RightBan = false;
//});

X.ready(function () {
    Page.UIWindow = new DialogClass("UIDesigner", 3, 100, 100, 0);

    Page.UIWindow.ContentElement.onselectstart = function () { return false; };
    Page.UIWindow.ContentElement.onselect = function () { try { document.selection.empty(); } catch (e) { } };

    for (var i = 0; i < Page.ObjCount; i++) {
        Page.UIObject[i] = eval('(' + Page.InitJsonString[i] + ')');
    }
    Page.LoadUI();
});

$(document).ready(function () {

});

Page.UpdateArgs = function (arg) {

    arg["Azalea_SessionID"] = X.Storage.Get("Azalea_SessionID");
    arg["Azalea_AuthID"] = X.Storage.Get("Azalea_AuthID");
    arg["Azalea_Rnd"] = Math.random();

    return arg;
}

//一键生成
Page.OneKey = function () {
    var arg = { Table: Page.TableName, ID: Page.TableID };
    $.post("OneKey.aspx", Page.UpdateArgs(arg), $.AjaxRequest.Execute);
}

///添加一个新对象
Page.AddObject = function (objType) {
    var Obj = new DialogClass("AddObject", 5, 300, 130, 100);
    Obj.TitleElement.innerHTML = "添加一个控件对象";
    Obj.SetLocation(109, 311);

    var html = "";
    html += "<div style=\"padding: 15px 0px 0px 20px;\">"
    html += "  <div class=\"pub-left\" style=\"padding: 2px 3px 0px 0px\">对象类型:</div>";
    html += "  <div class=\"pub-left\" style=\"padding: 2px 3px 0px 0px\">" + objType + "</div>";
    html += "  <div class=\"pub-clear\"></div>";
    html += "</div>";
    html += "<div style=\"padding: 10px 0px 0px 20px;\">";
    html += "  <div class=\"pub-left\" style=\"padding: 2px 3px 0px 0px\">对象识标:</div>";
    html += "  <div class=\"pub-left\">";
    html += "    <input type=\"text\" id=\"AddObj_Name\" style=\"width: 180px; height: 20px; border: 1px solid #222; background: #fff; color: #222; padding: 0px 0px 0px 3px;\" />";
    html += "  </div>";
    html += "  <div class=\"pub-clear\"></div>";
    html += "</div>";
    html += "<div style=\"padding: 10px 0px 0px 160px;\">";
    html += "    <input type=\"button\" value=\"确定\"  style=\"width: 96px; height: 26px;\"  onclick=\"Page.Add" + objType + "Done();\" />";
    html += "</div>";

    Obj.ContentElement.innerHTML = html;
}

///添加标签
Page.AddLable = function () { Page.AddObject("Lable"); }

///添加文本框
Page.AddTextBox = function () { Page.AddObject("TextBox"); }

//添加线条
Page.AddLine = function () {
    Page.ObjCount++;
    Page.UIObject[Page.ObjCount - 1] = {};

    Page.AutoNumber++;
    Page.UIObject[Page.ObjCount - 1]["ID"] = "Auto_" + Page.AutoNumber;
    Page.UIObject[Page.ObjCount - 1]["ObjectType"] = "Line";
    Page.UIObject[Page.ObjCount - 1]["Color"] = "#000000";

    var obj = Page.UIObject[Page.ObjCount - 1];

    //新建UI标签
    var UIDiv = document.getElementById("UIDiv");
    var lab = document.createElement("div");
    UIDiv.appendChild(lab);
    lab.id = "UI_" + obj.ID;

    //建立对象列表
    var ColPan = document.getElementById("ColsPan");
    var colnew = document.createElement("li"); //document.getElementById("Col_" + obj.Name);
    ColPan.appendChild(colnew);
    colnew.id = "Col_ID_" + obj.ID;

    var html = "";
    html += "<a href=\"javascript:;\" onClick=\"Page.SelectUI('" + obj.ID + "');\">";
    html += "&lt;" + obj.ObjectType + ":" + obj.ID;
    if (obj["Name"]) {
        html += "@" + obj.Name;
    }
    html += "&gt;</a>";

    colnew.innerHTML = html;

    //alert(obj.ID);
    Page.LoadOneUI(obj);
}

//添加文本框
Page.AddTextBoxDone = function () {

    var szName = $(AddObj_Name).val();

    if (szName == "") {
        alert("文本框必须输入一个识标");
        return;
    }

    $.Dialog.Close('AddObject');

    Page.ObjCount++;
    Page.UIObject[Page.ObjCount - 1] = {};

    //Page.AutoNumber++;
    Page.UIObject[Page.ObjCount - 1]["ID"] = szName;
    Page.UIObject[Page.ObjCount - 1]["ObjectType"] = "TextBox";
    Page.UIObject[Page.ObjCount - 1]["Text"] = szName;
    Page.UIObject[Page.ObjCount - 1]["Type"] = "text";
    Page.UIObject[Page.ObjCount - 1]["Left"] = "0";
    Page.UIObject[Page.ObjCount - 1]["Top"] = "0";
    Page.UIObject[Page.ObjCount - 1]["Width"] = "100";
    Page.UIObject[Page.ObjCount - 1]["Height"] = "20";
    Page.UIObject[Page.ObjCount - 1]["PaddingTop"] = "0";
    Page.UIObject[Page.ObjCount - 1]["PaddingRight"] = "3";
    Page.UIObject[Page.ObjCount - 1]["PaddingBottom"] = "0";
    Page.UIObject[Page.ObjCount - 1]["PaddingLeft"] = "3";

    var obj = Page.UIObject[Page.ObjCount - 1];

    //新建UI标签
    var UIDiv = document.getElementById("UIDiv");
    var lab = document.createElement("div");
    UIDiv.appendChild(lab);
    lab.id = "UI_" + obj.ID;

    //建立对象列表
    var ColPan = document.getElementById("ColsPan");
    var colnew = document.createElement("li"); //document.getElementById("Col_" + obj.Name);
    ColPan.appendChild(colnew);
    colnew.id = "Col_ID_" + obj.ID;

    var html = "";
    html += "<a href=\"javascript:;\" onClick=\"Page.SelectUI('" + obj.ID + "');\">";
    html += "&lt;" + obj.ObjectType + ":" + obj.ID;
    if (obj["Name"]) {
        html += "@" + obj.Name;
    }
    html += "&gt;</a>";

    colnew.innerHTML = html;

    //alert(obj.ID);
    Page.LoadOneUI(obj);
}

//添加标签
Page.AddLableDone = function () {

    var szName = $(AddObj_Name).val();
    $.Dialog.Close('AddObject');

    if (szName == "") {
        Page.AutoNumber++;
        szName = "Auto_" + Page.AutoNumber;
    }

    Page.ObjCount++;
    Page.UIObject[Page.ObjCount - 1] = {};

    Page.UIObject[Page.ObjCount - 1]["ID"] = szName
    Page.UIObject[Page.ObjCount - 1]["ObjectType"] = "Label";
    Page.UIObject[Page.ObjCount - 1]["Text"] = szName;

    var obj = Page.UIObject[Page.ObjCount - 1];

    //新建UI标签
    var UIDiv = document.getElementById("UIDiv");
    var lab = document.createElement("div");
    UIDiv.appendChild(lab);
    lab.id = "UI_" + obj.ID;

    //建立对象列表
    var ColPan = document.getElementById("ColsPan");
    var colnew = document.createElement("li"); //document.getElementById("Col_" + obj.Name);
    ColPan.appendChild(colnew);
    colnew.id = "Col_ID_" + obj.ID;

    var html = "";
    html += "<a href=\"javascript:;\" onClick=\"Page.SelectUI('" + obj.ID + "');\">";
    html += "&lt;" + obj.ObjectType + ":" + obj.ID;
    if (obj["Name"]) {
        html += "@" + obj.Name;
    }
    html += "&gt;</a>";

    colnew.innerHTML = html;

    //alert(obj.ID);
    Page.LoadOneUI(obj);
}

//保存到服务端
Page.Save = function () {
    var json = "{";
    json += "Form:" + JSON.stringify(Page.FormObject);
    for (var i = 0; i < Page.ObjCount; i++) {
        var obj = Page.UIObject[i];
        if (obj != null) {
            if (obj.ObjectType != "Form") {
                if (i != Page.ObjCount - 1) json += ",";
                json += obj.ObjectType + ":" + JSON.stringify(obj);
            }
        }
    }
    json += "}";
    //alert(json);
    var arg = { Table: Page.TableName, ID: Page.TableID, Json: json };
    $.post("Save.aspx", Page.UpdateArgs(arg), $.AjaxRequest.Execute);
}

///编辑属性结束
Page.EditFinish2 = function (index, pro, pro2, value) {
    var obj = Page.UIObject[index];

    //alert(value);

    if (!obj[pro]) obj[pro] = {};
    //var PropertyObj = obj[pro];

    var pros = [];

    if (obj.ObjectType == "Label") objPros = Config.Label;
    if (obj.ObjectType == "TextBox") objPros = Config.TextBox;

    for (var i = 0; i < objPros.length; i++) {
        if (objPros[i].Name == pro) {
            //alert(objPros[i].ObjectType);
            pros = Config[objPros[i].ObjectType];
            break;
        }
    }

    for (var i = 0; i < pros.length; i++) {
        if (pros[i].Name == pro2) {
            if (pros[i].Object && objPros[i].ObjectType != "") {
                var pObj = eval('(' + value + ')');
                obj[pro][pro2] = {};
                //PropertyObj[pro2] = pObj;
                for (var property in pObj) {
                    obj[pro][pro2][property] = pObj[property];
                }
            } else {
                obj[pro][pro2] = value;
            }
            break;
        }
    }

    Page.LoadOneUI(obj);
}

///编辑属性结束
Page.EditFinish = function (index, pro, value) {
    var obj = Page.UIObject[index];
    obj[pro] = value;
    Page.LoadOneUI(obj);
}

///编辑属性结束
Page.FormEditFinish = function (pro, value) {
    var obj = Page.FormObject;
    obj[pro] = value;
    var UIDiv = document.getElementById("UIDiv");
    $(UIDiv).css({ width: obj.Width, height: obj.Height - 30, overflow: obj.Overflow });

    //alert(Page.UIWindow);
    var win = Page.UIWindow;
    //alert(win["setSize"]);
    win.SetSize(obj.Width, obj.Height);
}

///载入一个对象的属性
Page.LoadProperty2 = function (index, Property) {
    var UIPro = document.getElementById("UIProperty");
    var obj = Page.UIObject[index];

    if (!obj[Property]) obj[Property] = {};

    var PropertyObj = obj[Property];
    var objPros = [];
    var pros = [];

    if (obj.ObjectType == "Label") objPros = Config.Label;
    if (obj.ObjectType == "TextBox") objPros = Config.TextBox;
    if (obj.ObjectType == "Line") objPros = Config.Line;

    for (var i = 0; i < objPros.length; i++) {
        if (objPros[i].Name == Property) {
            //alert(objPros[i].ObjectType);
            pros = Config[objPros[i].ObjectType];
            break;
        }
    }

    $("#UIProTitle").html("<a href=\"javascript:;\" onclick=\"Page.LoadProperty(" + index + ");\" class=\"a-white\">" + obj.ID + "</a>&nbsp;&gt;&nbsp;" + Property);
    //alert(pros.length);

    var html = "";
    html += "<table style=\"width:100%;\">";

    for (var i = 0; i < pros.length; i++) {
        html += "<tr>";
        html += "<td style=\"width:40%;\">" + pros[i].Text + "</td>";
        if (pros[i].Object) {
            if (pros[i].ObjectType == "") {
                //alert(pros[i].Text + ":" + JSON.stringify(obj[pros[i].Name]));
                if (!PropertyObj[pros[i].Name]) PropertyObj[pros[i].Name] = {};
                html += "<td><input type=\"text\" style=\"border:0px; width:100%;\" value=\"" + JSON.stringify(PropertyObj[pros[i].Name]).replace(/"/g, "&quot;") + "\" onblur=\"Page.EditFinish2(" + index + ",'" + Property + "','" + pros[i].Name + "',this.value);\" /></td>";
            } else {
                html += "<td><a href=\"javascript:;\" onclick=\"Page.LoadProperty2(" + index + ",'" + pros[i].Name + "');\"  class=\"a-blue\">编辑</a></td>";
            }
        } else {
            var szName = pros[i].Name;
            if (!PropertyObj[szName]) PropertyObj[szName] = "";
            if (pros[i].ReadOnly) {
                html += "<td style=\"background:#eee;\">" + PropertyObj[pros[i].Name] + "</td>";
            } else {
                html += "<td><input type=\"text\" style=\"border:0px; width:100%;\" value=\"" + PropertyObj[szName] + "\" onblur=\"Page.EditFinish2(" + index + ",'" + Property + "','" + pros[i].Name + "',this.value);\" /></td>";
            }
        }
        html += "</tr>";
    }

    html += "</table>";

    UIPro.innerHTML = html;
}

///载入一个对象的属性
Page.LoadProperty = function (index) {
    var UIPro = document.getElementById("UIProperty");
    var obj = Page.UIObject[index];
    var pros = [];

    //alert(JSON.stringify(obj));

    if (obj.ObjectType == "Label") pros = Config.Label;
    if (obj.ObjectType == "TextBox") pros = Config.TextBox;
    if (obj.ObjectType == "Line") pros = Config.Line;

    $("#UIProTitle").html(obj.ID);

    var html = "";
    html += "<table style=\"width:100%;\">";

    for (var i = 0; i < pros.length; i++) {
        html += "<tr>";
        html += "<td style=\"width:40%;\">" + pros[i].Text + "</td>";

        if (!obj[pros[i].Name]) obj[pros[i].Name] = "";

        if (pros[i].Object) {
            if (pros[i].ObjectType == "") {
                html += "<td><input type=\"text\" style=\"border:0px; width:100%;\" value=\"" + JSON.stringify(obj[pros[i].Name]) + "\" onblur=\"Page.EditFinish(" + index + ",'" + pros[i].Name + "',this.value);\" /></td>";
            } else {
                html += "<td><a href=\"javascript:;\" onclick=\"Page.LoadProperty2(" + index + ",'" + pros[i].Name + "');\"  class=\"a-blue\">编辑</a></td>";
            }
        } else {
            if (pros[i].ReadOnly) {
                html += "<td style=\"background:#252526;\">" + obj[pros[i].Name] + "</td>";
            } else {
                html += "<td><input type=\"text\" style=\"border:0px; width:100%;\" value=\"" + obj[pros[i].Name] + "\" onblur=\"Page.EditFinish(" + index + ",'" + pros[i].Name + "',this.value);\" /></td>";
            }
        }
        html += "</tr>";
    }

    html += "</table>";

    UIPro.innerHTML = html;
}

///载入一个对象的属性
Page.LoadFormProperty = function () {
    var UIPro = document.getElementById("UIProperty");
    var obj = Page.FormObject;
    var pros = Config.Form;

    $("#UIProTitle").html("Form");

    var html = "";
    html += "<table style=\"width:100%;\">";

    for (var i = 0; i < pros.length; i++) {
        html += "<tr>";
        html += "<td style=\"width:40%;\">" + pros[i].Text + "</td>";
        if (pros[i].Object) {
            html += "<td>Object</td>";
        } else {
            if (pros[i].ReadOnly) {
                html += "<td style=\"background:#252526;\">" + obj[pros[i].Name] + "</td>";
            } else {
                html += "<td><input type=\"text\" style=\"border:0px; width:100%;\" value=\"" + obj[pros[i].Name] + "\" onblur=\"Page.FormEditFinish('" + pros[i].Name + "',this.value);\" /></td>";
            }
        }
        html += "</tr>";
    }

    html += "</table>";

    UIPro.innerHTML = html;
}

///选择窗体
Page.SelectedForm = function () {
    if (Page.SelectedID != "") {
        $("#UI_" + Page.SelectedID).css({ border: "" });
        $("#Col_ID_" + Page.SelectedID).css({ backgroundColor: "" });
    }
    Page.SelectedID = "";
    Page.LoadFormProperty();
}

///选择一个UI
Page.SelectUI = function (id, e) {
    Page.SelectUIOn(id, false, e);
}

///选择一个UI
Page.SelectUIOn = function (id, moved, e) {
    if (e && e.stopPropagation) {//非IE
        e.stopPropagation();
    }
    else {//IE
        window.event.cancelBubble = true;
    }

    if (Page.SelectedID != "") {
        $("#UI_" + Page.SelectedID).css({ border: "" });
        $("#Col_ID_" + Page.SelectedID).css({ backgroundColor: "" });
    }
    $("#UI_" + id).css({ border: "1px dashed #c40000" });
    $("#Col_ID_" + id).css({ backgroundColor: "#3399ff" });
    Page.SelectedID = id;

    //列出属性
    for (var i = 0; i < Page.ObjCount; i++) {
        var obj = Page.UIObject[i];
        if (obj["ID"]) {
            if (obj.ID == id) {
                if (moved) {
                    Page.MouseDownX = Page.MouseX;
                    Page.MouseDownY = Page.MouseY;
                    Page.ObjectX = parseInt(obj["Left"]);
                    Page.ObjectY = parseInt(obj["Top"]);
                    Page.MouseDown = i;
                }
                Page.LoadProperty(i);
            }
        }
    }
}

//当前鼠标拖动对象
Page.MouseDown = -1
Page.MouseDownX = 0;
Page.MouseDownY = 0;
Page.MouseX = 0;
Page.MouseY = 0;
Page.ObjectX = 0;
Page.ObjectY = 0;


///刷新单个UI
Page.LoadOneUI = function (obj) {
    var lab = document.getElementById("UI_" + obj.ID);
    lab.style.position = "absolute";
    lab.style.left = obj.Left + "px";
    lab.style.top = obj.Top + "px";

    if (obj.ObjectType == "Label") {
        //lab.style.width = obj.Width + "px";
        //lab.style.height = obj.Height + "px";
        //lab.style.textAlign = obj.Align;

        var labhtml = "";
        //labhtml += obj.Text;
        labhtml += "<div style=\"padding:" + obj.PaddingTop + "px " + obj.PaddingRight + "px " + obj.PaddingBottom + "px " + obj.PaddingLeft + "px;";
        labhtml += " width:" + obj.Width + "px; height:" + obj.Height + "px;";
        labhtml += " text-align:" + obj.Align + ";";
        labhtml += obj.Style;
        labhtml += " overflow:hidden; cursor:default;\" onmousedown=\"Page.SelectUIOn('" + obj.ID + "',true,event);\">";
        labhtml += obj.Text;
        labhtml += "</div>";

        lab.innerHTML = labhtml;
        //$(lab).css({ position: "absolute", left: obj.Left, top: obj.Top, width: obj.Width, height: obj.Height, textAlign: obj.Align }).html(obj.Text);
    }

    if (obj.ObjectType == "Line") {
        //lab.style.width = obj.Width + "px";
        //lab.style.height = obj.Height + "px";
        //lab.style.textAlign = obj.Align;

        var labhtml = "";
        //labhtml += obj.Text;
        labhtml += "<div style=\"padding:" + obj.PaddingTop + "px " + obj.PaddingRight + "px " + obj.PaddingBottom + "px " + obj.PaddingLeft + "px;";
        labhtml += " width:" + obj.Width + "px; height:" + obj.Height + "px;";
        labhtml += " background:" + obj.Color + ";";
        labhtml += " overflow:hidden; cursor:default;\" onmousedown=\"Page.SelectUIOn('" + obj.ID + "',true,event);\">";
        labhtml += obj.Text;
        labhtml += "</div>";

        lab.innerHTML = labhtml;
        //$(lab).css({ position: "absolute", left: obj.Left, top: obj.Top, width: obj.Width, height: obj.Height, textAlign: obj.Align }).html(obj.Text);
    }

    if (obj.ObjectType == "TextBox") {
        //lab.style.textAlign = obj.Align;
        //lab.style.overflow = "hidden";
        //lab.style.paddingTop = obj.PaddingTop + "px";
        //lab.style.paddingRight = obj.PaddingRight + "px";
        //lab.style.paddingBottom = obj.PaddingBottom + "px";
        //lab.style.paddingLeft = obj.PaddingLeft + "px";
        lab.className = "page-textbox";

        var labhtml = "";
        labhtml += "<div style=\"padding:" + obj.PaddingTop + "px " + obj.PaddingRight + "px " + obj.PaddingBottom + "px " + obj.PaddingLeft + "px;";
        labhtml += " width:" + obj.Width + "px; height:" + obj.Height + "px;";
        labhtml += " text-align:" + obj.Align + ";";
        labhtml += obj.Style;
        labhtml += " overflow:hidden; cursor:default;\" onmousedown=\"Page.SelectUIOn('" + obj.ID + "',true,event);\">";
        labhtml += obj.ID + "@" + obj.Text;
        labhtml += "</div>";

        lab.innerHTML = labhtml;

        if (obj["Type"]) {
            if (obj.Type == "hidden") {
                lab.style.display = "none";
            }
        }
        //$(lab).css({ padding: obj.Padding });
        //$(lab).css({ position: "absolute", left: obj.Left, top: obj.Top, width: obj.Width, height: obj.Height, textAlign: obj.Align }).html(obj.Text);
    }
}

///生成UI界面
Page.LoadUI = function () {
    var nWidth = 320;
    var nHeight = 240;
    Page.FormObject["Width"] = nWidth;
    Page.FormObject["Height"] = nHeight;

    var ColPan = document.getElementById("ColsPan");

    var UIPan = document.getElementById("UIMain");
    $(UIPan).css({ position: "relative" });

    var win = Page.UIWindow;
    //UIPan.appendChild(win.Element);
    document.body.removeChild(win.Element);
    UIPan.appendChild(win.Element);

    win.SetSize(nWidth, nHeight);
    $(win.Element).css({ left: 10, top: 10 });
    //$(win.Element).css({ left: 3, top: 3, width: "100%", height: "100%" });
    //alert(obj.TitleElement.outerHTML);
    $(win.TitleElement).html("UI设计 - [" + Page.TableName + "]");
    $(win.ContentElement).html("");

    var UISpaceDiv = document.createElement("div");
    win.ContentElement.appendChild(UISpaceDiv);
    $(UISpaceDiv).css({ padding: "6px 0px 0px 5px", height: 24, backgroundColor: "#dddddd" }).html("系统预留区域");

    var UIDiv = document.createElement("div");
    win.ContentElement.appendChild(UIDiv);
    UIDiv.id = "UIDiv";
    //UIDiv.className = "page-ui";
    $(UIDiv).css({ width: nWidth, height: nHeight, position: "relative" }).mousedown(function () {
        Page.SelectedForm();
    }).mouseup(function () {
        Page.MouseDown = -1;
    }).mousemove(function (e) {
        Page.MouseX = $(UIDiv).scrollLeft() + e.pageX;
        Page.MouseY = $(UIDiv).scrollTop() + e.pageY;
        var uidivhtml = "";
        uidivhtml += "Point(" + Page.MouseX + "," + Page.MouseY + ")/Down:" + Page.MouseDown;

        if (Page.MouseDown >= 0) {
            var obj = Page.UIObject[Page.MouseDown];
            uidivhtml += "/Type:" + obj.ObjectType;
            uidivhtml += "/Memory(" + Page.MouseDownX + "," + Page.MouseDownY + ")";
            uidivhtml += "/Object(" + Page.ObjectX + "," + Page.ObjectY + ")";
            var nLeft = Page.ObjectX + Page.MouseX - Page.MouseDownX;
            var nTop = Page.ObjectY + Page.MouseY - Page.MouseDownY;
            if (obj.ObjectType == "TextBox") {
                obj["Top"] = Math.floor(nTop / 5) * 5 + 2;
            } else {
                obj["Top"] = Math.floor(nTop / 5) * 5;
            }
            obj["Left"] = Math.floor(nLeft / 5) * 5;
            //obj["Left"] = parseInt(obj["Left"]) + Page.MouseX - Page.MouseDownX;
            //obj["Top"] = parseInt(obj["Top"]) + Page.MouseY - Page.MouseDownY;
            Page.LoadOneUI(obj);
            Page.LoadProperty(Page.MouseDown);
        }

        $(UISpaceDiv).html(uidivhtml);
    });


    for (var i = 0; i < Page.ObjCount; i++) {
        var obj = Page.UIObject[i];
        //Page.UIObject[i] = eval('(' + Page.InitJsonString[i] + ')');
        if (obj.ObjectType == "Form") {
            if (obj["Width"]) {
                Page.FormObject["Width"] = obj.Width;
                $(UIDiv).css({ width: obj.Width });
                win.SetWidth(obj.Width);
            }
            if (obj["Height"]) {
                Page.FormObject["Height"] = obj.Height;
                $(UIDiv).css({ height: obj.Height - 30 });
                win.SetHeight(obj.Height);
            }
            if (obj["Overflow"]) {
                Page.FormObject["Overflow"] = obj.Overflow;
                $(UIDiv).css({ overflow: obj.Overflow });
            }
        } else {

            if (obj.ObjectType == "Label" || obj.ObjectType == "Line" || obj.ObjectType == "TextBox") {

                //新建UI标签
                var lab = document.createElement("div");
                UIDiv.appendChild(lab);
                if (!obj["ID"]) {
                    Page.AutoNumber++;
                    obj["ID"] = "Auto_" + Page.AutoNumber;
                }
                lab.id = "UI_" + obj.ID;

                var nfound = false;
                //确认当前控件是否存在列中，如有，则修改其显示
                if (obj["Name"]) {
                    if (obj.Name != "") {
                        var col = document.getElementById("Col_Name_" + obj.Name);
                        if (col) {
                            col.id = "Col_ID_" + obj.ID;
                            //col.onclick = function () { Page.SelectUI(obj.ID); };

                            var html = "";
                            //html += "<div style=\"padding:0px;\" onClick=\"Page.SelectUI('" + obj.ID + "');\">";
                            html += "&nbsp;-&nbsp;<a href=\"javascript:;\" onClick=\"Page.SelectUI('" + obj.ID + "');\">&lt;" + obj.ObjectType + ":" + obj.ID + "&gt;</a>";
                            //html += "&nbsp;<a href=\"javascrpt:;\" onClick=\"Page.SelectUI('" + obj.ID + "');\">选择</a>";

                            col.innerHTML += html;
                            nfound = true;
                        }
                    }
                }

                //当前空间不在列中，直接添加一个虚拟列
                if (!nfound) {
                    //alert(ColPan.innerHTML);
                    var colnew = document.createElement("li"); //document.getElementById("Col_" + obj.Name);
                    ColPan.appendChild(colnew);
                    colnew.id = "Col_ID_" + obj.ID;

                    var html = "";
                    html += "<a href=\"javascript:;\" onClick=\"Page.SelectUI('" + obj.ID + "');\">";
                    html += "&lt;" + obj.ObjectType + ":" + obj.ID;
                    if (obj["Name"]) {
                        html += "@" + obj.Name;
                    }
                    html += "&gt;</a>";

                    colnew.innerHTML = html;
                }

                Page.LoadOneUI(obj);
            }
        }
    }
    Page.SelectedForm();
}