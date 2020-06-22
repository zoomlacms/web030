using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using ZoomLa.BLL;
using ZoomLa.Common;
using ZoomLa.Model;
using ZoomLa.Sns;
using ZoomLa.SQLDAL;

public partial class Extend_YJPay : System.Web.UI.Page
{
    B_User buser = new B_User();
    B_CartPro cpBll = new B_CartPro();
    B_OrderList orderBll = new B_OrderList();
    B_Payment payBll = new B_Payment();
    public int Mid { get { return DataConvert.CLng(Request.QueryString["ID"]); } }
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            M_UserInfo mu = buser.GetLogin();
            DataRow dr = ExOrder.SelReturnModel(Mid);
            int user = DataConvert.CLng(dr["status_user"]);
            int teacher = DataConvert.CLng(dr["status_teacher"]);
            if (mu.IsNull) { function.WriteErrMsg("用户未登录"); }
            if (DataConvert.CLng(dr["status_money"]) == 1) { function.WriteErrMsg("订单已支付过佣金"); }
            if (teacher !=(int)ExConast.Order_Teacher.签约成功) { function.WriteErrMsg("订单状态不正确"); }
            //-----------------生成支付单
            //检测是否已有支付单
            DataTable payDT = DBCenter.Sel(payBll.TbName,"code='"+ Mid + "'","PaymentID DESC");
            if (payDT.Rows.Count > 0)
            {
                M_Payment payMod = payBll.SelReturnModel(Convert.ToInt32(payDT.Rows[0]["PaymentID"]));
                if (payMod.Status == (int)M_Payment.PayStatus.HasPayed) { function.WriteErrMsg("支付单已付过款"); }
                Response.Redirect("/Payonline/OrderPay.aspx?payno=" + payMod.PayNo);
            }
            else
            {
                M_OrderList orderMod = orderBll.NewOrder(mu, M_OrderList.OrderEnum.Normal);
                orderMod.Ordersamount = PlugConfig.Instance.Order_YJ;
                orderMod.Specifiedprice = PlugConfig.Instance.Order_YJ;
                orderMod.Balance_price = PlugConfig.Instance.Order_YJ;
                orderMod.Money_code = Mid.ToString();
                orderMod.id = orderBll.insert(orderMod);
                M_CartPro cpMod = new M_CartPro();
                cpMod.Orderlistid = orderMod.id;
                cpMod.Proname = "佣金";
                cpMod.Pronum = 1;
                cpMod.Shijia = orderMod.Ordersamount;
                cpMod.UserID = mu.UserID;
                cpMod.Username = mu.UserName;
                cpMod.ID = cpBll.GetInsert(cpMod);
                M_Payment payMod = payBll.CreateByOrder(orderMod);
                payMod.code = Mid.ToString();
                payMod.PaymentID = payBll.Add(payMod);
                //进去支付界面
                Response.Redirect("/Payonline/OrderPay.aspx?payno=" + payMod.PayNo);
            }
        }
    }
}