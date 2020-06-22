<%@ Page Language="C#" AutoEventWireup="true" CodeFile="Store.aspx.cs" Inherits="Extend_Common_Store" MasterPageFile="~/Extend/Common/Main.master" %>
<asp:Content runat="server" ContentPlaceHolderID="head"><title>店铺信息</title></asp:Content>
<asp:Content runat="server" ContentPlaceHolderID="Content">
<header class="mteacher_header" style="position:fixed;top:0px;width:100%;">
    <div class="addcontent_top">
        <a href="javascript:history.back(-1)"><i class="zi zi_arrowLeft"></i></a>
        <small id="add_title">店铺信息</small>
    </div>
</header>
<div style="height:20px;"></div>
<section>
    <div class="weui-cells weui-cells_form">
        <div class="weui-cell">
            <div class="weui-cell__hd">
                <label class="weui-label">店铺名称</label></div>
            <div class="weui-cell__bd">
                <ZL:TextBox runat="server" ID="StoreName_T" class="weui-input" placeholder="请输入店铺名称"  AllowEmpty="false" MaxLength="15"/>
            </div>
        </div>
    </div>
    <div class="weui-btn-area">
        <asp:Button runat="server" class="weui-btn weui-btn_primary" ID="Save_Btn" OnClick="Save_Btn_Click" Text="申请成为店主" />
    </div>
</section>
</asp:Content>
<asp:Content runat="server" ContentPlaceHolderID="Script">

</asp:Content>