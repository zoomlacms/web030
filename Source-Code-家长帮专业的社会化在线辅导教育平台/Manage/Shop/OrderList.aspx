﻿<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="OrderList.aspx.cs" Inherits="ZoomLaCMS.Manage.Shop.OrderList" MasterPageFile="~/Common/Master/Empty2.master" %>
<%@ Import Namespace="ZoomLa.Model" %>
<%@ Import Namespace="ZoomLa.BLL" %>
<asp:Content runat="server" ContentPlaceHolderID="head">
<link href="/App_Themes/v4style_patch.css" rel="stylesheet" />
<title>订单列表</title>
<script>location = "/Extend/Admin/Order.aspx";</script>

</asp:Content>
<asp:Content runat="server" ContentPlaceHolderID="Content" Visible="false">
    <div id="BreadDiv" class="mysite">
        <div>
            <ol id="BreadNav" class="breadcrumb fixed-top">
                <li class="breadcrumb-item"><a href="ProductManage.aspx">商城管理</a></li>
                <li class="breadcrumb-item"><a href="OrderList.aspx">订单管理</a></li>
                <li class="breadcrumb-item"><a href="OrderList.aspx">订单列表</a> [<a href="AddOrder.aspx?">添加订单</a>]</li>
                <div id="help" class="pull-right text-center"><a href="javascript:;" class="help_btn active" onclick="selbox.toggle(cfg);"><i class="zi zi_search" zico="搜索"></i></a></div>
                <div id="sel_box">
                    <div class="input-group">
                        <asp:TextBox runat="server" ID="ProName_T" class="form-control max20rem" placeholder="商品名称" />
                        <asp:TextBox runat="server" ID="OrderNo_T" class="form-control max20rem" placeholder="订单号" />
                        <ZL:TextBox runat="server" ID="ReUser_T" class="form-control max20rem"  placeholder="收货人"/>
                        <asp:TextBox runat="server" ID="Mobile_T" class="form-control max20rem" placeholder="手机号" ValidType="MobileNumber"  />
                        <asp:TextBox runat="server" ID="UserID_T" class="form-control max20rem" placeholder="用户ID 多个用户用,号分隔" />
                        <asp:TextBox runat="server" ID="ExpSTime_T" class="form-control max20rem" placeholder="发货时间起始" onclick="WdatePicker({maxDate:'#F{$dp.$D(\'ExpETime_T\')}'});"/>
                        <asp:TextBox runat="server" ID="ExpETime_T" class="form-control max20rem" placeholder="发货时间结束" onclick="WdatePicker({minDate:'#F{$dp.$D(\'ExpSTime_T\')}'});"/>
						<div class="input-group-append">
							<span class="input-group-text" title="支持多条件查询"><i class="zi zi_leaf" zico="叶子"></i></span>
					  </div>
                        
                    </div>
                    <div class="input-group">
                        <asp:DropDownList runat="server" ID="StoreType_DP" class="form-control max20rem">
                            <asp:ListItem Value="all">商城与店铺</asp:ListItem>
                            <asp:ListItem Value="shop">仅商城</asp:ListItem>
                            <asp:ListItem Value="store">仅店铺</asp:ListItem>
                        </asp:DropDownList>
                        <asp:DropDownList runat="server" ID="SkeyType_DP" class="form-control max20rem">
                            <asp:ListItem Value="exp" Selected="True">快递单号</asp:ListItem>
                            <asp:ListItem Value="oid">订单ID</asp:ListItem>
                        </asp:DropDownList>
                        <asp:TextBox runat="server" ID="Skey_T" class="form-control max20rem" placeholder="请输入关键词" />
                        <asp:TextBox runat="server" ID="Remind_T" class="form-control max20rem" placeholder="订单备注"></asp:TextBox>
                        <asp:TextBox runat="server" ID="STime_T" class="form-control max20rem" placeholder="订单创建起始时间" onclick="WdatePicker({maxDate:'#F{$dp.$D(\'ETime_T\')}'});" />
                        <asp:TextBox runat="server" ID="ETime_T" class="form-control max20rem" placeholder="订单创建结束时间" onclick="WdatePicker({minDate:'#F{$dp.$D(\'STime_T\')}'});" />
						<div class="input-group-append">
						 <asp:Button runat="server" ID="Skey_Btn" class="input-group-text btn btn-outline-info" OnClick="Skey_Btn_Click" Text="查询" />
					  </div>
					  <div class="input-group-append">
						 <button type="button" class="input-group-text btn btn-outline-info" onclick="cleartxt();"><i class="zi zi_redoalt" zico="重做标识"></i>清除查询</button>
					  </div>
                    </div>
                    <div class="clearfix"></div>
                </div>
            </ol>
        </div>
    </div>
<div id="maindiv">
    <ul id="ordernav" class="nav nav-tabs list_choice">
       <li class="nav-item" data-type="all"><a class="nav-link" href="<%=BaseUrl %>"><asp:Label runat="server" ID="order_all_l" Text="全部订单"></asp:Label></a></li>
       <li class="nav-item" data-type="unpaid"><a class="nav-link" href="<%=BaseUrl %>&filter=unpaid"><asp:Label runat="server" ID="order_unpaid_l" Text="待付款"></asp:Label></a></li>
       <li class="nav-item" data-type="prepay"><a class="nav-link" href="<%=BaseUrl %>&filter=prepay"><asp:Label runat="server" ID="order_prepay_l" Text="预付款"></asp:Label></a></li>
       <li class="nav-item" data-type="paid"><a class="nav-link" href="<%=BaseUrl %>&filter=paid"><asp:Label runat="server" ID="order_paid_l" Text="已付款"></asp:Label></a></li>
       <li class="nav-item" data-type="unexp"><a class="nav-link" href="<%=BaseUrl %>&filter=unexp"><asp:Label runat="server" ID="order_unexp_l" Text="待发货"></asp:Label></a></li>
       <li class="nav-item" data-type="exped"><a class="nav-link" href="<%=BaseUrl %>&filter=exped"><asp:Label runat="server" ID="order_exped_l" Text="已发货"></asp:Label></a></li>
       <li class="nav-item" data-type="finished"><a class="nav-link" href="<%=BaseUrl %>&filter=finished"><asp:Label runat="server" ID="order_finished_l" Text="交易完成"></asp:Label></a></li>
       <li class="nav-item" data-type="unrefund"><a class="nav-link" href="<%=BaseUrl %>&filter=unrefund"><asp:Label runat="server" ID="order_unrefund_l" Text="待退款"></asp:Label></a></li>
       <li class="nav-item" data-type="refunded"><a class="nav-link" href="<%=BaseUrl %>&filter=refunded"><asp:Label runat="server" ID="order_refunded_l" Text="退款完成"></asp:Label></a></li>
       <li class="nav-item" data-type="recycle"><a class="nav-link" href="<%=BaseUrl %>&filter=recycle"><asp:Label runat="server" ID="order_recycle_l" Text="回收站"></asp:Label></a></li>
    </ul>
    <div class="orderlist" id="orderlist">
            <div runat="server" id="empty_div" visible="false" class="alert alert-info">没有匹配的订单信息</div>
            <ZL:Repeater ID="Order_RPT" runat="server"  PagePre="<div class='clearfix'></div><div class='text-center foot_page'><label class='pull-left'><input type='checkbox' id='chkAll'/>全选</label>" PageEnd="</div>"
                 OnItemDataBound="Order_RPT_ItemDataBound" OnItemCommand="Order_RPT_ItemCommand" PageSize="10" BoxType="dp">
                <ItemTemplate>
                    <div class="order-item">
                        <table class="table prolist">
                            <thead>
                            <tr class="tips_div">
                                <th class="orderinfo" colspan="8">
                                    <div style="display: inline-block; width: 1100px;font-size:12px;">
                                        <span><strong><label><input type="checkbox" name="idchk" value="<%#Eval("ID") %>" style="position:relative;top:2px;"/>编号：</strong><%#Eval("ID") %></label></span>
                                        <span><strong>订单号：</strong><a href="OrderListInfo.aspx?ID=<%#Eval("ID") %>" title="订单详情"><%#Eval("OrderNo") %></a></span>
                                        <span><strong>下单时间：</strong><%#Eval("AddTime") %></span>
                                        <span><strong>付款单号：</strong><%#GetPayInfo() %></span>
                                        <span><strong>发货时间：</strong><%#GetExpSTime() %></span>
                                        <span><strong>推荐人：</strong><%#GetPUserInfo() %></span>
                                    </div>
                                     <span style="font-size:16px;font-weight:bolder;">店铺：<asp:Label ID="Store_L" runat="server"/></span>
                                    <a href="javascript:;" title="收缩/展开" onclick="order.slideup(this);"><i class="zi zi_circleDowns" style="font-size: 20px;"></i></a>
                                    <asp:LinkButton runat="server" CommandArgument='<%#Eval("ID") %>' CommandName="del2" Visible='<%#Filter.Equals("recycle")?false:true %>'
                                        class="pull-right btn btn-xs btn-danger margin_l5" OnClientClick="return confirm('确定要移入回收站吗');"><i class="zi zi_trashalt" zico="垃圾箱竖条"></i> 删除订单</asp:LinkButton>
                                    <a href="Addon/ExpPrint.aspx?ID=<%#Eval("ID") %>" class="pull-right btn btn-xs btn-info <%#ZoomLa.Common.DataConverter.CLng(Eval("ExpressNum"))>0?"":"hidden" %>"><i class="zi zi_print" zico="打印机"></i> 打印快递单</a>
                                </th>
                            </tr></thead>
                            <tbody class="prowrap">
                                <asp:Repeater ID="Pro_RPT" runat="server" EnableViewState="false" OnItemDataBound="Pro_RPT_ItemDataBound">
                                    <ItemTemplate>
                                        <tr class="<%#Container.ItemIndex>4?"pro_more hidden":"" %>">
                                            <td style="text-align: left; border-right: none; border-left: none;">
                                                <span>
                                                    <a href="<%#GetShopUrl() %>" target="_blank">
                                                        <img src="<%#GetImgUrl() %>" onerror="shownopic(this);" class="img50" /></a>
                                                    <span><%#Eval("Proname") %></span>
                                                </span>
                                                <%#Eval("PClass","").Equals("2")?"<input type='button' class='btn btn-info' value='促销组合' onclick=\"order.showSuit('"+Eval("CartID")+"');\">":"" %>
                                            </td>
                                            <td class="td_md goodservice" style="border-left: none;"><%#GetRepair() %></td>
                                            <td class="td_md"><%#Eval("Shijia","{0:f2}") %></td>
                                            <td class="td_md gray9">x<%#Eval("Pronum") %></td>
                                            <asp:Literal runat="server" ID="Order_Lit" EnableViewState="false"></asp:Literal>
                                        </tr>
                                        <asp:Panel runat="server" Visible='<%#Container.ItemIndex==5?true:false %>'>
                                            <tr><td colspan="4" class="text-left" style="line-height:30px;height:30px;"><a href="javascript:;" onclick="order.showMore(this);" class="btn btn-info">查看更多商品 <i class="zi zi_forRight" zico="右指"></i></a></td></tr>
                                        </asp:Panel>
                                    </ItemTemplate>
                                </asp:Repeater>
                                <%#GetMessage() %>
                            </tbody>
                        </table>
                    </div>
                </ItemTemplate>
                <FooterTemplate></FooterTemplate>
            </ZL:Repeater>
     </div>
    <div class="opdiv">
        <%-- <button type="button" class="btn btn-primary" onclick="OutToExcel();">下载概览</button>--%>
        <asp:Button ID="DownDetails_B" runat="server" CssClass="btn btn-info" OnClick="DownDetails_B_Click" Text="下载详单" />
        <div id="op_normal" runat="server" visible="false" style="display: inline-block;">
            <asp:Button ID="Sure_Btn" class="btn btn-info" Text="确认订单" runat="server" OnClick="Sure_Btn_Click" OnClientClick="return confirm('要确认订单吗?');" />
            <asp:Button ID="Recycle_Btn" class="btn btn-info" Text="移除订单" runat="server" OnClick="Recycle_Btn_Click" OnClientClick="return confirm('确认要移入回收站吗?');" />
        </div>
        <div id="op_recycle" runat="server" visible="false" style="display: inline-block;">
            <asp:Button runat="server" ID="BatRecover_Btn" class="btn btn-info" Text="批量还原" OnClick="BatRecover_Btn_Click" />
            <asp:Button runat="server" ID="BatDel_Btn" class="btn btn-danger" Text="批量删除" OnClick="BatDel_Btn_Click" OnClientClick="return confirm('不可恢复性删除,确定要移除订单吗?');" />
            <asp:Button runat="server" ID="Clear_Btn" class="btn btn-danger" Text="清空回收站" OnClick="Clear_Btn_Click" OnClientClick="return confirm('不可恢复性删除,确定要移除订单吗?');" />
        </div>
        <div class="pull-right mr-5"><span>金额合计:</span><span class="rd_red_l"><%=TotalSum_Hid.Value %></span></div>
    </div>
</div>
<asp:HiddenField runat="server" ID="TotalSum_Hid" />
</asp:Content>
<asp:Content runat="server" ContentPlaceHolderID="Script">

</asp:Content>

