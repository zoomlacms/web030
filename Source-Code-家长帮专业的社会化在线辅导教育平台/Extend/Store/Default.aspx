<%@ Page Language="C#" AutoEventWireup="true" CodeFile="Default.aspx.cs" Inherits="Extend_Store_Default" MasterPageFile="~/Extend/Common/Main.master" %>
<asp:Content runat="server" ContentPlaceHolderID="head"><title>店铺管理</title></asp:Content>
<asp:Content runat="server" ContentPlaceHolderID="Content">
<section class="container Parents_top">
    <div class="row">
        <%Call.Label("{ZL.Label id=\"获取店家信息new\" /}"); %>
    </div>
</section>
<!--top end-->

<div class="container user_list_ul">
    <ul>
        <li><a href="/extend/order.aspx?mode=store"><i class="zi zi_cartarrowdown"></i> 订单管理 <small><i class="zi zi_pathRight"></i></small></a></li>
        <li><a href="javascript:;" onclick="$('#qrcode_modal').modal('show');" id="copyLink"><i class="zi zi_fly"></i> 推广店铺 <small><i class="zi zi_pathRight"></i></small></a></li>
<%--        <li><a href="javascript:;" onclick="$('#qrcode_modal').modal('show');" id="copyLink2"><i class="zi zi_flag"></i> 下线推广 <small><i class="zi zi_pathRight"></i></small></a></li>--%>
        <li><a href="SRTJ.aspx"><i class="zi zi_dollarSign"></i> 收入统计<small><i class="zi zi_pathRight"></i></small></a></li>
        <li><a href="/Class_36/NodePage.aspx"><i class="zi zi_arrowDown"></i> 我的下线<small><i class="zi zi_pathRight"></i></small></a></li>
        <li><a href="/User/Money/WithDraw"><i class="zi zi_yensign"></i> 资金提现<small><i class="zi zi_pathRight"></i></small></a></li>
        <li><a href="/Extend/ms.aspx"><i class="zi zi_flag"></i> 老师推荐<small><i class="zi zi_pathRight"></i></small></a></li>
       <%-- <li><a href="/Extend/ms.aspx"><i class="zi zi_flag"></i> 老师推荐<small><i class="zi zi_pathRight"></i></small></a></li>--%>
        <li><a href="/user/"><i class="zi zi_pathLeft"></i> 返回会员中心 </a></li>
    </ul>
</div>
<div class="modal fade" id="qrcode_modal" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true" style="margin-top:30%;">
    <div class="modal-dialog">
        <div class="modal-content text-center">
            <div style="padding-top:3rem;padding-bottom:3rem;">
                <img src="/common/common.ashx?url=<%=GetTGUrl() %>" style="width:50%;margin:0 auto;"/>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-info" data-dismiss="modal" style="margin:0 auto;">关闭窗口</button>
            </div>
        </div>
    </div>
</div>
</asp:Content>
<asp:Content runat="server" ContentPlaceHolderID="Script">
<script src="/Template/Gredu/style/layer/layer.js"></script>
<script>
//分享按钮JS配合layer.js使用
 //$(document).ready(function (e) {
 //        var clipboard = new ClipboardJS("#copyLink");
 //           clipboard.on('success', function (e) {
 //               console.log(e);
 //   			      layer.msg('店铺网址复制成功-快去分享吧！');
 //           });
 //           clipboard.on('error', function (e) {
 //               console.log(e);
 //                layer.msg('复制失败！');
 //      });

 //        var clipboard = new ClipboardJS("#copyLink2");
 //           clipboard.on('success', function (e) {
 //               console.log(e);
 //   			      layer.msg('复制成功-分享就有下线！');
 //           });
 //           clipboard.on('error', function (e) {
 //               console.log(e);
 //                layer.msg('复制失败！');
 //      });
	   
 //});

//	$(".a").empty().html('<i class="zi zi_heart" aria-hidden="true"></i> 已推荐')
//	$(".a").attr("href","javasrcipt:;")
</script>

</asp:Content>