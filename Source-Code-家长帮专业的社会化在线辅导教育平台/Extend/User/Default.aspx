<%@ Page Language="C#" AutoEventWireup="true" CodeFile="Default.aspx.cs" Inherits="Extend_User_Default" MasterPageFile="~/Extend/Common/Main.master" %>
<%@ Import Namespace="ZoomLa.Sns" %>
<asp:Content runat="server" ContentPlaceHolderID="head"><title>用户中心</title></asp:Content>
<asp:Content runat="server" ContentPlaceHolderID="Content">
<section class="container Parents_top">
    <div class="row">
    <div class="col-4 Parents_top_l">
        <a href="javascript:;"><img src="<%=mu.UserFace %>" onerror="shownopic(this);" alt="admin"></a>
        <a href="javasrcipt:;">家长</a>
    </div>
    <div class="col-8 Parents_top_r">
        <ul>
            <li><i class="zi zi_useralt"></i> 用户名：<%:mu.UserName %><a href="/User/User/LogOut" class="float-right"><i class="zi zi_signoutalt" zico="出口标志"></i></a></li>
            <li><i class="zi zi_bulbGlow"></i> 昵称：<%:mu.HoneyName %></li>
            <li><i class="zi zi_bells"></i> 加入时间：<%:mu.RegTime.ToString("yyyy-MM-dd") %></li>
        </ul>
    </div>
    </div>
    </section>

    <div class="container user_list_ul">
        <ul>
            <li runat="server" visible="false" id="student_empty"><a href="/User/Content/AddContent?NodeID=38&ModelID=<%:(int)ExConast.ModelInfo.家长申请 %>" class="text-danger"><i class="zi zi_bulb" zico="灯泡"></i> 未添加学员信息-维护信息才能使用完整功能 <small><i class="zi zi_pathRight"></i></small></a></li>
            <li runat="server" visible="false" id="student_ok"><a href="/User/Content/AddContent?ID=<%=Gid %>"><i class="zi zi_bookopen"></i>学员信息 <small><i class="zi zi_user"></i></small></a></li>
            <li style="position:relative;">
                <a href="/Extend/order.aspx"><i class="zi zi_cartarrowdown"></i>订单管理 <small><i class="zi zi_pathRight"></i></small></a>
                <%=ExHelper.ShowTip("order") %>
            </li>
            <li><a href="/Extend/User/MyTeacher.aspx"><i class="zi zi_bookopen"></i>我的老师 <small><i class="zi zi_pathRight"></i></small></a></li>
           <%-- <li><a href="/User/Message/MessageOutbox"><i class="zi zi_bubbleSquare"></i>消息管理 <small><i class="zi zi_pathRight"></i></small></a></li>--%>
            <li><a href="/User/info/UserBase"><i class="zi zi_useralt"></i>我的信息 <small><i class="zi zi_pathRight"></i></small></a></li>
            <li><a href="/PClass?id=22"><i class="zi zi_bubbleSquare"></i>讨论专区 <small><i class="zi zi_pathRight"></i></small></a></li>
            <li><a href="tel:<%:ZoomLa.Components.SiteConfig.SiteInfo.MasterPhone %>"><i class="zi zi_service"></i>联系客服 <small><i class="zi zi_pathRight"></i></small></a></li>
            <li><a href="/User/Change/Pwd"><i class="zi zi_squareCorrect"></i>修改密码 <small><i class="zi zi_pathRight"></i></small></a></li>
            <li><asp:Label runat="server" ID="store_l"></asp:Label></li>
        </ul>
    </div>
</asp:Content>
<asp:Content runat="server" ContentPlaceHolderID="Script">
<script>
    tipHelper.get("me", function (result) {
        $("#tip_order_cmt").text(result.order_cmt);
        $("#tip_order_cmt").show();
    });
</script>
</asp:Content>