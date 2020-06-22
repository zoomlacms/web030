using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using ZoomLa.BLL;
using ZoomLa.Model;
using ZoomLa.SQLDAL;

public partial class Extend_Store_XX : System.Web.UI.Page
{
    B_User buser = new B_User();
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            M_UserInfo mu = buser.GetLogin();
            // AND PageID>0
            DataTable dt = DBCenter.Sel("ZL_User","ParentUserID="+mu.UserID+ " AND PageID>0");
            RPT.DataSource = dt;
            RPT.DataBind();
        }
    }
}