using System;
using System.Collections.Generic;
using System.Data.Common;
using System.Data.SqlClient;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using ZoomLa.BLL;
using ZoomLa.BLL.Other;
using ZoomLa.Common;
using ZoomLa.Components;
using ZoomLa.Model;
using ZoomLa.SQLDAL;

public partial class Extend_Common_WithDraw_Add : System.Web.UI.Page
{
    B_User buser = new B_User();
    B_Cash cashBll = new B_Cash();
    B_User_Bank bankBll = new B_User_Bank();
    protected void Page_Load(object sender, EventArgs e)
    {
        M_UserInfo mu = buser.GetLogin(false);
        double money = Convert.ToDouble(Request.Form["Money_T"]);
        double fee = SiteConfig.UserConfig.WD_FeePrecent > 0 ? (money * (SiteConfig.UserConfig.WD_FeePrecent / 100)) : 0;
        string shortPwd = Request.Form["ShortPwd_T"];
        if (money < 1) { function.WriteErrMsg("提现金额错误,不能小于1"); return; }
        if (money < SiteConfig.UserConfig.WD_Min) { function.WriteErrMsg("提现金额必须>=[" + SiteConfig.UserConfig.WD_Min + "]"); return; }
        if (SiteConfig.UserConfig.WD_Max > 0 && money > SiteConfig.UserConfig.WD_Max)
        {
            function.WriteErrMsg("提现金额必须小于[" + SiteConfig.UserConfig.WD_Max + "]");
            return;
        }
        if (SiteConfig.UserConfig.WD_Multi > 0 && (money % SiteConfig.UserConfig.WD_Multi) != 0)
        {
            function.WriteErrMsg("提现金额必须是[" + SiteConfig.UserConfig.WD_Multi + "]的倍数");
            return;
        }
        if (mu.Purse < (money + fee)) { function.WriteErrMsg("你只有[" + mu.Purse.ToString("f2") + "],需[" + (money + fee).ToString("F2") + "]才可提现"); return; }
        if (string.IsNullOrEmpty(shortPwd)) { function.WriteErrMsg("未输入支付密码"); return; }
        if (!mu.PayPassWord.Equals(StringHelper.MD5(shortPwd))) { function.WriteErrMsg("支付密码不正确"); return; }
        //生成提现单据
        M_Cash cashMod = new M_Cash();
        cashMod.UserID = mu.UserID;
        cashMod.money = money;
        cashMod.WithDrawFee = fee;
        cashMod.YName = mu.UserName;
        cashMod.CardType = Request.Form["cardType_rad"];
        cashMod.Remark = Request.Form["Remark_T"];
        switch (cashMod.CardType)
        {
            case "银行卡":
                {
                    cashMod.Account = Request.Form["Account_T"];
                    cashMod.Bank = Request.Form["Bank_T"];
                    cashMod.PeopleName = Request.Form["PName_T"];
                }
                break;
            default://其它网络支付方式
                {
                    cashMod.Account = Request.Form["Net_Account_T"];
                    cashMod.Bank = cashMod.CardType;
                    cashMod.PeopleName = Request.Form["Net_PName_T"];
                    cashMod.QRcode = Request.Form["QRCode_t"];
                }
                break;
        }

        //银行账户信息
        //int bankid = DataConverter.CLng(Request.Form["bankid"]);
        M_User_Bank bankMod = SelModelByUid(mu.UserID);
        //账户不存在则新增,只存储最近一次的
        if (bankMod == null) { bankMod = new M_User_Bank(); }
        bankMod.CardNum = cashMod.Account;
        bankMod.BankName = cashMod.Bank;
        bankMod.PeopleName = cashMod.PeopleName;
        bankMod.Remark = cashMod.Remark;
        bankMod.CardType = cashMod.CardType;
        bankMod.UserID = mu.UserID;
        bankMod.QRCode = cashMod.QRcode;
        if (bankMod.ID > 0) { bankBll.UpdateByID(bankMod); }
        else { bankMod.ID = bankBll.Insert(bankMod); }

        buser.MinusVMoney(mu.UserID, money, M_UserExpHis.SType.Purse, cashMod.Remark);
        //if (cashMod.WithDrawFee > 0)
        //{
        //    buser.MinusVMoney(mu.UserID, cashMod.WithDrawFee, M_UserExpHis.SType.Purse, "提现手续费率" + SiteConfig.SiteOption.MastMoney.ToString("F2") + "%");
        //}
        cashBll.insert(cashMod);
        function.WriteSuccessMsg("提现申请成功,请等待管理员审核", "/User/Money/WithDrawLog");
    }
    public M_User_Bank SelModelByUid(int uid, string bankName = "")
    {
        string where = "UserID=" + uid;
        List<SqlParameter> sp = new List<SqlParameter>();
        if (!string.IsNullOrEmpty(bankName))
        {
            sp.Add(new SqlParameter("bankName", bankName.Trim()));
            where += " AND BankName=@bankName";
        }
        using (DbDataReader reader = DBCenter.SelReturnReader("ZL_User_Bank", where, "ID DESC", sp))
        {
            if (reader.Read())
            {
                return new M_User_Bank().GetModelFromReader(reader);
            }
            else
            {
                return null;
            }
        }
    }
}