<%@ Page Language="C#" AutoEventWireup="true" CodeFile="Default.aspx.cs" Inherits="Extend_Teacher_Default" MasterPageFile="~/Extend/Common/Main.master" %>
<asp:Content runat="server" ContentPlaceHolderID="head"><title>教师中心</title></asp:Content>
<asp:Content runat="server" ContentPlaceHolderID="Content">
<section class="container Parents_top">
    <div class="row">
    <div class="col-4 Parents_top_l">
        <a href="javascript:;"><img src="<%=mu.UserFace %>" onerror="shownopic(this);" alt="admin"></a>
        <a href="javasrcipt:;">老师</a>
    </div>
    <div class="col-8 Parents_top_r">
        <ul>
            <li><i class="zi zi_useralt"></i> 用户名：<%:mu.UserName %><a href="/User/User/LogOut"  class="float-right"><i class="zi zi_signoutalt" zico="出口标志"></i></a></li>
            <li><i class="zi zi_bulbGlow"></i> 昵称：<%:mu.HoneyName %></li>
            <li><i class="zi zi_arice"></i> 状态：<asp:Label runat="server" ID="Status_L"></asp:Label></li>
            <li><i class="zi zi_bells"></i> 加入时间：<%:mu.RegTime.ToString("yyyy-MM-dd") %></li>
        </ul>
    </div>
    </div>
    </section>

    <div class="container user_list_ul">
        <ul>
            <li><a href="javascript:;" onclick="editInfo();"><i class="zi zi_fileLine"></i>维护个人教师档案 <small><i class="zi zi_pathRight"></i></small></a></li>
            <li style="position:relative;">
                <a href="/extend/order.aspx">
                    <i class="zi zi_cartarrowdown"></i>订单管理 <small><i class="zi zi_pathRight"></i></small>
                    <%=ZoomLa.Sns.ExHelper.ShowTip("order") %>
                </a>
            </li>
            <li><a href="/extend/teacher/MyStudent.aspx"><i class="zi zi_user"></i>我的学员 <small><i class="zi zi_pathRight"></i></small></a></li>
        <%--    <li><a href="/User/Message/MessageOutbox"><i class="zi zi_bubbleSquare"></i>消息管理 <small><i class="zi zi_pathRight"></i></small></a></li>--%>
            <li><a href="/PClass?id=22"><i class="zi zi_commentdots"></i>评价中心 <small><i class="zi zi_pathRight"></i></small></a></li>
            <li><a href="/User/Change/Pwd"><i class="zi zi_edit"></i>修改密码 <small><i class="zi zi_pathRight"></i></small></a></li>
            <li><a href="/User/Change/Mobile"><i class="zi zi_cog"></i>设置 <small><i class="zi zi_pathRight"></i></small></a></li>
            <li><asp:Label runat="server" ID="store_l"></asp:Label></li>
        </ul>
    </div>
</asp:Content>
<asp:Content runat="server" ContentPlaceHolderID="Script">
    <script>
        function editInfo()
        {
            var gid = "<%:Gid%>";
            var url = "/User/Content/AddContent?ID=" + gid;
            if (gid != "0") {
                if (!confirm("确定要修改吗，待审核状态无法接订单")) { return false; }
            }
            else { url += "&ModelID=<%:(int)ZoomLa.Sns.ExConast.ModelInfo.老师申请%>&NodeID=37"; }
            location = url;
        }
    </script>
</asp:Content>