<%@ WebHandler Language="C#" Class="API" %>

using System;
using System.Web;
using System.Data;
using ZoomLa.BLL;
using ZoomLa.BLL.API;
using ZoomLa.BLL.Helper;
using ZoomLa.BLL.User;
using ZoomLa.Model;
using ZoomLa.SQLDAL;
using Newtonsoft.Json;
using ZoomLa.Sns;

public class API :API_Base,IHttpHandler {
    B_User buser = new B_User();
    public int Mid { get { return DataConvert.CLng(Req("ID")); } }
    public void ProcessRequest(HttpContext context)
    {
        M_UserInfo mu = buser.GetLogin();
        retMod.retcode = M_APIResult.Failed;
        //retMod.callback = CallBack;
        try
        {
            switch (Action)
            {
                case "near"://获取附近的店家信息
                    {
                        #region near
                        double lat = DataConvert.CDouble(Req("lat"));
                        double lng = DataConvert.CDouble(Req("lng"));
                        if (lat <= 0 || lng <= 0) { throw new Exception("未指定用户坐标"); }
                        string fields = "A.GeneralID,A.Title,B.*";
                        DataTable dt = DBCenter.JoinQuery(fields, "ZL_CommonModel", "ZL_C_lssq", "A.ItemID=B.ID", "A.ModelID=53 AND A.Status=99");
                        dt.Columns.Add("distance", typeof(double));
                        dt.Columns.Add("return", typeof(int));//1==可返回
                                                              //只允许显示一公里内的数据
                        for (int i = 0; i < dt.Rows.Count; i++)
                        {
                            DataRow dr = dt.Rows[i];
                            string pos = DataConvert.CStr(dr["xzzb"]);//lng lat
                                                                      //未正确指定地址则忽略
                            if (string.IsNullOrEmpty(pos) || pos.IndexOf(',') < 1) { continue; }
                            double lat2 = DataConvert.CDouble(pos.Split(',')[1]);
                            double lng2 = DataConvert.CDouble(pos.Split(',')[0]);
                            double distance = GPSCalc.GetDistance(lat, lng, lat2, lng2);
                            dr["distance"] = distance;
                            dr["return"] = distance < 1000 ? 0 : 1;//1公里内
                        }
                        dt.DefaultView.RowFilter = "return=1";
                        dt = dt.DefaultView.ToTable();
                        retMod.retcode = M_APIResult.Success;
                        retMod.result = JsonConvert.SerializeObject(dt);
                        #endregion
                    }
                    break;
                case "order_user_sign":
                    {
                        string status = DataConvert.CStr(Req("status"));
                        DataRow orderDR = ExOrder.SelReturnModel(Mid);
                        if (orderDR == null) { throw new Exception("订单不存在"); }
                        if (DataConvert.CLng(orderDR["xsrid"]) != mu.UserID) { throw new Exception("无权操作该订单"); }
                        if (DataConvert.CLng(orderDR["status_user"]) != 0) { throw new Exception("订单不可修改"); }
                        //--------------------------------
                        ExOrder.Sign_User(Mid,status);
                        retMod.retcode = M_APIResult.Success;
                    }
                    break;
                case "order_user_cancel":
                    {
                        DataRow orderDR = ExOrder.SelReturnModel(Mid);
                        if (orderDR == null) { throw new Exception("订单不存在"); }
                        if (DataConvert.CLng(orderDR["xsrid"]) != mu.UserID) { throw new Exception("无权操作该订单"); }
                        if (DataConvert.CLng(orderDR["status_order"]) != (int)ExConast.OrderStatus.正常)
                        { throw new Exception("订单当前状态不可取消"); }
                        orderDR["status_order"] = (int)ExConast.OrderStatus.取消;
                        ExOrder.UpdateById(orderDR);
                        retMod.retcode = M_APIResult.Success;
                    }
                    break;
                case "order_user_finish"://家长确认完结订单
                    {
                        DataRow orderDR = ExOrder.SelReturnModel(Mid);
                        if (orderDR == null) { throw new Exception("订单不存在"); }
                        if (DataConvert.CLng(orderDR["xsrid"]) != mu.UserID) { throw new Exception("无权操作该订单"); }
                        if (DataConvert.CLng(orderDR["status_order"]) != (int)ExConast.OrderStatus.签约成功)
                        { throw new Exception("订单当前状态不可完结"); }
                        orderDR["status_order"] = (int)ExConast.OrderStatus.订单完结;
                        orderDR["edate"] = DateTime.Now.ToString("yyyy/MM/dd HH:mm:ss");
                        ExOrder.UpdateById(orderDR);
                        retMod.retcode = M_APIResult.Success;
                    }
                    break;
                case "order_teacher_sign":
                    {
                        string status = DataConvert.CStr(Req("status"));
                        DataRow orderDR = ExOrder.SelReturnModel(Mid);
                        if (orderDR == null) { throw new Exception("订单不存在"); }
                        if (DataConvert.CLng(orderDR["spfbrid"]) != mu.UserID) { throw new Exception("无权操作该订单"); }
                        if (DataConvert.CLng(orderDR["status_teacher"]) != 0) { throw new Exception("订单不可修改"); }
                        //--------------------------------
                        ExOrder.Sign_Teacher(Mid, status);
                        retMod.retcode = M_APIResult.Success;
                    }
                    break;
                case "tea_elite":
                    {
                        B_Ex_TeaElite eliteBll = new B_Ex_TeaElite();
                        if (mu.UserID < 1 || mu.PageID < 1) { retMod.retmsg = "没有推荐权限"; }
                        else if (Mid < 1) { retMod.retmsg = "未指定教师信息"; }
                        else
                        {
                            eliteBll.Elite(mu.UserID, Mid);
                            retMod.retcode = M_APIResult.Success;
                        }
                    }
                    break;
                case "tea_unelite":
                    {
                        if (mu.UserID < 1 || Mid < 1) { retMod.retmsg = "信息不完整"; }
                        else
                        {
                            B_Ex_TeaElite eliteBll = new B_Ex_TeaElite();
                            eliteBll.UnElite(mu.UserID, Mid);
                            retMod.retcode = M_APIResult.Success;
                        }
                    }
                    break;
                case "store_get"://只允许分享店主的基本信息
                    {
                        M_UserInfo storeMU =  buser.SelReturnModel(Mid);
                        //-------------- || storeMU.PageID < 1
                        if (storeMU.IsNull) { retMod.retmsg = "店铺信息不存在"; }
                        else
                        {
                            M_AJAXUser userMod = new M_AJAXUser(storeMU);
                            retMod.result = JsonConvert.SerializeObject(storeMU);
                            retMod.retcode = M_APIResult.Success;
                        }
                    }
                    break;
                case "wx_config":
                    {
                        //{appId: "wx0aa8604f70a29af7",timestamp:"1542878970" , nonceStr:"5K8264ILTKCH16CQ2502SI8ZNMTM67VS", signature:"EBCAB7BEF37D3C03068CEC009E032B7F6915CFB8",jsApiList:['checkJsApi','onMenuShareTimeline','onMenuShareAppMessage']}
                        //url = CurrentReq.Request.Url.AbsoluteUri;
                        M_UserInfo storeMU = buser.GetLogin();
                        M_AJAXUser userMod = new M_AJAXUser(storeMU);
                        string url = Req("url");
                        WxAPI api = WxAPI.Code_Get(1);
                        string wxappid = api.AppId.APPID;
                        string timeStamp = WxAPI.HP_GetTimeStamp();
                        string sign = api.JSAPI_GetSign(api.JSAPITicket, WxAPI.nonce, timeStamp, url);
                        string config = "{\"appId\": \"" + api.AppId.APPID + "\",\"timestamp\":\"" + timeStamp + "\" ,\"nonceStr\":\"" + WxAPI.nonce + "\",\"signature\":\"" + sign + "\"}";
                        retMod.retcode = M_APIResult.Success;
                        retMod.result = config;
                        retMod.addon = userMod;
                    }
                    break;
                case "tip_me"://获取用户的消息提示
                    {
                        if (mu.IsNull) { throw new Exception("用户未登录"); }
                        M_Tip tip = new M_Tip();
                        string TbName = "ZL_Pub_dsmx";
                        if (ExHelper.IsUser(mu.GroupID))
                        {
                            //待处理
                            {
                                string where = "xsrid=" + mu.UserID;
                                //待处时中--已方未处理的
                                where += " AND status_user=" + (int)ExConast.Order_User.初始;
                                where += " AND (status_order=0 OR status_order IS NULL)";
                                tip.order_dcl = DBCenter.Count(TbName, where);
                            }
                            //可评价
                            {
                                string where = "xsrid=" + mu.UserID;
                                //进行中,未完结的订单
                                where += " AND status_order=" + (int)ExConast.OrderStatus.签约成功;
                                //未评论过,或时间超过一周
                                where += " AND (commentDate IS NULL OR CONVERT(datetime,commentDate)<'" + DateTime.Now.AddDays(-7).ToString("yyyy/MM/dd HH:mm:ss") + "')";
                                tip.order_cmt = DBCenter.Count(TbName, where);
                            }
                        }
                        else if (ExHelper.IsTeacher(mu.GroupID))
                        {
                            //待处理
                            {
                                string where = "spfbrid=" + mu.UserID;
                                where += " AND status_teacher=" + (int)ExConast.Order_Teacher.初始;
                                where += " AND (status_order=0 OR status_order IS NULL)";
                                tip.order_dcl = DBCenter.Count(TbName, where);
                            }
                            //待支付佣金
                            {
                                string where = "spfbrid=" + mu.UserID;
                                where += " AND status_order IN (99,100)";
                                where += " AND status_money=0";
                                tip.order_dzf = DBCenter.Count(TbName, where);
                            }
                        }
                        retMod.retcode = M_APIResult.Success;
                        retMod.result = JsonConvert.SerializeObject(tip);
                    }
                    break;
                default:
                    retMod.retmsg = "[" + Action + "]不存在";
                    break;
            }
        }
        catch (Exception ex) { retMod.retmsg = ex.Message; }
        RepToClient(retMod);
    }
    public bool IsReusable { get { return false; } }
    public class M_Tip
    {
        public string type = "me";
        public int total { get { return order + msg; } }
        //前端 tip_order,tip_order_dcl来实现分段
        public int order { get { return order_cmt + order_dcl + order_dzf; } }
        //待处理,评价,支付
        public int order_dcl = 0;
        public int order_cmt = 0;
        public int order_dzf = 0;
        //消息提醒,暂不启用
        public int msg { get { return msg_rece + msg_send; } }
        public int msg_rece = 0;
        public int msg_send = 0;
    }
}