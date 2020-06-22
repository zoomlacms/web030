<%@ Page Language="C#" AutoEventWireup="true" CodeFile="SRTJ.aspx.cs" Inherits="Extend_Admin_SRTJ" MasterPageFile="~/Manage/I/Default.Master" %>
<asp:Content runat="server" ContentPlaceHolderID="head"><title>收入统计</title></asp:Content>
<asp:Content runat="server" ContentPlaceHolderID="Content">
<%--<%=Call.SetBread(new Bread[] {
new Bread("{manage}","工作台"),
new Bread(Request.RawUrl,"收入统计")
}) %>--%>
<style type="text/css">
    #navHolder{display:none;}
</style>
<div class="" style="width:100%;">
<div class="input-group" style="margin-bottom:5px;">
    <asp:TextBox runat="server" ID="skey_t" class="form-control" placeholder="请输入关键词"></asp:TextBox>
    <span class="input-group-append">
        <asp:Button runat="server" ID="skey_btn" Text="筛选" OnClick="skey_btn_Click" class="btn btn-info"/>
    </span>
</div>
   <table class="table table-bordered table-striped">
       <tr>
           <td>ID</td>
           <td>时间</td>
           <td>备注</td>
       </tr>
      <ZL:Repeater runat="server" ID="RPT" OnItemCommand="RPT_ItemCommand" PageSize="10"
          PagePre="<tr><td class='text-center' colspan='10'>" PageEnd="</td></tr>">
          <ItemTemplate>
              <tr>
                  <td><%#Eval("ExpHisID") %></td>
                  <td><%#Eval("HisTime") %></td>
                  <td><%#Eval("Detail") %></td>
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