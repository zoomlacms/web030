using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using ZoomLa.BLL;
using ZoomLa.Common;
using ZoomLa.Components;
using ZoomLa.Model;
using ZoomLa.Sns;

public partial class Extend_Store_Default : System.Web.UI.Page
{
    B_User buser = new B_User();
    B_Ex_Store stBll = new B_Ex_Store();
    public M_UserInfo mu = null;
    protected void Page_Load(object sender, EventArgs e)
    {
        B_User.CheckIsLogged(Request.RawUrl);
        mu = buser.GetLogin();
        if (!IsPostBack)
        {
            if (mu.PageID < 1) { Response.Redirect("/Extend/Common/Store.aspx"); }
            DataRow dr = stBll.SelReturnModel(mu.PageID);
            if (dr == null) { function.WriteErrMsg("店铺信息不存在"); }
            if (DataConverter.CLng(dr["dpzt"]) != 99) { function.WriteErrMsg("店铺尚未审核"); }
        }
    }
    public string GetTGUrl()
    {
        string url= SiteConfig.SiteInfo.SiteUrl+"/?puid="+mu.UserID;
        return HttpUtility.UrlEncode(url) + "&img=" + HttpUtility.UrlEncode(SiteConfig.SiteInfo.LogoUrl);
    }
}