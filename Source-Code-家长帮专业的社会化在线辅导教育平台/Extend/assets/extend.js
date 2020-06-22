//teacher,order,user
var siteUrl = "http://" + location.host;
var apiUrl = "/Extend/API.ashx?action=";
var noPic = siteUrl + "/Template/Gredu/style/Images/LOGO_sm.png";
var store = {
    get: function (id, cb) {
        var packet = { "id": id };
        $.post(apiUrl + "store_get", packet, function (data) {
            var model = APIResult.getModel(data);
            if (APIResult.isok(model)) { if (cb) { cb(model); } }
            else { console.error("store_get", packet, model.retmsg); cb(null); }
        })
    }

};
var tipHelper = {
    get: function (type, cb) {
        //tip_me
        //可评论信息,新的订单
        var id = "tip_" + type;
        $.post(apiUrl + id, {}, function (data) {
            var model = APIResult.getModel(data);
            if (APIResult.isok(model)) {
                if (model.result.total < 1) { return; }
               
                $("#" + id).text(model.result.total);
                $("#" + id).show();
                //tip_order,tip_order_dcl
                for (var key in model.result)
                {
                    if (key == "type" || key == "total") { continue; }
                    var $dom = $("#tip_" + key);
                    var num = parseInt(model.result[key]);
                    console.log("#tip_" + key, $dom.length,num);
                    if ($dom.length < 1 || num < 1) { continue; }
                    else { $dom.text(model.result[key]); $dom.show(); }
                }
                if (cb) { cb(model.result); }
            }
            else { console.error(id, model.retmsg); }
        })
    }
};
var footer = {};
footer.set = function (type) {
    $("#tab_me").removeClass("active");
    $("#tab_" + type).addClass("active");
}
var wxHelper = {};
wxHelper.newShare = function () {
    return {
        title: "", link: "",
        imgUrl: "", desc: ""
    };
}
//为图片附加根域名
wxHelper.urlDeal = function (url) {
    if (!url) { return noPic; }
    if (url.indexOf("http") != -1) { return url; }
    return siteUrl + url;
}
wxHelper.init = function () {
    //分享出带有当前店铺的推广地址的页面信息
    if (!window.wx) { console.warn("wx not exist!!"); return; }
    if (!window.shareInfo) { window.shareInfo = wxHelper.newShare(); }
    $.post(apiUrl + "wx_config", { url: location.href }, function (data) {
        var model = APIResult.getModel(data);
        if (!APIResult.isok(model)) { console.error("wx failed:", model.retmsg); }
        else
        {
            model.result.jsApiList = ['checkJsApi', 'onMenuShareTimeline', 'onMenuShareAppMessage'];
            wx.config(model.result);//config end;
            var mu = model.addon;
            console.log("wx success:", model.result, mu);
            //检测是否带有puid
            var href = location.href.toLowerCase();
            if (href.indexOf("puid") > 0) {
                var host = href.split('?')[0];
                var query = "";
                var params = href.split('?')[1].split('&');
                for (var i = 0; i < params.length; i++) {
                    if (params[i].indexOf("puid") > -1) { continue; }
                    query += params[i] + "&";
                }
                //用于过滤 xxx.com?puid=1
                if (query.length > 0) {
                    query = query.substr(0, query.length - 1);
                    href = host + "?" + query;
                }
                else { href = host; }
            }

            //
            if (!shareInfo.title) { shareInfo.title = $("title").text(); }
            if (!shareInfo.desc) { shareInfo.desc = "一站式学习成长平台"; }
            if (!shareInfo.imgUrl) {
                shareInfo.imgUrl = siteUrl + "/Template/Gredu/style/Images/LOGO_sm.png";
            }
            if (!shareInfo.link) { shareInfo.link = href; }
            if (shareInfo.link.indexOf("?") > 0) { shareInfo.link += "&puid=" + mu.UserID; }
            else { shareInfo.link += "?puid=" + mu.UserID; }

            wx.ready(function () {
                wx.onMenuShareTimeline(shareInfo, function (res) { });
                wx.onMenuShareAppMessage(shareInfo);
            });
        }//else end;
    })
}
//用于个人风采
function getImgs(json) {
    var empty = [{ "url": "/Extend/assets/imgs/nopic.jpg", "desc": "" }];
    if (!json || json == "[]") { return empty; }
    var imgs = null;
    try {
        imgs = JSON.parse(json);
    } catch (ex) { console.error("cover failed:", json); imgs = empty; }
    if (imgs.length < 1) { imgs = empty; }
    return imgs;
}
function getPuid() {
    var puid = getParam("puid");
    if (!puid) { puid = getCookie("puid"); }
    return puid;
}
function getParam(paramName) {
    paramValue = ""; isFound = false; if (this.location.search.indexOf("?") == 0 && this.location.search.indexOf("=") > 1) {
        arrSource = decodeURI(this.location.search).substring(1, this.location.search.length).split("&");
        i = 0;
        //定位参数
        while (i < arrSource.length && !isFound) {
            var start = arrSource[i].indexOf("=");
            if (start > 0 && arrSource[i].split("=")[0].toLowerCase() == paramName.toLowerCase()) {
                //paramValue = arrSource[i].split("=")[1];
                paramValue = arrSource[i].substring(start + 1, arrSource[i].length);
                isFound = true;
            }
            i++;
        }
    }
    return paramValue;
}
var cookieUtils = {
    get: function (name) {
        var cookieName = encodeURIComponent(name) + "=";
        //只取得最匹配的name，value
        var cookieStart = document.cookie.indexOf(cookieName);
        var cookieValue = null;

        if (cookieStart > -1) {
            // 从cookieStart算起
            var cookieEnd = document.cookie.indexOf(';', cookieStart);
            //从=后面开始
            if (cookieEnd > -1) {
                cookieValue = decodeURIComponent(document.cookie.substring(cookieStart + cookieName.length, cookieEnd));
            } else {
                cookieValue = decodeURIComponent(document.cookie.substring(cookieStart + cookieName.length, document.cookie.length));
            }
        }

        return cookieValue;
    },
    set: function (name, val, options) {
        if (!name) {
            throw new Error("cookie must have name");
        }
        var enc = encodeURIComponent;
        var parts = [];
        val = (val !== null && val !== undefined) ? val.toString() : "";
        options = options || {};
        if (!options.path) { options.path = "/"; }
        if (!options.expires) {
            var today = new Date()
            var expires = new Date()
            expires.setTime(today.getTime() + 1000 * 60 * 60 * 24 * 30)
            options.expires = expires;
            options.maxAge = 5 * 365 * 24 * 60 * 60;
        }
        //----------------------------------------
        parts.push(enc(name) + "=" + enc(val));
        // domain中必须包含两个点号
        if (options.domain) {
            parts.push("domain=" + options.domain);
        }
        if (options.path) {
            parts.push("path=" + options.path);
        }
        // 如果不设置expires和max-age浏览器会在页面关闭时清空cookie
        if (options.expires) {
            parts.push("expires=" + options.expires.toGMTString());
        }
        if (options.maxAge && typeof options.maxAge === "number") {
            parts.push("max-age=" + options.maxAge);
        }
        if (options.httpOnly) {
            parts.push("HTTPOnly");
        }
        if (options.secure) {
            parts.push("secure");
        }

        document.cookie = parts.join(";");
    },
    del: function (name, options) {
        options.expires = new Date(0);// 设置为过去日期
        this.set(name, null, options);
    }
}
function setCookie(name, val) {
    //, { expires: (30 * 24 * 60 * 60) }
    cookieUtils.set(name, val);
}
function getCookie(name) {
    return cookieUtils.get(name);
}
$(function () {
    //wxHelper.init();
    //检测推荐关系,并实时存储
    var puid = getParam("puid");
    if (puid) { setCookie("puid",puid); }
    console.log("puid="+getPuid(), location.href);
})