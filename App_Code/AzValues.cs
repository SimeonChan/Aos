using System;
using System.Collections.Generic;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

/// <summary>
/// AzValues 的摘要说明
/// </summary>
public class AzValues
{
    private Page gOwer;

    public AzValues(Page owner)
    {
        //
        // TODO: 在此处添加构造函数逻辑
        //
        gOwer = owner;
    }

    public string GetLoaction(string name)
    {
        switch (name.Trim().ToLower())
        {
            case "time":
                return Ly.Time.Now.toCommonFormatTimeString;
            case "datetime":
                return Ly.Time.Now.toCommonFormatString;
            case "date":
                return Ly.Time.Now.toCommonFormatDateString;
            default:
                return "";
        }
    }

    public string GetRequest(string name)
    {
        return Pub.Request(gOwer, name.Trim());
    }
}