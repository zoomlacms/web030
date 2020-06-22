using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using ZoomLa.BLL;
using ZoomLa.BLL.Helper;
using ZoomLa.Common;
using ZoomLa.Model;
using ZoomLa.Sns;

public partial class Extend_User_MyTeacher : System.Web.UI.Page
{
    /*
     * 1.根据用户所关联的有效订单,抽出当前/以前的老师信息
     * *订单如何判断是否在有效期内
     */
    B_User buser = new B_User();
    B_Ex_Teacher teaBll = new B_Ex_Teacher();
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            M_UserInfo mu = buser.GetLogin();
            DataTable nowDT = ExOrder.SelPage(1, int.MaxValue, new F_Order()
            {
                uid = mu.UserID,
                s_order = "99"
            }).dt;
            DataTable hisDT = ExOrder.SelPage(1, int.MaxValue, new F_Order()
            {
                uid = mu.UserID,
                s_order = "100"
            }).dt;
            {
                string uids = StrHelper.GetIDSFromDT(nowDT, "spfbrid");
                if (string.IsNullOrEmpty(uids)) { uids = "-1"; }
                DataTable dt = teaBll.SelPage(new F_Teacher() { uids = uids });
                RPT.DataSource = dt;
                RPT.DataBind();
                if (dt.Rows.Count < 1) { function.Script(this,"$('#empty1').show();"); }
            }
            {
                string uids = StrHelper.GetIDSFromDT(hisDT, "spfbrid");
                if (string.IsNullOrEmpty(uids)) { uids = "-1"; }
                DataTable dt = teaBll.SelPage(new F_Teacher() { uids = uids });
                RPT2.DataSource = dt;
                RPT2.DataBind();
                if (dt.Rows.Count < 1) { function.Script(this, "$('#empty2').show();"); }
            }
        }
    }
}