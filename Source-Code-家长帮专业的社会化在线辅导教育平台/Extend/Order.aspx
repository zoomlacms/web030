<%@ Page Language="C#" AutoEventWireup="true" CodeFile="Order.aspx.cs" Inherits="Extend_Order" MasterPageFile="~/Extend/Common/Main.master" %>
<%@ Import Namespace="ZoomLa.Sns" %>
<asp:Content runat="server" ContentPlaceHolderID="head"><title>订单管理</title></asp:Content>
<asp:Content runat="server" ContentPlaceHolderID="Content">
<style type="text/css">
    .label{background-color:#ff6a00;color:#fff;padding:4px;text-align:center;font-size:12px;border-radius:5px;display:inline-block;min-width:50px;}
    .weui-panel__ft{border-bottom:1px solid #ddd;text-align:right;padding-right:10px;min-height:20px;}
</style>
<div style="height:40px;"></div>
<header class="mteacher_header">
    <div class="addcontent_top">
        <a href="javascript:history.back(-1)"><i class="zi zi_arrowLeft"></i></a>
        <small id="add_title">订单信息</small>
    </div>
</header>
<div class="mbtab">
        <div id="tab1" class="item active" onclick="mbtab.go(this);" data-url="<%=BaseUrl %>">待处理<%=ZoomLa.Sns.ExHelper.ShowTip("order_dcl") %></div>
        <div id="tab2" class="item" onclick="mbtab.go(this);" data-url="<%:BaseUrl+"&fast=ycg"%>">已成功<%=ZoomLa.Sns.ExHelper.ShowTip("order_cmt") %></div>
        <%if (ExHelper.IsTeacher(mu.GroupID))
            { %>
        <div id="tab4" class="item" onclick="mbtab.go(this);" data-url="<%:BaseUrl+"&fast=dzf" %>">待支付<%=ZoomLa.Sns.ExHelper.ShowTip("order_dzf") %></div>
        <%} %>
        <div id="tab3"class="item" onclick="mbtab.go(this);" data-url="<%:BaseUrl+"&fast=ywj" %>">已完结</div>
        <div id="tab5" class="item" onclick="mbtab.go(this);" data-url="<%:BaseUrl+"&fast=fail"%>">已失效</div>
    </div>
<div class="weui-panel weui-panel_access">
        <ZL:RepeaterMB runat="server" ID="RPT" PageSize="10" PagePre="<div class='text-center' style='padding:5px;'>" PageEnd="</div>">
            <ItemTemplate>
                <div class="weui-panel__hd" style="color:black;" runat="server" visible='<%#((Mode=="store")&&Eval("status_money","")=="1")%>'>
                    佣金分成：<%#ZoomLa.Common.DataConverter.CDouble(Eval("fcAmount")).ToString("F2") %>元 支付时间：<%#Eval("fcDate") %>
                </div>
                <div class="weui-panel__bd">
                    <a href="javascript:void(0);" class="weui-media-box weui-media-box_appmsg" style="padding-bottom:0px;">
                        <div class="weui-media-box__hd">
                            <img class="weui-media-box__thumb" src="<%#Eval("sp_img") %>" onerror="shownopic(this);" style="border-radius:50%;">
                        </div>
                        <div class="weui-media-box__bd">
                            <h4 class="weui-media-box__title">
                                <div>
                                    <span class="label"><%#"教师："+ShowTeaName() %></span>
                                    <span class="label"><%#"学员："+Eval("xsr") %></span>
                                </div>

                                <div style="margin-top: 2px;">
                                    <span class="label"><%#"店主："+ZoomLa.BLL.B_User.GetUserName(Eval("djhname"),Eval("djname")) %></span>
                                    <span class="label"><%#"订单："+ShowStatus() %></span>
                                </div>
                            </h4>
                            <p class="weui-media-box__desc">
                                <span><%#ShowSEDate() %></span>
                            </p>
                        </div>
                    </a>
                </div>
                <div class="weui-panel__ft">
                  <%#ShowBtns() %>
                </div>
            </ItemTemplate>
            <FooterTemplate></FooterTemplate>
        </ZL:RepeaterMB>
            </div>
<div class="empty_tip" id="empty1">
        <i class="zi zi_boxopen"></i>
        <div class="text">没有订单信息</div>
    </div>
<div style="display:none;">
    <asp:Button runat="server" ID="mybind_btn" OnClick="mybind_btn_Click" />
</div>
</asp:Content>
<asp:Content runat="server" ContentPlaceHolderID="ScriptContent">
    <script src="/JS/Modal/APIResult.js"></script>
    <script src="/JS/Controls/ZL_Dialog.js"></script>
    <script>
        var order = { wait: new ZL_Dialog(),url:"/Extend/API.ashx?action=" };
        order.wait.maxbtn = false;
        order.user_sign = function (status, id) {
            var ref = this;
            ref.wait.ShowMask("正在处理中...");
            $.post(ref.url + "order_user_sign", { "status": status, "id": id }, function (data) {
                order.callback(data);
            })
        }
        order.user_cancel = function (id) {
            var ref = this;
            ref.wait.ShowMask("正在处理中...");
            $.post(ref.url + "order_user_cancel", { "id": id }, function (data) {
                order.callback(data);
            })
        }
        order.teacher_sign = function (status, id) {
            var ref = this;
            ref.wait.ShowMask("正在处理中...");
            $.post(ref.url + "order_teacher_sign", {"status":status, "id": id }, function (data) {
                order.callback(data);
            })
        }
        order.finish = function (id)
        {
            var ref = this;
            if (!confirm("确定要结束该订单吗")) { return false; }
            ref.wait.ShowMask("正在处理中...");
            $.post(ref.url + "order_user_finish", { "id": id }, function (data) {
                order.callback(data);
            });
        }
        //common callback
        order.callback = function (data) {
            var ref = this;
            var ret = APIResult.getModel(data);
            if (APIResult.isok(ret)) { $("#mybind_btn").click(); }
            else { alert("失败:" + ret.retmsg); }
            ref.wait.CloseModal();
        }
    </script>
</asp:Content>