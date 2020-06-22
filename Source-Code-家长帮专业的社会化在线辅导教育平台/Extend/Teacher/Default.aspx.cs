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

public partial class Extend_Teacher_Default : System.Web.UI.Page
{
    B_User buser = new B_User();
    B_Ex_Teacher teaBll = new B_Ex_Teacher();
    public M_UserInfo mu = null;
    public int Gid = 0;
    protected void Page_Load(object sender, EventArgs e)
    {
        B_User.CheckIsLogged(Request.RawUrl);
        mu = buser.GetLogin();
        if (mu.GroupID == (int)ExOrder.Group.家长) { Response.Redirect("/Class_38/Default.aspx");return; }
        if (!IsPostBack)
        {
            //通过审核后,status=99
            DataRow dr = teaBll.SelByUid(mu.UserID);
            if (dr == null) { Status_L.Text = "<span style='color:red;'>未提交资料</span>"; }
            else if (DataConvert.CLng(dr["Status"]) != 99) { Status_L.Text = "<span style='color:orange;'>待审核</span>"; }
            else if (DataConvert.CLng(dr["status"]) == 99)
            {
                Status_L.Text = "<span style='color:#fff;'>已审核</span>";
                Status_L.Text += "<a href='/Item/"+dr["GeneralID"]+ ".aspx' class='weui-btn weui-btn_mini weui-btn_primary' target='_blank' style='position:absolute;margin-left:10px;margin-top:-5px;'><i class='zi zi_eye'></i> 个人主页</a>";
            }
            if (dr != null) { Gid = DataConvert.CLng(dr["GeneralID"]); }

            string tlp = "<a href=\"{0}\"><i class=\"zi zi_storealt\"></i>{1}<small><i class=\"zi zi_pathRight\"></i></small></a>";
            if (mu.PageID < 1)
            {
                store_l.Text = string.Format(tlp,"/Extend/Common/Store.aspx", "申请成为店家");
            }
            else
            {
                B_Ex_Store stBll = new B_Ex_Store();
                DataRow storeDR = stBll.SelReturnModel(mu.PageID);
                if (DataConvert.CLng(storeDR["dpzt"]) == 99) { store_l.Text = string.Format(tlp, "/Extend/Store/Default.aspx", "店铺管理"); }
                else { store_l.Text = string.Format(tlp, "javascript:;", "店铺管理<span style='color:red;'>(待审核)</span>"); }
            }
        }
    }
}