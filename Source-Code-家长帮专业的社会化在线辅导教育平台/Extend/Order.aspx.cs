using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using ZoomLa.SQLDAL.SQL;
using ZoomLa.Sns;
using ZoomLa.SQLDAL;
using ZoomLa.Model;
using ZoomLa.BLL;
using ZoomLa.Common;

public partial class Extend_Order : System.Web.UI.Page
{
    B_User buser = new B_User();
    public M_UserInfo mu = null;
    //mode==store,显示店家有权查看的订单
    public string Mode { get { return DataConvert.CStr(Request.QueryString["mode"]); } }
    public string Fast
    {
        get
        {
            string fast = Request.QueryString["fast"];
            if (string.IsNullOrEmpty(fast)) { fast = "dcl"; }
            return fast;
        }
    }
    public string BaseUrl
    {
        get
        {
            string url = "Order.aspx?a=1";
            if (!string.IsNullOrEmpty(Mode)) { url += "&mode=" + Mode; }
            return url;
        }
    }
    protected void Page_Load(object sender, EventArgs e)
    {
        /*
         * 1.教师反馈失败后,家长可否继续操作
         * 2.教师反馈后,家长可否继续取消订单
         * 3.双方均反馈成功后,还需进行何种操作
         * 4.教师的佣金
         * 5.店家可进行哪些操作
         */


        //1.有几个角色可访问该页    用户|店家|教师|管理员
        //2.哪个字段用于标识 店家|教师
        //xsrid=家长ID,djid=店家ID,spfbrid=教师ID
        B_User.CheckIsLogged(Request.RawUrl);
        mu = buser.GetLogin();
        RPT.SPage = MyBind;
        if (!IsPostBack)
        {
            if (Mode == "store" && mu.PageID < 1) { function.WriteErrMsg("你无权浏览店铺订单"); }
            RPT.DataBind();
        }
        //new B_Admin().SetLoginState(B_Admin.GetAdminByAdminId(1));
    }
    public DataTable MyBind(int psize, int cpage)
    {
        F_Order filter = new F_Order();
        if (Mode == "store")
        {
            filter.djid = mu.UserID;
        }
        else if (ExHelper.IsTeacher(mu.GroupID))
        {
            filter.tuid = mu.UserID;
        }
        else//默认为家长
        {
            filter.uid = mu.UserID;
        }

        //订单状态筛选
        filter.fast = Fast;
        PageSetting setting = ExOrder.SelPage(cpage,psize,filter);
        RPT.ItemCount = setting.itemCount;
        if (setting.itemCount < 1)
        {
            function.Script(this, "$('#empty1').show();");
        }
        return setting.dt;
    }
    public string ShowHead()
    {
        if (ExHelper.IsUser(mu.GroupID)) { return "用户"; }
        else if (ExHelper.IsTeacher(mu.GroupID)) { return "教师"; }
        else { return ""; }
    }
    //显示老师昵称
    public string ShowTeaName()
    {
        string uname = Eval("sp_uname", "");
        string nick = Eval("sp_hname", "");
        if (!uname.Equals(nick) && !string.IsNullOrEmpty(nick))
        { uname += "/" + nick; }
        return uname;
    }
    public string ShowStatus()
    {
        DataRow dr = (GetDataItem() as DataRowView).Row;
        //return ExOrder.ShowStatusStr(dr);
        return ExOrder.ShowStatusByUser(dr,mu.GroupID);
    }
    public string ShowSEDate()
    {
        string result = Eval("PubAddTime", "");
        if (!string.IsNullOrEmpty(Eval("edate", "")))
        { result += "--" + Eval("edate", ""); }
        return result;
    }
    public string ShowBtns()
    {
        int user = DataConvert.CLng(Eval("status_user"));
        int teacher = DataConvert.CLng(Eval("status_teacher"));
        int order = DataConvert.CLng(Eval("status_order"));
        int money = DataConvert.CLng(Eval("status_money"));
        if (order == (int)ExConast.OrderStatus.取消) { return ""; }
        int id = DataConvert.CLng(Eval("ID"));
        string btnTlp = "<a href=\"javascript:;\" class='btn btn-info btn-sm' onclick=\"{1}\" style='margin-right:5px;margin-bottom:5px;'>{0}</a>";
        string html = "";
        //-----------------------------------------------------
        if (Mode == "store")
        {

        }
        else if (mu.GroupID == (int)ExOrder.Group.家长)
        {
            if (user == 0)
            {
                html += string.Format(btnTlp, "反馈成功", "order.user_sign('success','" + id + "');");
                html += string.Format(btnTlp, "反馈失败", "order.user_sign('fail','" + id + "');");
                html += string.Format(btnTlp.Replace("info", "danger"), "取消订单", "order.user_cancel('" + id + "');");
            }
            //订单成功,且未评论过 teacher == 99 && 
            if (order == (int)ExConast.OrderStatus.签约成功)
            {
                html += string.Format(btnTlp, "订单评价", "location='/Extend/User/AddShare.aspx?OrderID=" + id + "';");
                html += string.Format(btnTlp.Replace("info", "warning"), "结束订单", "order.finish('" + id + "');");
            }
        }
        else if (mu.GroupID == (int)ExOrder.Group.老师)
        {
            if (teacher == 0)
            {
                html += string.Format(btnTlp, "签单成功", "order.teacher_sign('success','" + id + "');");
                html += string.Format(btnTlp, "反馈失败", "order.teacher_sign('fail','" + id + "');");
            }
            if (teacher == (int)ExConast.Order_Teacher.签约成功 && money == 0)
            { html += "<a href =\"/Extend/YJPay.aspx?ID=" + id + "\" class='btn btn-info btn-sm' style='margin-bottom:5px;'>支付佣金</a>"; }
        }
        return html;
    }
    protected void mybind_btn_Click(object sender, EventArgs e)
    {
        RPT.DataBind();
    }
}