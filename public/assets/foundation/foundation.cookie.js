/*!
 * jQuery Cookie Plugin v1.3
 * https://github.com/carhartl/jquery-cookie
 *
 * Copyright 2011, Klaus Hartl
 * Dual licensed under the MIT or GPL Version 2 licenses.
 * http://www.opensource.org/licenses/mit-license.php
 * http://www.opensource.org/licenses/GPL-2.0
 *
 * Modified to work with Zepto.js by ZURB
 */
!function(e,t,n){function i(e){return e}function o(e){return decodeURIComponent(e.replace(r," "))}var r=/\+/g,s=e.cookie=function(r,a,l){if(a!==n){if(l=e.extend({},s.defaults,l),null===a&&(l.expires=-1),"number"==typeof l.expires){var c=l.expires,u=l.expires=new Date;u.setDate(u.getDate()+c)}return a=s.json?JSON.stringify(a):String(a),t.cookie=[encodeURIComponent(r),"=",s.raw?a:encodeURIComponent(a),l.expires?"; expires="+l.expires.toUTCString():"",l.path?"; path="+l.path:"",l.domain?"; domain="+l.domain:"",l.secure?"; secure":""].join("")}for(var p=s.raw?i:o,d=t.cookie.split("; "),h=0,f=d.length;f>h;h++){var g=d[h].split("=");if(p(g.shift())===r){var m=p(g.join("="));return s.json?JSON.parse(m):m}}return null};s.defaults={},e.removeCookie=function(t,n){return null!==e.cookie(t)?(e.cookie(t,null,n),!0):!1}}(Foundation.zj,document);