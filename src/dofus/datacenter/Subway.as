class dofus.datacenter.Subway extends dofus.datacenter.Hint
{
   var _nCost;
   var fieldToSort;
   function Subway(data, cost)
   {
      super(data);
      this._nCost = cost;
      this.fieldToSort = this.name + this.mapID;
   }
   function get cost()
   {
      return this._nCost;
   }
}
