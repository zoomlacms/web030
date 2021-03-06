var BMapLib = window.BMapLib = BMapLib || {};
(function () {
	var b = b || {
		guid: "$BAIDU$"
	};
	(function () {
		window[b.guid] = {};
		b.extend = function (i, g) {
			for (var h in g) {
				if (g.hasOwnProperty(h)) {
					i[h] = g[h]
				}
			}
			return i
		};
		b.lang = b.lang || {};
		b.lang.guid = function () {
			return "TANGRAM__" + (window[b.guid]._counter++).toString(36)
		};
		window[b.guid]._counter = window[b.guid]._counter || 1;
		window[b.guid]._instances = window[b.guid]._instances || {};
		b.lang.Class = function (g) {
			this.guid = g || b.lang.guid();
			window[b.guid]._instances[this.guid] = this
		};
		window[b.guid]._instances = window[b.guid]._instances || {};
		b.lang.isString = function (g) {
			return "[object String]" == Object.prototype.toString.call(g)
		};
		b.lang.isFunction = function (g) {
			return "[object Function]" == Object.prototype.toString.call(g)
		};
		b.lang.Class.prototype.toString = function () {
			return "[object " + (this._className || "Object") + "]"
		};
		b.lang.Event = function (g, h) {
			this.type = g;
			this.returnValue = true;
			this.target = h || null;
			this.currentTarget = null
		};
		b.lang.Class.prototype.addEventListener = function (j, i, h) {
			if (!b.lang.isFunction(i)) {
				return
			}!this.__listeners && (this.__listeners = {});
			var g = this.__listeners,
				k;
			if (typeof h == "string" && h) {
				if (/[^\w\-]/.test(h)) {
					throw ("nonstandard key:" + h)
				} else {
					i.hashCode = h;
					k = h
				}
			}
			j.indexOf("on") != 0 && (j = "on" + j);
			typeof g[j] != "object" && (g[j] = {});
			k = k || b.lang.guid();
			i.hashCode = k;
			g[j][k] = i
		};
		b.lang.Class.prototype.removeEventListener = function (i, h) {
			if (b.lang.isFunction(h)) {
				h = h.hashCode
			} else {
				if (!b.lang.isString(h)) {
					return
				}
			}!this.__listeners && (this.__listeners = {});
			i.indexOf("on") != 0 && (i = "on" + i);
			var g = this.__listeners;
			if (!g[i]) {
				return
			}
			g[i][h] && delete g[i][h]
		};
		b.lang.Class.prototype.dispatchEvent = function (k, g) {
			if (b.lang.isString(k)) {
				k = new b.lang.Event(k)
			}!this.__listeners && (this.__listeners = {});
			g = g || {};
			for (var j in g) {
				k[j] = g[j]
			}
			var j, h = this.__listeners,
				l = k.type;
			k.target = k.target || this;
			k.currentTarget = this;
			l.indexOf("on") != 0 && (l = "on" + l);
			b.lang.isFunction(this[l]) && this[l].apply(this, arguments);
			if (typeof h[l] == "object") {
				for (j in h[l]) {
					h[l][j].apply(this, arguments)
				}
			}
			return k.returnValue
		};
		b.lang.inherits = function (m, k, j) {
			var i, l, g = m.prototype,
				h = new Function();
			h.prototype = k.prototype;
			l = m.prototype = new h();
			for (i in g) {
				l[i] = g[i]
			}
			m.prototype.constructor = m;
			m.superClass = k.prototype;
			if ("string" == typeof j) {
				l._className = j
			}
		};
		b.dom = b.dom || {};
		b.g = b.dom.g = function (g) {
			if ("string" == typeof g || g instanceof String) {
				return document.getElementById(g)
			} else {
				if (g && g.nodeName && (g.nodeType == 1 || g.nodeType == 9)) {
					return g
				}
			}
			return null
		};
		b.browser = b.browser || {};
		if (/msie (\d+\.\d)/i.test(navigator.userAgent)) {
			b.browser.ie = b.ie = document.documentMode || +RegExp["\x241"]
		}
		b.dom._NAME_ATTRS = (function () {
			var g = {
				cellpadding: "cellPadding",
				cellspacing: "cellSpacing",
				colspan: "colSpan",
				rowspan: "rowSpan",
				valign: "vAlign",
				usemap: "useMap",
				frameborder: "frameBorder"
			};
			if (b.browser.ie < 8) {
				g["for"] = "htmlFor";
				g["class"] = "className"
			} else {
				g.htmlFor = "for";
				g.className = "class"
			}
			return g
		})();
		b.getAttr = b.dom.getAttr = function (h, g) {
			h = b.dom.g(h);
			if ("style" == g) {
				return h.style.cssText
			}
			g = b.dom._NAME_ATTRS[g] || g;
			return h.getAttribute(g)
		};
		b.event = b.event || {};
		b.event._listeners = b.event._listeners || [];
		b.on = b.event.on = function (h, k, m) {
			k = k.replace(/^on/i, "");
			h = b.g(h);
			var l = function (o) {
					m.call(h, o)
				},
				g = b.event._listeners,
				j = b.event._eventFilter,
				n, i = k;
			k = k.toLowerCase();
			if (j && j[k]) {
				n = j[k](h, k, l);
				i = n.type;
				l = n.listener
			}
			if (h.addEventListener) {
				h.addEventListener(i, l, false)
			} else {
				if (h.attachEvent) {
					h.attachEvent("on" + i, l)
				}
			}
			g[g.length] = [h, k, m, l, i];
			return h
		}
	})();
	var f = {
		request: function (j, g) {
			if (g) {
				var i = (Math.random() * 100000).toFixed(0);
				BMap._rd["_cbk" + i] = function (k) {
					g && g(k);
					delete BMap._rd["_cbk" + i]
				};
				j += "&callback=BMap._rd._cbk" + i
			}
			var h = document.createElement("script");
			h.setAttribute("src", j);
			document.body.appendChild(h);
			if (h.addEventListener) {
				h.addEventListener("load", function (l) {
					var k = l.target;
					k.parentNode.removeChild(k)
				}, false)
			} else {
				if (h.attachEvent) {
					h.attachEvent("onreadystatechange", function (l) {
						var k = window.event.srcElement;
						if (k && (k.readyState == "loaded" || k.readyState == "complete")) {
							k.parentNode.removeChild(k)
						}
					})
				}
			}
			setTimeout(function () {
				document.getElementsByTagName("head")[0].appendChild(h);
				h = null
			}, 1)
		}
	};
	var a = {
		serviceUrl: "http://api.map.baidu.com"
	};

	function e(i) {
		var h = BMAP_NORMAL_MAP.getProjection();
		var g = null;
		i = i.split("|")[2];
		i = i.substr(0, i.length - 1);
		i = i.split(",");
		var g = h.pointToLngLat(new BMap.Pixel(i[0], i[1]));
		return g
	}

	function c(n) {
		var j = BMAP_NORMAL_MAP.getProjection();
		var l = [];
		n = n.split(";");
		for (var k = 0, h = n.length; k < h; k++) {
			var m = n[k].split(",");
			var g = j.pointToLngLat(new BMap.Pixel(m[0], m[1]));
			l.push(g)
		}
		return l
	}
	var d = BMapLib.CityList = function (g) {
		g = g || {};
		this._opts = b.extend(b.extend(this._opts || {}, {
			container: null,
			map: null
		}), g);
		this._data = null;
		this._init()
	};
	b.lang.inherits(d, b.lang.Class, "CityList");
	d.prototype._init = function () {
		if (this._opts.container) {
			this._initContainer()
		}
	};
	d.prototype.getBusiness = function (i, g) {
		var h = a.serviceUrl + "/shangquan/reverse/?wd=" + i;
		f.request(h, function (m) {
			var k = null;
			if (m && m.error && m.error["errno"] == "0") {
				k = m.content
			}
			for (var l = 0, j = k.length; l < j; l++) {
				k[l]["coordinate"] = c(k[l]["coordinate"])
			}
			if (g) {
				g(k)
			}
		})
	};
	d.prototype.getSubAreaList = function (h, g) {
		var i = a.serviceUrl + "/shangquan/forward/?qt=sub_area_list&ext=1&level=1&areacode=" + h + "&business_flag=0";
		f.request(i, function (m) {
			var k = null;
			if (m && m.result && m.result["error"] == "0") {
				k = m.content
			}
			k.geo = e(k.geo);
			for (var l = 0, j = k.sub.length; l < j; l++) {
				k.sub[l]["geo"] = e(k.sub[l]["geo"])
			}
			if (g) {
				g(k)
			}
		})
	};
	d.prototype._initContainer = function () {
		var q = this;

		function h(x, z, y, u) {
			h.id = z;
			h.level = y;
			var w = new Date().getTime();
			var v = l + "&areacode=" + x;
			if (u) {
				v += "&business_flag=1"
			} else {
				v += "&business_flag=0"
			}
			f.request(v, k)
		}

		function k(z) {
			var D = "";
			if (z.content) {
				var C = z.content;
				var A = [];
				var y = n(C.geo);
				var u = new BMap.MercatorProjection();
				var v = u.pointToLngLat(new BMap.Pixel(y.x, y.y));
				if (z.content.area_code == 1) {
					var E = new BMap.Point(116.403119, 39.92069);
					map.centerAndZoom(E, 12)
				} else {
					var E = new BMap.Point(v.lng, v.lat);
					map.centerAndZoom(E, h.level)
				}
				if (z.content.sub) {
					D = C.sub;
					D.splice(0, 0, {
						area_name: "请选择",
						area_code: ""
					});
					var B = document.createDocumentFragment();
					var t;
					var x = {
						131: 1,
						289: 2,
						332: 3,
						132: 4
					};
					for (var w = 0; w < D.length; w++) {
						D[w].sort = D[w].area_code ? x[D[w].area_code] || 5 : 0
					}
					D.sort(function (G, F) {
						return G.sort - F.sort
					});
					for (var w = 0; w < D.length; w++) {
						t = document.createElement("option");
						t.innerHTML = D[w].area_name;
						t.area_type = D[w].area_type;
						t.geo = D[w].geo;
						if (D[w].business_geo) {
							t.business_geo = D[w].business_geo
						}
						t.value = D[w].area_code;
						t.title = D[w].area_name;
						B.appendChild(t)
					}
					D.shift();
					if (h.id) {
						h.id.innerHTML = "";
						h.id.appendChild(B)
					}
				}
			}
		}

		function n(x) {
			var v = /([^\|;]*)(?=;)/;
			var y = v.exec(x);
			var u = y[0].split(",")[0] * 1;
			var t = y[0].split(",")[1] * 1;
			var w = {
				x: u,
				y: t
			};
			return w
		}
		var l = a.serviceUrl + "/shangquan/forward/?qt=sub_area_list&ext=1&level=1";
		var j = "width:70px;margin:0 5px;";
		var g = b.g(this._opts.container),
			p = document.createElement("select"),
			r = document.createElement("select"),
			i = document.createElement("select"),
			m = document.createElement("select");
		p.style.cssText = j;
		r.style.cssText = j;
		i.style.cssText = j;
		m.style.cssText = j;
		g.appendChild(p);
		g.appendChild(document.createTextNode("省"));
		g.appendChild(r);
		g.appendChild(document.createTextNode("市"));
		g.appendChild(i);
		g.appendChild(document.createTextNode("区"));
		g.appendChild(m);
		g.appendChild(document.createTextNode("商圈"));
		b.on(p, "change", function () {
			var v = p.value;
			r.innerHTML = i.innerHTML = m.innerHTML = "";
			if (v == 131 || v == 289 || v == 332 || v == 132) {
				var u = "";
				switch (v) {
					case "131":
						u = "北京市";
						break;
					case "289":
						u = "上海市";
						break;
					case "332":
						u = "天津市";
						break;
					case "132":
						u = "重庆市";
						break
				}
				var t = document.createDocumentFragment();
				var w;
				w = document.createElement("option");
				w.innerHTML = u;
				w.value = v;
				w.title = u;
				t.appendChild(w);
				r.appendChild(t);
				h(v, i, 12)
			} else {
				h(v, r, 12)
			}
			o(this.options[this.selectedIndex])
		});
		b.on(r, "change", function () {
			var t = r.value;
			h(t, i, 12);
			i.innerHTML = "";
			o(this.options[this.selectedIndex])
		});
		b.on(i, "change", function () {
			var t = i.value;
			h(t, m, 12, 1);
			m.innerHTML = "";
			o(this.options[this.selectedIndex])
		});

		function o(t) {
			q.dispatchEvent("cityclick", {
				area_code: t.value,
				area_type: t.area_type,
				geo: e(t.geo),
				area_name: t.title
			})
		}
		var s = new BMap.Polygon();
		map.addOverlay(s);
		s.hide();
		b.on(m, "change", function (B) {
			var w = m.value;
			var z = this.options[this.selectedIndex];
			var x = n(z.geo);
			var u = new BMap.MercatorProjection();
			var v = u.pointToLngLat(new BMap.Pixel(x.x, x.y));
			var C = z.business_geo;
			C = C.split(";");
			for (var y = 0, A = C.length; y < A; y++) {
				var t = C[y].split(",");
				C[y] = u.pointToLngLat(new BMap.Pixel(t[0], t[1]))
			}
			s.show();
			s.setPath(C);
			map.setViewport(C);
			o(this.options[this.selectedIndex])
		});
		h(1, p, 12)
	}
	
	
	d.prototype.getSubBusinessList = function (areaCode, cbk) {
        var url = a.serviceUrl + "/shangquan/forward/?qt=sub_area_list&ext=1&level=1&areacode=" + areaCode + "&business_flag=1";
        f.request(url,function(json){
            var result = null;
            if (json && json['result'] && json['result']['error'] == "0") {
                result = json['content'];
            }


            result.geo = e(result.geo);


            for (var i = 0, len = result.sub.length; i < len; i++) {
                result.sub[i]['geo'] = encodeURI(result.sub[i]['geo']);
            }


            if (cbk) {
                cbk(result);
            }
        });
    }
	
})();



