using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using ZoomLa.BLL;
using ZoomLa.Model;
using ZoomLa.Sns;
using ZoomLa.SQLDAL;

public partial class Extend_User_Default : System.Web.UI.Page
{
    B_User buser = new B_User();
    B_Ex_User userBll = new B_Ex_User();
    public M_UserInfo mu = null;
    public int Gid = 0;
    protected void Page_Load(object sender, EventArgs e)
    {
        B_User.CheckIsLogged(Request.RawUrl);
        mu = buser.GetLogin();
        if (ExHelper.IsTeacher(mu.GroupID)) { Response.Redirect("/Extend/Teacher/Default.aspx"); return; }
        Gid = userBll.GetGid(mu.UserID);
        if (!IsPostBack)
        {
            student_empty.Visible = Gid == 0;
            student_ok.Visible = Gid != 0;
            string tlp = "<a href=\"{0}\"><i class=\"zi zi_storealt\"></i>{1}<small><i class=\"zi zi_pathRight\"></i></small></a>";
            if (mu.PageID < 1)
            {
                store_l.Text = string.Format(tlp, "/Extend/Common/Store.aspx", "申请成为店家");
            }
            else
            {
                B_Ex_Store stBll = new B_Ex_Store();
                DataRow storeDR = stBll.SelReturnModel(mu.PageID);
                if (DataConvert.CLng(storeDR["dpzt"]) == 99) { store_l.Text = string.Format(tlp, "/Extend/Store/Default.aspx","店铺管理"); }
                else { store_l.Text = string.Format(tlp, "javascript:;", "店铺管理<span style='color:red;'>(待审核)</span>"); }
            }
        }
    }
}