class dofus.datacenter.GuildInfos extends Object
{
   var _bValid;
   var _eaHouses;
   var _eaMembers;
   var _eaMountParks;
   var _eaTaxCollectors;
   var _eaTaxSpells;
   var _grPlayerRights;
   var _nBackEmblemColor;
   var _nBackEmblemID;
   var _nBoostPoints;
   var _nDefendedTaxCollectorID;
   var _nInfosLastModification;
   var _nLevel;
   var _nMaxMountParks;
   var _nNoteLastModification;
   var _nTaxBonusDamage;
   var _nTaxCount;
   var _nTaxCountMax;
   var _nTaxHireCost;
   var _nTaxLP;
   var _nTaxPP;
   var _nTaxPercepteur;
   var _nTaxPods;
   var _nTaxSagesse;
   var _nUpEmblemColor;
   var _nUpEmblemID;
   var _nXP;
   var _nXPMax;
   var _nXPMin;
   var _oRanksName;
   var _sInfos;
   var _sInfosMember;
   var _sName;
   var _sNote;
   var _sNoteMember;
   var api;
   var dispatchEvent;
   function GuildInfos(sName, nBackEmblemID, nBackEmblemColor, nUpEmblemID, nUpEmblemColor, nPlayerRights)
   {
      super();
      this.api = _global.API;
      mx.events.EventDispatcher.initialize(this);
      this.initialize(false,sName,nBackEmblemID,nBackEmblemColor,nUpEmblemID,nUpEmblemColor,nPlayerRights);
      this._eaMembers = new ank.utils.ExtendedArray();
      this._eaTaxCollectors = new ank.utils.ExtendedArray();
      this._eaMountParks = new ank.utils.ExtendedArray();
      this._oRanksName = new dofus.datacenter.GuildRanks();
   }
   function get name()
   {
      return this._sName;
   }
   function get isValid()
   {
      return this._bValid;
   }
   function get emblem()
   {
      return {backID:this._nBackEmblemID,backColor:this._nBackEmblemColor,upID:this._nUpEmblemID,upColor:this._nUpEmblemColor};
   }
   function get playerRights()
   {
      return this._grPlayerRights;
   }
   function get level()
   {
      return this._nLevel;
   }
   function get xpmin()
   {
      return this._nXPMin;
   }
   function get xpmax()
   {
      return this._nXPMax;
   }
   function get xp()
   {
      return this._nXP;
   }
   function get members()
   {
      return this._eaMembers;
   }
   function get taxCount()
   {
      return this._nTaxCount;
   }
   function set taxCount(nTaxCount)
   {
      this._nTaxCount = nTaxCount;
   }
   function get taxCountMax()
   {
      return this._nTaxCountMax;
   }
   function set taxCountMax(nTaxCountMax)
   {
      this._nTaxCountMax = nTaxCountMax;
   }
   function get taxSpells()
   {
      return this._eaTaxSpells;
   }
   function get taxLp()
   {
      return this._nTaxLP;
   }
   function get taxBonus()
   {
      return this._nTaxBonusDamage;
   }
   function get taxcollectorHireCost()
   {
      return this._nTaxHireCost;
   }
   function set taxcollectorHireCost(nTaxHireCost)
   {
      this._nTaxHireCost = nTaxHireCost;
   }
   function get taxPod()
   {
      return this._nTaxPods;
   }
   function get taxPP()
   {
      return this._nTaxPP;
   }
   function get taxWisdom()
   {
      return this._nTaxSagesse;
   }
   function get taxPopulation()
   {
      return this._nTaxPercepteur;
   }
   function get boostPoints()
   {
      return this._nBoostPoints;
   }
   function get taxCollectors()
   {
      return this._eaTaxCollectors;
   }
   function get mountParks()
   {
      return this._eaMountParks;
   }
   function get maxMountParks()
   {
      return this._nMaxMountParks;
   }
   function get houses()
   {
      return this._eaHouses;
   }
   function set defendedTaxCollectorID(nDefendedTaxCollectorID)
   {
      this._nDefendedTaxCollectorID = nDefendedTaxCollectorID;
   }
   function get defendedTaxCollectorID()
   {
      return this._nDefendedTaxCollectorID;
   }
   function get isLocalPlayerDefender()
   {
      return this._nDefendedTaxCollectorID != undefined;
   }
   function get note()
   {
      return this._sNote;
   }
   function get noteMember()
   {
      return this._sNoteMember;
   }
   function get noteFormatedLastModification()
   {
      var _loc2_ = new Date(this._nNoteLastModification);
      return this.formatDate(_loc2_);
   }
   function get infos()
   {
      return this._sInfos;
   }
   function get infosMember()
   {
      return this._sInfosMember;
   }
   function get infosFormatedLastModification()
   {
      var _loc2_ = new Date(this._nInfosLastModification);
      return this.formatDate(_loc2_);
   }
   function initialize(bUpdate, sName, nBackEmblemID, nBackEmblemColor, nUpEmblemID, nUpEmblemColor, nPlayerRights)
   {
      this._sName = sName;
      this._nBackEmblemID = nBackEmblemID;
      this._nBackEmblemColor = nBackEmblemColor;
      this._nUpEmblemID = nUpEmblemID;
      this._nUpEmblemColor = nUpEmblemColor;
      this._grPlayerRights = new dofus.datacenter.GuildRights(nPlayerRights);
      if(bUpdate)
      {
         this.dispatchEvent({type:"modelChanged",eventName:"infosUpdate"});
         this.dispatchEvent({type:"rightsChanged"});
      }
   }
   function setGeneralInfos(bValid, nLevel, nXPMin, nXP, nXPMax)
   {
      this._bValid = bValid;
      this._nLevel = nLevel;
      this._nXPMin = nXPMin;
      this._nXP = nXP;
      this._nXPMax = nXPMax;
      this.dispatchEvent({type:"modelChanged",eventName:"general"});
   }
   function setNote(sNote, sNoteMember, nNoteLastModification)
   {
      this._sNote = sNote;
      this._sNoteMember = sNoteMember;
      this._nNoteLastModification = nNoteLastModification;
      this.dispatchEvent({type:"modelChanged",eventName:"note"});
   }
   function setInformations(sInfos, sInfosMember, nInfosLastModification)
   {
      this._sInfos = sInfos;
      this._sInfosMember = sInfosMember;
      this._nInfosLastModification = nInfosLastModification;
      this.dispatchEvent({type:"modelChanged",eventName:"informations"});
   }
   function setMembers()
   {
      this.dispatchEvent({type:"modelChanged",eventName:"members"});
   }
   function setMountParks(nMaxMountParks, eaMountParks)
   {
      this._nMaxMountParks = nMaxMountParks;
      this._eaMountParks = eaMountParks;
      this.dispatchEvent({type:"modelChanged",eventName:"mountParks"});
   }
   function setBoosts(nLP, nBonusDamage, nPods, nPP, nSagesse, nPercepteur, nBoostPoints, eaSpells)
   {
      this._nTaxLP = nLP;
      this._nTaxBonusDamage = nBonusDamage;
      this._nTaxPods = nPods;
      this._nTaxPP = nPP;
      this._nTaxSagesse = nSagesse;
      this._nTaxPercepteur = nPercepteur;
      this._nBoostPoints = nBoostPoints;
      this._eaTaxSpells = eaSpells;
      this.dispatchEvent({type:"modelChanged",eventName:"boosts"});
   }
   function setNoBoosts()
   {
      this.dispatchEvent({type:"modelChanged",eventName:"noboosts"});
   }
   function canBoost(sCharac, nParams)
   {
      var _loc4_ = this.getBoostCostAndCountForCharacteristic(sCharac,nParams).cost;
      if(this._nBoostPoints >= _loc4_ && _loc4_ != undefined)
      {
         return true;
      }
      return false;
   }
   function getBoostCostAndCountForCharacteristic(sCharac, nParams)
   {
      var _loc4_ = this.api.lang.getGuildBoosts(sCharac);
      var _loc5_ = 1;
      var _loc6_ = 1;
      var _loc7_ = 0;
      var _loc8_;
      switch(sCharac)
      {
         case "w":
            _loc7_ = this._nTaxPods;
            break;
         case "p":
            _loc7_ = this._nTaxPP;
            break;
         case "c":
            _loc7_ = this._nTaxPercepteur;
            break;
         case "x":
            _loc7_ = this._nTaxSagesse;
            break;
         case "s":
            _loc8_ = this._eaTaxSpells.findFirstItem("ID",nParams);
            if(_loc8_ != -1)
            {
               _loc7_ = _loc8_.item.level;
            }
      }
      var _loc9_ = this.api.lang.getGuildBoostsMax(sCharac);
      var _loc10_;
      var _loc11_;
      if(_loc7_ < _loc9_)
      {
         _loc10_ = 0;
         while(_loc10_ < _loc4_.length)
         {
            _loc11_ = _loc4_[_loc10_][0];
            if(_loc7_ < _loc11_)
            {
               break;
            }
            _loc5_ = _loc4_[_loc10_][1];
            _loc6_ = _loc4_[_loc10_][2] != undefined ? _loc4_[_loc10_][2] : 1;
            _loc10_ = _loc10_ + 1;
         }
         return {cost:_loc5_,count:_loc6_};
      }
      return null;
   }
   function setTaxCollectors()
   {
      this.dispatchEvent({type:"modelChanged",eventName:"taxcollectors"});
   }
   function setNoTaxCollectors()
   {
      this.dispatchEvent({type:"modelChanged",eventName:"notaxcollectors"});
   }
   function setHouses(eaHouses)
   {
      this._eaHouses = eaHouses;
      this.dispatchEvent({type:"modelChanged",eventName:"houses"});
   }
   function setNoHouses()
   {
      this._eaHouses = new ank.utils.ExtendedArray();
      this.dispatchEvent({type:"modelChanged",eventName:"nohouses"});
   }
   function setRankName(nID, sRankName)
   {
      this._oRanksName.setRankCustomName(nID,sRankName);
      this.dispatchEvent({type:"modelChanged",eventName:"rank"});
   }
   function resetRankName(nID)
   {
      if(nID == -1)
      {
         this._oRanksName.resetAllRankCustomName();
      }
      else
      {
         this._oRanksName.resetRankCustomName(nID);
      }
      this.dispatchEvent({type:"modelChanged",eventName:"rank"});
   }
   function getRankName(nID)
   {
      return this._oRanksName.getRankName(nID);
   }
   function formatDate(date)
   {
      var _loc3_ = (date.getDate() < 10 ? "0" : "") + date.getDate();
      var _loc4_ = (date.getMonth() + 1 < 10 ? "0" : "") + (date.getMonth() + 1);
      var _loc5_ = (date.getHours() < 10 ? "0" : "") + date.getHours();
      var _loc6_ = (date.getMinutes() < 10 ? "0" : "") + date.getMinutes();
      return _loc3_ + "." + _loc4_ + "." + date.getFullYear() + " " + _loc5_ + ":" + _loc6_;
   }
}
