<%@ Page Language="C#" AutoEventWireup="true" CodeFile="ms.aspx.cs" Inherits="Extend_ms" MasterPageFile="~/Extend/Common/Main.master" ValidateRequest="false" %>
<asp:Content runat="server" ContentPlaceHolderID="head"><title>名师</title></asp:Content>
<asp:Content runat="server" ContentPlaceHolderID="Content">
<style type="text/css">
    .infoItem{background-color:#f59653;border:1px solid #ff6a00;color:#fff !important;padding:3px;text-align:center;min-width:60px;border-radius:6px;font-size:12px;
              margin-bottom:10px;display:inline-block;
    }
   
    .sqItem{display:none;}
    .sqItem small,.weizhi_list_warp_r small{background-color:#999;float:right;border-radius:50%;width:30px;height:30px;text-align:center;margin-top:5px;line-height:30px;color:#fff;}
    .sqItem a{color:#000;}



    dl, ol, ul{margin-bottom:0px;}
    #page_div{display:block;text-align:center;padding-left:1rem;padding-right:1rem;}
    #page_div li{border-top:none;}
    #page_div li a{padding:.5rem .75rem;}
    .btn-area{text-align: right;padding:5px;}
    #qu_div { overflow: auto; height: 18rem; flex-direction: row !important; }
    .slide li{height:40px;}
    .slide li a{line-height:40px;height:40px;}
</style>
<!--<header class="mteacher_header">-->
<header>
<div class="addcontent_top"><a href="javascript:history.back(-1)"><i class="zi zi_arrowLeft"></i></a> <small id="add_title">家长56-老师列表</small></div>


<section class="job-module" style="border-bottom:1px solid #ddd;"> 
<dl class="retrie"> 
<dt class="d-flex">
	<a id="aress" href="javascript:;"><%:ShowText(sq,"位置") %></a>
	<a id="area" href="javascript:;"><%:ShowText(nj,"年级") %></a>
	<a id="wage" href="javascript:;"><%:ShowText(xk,"课程") %></a>
</dt> 
<dd class="aress">
<div class="slide downlist weizhi_list_warp">

<ul class="nav nav-pills tab_ul" id="pills-tab" role="tablist">
  <li class="nav-item">
    <a class="nav-link active" id="pills-home-tab" data-toggle="pill" href="#pills-home">商圈</a>
  </li>
  <li class="nav-item">
    <a class="nav-link" id="pills-profile-tab" data-toggle="pill" href="#pills-profile">地铁</a>
  </li>
</ul>
<div class="tab-content" id="pills-tabContent">
  <div class="tab-pane fade show active" id="pills-home">
    <div class="row weizhi_list">
	<div class="col-5 weizhi_list_l">
	<div id="qu_div" class="nav nav-pills">
        <asp:Repeater runat="server" ID="RPT_QU">
            <ItemTemplate>
                <a class="nav-link home<%#Container.ItemIndex %> quItem" id="qu_<%#Eval("qu") %>" data-num="<%#Eval("qunum") %>" href="#home<%#Eval("qu") %>" onclick="setSQ('<%#Eval("qu") %>');" data-id="<%#Eval("qu") %>"><%#Eval("qu") %></a>
            </ItemTemplate>
        </asp:Repeater>
        <a class="nav-link home0 quItem" onclick="getTo(0,'');">全部</a>
	</div>
	</div>
	<div class="col-7 weizhi_list_r">
	<div class="tab-content" id="v-pills-tabContent">
        <asp:Repeater runat="server" ID="RPT_SQ">
            <ItemTemplate>
                <li data-qu="<%#Eval("qu") %>" data-num="<%#Eval("sqnum") %>" class="sqItem">
                    <a href="javascript:;" onclick="getTo('<%#Eval("qu") %>','<%#Eval("GradeName") %>')"><%# Eval("GradeName") %><small><%#Eval("sqnum") %></small></a>
                </li>
            </ItemTemplate>
        </asp:Repeater>
        <li data-qu="" class="sqItem" id="sq_all_li">
            <a href="javascript:;" onclick="getTo($('#sq_all_li').data('qu'),'')">全部<small><span id="sq_all_sp">0</span></small></a>
        </li>
	</div>
	</div>
	</div>
    <script>
        function setSQ(qu) {
            var $this = $("#qu_" + qu);
            $(".quItem").removeClass("active").removeClass("show");
            $this.addClass("active").addClass("show");
            $(".sqItem").hide();
            if (qu) {
                $(".sqItem").each(function () {
                    if ($(this).data("qu") == qu) {$(this).show();}
                });
                $("#sq_all_sp").text($this.data("num"));//整个区的人数
                $("#sq_all_li").data("qu", qu);
                $("#sq_all_li").show();
            }
        }
        function getTo(qu, sq) {
            location = "/Extend/ms.aspx?nj=<%=nj %>&xk=<%=xk %>&sq=" + sq + "&qu=" + qu;
        }
        $(function () {
            var qu = "<%=qu%>";
            if (qu == "") { qu = $(".quItem:first").data("id"); }
            setSQ(qu);
        })
    </script>
  </div>
  <div class="tab-pane fade" id="pills-profile">
       <div class="row weizhi_list">
		<div class="col-5 weizhi_list_l">
		<div class="nav flex-column nav-pills weizhi_list_warp" id="v-pills-tab" role="tablist" aria-orientation="vertical">
		<%Call.Label("{ZL.Label id=\"收取地铁所有线路\" Cate=\"12\" ParentID=\"0\" order=\"asc\" ShowNum=\"100\" /}"); %>
		</div>
		</div>
		<div class="col-7 weizhi_list_r">
		<div class="tab-content weizhi_list_warp_r" id="v-pills-tabContent">
		<%Call.Label("{ZL.Label id=\"根据线路ID抽取抽取列表\" order=\"asc\" ShowNum=\"100\" /}"); %>
		</div>
		</div>
		</div><!--row end-->
  </div>
</div>
</div><!--downlist end-->
</dd> 

<dd class="area"> 
	<ul class="slide downlist" id="tea_n"> 
		<li><a href="<%=NodeUrl %>?nj=小学&xk=<%=xk %>&sq=<%=sq %>">小学</a></li> 
		<li><a href="<%=NodeUrl %>?nj=初中&xk=<%=xk %>&sq=<%=sq %>">初中</a></li> 
		<li><a href="<%=NodeUrl %>?nj=高中&xk=<%=xk %>&sq=<%=sq %>">高中</a></li> 
        <li><a href="<%=NodeUrl %>?xk=<%=xk %>&sq=<%=sq %>">全部</a></li> 
	</ul> 
</dd> 

<dd class="wage"> 
	<ul class="slide downlist" id="tea_kecheng"> </ul> 
</dd> 
</dl> 
</section> 

</header>
<!--header end-->


<section class="mteacher_list">
<ul>
    <ZL:RepeaterMB runat="server" ID="RPT" PageSize="10" PagePre="<div id='page_div'>" PageEnd="</div>">
        <ItemTemplate>
            <li>
                <a href="/Item/<%#Eval("GeneralID") %>.aspx" style="padding-bottom:0px;">
                    <img class="list_left" src="<%#Eval("salt") %>" onerror="shownopic(this);" style="border-radius: 50%;">
                    <div class="list_right" style="width:100%;">
                        <div><strong><%#ZoomLa.BLL.B_User.GetUserName(Eval("Title"),Eval("HoneyName")) %></strong></div>
                        <div>
                            <%# ShowInfo(Eval("jl"),"教龄") %>
                            <%# ShowInfo(Eval("jzxx"),"名师") %>
                            <%# ShowInfo(Eval("jxfw"),"") %>
                            <%# ShowInfo(Eval("jxms"),"") %>
                        </div>
                        <div><%#Eval("xxdz")+" "+Eval("qu")+" "+Eval("sq") %></div>
                    </div>
                </a>
                <div class="btn-area">
                    <%#ShowEliteBtn() %>
                </div>
            </li>
        </ItemTemplate>
        <FooterTemplate></FooterTemplate>
    </ZL:RepeaterMB>
</ul>
<div class="empty_tip" id="empty1">
    <i class="zi zi_boxopen"></i>
    <div class="text">没有筛选到信息</div>
</div>
</section>
<!--list end-->

<div class="body_mask"></div>
<!--body mask-->

</asp:Content>
<asp:Content runat="server" ContentPlaceHolderID="Script">
<script>
    wxHelper.init();
    var cls = {};
    cls.data = [
        { n: "小学", list: "语文,数学,外语".split(',') },
        { n: "初中", list: "语文,数学,外语,物理,化学,历史,地理,生物,政治".split(',') },
        { n: "高中", list: "语文,数学,外语,物理,化学,历史,地理,生物,政治".split(',') }
    ];
    cls.init = function () {
        var kcTlp = '<li><a href="<%=NodeUrl %>?xk={0}&nj=<%=nj%>&sq=<%=sq%>">{0}</a></li>';
        var list = cls.get();
        for (var i = 0; i < list.length; i++) {
            var tlp = kcTlp.replace("{0}", list[i]).replace("{0}", list[i]);
            $("#tea_kecheng").append(tlp);
        }
        $("#tea_kecheng").append('<li><a href="<%=NodeUrl %>?nj=<%=nj%>&sq=<%=sq%>">全部</a></li>');
    }
    cls.get = function () {
        var nj = "<%:nj%>";
        for (var i = 0; i < cls.data.length; i++) {
            if (cls.data[i].n == nj) { return cls.data[i].list; }
        }
        return cls.data[1].list;
    }
    cls.init();
    var teacher = {
        api: "/Extend/API.ashx?action=",
        //店主推荐老师
        elite: function (id) {
            var ref = this;
            $.post(ref.api + "tea_elite", { "id": id }, function (data) {
                $("#elite_" + id).hide();
                $("#unelite_" + id).show();
            })
        },
        unelite: function (id) {
            var ref = this;
            $.post(ref.api + "tea_unelite", { "id": id }, function (data) {
                $("#elite_" + id).show();
                $("#unelite_" + id).hide();
            })
        },
    };
</script>
<script>
$(function(){
    footer.set("ms");

$('.retrie dt a').click(function(){
		var $t=$(this);
		if($t.hasClass('up')){
			$(".retrie dt a").removeClass('up');
			$('.downlist').hide();
			$('.mask').hide();
			
		/*获取页面文档高度*/
		var height=$(document).height();
		$(".body_mask").css("height","0");
			
		}else{
			$(".retrie dt a").removeClass('up');
			$('.downlist').hide();
			$t.addClass('up');
			$('.downlist').eq($(".retrie dt a").index($(this)[0])).show();//让一个元素显示出来  
			$('.mask').show();
			
		/*获取页面文档高度*/
		var height=$(document).height();
		$(".body_mask").css("height",height);
			
		}
	});
	
	//$(".aress div a:contains('"+$('#aress').text()+"')").addClass('selected');
	//$(".area ul li a:contains('"+$('#area').text()+"')").addClass('selected');
	//$(".wage ul li a:contains('"+$('#wage').text()+"')").addClass('selected');

	/*滑动门初始化*/
	//$(".home1").addClass("active show");
	
})
</script>
</asp:Content>