<%@ Page Language="C#" AutoEventWireup="true" CodeFile="Config.aspx.cs" Inherits="Extend_Admin_Config" MasterPageFile="~/Manage/I/Index.Master"%>
<asp:Content runat="server" ContentPlaceHolderID="head">
<title>订单配置</title>
<style type="text/css">
.input-group{max-width:300px;}
</style>
</asp:Content>
<asp:Content runat="server" ContentPlaceHolderID="Content">
    <table class="table table-bordered table-striped">
        <tr><td colspan="2" class="text-center"><strong>订单配置</strong></td></tr>
        <tr>
            <td style="width:150px;">订单佣金</td>
            <td>
                <div class="input-group">
                    <asp:TextBox runat="server" ID="Order_YJ" class="form-control" MaxLength="6"/>
                    <span class="input-group-append"><span class="input-group-text">元</span></span>
                </div>
                <small>订单的固定佣金金额</small>
            </td>
        </tr>
        <tr>
            <td>平台分成</td>
            <td>
                 <div class="input-group">
                    <asp:TextBox runat="server" ID="Order_PTFC" class="form-control" MaxLength="3" />
                    <span class="input-group-append"><span class="input-group-text">%</span></span>
                </div>
                <small>数值在0-100之间,三个分成数值总额必须为100%</small>
            </td>
        </tr>
        <tr><td>店家分成</td>
            <td>
                <div class="input-group">
                    <asp:TextBox runat="server" ID="Order_DJFC" class="form-control" MaxLength="3" />
                    <span class="input-group-append"><span class="input-group-text">%</span></span>
                </div>
            </td>
        </tr>
        <tr>
            <td>店家上线分成</td>
            <td>
                 <div class="input-group">
                    <asp:TextBox runat="server" ID="Order_DJSXFC" class="form-control" MaxLength="3" />
                    <span class="input-group-append"><span class="input-group-text">%</span></span>
                </div>
                <small>如无上线,则自动转给平台</small>
            </td>
        </tr>
        <tr><td></td><td><asp:Button runat="server" ID="Save_Btn" Text="保存配置" OnClick="Save_Btn_Click" class="btn btn-info"/></td></tr>
    </table>
</asp:Content>
<asp:Content runat="server" ContentPlaceHolderID="ScriptContent">
<style type="text/css">
    small{color:#0094ff;}
</style>
</asp:Content>