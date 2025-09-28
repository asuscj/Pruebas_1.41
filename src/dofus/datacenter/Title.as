class dofus.datacenter.Title
{
   var _color;
   var _id;
   var _text;
   var api;
   function Title(id, param)
   {
      this.api = _global.API;
      this._id = id;
      var _loc4_;
      switch(this.api.lang.getTitle(id).pt)
      {
         case 1:
            _loc4_ = this.api.lang.getTitle(id).t.split("%1").join(this.api.lang.getMonsters()[_global.parseInt(param)].n);
            break;
         case 0:
         default:
            _loc4_ = this.api.lang.getTitle(id).t.split("%1").join(param);
      }
      this._text = "« " + _loc4_ + " »";
      this._color = this.api.lang.getTitle(id).c;
   }
   function get color()
   {
      return this._color;
   }
   function get text()
   {
      return this._text;
   }
}
