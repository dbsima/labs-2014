/*
YUI 3.5.1 (build 22)
Copyright 2012 Yahoo! Inc. All rights reserved.
Licensed under the BSD License.
http://yuilibrary.com/license/
*/
YUI.add("attribute-core",function(c){c.State=function(){this.data={};};c.State.prototype={add:function(v,w,y){var x=this.data;x[v]=x[v]||{};x[v][w]=y;},addAll:function(v,x){var w;for(w in x){if(x.hasOwnProperty(w)){this.add(v,w,x[w]);}}},remove:function(v,w){var x=this.data;if(x[v]){delete x[v][w];}},removeAll:function(v,x){var w=this.data;if(!x){if(w[v]){delete w[v];}}else{c.each(x,function(z,y){if(c.Lang.isString(y)){this.remove(v,y);}else{this.remove(v,z);}},this);}},get:function(v,w){var x=this.data;return(x[v])?x[v][w]:undefined;},getAll:function(w,v){var y=this.data,x;if(!v){c.each(y[w],function(A,z){x=x||{};x[z]=A;});}else{x=y[w];}return x;}};var i=c.Object,d=c.Lang,q=".",k="getter",j="setter",l="readOnly",r="writeOnce",p="initOnly",u="validator",f="value",m="valueFn",o="lazyAdd",t="added",h="_bypassProxy",b="initializing",g="initValue",a="lazy",n="isLazyAdd",e;function s(w,v,x){this._initAttrHost(w,v,x);}s.INVALID_VALUE={};e=s.INVALID_VALUE;s._ATTR_CFG=[j,k,u,f,m,r,l,o,h];s.prototype={_initAttrHost:function(w,v,x){this._state=new c.State();this._initAttrs(w,v,x);},addAttr:function(w,v,y){var z=this,B=z._state,A,x;v=v||{};y=(o in v)?v[o]:y;if(y&&!z.attrAdded(w)){B.addAll(w,{lazy:v,added:true});}else{if(!z.attrAdded(w)||B.get(w,n)){x=(f in v);if(x){A=v.value;delete v.value;}v.added=true;v.initializing=true;B.addAll(w,v);if(x){z.set(w,A);}B.remove(w,b);}}return z;},attrAdded:function(v){return !!this._state.get(v,t);},get:function(v){return this._getAttr(v);},_isLazyAttr:function(v){return this._state.get(v,a);},_addLazyAttr:function(x,v){var y=this._state,w=y.get(x,a);y.add(x,n,true);y.remove(x,a);this.addAttr(x,w);},set:function(v,w){return this._setAttr(v,w);},_set:function(v,w){return this._setAttr(v,w,null,true);},_setAttr:function(x,A,v,y){var E=true,w=this._state,B=this._stateProxy,H,D,G,I,z,C,F;if(x.indexOf(q)!==-1){G=x;I=x.split(q);x=I.shift();}if(this._isLazyAttr(x)){this._addLazyAttr(x);}H=w.getAll(x,true)||{};D=(!(f in H));if(B&&x in B&&!H._bypassProxy){D=false;}C=H.writeOnce;F=H.initializing;if(!D&&!y){if(C){E=false;}if(H.readOnly){E=false;}}if(!F&&!y&&C===p){E=false;}if(E){if(!D){z=this.get(x);}if(I){A=i.setValue(c.clone(z),I,A);if(A===undefined){E=false;}}if(E){if(!this._fireAttrChange||F){this._setAttrVal(x,G,z,A);}else{this._fireAttrChange(x,G,z,A,v);}}}return this;},_getAttr:function(x){var y=this,C=x,z=y._state,A,v,B,w;if(x.indexOf(q)!==-1){A=x.split(q);x=A.shift();}if(y._tCfgs&&y._tCfgs[x]){w={};w[x]=y._tCfgs[x];delete y._tCfgs[x];y._addAttrs(w,y._tVals);}if(y._isLazyAttr(x)){y._addLazyAttr(x);}B=y._getStateVal(x);v=z.get(x,k);if(v&&!v.call){v=this[v];}B=(v)?v.call(y,B,C):B;B=(A)?i.getValue(B,A):B;return B;},_getStateVal:function(v){var w=this._stateProxy;return w&&(v in w)&&!this._state.get(v,h)?w[v]:this._state.get(v,f);},_setStateVal:function(v,x){var w=this._stateProxy;if(w&&(v in w)&&!this._state.get(v,h)){w[v]=x;}else{this._state.add(v,f,x);}},_setAttrVal:function(H,G,C,A){var I=this,D=true,F=this._state.getAll(H,true)||{},y=F.validator,B=F.setter,E=F.initializing,x=this._getStateVal(H),w=G||H,z,v;if(y){if(!y.call){y=this[y];}if(y){v=y.call(I,A,w);if(!v&&E){A=F.defaultValue;v=true;}}}if(!y||v){if(B){if(!B.call){B=this[B];}if(B){z=B.call(I,A,w);if(z===e){D=false;}else{if(z!==undefined){A=z;}}}}if(D){if(!G&&(A===x)&&!d.isObject(A)){D=false;}else{if(!(g in F)){F.initValue=A;}I._setStateVal(H,A);}}}else{D=false;}return D;},setAttrs:function(v){return this._setAttrs(v);},_setAttrs:function(w){for(var v in w){if(w.hasOwnProperty(v)){this.set(v,w[v]);}}return this;},getAttrs:function(v){return this._getAttrs(v);},_getAttrs:function(y){var A=this,C={},z,w,v,B,x=(y===true);y=(y&&!x)?y:i.keys(A._state.data);for(z=0,w=y.length;z<w;z++){v=y[z];B=A.get(v);if(!x||A._getStateVal(v)!=A._state.get(v,g)){C[v]=A.get(v);}}return C;},addAttrs:function(v,w,x){var y=this;if(v){y._tCfgs=v;y._tVals=y._normAttrVals(w);y._addAttrs(v,y._tVals,x);y._tCfgs=y._tVals=null;}return y;},_addAttrs:function(w,x,y){var A=this,v,z,B;for(v in w){if(w.hasOwnProperty(v)){z=w[v];z.defaultValue=z.value;B=A._getAttrInitVal(v,z,A._tVals);if(B!==undefined){z.value=B;}if(A._tCfgs[v]){delete A._tCfgs[v];}A.addAttr(v,z,y);}}},_protectAttrs:function(w){if(w){w=c.merge(w);for(var v in w){if(w.hasOwnProperty(v)){w[v]=c.merge(w[v]);}}}return w;},_normAttrVals:function(v){return(v)?c.merge(v):null;},_getAttrInitVal:function(v,w,y){var z,x;if(!w.readOnly&&y&&y.hasOwnProperty(v)){z=y[v];}else{z=w.value;x=w.valueFn;if(x){if(!x.call){x=this[x];}if(x){z=x.call(this,v);}}}return z;},_initAttrs:function(w,v,z){w=w||this.constructor.ATTRS;var y=c.Base,x=c.BaseCore,A=(y&&c.instanceOf(this,y)),B=(!A&&x&&c.instanceOf(this,x));if(w&&!A&&!B){this.addAttrs(this._protectAttrs(w),v,z);}}};c.AttributeCore=s;},"3.5.1");/*
YUI 3.5.1 (build 22)
Copyright 2012 Yahoo! Inc. All rights reserved.
Licensed under the BSD License.
http://yuilibrary.com/license/
*/
YUI.add("base-core",function(a){var e=a.Object,i=a.Lang,h=".",l="initialized",d="destroyed",c="initializer",b=Object.prototype.constructor,j="deep",m="shallow",k="destructor",g=a.AttributeCore,f=function(t,q,o){var u;for(u in q){if(o[u]){t[u]=q[u];}}return t;};function n(o){if(!this._BaseInvoked){this._BaseInvoked=true;this._initBase(o);}}n._ATTR_CFG=g._ATTR_CFG.concat("cloneDefaultValue");n._ATTR_CFG_HASH=a.Array.hash(n._ATTR_CFG);n._NON_ATTRS_CFG=["plugins"];n.NAME="baseCore";n.ATTRS={initialized:{readOnly:true,value:false},destroyed:{readOnly:true,value:false}};n.prototype={_initBase:function(o){a.stamp(this);this._initAttribute(o);var p=a.Plugin&&a.Plugin.Host;if(this._initPlugins&&p){p.call(this);}if(this._lazyAddAttrs!==false){this._lazyAddAttrs=true;}this.name=this.constructor.NAME;this.init.apply(this,arguments);},_initAttribute:function(){g.apply(this);},init:function(o){this._baseInit(o);return this;},_baseInit:function(o){this._initHierarchy(o);if(this._initPlugins){this._initPlugins(o);}this._set(l,true);},destroy:function(){this._baseDestroy();return this;},_baseDestroy:function(){if(this._destroyPlugins){this._destroyPlugins();}this._destroyHierarchy();this._set(d,true);},_getClasses:function(){if(!this._classes){this._initHierarchyData();}return this._classes;},_getAttrCfgs:function(){if(!this._attrs){this._initHierarchyData();}return this._attrs;},_filterAttrCfgs:function(s,p){var q=null,o,r=s.ATTRS;if(r){for(o in r){if(p[o]){q=q||{};q[o]=p[o];p[o]=null;}}}return q;},_filterAdHocAttrs:function(r,p){var q,s=this._nonAttrs,o;if(p){q={};for(o in p){if(!r[o]&&!s[o]&&p.hasOwnProperty(o)){q[o]={value:p[o]};}}}return q;},_initHierarchyData:function(){var u=this.constructor,r,o,s,t=(this._allowAdHocAttrs)?{}:null,q=[],p=[];while(u){q[q.length]=u;if(u.ATTRS){p[p.length]=u.ATTRS;}if(this._allowAdHocAttrs){s=u._NON_ATTRS_CFG;if(s){for(r=0,o=s.length;r<o;r++){t[s[r]]=true;}}}u=u.superclass?u.superclass.constructor:null;}this._classes=q;this._nonAttrs=t;this._attrs=this._aggregateAttrs(p);},_attrCfgHash:function(){return n._ATTR_CFG_HASH;},_aggregateAttrs:function(v){var r,w,q,o,x,p,u,t=this._attrCfgHash(),s={};if(v){for(p=v.length-1;p>=0;--p){w=v[p];for(r in w){if(w.hasOwnProperty(r)){q=f({},w[r],t);o=q.value;u=q.cloneDefaultValue;if(o){if((u===undefined&&(b===o.constructor||i.isArray(o)))||u===j||u===true){q.value=a.clone(o);}else{if(u===m){q.value=a.merge(o);}}}x=null;if(r.indexOf(h)!==-1){x=r.split(h);r=x.shift();}if(x&&s[r]&&s[r].value){e.setValue(s[r].value,x,o);}else{if(!x){if(!s[r]){s[r]=q;}else{f(s[r],q,t);}}}}}}}return s;},_initHierarchy:function(u){var q=this._lazyAddAttrs,v,x,z,s,p,y,t,r=this._getClasses(),o=this._getAttrCfgs(),w=r.length-1;for(z=w;z>=0;z--){v=r[z];x=v.prototype;t=v._yuibuild&&v._yuibuild.exts;if(t){for(s=0,p=t.length;s<p;s++){t[s].apply(this,arguments);}}this.addAttrs(this._filterAttrCfgs(v,o),u,q);if(this._allowAdHocAttrs&&z===w){this.addAttrs(this._filterAdHocAttrs(o,u),u,q);}if(x.hasOwnProperty(c)){x.initializer.apply(this,arguments);}if(t){for(s=0;s<p;s++){y=t[s].prototype;if(y.hasOwnProperty(c)){y.initializer.apply(this,arguments);}}}}},_destroyHierarchy:function(){var s,t,w,u,q,o,r,v,p=this._getClasses();for(w=0,u=p.length;w<u;w++){s=p[w];t=s.prototype;r=s._yuibuild&&s._yuibuild.exts;if(r){for(q=0,o=r.length;q<o;q++){v=r[q].prototype;if(v.hasOwnProperty(k)){v.destructor.apply(this,arguments);}}}if(t.hasOwnProperty(k)){t.destructor.apply(this,arguments);}}},toString:function(){return this.name+"["+a.stamp(this,true)+"]";}};a.mix(n,g,false,null,1);n.prototype.constructor=n;a.BaseCore=n;},"3.5.1",{requires:["attribute-core"]});/*
YUI 3.5.1 (build 22)
Copyright 2012 Yahoo! Inc. All rights reserved.
Licensed under the BSD License.
http://yuilibrary.com/license/
*/
YUI.add("event-custom-complex",function(f){var b,e,d={},a=f.CustomEvent.prototype,c=f.EventTarget.prototype;f.EventFacade=function(h,g){h=h||d;this._event=h;this.details=h.details;this.type=h.type;this._type=h.type;this.target=h.target;this.currentTarget=g;this.relatedTarget=h.relatedTarget;};f.extend(f.EventFacade,Object,{stopPropagation:function(){this._event.stopPropagation();this.stopped=1;},stopImmediatePropagation:function(){this._event.stopImmediatePropagation();this.stopped=2;},preventDefault:function(){this._event.preventDefault();this.prevented=1;},halt:function(g){this._event.halt(g);this.prevented=1;this.stopped=(g)?2:1;}});a.fireComplex=function(p){var r,l,g,n,i,o,u,j,h,t=this,s=t.host||t,m,k;if(t.stack){if(t.queuable&&t.type!=t.stack.next.type){t.log("queue "+t.type);t.stack.queue.push([t,p]);return true;}}r=t.stack||{id:t.id,next:t,silent:t.silent,stopped:0,prevented:0,bubbling:null,type:t.type,afterQueue:new f.Queue(),defaultTargetOnly:t.defaultTargetOnly,queue:[]};j=t.getSubs();t.stopped=(t.type!==r.type)?0:r.stopped;t.prevented=(t.type!==r.type)?0:r.prevented;t.target=t.target||s;u=new f.EventTarget({fireOnce:true,context:s});t.events=u;if(t.stoppedFn){u.on("stopped",t.stoppedFn);}t.currentTarget=s;t.details=p.slice();t.log("Firing "+t.type);t._facade=null;l=t._getFacade(p);if(f.Lang.isObject(p[0])){p[0]=l;}else{p.unshift(l);}if(j[0]){t._procSubs(j[0],p,l);}if(t.bubbles&&s.bubble&&!t.stopped){k=r.bubbling;r.bubbling=t.type;if(r.type!=t.type){r.stopped=0;r.prevented=0;}o=s.bubble(t,p,null,r);t.stopped=Math.max(t.stopped,r.stopped);t.prevented=Math.max(t.prevented,r.prevented);r.bubbling=k;}if(t.prevented){if(t.preventedFn){t.preventedFn.apply(s,p);}}else{if(t.defaultFn&&((!t.defaultTargetOnly&&!r.defaultTargetOnly)||s===l.target)){t.defaultFn.apply(s,p);}}t._broadcast(p);if(j[1]&&!t.prevented&&t.stopped<2){if(r.id===t.id||t.type!=s._yuievt.bubbling){t._procSubs(j[1],p,l);while((m=r.afterQueue.last())){m();}}else{h=j[1];if(r.execDefaultCnt){h=f.merge(h);f.each(h,function(q){q.postponed=true;});}r.afterQueue.add(function(){t._procSubs(h,p,l);});}}t.target=null;if(r.id===t.id){n=r.queue;while(n.length){g=n.pop();i=g[0];r.next=i;i.fire.apply(i,g[1]);}t.stack=null;}o=!(t.stopped);if(t.type!=s._yuievt.bubbling){r.stopped=0;r.prevented=0;t.stopped=0;t.prevented=0;}return o;};a._getFacade=function(){var g=this._facade,j,i,h=this.details;if(!g){g=new f.EventFacade(this,this.currentTarget);}j=h&&h[0];if(f.Lang.isObject(j,true)){i={};f.mix(i,g,true,e);f.mix(g,j,true);f.mix(g,i,true,e);g.type=j.type||g.type;}g.details=this.details;g.target=this.originalTarget||this.target;g.currentTarget=this.currentTarget;g.stopped=0;g.prevented=0;this._facade=g;return this._facade;};a.stopPropagation=function(){this.stopped=1;if(this.stack){this.stack.stopped=1;}this.events.fire("stopped",this);};a.stopImmediatePropagation=function(){this.stopped=2;if(this.stack){this.stack.stopped=2;}this.events.fire("stopped",this);};a.preventDefault=function(){if(this.preventable){this.prevented=1;if(this.stack){this.stack.prevented=1;}}};a.halt=function(g){if(g){this.stopImmediatePropagation();}else{this.stopPropagation();}this.preventDefault();};c.addTarget=function(g){this._yuievt.targets[f.stamp(g)]=g;this._yuievt.hasTargets=true;};c.getTargets=function(){return f.Object.values(this._yuievt.targets);};c.removeTarget=function(g){delete this._yuievt.targets[f.stamp(g)];};c.bubble=function(u,q,o,s){var m=this._yuievt.targets,p=true,v,r=u&&u.type,h,l,n,j,g=o||(u&&u.target)||this,k;if(!u||((!u.stopped)&&m)){for(l in m){if(m.hasOwnProperty(l)){v=m[l];h=v.getEvent(r,true);j=v.getSibling(r,h);if(j&&!h){h=v.publish(r);}k=v._yuievt.bubbling;v._yuievt.bubbling=r;if(!h){if(v._yuievt.hasTargets){v.bubble(u,q,g,s);}}else{h.sibling=j;h.target=g;h.originalTarget=g;h.currentTarget=v;n=h.broadcast;h.broadcast=false;h.emitFacade=true;h.stack=s;p=p&&h.fire.apply(h,q||u.details||[]);h.broadcast=n;h.originalTarget=null;if(h.stopped){break;}}v._yuievt.bubbling=k;}}}return p;};b=new f.EventFacade();e=f.Object.keys(b);},"3.5.1",{requires:["event-custom-base"]});/*
YUI 3.5.1 (build 22)
Copyright 2012 Yahoo! Inc. All rights reserved.
Licensed under the BSD License.
http://yuilibrary.com/license/
*/
YUI.add("attribute-events",function(e){var f=e.EventTarget,d="Change",a="broadcast",c="published";function b(){this._ATTR_E_FACADE={};f.call(this,{emitFacade:true});}b._ATTR_CFG=[a];b.prototype={set:function(g,i,h){return this._setAttr(g,i,h);},_set:function(g,i,h){return this._setAttr(g,i,h,true);},setAttrs:function(g,h){return this._setAttrs(g,h);},_fireAttrChange:function(o,n,k,j,g){var q=this,m=o+d,i=q._state,p,l,h;if(!i.get(o,c)){h={queuable:false,defaultTargetOnly:true,defaultFn:q._defAttrChangeFn,silent:true};l=i.get(o,a);if(l!==undefined){h.broadcast=l;}q.publish(m,h);i.add(o,c,true);}p=(g)?e.merge(g):q._ATTR_E_FACADE;p.attrName=o;p.subAttrName=n;p.prevVal=k;p.newVal=j;q.fire(m,p);},_defAttrChangeFn:function(g){if(!this._setAttrVal(g.attrName,g.subAttrName,g.prevVal,g.newVal)){g.stopImmediatePropagation();}else{g.newVal=this.get(g.attrName);}}};e.mix(b,f,false,null,1);e.AttributeEvents=b;},"3.5.1",{requires:["event-custom"]});/*
YUI 3.5.1 (build 22)
Copyright 2012 Yahoo! Inc. All rights reserved.
Licensed under the BSD License.
http://yuilibrary.com/license/
*/
YUI.add("attribute-extras",function(f){var a="broadcast",d="published",e="initValue",c={readOnly:1,writeOnce:1,getter:1,broadcast:1};function b(){}b.prototype={modifyAttr:function(h,g){var i=this,k,j;if(i.attrAdded(h)){if(i._isLazyAttr(h)){i._addLazyAttr(h);}j=i._state;for(k in g){if(c[k]&&g.hasOwnProperty(k)){j.add(h,k,g[k]);if(k===a){j.remove(h,d);}}}}},removeAttr:function(g){this._state.removeAll(g);},reset:function(g){var h=this;if(g){if(h._isLazyAttr(g)){h._addLazyAttr(g);}h.set(g,h._state.get(g,e));}else{f.each(h._state.data,function(i,j){h.reset(j);});}return h;},_getAttrCfg:function(g){var i,h=this._state;if(g){i=h.getAll(g)||{};}else{i={};f.each(h.data,function(j,k){i[k]=h.getAll(k);});}return i;}};f.AttributeExtras=b;},"3.5.1");/*
YUI 3.5.1 (build 22)
Copyright 2012 Yahoo! Inc. All rights reserved.
Licensed under the BSD License.
http://yuilibrary.com/license/
*/
YUI.add("attribute-base",function(b){var a=function(){this._ATTR_E_FACADE=null;this._yuievt=null;b.AttributeCore.apply(this,arguments);b.AttributeEvents.apply(this,arguments);b.AttributeExtras.apply(this,arguments);};b.mix(a,b.AttributeCore,false,null,1);b.mix(a,b.AttributeExtras,false,null,1);b.mix(a,b.AttributeEvents,true,null,1);a.INVALID_VALUE=b.AttributeCore.INVALID_VALUE;a._ATTR_CFG=b.AttributeCore._ATTR_CFG.concat(b.AttributeEvents._ATTR_CFG);b.Attribute=a;},"3.5.1",{requires:["attribute-core","attribute-events","attribute-extras"]});/*
YUI 3.5.1 (build 22)
Copyright 2012 Yahoo! Inc. All rights reserved.
Licensed under the BSD License.
http://yuilibrary.com/license/
*/
YUI.add("attribute-complex",function(b){var a=b.Object,c=".";b.Attribute.Complex=function(){};b.Attribute.Complex.prototype={_normAttrVals:function(g){var i={},h={},j,d,f,e;if(g){for(e in g){if(g.hasOwnProperty(e)){if(e.indexOf(c)!==-1){j=e.split(c);d=j.shift();f=h[d]=h[d]||[];f[f.length]={path:j,value:g[e]};}else{i[e]=g[e];}}}return{simple:i,complex:h};}else{return null;}},_getAttrInitVal:function(m,j,p){var e=j.value,o=j.valueFn,d,f,h,g,q,n,k;if(o){if(!o.call){o=this[o];}if(o){e=o.call(this,m);}}if(!j.readOnly&&p){d=p.simple;if(d&&d.hasOwnProperty(m)){e=d[m];}f=p.complex;if(f&&f.hasOwnProperty(m)){k=f[m];for(h=0,g=k.length;h<g;++h){q=k[h].path;n=k[h].value;a.setValue(e,q,n);}}}return e;}};b.mix(b.Attribute,b.Attribute.Complex,true,null,1);b.AttributeComplex=b.Attribute.Complex;},"3.5.1",{requires:["attribute-base"]});/*
YUI 3.5.1 (build 22)
Copyright 2012 Yahoo! Inc. All rights reserved.
Licensed under the BSD License.
http://yuilibrary.com/license/
*/
YUI.add("base-base",function(b){var g=b.Lang,e="destroy",i="init",h="bubbleTargets",c="_bubbleTargets",j=b.BaseCore,f=b.AttributeCore,a=b.Attribute;function d(){j.apply(this,arguments);}d._ATTR_CFG=a._ATTR_CFG.concat("cloneDefaultValue");d._ATTR_CFG_HASH=b.Array.hash(d._ATTR_CFG);d._NON_ATTRS_CFG=j._NON_ATTRS_CFG.concat(["on","after","bubbleTargets"]);d.NAME="base";d.ATTRS=f.prototype._protectAttrs(j.ATTRS);d.prototype={_initBase:function(k){this._eventPrefix=this.constructor.EVENT_PREFIX||this.constructor.NAME;b.BaseCore.prototype._initBase.call(this,k);},_initAttribute:function(k){a.call(this);this._yuievt.config.prefix=this._eventPrefix;},_attrCfgHash:function(){return d._ATTR_CFG_HASH;},init:function(k){this.publish(i,{queuable:false,fireOnce:true,defaultTargetOnly:true,defaultFn:this._defInitFn});this._preInitEventCfg(k);this.fire(i,{cfg:k});return this;},_preInitEventCfg:function(m){if(m){if(m.on){this.on(m.on);}if(m.after){this.after(m.after);}}var n,k,p,o=(m&&h in m);if(o||c in this){p=o?(m&&m.bubbleTargets):this._bubbleTargets;if(g.isArray(p)){for(n=0,k=p.length;n<k;n++){this.addTarget(p[n]);}}else{if(p){this.addTarget(p);}}}},destroy:function(){this.publish(e,{queuable:false,fireOnce:true,defaultTargetOnly:true,defaultFn:this._defDestroyFn});this.fire(e);this.detachAll();return this;},_defInitFn:function(k){this._baseInit(k.cfg);},_defDestroyFn:function(k){this._baseDestroy(k.cfg);}};b.mix(d,a,false,null,1);b.mix(d,j,false,null,1);d.prototype.constructor=d;b.Base=d;},"3.5.1",{requires:["base-core","attribute-base"]});/*
YUI 3.5.1 (build 22)
Copyright 2012 Yahoo! Inc. All rights reserved.
Licensed under the BSD License.
http://yuilibrary.com/license/
*/
YUI.add("base-build",function(g){var c=g.Base,a=g.Lang,b="initializer",e="destructor",f,d=function(j,i,h){if(h[j]){i[j]=(i[j]||[]).concat(h[j]);}};c._build=function(h,o,t,x,w,q){var y=c._build,j=y._ctor(o,q),m=y._cfg(o,q,t),v=y._mixCust,k=j._yuibuild.dynamic,p,n,u,z,s,r;for(p=0,n=t.length;p<n;p++){u=t[p];z=u.prototype;s=z[b];r=z[e];delete z[b];delete z[e];g.mix(j,u,true,null,1);v(j,u,m);if(s){z[b]=s;}if(r){z[e]=r;}j._yuibuild.exts.push(u);}if(x){g.mix(j.prototype,x,true);}if(w){g.mix(j,y._clean(w,m),true);v(j,w,m);}j.prototype.hasImpl=y._impl;if(k){j.NAME=h;j.prototype.constructor=j;}return j;};f=c._build;g.mix(f,{_mixCust:function(h,t,p){var o,j,q,k,m,n;if(p){o=p.aggregates;j=p.custom;q=p.statics;}if(q){g.mix(h,t,true,q);}if(o){for(n=0,m=o.length;n<m;n++){k=o[n];if(!h.hasOwnProperty(k)&&t.hasOwnProperty(k)){h[k]=a.isArray(t[k])?[]:{};}g.aggregate(h,t,true,[k]);}}if(j){for(n in j){if(j.hasOwnProperty(n)){j[n](n,h,t);}}}},_tmpl:function(h){function i(){i.superclass.constructor.apply(this,arguments);}g.extend(i,h);return i;},_impl:function(n){var q=this._getClasses(),p,k,h,o,r,m;for(p=0,k=q.length;p<k;p++){h=q[p];if(h._yuibuild){o=h._yuibuild.exts;r=o.length;for(m=0;m<r;m++){if(o[m]===n){return true;}}}}return false;},_ctor:function(h,i){var k=(i&&false===i.dynamic)?false:true,l=(k)?f._tmpl(h):h,j=l._yuibuild;if(!j){j=l._yuibuild={};}j.id=j.id||null;j.exts=j.exts||[];j.dynamic=k;return l;},_cfg:function(m,q,n){var k=[],p={},v=[],h,t=(q&&q.aggregates),u=(q&&q.custom),r=(q&&q.statics),s=m,o,j;while(s&&s.prototype){h=s._buildCfg;if(h){if(h.aggregates){k=k.concat(h.aggregates);}if(h.custom){g.mix(p,h.custom,true);}if(h.statics){v=v.concat(h.statics);}}s=s.superclass?s.superclass.constructor:null;}if(n){for(o=0,j=n.length;o<j;o++){s=n[o];h=s._buildCfg;if(h){if(h.aggregates){k=k.concat(h.aggregates);}if(h.custom){g.mix(p,h.custom,true);}if(h.statics){v=v.concat(h.statics);}}}}if(t){k=k.concat(t);}if(u){g.mix(p,q.cfgBuild,true);}if(r){v=v.concat(r);}return{aggregates:k,custom:p,statics:v};},_clean:function(q,j){var p,k,h,n=g.merge(q),o=j.aggregates,m=j.custom;for(p in m){if(n.hasOwnProperty(p)){delete n[p];}}for(k=0,h=o.length;k<h;k++){p=o[k];if(n.hasOwnProperty(p)){delete n[p];}}return n;}});c.build=function(j,h,k,i){return f(j,h,k,null,null,i);};c.create=function(h,k,j,i,l){return f(h,k,j,i,l);};c.mix=function(h,i){return f(null,h,i,null,null,{dynamic:false});};c._buildCfg={custom:{ATTRS:function(m,k,i){k.ATTRS=k.ATTRS||{};if(i.ATTRS){var j=i.ATTRS,l=k.ATTRS,h;for(h in j){if(j.hasOwnProperty(h)){l[h]=l[h]||{};g.mix(l[h],j[h],true);}}}},_NON_ATTRS_CFG:d},aggregates:["_PLUG","_UNPLUG"]};},"3.5.1",{requires:["base-base"]});/*
YUI 3.5.1 (build 22)
Copyright 2012 Yahoo! Inc. All rights reserved.
Licensed under the BSD License.
http://yuilibrary.com/license/
*/
YUI.add("base-pluginhost",function(c){var a=c.Base,b=c.Plugin.Host;c.mix(a,b,false,null,1);a.plug=b.plug;a.unplug=b.unplug;},"3.5.1",{requires:["base-base","pluginhost"]});/*
YUI 3.5.1 (build 22)
Copyright 2012 Yahoo! Inc. All rights reserved.
Licensed under the BSD License.
http://yuilibrary.com/license/
*/
YUI.add("querystring-stringify-simple",function(c){var b=c.namespace("QueryString"),a=encodeURIComponent;b.stringify=function(j,k){var d=[],h=k&&k.arrayKey?true:false,g,f,e;for(g in j){if(j.hasOwnProperty(g)){if(c.Lang.isArray(j[g])){for(f=0,e=j[g].length;f<e;f++){d.push(a(h?g+"[]":g)+"="+a(j[g][f]));}}else{d.push(a(g)+"="+a(j[g]));}}}return d.join("&");};},"3.5.1",{requires:["yui-base"]});/*
YUI 3.5.1 (build 22)
Copyright 2012 Yahoo! Inc. All rights reserved.
Licensed under the BSD License.
http://yuilibrary.com/license/
*/
YUI.add("io-base",function(a){var h=["start","complete","end","success","failure","progress"],b=["status","statusText","responseText","responseXML"],f=a.config.win,g=0;function c(j){var k=this;k._uid="io:"+g++;k._init(j);a.io._map[k._uid]=k;}c.prototype={_id:0,_headers:{"X-Requested-With":"XMLHttpRequest"},_timeout:{},_init:function(k){var m=this,l,j;m.cfg=k||{};a.augment(m,a.EventTarget);for(l=0,j=h.length;l<j;++l){m.publish("io:"+h[l],a.merge({broadcast:1},k));m.publish("io-trn:"+h[l],k);}},_create:function(k,p){var o=this,n={id:a.Lang.isNumber(p)?p:o._id++,uid:o._uid},m=k.xdr?k.xdr.use:null,l=k.form&&k.form.upload?"iframe":null,j;if(m==="native"){m=a.UA.ie?"xdr":null;}j=m||l;n=j?a.merge(a.IO.customTransport(j),n):a.merge(a.IO.defaultTransport(),n);if(n.notify){k.notify=function(r,q,s){o.notify(r,q,s);};}if(!j){if(f&&f.FormData&&k.data instanceof FormData){n.c.upload.onprogress=function(q){o.progress(n,q,k);};n.c.onload=function(q){o.load(n,q,k);};n.c.onerror=function(q){o.error(n,q,k);};n.upload=true;}}return n;},_destroy:function(j){if(f&&!j.notify&&!j.xdr){if(d&&!j.upload){j.c.onreadystatechange=null;}else{if(j.upload){j.c.upload.onprogress=null;j.c.onload=null;j.c.onerror=null;}else{if(a.UA.ie&&!j.e){j.c.abort();}}}}j=j.c=null;},_evt:function(n,k,j){var p=this,l,q=j["arguments"],r=p.cfg.emitFacade,m="io:"+n,o="io-trn:"+n;this.detach(o);if(k.e){k.c={status:0,statusText:k.e};}l=[r?{id:k.id,data:k.c,cfg:j,"arguments":q}:k.id];if(!r){if(n===h[0]||n===h[2]){if(q){l.push(q);}}else{if(k.evt){l.push(k.evt);}else{l.push(k.c);}if(q){l.push(q);}}}l.unshift(m);p.fire.apply(p,l);if(j.on){l[0]=o;p.once(o,j.on[n],j.context||a);p.fire.apply(p,l);}},start:function(k,j){this._evt(h[0],k,j);},complete:function(k,j){this._evt(h[1],k,j);},end:function(k,j){this._evt(h[2],k,j);this._destroy(k);},success:function(k,j){this._evt(h[3],k,j);this.end(k,j);},failure:function(k,j){this._evt(h[4],k,j);this.end(k,j);},progress:function(l,k,j){l.evt=k;this._evt(h[5],l,j);},load:function(l,k,j){l.evt=k.target;this._evt(h[1],l,j);},error:function(l,k,j){l.evt=k;this._evt(h[4],l,j);},_retry:function(l,k,j){this._destroy(l);j.xdr.use="flash";return this.send(k,j,l.id);},_concat:function(j,k){j+=(j.indexOf("?")===-1?"?":"&")+k;return j;},setHeader:function(j,k){if(k){this._headers[j]=k;}else{delete this._headers[j];}},_setHeaders:function(k,j){j=a.merge(this._headers,j);a.Object.each(j,function(m,l){if(m!=="disable"){k.setRequestHeader(l,j[l]);}});},_startTimeout:function(k,j){var l=this;l._timeout[k.id]=setTimeout(function(){l._abort(k,"timeout");},j);},_clearTimeout:function(j){clearTimeout(this._timeout[j]);delete this._timeout[j];},_result:function(m,k){var j;try{j=m.c.status;}catch(l){j=0;}if(j>=200&&j<300||j===304||j===1223){this.success(m,k);}else{this.failure(m,k);}},_rS:function(k,j){var l=this;if(k.c.readyState===4){if(j.timeout){l._clearTimeout(k.id);}setTimeout(function(){l.complete(k,j);l._result(k,j);},0);}},_abort:function(k,j){if(k&&k.c){k.e=j;k.c.abort();}},send:function(l,m,k){var n,j,q,r,v,p,t=this,w=l,o={};m=m?a.Object(m):{};n=t._create(m,k);j=m.method?m.method.toUpperCase():"GET";v=m.sync;p=m.data;if((a.Lang.isObject(p)&&!p.nodeType)&&!n.upload){p=a.QueryString.stringify(p);}if(m.form){if(m.form.upload){return t.upload(n,l,m);}else{p=t._serialize(m.form,p);}}if(p){switch(j){case"GET":case"HEAD":case"DELETE":w=t._concat(w,p);p="";break;case"POST":case"PUT":m.headers=a.merge({"Content-Type":"application/x-www-form-urlencoded; charset=UTF-8"},m.headers);break;}}if(n.xdr){return t.xdr(w,n,m);}else{if(n.notify){return n.c.send(n,l,m);}}if(!v&&!n.upload){n.c.onreadystatechange=function(){t._rS(n,m);};}try{n.c.open(j,w,!v,m.username||null,m.password||null);t._setHeaders(n.c,m.headers||{});t.start(n,m);if(m.xdr&&m.xdr.credentials){if(!a.UA.ie){n.c.withCredentials=true;}}n.c.send(p);if(v){for(q=0,r=b.length;q<r;++q){o[b[q]]=n.c[b[q]];}o.getAllResponseHeaders=function(){return n.c.getAllResponseHeaders();};o.getResponseHeader=function(u){return n.c.getResponseHeader(u);};t.complete(n,m);t._result(n,m);return o;}}catch(s){if(n.xdr){return t._retry(n,l,m);}else{t.complete(n,m);t._result(n,m);}}if(m.timeout){t._startTimeout(n,m.timeout);}return{id:n.id,abort:function(){return n.c?t._abort(n,"abort"):false;},isInProgress:function(){return n.c?(n.c.readyState%4):false;},io:t};}};a.io=function(k,j){var l=a.io._map["io:0"]||new c();return l.send.apply(l,[k,j]);};a.io.header=function(j,k){var l=a.io._map["io:0"]||new c();l.setHeader(j,k);};a.IO=c;a.io._map={};var d=f&&f.XMLHttpRequest,i=f&&f.XDomainRequest,e=f&&f.ActiveXObject;a.mix(a.IO,{_default:"xhr",defaultTransport:function(k){if(k){a.IO._default=k;}else{var j={c:a.IO.transports[a.IO._default](),notify:a.IO._default==="xhr"?false:true};return j;}},transports:{xhr:function(){return d?new XMLHttpRequest():e?new ActiveXObject("Microsoft.XMLHTTP"):null;},xdr:function(){return i?new XDomainRequest():null;},iframe:function(){return{};},flash:null,nodejs:null},customTransport:function(k){var j={c:a.IO.transports[k]()};j[(k==="xdr"||k==="flash")?"xdr":"notify"]=true;return j;}});a.mix(a.IO.prototype,{notify:function(k,l,j){var m=this;switch(k){case"timeout":case"abort":case"transport error":l.c={status:0,statusText:k};k="failure";default:m[k].apply(m,[l,j]);}}});},"3.5.1",{requires:["event-custom-base","querystring-stringify-simple"]});/*
YUI 3.5.1 (build 22)
Copyright 2012 Yahoo! Inc. All rights reserved.
Licensed under the BSD License.
http://yuilibrary.com/license/
*/
YUI.add("json-parse",function(b){function k(e){return(b.config.win||this||{})[e];}var j=k("JSON"),l=(Object.prototype.toString.call(j)==="[object JSON]"&&j),f=!!l,o=/[\u0000\u00ad\u0600-\u0604\u070f\u17b4\u17b5\u200c-\u200f\u2028-\u202f\u2060-\u206f\ufeff\ufff0-\uffff]/g,m=/\\(?:["\\\/bfnrt]|u[0-9a-fA-F]{4})/g,d=/"[^"\\\n\r]*"|true|false|null|-?\d+(?:\.\d*)?(?:[eE][+\-]?\d+)?/g,g=/(?:^|:|,)(?:\s*\[)+/g,p=/[^\],:{}\s]/,n=function(e){return"\\u"+("0000"+(+(e.charCodeAt(0))).toString(16)).slice(-4);},c=function(r,e){var q=function(x,u){var t,s,w=x[u];if(w&&typeof w==="object"){for(t in w){if(w.hasOwnProperty(t)){s=q(w,t);if(s===undefined){delete w[t];}else{w[t]=s;}}}}return e.call(x,u,w);};return typeof e==="function"?q({"":r},""):r;},h=function(q,e){q=q.replace(o,n);if(!p.test(q.replace(m,"@").replace(d,"]").replace(g,""))){return c(eval("("+q+")"),e);}throw new SyntaxError("JSON.parse");};b.namespace("JSON").parse=function(q,e){if(typeof q!=="string"){q+="";}return l&&b.JSON.useNativeParse?l.parse(q,e):h(q,e);};function a(q,e){return q==="ok"?true:e;}if(l){try{f=(l.parse('{"ok":false}',a)).ok;}catch(i){f=false;}}b.JSON.useNativeParse=f;},"3.5.1",{requires:["yui-base"]});YUI.add('moodle-enrol-notification', function(Y) {

var DIALOGUE_NAME = 'Moodle dialogue',
    DIALOGUE_PREFIX = 'moodle-dialogue',
    CONFIRM_NAME = 'Moodle confirmation dialogue',
    EXCEPTION_NAME = 'Moodle exception',
    AJAXEXCEPTION_NAME = 'Moodle AJAX exception',
    ALERT_NAME = 'Moodle alert',
    C = Y.Node.create,
    BASE = 'notificationBase',
    LIGHTBOX = 'lightbox',
    NODELIGHTBOX = 'nodeLightbox',
    COUNT = 0,
    CONFIRMYES = 'yesLabel',
    CONFIRMNO = 'noLabel',
    TITLE = 'title',
    QUESTION = 'question',
    CSS = {
        BASE : 'moodle-dialogue-base',
        WRAP : 'moodle-dialogue-wrap',
        HEADER : 'moodle-dialogue-hd',
        BODY : 'moodle-dialogue-bd',
        CONTENT : 'moodle-dialogue-content',
        FOOTER : 'moodle-dialogue-fd',
        HIDDEN : 'hidden',
        LIGHTBOX : 'moodle-dialogue-lightbox'
    };

var DIALOGUE = function(config) {
    COUNT++;
    var id = 'moodle-dialogue-'+COUNT;
    config.notificationBase =
        C('<div class="'+CSS.BASE+'">')
            .append(C('<div class="'+CSS.LIGHTBOX+' '+CSS.HIDDEN+'"></div>'))
            .append(C('<div id="'+id+'" class="'+CSS.WRAP+'"></div>')
                .append(C('<div class="'+CSS.HEADER+' yui3-widget-hd"></div>'))
                .append(C('<div class="'+CSS.BODY+' yui3-widget-bd"></div>'))
                .append(C('<div class="'+CSS.CONTENT+' yui3-widget-ft"></div>')));
    Y.one(document.body).append(config.notificationBase);
    config.srcNode =    '#'+id;
    config.width =      config.width || '400px';
    config.visible =    config.visible || false;
    config.center =     config.centered || true;
    config.centered =   false;
    DIALOGUE.superclass.constructor.apply(this, [config]);
};
Y.extend(DIALOGUE, Y.Overlay, {
    initializer : function(config) {
        this.set(NODELIGHTBOX, this.get(BASE).one('.'+CSS.LIGHTBOX).setStyle('opacity', 0.5));
        this.after('visibleChange', this.visibilityChanged, this);
        this.after('headerContentChange', function(e){
            var h = (this.get('closeButton'))?this.get(BASE).one('.'+CSS.HEADER):false;
            if (h && !h.one('.closebutton')) {
                var c = C('<div class="closebutton"></div>');
                c.on('click', this.hide, this);
                h.append(c);
            }
        }, this);
        this.render();
        this.show();
    },
    visibilityChanged : function(e) {
        switch (e.attrName) {
            case 'visible':
                if (this.get(LIGHTBOX)) {
                    var l = this.get(NODELIGHTBOX);
                    if (!e.prevVal && e.newVal) {
                        l.setStyle('height',l.get('docHeight')+'px').removeClass(CSS.HIDDEN);
                    } else if (e.prevVal && !e.newVal) {
                        l.addClass(CSS.HIDDEN);
                    }
                }
                if (this.get('center') && !e.prevVal && e.newVal) {
                    this.centerDialogue();
                }
                if (this.get('draggable')) {
                    var titlebar = '#' + this.get('id') + ' .' + CSS.HEADER;
                    this.plug(Y.Plugin.Drag, {handles : [titlebar]});
                    this.dd.addInvalid('div.closebutton');
                    Y.one(titlebar).setStyle('cursor', 'move');
                }
                break;
        }
    },
    centerDialogue : function() {
        var bb = this.get('boundingBox'), hidden = bb.hasClass(DIALOGUE_PREFIX+'-hidden');
        if (hidden) {
            bb.setStyle('top', '-1000px').removeClass(DIALOGUE_PREFIX+'-hidden');
        }
        var x = Math.max(Math.round((bb.get('winWidth') - bb.get('offsetWidth'))/2), 15);
        var y = Math.max(Math.round((bb.get('winHeight') - bb.get('offsetHeight'))/2), 15) + Y.one(window).get('scrollTop');

        if (hidden) {
            bb.addClass(DIALOGUE_PREFIX+'-hidden');
        }
        bb.setStyle('left', x).setStyle('top', y);
    }
}, {
    NAME : DIALOGUE_NAME,
    CSS_PREFIX : DIALOGUE_PREFIX,
    ATTRS : {
        notificationBase : {

        },
        nodeLightbox : {
            value : null
        },
        lightbox : {
            validator : Y.Lang.isBoolean,
            value : true
        },
        closeButton : {
            validator : Y.Lang.isBoolean,
            value : true
        },
        center : {
            validator : Y.Lang.isBoolean,
            value : true
        },
        draggable : {
            validator : Y.Lang.isBoolean,
            value : false
        }
    }
});

var ALERT = function(config) {
    config.closeButton = false;
    ALERT.superclass.constructor.apply(this, [config]);
};
Y.extend(ALERT, DIALOGUE, {
    _enterKeypress : null,
    initializer : function(config) {
        this.publish('complete');
        var yes = C('<input type="button" value="'+this.get(CONFIRMYES)+'" />'),
            content = C('<div class="confirmation-dialogue"></div>')
                    .append(C('<div class="confirmation-message">'+this.get('message')+'</div>'))
                    .append(C('<div class="confirmation-buttons"></div>')
                            .append(yes));
        this.get(BASE).addClass('moodle-dialogue-confirm');
        this.setStdModContent(Y.WidgetStdMod.BODY, content, Y.WidgetStdMod.REPLACE);
        this.setStdModContent(Y.WidgetStdMod.HEADER, this.get(TITLE), Y.WidgetStdMod.REPLACE);
        this.after('destroyedChange', function(){this.get(BASE).remove();}, this);
        this._enterKeypress = Y.on('key', this.submit, window, 'down:13', this);
        yes.on('click', this.submit, this);
    },
    submit : function(e, outcome) {
        this._enterKeypress.detach();
        this.fire('complete');
        this.hide();
        this.destroy();
    }
}, {
    NAME : ALERT_NAME,
    CSS_PREFIX : DIALOGUE_PREFIX,
    ATTRS : {
        title : {
            validator : Y.Lang.isString,
            value : 'Alert'
        },
        message : {
            validator : Y.Lang.isString,
            value : 'Confirm'
        },
        yesLabel : {
            validator : Y.Lang.isString,
            setter : function(txt) {
                if (!txt) {
                    txt = 'Ok';
                }
                return txt;
            },
            value : 'Ok'
        }
    }
});

var CONFIRM = function(config) {
    CONFIRM.superclass.constructor.apply(this, [config]);
};
Y.extend(CONFIRM, DIALOGUE, {
    _enterKeypress : null,
    _escKeypress : null,
    initializer : function(config) {
        this.publish('complete');
        this.publish('complete-yes');
        this.publish('complete-no');
        var yes = C('<input type="button" value="'+this.get(CONFIRMYES)+'" />'),
            no = C('<input type="button" value="'+this.get(CONFIRMNO)+'" />'),
            content = C('<div class="confirmation-dialogue"></div>')
                        .append(C('<div class="confirmation-message">'+this.get(QUESTION)+'</div>'))
                        .append(C('<div class="confirmation-buttons"></div>')
                            .append(yes)
                            .append(no));
        this.get(BASE).addClass('moodle-dialogue-confirm');
        this.setStdModContent(Y.WidgetStdMod.BODY, content, Y.WidgetStdMod.REPLACE);
        this.setStdModContent(Y.WidgetStdMod.HEADER, this.get(TITLE), Y.WidgetStdMod.REPLACE);
        this.after('destroyedChange', function(){this.get(BASE).remove();}, this);
        this._enterKeypress = Y.on('key', this.submit, window, 'down:13', this, true);
        this._escKeypress = Y.on('key', this.submit, window, 'down:27', this, false);
        yes.on('click', this.submit, this, true);
        no.on('click', this.submit, this, false);
    },
    submit : function(e, outcome) {
        this._enterKeypress.detach();
        this._escKeypress.detach();
        this.fire('complete', outcome);
        if (outcome) {
            this.fire('complete-yes');
        } else {
            this.fire('complete-no');
        }
        this.hide();
        this.destroy();
    }
}, {
    NAME : CONFIRM_NAME,
    CSS_PREFIX : DIALOGUE_PREFIX,
    ATTRS : {
        yesLabel : {
            validator : Y.Lang.isString,
            value : 'Yes'
        },
        noLabel : {
            validator : Y.Lang.isString,
            value : 'No'
        },
        title : {
            validator : Y.Lang.isString,
            value : 'Confirm'
        },
        question : {
            validator : Y.Lang.isString,
            value : 'Are you sure?'
        }
    }
});
Y.augment(CONFIRM, Y.EventTarget);

var EXCEPTION = function(config) {
    config.width = config.width || (M.cfg.developerdebug)?Math.floor(Y.one(document.body).get('winWidth')/3)+'px':null;
    config.closeButton = true;
    EXCEPTION.superclass.constructor.apply(this, [config]);
};
Y.extend(EXCEPTION, DIALOGUE, {
    _hideTimeout : null,
    _keypress : null,
    initializer : function(config) {
        this.get(BASE).addClass('moodle-dialogue-exception');
        this.setStdModContent(Y.WidgetStdMod.HEADER, config.name, Y.WidgetStdMod.REPLACE);
        var content = C('<div class="moodle-exception"></div>')
                    .append(C('<div class="moodle-exception-message">'+this.get('message')+'</div>'))
                    .append(C('<div class="moodle-exception-param hidden param-filename"><label>File:</label> '+this.get('fileName')+'</div>'))
                    .append(C('<div class="moodle-exception-param hidden param-linenumber"><label>Line:</label> '+this.get('lineNumber')+'</div>'))
                    .append(C('<div class="moodle-exception-param hidden param-stacktrace"><label>Stack trace:</label> <pre>'+this.get('stack')+'</pre></div>'));
        if (M.cfg.developerdebug) {
            content.all('.moodle-exception-param').removeClass('hidden');
        }
        this.setStdModContent(Y.WidgetStdMod.BODY, content, Y.WidgetStdMod.REPLACE);

        var self = this;
        var delay = this.get('hideTimeoutDelay');
        if (delay) {
            this._hideTimeout = setTimeout(function(){self.hide();}, delay);
        }
        this.after('visibleChange', this.visibilityChanged, this);
        this.after('destroyedChange', function(){this.get(BASE).remove();}, this);
        this._keypress = Y.on('key', this.hide, window, 'down:13,27', this);
        this.centerDialogue();
    },
    visibilityChanged : function(e) {
        if (e.attrName == 'visible' && e.prevVal && !e.newVal) {
            if (this._keypress) this._keypress.detach();
            var self = this;
            setTimeout(function(){self.destroy();}, 1000);
        }
    }
}, {
    NAME : EXCEPTION_NAME,
    CSS_PREFIX : DIALOGUE_PREFIX,
    ATTRS : {
        message : {
            value : ''
        },
        name : {
            value : ''
        },
        fileName : {
            value : ''
        },
        lineNumber : {
            value : ''
        },
        stack : {
            setter : function(str) {
                var lines = str.split("\n");
                var pattern = new RegExp('^(.+)@('+M.cfg.wwwroot+')?(.{0,75}).*:(\\d+)$');
                for (var i in lines) {
                    lines[i] = lines[i].replace(pattern, "<div class='stacktrace-line'>ln: $4</div><div class='stacktrace-file'>$3</div><div class='stacktrace-call'>$1</div>");
                }
                return lines.join('');
            },
            value : ''
        },
        hideTimeoutDelay : {
            validator : Y.Lang.isNumber,
            value : null
        }
    }
});

var AJAXEXCEPTION = function(config) {
    config.name = config.name || 'Error';
    config.closeButton = true;
    AJAXEXCEPTION.superclass.constructor.apply(this, [config]);
};
Y.extend(AJAXEXCEPTION, DIALOGUE, {
    _keypress : null,
    initializer : function(config) {
        this.get(BASE).addClass('moodle-dialogue-exception');
        this.setStdModContent(Y.WidgetStdMod.HEADER, config.name, Y.WidgetStdMod.REPLACE);
        var content = C('<div class="moodle-ajaxexception"></div>')
                    .append(C('<div class="moodle-exception-message">'+this.get('error')+'</div>'))
                    .append(C('<div class="moodle-exception-param hidden param-debuginfo"><label>URL:</label> '+this.get('reproductionlink')+'</div>'))
                    .append(C('<div class="moodle-exception-param hidden param-debuginfo"><label>Debug info:</label> '+this.get('debuginfo')+'</div>'))
                    .append(C('<div class="moodle-exception-param hidden param-stacktrace"><label>Stack trace:</label> <pre>'+this.get('stacktrace')+'</pre></div>'));
        if (M.cfg.developerdebug) {
            content.all('.moodle-exception-param').removeClass('hidden');
        }
        this.setStdModContent(Y.WidgetStdMod.BODY, content, Y.WidgetStdMod.REPLACE);

        var self = this;
        var delay = this.get('hideTimeoutDelay');
        if (delay) {
            this._hideTimeout = setTimeout(function(){self.hide();}, delay);
        }
        this.after('visibleChange', this.visibilityChanged, this);
        this._keypress = Y.on('key', this.hide, window, 'down:13, 27', this);
        this.centerDialogue();
    },
    visibilityChanged : function(e) {
        if (e.attrName == 'visible' && e.prevVal && !e.newVal) {
            var self = this;
            this._keypress.detach();
            setTimeout(function(){self.destroy();}, 1000);
        }
    }
}, {
    NAME : AJAXEXCEPTION_NAME,
    CSS_PREFIX : DIALOGUE_PREFIX,
    ATTRS : {
        error : {
            validator : Y.Lang.isString,
            value : 'Unknown error'
        },
        debuginfo : {
            value : null
        },
        stacktrace : {
            value : null
        },
        reproductionlink : {
            setter : function(link) {
                if (link !== null) {
                    link = '<a href="'+link+'">'+link.replace(M.cfg.wwwroot, '')+'</a>';
                }
                return link;
            },
            value : null
        },
        hideTimeoutDelay : {
            validator : Y.Lang.isNumber,
            value : null
        }
    }
});

M.core = M.core || {};
M.core.dialogue = DIALOGUE;
M.core.alert = ALERT;
M.core.confirm = CONFIRM;
M.core.exception = EXCEPTION;
M.core.ajaxException = AJAXEXCEPTION;

}, '@VERSION@', {requires:['base','node','overlay','event-key', 'moodle-enrol-notification-skin', 'dd-plugin']});
/*
YUI 3.5.1 (build 22)
Copyright 2012 Yahoo! Inc. All rights reserved.
Licensed under the BSD License.
http://yuilibrary.com/license/
*/
YUI.add("classnamemanager",function(c){var b="classNamePrefix",d="classNameDelimiter",a=c.config;a[b]=a[b]||"yui3";a[d]=a[d]||"-";c.ClassNameManager=function(){var e=a[b],f=a[d];return{getClassName:c.cached(function(){var g=c.Array(arguments);if(g[g.length-1]!==true){g.unshift(e);}else{g.pop();}return g.join(f);})};}();},"3.5.1",{requires:["yui-base"]});/*
YUI 3.5.1 (build 22)
Copyright 2012 Yahoo! Inc. All rights reserved.
Licensed under the BSD License.
http://yuilibrary.com/license/
*/
YUI.add("event-synthetic",function(b){var j=b.Env.evt.dom_map,d=b.Array,i=b.Lang,l=i.isObject,c=i.isString,e=i.isArray,g=b.Selector.query,k=function(){};function h(n,m){this.handle=n;this.emitFacade=m;}h.prototype.fire=function(s){var t=d(arguments,0,true),q=this.handle,o=q.evt,m=q.sub,p=m.context,u=m.filter,n=s||{},r;if(this.emitFacade){if(!s||!s.preventDefault){n=o._getFacade();if(l(s)&&!s.preventDefault){b.mix(n,s,true);t[0]=n;}else{t.unshift(n);}}n.type=o.type;n.details=t.slice();if(u){n.container=o.host;}}else{if(u&&l(s)&&s.currentTarget){t.shift();}}m.context=p||n.currentTarget||o.host;r=o.fire.apply(o,t);m.context=p;return r;};function f(o,n,m){this.handles=[];this.el=o;this.key=m;this.domkey=n;}f.prototype={constructor:f,type:"_synth",fn:k,capture:false,register:function(m){m.evt.registry=this;this.handles.push(m);},unregister:function(p){var o=this.handles,n=j[this.domkey],m;for(m=o.length-1;m>=0;--m){if(o[m].sub===p){o.splice(m,1);break;}}if(!o.length){delete n[this.key];if(!b.Object.size(n)){delete j[this.domkey];}}},detachAll:function(){var n=this.handles,m=n.length;while(--m>=0){n[m].detach();}}};function a(){this._init.apply(this,arguments);}b.mix(a,{Notifier:h,SynthRegistry:f,getRegistry:function(s,r,p){var q=s._node,o=b.stamp(q),n="event:"+o+r+"_synth",m=j[o];if(p){if(!m){m=j[o]={};}if(!m[n]){m[n]=new f(q,o,n);}}return(m&&m[n])||null;},_deleteSub:function(n){if(n&&n.fn){var m=this.eventDef,o=(n.filter)?"detachDelegate":"detach";this.subscribers={};this.subCount=0;m[o](n.node,n,this.notifier,n.filter);this.registry.unregister(n);delete n.fn;delete n.node;delete n.context;}},prototype:{constructor:a,_init:function(){var m=this.publishConfig||(this.publishConfig={});this.emitFacade=("emitFacade" in m)?m.emitFacade:true;m.emitFacade=false;},processArgs:k,on:k,detach:k,delegate:k,detachDelegate:k,_on:function(s,t){var u=[],o=s.slice(),p=this.processArgs(s,t),q=s[2],m=t?"delegate":"on",n,r;n=(c(q))?g(q):d(q||b.one(b.config.win));if(!n.length&&c(q)){r=b.on("available",function(){b.mix(r,b[m].apply(b,o),true);},q);return r;}b.Array.each(n,function(w){var x=s.slice(),v;w=b.one(w);if(w){if(t){v=x.splice(3,1)[0];}x.splice(0,4,x[1],x[3]);if(!this.preventDups||!this.getSubs(w,s,null,true)){u.push(this._subscribe(w,m,x,p,v));}}},this);return(u.length===1)?u[0]:new b.EventHandle(u);},_subscribe:function(q,o,t,r,p){var v=new b.CustomEvent(this.type,this.publishConfig),s=v.on.apply(v,t),u=new h(s,this.emitFacade),n=a.getRegistry(q,this.type,true),m=s.sub;m.node=q;m.filter=p;if(r){this.applyArgExtras(r,m);}b.mix(v,{eventDef:this,notifier:u,host:q,currentTarget:q,target:q,el:q._node,_delete:a._deleteSub},true);s.notifier=u;n.register(s);this[o](q,m,u,p);return s;},applyArgExtras:function(m,n){n._extra=m;},_detach:function(o){var t=o[2],r=(c(t))?g(t):d(t),s,q,m,p,n;o.splice(2,1);for(q=0,m=r.length;q<m;++q){s=b.one(r[q]);if(s){p=this.getSubs(s,o);if(p){for(n=p.length-1;n>=0;--n){p[n].detach();}}}}},getSubs:function(o,u,n,q){var m=a.getRegistry(o,this.type),v=[],t,p,s,r;if(m){t=m.handles;if(!n){n=this.subMatch;}for(p=0,s=t.length;p<s;++p){r=t[p];if(n.call(this,r.sub,u)){if(q){return r;}else{v.push(t[p]);}}}}return v.length&&v;},subMatch:function(n,m){return !m[1]||n.fn===m[1];}}},true);b.SyntheticEvent=a;b.Event.define=function(o,n,q){var p,r,m;if(o&&o.type){p=o;q=n;}else{if(n){p=b.merge({type:o},n);}}if(p){if(q||!b.Node.DOM_EVENTS[p.type]){r=function(){a.apply(this,arguments);};b.extend(r,a,p);m=new r();o=m.type;b.Node.DOM_EVENTS[o]=b.Env.evt.plugins[o]={eventDef:m,on:function(){return m._on(d(arguments));},delegate:function(){return m._on(d(arguments),true);},detach:function(){return m._detach(d(arguments));}};}}else{if(c(o)||e(o)){b.Array.each(d(o),function(s){b.Node.DOM_EVENTS[s]=1;});}}return m;};},"3.5.1",{requires:["node-base","event-custom-complex"]});/*
YUI 3.5.1 (build 22)
Copyright 2012 Yahoo! Inc. All rights reserved.
Licensed under the BSD License.
http://yuilibrary.com/license/
*/
YUI.add("event-focus",function(f){var d=f.Event,c=f.Lang,a=c.isString,e=f.Array.indexOf,b=c.isFunction(f.DOM.create('<p onbeforeactivate=";"/>').onbeforeactivate);function g(i,h,k){var j="_"+i+"Notifiers";f.Event.define(i,{_attach:function(m,n,l){if(f.DOM.isWindow(m)){return d._attach([i,function(o){n.fire(o);},m]);}else{return d._attach([h,this._proxy,m,this,n,l],{capture:true});}},_proxy:function(o,s,q){var p=o.target,m=o.currentTarget,r=p.getData(j),t=f.stamp(m._node),l=(b||p!==m),n;s.currentTarget=(q)?p:m;s.container=(q)?m:null;if(!r){r={};p.setData(j,r);if(l){n=d._attach([k,this._notify,p._node]).sub;n.once=true;}}else{l=true;}if(!r[t]){r[t]=[];}r[t].push(s);if(!l){this._notify(o);}},_notify:function(w,q){var C=w.currentTarget,l=C.getData(j),x=C.ancestors(),B=C.get("ownerDocument"),s=[],m=l?f.Object.keys(l).length:0,A,r,t,n,o,y,u,v,p,z;C.clearData(j);x.push(C);if(B){x.unshift(B);}x._nodes.reverse();y=m;x.some(function(H){var G=f.stamp(H),E=l[G],F,D;if(E){m--;for(F=0,D=E.length;F<D;++F){if(E[F].handle.sub.filter){s.push(E[F]);}}}return !m;});m=y;while(m&&(A=x.shift())){n=f.stamp(A);r=l[n];if(r){for(u=0,v=r.length;u<v;++u){t=r[u];p=t.handle.sub;o=true;w.currentTarget=A;if(p.filter){o=p.filter.apply(A,[A,w].concat(p.args||[]));s.splice(e(s,t),1);}if(o){w.container=t.container;z=t.fire(w);}if(z===false||w.stopped===2){break;}}delete r[n];m--;}if(w.stopped!==2){for(u=0,v=s.length;u<v;++u){t=s[u];p=t.handle.sub;if(p.filter.apply(A,[A,w].concat(p.args||[]))){w.container=t.container;w.currentTarget=A;z=t.fire(w);}if(z===false||w.stopped===2){break;}}}if(w.stopped){break;}}},on:function(n,l,m){l.handle=this._attach(n._node,m);},detach:function(m,l){l.handle.detach();},delegate:function(o,m,n,l){if(a(l)){m.filter=function(p){return f.Selector.test(p._node,l,o===p?null:o._node);};}m.handle=this._attach(o._node,n,true);},detachDelegate:function(m,l){l.handle.detach();}},true);}if(b){g("focus","beforeactivate","focusin");g("blur","beforedeactivate","focusout");}else{g("focus","focus","focus");g("blur","blur","blur");}},"3.5.1",{requires:["event-synthetic"]});/*
YUI 3.5.1 (build 22)
Copyright 2012 Yahoo! Inc. All rights reserved.
Licensed under the BSD License.
http://yuilibrary.com/license/
*/
YUI.add("widget-base",function(b){var g=b.Lang,r=b.Node,e=b.ClassNameManager,w=e.getClassName,M,s=b.cached(function(L){return L.substring(0,1).toUpperCase()+L.substring(1);}),F="content",P="visible",K="hidden",y="disabled",B="focused",d="width",A="height",N="boundingBox",v="contentBox",k="parentNode",m="ownerDocument",x="auto",j="srcNode",I="body",H="tabIndex",q="id",i="render",J="rendered",n="destroyed",a="strings",o="<div></div>",z="Change",p="loading",E="_uiSet",D="",G=function(){},u=true,O=false,t,l={},f=[P,y,A,d,B,H],C=b.UA.webkit,h={};function c(Q){var T=this,L,S,R=T.constructor;T._strs={};T._cssPrefix=R.CSS_PREFIX||w(R.NAME.toLowerCase());Q=Q||{};c.superclass.constructor.call(T,Q);S=T.get(i);if(S){if(S!==u){L=S;}T.render(L);}}c.NAME="widget";t=c.UI_SRC="ui";c.ATTRS=l;l[q]={valueFn:"_guid",writeOnce:u};l[J]={value:O,readOnly:u};l[N]={value:null,setter:"_setBB",writeOnce:u};l[v]={valueFn:"_defaultCB",setter:"_setCB",writeOnce:u};l[H]={value:null,validator:"_validTabIndex"};l[B]={value:O,readOnly:u};l[y]={value:O};l[P]={value:u};l[A]={value:D};l[d]={value:D};l[a]={value:{},setter:"_strSetter",getter:"_strGetter"};l[i]={value:O,writeOnce:u};c.CSS_PREFIX=w(c.NAME.toLowerCase());c.getClassName=function(){return w.apply(e,[c.CSS_PREFIX].concat(b.Array(arguments),true));};M=c.getClassName;c.getByNode=function(L){var S,R,Q=M();L=r.one(L);if(L){L=L.ancestor("."+Q,true);if(L){R=L.get(q);S=h[R];}}return S||null;};b.extend(c,b.Base,{getClassName:function(){return w.apply(e,[this._cssPrefix].concat(b.Array(arguments),true));},initializer:function(L){var Q=this.get(N);if(Q instanceof r){this._mapInstance(Q.get(q));}if(this._applyParser){this._applyParser(L);}},_mapInstance:function(L){if(!(h[L])){h[L]=this;}},destructor:function(){var L=this.get(N),Q;if(L instanceof r){Q=L.get(q);if(Q in h){delete h[Q];}this._destroyBox();}},destroy:function(L){this._destroyAllNodes=L;return c.superclass.destroy.apply(this);},_destroyBox:function(){var R=this.get(N),Q=this.get(v),L=this._destroyAllNodes,S;S=R&&R.compareTo(Q);if(this.UI_EVENTS){this._destroyUIEvents();}this._unbindUI(R);if(L){R.empty();R.remove(u);}else{if(Q){Q.remove(u);}if(!S){R.remove(u);}}},render:function(L){if(!this.get(n)&&!this.get(J)){this.publish(i,{queuable:O,fireOnce:u,defaultTargetOnly:u,defaultFn:this._defRenderFn});this.fire(i,{parentNode:(L)?r.one(L):null});}return this;},_defRenderFn:function(L){this._parentNode=L.parentNode;this.renderer();this._set(J,u);this._removeLoadingClassNames();},renderer:function(){var L=this;L._renderUI();L.renderUI();L._bindUI();L.bindUI();L._syncUI();L.syncUI();},bindUI:G,renderUI:G,syncUI:G,hide:function(){return this.set(P,O);},show:function(){return this.set(P,u);},focus:function(){return this._set(B,u);},blur:function(){return this._set(B,O);},enable:function(){return this.set(y,O);},disable:function(){return this.set(y,u);},_uiSizeCB:function(L){this.get(v).toggleClass(M(F,"expanded"),L);},_renderBox:function(L){var T=this,Q=T.get(v),R=T.get(N),V=T.get(j),S=T.DEF_PARENT_NODE,U=(V&&V.get(m))||R.get(m)||Q.get(m);if(V&&!V.compareTo(Q)&&!Q.inDoc(U)){V.replace(Q);}if(!R.compareTo(Q.get(k))&&!R.compareTo(Q)){if(Q.inDoc(U)){Q.replace(R);}R.appendChild(Q);}L=L||(S&&r.one(S));if(L){L.appendChild(R);}else{if(!R.inDoc(U)){r.one(I).insert(R,0);}}},_setBB:function(L){return this._setBox(this.get(q),L,this.BOUNDING_TEMPLATE);},_setCB:function(L){return(this.CONTENT_TEMPLATE===null)?this.get(N):this._setBox(null,L,this.CONTENT_TEMPLATE);},_defaultCB:function(L){return this.get(j)||null;},_setBox:function(R,Q,L){Q=r.one(Q)||r.create(L);if(!Q.get(q)){Q.set(q,R||b.guid());}return Q;},_renderUI:function(){this._renderBoxClassNames();this._renderBox(this._parentNode);},_renderBoxClassNames:function(){var S=this._getClasses(),L,Q=this.get(N),R;Q.addClass(M());for(R=S.length-3;R>=0;R--){L=S[R];Q.addClass(L.CSS_PREFIX||w(L.NAME.toLowerCase()));}this.get(v).addClass(this.getClassName(F));},_removeLoadingClassNames:function(){var R=this.get(N),L=this.get(v),Q=this.getClassName(p),S=M(p);R.removeClass(S).removeClass(Q);L.removeClass(S).removeClass(Q);},_bindUI:function(){this._bindAttrUI(this._UI_ATTRS.BIND);this._bindDOM();},_unbindUI:function(L){this._unbindDOM(L);},_bindDOM:function(){var L=this.get(N).get(m),Q=c._hDocFocus;if(!Q){Q=c._hDocFocus=L.on("focus",this._onDocFocus,this);Q.listeners={count:0};}Q.listeners[b.stamp(this,true)]=true;Q.listeners.count++;if(C){this._hDocMouseDown=L.on("mousedown",this._onDocMouseDown,this);}},_unbindDOM:function(L){var T=c._hDocFocus,Q=b.stamp(this,true),S,R=this._hDocMouseDown;if(T){S=T.listeners;if(S[Q]){delete S[Q];S.count--;}if(S.count===0){T.detach();c._hDocFocus=null;}}if(C&&R){R.detach();}},_syncUI:function(){this._syncAttrUI(this._UI_ATTRS.SYNC);},_uiSetHeight:function(L){this._uiSetDim(A,L);this._uiSizeCB((L!==D&&L!==x));},_uiSetWidth:function(L){this._uiSetDim(d,L);},_uiSetDim:function(L,Q){this.get(N).setStyle(L,g.isNumber(Q)?Q+this.DEF_UNIT:Q);},_uiSetVisible:function(L){this.get(N).toggleClass(this.getClassName(K),!L);},_uiSetDisabled:function(L){this.get(N).toggleClass(this.getClassName(y),L);},_uiSetFocused:function(R,Q){var L=this.get(N);L.toggleClass(this.getClassName(B),R);if(Q!==t){if(R){L.focus();}else{L.blur();}}},_uiSetTabIndex:function(Q){var L=this.get(N);if(g.isNumber(Q)){L.set(H,Q);}else{L.removeAttribute(H);}},_onDocMouseDown:function(L){if(this._domFocus){this._onDocFocus(L);}},_onDocFocus:function(L){var Q=c.getByNode(L.target),R=c._active;if(R&&(R!==Q)){R._domFocus=false;R._set(B,false,{src:t});c._active=null;}if(Q){Q._domFocus=true;Q._set(B,true,{src:t});c._active=Q;}},toString:function(){return this.name+"["+this.get(q)+"]";},DEF_UNIT:"px",DEF_PARENT_NODE:null,CONTENT_TEMPLATE:o,BOUNDING_TEMPLATE:o,_guid:function(){return b.guid();},_validTabIndex:function(L){return(g.isNumber(L)||g.isNull(L));},_bindAttrUI:function(Q){var R,L=Q.length;for(R=0;R<L;R++){this.after(Q[R]+z,this._setAttrUI);}},_syncAttrUI:function(R){var S,Q=R.length,L;for(S=0;S<Q;S++){L=R[S];
this[E+s(L)](this.get(L));}},_setAttrUI:function(L){if(L.target===this){this[E+s(L.attrName)](L.newVal,L.src);}},_strSetter:function(L){return b.merge(this.get(a),L);},getString:function(L){return this.get(a)[L];},getStrings:function(){return this.get(a);},_UI_ATTRS:{BIND:f,SYNC:f}});b.Widget=c;},"3.5.1",{requires:["attribute","event-focus","base-base","base-pluginhost","node-base","node-style","classnamemanager"],skinnable:true});/*
YUI 3.5.1 (build 22)
Copyright 2012 Yahoo! Inc. All rights reserved.
Licensed under the BSD License.
http://yuilibrary.com/license/
*/
YUI.add("widget-htmlparser",function(f){var e=f.Widget,c=f.Node,d=f.Lang,a="srcNode",b="contentBox";e.HTML_PARSER={};e._buildCfg={aggregates:["HTML_PARSER"]};e.ATTRS[a]={value:null,setter:c.one,getter:"_getSrcNode",writeOnce:true};f.mix(e.prototype,{_getSrcNode:function(g){return g||this.get(b);},_applyParsedConfig:function(i,g,h){return(h)?f.mix(g,h,false):g;},_applyParser:function(g){var i=this,j=i.get(a),h=i._getHtmlParser(),l,k;if(h&&j){f.Object.each(h,function(n,m,p){k=null;if(d.isFunction(n)){k=n.call(i,j);}else{if(d.isArray(n)){k=j.all(n[0]);if(k.isEmpty()){k=null;}}else{k=j.one(n);}}if(k!==null&&k!==undefined){l=l||{};l[m]=k;}});}g=i._applyParsedConfig(j,g,l);},_getHtmlParser:function(){var h=this._getClasses(),k={},g,j;for(g=h.length-1;g>=0;g--){j=h[g].HTML_PARSER;if(j){f.mix(k,j,true);}}return k;}});},"3.5.1",{requires:["widget-base"]});