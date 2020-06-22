using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using ZoomLa.Sns;
using ZoomLa.SQLDAL;
using ZoomLa.SQLDAL.SQL;

public partial class Extend_Admin_SRTJ : System.Web.UI.Page
{
    B_Ex_SRTJ srBll = new B_Ex_SRTJ();
    public int UserID { get { return DataConvert.CLng(Request.QueryString["UserID"]); } }
    protected void Page_Load(object sender, EventArgs e)
    {
        RPT.SPage = MyBind;
        if (!IsPostBack)
        {
            RPT.DataBind();
        }
    }
    public DataTable MyBind(int psize,int cpage)
    {
        F_SRTJ filter = new F_SRTJ();
        filter.uids = UserID.ToString();
        filter.skey = skey_t.Text;
        PageSetting setting = srBll.SelPage(cpage,psize,filter);
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