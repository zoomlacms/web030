<%@ Page Language="C#" AutoEventWireup="true" CodeFile="MyStudent.aspx.cs" Inherits="Extend_Teacher_MyStudent" MasterPageFile="~/Extend/Common/Main.master" %>
<asp:Content runat="server" ContentPlaceHolderID="head"><title>学员信息</title></asp:Content>
<asp:Content runat="server" ContentPlaceHolderID="Content">
<header class="mteacher_header">
    <div class="addcontent_top">
        <a href="javascript:history.back(-1)"><i class="zi zi_arrowLeft"></i></a>
        <small id="add_title">学员信息</small>
    </div>
</header>
<div style="height:38px;"></div>
<div class="mbtab">
    <div class="item active" onclick="mbtab.set(this);" data-tab="tab1">生效</div>
    <div class="item" onclick="mbtab.set(this);" data-tab="tab2">历史</div>
</div>

<section class="mteacher_list">
<div id="tab1" class="mbtab-panel active">
<ul>
    <ZL:RepeaterMB ID="RPT" runat="server" PageSize="10" PagePre="">
        <ItemTemplate>
            <li><a href="javascript:;">
                <img class="list_left" src="<%#Eval("salt") %>" onerror="shownopic(this);" style="border-radius: 50%;">
                <div class="list_right">
                    <strong><%#ZoomLa.BLL.B_User.GetUserName(Eval("HoneyName"),Eval("UserName")) %></strong>
                    <abbr class="abbr_p"><small><%#Eval("sznj") %></small></abbr>
                    <abbr class="abbr_p"><small><%#Eval("szsf")+" "+Eval("xxdz") %></small></abbr>
                </div>
            </a>
            </li>
        </ItemTemplate>
    </ZL:RepeaterMB>
</ul>
<div class="empty_tip" id="empty1">
    <i class="zi zi_boxopen"></i>
    <div class="text">没有生效中的信息</div>
</div>
</div>
<div id="tab2" class="mbtab-panel">
    <ul>
        <ZL:Repeater ID="RPT2" runat="server" PageSize="10" PagePre="">
            <ItemTemplate>
                  <li><a href="javascript:;">
                <img class="list_left" src="<%#Eval("salt") %>" onerror="shownopic(this);" style="border-radius: 50%;">
                <div class="list_right">
                    <strong><%#ZoomLa.BLL.B_User.GetUserName(Eval("HoneyName"),Eval("UserName")) %></strong>
                    <abbr class="abbr_p"><small><%#Eval("sznj") %></small></abbr>
                    <abbr class="abbr_p"><small><%#Eval("szsf")+" "+Eval("xxdz") %></small></abbr>
                </div>
            </a>
            </li>
            </ItemTemplate>
        </ZL:Repeater>
    </ul>
<div class="empty_tip" id="empty2">
    <i class="zi zi_boxopen"></i>
    <div class="text">没有可用的历史信息</div>
</div>
</div>

</section>

</asp:Content>
<asp:Content runat="server" ContentPlaceHolderID="Script">

</asp:Content>