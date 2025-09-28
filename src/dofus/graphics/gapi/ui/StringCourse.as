class dofus.graphics.gapi.ui.StringCourse extends dofus.graphics.gapi.core.DofusAdvancedComponent
{
   var _bFilters;
   var _colors;
   var _lblLevel;
   var _lblName;
   var _ldrStringCourse;
   var _mcAnim;
   var _nGfxID;
   var _sGfx;
   var _sLevel;
   var _sName;
   var addToQueue;
   var unloadThis;
   static var CLASS_NAME = "StringCourse";
   function StringCourse()
   {
      super();
   }
   function set name(sName)
   {
      this._sName = sName;
   }
   function set level(sLevel)
   {
      this._sLevel = sLevel;
   }
   function set gfx(sGfx)
   {
      this._sGfx = sGfx;
   }
   function set colors(aColors)
   {
      this._colors = aColors;
   }
   function set bFilters(bFilters)
   {
      this._bFilters = bFilters;
   }
   function set gfxID(nGfxID)
   {
      this._nGfxID = nGfxID;
   }
   function init()
   {
      super.init(false,dofus.graphics.gapi.ui.StringCourse.CLASS_NAME);
   }
   function createChildren()
   {
      this.addToQueue({object:this,method:this.loadContent});
   }
   function loadContent()
   {
      this._ldrStringCourse.addEventListener("error",this);
      this._ldrStringCourse.addEventListener("complete",this);
      this._ldrStringCourse.contentPath = this._sGfx;
      if(dofus.Constants.INVADER_AREA && this._bFilters)
      {
         if(this._nGfxID == 1219)
         {
            return undefined;
         }
         this._ldrStringCourse.filters = [new flash.filters.GlowFilter(16711680,1,10,10,1,1,true,false)];
      }
   }
   function unloadContent()
   {
      this._ldrStringCourse.contentPath = "";
      this._lblName.text = "";
      this._lblLevel.text = "";
   }
   function applyColor(mc, zone)
   {
      var _loc4_ = this._colors[zone];
      if(_loc4_ == -1 || _loc4_ == undefined)
      {
         return undefined;
      }
      var _loc5_ = (_loc4_ & 0xFF0000) >> 16;
      var _loc6_ = (_loc4_ & 0xFF00) >> 8;
      var _loc7_ = _loc4_ & 0xFF;
      var _loc8_ = new Color(mc);
      var _loc9_ = {};
      _loc9_ = {ra:0,ga:0,ba:0,rb:_loc5_,gb:_loc6_,bb:_loc7_};
      _loc8_.setTransform(_loc9_);
   }
   function complete(oEvent)
   {
      this._lblName.text = this._sName;
      this._lblLevel.text = this._sLevel;
      var ref = this;
      this._ldrStringCourse.content.stringCourseColor = function(mc, z)
      {
         ref.applyColor(mc,z);
      };
      this._mcAnim.play();
   }
   function error(oEvent)
   {
      this.unloadThis();
   }
}
