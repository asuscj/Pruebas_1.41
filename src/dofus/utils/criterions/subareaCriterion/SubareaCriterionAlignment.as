class dofus.utils.criterions.subareaCriterion.SubareaCriterionAlignment extends dofus.utils.ApiElement implements dofus.utils.criterions.ICriterion
{
   var _aSubarea;
   var _nAlignmentIndex;
   var _sOperator;
   var api;
   function SubareaCriterionAlignment(sOperator, nAlignmentIndex)
   {
      super();
      this._sOperator = sOperator;
      this._nAlignmentIndex = nAlignmentIndex;
      this._aSubarea = new dofus.datacenter.Subarea(this.api.datacenter.Map.subarea, 0);
   }
   function isFilled()
   {
      var _loc2_ = this._aSubarea.alignment;
      switch(this._sOperator)
      {
         case "=":
            return this._aSubarea.alignment.index == this._nAlignmentIndex;
         case "!":
            return this._aSubarea.alignment.index != this._nAlignmentIndex;
         default:
            return false;
      }
   }
   function check()
   {
      return "=!".indexOf(this._sOperator) > -1;
   }
   function checkCriterion(api):Boolean
   {
      return this.isFilled();
   }
}
