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

public partial class Extend_Teacher_MyStudent : System.Web.UI.Page
{
     /*
      * 1.老师所接过的订单
      * *订单如何判断是否在有效期内
      */
    B_User buser = new B_User();
    B_Ex_User userBll = new B_Ex_User();

    protected void Page_Load(object sender, EventArgs e)
    {
        B_User.CheckIsLogged(Request.RawUrl);
        if (!IsPostBack)
        {
            M_UserInfo mu = buser.GetLogin();
            //双方均同意,且未完结的订单
            DataTable nowDT = ExOrder.SelPage(1, int.MaxValue, new F_Order()
            {
                tuid = mu.UserID,
                s_order = "99"
            }).dt;
            //双方均同意,且已完结的订单
            DataTable hisDT = ExOrder.SelPage(1, int.MaxValue, new F_Order()
            {
                tuid = mu.UserID,
                s_order = "100"
            }).dt;
            {
               
                string uids = StrHelper.GetIDSFromDT(nowDT, "xsrid");
                if (string.IsNullOrEmpty(uids)) { uids = "-1"; }
                DataTable dt = userBll.SelPage(new Com_Filter() { uids = uids });
                RPT.DataSource = dt;
                RPT.DataBind();
                if (dt.Rows.Count < 1) { function.Script(this, "$('#empty1').show();"); }
            }
            {
                string uids = StrHelper.GetIDSFromDT(hisDT, "xsrid");
                if (string.IsNullOrEmpty(uids)) { uids = "-1"; }
                DataTable dt = userBll.SelPage(new Com_Filter() { uids = uids });
                RPT2.DataSource = dt;
                RPT2.DataBind();
                if (dt.Rows.Count < 1) { function.Script(this, "$('#empty2').show();"); }
            }
        }
    }
}