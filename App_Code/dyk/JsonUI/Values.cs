using System;
using System.Collections.Generic;
using System.Web;

namespace dyk.JsonUI {

  /// <summary>
  /// Values 的摘要说明
  /// </summary>
  public class Values {

    private string gszName;
    private dyk.Format.Json gJson;

    public Values(string name) {
      //
      // TODO: 在此处添加构造函数逻辑
      //
      gszName = name;
      //gszValue = "";
      gJson = new Format.Json();
    }

    public Values(string name, string value) {
      gszName = name;
      gJson = new Format.Json(value);
    }

    /// <summary>
    /// 获取识标符
    /// </summary>
    public string ID { get { return gszName; } }

    /// <summary>
    /// 获取Json对象
    /// </summary>
    public dyk.Format.JsonObject JsonObject { get { return gJson; } }
  }

}