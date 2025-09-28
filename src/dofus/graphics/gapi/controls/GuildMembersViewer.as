class dofus.graphics.gapi.controls.GuildMembersViewer extends dofus.graphics.gapi.core.DofusAdvancedComponent
{
   var _btnShowOfflineMembers;
   var _dgMembers;
   var _eaData;
   var _lblCount;
   var _lblDescription;
   var _lblSeeAvgMembersLvl;
   var _lblShowOfflineMembers;
   var addToQueue;
   var api;
   static var CLASS_NAME = "GuildMembersViewer";
   function GuildMembersViewer()
   {
      super();
   }
   function set members(eaMembers)
   {
      this._eaData = eaMembers;
      this.updateData(this._eaData);
   }
   function init()
   {
      super.init(false,dofus.graphics.gapi.controls.GuildMembersViewer.CLASS_NAME);
   }
   function createChildren()
   {
      this.addToQueue({object:this,method:this.initTexts});
      this.addToQueue({object:this,method:this.addListeners});
   }
   function addListeners()
   {
      this._dgMembers.addEventListener("itemSelected",this);
      this._dgMembers.addEventListener("itemRollOver",this);
      this._dgMembers.addEventListener("itemRollOut",this);
      this._btnShowOfflineMembers.addEventListener("click",this);
   }
   function initTexts()
   {
      this._dgMembers.columnsNames = ["","",this.api.lang.getText("NAME_BIG"),this.api.lang.getText("GUILD_RANK"),this.api.lang.getText("LEVEL_SMALL"),this.api.lang.getText("PERCENT_XP"),this.api.lang.getText("WIN_XP"),""];
      this._lblDescription.text = this.api.lang.getText("GUILD_MEMBERS_LIST");
      this._lblShowOfflineMembers.text = this.api.lang.getText("DISPLAY_OFFLINE_GUILD_MEMBERS");
   }
   function updateData(eaMembers)
   {
      var _loc3_ = 0;
      var _loc4_ = 0;
      while(_loc4_ < eaMembers.length)
      {
         if(eaMembers[_loc4_].state != 0)
         {
            _loc3_ = _loc3_ + 1;
         }
         _loc4_ = _loc4_ + 1;
      }
      this._lblCount.text = _loc3_ + " / " + String(eaMembers.length) + " " + ank.utils.PatternDecoder.combine(this.api.lang.getText("MEMBERS"),"m",eaMembers.length < 2);
      var _loc5_ = new ank.utils.ExtendedArray();
      var _loc6_;
      if(!this._btnShowOfflineMembers.selected)
      {
         _loc6_ = 0;
         while(_loc6_ < eaMembers.length)
         {
            if(eaMembers[_loc6_].state != 0)
            {
               _loc5_.push(eaMembers[_loc6_]);
            }
            _loc6_ = _loc6_ + 1;
         }
      }
      else
      {
         _loc5_ = eaMembers;
      }
      var _loc7_ = 0;
      var _loc8_ = 0;
      while(_loc8_ < eaMembers.length)
      {
         _loc7_ += eaMembers[_loc8_].level;
         _loc8_ = _loc8_ + 1;
      }
      _loc7_ = Math.floor(_loc7_ / eaMembers.length);
      if(!_global.isNaN(_loc7_))
      {
         this._lblSeeAvgMembersLvl.text = this.api.lang.getText("GUILD_AVG_MEMBERS_LEVEL") + " : " + _loc7_;
      }
      else
      {
         this._lblSeeAvgMembersLvl.text = "";
      }
      this._dgMembers.dataProvider = _loc5_;
   }
   function itemSelected(oEvent)
   {
      var _loc3_ = oEvent.row.item;
      if(_loc3_.name != this.api.datacenter.Player.Name)
      {
         if(_loc3_.state == 0)
         {
            this.api.kernel.showMessage(undefined,this.api.lang.getText("USER_NOT_CONNECTED",[_loc3_.name]),"ERROR_CHAT");
         }
         else
         {
            this.api.kernel.GameManager.showPlayerPopupMenu(undefined,{sPlayerName:_loc3_.name,sPlayerID:_loc3_.id,bNoGuildInvite:true,bShowJoinFriend:this.api.datacenter.Player.isAuthorized,bShowViewTtgCollection:_loc3_.hasTtgCollection});
         }
      }
   }
   function itemRollOver(oEvent)
   {
      oEvent.row.cellRenderer_mc.over();
   }
   function itemRollOut(oEvent)
   {
      oEvent.row.cellRenderer_mc.out();
   }
   function click(oEvent)
   {
      var _loc0_;
      if((_loc0_ = oEvent.target) === this._btnShowOfflineMembers)
      {
         this.updateData(this._eaData);
      }
   }
}
