/// <reference path="../../../js/jquery-1.10.2.min.js" />
/// <reference path="../../../../js/jq-messagebox.js" />
/// <reference path="../../../js/Controls/AjaxRequest.js" />

var Page = function () { }

Page.AddColumn = function (table) {
    $.post("TableColumnAdd.aspx", { Table: table, Column: $("#name").val() }, function (data) {
        //alert(e);
        $.AjaxRequest.Execute(data);
    });
}

Page.AddColumnWithName = function (table, name) {
    $.post("TableColumnAdd.aspx", { Table: table, Column: name }, function (data) {
        //alert(e);
        $.AjaxRequest.Execute(data);
    });
}

Page.TableEdit = function (table, tablename, column, columnname, col) {
    $.Window.Open("Message_Edit", "修改表格[" + tablename + "]列[" + columnname + "]的[" + col + "]属性", 480, "TableColumnEditBox.aspx", { Table: table, Column: column, Property: col });
}

Page.TableEditAuto = function (EId, table, column, col, value) {
    $("#" + EId).load("TableColumnEditBoxAuto.aspx", { Table: table, Column: column, Property: col, Value: value });
}

///保存表格属性
Page.TableEditSave = function (column, col, value) {
    $.post("TableColumnSave.aspx", { Column: column, Property: col, Value: value }, function (data) {
        $.AjaxRequest.Execute(data);
    });
}

///通过编辑框保存表格属性
Page.TableEditSaveByEdit = function (column, col) {
    Page.TableEditSave(column, col, $("#EditBox_Value").val());
}