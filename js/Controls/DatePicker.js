/*
日期选择器
*/
var DatePicker = function () { }

///日期选择器元素对象
DatePicker.Element = null;
DatePicker.ElementID = "";

///日期选择器当前工作模式
DatePicker.Mode = 0;

///日期选择器的年份
DatePicker.Year = 0;

///日期选择器的月份
DatePicker.Month = 0;

///日期选择器的日期
DatePicker.Day = 0;

///日期选择器赋值对象
DatePicker.Target = "";

///日期选择器初始化
DatePicker.Load = function (id) {

    DatePicker.ElementID = id;
    DatePicker.Element = document.getElementById(id);

    if (DatePicker.Element) {
        var html = "";

        html += "<div style=\"background: #fff; border: 2px solid #222222; width: 430px;\">";

        html += "<div>";
        html += "<div style=\"float: left; width: 370px; text-align: center; padding: 3px 0px 3px 0px; background: #0094ff; color: #fff;\">日期选择器</div>";
        html += "<div style=\"float: right; width: 60px; text-align: center; background: #990000; color: #fff; padding: 3px 0px 3px 0px; cursor: pointer;\" onclick=\"DatePicker.Close();\" onmousemove=\"this.style.backgroundColor='#FF0000';\" onmouseout=\"this.style.backgroundColor='#990000';\">关闭</div>";
        html += "<div style=\"clear: both;\"></div>";
        html += "</div>";

        html += "<div id=\"" + id + "_Body\">";
        html += "</div>";

        html += "</div>";

        DatePicker.Element.innerHTML = html;

        DatePicker.Element = document.getElementById(id + "_Body");
    } else {
        alert("未找到ID为\"" + id + "\"的页面元素，日期选择器初始化失败");
    }
}

///显示日期选择器
DatePicker.Show = function () {
    document.getElementById(DatePicker.ElementID).style.display = "";
}

///移动日期选择器
DatePicker.Move = function (x, y) {
    var div = document.getElementById(DatePicker.ElementID);
    div.style.top = y + "px";
    div.style.left = x + "px";
}

///关闭日期选择器
DatePicker.Close = function () {
    document.getElementById(DatePicker.ElementID).style.display = "none";
}

///年选择器模式
DatePicker.YearPicker = function (id, d) {
    DatePicker.Mode = 2;
    DatePicker.Target = id;
    var myDate = new Date();
    if (d != "") myDate = new Date(d);
    DatePicker.Year = myDate.getFullYear();
    DatePicker.ShowYear(DatePicker.Year);
    DatePicker.Show();
}

///月选择器模式
DatePicker.MonthPicker = function (id, d) {
    DatePicker.Mode = 1;
    DatePicker.Target = id;
    var myDate = new Date();
    if (d != "") myDate = new Date(d);
    DatePicker.Year = myDate.getFullYear();
    DatePicker.Month = myDate.getMonth() + 1;
    DatePicker.ShowMonth();
    DatePicker.Show();
}

///日选择器模式
DatePicker.DayPicker = function (id, d) {
    DatePicker.Mode = 0;
    DatePicker.Target = id;
    var myDate = new Date();
    if (d != "") myDate = new Date(d);
    //alert(myDate);
    DatePicker.Year = myDate.getFullYear();
    DatePicker.Month = myDate.getMonth() + 1;
    DatePicker.Day = myDate.getDate();
    DatePicker.ShowDay();
    DatePicker.Show();
}

///选择一个年份
DatePicker.YearSelect = function (y) {
    if (DatePicker.Mode == 2) {
        var obj = document.getElementById(DatePicker.Target);
        if (obj) {
            obj.value = y;
        } else {
            alert("未找到赋值对象,赋值失败!");
        }
        DatePicker.Close();
    } else {
        DatePicker.Year = y;
        DatePicker.ShowMonth();
    }
}

///选择一个月份
DatePicker.MonthSelect = function (y, m) {
    if (DatePicker.Mode == 1) {
        var obj = document.getElementById(DatePicker.Target);
        if (obj) {
            obj.value = y + "-" + (m < 10 ? "0" + m : m);
        } else {
            alert("未找到赋值对象,赋值失败!");
        }
        DatePicker.Close();
    } else {
        DatePicker.Year = y;
        DatePicker.Month = m;
        DatePicker.ShowDay();
    }
}

///选择一个日期
DatePicker.DaySelect = function (y, m, d) {
    var obj = document.getElementById(DatePicker.Target);
    if (obj) {
        obj.value = y + "-" + (m < 10 ? "0" + m : m) + "-" + (d < 10 ? "0" + d : d);
    } else {
        alert("未找到赋值对象,赋值失败!");
    }
    DatePicker.Close();
}

///显示日期选择项
DatePicker.ShowDay = function () {

    var day = new Date(DatePicker.Year + "-" + DatePicker.Month + "-1");
    var daycount = 0;

    switch (DatePicker.Month) {
        case 1:
        case 3:
        case 5:
        case 7:
        case 8:
        case 10:
        case 12:
            daycount = 31;
            break;
        case 4:
        case 6:
        case 9:
        case 11:
            daycount = 30;
            break;
        default:
            if ((DatePicker.Year % 400 == 0) || (DatePicker.Year % 4 == 0 && DatePicker.Year % 100 != 0)) {
                daycount = 29;
            } else {
                daycount = 28;
            }
            break;
    }

    var html = "";

    var yb = DatePicker.Year;
    var mb = DatePicker.Month - 1;
    if (mb <= 0) {
        yb--;
        mb = 12;
    }

    var ya = DatePicker.Year;
    var ma = DatePicker.Month + 1;
    if (ma > 12) {
        ya++;
        ma = 1;
    }

    html += "<div style=\"border-bottom: 1px solid #dddddd;\">";
    html += "<div style=\"float: left; width: 60px; text-align: center; padding: 5px 0px 5px 0px; cursor: pointer;\" onclick=\"DatePicker.MonthSelect(" + yb + "," + mb + ");\" onmousemove=\"this.style.backgroundColor='#dddddd';\" onmouseout=\"this.style.backgroundColor='#fff';\">向前</div>";
    html += "<div style=\"float: left; width: 310px; text-align: center; padding: 5px 0px 5px 0px;; cursor: pointer;\" onclick=\"DatePicker.YearSelect(" + DatePicker.Year + ");\" onmousemove=\"this.style.backgroundColor='#dddddd';\" onmouseout=\"this.style.backgroundColor='#fff';\"\">" + DatePicker.Year + "年" + (DatePicker.Month < 10 ? "0" + DatePicker.Month : DatePicker.Month) + "月</div>";
    html += "<div style=\"float: left; width: 60px; text-align: center; padding: 5px 0px 5px 0px;cursor: pointer;\" onclick=\"DatePicker.MonthSelect(" + ya + "," + ma + ");\" onmousemove=\"this.style.backgroundColor='#dddddd';\" onmouseout=\"this.style.backgroundColor='#fff';\">向后</div>";
    html += "<div style=\"clear: both;\"></div>";
    html += "</div>";

    html += "<div style=\"padding: 3px 5px 3px 5px; border-bottom: 1px solid #dddddd;\">";
    html += "<div style=\"float: left; width: 60px; text-align: center;\">日</div>";
    html += "<div style=\"float: left; width: 60px; text-align: center;\">一</div>";
    html += "<div style=\"float: left; width: 60px; text-align: center;\">二</div>";
    html += "<div style=\"float: left; width: 60px; text-align: center;\">三</div>";
    html += "<div style=\"float: left; width: 60px; text-align: center;\">四</div>";
    html += "<div style=\"float: left; width: 60px; text-align: center;\">五</div>";
    html += "<div style=\"float: left; width: 60px; text-align: center;\">六</div>";
    html += "<div style=\"clear: both;\"></div>";
    html += "</div>";

    html += "<div style=\"padding: 5px 5px 5px 5px;\">";

    for (var i = 1; i <= day.getDay() ; i++) {
        html += "<div style=\"float: left; width: 60px; text-align: center; padding: 5px 0px 5px 0px; cursor: pointer;\">&nbsp;</div>";
    }

    for (var i = 1; i <= daycount ; i++) {
        html += "<div style=\"float: left; width: 60px; text-align: center; padding: 5px 0px 5px 0px; cursor: pointer;\" onclick=\"DatePicker.DaySelect(" + DatePicker.Year + "," + DatePicker.Month + "," + i + ");\" onmousemove=\"this.style.backgroundColor='#dddddd';\" onmouseout=\"this.style.backgroundColor='#fff';\">" + i + "日</div>";
    }
    html += "<div style=\"clear: both;\"></div>";
    html += "</div>";


    var myDate = new Date();
    var myMonth = myDate.getMonth() + 1;
    var myDay = myDate.getDate();

    html += "<div style=\"padding: 5px 5px 5px 5px;\">";
    html += "<div style=\"float: left; width: 410px; text-align: left; padding: 5px 5px 5px 5px; cursor: pointer;\" onclick=\"DatePicker.DaySelect(" + myDate.getFullYear() + "," + myMonth + "," + myDay + ");\" onmousemove=\"this.style.backgroundColor='#dddddd';\" onmouseout=\"this.style.backgroundColor='#fff';\">[选择今天]" + myDate.getFullYear() + "年" + (myMonth < 10 ? "0" + myMonth : myMonth) + "月" + (myDay < 10 ? "0" + myDay : myDay) + "日</div>";
    html += "<div style=\"clear: both;\"></div>";
    html += "</div>";

    DatePicker.Element.innerHTML = html;
}

///显示月份选择项
DatePicker.ShowMonth = function () {

    var html = "";

    html += "<div style=\"border-bottom: 1px solid #dddddd;\">";
    html += "<div style=\"float: left; width: 60px; text-align: center; padding: 5px 0px 5px 0px; cursor: pointer;\" onclick=\"DatePicker.YearSelect(" + (DatePicker.Year - 1) + ");\" onmousemove=\"this.style.backgroundColor='#dddddd';\" onmouseout=\"this.style.backgroundColor='#fff';\">向前</div>";
    html += "<div style=\"float: left; width: 310px; text-align: center; padding: 5px 0px 5px 0px;; cursor: pointer;\" onclick=\"DatePicker.ShowYear(" + DatePicker.Year + ");\" onmousemove=\"this.style.backgroundColor='#dddddd';\" onmouseout=\"this.style.backgroundColor='#fff';\"\">" + DatePicker.Year + "年</div>";
    html += "<div style=\"float: left; width: 60px; text-align: center; padding: 5px 0px 5px 0px;cursor: pointer;\" onclick=\"DatePicker.YearSelect(" + (DatePicker.Year + 1) + ");\" onmousemove=\"this.style.backgroundColor='#dddddd';\" onmouseout=\"this.style.backgroundColor='#fff';\">向后</div>";
    html += "<div style=\"clear: both;\"></div>";
    html += "</div>";

    html += "<div style=\"padding: 5px 5px 5px 5px; border-bottom: 1px solid #dddddd;\">";
    for (var i = 1; i <= 12; i++) {
        html += "<div style=\"float: left; width: 105px; text-align: center; padding: 5px 0px 5px 0px; cursor: pointer;\" onclick=\"DatePicker.MonthSelect(" + DatePicker.Year + "," + i + ");\" onmousemove=\"this.style.backgroundColor='#dddddd';\" onmouseout=\"this.style.backgroundColor='#fff';\">" + i + "月</div>";
    }
    html += "<div style=\"clear: both;\"></div>";
    html += "</div>";

    var myDate = new Date();
    var myMonth = myDate.getMonth() + 1;

    html += "<div style=\"padding: 5px 5px 5px 5px;\">";
    html += "<div style=\"float: left; width: 410px; text-align: left; padding: 5px 5px 5px 5px; cursor: pointer;\" onclick=\"DatePicker.MonthSelect(" + myDate.getFullYear() + "," + myMonth + ");\" onmousemove=\"this.style.backgroundColor='#dddddd';\" onmouseout=\"this.style.backgroundColor='#fff';\">[选择本月]" + myDate.getFullYear() + "年" + (myMonth < 10 ? "0" + myMonth : myMonth) + "月</div>";
    html += "<div style=\"clear: both;\"></div>";
    html += "</div>";

    DatePicker.Element.innerHTML = html;
}

///显示年份选择项
DatePicker.ShowYear = function (y) {
    var yb = y - 4;
    var ya = y + 4;

    var html = "";

    html += "<div style=\"border-bottom: 1px solid #dddddd;\">";
    html += "<div style=\"float: left; width: 60px; text-align: center; padding: 5px 0px 5px 0px; cursor: pointer;\" onclick=\"DatePicker.ShowYear(" + (y - 9) + ");\" onmousemove=\"this.style.backgroundColor='#dddddd';\" onmouseout=\"this.style.backgroundColor='#fff';\">向前</div>";
    html += "<div style=\"float: left; width: 310px; text-align: center; padding: 5px 0px 5px 0px;\">" + yb + "年 - " + ya + "年</div>";
    html += "<div style=\"float: left; width: 60px; text-align: center; padding: 5px 0px 5px 0px;cursor: pointer;\" onclick=\"DatePicker.ShowYear(" + (y + 9) + ");\" onmousemove=\"this.style.backgroundColor='#dddddd';\" onmouseout=\"this.style.backgroundColor='#fff';\">向后</div>";
    html += "<div style=\"clear: both;\"></div>";
    html += "</div>";

    html += "<div style=\"padding: 5px 5px 5px 5px; border-bottom: 1px solid #dddddd;\">";
    for (var i = yb; i <= ya; i++) {
        html += "<div style=\"float: left; width: 140px; text-align: center; padding: 5px 0px 5px 0px; cursor: pointer;\" onclick=\"DatePicker.YearSelect(" + i + ");\" onmousemove=\"this.style.backgroundColor='#dddddd';\" onmouseout=\"this.style.backgroundColor='#fff';\">" + i + "年</div>";
    }
    html += "<div style=\"clear: both;\"></div>";
    html += "</div>";

    var myDate = new Date();

    html += "<div style=\"padding: 5px 5px 5px 5px;\">";
    html += "<div style=\"float: left; width: 410px; text-align: left; padding: 5px 5px 5px 5px; cursor: pointer;\" onclick=\"DatePicker.YearSelect(" + myDate.getFullYear() + ");\" onmousemove=\"this.style.backgroundColor='#dddddd';\" onmouseout=\"this.style.backgroundColor='#fff';\">[选择本年]" + myDate.getFullYear() + "年</div>";
    html += "<div style=\"clear: both;\"></div>";
    html += "</div>";

    DatePicker.Element.innerHTML = html;
}

///设置动态加载标志
X.Page.Scripts["Page_DatePicker"] = true;