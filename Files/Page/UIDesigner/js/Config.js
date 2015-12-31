var Config = {
    //窗口属性
    Form: [
        { Name: "Width", Text: "宽度(Width)", ReadOnly: false, Object: false },
        { Name: "Height", Text: "高度(Height)", ReadOnly: false, Object: false },
        { Name: "Overflow", Text: "超出处理(Overflow)", ReadOnly: false, Object: false }
    ],
    //线条属性
    Line: [
        { Name: "ID", Text: "识标符(ID)", ReadOnly: true, Object: false },
        { Name: "Left", Text: "位置(X)", ReadOnly: false, Object: false },
        { Name: "Top", Text: "位置(Y)", ReadOnly: false, Object: false },
        { Name: "Width", Text: "宽度(Width)", ReadOnly: false, Object: false },
        { Name: "Height", Text: "高度(Height)", ReadOnly: false, Object: false },
        { Name: "Color", Text: "颜色(Color)", ReadOnly: false, Object: false }
    ],
    //标签属性
    Label: [
        { Name: "ID", Text: "识标符(ID)", ReadOnly: true, Object: false },
        { Name: "Text", Text: "显示文本", ReadOnly: false, Object: false },
        { Name: "Align", Text: "对齐方式", ReadOnly: false, Object: false },
        { Name: "Left", Text: "位置(X)", ReadOnly: false, Object: false },
        { Name: "Top", Text: "位置(Y)", ReadOnly: false, Object: false },
        { Name: "Width", Text: "宽度(Width)", ReadOnly: false, Object: false },
        { Name: "Height", Text: "高度(Height)", ReadOnly: false, Object: false },
        { Name: "PaddingTop", Text: "内边距(上)", ReadOnly: false, Object: false },
        { Name: "PaddingRight", Text: "内边距(右)", ReadOnly: false, Object: false },
        { Name: "PaddingBottom", Text: "内边距(下)", ReadOnly: false, Object: false },
        { Name: "PaddingLeft", Text: "内边距(左)", ReadOnly: false, Object: false },
        { Name: "Style", Text: "样式(Style)", ReadOnly: false, Object: false }
    ],
    //文本框属性
    TextBox: [
        { Name: "ID", Text: "识标符(ID)", ReadOnly: true, Object: false },
        { Name: "Name", Text: "关联数据列", ReadOnly: true, Object: false },
        { Name: "Type", Text: "工作类型", ReadOnly: false, Object: false },
        { Name: "ReadOnly", Text: "只读", ReadOnly: false, Object: false },
        { Name: "Value", Text: "值设定", ReadOnly: false, Object: true, ObjectType: "TextBox_Value" },
        { Name: "View", Text: "浏览值设定", ReadOnly: false, Object: true, ObjectType: "TextBox_Value" },
        { Name: "Align", Text: "对齐方式", ReadOnly: false, Object: false },
        { Name: "Left", Text: "位置(X)", ReadOnly: false, Object: false },
        { Name: "Top", Text: "位置(Y)", ReadOnly: false, Object: false },
        { Name: "Width", Text: "宽度(Width)", ReadOnly: false, Object: false },
        { Name: "Height", Text: "高度(Height)", ReadOnly: false, Object: false },
        { Name: "PaddingTop", Text: "内边距(上)", ReadOnly: false, Object: false },
        { Name: "PaddingRight", Text: "内边距(右)", ReadOnly: false, Object: false },
        { Name: "PaddingBottom", Text: "内边距(下)", ReadOnly: false, Object: false },
        { Name: "PaddingLeft", Text: "内边距(左)", ReadOnly: false, Object: false },
        { Name: "Style", Text: "样式(Style)", ReadOnly: false, Object: false },
        { Name: "Limit", Text: "编辑权限", ReadOnly: false, Object: false },
        { Name: "OnLeave", Text: "[事件]失去焦点", ReadOnly: false, Object: false }
    ],
    TextBox_Value: [
        { Name: "Type", Text: "值类型", ReadOnly: false, Object: false },
        { Name: "Binding", Text: "绑定字段", ReadOnly: false, Object: false },
        { Name: "Tables", Text: "表格集合", ReadOnly: false, Object: false },
        { Name: "Columns", Text: "字段集合", ReadOnly: false, Object: false },
        { Name: "Premise", Text: "条件集合", ReadOnly: false, Object: false },
        { Name: "Order", Text: "排序集合", ReadOnly: false, Object: false },
        { Name: "Bindings", Text: "多字段绑定", ReadOnly: true, Object: true, ObjectType: "" }
    ]
};

///设置动态加载标志
X.Page.Scripts["Page_Config"] = true;