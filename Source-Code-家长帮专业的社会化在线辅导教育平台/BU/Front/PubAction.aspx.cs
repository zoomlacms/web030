using System;
using System.Collections.Generic;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using ZoomLa.Model;
using ZoomLa.BLL;
using ZoomLa.Components;
using ZoomLa.Common;
using System.Data.SqlClient;
using System.Data;
using ZoomLa.SQLDAL;
using System.Linq;
using ZoomLa.BLL.CreateJS;
using ZoomLa.BLL.Helper;
using ZoomLa.BLL.API;
namespace ZoomLaCMS
{
    //仅用于订单生成
    public partial class PubAction : System.Web.UI.Page
    {
        B_Pub pubBll = new B_Pub();
        B_Model modBll = new B_Model();
        B_User buser = new B_User();
        B_ModelField mfBll = new B_ModelField();
        M_UserInfo mu = new M_UserInfo();
        public int Pid
        {
            get
            {
                return DataConverter.CLng(Request["Pubid"]);
            }
        }
        protected void Page_Load(object sender, EventArgs e)
        {
            if (Pid <= 0) { function.WriteErrMsg("参数错误!不存在此信息!"); }
            M_Pub mpub = pubBll.GetSelect(Pid);
            mu = buser.GetLogin();
            if (mpub == null || mpub.Pubid < 1) { function.WriteErrMsg("互动信息不存在"); }

            M_APIResult retMod = new M_APIResult();
            int spid = DataConvert.CLng(Request.Form["spfbrid"]);
            if (mu.UserID < 1) { retMod.retmsg = "未登录不可提交订单"; RepToClient(retMod.ToString()); return; }
            if (spid < 1) { retMod.retmsg = "未指定教师信息"; RepToClient(retMod.ToString()); return; }
            {
                //如果存在与该老师的进行中订单,则忽略
                string where = "xsrid=" + mu.UserID + " AND spfbrid=" + spid;
                where += " AND status_order>=0 AND status_order<100";
                if (DBCenter.IsExist("ZL_Pub_dsmx", where))
                {
                    retMod.retmsg = "已存在生效中的订单";
                    RepToClient(retMod.ToString());
                    return;
                }
            }
            M_UserInfo spmu = buser.SelReturnModel(spid);
            if (spmu.IsNull) { retMod.retmsg = "老师信息不存在"; RepToClient(retMod.ToString());return; }
            //-----------------------获取用户提交的数据
            //隐藏字段值
            int PubContentid = DataConverter.CLng(Request.Form["PubContentid"]);
            int Parentid = DataConvert.CLng(Request.Form["Parentid"]);
            //用户提交
            string pbtitle = Server.HtmlEncode(DataConvert.CStr(Request.Form["PubTitle"]));
            string pbcontent = Server.HtmlEncode(DataConvert.CStr(Request.Form["PubContent"]));
            if (!pbtitle.Contains("的"))//xxx的课程
            {
                pbtitle = B_User.GetUserName(spmu.HoneyName, spmu.UserName) + "的课程";
            }
            //-----------------------可提交判断
            List<SqlParameter> sp = new List<SqlParameter>();
            //-----------------------初始化参数
            //删除超过保留期限的值
            //pubBll.DeleteModel(mpub.PubTableName, "DateDiff(d,PubAddTime,getdate())>" + mpub.Pubkeep);
            //ModelField表中仅存了自定义的字段
            B_CodeModel codeBll = new B_CodeModel(mpub.PubTableName);
            DataRow dr = codeBll.NewModel();
            DataTable mfDT = mfBll.DB_SelByModel(mpub.PubModelID);
            mfDT.DefaultView.RowFilter = "sys_type=0";
            mfDT = mfDT.DefaultView.ToTable();
            //-----固定的系统字段
            dr["Pubnum"] = 1;
            dr["PubIP"] = EnviorHelper.GetUserIP();
            dr["PubUserID"] = mu.UserID;
            dr["PubUserName"] = mu.UserName;
            dr["Pubupid"] = mpub.Pubid;
            dr["PubAddTime"] = DateTime.Now;
            dr["Parentid"] = Parentid;
            dr["PubTitle"] = pbtitle;
            dr["PubContent"] = pbcontent;
            dr["Pubstart"] = mpub.PubIsTrue == 1 ? 0 : 1;//取反
            dr["PubInputer"] = B_User.GetUserName(mu.HoneyName, mu.UserName);
            dr["PubContentid"] = PubContentid;
            //dr["cookflag"] = CookFlag;
            //=========订单初始化
            dr["status_order"] = 0;
            dr["status_user"] = 0;
            dr["status_teacher"] = 0;
            dr["status_money"] = 0;
            dr["edate"] = "";
            dr["fcAmount"] = 0;
            dr["fcDate"] = "";
            
            //int djid = DataConvert.CLng(mu.ParentUserID);
            //if (djid < 1) { djid = DataConvert.CLng(Request["djid"]); }
            dr["djid"] = DataConvert.CLng(Request["djid"]);

            //------非系统字段
            for (int i = 0; i < mfDT.Rows.Count; i++)
            {
                M_ModelField mfMod = new M_ModelField().GetModelFromReader(mfDT.Rows[i]);
                string value = Server.HtmlEncode(Request.Form[mfMod.FieldName] ?? "");
                Parentid = DataConvert.CLng(Request.Form["Parentid"]);
                if (mfMod.IsNotNull && string.IsNullOrEmpty(value))
                {
                    RepToClient(mfMod.FieldName+"不能为空");
                }
                dr[mfMod.FieldName] = value;
                switch (mpub.PubType)
                {
                    #region 根据互动类型,进行空值判断
                    case 0:
                        if (string.IsNullOrEmpty(pbcontent))
                        {
                            RepToClient("评论内容不能为空!");
                        }
                        break;
                    case 1:
                        if (string.IsNullOrEmpty(pbtitle))
                        {
                            RepToClient("标题不能为空!");
                        }
                        break;
                    case 2:
                        if (string.IsNullOrEmpty(pbtitle))
                        {
                            RepToClient("标题不能为空!");
                        }
                        if (string.IsNullOrEmpty(pbcontent))
                        {
                            RepToClient("活动信息不能为空!");
                        }
                        break;
                    case 3:
                        if (string.IsNullOrEmpty(pbtitle) || string.IsNullOrEmpty(pbcontent))
                        {
                            RepToClient("标题与内容不能为空!");
                        }
                        break;
                    case 4:
                        if (string.IsNullOrEmpty(pbtitle))
                        {
                            RepToClient("标题不能为空!");
                        }
                        break;
                    case 5:
                        break;
                    case 7://将评星控件的数据写入数据表中
                        dr["PubContent"] = Request.Params["scoreVal"];
                        break;
                    case 8://互动表单
                        break;
                        #endregion
                }
            }
            codeBll.Insert(dr);
            retMod.retcode = M_APIResult.Success;
            RepToClient(retMod.ToString());
            //Upaddnums(mpub); //更新总参与人数
        }
        public void RepToClient(string msg)
        {
            Response.Clear();
            Response.Write(msg);
            Response.Flush();
            Response.End();
        }
        // 更新总参与人数
        private void Upaddnums(M_Pub mpub)
        {
            mpub.PubAddnum = mpub.PubAddnum + 1;
            pubBll.GetUpdate(mpub);
            if (string.IsNullOrEmpty(mpub.PubGourl))
            {
                if (mpub.PubGourl == "")
                {
                    function.Script(this, "ActionSec(1,'" + Server.HtmlEncode(Request.UrlReferrer.ToString()) + "')");
                }
                else
                {
                    function.Script(this, "ActionSec(1,'" + mpub.PubGourl + "')");
                }
            }
            else
            {
                function.Script(this, "ActionSec(1,'" + mpub.PubGourl + "')");
            }
        }
    }
}