!function(t,e,n,i){"use strict";Foundation.libs.joyride={name:"joyride",version:"4.2.2",defaults:{expose:!1,modal:!1,tipLocation:"bottom",nubPosition:"auto",scrollSpeed:300,timer:0,startTimerOnClick:!0,startOffset:0,nextButton:!0,tipAnimation:"fade",pauseAfter:[],exposed:[],tipAnimationFadeSpeed:300,cookieMonster:!1,cookieName:"joyride",cookieDomain:!1,cookieExpires:365,tipContainer:"body",postRideCallback:function(){},postStepCallback:function(){},preStepCallback:function(){},preRideCallback:function(){},postExposeCallback:function(){},template:{link:'<a href="#close" class="joyride-close-tip">&times;</a>',timer:'<div class="joyride-timer-indicator-wrap"><span class="joyride-timer-indicator"></span></div>',tip:'<div class="joyride-tip-guide"><span class="joyride-nub"></span></div>',wrapper:'<div class="joyride-content-wrapper"></div>',button:'<a href="#" class="small button joyride-next-tip"></a>',modal:'<div class="joyride-modal-bg"></div>',expose:'<div class="joyride-expose-wrapper"></div>',exposeCover:'<div class="joyride-expose-cover"></div>'},exposeAddClass:""},settings:{},init:function(e,n,i){return this.scope=e||this.scope,Foundation.inherit(this,"throttle data_options scrollTo scrollLeft delay"),"object"==typeof n?t.extend(!0,this.settings,this.defaults,n):t.extend(!0,this.settings,this.defaults,i),"string"!=typeof n?(this.settings.init||this.events(),this.settings.init):this[n].call(this,i)},events:function(){var n=this;t(this.scope).on("click.joyride",".joyride-next-tip, .joyride-modal-bg",function(t){t.preventDefault(),this.settings.$li.next().length<1?this.end():this.settings.timer>0?(clearTimeout(this.settings.automate),this.hide(),this.show(),this.startTimer()):(this.hide(),this.show())}.bind(this)).on("click.joyride",".joyride-close-tip",function(t){t.preventDefault(),this.end()}.bind(this)),t(e).on("resize.fndtn.joyride",n.throttle(function(){if(t("[data-joyride]").length>0&&n.settings.$next_tip){if(n.settings.exposed.length>0){var e=t(n.settings.exposed);e.each(function(){var e=t(this);n.un_expose(e),n.expose(e)})}n.is_phone()?n.pos_phone():n.pos_default(!1,!0)}},100)),this.settings.init=!0},start:function(){var e=this,n=t(this.scope).find("[data-joyride]"),i=["timer","scrollSpeed","startOffset","tipAnimationFadeSpeed","cookieExpires"],o=i.length;this.settings.init||this.init(),this.settings.$content_el=n,this.settings.$body=t(this.settings.tipContainer),this.settings.body_offset=t(this.settings.tipContainer).position(),this.settings.$tip_content=this.settings.$content_el.find("> li"),this.settings.paused=!1,this.settings.attempts=0,this.settings.tipLocationPatterns={top:["bottom"],bottom:[],left:["right","top","bottom"],right:["left","top","bottom"]},"function"!=typeof t.cookie&&(this.settings.cookieMonster=!1),(!this.settings.cookieMonster||this.settings.cookieMonster&&null===t.cookie(this.settings.cookieName))&&(this.settings.$tip_content.each(function(n){var s=t(this);t.extend(!0,e.settings,e.data_options(s));for(var r=o-1;r>=0;r--)e.settings[i[r]]=parseInt(e.settings[i[r]],10);e.create({$li:s,index:n})}),!this.settings.startTimerOnClick&&this.settings.timer>0?(this.show("init"),this.startTimer()):this.show("init"))},resume:function(){this.set_li(),this.show()},tip_template:function(e){var n,i;return e.tip_class=e.tip_class||"",n=t(this.settings.template.tip).addClass(e.tip_class),i=t.trim(t(e.li).html())+this.button_text(e.button_text)+this.settings.template.link+this.timer_instance(e.index),n.append(t(this.settings.template.wrapper)),n.first().attr("data-index",e.index),t(".joyride-content-wrapper",n).append(i),n[0]},timer_instance:function(e){var n;return n=0===e&&this.settings.startTimerOnClick&&this.settings.timer>0||0===this.settings.timer?"":this.outerHTML(t(this.settings.template.timer)[0])},button_text:function(e){return this.settings.nextButton?(e=t.trim(e)||"Next",e=this.outerHTML(t(this.settings.template.button).append(e)[0])):e="",e},create:function(e){var n=e.$li.attr("data-button")||e.$li.attr("data-text"),i=e.$li.attr("class"),o=t(this.tip_template({tip_class:i,index:e.index,button_text:n,li:e.$li}));t(this.settings.tipContainer).append(o)},show:function(e){var n=null;this.settings.$li===i||-1===t.inArray(this.settings.$li.index(),this.settings.pauseAfter)?(this.settings.paused?this.settings.paused=!1:this.set_li(e),this.settings.attempts=0,this.settings.$li.length&&this.settings.$target.length>0?(e&&(this.settings.preRideCallback(this.settings.$li.index(),this.settings.$next_tip),this.settings.modal&&this.show_modal()),this.settings.preStepCallback(this.settings.$li.index(),this.settings.$next_tip),this.settings.modal&&this.settings.expose&&this.expose(),this.settings.tipSettings=t.extend(this.settings,this.data_options(this.settings.$li)),this.settings.timer=parseInt(this.settings.timer,10),this.settings.tipSettings.tipLocationPattern=this.settings.tipLocationPatterns[this.settings.tipSettings.tipLocation],/body/i.test(this.settings.$target.selector)||this.scroll_to(),this.is_phone()?this.pos_phone(!0):this.pos_default(!0),n=this.settings.$next_tip.find(".joyride-timer-indicator"),/pop/i.test(this.settings.tipAnimation)?(n.width(0),this.settings.timer>0?(this.settings.$next_tip.show(),this.delay(function(){n.animate({width:n.parent().width()},this.settings.timer,"linear")}.bind(this),this.settings.tipAnimationFadeSpeed)):this.settings.$next_tip.show()):/fade/i.test(this.settings.tipAnimation)&&(n.width(0),this.settings.timer>0?(this.settings.$next_tip.fadeIn(this.settings.tipAnimationFadeSpeed).show(),this.delay(function(){n.animate({width:n.parent().width()},this.settings.timer,"linear")}.bind(this),this.settings.tipAnimationFadeSpeed)):this.settings.$next_tip.fadeIn(this.settings.tipAnimationFadeSpeed)),this.settings.$current_tip=this.settings.$next_tip):this.settings.$li&&this.settings.$target.length<1?this.show():this.end()):this.settings.paused=!0},is_phone:function(){return Modernizr?Modernizr.mq("only screen and (max-width: 767px)")||t(".lt-ie9").length>0:this.settings.$window.width()<767},hide:function(){this.settings.modal&&this.settings.expose&&this.un_expose(),this.settings.modal||t(".joyride-modal-bg").hide(),this.settings.$current_tip.css("visibility","hidden"),setTimeout(t.proxy(function(){this.hide(),this.css("visibility","visible")},this.settings.$current_tip),0),this.settings.postStepCallback(this.settings.$li.index(),this.settings.$current_tip)},set_li:function(t){t?(this.settings.$li=this.settings.$tip_content.eq(this.settings.startOffset),this.set_next_tip(),this.settings.$current_tip=this.settings.$next_tip):(this.settings.$li=this.settings.$li.next(),this.set_next_tip()),this.set_target()},set_next_tip:function(){this.settings.$next_tip=t(".joyride-tip-guide[data-index='"+this.settings.$li.index()+"']"),this.settings.$next_tip.data("closed","")},set_target:function(){var e=this.settings.$li.attr("data-class"),i=this.settings.$li.attr("data-id"),o=function(){return i?t(n.getElementById(i)):e?t("."+e).first():t("body")};this.settings.$target=o()},scroll_to:function(){var n,i;n=t(e).height()/2,i=Math.ceil(this.settings.$target.offset().top-n+this.outerHeight(this.settings.$next_tip)),i>0&&this.scrollTo(t("html, body"),i,this.settings.scrollSpeed)},paused:function(){return-1===t.inArray(this.settings.$li.index()+1,this.settings.pauseAfter)},restart:function(){this.hide(),this.settings.$li=i,this.show("init")},pos_default:function(n,i){var o=(Math.ceil(t(e).height()/2),this.settings.$next_tip.offset(),this.settings.$next_tip.find(".joyride-nub")),s=Math.ceil(this.outerWidth(o)/2),r=Math.ceil(this.outerHeight(o)/2),a=n||!1;if(a&&(this.settings.$next_tip.css("visibility","hidden"),this.settings.$next_tip.show()),"undefined"==typeof i&&(i=!1),/body/i.test(this.settings.$target.selector))this.settings.$li.length&&this.pos_modal(o);else{if(this.bottom()){var l=this.settings.$target.offset().left;Foundation.rtl&&(l=this.settings.$target.offset().width-this.settings.$next_tip.width()+l),this.settings.$next_tip.css({top:this.settings.$target.offset().top+r+this.outerHeight(this.settings.$target),left:l}),this.nub_position(o,this.settings.tipSettings.nubPosition,"top")}else if(this.top()){var l=this.settings.$target.offset().left;Foundation.rtl&&(l=this.settings.$target.offset().width-this.settings.$next_tip.width()+l),this.settings.$next_tip.css({top:this.settings.$target.offset().top-this.outerHeight(this.settings.$next_tip)-r,left:l}),this.nub_position(o,this.settings.tipSettings.nubPosition,"bottom")}else this.right()?(this.settings.$next_tip.css({top:this.settings.$target.offset().top,left:this.outerWidth(this.settings.$target)+this.settings.$target.offset().left+s}),this.nub_position(o,this.settings.tipSettings.nubPosition,"left")):this.left()&&(this.settings.$next_tip.css({top:this.settings.$target.offset().top,left:this.settings.$target.offset().left-this.outerWidth(this.settings.$next_tip)-s}),this.nub_position(o,this.settings.tipSettings.nubPosition,"right"));!this.visible(this.corners(this.settings.$next_tip))&&this.settings.attempts<this.settings.tipSettings.tipLocationPattern.length&&(o.removeClass("bottom").removeClass("top").removeClass("right").removeClass("left"),this.settings.tipSettings.tipLocation=this.settings.tipSettings.tipLocationPattern[this.settings.attempts],this.settings.attempts++,this.pos_default())}a&&(this.settings.$next_tip.hide(),this.settings.$next_tip.css("visibility","visible"))},pos_phone:function(e){var n=this.outerHeight(this.settings.$next_tip),i=(this.settings.$next_tip.offset(),this.outerHeight(this.settings.$target)),o=t(".joyride-nub",this.settings.$next_tip),s=Math.ceil(this.outerHeight(o)/2),r=e||!1;o.removeClass("bottom").removeClass("top").removeClass("right").removeClass("left"),r&&(this.settings.$next_tip.css("visibility","hidden"),this.settings.$next_tip.show()),/body/i.test(this.settings.$target.selector)?this.settings.$li.length&&this.pos_modal(o):this.top()?(this.settings.$next_tip.offset({top:this.settings.$target.offset().top-n-s}),o.addClass("bottom")):(this.settings.$next_tip.offset({top:this.settings.$target.offset().top+i+s}),o.addClass("top")),r&&(this.settings.$next_tip.hide(),this.settings.$next_tip.css("visibility","visible"))},pos_modal:function(t){this.center(),t.hide(),this.show_modal()},show_modal:function(){if(!this.settings.$next_tip.data("closed")){var e=t(".joyride-modal-bg");e.length<1&&t("body").append(this.settings.template.modal).show(),/pop/i.test(this.settings.tipAnimation)?e.show():e.fadeIn(this.settings.tipAnimationFadeSpeed)}},expose:function(){var n,i,o,s,r,a="expose-"+Math.floor(1e4*Math.random());if(arguments.length>0&&arguments[0]instanceof t)o=arguments[0];else{if(!this.settings.$target||/body/i.test(this.settings.$target.selector))return!1;o=this.settings.$target}return o.length<1?(e.console&&console.error("element not valid",o),!1):(n=t(this.settings.template.expose),this.settings.$body.append(n),n.css({top:o.offset().top,left:o.offset().left,width:this.outerWidth(o,!0),height:this.outerHeight(o,!0)}),i=t(this.settings.template.exposeCover),s={zIndex:o.css("z-index"),position:o.css("position")},r=null==o.attr("class")?"":o.attr("class"),o.css("z-index",parseInt(n.css("z-index"))+1),"static"==s.position&&o.css("position","relative"),o.data("expose-css",s),o.data("orig-class",r),o.attr("class",r+" "+this.settings.exposeAddClass),i.css({top:o.offset().top,left:o.offset().left,width:this.outerWidth(o,!0),height:this.outerHeight(o,!0)}),this.settings.$body.append(i),n.addClass(a),i.addClass(a),o.data("expose",a),this.settings.postExposeCallback(this.settings.$li.index(),this.settings.$next_tip,o),this.add_exposed(o),void 0)},un_expose:function(){var n,i,o,s,r,a=!1;if(arguments.length>0&&arguments[0]instanceof t)i=arguments[0];else{if(!this.settings.$target||/body/i.test(this.settings.$target.selector))return!1;i=this.settings.$target}return i.length<1?(e.console&&console.error("element not valid",i),!1):(n=i.data("expose"),o=t("."+n),arguments.length>1&&(a=arguments[1]),a===!0?t(".joyride-expose-wrapper,.joyride-expose-cover").remove():o.remove(),s=i.data("expose-css"),"auto"==s.zIndex?i.css("z-index",""):i.css("z-index",s.zIndex),s.position!=i.css("position")&&("static"==s.position?i.css("position",""):i.css("position",s.position)),r=i.data("orig-class"),i.attr("class",r),i.removeData("orig-classes"),i.removeData("expose"),i.removeData("expose-z-index"),this.remove_exposed(i),void 0)},add_exposed:function(e){this.settings.exposed=this.settings.exposed||[],e instanceof t||"object"==typeof e?this.settings.exposed.push(e[0]):"string"==typeof e&&this.settings.exposed.push(e)},remove_exposed:function(e){var n,i;e instanceof t?n=e[0]:"string"==typeof e&&(n=e),this.settings.exposed=this.settings.exposed||[],i=this.settings.exposed.length;for(var o=0;i>o;o++)if(this.settings.exposed[o]==n)return this.settings.exposed.splice(o,1),void 0},center:function(){var n=t(e);return this.settings.$next_tip.css({top:(n.height()-this.outerHeight(this.settings.$next_tip))/2+n.scrollTop(),left:(n.width()-this.outerWidth(this.settings.$next_tip))/2+this.scrollLeft(n)}),!0},bottom:function(){return/bottom/i.test(this.settings.tipSettings.tipLocation)},top:function(){return/top/i.test(this.settings.tipSettings.tipLocation)},right:function(){return/right/i.test(this.settings.tipSettings.tipLocation)},left:function(){return/left/i.test(this.settings.tipSettings.tipLocation)},corners:function(n){var i=t(e),o=i.height()/2,s=Math.ceil(this.settings.$target.offset().top-o+this.settings.$next_tip.outerHeight()),r=i.width()+this.scrollLeft(i),a=i.height()+s,l=i.height()+i.scrollTop(),c=i.scrollTop();return c>s&&(c=0>s?0:s),a>l&&(l=a),[n.offset().top<c,r<n.offset().left+n.outerWidth(),l<n.offset().top+n.outerHeight(),this.scrollLeft(i)>n.offset().left]},visible:function(t){for(var e=t.length;e--;)if(t[e])return!1;return!0},nub_position:function(t,e,n){"auto"===e?t.addClass(n):t.addClass(e)},startTimer:function(){this.settings.$li.length?this.settings.automate=setTimeout(function(){this.hide(),this.show(),this.startTimer()}.bind(this),this.settings.timer):clearTimeout(this.settings.automate)},end:function(){this.settings.cookieMonster&&t.cookie(this.settings.cookieName,"ridden",{expires:this.settings.cookieExpires,domain:this.settings.cookieDomain}),this.settings.timer>0&&clearTimeout(this.settings.automate),this.settings.modal&&this.settings.expose&&this.un_expose(),this.settings.$next_tip.data("closed",!0),t(".joyride-modal-bg").hide(),this.settings.$current_tip.hide(),this.settings.postStepCallback(this.settings.$li.index(),this.settings.$current_tip),this.settings.postRideCallback(this.settings.$li.index(),this.settings.$current_tip),t(".joyride-tip-guide").remove()},outerHTML:function(t){return t.outerHTML||(new XMLSerializer).serializeToString(t)},off:function(){t(this.scope).off(".joyride"),t(e).off(".joyride"),t(".joyride-close-tip, .joyride-next-tip, .joyride-modal-bg").off(".joyride"),t(".joyride-tip-guide, .joyride-modal-bg").remove(),clearTimeout(this.settings.automate),this.settings={}},reflow:function(){}}}(Foundation.zj,this,this.document);