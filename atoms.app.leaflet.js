(function(){"use strict";var __geocode,__markerIcon,__parseAddress,__queryPlace,__bind=function(fn,me){return function(){return fn.apply(me,arguments)}},__hasProp={}.hasOwnProperty,__extends=function(child,parent){function ctor(){this.constructor=child}for(var key in parent)__hasProp.call(parent,key)&&(child[key]=parent[key]);return ctor.prototype=parent.prototype,child.prototype=new ctor,child.__super__=parent.prototype,child};Atoms.Atom.Leaflet=function(_super){function Leaflet(){return this.__init=__bind(this.__init,this),Leaflet.__super__.constructor.apply(this,arguments)}return __extends(Leaflet,_super),Leaflet.template='<div id="{{id}}" {{#if.style}}class="{{style}}"{{/if.style}}>\n  <span class="icon loading-d"></span>\n</div>',Leaflet.base="Leaflet",Leaflet.events=["query"],Leaflet.prototype._map=null,Leaflet.prototype._markers=[],Leaflet.prototype._query=[],Leaflet.prototype._tileUrl="http://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",Leaflet.prototype.output=function(){var url;return Leaflet.__super__.output.apply(this,arguments),Atoms.$("[data-extension=leaflet]").length>0?this.__init():(url="http://cdn.leafletjs.com/leaflet-0.7.3/leaflet",Hope.chain([function(){return function(){return Atoms.resource("leaflet","link",""+url+".css")}}(this),function(){return function(){return Atoms.resource("leaflet","script",""+url+".js")}}(this)]).then(function(_this){return function(error){return error?console.error("Atoms.App.Leaflet error loading resources"):_this.__init()}}(this)))},Leaflet.prototype.center=function(position,zoom_level){var latLng;return null==zoom_level&&(zoom_level=8),latLng="undefined"!=typeof L&&null!==L?L.latLng(position.latitude,position.longitude):void 0,this._map.setView(latLng,zoom_level)},Leaflet.prototype.zoom=function(level){return this._map.setZoom(level)},Leaflet.prototype.query=function(value){return"string"==typeof value&&(this._query=[],__geocode(value).then(function(_this){return function(error,results){var result;return _this._query=function(){var _i,_len,_results;for(_results=[],_i=0,_len=results.length;_len>_i;_i++)result=results[_i],_results.push(__parseAddress(result));return _results}(),_this.bubble("query",_this._query)}}(this))),!0},Leaflet.prototype.marker=function(position,icon,animate){var latLng,marker,markerOptions;return null==animate&&(animate=!1),latLng="undefined"!=typeof L&&null!==L?L.latLng(position.latitude,position.longitude):void 0,markerOptions={icon:__markerIcon(icon)},marker="undefined"!=typeof L&&null!==L?new L.marker(latLng,markerOptions):void 0,this._map.addLayer(marker),this._markers.push(marker),!0},Leaflet.prototype.clean=function(){var marker,_i,_len,_ref;for(_ref=this._markers,_i=0,_len=_ref.length;_len>_i;_i++)marker=_ref[_i],this._map.removeLayer(marker);return this._markers=[]},Leaflet.prototype.__init=function(){var mapOptions,tileOptions,tileUrl,_ref;return mapOptions={center:[43.256963,-2.923441],zoom:1,zoomControl:!1},tileUrl=null!=(_ref=this.attributes.tile)?_ref:this._tileUrl,tileOptions={attribution:'Map data &copy; <a href="http://openstreetmap.org">OpenStreetMap</a> contributors'},this._map="undefined"!=typeof L&&null!==L?L.map(this.attributes.id,mapOptions):void 0,"undefined"!=typeof L&&null!==L?L.tileLayer(tileUrl,tileOptions).addTo(this._map):void 0},Leaflet}(Atoms.Class.Atom),__markerIcon=function(icon){var iconOptions;return icon?(iconOptions={iconUrl:icon.url,iconSize:[icon.size_x,icon.size_y],iconAnchor:[icon.anchor_x,icon.anchor_y]},"undefined"!=typeof L&&null!==L?L.icon(iconOptions):void 0):"undefined"!=typeof L&&null!==L?new L.Icon.Default:void 0},__queryPlace=function(value){return value=null!=value.latitude&&null!=value.longitude?"undefined"!=typeof L&&null!==L?L.latLng(value.latitude,value.longitude):void 0:null},__parseAddress=function(address){return{address:address.display_name,type:address.type,position:{latitude:address.lat,longitude:address.lon}}},__geocode=function(value){var ajax,promise;return promise=new Hope.Promise,ajax=$$.ajax||$.ajax,ajax({url:"http://nominatim.openstreetmap.org/search",data:{q:value,format:"json"},success:function(){return function(response){return promise.done(null,response)}}(this),error:function(){return function(response,error){return console.error(error),promise.done(error,null)}}(this)}),promise}}).call(this);