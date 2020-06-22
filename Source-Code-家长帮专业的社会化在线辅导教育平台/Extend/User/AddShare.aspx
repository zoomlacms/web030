<%@ Page Language="C#" AutoEventWireup="true" CodeFile="AddShare.aspx.cs" Inherits="Extend_User_AddShare" MasterPageFile="~/Extend/Common/Main.master" %>
<asp:Content runat="server" ContentPlaceHolderID="head"><title>订单评价</title></asp:Content>
<asp:Content runat="server" ContentPlaceHolderID="Content">
 <header class="mteacher_header" style="position:fixed;top:0px;width:100%;">
    <div class="addcontent_top">
        <a href="javascript:history.back(-1)"><i class="zi zi_arrowLeft"></i></a>
        <small id="add_title">订单评价</small>
    </div>
</header>
<div style="height:20px;"></div>
<section id="shareorder">
    <div class="weui-cells weui-cells_form ">
        <div class="weui-cell">
            <div class="weui-cell__hd">
                <label class="weui-label">标题</label></div>
            <div class="weui-cell__bd">
                 <asp:Label runat="server" ID="Title_T" CssClass="weui-input"></asp:Label>
            </div>
        </div>
         <div class="weui-cell">
             <div class="weui-cell__hd">
                 <label class="weui-label">评分</label>
             </div>
             <div class="weui-cell__bd">
                 <div id="star_div">
                     <i class="staricon zi zi_star" data-val="1"></i>
                     <i class="staricon zi zi_star" data-val="2"></i>
                     <i class="staricon zi zi_star" data-val="3"></i>
                     <i class="staricon zi zi_star" data-val="4"></i>
                     <i class="staricon zi zi_star" data-val="5"></i>
                     <input type="hidden" id="star_hid" name="star_hid" value="0" />
                 </div>
            </div>
        </div>
        <div class="weui-cell">
             <div class="weui-cell__hd">
                 <label class="weui-label">评价</label>
             </div>
             <div class="weui-cell__bd">
                 <textarea id="MsgContent_T" name="MsgContent_T" placeholder="快分享你课程的体验吧" class="form-control msgcon" maxlength="500" style="height: 120px; resize: none;"></textarea>
                 <div class="text-right tips pull-right">10-500字</div>
            </div>
        </div>


   
    </div>

    <div class="weui-btn-area">
        <div class="alert alert-info" runat="server" id="tip_div" visible="false"></div>
        <asp:Button runat="server" class="weui-btn weui-btn_primary" ID="Save_Btn" OnClick="Save_Btn_Click" Text="添加评论" />
    </div>
</section>   
    
    
    
    
    
<%--    <div class="shareorder">
        <div class="row">
            <div class="col-md-3 td_left text-right">晒单：</div>
            <div class="col-md-9">
                <input type="button" id="upfile_btn" class="btn btn-info" value="添加图片" />
                <div style="margin-top: 10px;" id="uploader" class="uploader">
                    <ul class="filelist"></ul>
                </div>
                <input type="hidden" id="Attach_Hid" name="Attach_Hid" />
            </div>
        </div>
       <div class="row">
            <div class="col-md-3"></div>
            <div class="col-md-9">
                <input type="button" class="btn btn-primary" onclick="SubCheck();" value="评价并继续" />
                <label><input type="checkbox" id="IsHideName" name="IsHideName" class="margin_l20" value="1" />匿名评价</label>
            </div>
        </div>
      
    </div>--%>
</asp:Content>
<asp:Content runat="server" ContentPlaceHolderID="Script">
<style type="text/css">
.shareorder .row{margin-bottom:5px;}
.img50 {width:50px;height:50px;}
.img80 {width:80px;height:80px;}
.staricon{font-size:1.2em; color:#ccc; cursor:pointer;}
.staricon.fa-star {color:#FBA507;}
.comments-header {border:1px solid #ddd;padding:0 20px;background:#f7f7f7;
					height:30px;line-height:30px;}
.sphead {text-align:center;font-weight:700;display:inline-block;}
.column1 {width:550px;}
.column2 {width:120px;text-align:left;}
.column3 {width:180px;}
.column4 {width:130px;text-align:left;}
/*回复主列表 上右下左*/
.com-item-main {width:100%;}
.comments-item {padding:10px 20px 10px 20px;margin-top:-1px;border:1px solid #ddd;font-size:12px;color:#666;}
.comments-item .time {color:#999;font-weight:400;display:inline-block;}
.comments-item .user-item {padding-bottom:3px;}
.comments-item .user_group {color:#088000;margin-left:10px;}
.comments-item .p-imgs {margin-top:5px;}
.comments-item .imgsp {padding:3px;margin-right:3px; display:inline-block;border:1px solid #ddd;cursor:pointer;}
.comments-item .imgsp:hover {border:1px solid #31708f;}
.comments-item .comment-operate {padding-top:2px;}
.comments-item .linkgray{cursor:pointer;color:#999;}
.comments-item .reply-operate {display:none;margin-top:5px;text-align:right;background:#f7f7f7;padding:10px 10px 15px;border:1px solid #ddd;}
/*回复列表*/
.comment-reply-item {border-top:1px dotted #ccc;padding:10px 0 10px 15px; }
</style>
<link href="/JS/Controls/ZL_Webup.css" rel="stylesheet" />
<script src="/JS/Controls/ZL_Dialog.js"></script>
<script src="/JS/Controls/ZL_Webup.js"></script>
<script>
    $(function () {
        $("form").validate({});
        jQuery.validator.addMethod("msgcon", function (value) {
            return (value.length > 9);
        }, "心得最少需要10个字符!");
        ZL_Webup.config.json.ashx = "";
        ZL_Webup.config.json.accept = "img";
        $("#upfile_btn").click(ZL_Webup.ShowFileUP);
        StarInit();
        //---
        $("input[name=cart_rad]")[0].checked = true;
    })
    function AddAttach(file, ret, pval) { return ZL_Webup.AddAttach(file, ret, pval); }
    function reloadPage() { }
    //评星
    function StarInit() {
        $(".staricon").hover(function () {
            //fa-star-o空心,
            $(this).removeClass("fa-star-o").addClass("fa-star");
            $(this).prevAll(".staricon").removeClass("fa-star-o").addClass("fa-star");
        }, function () {
            StarByVal($("#star_hid").val());
        }).click(function () {
            $("#star_hid").val($(this).data("val"));
            StarByVal($(this).data("val"));
        });
        //移出div块,除非已click,否则清除值
        $("#star_div").mouseleave(function () {
            var val = $("#star_hid").val();
            StarByVal(val);
        });
        //根据val点亮或熄灭评星
        function StarByVal(val) {
            if (val == "" || val == 0 || val == "0") { $(".staricon").removeClass("fa-star").addClass("fa-star-o"); }
            else
            {
                var ref = $(".staricon[data-val=" + val + "]"); ref.removeClass("fa-star-o").addClass("fa-star");
                ref.prevAll().removeClass("fa-star-o").addClass("fa-star");
                ref.nextAll().removeClass("fa-star").addClass("fa-star-o");
            }
        }
    }
    //-----
    function SubCheck() {
        var score = parseInt($("#star_hid").val());
        if (score < 1 || score > 5) { alert("请选定评分"); return false; }
        $("form").submit();
    }
</script>
</asp:Content>