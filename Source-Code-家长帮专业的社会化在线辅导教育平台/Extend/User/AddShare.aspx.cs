using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using ZoomLa.BLL;
using ZoomLa.BLL.Shop;
using ZoomLa.Common;
using ZoomLa.Model;
using ZoomLa.Model.Shop;
using ZoomLa.Sns;
using ZoomLa.SQLDAL;

public partial class Extend_User_AddShare : System.Web.UI.Page
{
    B_Order_Share shareBll = new B_Order_Share();
    B_User buser = new B_User();
    M_UserInfo mu = null;
    
    public int OrderID { get { return DataConvert.CLng(Request.QueryString["OrderID"]); } }
    protected void Page_Load(object sender, EventArgs e)
    {
        B_User.CheckIsLogged(Request.RawUrl);
        mu = buser.GetLogin();
        if (!IsPostBack)
        {
            DataRow dr = ExOrder.SelReturnModel(OrderID);
            if (dr == null) { function.WriteErrMsg("订单不存在"); }
            if (DataConvert.CLng(dr["xsrid"]) != mu.UserID) { function.WriteErrMsg("你无权访问该订单"); }
            if (DataConvert.CLng(dr["status_order"]) != 99) { function.WriteErrMsg("订单不允许评价"); }
            Title_T.Text = DataConvert.CStr(dr["spmc"]);
            //订单成功,且未完结,且未评论或最近一次的评论超过(7*24*60),则可评
            DataTable shareDT = DBCenter.SelTop(1, "ID", "*", "ZL_Order_Share", "ProID=" + dr["nrgid"] + " AND UserID=" + mu.UserID, "ID DESC");
            if (shareDT.Rows.Count > 0)
            {
                DateTime last = Convert.ToDateTime(shareDT.Rows[0]["CDate"]);
                if ((DateTime.Now - last).TotalMinutes < (7 * 24 * 60))
                {
                    Save_Btn.Visible = false;
                    tip_div.Visible = true;
                    tip_div.InnerHtml = "你最近一次评论时间:" + last.ToString("yyyy年MM月dd日 HH:mm") + ",必须一周后才可再评论";
                }
            }
        }
    }


    protected void Save_Btn_Click(object sender, EventArgs e)
    {

        DataRow dr = ExOrder.SelReturnModel(OrderID);
        if (dr == null) { function.WriteErrMsg("订单不存在"); }

        M_Order_Share shareMod = new M_Order_Share();
        shareMod.Title = Request.Form["Title_T"];
        shareMod.MsgContent = Request.Form["MsgContent_T"];
        shareMod.UserID = mu.UserID;
        shareMod.IsAnonymous = string.IsNullOrEmpty(Request.Form["IsHideName"]) ? 0 : 1;
        shareMod.Score = DataConverter.CLng(Request.Form["star_hid"]);
        if (shareMod.Score > 5) { shareMod.Score = 5; }
        shareMod.Imgs = Request.Form["Attach_Hid"];
        shareMod.Labels = "";
        shareMod.OrderID = OrderID;
        shareMod.ProID = DataConvert.CLng(dr["nrgid"]);//老师ID
        shareMod.OrderDate = DataConvert.CDate(dr["PubAddTime"]);
        shareBll.Insert(shareMod);
        dr["commentDate"] = DateTime.Now;
        ExOrder.UpdateById(dr);
        function.WriteSuccessMsg("评价成功,将跳转至详情页", "/Item/" + shareMod.ProID + ".aspx");
    }
}