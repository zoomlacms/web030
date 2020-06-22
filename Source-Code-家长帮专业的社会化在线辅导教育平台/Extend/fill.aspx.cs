using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using ZoomLa.BLL;
using ZoomLa.BLL.CreateJS;
using ZoomLa.Model;
using ZoomLa.Sns;
using ZoomLa.SQLDAL;

public partial class Extend_fill : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        M_AdminInfo adminMod = B_Admin.GetLogin();
        if (adminMod == null || adminMod.AdminId != 1) { throw new Exception("no access"); }

        //---------------------181120
        if (false)
        {
            #region  初始化填充店铺数据
            B_Ex_Store stBll = new B_Ex_Store();
            DataTable userDT = DBCenter.Sel("ZL_User", "PageID>0");
            DBCenter.UpdateSQL(stBll.TbName, "cdate='" + DateTime.Now.ToString("yyyy/MM/dd HH:mm:ss") + "',dpzt=99", "");
            foreach (DataRow user in userDT.Rows)
            {
                DataRow stDR = stBll.SelReturnModel(DataConvert.CLng(user["PageID"]));
                stDR["djid"] = Convert.ToInt32(user["UserID"]);
                stBll.UpdateById(stDR);
            }
            #endregion
        }
        if (true)
        {
            #region 内容迁移为移动编辑器
            B_CodeModel codeBll = new B_CodeModel("ZL_C_LSSQ");
            DataTable dt = codeBll.Sel();
            //jxtd  jxjl  cgal
            for (int i = 0; i < dt.Rows.Count; i++)
            {
                DataRow dr = dt.Rows[i];
                dr["jxtd"] = UeditorToMB(DataConvert.CStr(dr["jxtd"]));
                dr["jxjl"] = UeditorToMB(DataConvert.CStr(dr["jxjl"]));
                dr["cgal"] = UeditorToMB(DataConvert.CStr(dr["cgal"]));
                codeBll.UpdateByID(dr);
            }
            #endregion
        }
        throw new Exception("操作完成");
    }
    public string UeditorToMB(string content)
    {
        if (string.IsNullOrEmpty(content)) { return ""; }
        content = content.Replace("<p>", "").Replace("</p>", "\r\n")
            .Replace("<br/>", "").Replace("&nbsp;", " ");
        return content;
    }
}