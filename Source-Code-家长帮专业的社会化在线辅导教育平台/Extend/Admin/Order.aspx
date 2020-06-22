<%@ Page Language="C#" AutoEventWireup="true" CodeFile="Order.aspx.cs" Inherits="Extend_Admin_Order" MasterPageFile="~/Manage/I/Index.Master"%>
<asp:Content runat="server" ContentPlaceHolderID="head"><title>订单管理</title></asp:Content>
<asp:Content runat="server" ContentPlaceHolderID="Content">
    <%=Call.SetBread(new Bread[] {
    new Bread("{manage}","工作台"),
    new Bread(Request.RawUrl,"订单管理")

}) %>
<div class="list_choice">
<table class="table table-bordered table-striped">
        <tr>
            <td>ID</td>
            <td>店主</td>
            <td>课程名</td>
            <td>下单人</td>
           <%-- <td>金额</td>--%>
            <td>下单时间</td>
            <td>订单状态</td>
            <td>操作</td>
        </tr>
        <ZL:Repeater runat="server" ID="RPT" PageSize="10" PagePre="<tr class='hidden'><td></td><td colspan='12'><div class='text-center'>" PageEnd="</div></td></tr>"
            OnItemCommand="RPT_ItemCommand">
            <ItemTemplate>
                <tr>
                    <td><%#Eval("ID") %></td>
                    <td><%#ZoomLa.BLL.B_User.GetUserName(Eval("djhname"),Eval("djname")) %></td>
                    <td><%#Eval("spmc") %></td>
                    <td data-uid="<%#Eval("xsrid") %>"><%#Eval("xsr") %></td>
                    <%--<td><%#ZoomLa.Common.DataConverter.CDouble(Eval("dsjg")).ToString("F2") %></td>--%>
                    <td><%#Eval("PubAddTime") %></td>
                    <td><%#ShowStatus() %></td>
                    <td>
                        <asp:LinkButton runat="server" class="btn btn-info btn-sm" CommandArgument='<%#Eval("ID") %>' CommandName="teacher" OnClientClick="return confirm('确认操作？一旦操作就会给店家返钱,并不可逆.');" Visible='<%#ShowBtn("teacher") %>'>老师确认</asp:LinkButton>
                        <asp:LinkButton runat="server" class="btn btn-info btn-sm" CommandArgument='<%#Eval("ID") %>' CommandName="user" OnClientClick="return confirm('确认操作?');" Visible='<%#ShowBtn("user") %>'>家长确认</asp:LinkButton>
                    </td>
                </tr>
            </ItemTemplate>
            <FooterTemplate></FooterTemplate>
        </ZL:Repeater>
    </table>
</div>
<div style="display:none;">
    <asp:Button runat="server" ID="mybind_btn" OnClick="mybind_btn_Click" />
</div>
</asp:Content>

<asp:Content runat="server" ContentPlaceHolderID="ScriptContent">

</asp:Content>
