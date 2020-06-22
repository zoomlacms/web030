using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using ZoomLa.BLL;
using ZoomLa.Common;
using ZoomLa.Model;
using ZoomLa.Sns;
using ZoomLa.SQLDAL;

public partial class Extend_Common_Store : System.Web.UI.Page
{
    B_Ex_Store stBll = new B_Ex_Store();
    B_User buser = new B_User();
    M_UserInfo mu = null;
    protected void Page_Load(object sender, EventArgs e)
    {
        B_User.CheckIsLogged(Request.RawUrl);
        mu = buser.GetLogin();
        if (!IsPostBack)
        {
            DataRow dr = stBll.SelReturnModel(mu.PageID);
            if (dr != null)
            {
                StoreName_T.Text = DataConvert.CStr(dr["StoresName"]);
                Save_Btn.Text = "请等待管理员审核";
                Save_Btn.Attributes["disabled"] = "disabled";
            }
            else { StoreName_T.Text = B_User.GetUserName(mu.HoneyName, mu.UserName) + "的店铺"; }
        }
    }

    protected void Save_Btn_Click(object sender, EventArgs e)
    {
        DataRow dr = stBll.SelReturnModel(mu.PageID);
        if (dr == null) { dr = stBll.NewModel(); }
        dr["StoresName"] = StoreName_T.Text.Trim();
        dr["djid"] = mu.UserID;
        if (DataConvert.CLng(dr["ID"]) > 0)
        {
            stBll.UpdateById(dr);
        }
        else
        {
            mu.PageID = stBll.Insert(dr);
            buser.UpdateByID(mu);
        }
        string url = "";
        if (ExHelper.IsUser(mu.GroupID)) { url = "/Class_38/Default.aspx"; }
        else if (ExHelper.IsTeacher(mu.GroupID)) { url = "/Extend/Teacher/Default.aspx"; }
        function.WriteSuccessMsg("已提交申请,请等待管理员审核", "");
    }
    //public string GetUrl(M_UserInfo mu)
    //{
    //    string url = "";
    //    if (mu.GroupID == (int)ExOrder.Group.家长) { url = "/"; }
    //    else if (mu.GroupID == (int)ExOrder.Group.老师) { }
    //    else { }
    //    return url;
    //}
}