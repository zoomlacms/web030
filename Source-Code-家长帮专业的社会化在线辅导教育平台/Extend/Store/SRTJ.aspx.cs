using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using ZoomLa.BLL;
using ZoomLa.Common;
using ZoomLa.Model;
using ZoomLa.Sns;
using ZoomLa.SQLDAL;
using ZoomLa.SQLDAL.SQL;

public partial class Extend_Store_SRTJ : System.Web.UI.Page
{
    B_User buser = new B_User();
    M_UserInfo mu = null;
    B_Ex_SRTJ srBll = new B_Ex_SRTJ();
    protected void Page_Load(object sender, EventArgs e)
    {
        mu = buser.GetLogin();
        RPT.SPage = MyBind;
        if (!IsPostBack)
        {
            RPT.DataBind();
        }
    }
    public DataTable MyBind(int psize, int cpage)
    {
        F_SRTJ filter = new F_SRTJ() { uids = mu.UserID.ToString() };
        PageSetting setting = srBll.SelPage(cpage, psize, filter);
        RPT.ItemCount = setting.itemCount;
        in_l.Text = filter.r_moneyIn.ToString("F2");
        out_l.Text = filter.r_moneyOut.ToString("F2");
        total_l.Text = filter.r_moneyTotal.ToString("F2");
        if (setting.itemCount < 1)
        { function.Script(this, "$('#empty1').show();"); rpt_wrap.Visible = false; }
        return setting.dt;
    }
}