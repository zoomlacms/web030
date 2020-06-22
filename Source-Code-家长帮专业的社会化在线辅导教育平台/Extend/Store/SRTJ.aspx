<%@ Page Language="C#" AutoEventWireup="true" CodeFile="SRTJ.aspx.cs" Inherits="Extend_Store_SRTJ" MasterPageFile="~/Extend/Common/Main.master" %>
<asp:Content runat="server" ContentPlaceHolderID="head"><title>收入统计</title></asp:Content>
<asp:Content runat="server" ContentPlaceHolderID="Content">
<style type="text/css">
.weui-media-box{padding-bottom:0px;}
.weui-media-box__desc{margin-bottom:5px;}
.dl, ol, ul{margin-bottom:0px;}
.money_wrap{text-align:center;font-size:16px;}
.money_wrap .moneyl{color:#ff0000;font-size:1rem;}
</style>
<header class="mteacher_header">
    <div class="addcontent_top">
        <a href="Default.aspx"><i class="zi zi_arrowLeft"></i></a>
        <small id="add_title">收入统计</small>
    </div>
</header>
<div style="height:38px;"></div>
<div class="empty_tip" id="empty1">
    <i class="zi zi_boxopen"></i>
    <div class="text">没有收入信息</div>
</div>
<div runat="server" id="rpt_wrap">
<div class="money_wrap">
    <span>收入：</span><asp:Label runat="server" class="moneyl" ID="in_l"></asp:Label>
    <span>支出：</span><asp:Label runat="server" class="moneyl" ID="out_l"></asp:Label>
    <span>合计：</span><asp:Label runat="server" class="moneyl" ID="total_l"></asp:Label>
</div>
<ZL:RepeaterMB runat="server" ID="RPT" PageSize="10" PagePre="<div style='border-top:1px solid #ddd;padding-top:5px;margin-bottom:20px;'>" PageEnd="</div>">
            <ItemTemplate>
                <div class="weui-panel">
                <div class="weui-panel__bd">
                <div class="weui-media-box weui-media-box_text">
                    <h4 class="weui-media-box__title"><%#Eval("score","{0:F2}") %></h4>
                    <p class="weui-media-box__desc"><%#Eval("Detail") %></p>
                    <ul class="weui-media-box__info">
                        <li class="weui-media-box__info__meta"><i class="zi zi_clock"></i> <%#Eval("HisTime","{0:yyyy/MM/dd HH:mm}") %></li>
                    </ul>
                </div>
            </div>
                    </div>
            </ItemTemplate>
            <FooterTemplate></FooterTemplate>
        </ZL:RepeaterMB>
</div>
    
</asp:Content>
<asp:Content runat="server" ContentPlaceHolderID="Script">

</asp:Content>