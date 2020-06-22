using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using ZoomLa.BLL;
using ZoomLa.Model;
using ZoomLa.Sns;
using ZoomLa.SQLDAL;

public partial class Extend_Common_ContentManage_Status : System.Web.UI.Page
{
    /*
     * 后台审核通过,更新头像
     */ 
    protected void Page_Load(object sender, EventArgs e)
    {
        B_Admin.CheckIsLogged(Request.RawUrl);
        B_User buser = new B_User();
        B_Content conBll = new B_Content();
        string ids = Request["ids"];
        int status = DataConvert.CLng(Request["status"]);
        switch (status)
        {
            case (int)ZLEnum.ConStatus.Audited:
                if (!string.IsNullOrEmpty(ids))
                {
                    //SafeSC.CheckIDSEx(ids);
                    //string fields = "B.*,A.Title";
                    //DataTable dt = DBCenter.JoinQuery(fields, "ZL_CommonModel", "ZL_C_LSSQ", "A.ItemID=B.ID", "A.GeneralID IN (" + ids + ")");
                    //foreach (DataRow dr in dt.Rows)
                    //{
                    //    int uid = DataConvert.CLng(dr["yhid"]);
                    //    if (uid < 1) { continue; }
                    //    string faceUrl = ExHelper.Json_GetFirstImage(DataConvert.CStr(dr["tx"]));
                    //    if (string.IsNullOrEmpty(faceUrl)) { faceUrl = "/Images/userface/noface.png"; }
                    //    string name = DataConvert.CStr(dr["Title"]);
                    //    string zsxm = DataConvert.CStr(dr["zsxm"]);
                    //    DBCenter.UpdateSQL("ZL_User", "Salt=@face,HoneyName=@name,[Permissions]=@zsxm", "UserID=" + uid, new List<SqlParameter>()
                    //    { new SqlParameter("face", faceUrl),
                    //      new SqlParameter("name",name),
                    //      new SqlParameter("zsxm",zsxm)
                    //    });
                    //    DBCenter.UpdateSQL("ZL_UserBase","UserFace=@face","UserID="+uid,new List<SqlParameter>() {new SqlParameter("face",faceUrl) });
                    //}
                }
                break;
            //case (int)ZLEnum.ConStatus.UnAudit:
            //    break;
        }
        conBll.UpdateStatus(ids, status);
        Response.Write("1");Response.Flush();Response.End();return;
    }

}