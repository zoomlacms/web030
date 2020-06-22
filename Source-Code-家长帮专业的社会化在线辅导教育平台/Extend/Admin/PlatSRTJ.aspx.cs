using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using ZoomLa.BLL;
using ZoomLa.BLL.CreateJS;
using ZoomLa.Sns;
using ZoomLa.SQLDAL;
using ZoomLa.SQLDAL.SQL;

public partial class Extend_Admin_PlatSRTJ : System.Web.UI.Page
{
    B_Ex_PlatSR srBll = new B_Ex_PlatSR();
    protected void Page_Load(object sender, EventArgs e)
    {
        RPT.SPage = MyBind;
        if (!IsPostBack)
        {
            RPT.DataBind();
        }
    }
    public DataTable MyBind(int psize, int cpage)
    {
        PageSetting setting = srBll.SelPage(cpage, psize, new F_SRTJ()
        {
            skey = skey_t.Text,
            sdate = sdate_t.Text,
            edate = edate_t.Text
        });
        RPT.ItemCount = setting.itemCount;
        return setting.dt;
    }

    protected void skey_btn_Click(object sender, EventArgs e)
    {
        RPT.DataBind();
    }

    protected void RPT_ItemCommand(object source, RepeaterCommandEventArgs e)
    {

    }
}
