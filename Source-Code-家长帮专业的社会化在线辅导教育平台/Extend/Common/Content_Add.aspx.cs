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
/*
 * 前台老师,店主,家长,维护个人档案
 */
public partial class Extend_Common_Content_Add : System.Web.UI.Page
{
    B_User buser = new B_User();
    B_Node nodeBll = new B_Node();
    B_Model modBll = new B_Model();
    B_ModelField fieldBll = new B_ModelField();
    B_Content conBll = new B_Content();
   
    protected void Page_Load(object sender, EventArgs e)
    {
        B_User.CheckIsLogged("/User/");
        int NodeID = DataConvert.CLng(Request["NodeID"]);
        int ModelID = DataConvert.CLng(Request["ModelID"]);
        M_UserInfo mu = buser.GetLogin();
        M_CommonData CData = new M_CommonData();
        //检测当前用户有无填过,有则直接取
        int Mid = DataConverter.CLng(Request["id"]);
        if (Mid < 1)
        {
            //检测是否有同用户数据存在
            Mid = DataConvert.CLng(DBCenter.ExecuteScala("ZL_CommonModel", "GeneralID",
                "Inputer=@uname AND ModelID=" + ModelID, "GeneralID DESC", new List<SqlParameter>() { new SqlParameter("uname", mu.UserName) }));
        }
        if (Mid > 0)
        {
            CData = conBll.GetCommonData(Mid);
            if (!CData.Inputer.Equals(mu.UserName)) { function.WriteErrMsg("你无权修改该内容"); return; }
        }
        else
        {
            CData.NodeID = NodeID;
            CData.ModelID = ModelID;
            CData.TableName = modBll.SelReturnModel(CData.ModelID).TableName;
        }
        M_Node nodeMod = nodeBll.SelReturnModel(CData.NodeID);
        DataTable dt = fieldBll.SelByModelID(CData.ModelID, false);
        Call commonCall = new Call();
        DataTable table;
        try
        {
            HttpRequestWrapper wrap = new HttpRequestWrapper(Request);
            table = commonCall.GetDTFromMVC(dt, wrap);

            //table = commonCall.GetDTFromPage(dt, this, ViewState);
        }
        catch (Exception ex)
        {
            function.WriteErrMsg(ex.Message); return;
        }
        CData.Title = Request.Form["title"];
        CData.Subtitle = Request["Subtitle"];
        CData.PYtitle = Request["PYtitle"];
        CData.TagKey = Request.Form["tabinput"];
        CData.Status = nodeMod.SiteContentAudit;
        //老师修改信息,必须要审核
        //用户名,头像等信息,实时变更
        if (CData.ModelID == (int)ExConast.ModelInfo.老师申请)
        {
            if (CData.GeneralID > 0 && CData.SuccessfulUserID != mu.UserID) { function.WriteErrMsg("无权操作该信息"); }
            CData.Status = (int)ZLEnum.ConStatus.UnAudit;
            string name = CData.Title;
            string zsxm = DataConvert.CStr(Request.Form["txt_zsxm"]);
            string faceUrl = ExHelper.Json_GetFirstImage(DataConvert.CStr(Request.Form["txt_tx"]));
            if (string.IsNullOrEmpty(faceUrl)) { faceUrl = "/Images/userface/noface.png"; }

            DBCenter.UpdateSQL("ZL_User", "Salt=@face,HoneyName=@name,[Permissions]=@zsxm", "UserID=" + mu.UserID, new List<SqlParameter>()
                        { new SqlParameter("face", faceUrl),
                          new SqlParameter("name",name),
                          new SqlParameter("zsxm",zsxm)
                        });
            DBCenter.UpdateSQL("ZL_UserBase", "UserFace=@face", "UserID=" + mu.UserID, new List<SqlParameter>() { new SqlParameter("face", faceUrl) });
            buser.GetLogin(false);//实时更新
        }
        string parentTree = "";
        CData.TitleStyle = Request.Form["TitleStyle"];
        CData.TopImg = Request.Form["topimg_hid"];//首页图片
        if (Mid > 0)//修改内容
        {
            conBll.UpdateContent(table, CData);
        }
        else
        {
            CData.FirstNodeID = nodeBll.SelFirstNodeID(CData.NodeID, ref parentTree);
            CData.ParentTree = parentTree;
            CData.Inputer = mu.UserName;
            CData.SuccessfulUserID = mu.UserID;
            CData.GeneralID = conBll.AddContent(table, CData);//插入信息给两个表，主表和从表:CData-主表的模型，table-从表
        }
        function.WriteSuccessMsg("操作成功!", "/User/");
    }
}