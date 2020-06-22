<%@ Page Language="C#" AutoEventWireup="true" CodeFile="Store.aspx.cs" Inherits="Extend_Admin_Store" MasterPageFile="~/Manage/I/Index.Master" %>
<asp:Content runat="server" ContentPlaceHolderID="head"><title>店铺管理</title></asp:Content>
<asp:Content runat="server" ContentPlaceHolderID="Content">
<%=Call.SetBread(new Bread[] {
new Bread("{manage}","工作台"),
new Bread(Request.RawUrl,"店铺管理")
}) %>
<div class="list_choice">
<div class="input-group" style="margin-bottom:5px;">
    <asp:TextBox runat="server" ID="skey_t" class="form-control" placeholder="请输入店铺名称"></asp:TextBox>
    <span class="input-group-append">
        <asp:Button runat="server" ID="skey_btn" Text="筛选" OnClick="skey_btn_Click" class="btn btn-info"/>
    </span>
</div>
   <table class="table table-bordered table-striped">
       <tr>
           <td></td>
           <td>ID</td>
           <td>店铺名</td>
           <td>申请人</td>
           <td>申请时间</td>
           <td>状态</td>
           <td>收入</td>
           <td>操作</td>
       </tr>
      <ZL:Repeater runat="server" ID="RPT" OnItemCommand="RPT_ItemCommand" PageSize="10"
          PagePre="<tr><td class='text-center' colspan='10'>" PageEnd="</td></tr>">
          <ItemTemplate>
              <tr>
                  <td>
                      <input type="checkbox" name="idchk" value="<%#Eval("ID") %>"/>
                  </td>
                  <td><%#Eval("ID") %></td>
                  <td><%#Eval("StoresName") %></td>
                  <td> 
                      <a href="javascript:;" onclick="user.showuinfo(<%#Eval("djid") %>);"><%#ZoomLa.BLL.B_User.GetUserName(Eval("HoneyName"),Eval("UserName")) %></a>
                  </td>
                  <td><%#Eval("cdate") %></td>
                  <td><%#ShowStatus() %></td>
                  <td><%#Eval("moneyIn","{0:F2}") %></td>
                  <td>
                      <a href="javascript:;" onclick="ShowComDiag('SRTJ.aspx?UserID=<%#Eval("djid") %>','');" class="btn btn-info btn-sm"><i class="zi zi_dollarSign"></i> 收入详情</a>
                      <asp:LinkButton runat="server" CommandName="audit" CommandArgument='<%#Eval("ID") %>' class="btn btn-info btn-sm" Visible='<%#ZoomLa.Common.DataConverter.CLng(Eval("dpzt"))==0 %>'>审核通过</asp:LinkButton>
                      <asp:LinkButton runat="server" CommandName="unaudit" CommandArgument='<%#Eval("ID") %>' class="btn btn-outline-info btn-sm" Visible='<%#Eval("dpzt","")=="99" %>'>取消审核</asp:LinkButton>
                  </td>
              </tr>
          </ItemTemplate>
          <FooterTemplate></FooterTemplate>
      </ZL:Repeater>
   </table>
</div>
</asp:Content>
<asp:Content runat="server" ContentPlaceHolderID="ScriptContent">
<script src="/JS/Controls/ZL_Dialog.js"></script>
<script src="/JS/ICMS/ZL_Common.js"></script>
</asp:Content>