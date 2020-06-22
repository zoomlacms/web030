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

public partial class Extend_ms : System.Web.UI.Page
{
    /*
     * EX_View_QU=商圈
     * EX_View_SQ=地铁？？
     * 
     */
    B_User buser = new B_User();
    B_Ex_TeaElite eliteBll = new B_Ex_TeaElite();
    B_Ex_Teacher teaBll = new B_Ex_Teacher();
    //年级,学科,商家,区域ID
    public string nj { get { return HttpUtility.UrlDecode(DataConvert.CStr(Request.QueryString["nj"])); } }
    public string xk { get { return HttpUtility.UrlDecode(DataConvert.CStr(Request.QueryString["xk"])); } }
    public string sq { get { return HttpUtility.UrlDecode(DataConvert.CStr(Request.QueryString["sq"])); } }
    public string qu { get { return DataConvert.CStr(Request.QueryString["qu"]); } }
    public string NodeUrl { get { return ViewState["NodeUrl"] as string; }set { ViewState["NodeUrl"] = value; } }
    public string EliteIds { get { return ViewState["EliteIds"] as string; } set { ViewState["EliteIds"] = value;  } }
    //-----------
    public M_UserInfo mu = null;
    protected void Page_Load(object sender, EventArgs e)
    {
        RPT.SPage = MyBind;
        mu = buser.GetLogin();
        if (!IsPostBack)
        {
            NodeUrl ="/Extend/MS.aspx" ;//Call.GetLabel("{ZL:GetLastinfo(34)/}");
            if (mu.PageID > 1) { EliteIds = ","+ eliteBll.SelEliteIds(mu.UserID) + ","; }
            RPT.DataBind();
            RPT_QU.DataSource = DBCenter.DB.ExecuteTable(new SqlModel("SELECT * FROM EX_View_SQ_Teacher WHERE GradeID IN (SELECT MIN(GradeID) FROM EX_View_SQ_Teacher GROUP BY qu)", null));
            RPT_QU.DataBind();
            {
                DataTable dt = DBCenter.Sel("EX_View_SQ_Teacher","ParentID>0");
                RPT_SQ.DataSource = dt;
                RPT_SQ.DataBind();
            }
        }
    }
    private DataTable MyBind(int psize,int cpage)
    {
        PageSetting setting = teaBll.SelPage(cpage, psize, new F_Teacher()
        {
            nj = nj,
            xk = xk,
            qu = qu,
            sq = sq,
        });
        RPT.ItemCount = setting.itemCount;
        if (setting.itemCount < 1)
        { function.Script(this, "$('#empty1').show();$('#page_div').hide();"); }
        return setting.dt;
    }
    public string ShowInfo(object text,string append)
    {
        string tlp = "<small class=\"infoItem\">{0}</small>";
        string textStr = DataConvert.CStr(text).Trim();
        
        if (string.IsNullOrEmpty(textStr) || textStr.Contains("请选择")) { return ""; }
        else { return string.Format(tlp, textStr + append); }
    }
    public string ShowText(string text,string def)
    {
        return string.IsNullOrEmpty(text) ? def : text;
    }
    //显示商圈范围内教师数量
    public int ShowSQCount(string sq)
    {
        string where = "Status=99 AND SQ LIKE @sq ";
        List<SqlParameter> sp = new List<SqlParameter>() { };
        sp.Add(new SqlParameter("sq", "%" + sq + "%"));
        if (!string.IsNullOrEmpty(nj) || !string.IsNullOrEmpty(xk))
        {
            string jxfw = nj + "|" + xk;
            sp.Add(new SqlParameter("jxfw", "%" + jxfw + "%"));
            where += " AND jxfw LIKE @jxfw";
        }
        string T1 = "EX_View_Teacher";
        return DBCenter.Count(T1, where, sp);
    }
    public string ShowEliteBtn()
    {
        string html = "";
        if (mu.UserID < 1 || mu.PageID < 1) { return html; }
        int spid = DataConvert.CLng(Eval("UserID"));
        html += "<button type='button' id='elite_{0}' class=\"weui-btn weui-btn_mini weui-btn_primary {1}\" onclick=\"teacher.elite({0});\">设为推荐</button>";
        html += "<button type='button' id='unelite_{0}' class=\"weui-btn weui-btn_mini weui-btn_warn {2}\" onclick=\"teacher.unelite({0});\">取消推荐</button>";
        if (EliteIds.Contains("," + spid + ",")) { html = string.Format(html, spid, "hidden", ""); }
        else { html = string.Format(html, spid, "", "hidden"); }
        return html;
    }
}