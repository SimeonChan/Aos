using System;
using System.Collections.Generic;
using System.Web;

namespace dyk.WebSite {

    /// <summary>
    /// UpdateInfo 的摘要说明
    /// </summary>
    public class UpdateInfo {

        public class UpdateInfoItem {
            private string gszVersion;
            private List<string> gszItems;

            public UpdateInfoItem() {
                gszVersion = "";
                gszItems = new List<string>();
            }

            public string Version { get { return gszVersion; } set { gszVersion = value; } }
            public List<string> Items { get { return gszItems; } }
        }

        private List<UpdateInfoItem> gszAppUpdateInfo;

        public UpdateInfo() {
            //
            // TODO: 在此处添加构造函数逻辑
            //
            gszAppUpdateInfo = new List<UpdateInfoItem>();

            AddUpdate_1_04_1604_010();
            AddUpdate_1_04_1603_0009();
            AddUpdate_1_04_1601_0008();
            AddUpdate_1_04_16_0107();
            AddUpdate_1_04_006_1512();
            AddUpdate_1_04_005_1512();
            AddUpdate_1_04_004_1512();
            AddUpdate_1_04_003_1512();
            AddUpdate_1_04_002_1512();
            AddUpdate_1_04_001_1512();
            AddUpdate_1_03_004_1511();
            AddUpdate_1_03_1511_0603();
            AddUpdate_1_03_002_1511();
            AddUpdate_1_03_001_1510();
            AddUpdate_1_02_003();
            AddUpdate_1_02_002();
            AddUpdate_1_02_001();
            AddUpdate_1_01_005();
            AddUpdate_1_01_004();
        }

        private void AddUpdate_1_04_1604_010() {
            UpdateInfoItem item = new UpdateInfoItem();
            item.Version = "1.04.1603.010";
            item.Items.Add("修复：新授权无法正常管理表结构的问题");
            gszAppUpdateInfo.Add(item);
        }

        private void AddUpdate_1_04_1603_0009() {
            UpdateInfoItem item = new UpdateInfoItem();
            item.Version = "1.04.1603.0009";
            item.Items.Add("修复：安装过程中个无提示异常错误");
            gszAppUpdateInfo.Add(item);
        }

        private void AddUpdate_1_04_1601_0008() {
            UpdateInfoItem item = new UpdateInfoItem();
            item.Version = "1.04.1601.0008";
            item.Items.Add("新增：全新的UI生成方式，统一的UI生成算法，提升UI生成效率");
            item.Items.Add("新增：全新的组合信息数据界面，提供了一种不同于二维表格的展现方式");
            item.Items.Add("新增：编辑UI界面中支持转码");
            item.Items.Add("变更：版本升级将会区分新增、修复等内容的前缀，更加便于区分");
            item.Items.Add("变更：版本计数方式更改，将年份月份段放在第三段，修正版本放在最后一段");
            item.Items.Add("修复：二级目录操作无法统计到常用数据表中");
            item.Items.Add("修复：二级目录中出现非标准目录");
            gszAppUpdateInfo.Add(item);
        }

        private void AddUpdate_1_04_16_0107() {
            UpdateInfoItem item = new UpdateInfoItem();
            item.Version = "1.04.16.0107";
            item.Items.Add("更改版本计数方式，将年份段放在第三段，月份和修正版本放在最后一段");
            item.Items.Add("增加DS脚本在保存中事件的交互性，停止使用原UI中的AZS保存事件");
            item.Items.Add("修改UI界面中的保存脚本信息存储为数据库方式，替代原本的文本方式");
            item.Items.Add("增加数据字段选择性保存项，控制数据在保存时进行选择性保存，增加数据安全性和完整性控制");
            item.Items.Add("增加数据字段唯一性选项和验证");
            item.Items.Add("增加数据字段二维表格专有信息");
            item.Items.Add("增加数据字段绑定信息定义，取代原有的AzSql脚本绑定模式");
            gszAppUpdateInfo.Add(item);
        }

        private void AddUpdate_1_04_006_1512() {
            UpdateInfoItem item = new UpdateInfoItem();
            item.Version = "1.04.006.1512";
            item.Items.Add("解决独立授权客户出现的脚本错误的问题");
            item.Items.Add("修复因使用新脚本库而导致的兼容性问题");
            item.Items.Add("增加全新的HTML编辑器，并在UI界面中增加HTML类型控件");
            item.Items.Add("修改UI编辑属性为大小写不敏感，降低其编辑难度");
            gszAppUpdateInfo.Add(item);
        }

        private void AddUpdate_1_04_005_1512() {
            UpdateInfoItem item = new UpdateInfoItem();
            item.Version = "1.04.005.1512";
            item.Items.Add("使用全新的Ver1.03.1512版本XKits脚本库");
            item.Items.Add("增加DHTML服务器套件，在部分表格中进行尝试性使用");
            item.Items.Add("增加系统信息实时提醒功能");
            item.Items.Add("更改心跳交互的核心工作方式，具有登陆状态提醒功能");
            item.Items.Add("增加DS脚本关联，二维表格可通过直接点击关联执行脚本");
            item.Items.Add("修复云文件无法显示图标并显示无法打开的问题");
            gszAppUpdateInfo.Add(item);
        }

        private void AddUpdate_1_04_004_1512() {
            UpdateInfoItem item = new UpdateInfoItem();
            item.Version = "1.04.004.1512";
            item.Items.Add("修复筛选异常的问题");
            item.Items.Add("重新定义类文件存储方式");
            item.Items.Add("添加二维表格默认筛选功能，允许用户打开二维表格时进行自动数据筛选");
            gszAppUpdateInfo.Add(item);
        }

        private void AddUpdate_1_04_003_1512() {
            UpdateInfoItem item = new UpdateInfoItem();
            item.Version = "1.04.003.1512";
            item.Items.Add("引入全新的执行化DS脚本引擎，逐步替代原有的段式AZS脚本系统");
            item.Items.Add("美化表单UI的输入框和选择框");
            item.Items.Add("修改了历代版本遗留的小问题");
            item.Items.Add("清除了一批已经过期的页面");
            gszAppUpdateInfo.Add(item);
        }

        private void AddUpdate_1_04_002_1512() {
            UpdateInfoItem item = new UpdateInfoItem();
            item.Version = "1.04.002.1512";
            item.Items.Add("增加目录类型，使系统目录为不同用途提供分类");
            item.Items.Add("增加了关于中的产品商标");
            item.Items.Add("修改二维表格中的\"我的应用\"为\"数据管理\"");
            item.Items.Add("修复了1.04.001.1512版本更新后界面设计无法使用的问题");
            item.Items.Add("修复了1.04.001.1512版本更新后上传无法使用的问题");
            item.Items.Add("修复了1.04.001.1512版本更新后数据筛选无法使用的问题");
            item.Items.Add("修复了1.04.001.1512版本更新后数据排序无法使用的问题");
            item.Items.Add("修复了1.04.001.1512版本更新后数据无法删除的问题");
            item.Items.Add("修复了主页脚本错误的问题");
            item.Items.Add("修复了主页出现异常竖向滚动条的问题");
            gszAppUpdateInfo.Add(item);
        }

        private void AddUpdate_1_04_001_1512() {
            UpdateInfoItem item = new UpdateInfoItem();
            item.Version = "1.04.001.1512";
            item.Items.Add("重新定义底层数据为三层构建方式，分别为系统数据层、基础数据层和分支数据层，为大容量数据提供兼容性方案");
            item.Items.Add("重新定义系统整体的加载引导方式，弱化OA主导，增加插件处理优先级，增强系统界面表现力，进一步扩展系统的可适用范围");
            item.Items.Add("使用全新的\"主页\"代替原本的\"我的应用\"，页面元素更加丰富");
            item.Items.Add("增加系统消息的全局性");
            item.Items.Add("使用全新安装向导组合页面代替原来的安装界面");
            item.Items.Add("平台名称修改为云谊通数据管理平台");
            item.Items.Add("增强平台授权验证，防止第三方恶意连接");
            item.Items.Add("增加多服务器数据库设置，每个授权对象可独立设置数据库服务器，直接兼容服务器集群、跨地区数据中心");
            item.Items.Add("使用全新的蓝调登录界面，默认使用蓝调背景");
            item.Items.Add("新增一批默认背景图片");
            item.Items.Add("增加专用OA数据管理应用，并增加目录概念");
            gszAppUpdateInfo.Add(item);
        }

        private void AddUpdate_1_03_004_1511() {
            UpdateInfoItem item = new UpdateInfoItem();
            item.Version = "1.03.004.1511";
            item.Items.Add("更改版本号计数格式，还原1.03.002.1511版本的计数方式");
            item.Items.Add("增加插件概念，将所有的数据库配置和界面设计文件存储到同一个插件文件夹中，增强系统的可移植性");
            item.Items.Add("增加表格类型新概念，每一种表格类型可单独指向一个处理应用，增加表现界面的多样性，增强系统的可扩展性");
            item.Items.Add("修改了部分兼容性参数");
            item.Items.Add("增加了三级分销界面");
            item.Items.Add("修正了交互信息容易混淆的问题");
            gszAppUpdateInfo.Add(item);
        }

        private void AddUpdate_1_03_1511_0603() {
            UpdateInfoItem item = new UpdateInfoItem();
            item.Version = "1.03.003.1511";
            item.Items.Add("更改版本号计数格式，新增时间戳精确到日期");
            item.Items.Add("增加数据库配置文件的识别及版本接口");
            item.Items.Add("增加数据库管理的扩展信息兼容");
            item.Items.Add("增加数据库管理版本命名方式");
            item.Items.Add("优化配置文件存储方式，使文件存储更集中");
            item.Items.Add("增加部分功能的日志记录");
            gszAppUpdateInfo.Add(item);
        }

        private void AddUpdate_1_03_002_1511() {
            UpdateInfoItem item = new UpdateInfoItem();
            item.Version = "1.03.002.1511";
            item.Items.Add("增加了授权识标，向一体化平台迈进");
            item.Items.Add("修正了客户端中文件管理器点击弹出空白页的问题");
            item.Items.Add("去掉了加载动画中的联谊字样，加强系统的定制性");
            gszAppUpdateInfo.Add(item);
        }

        private void AddUpdate_1_03_001_1510() {
            UpdateInfoItem item = new UpdateInfoItem();
            item.Version = "1.03.001.1510";
            item.Items.Add("更改版本号计数格式为四段，新增一段为时间戳");
            item.Items.Add("增加了系统加载动画，动画内放置企业商标");
            item.Items.Add("增加了登录验证码，以增强系统安全性");
            item.Items.Add("增加了全新的XKits脚本库");
            item.Items.Add("增加了全新的系统图标");
            gszAppUpdateInfo.Add(item);
        }

        private void AddUpdate_1_02_003() {
            UpdateInfoItem item = new UpdateInfoItem();
            item.Version = "1.02.003";
            item.Items.Add("增加了展示性公司网站模块");
            item.Items.Add("修正了上传无法正常辨认当前用户的问题");
            item.Items.Add("修正了分页无法正常显示内容的问题");
            item.Items.Add("增加了商城模块");
            gszAppUpdateInfo.Add(item);
        }

        private void AddUpdate_1_02_002() {
            UpdateInfoItem item = new UpdateInfoItem();
            item.Version = "1.02.002";
            item.Items.Add("进一步优化了内核代码");
            item.Items.Add("增加列表中快速勾选操作功能，优化二选一值的处理方式");
            item.Items.Add("增加对话框交互中关闭的功能，设置添加和修改后默认关闭对话框");
            item.Items.Add("优化了脚本虚拟机的解析过程，修复了部分解析存在的问题");
            gszAppUpdateInfo.Add(item);
        }

        private void AddUpdate_1_02_001() {
            UpdateInfoItem item = new UpdateInfoItem();
            item.Version = "1.02.001";
            item.Items.Add("使用全新的Card界面，与原有界面共存");
            item.Items.Add("增加微信公众平台支持");
            item.Items.Add("升级为HTML5代码模式");
            item.Items.Add("增加平台通用性，增加手机操作界面，兼容鼠标、触屏和各类尺寸");
            item.Items.Add("增加独立工具栏");
            item.Items.Add("增加交互中的调试输出");
            item.Items.Add("增加交互Session的兼容性");
            item.Items.Add("支持更多浏览器");
            item.Items.Add("添加专用数据库管理应用，替代原本的页面方式");
            item.Items.Add("将原本页面方式的文件管理器及编辑器转化为应用模式");
            item.Items.Add("优化系统表处理方案");
            item.Items.Add("增加对话框的移动和直接关闭功能");
            item.Items.Add("增加\"关于本产品\"应用，用于向用户提供详尽的开发信息、激活信息及更新日志");
            item.Items.Add("增强OA插件的交互性，增加了统一交互接口");
            item.Items.Add("优化配置文件存储结构，使之更具扩展性和可移植性");
            item.Items.Add("修正了Ajax无法二次脚本加载的问题");
            item.Items.Add("使用全新的筛选图标及筛选界面");
            item.Items.Add("增加表格内容排序功能");
            gszAppUpdateInfo.Add(item);
        }

        private void AddUpdate_1_01_004() {
            UpdateInfoItem item = new UpdateInfoItem();
            item.Version = "1.01.004";
            item.Items.Add("增加页面快速搜索功能");
            item.Items.Add("增加聊天表情");
            item.Items.Add("过滤尖括号，增加聊天安全性");
            item.Items.Add("升级聊天，增加类型属性");
            item.Items.Add("增加聊天文件发送");
            item.Items.Add("增加内容查看功能");
            item.Items.Add("增加数据筛选功能");
            gszAppUpdateInfo.Add(item);
        }

        private void AddUpdate_1_01_005() {
            UpdateInfoItem item = new UpdateInfoItem();
            item.Version = "1.01.005";
            item.Items.Add("统一字符串连接读取方式");
            gszAppUpdateInfo.Add(item);
        }

        /// <summary>
        /// 升级信息
        /// </summary>
        public List<UpdateInfoItem> Items { get { return gszAppUpdateInfo; } }

    }

}

