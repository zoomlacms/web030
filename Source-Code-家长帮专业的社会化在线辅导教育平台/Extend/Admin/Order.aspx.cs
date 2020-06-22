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

public partial class Extend_Admin_Order : System.Web.UI.Page
{

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
        F_Order filter = new F_Order();
        PageSetting setting = ExOrder.SelPage(cpage, psize, filter);
        RPT.ItemCount = setting.itemCount;
        return setting.dt;
    }
    public string ShowStatus()
    {
        DataRow dr = (GetDataItem() as DataRowView).Row;
        return ExOrder.ShowStatusStr(dr);
    }
    protected void mybind_btn_Click(object sender, EventArgs e)
    {
        RPT.DataBind();
    }
    public bool ShowBtn(string type)
    {
        int user = DataConvert.CLng(Eval("status_user"));
        int teacher = DataConvert.CLng(Eval("status_teacher"));
        if (type == "user") { return !(user == (int)ExConast.Order_User.签约成功); }
        else if (type == "teacher") { return !(teacher == (int)ExConast.Order_Teacher.签约成功); }
        else { return false; }
    }
    protected void RPT_ItemCommand(object source, RepeaterCommandEventArgs e)
    {
        int id = DataConvert.CLng(e.CommandArgument);
        if (id < 1) { return; }
        switch (e.CommandName)
        {
            case "user":
                ExOrder.Sign_User(id,"success");
                break;
            case "teacher":
                ExOrder.Sign_Teacher(id, "success");
                break;
        }
        RPT.DataBind();
    }
}