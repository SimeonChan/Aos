/// <reference path="../../../js/jquery-1.10.2.min.js" />
/// <reference path="../../../../js/jq-messagebox.js" />
/// <reference path="../../../js/Controls/AjaxRequest.js" />

$(document).ready(function () {

});

var Page = function () { }

Page.AddTable = function (id) {
    $.post("Table_Add.aspx", { DB: id, Table: $("#name").val() }, function (data) {
        //alert(e);
        $.AjaxRequest.Execute(data);
    });
}

Page.AddTableWithName = function (id, name) {
    $.post("Table_Add.aspx", { DB: id, Table: name }, function (data) {
        //alert(e);
        $.AjaxRequest.Execute(data);
    });
}

Page.TableEdit = function (id, table, tablename, col) {
    $.Window.Open("Message_Edit", "修改表格[" + tablename + "]的[" + col + "]属性", 480, "TableEditBox.aspx", { DB: id, Table: table, Column: col });
}

Page.TableEditAuto = function (EId, id, table, col, value) {
    $("#" + EId).load("TableEditBoxAuto.aspx", { DB: id, Table: table, Column: col, Value: value });
}

///保存表格属性
Page.TableEditSave = function (id, table, col, value) {
    $.post("TableSave.aspx", { DB: id, Table: table, Column: col, Value: value }, function (data) {
        $.AjaxRequest.Execute(data);
    });
}

///通过编辑框保存表格属性
Page.TableEditSaveByEdit = function (id, table, col) {
    Page.TableEditSave(id, table, col, $("#EditBox_Value").val());
}

