using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using ZoomLa.BLL;
using ZoomLa.Sns;
using ZoomLa.SQLDAL;
using ZoomLa.SQLDAL.SQL;

public partial class Extend_Admin_Store : System.Web.UI.Page
{
    B_Ex_Store stBll = new B_Ex_Store();
    protected void Page_Load(object sender, EventArgs e)
    {
        //因为有推荐等关系,所以店铺不允许删除,只可取消审核
        RPT.SPage = MyBind;
        if (!IsPostBack)
        {
            RPT.DataBind();
        }
    }
    private DataTable MyBind(int psize,int cpage)
    {
        PageSetting setting = stBll.SelPage(cpage, psize, new Com_Filter()
        {
            skey = skey_t.Text.Trim(),
            status = DataConvert.CStr(Request["status"])
        });
        RPT.ItemCount = setting.itemCount;
        return setting.dt;
    }

    protected void RPT_ItemCommand(object source, RepeaterCommandEventArgs e)
    {
        switch (e.CommandName)
        {
            case "audit":
                stBll.UpdateStatus(e.CommandArgument.ToString(),99);
                RPT.DataBind();
                break;
            case "unaudit":
                stBll.UpdateStatus(e.CommandArgument.ToString(), 0);
                RPT.DataBind();
                break;
        }
    }

    public string ShowStatus()
    {
        int s = DataConvert.CLng(Eval("dpzt"));
        if (s == 0) { return "待审核"; }
        else if (s == 99) { return "<span style='color:green;'>已审核</span>"; }
        else { return s.ToString(); }
    }

    protected void skey_btn_Click(object sender, EventArgs e)
    {
        RPT.DataBind();
    }
}