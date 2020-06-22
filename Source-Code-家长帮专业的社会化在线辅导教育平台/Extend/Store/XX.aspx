<%@ Page Language="C#" AutoEventWireup="true" CodeFile="XX.aspx.cs" Inherits="Extend_Store_XX" MasterPageFile="~/Extend/Common/Main.master" %>
<asp:Content runat="server" ContentPlaceHolderID="head"><title>我的下线</title></asp:Content>
<asp:Content runat="server" ContentPlaceHolderID="Content">
<header class="mteacher_header">
    <div class="addcontent_top" style="background-color:#1ec1a7;">
        <a href="Default.aspx"><i class="zi zi_arrowLeft"></i></a>
    </div>
</header>
<section class="container Parents_top">
    <div class="row">
        <div class="col-12 Parents_top_l">
            <a href="#"><i class="zi zi_digg zi_3x"></i></a>
            <a href="#">我的下线</a>
        </div>
    </div>
</section>
<div class="container user_list_ul">
<ul>
   <asp:Repeater runat="server" ID="RPT">
       <ItemTemplate>
            <li><%#ZoomLa.BLL.B_User.GetUserName(Eval("HoneyName"),Eval("UserName")) %><small><i class="zi zi_userclock"></i> <%#Eval("RegTime","{0:yyyy-MM-dd}") %></small></li>
       </ItemTemplate>
   </asp:Repeater>
</ul>
</div>
</asp:Content>
<asp:Content runat="server" ContentPlaceHolderID="Script">

</asp:Content>