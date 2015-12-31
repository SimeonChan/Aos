using System;
using System.Collections.Generic;
using System.Web;

/// <summary>
/// Site 的摘要说明
/// </summary>
public class ClsSite {


    public const string AppName = "云谊通数据管理平台 - 基于 Azalea Web OS 技术构架";

    public const string AppKernelName = "Azalea Web OS";
    //public const string AppKernel = AppKernelName + " [Version:" + AppVersion + "]";
    public const string AppKernelUrl = "http://www.azlos.com";

    public const string AppAuSN = "068F-6695-D63C-96AA";
    public const string AppAuCompany = "温岭联谊网络科技有限公司";
    public const string AppAuType = "通用版(含文件云、OA、网站管理等)";

    public const string AppProduceName = "云谊通数据管理平台";
    public const string AppProduceCompany = "温岭联谊网络科技有限公司";
    public const string AppProduceCompanyUrl = "http://www.lianyi.biz";

    public const string AppTechnicalSupport = "联谊网络科技";
    public const string AppTechnicalUrl = "http://www.lywos.com";

    /// <summary>
    /// 获取网站程序版本
    /// </summary>
    public static string AppVersion
    {
        get
        {
            dyk.WebSite.UpdateInfo ui = new dyk.WebSite.UpdateInfo();
            return ui.Items[0].Version;
        }
    }

    /// <summary>
    /// 获取网站内核信息
    /// </summary>
    public static string AppKernel
    {
        get
        {
            return AppKernelName + " [Version:" + AppVersion + "]";
        }
    }

    public ClsSite() {
        //
        // TODO: 在此处添加构造函数逻辑
        //

        //gszAppUpdateInfo = "";
        //gszAppUpdateInfo += "Ver 1.02.001\n";
        //gszAppUpdateInfo += "1、使用全新的Card界面，与原有界面共存\n";
        //gszAppUpdateInfo += "2、增加微信公众平台支持\n";
        //gszAppUpdateInfo += "3、升级为HTML5代码模式\n";
        //gszAppUpdateInfo += "4、增加平台通用性，增加手机操作界面，兼容鼠标、触屏和各类尺寸\n";
        //gszAppUpdateInfo += "5、增加独立工具栏\n";
        //gszAppUpdateInfo += "6、增加交互中的调试输出\n";
        //gszAppUpdateInfo += "7、增加交互Session的兼容性\n";
        //gszAppUpdateInfo += "8、支持更多浏览器\n";
        //gszAppUpdateInfo += "9、添加专用数据库管理应用\n";
        //gszAppUpdateInfo += "10、将原本页面方式的文件管理器及编辑器转化为应用模式\n";
        //gszAppUpdateInfo += "11、优化系统表处理方案\n";
        //gszAppUpdateInfo += "12、增加对话框的移动和直接关闭功能\n";
        //gszAppUpdateInfo += "\n";
        //gszAppUpdateInfo += "Ver 1.01.005\n";
        //gszAppUpdateInfo += "1、统一字符串连接读取方式\n";
        //gszAppUpdateInfo += "\n";
        //gszAppUpdateInfo += "Ver 1.01.004\n";
        //gszAppUpdateInfo += "1、增加页面快速搜索功能\n";
        //gszAppUpdateInfo += "2、增加聊天表情\n";
        //gszAppUpdateInfo += "3、过滤尖括号，增加聊天安全性\n";
        //gszAppUpdateInfo += "4、升级聊天，增加类型属性\n";
        //gszAppUpdateInfo += "5、增加聊天文件发送\n";
        //gszAppUpdateInfo += "6、增加内容查看功能\n";
        //gszAppUpdateInfo += "7、增加数据筛选功能\n";
    }

}