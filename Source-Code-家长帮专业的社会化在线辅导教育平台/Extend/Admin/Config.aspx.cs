using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using ZoomLa.Common;
using ZoomLa.Sns;

public partial class Extend_Admin_Config : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            Order_YJ.Text = PlugConfig.Instance.Order_YJ.ToString("F2");
            Order_PTFC.Text = GetPercent(PlugConfig.Instance.Order_PTFC);
            Order_DJFC.Text = GetPercent(PlugConfig.Instance.Order_DJFC);
            Order_DJSXFC.Text = GetPercent(PlugConfig.Instance.Order_DJSXFC);
        }
    }
    private string GetPercent(double percent) { return (percent * 100).ToString("F0"); }
    protected void Save_Btn_Click(object sender, EventArgs e)
    {
        int ptfc = DataConverter.CLng(Order_PTFC.Text);
        int djfc = DataConverter.CLng(Order_DJFC.Text);
        int djsxfc = DataConverter.CLng(Order_DJSXFC.Text);
        if ((ptfc + djfc + djsxfc) != 100) { function.WriteErrMsg("分成总额必须为100%");return; }


        PlugConfig.Instance.Order_YJ = DataConverter.CDouble(Order_YJ.Text);
        PlugConfig.Instance.Order_PTFC = ptfc * 0.01;
        PlugConfig.Instance.Order_DJFC = djfc * 0.01;
        PlugConfig.Instance.Order_DJSXFC = djsxfc * 0.01;
        PlugConfig.Update();
        function.WriteSuccessMsg("保存成功");
    }
}