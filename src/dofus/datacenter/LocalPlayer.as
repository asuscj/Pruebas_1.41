class dofus.datacenter.LocalPlayer extends dofus.utils.ApiElement
{
   var Emotes;
   var InteractionsManager;
   var Inventory;
   var InventoryByItemPositions;
   var InventoryShortcuts;
   var ItemSets;
   var Jobs;
   var RapidStuffs;
   var Spells;
   var SpellsDecks;
   var SpellsManager;
   var _aFullStats;
   var _agility;
   var _bCraftPublicMode;
   var _bInParty;
   var _huntMatchmakingStatus;
   var _intelligence;
   var _nAP;
   var _nAgilityTotal;
   var _nAgilityXtra;
   var _nBonusPoints;
   var _nBonusPointsSpell;
   var _nChance;
   var _nChanceXtra;
   var _nColor1;
   var _nColor2;
   var _nColor3;
   var _nCriticalHitBonus;
   var _nCurrentJobID;
   var _nCurrentOverWeight;
   var _nCurrentWeight;
   var _nDiscernment;
   var _nEnergy;
   var _nEnergyMax;
   var _nForce;
   var _nForceXtra;
   var _nGuild;
   var _nInitiative;
   var _nIntelligenceXtra;
   var _nKama;
   var _nLP;
   var _nLPMax;
   var _nLevel;
   var _nMP;
   var _nMaxOverWeight;
   var _nMaxSummonedCreatures;
   var _nMaxWeight;
   var _nMountXPPercent;
   var _nRangeModerator;
   var _nRestrictions;
   var _nSex;
   var _nShowedLevel;
   var _nVitality;
   var _nVitalityXtra;
   var _nWisdom;
   var _nWisdomXtra;
   var _nXP;
   var _nXPHigh;
   var _nXPLow;
   var _oAlignment;
   var _oFakeAlignment;
   var _oMount;
   var _oQuestBook;
   var _oRank;
   var _oSpecialization;
   var _oSpriteData;
   var _oWeaponItem;
   var _sID;
   var _sName;
   var api;
   var currentUseObject;
   var dispatchEvent;
   var modReportSessionData;
   var spellIDByLevelID;
   var summonedCreaturesID;
   var ttgCollection;
   var isAuthorized = false;
   var isSkippingFightAnimations = false;
   var isSkippingLootPanel = false;
   static var MAX_RAPID_STUFFS_COUNT = 10;
   static var MAX_SPELLS_DECKS_COUNT = 10;
   var haveFakeAlignment = false;
   var currentSpellsDeckID = 0;
   var _nSummonedCreatures = 0;
   var _bIsRiding = false;
   var _bIsDead = false;
   var _nMoveStat = 0;
   var _nGatherStat = 0;
   function LocalPlayer(oAPI)
   {
      super();
      this.initialize(oAPI);
   }
   function initialize(oAPI)
   {
      super.initialize(oAPI);
      mx.events.EventDispatcher.initialize(this);
      this.clean();
      mx.events.EventDispatcher.initialize(this);
   }
   function clean()
   {
      this.SpellsManager = new dofus.managers.SpellsManager(this);
      this.InteractionsManager = new dofus.managers.InteractionsManager(this,this.api);
      this.Inventory = new ank.utils.ExtendedArray();
      this.InventoryByItemPositions = new ank.utils.ExtendedObject();
      this.InventoryShortcuts = new ank.utils.ExtendedObject();
      if(this.modReportSessionData == undefined)
      {
         this.modReportSessionData = new dofus.datacenter.ModReportSessionData();
      }
      this.modReportSessionData.initialize();
      this.ItemSets = new ank.utils.ExtendedObject();
      this.Jobs = new ank.utils.ExtendedArray();
      this.Spells = new ank.utils.ExtendedArray();
      this.Emotes = new ank.utils.ExtendedObject();
      this.ttgCollection = undefined;
      this.resetRapidStuffs();
      this.resetSpellsDecks();
      this.clearSummon();
      this._bCraftPublicMode = false;
      this._bInParty = false;
   }
   function clearSummon()
   {
      this._nSummonedCreatures = 0;
      this._nMaxSummonedCreatures = 1;
      this.summonedCreaturesID = {};
   }
   function get clip()
   {
      return this._oSpriteData.mc;
   }
   function get data()
   {
      return this._oSpriteData;
   }
   function set data(oSpriteData)
   {
      this._oSpriteData = oSpriteData;
      this.dispatchEvent({type:"spriteDataChanged",value:oSpriteData});
   }
   function get isCurrentPlayer()
   {
      return this.api.datacenter.Game.currentPlayerID == this._sID;
   }
   function get questBook()
   {
      return this._oQuestBook;
   }
   function set questBook(oQuestBook)
   {
      this._oQuestBook = oQuestBook;
   }
   function set ID(value)
   {
      this._sID = value;
   }
   function get ID()
   {
      return this._sID;
   }
   function set Name(value)
   {
      this._sName = String(value);
      this.dispatchEvent({type:"nameChanged",value:value});
   }
   function get Name()
   {
      return this._sName;
   }
   function set Guild(value)
   {
      this._nGuild = Number(value);
   }
   function get Guild()
   {
      return this._nGuild;
   }
   function set Level(value)
   {
      this._nLevel = Number(value);
      this.dispatchEvent({type:"levelChanged",value:value});
   }
   function get Level()
   {
      return this._nLevel;
   }
   function set ShowedLevel(value)
   {
      this._nShowedLevel = Number(value);
      this.dispatchEvent({type:"levelChanged",value:value});
   }
   function get ShowedLevel()
   {
      return !(this._nShowedLevel == undefined || this._nShowedLevel == -1) ? this._nShowedLevel : this.Level;
   }
   function set Sex(value)
   {
      this._nSex = Number(value);
   }
   function get Sex()
   {
      return this._nSex;
   }
   function set color1(value)
   {
      this._nColor1 = Number(value);
   }
   function get color1()
   {
      return this._nColor1;
   }
   function set color2(value)
   {
      this._nColor2 = Number(value);
   }
   function get color2()
   {
      return this._nColor2;
   }
   function set color3(value)
   {
      this._nColor3 = Number(value);
   }
   function get color3()
   {
      return this._nColor3;
   }
   function set LP(value)
   {
      this._nLP = Number(value) <= 0 ? 0 : Number(value);
      this.dispatchEvent({type:"lpChanged",value:value,id:this.ID});
   }
   function get LP()
   {
      return this._nLP;
   }
   function set LPmax(value)
   {
      this._nLPMax = Number(value);
      this.dispatchEvent({type:"lpMaxChanged",value:value});
   }
   function get LPmax()
   {
      return this._nLPMax;
   }
   function set AP(value)
   {
      this._nAP = Number(value);
      this.data.AP = Number(value);
      this.dispatchEvent({type:"apChanged",value:value,id:this.ID});
   }
   function get AP()
   {
      return this._nAP;
   }
   function set MP(value)
   {
      this._nMP = Number(value);
      this.data.MP = Number(value);
      this.dispatchEvent({type:"mpChanged",value:value,id:this.ID});
   }
   function get MP()
   {
      return this._nMP;
   }
   function set Kama(value)
   {
      this._nKama = Number(value);
      this.dispatchEvent({type:"kamaChanged",value:value});
   }
   function get Kama()
   {
      return this._nKama;
   }
   function set XPlow(value)
   {
      this._nXPLow = Number(value);
   }
   function get XPlow()
   {
      return this._nXPLow;
   }
   function set XP(value)
   {
      this._nXP = Number(value);
      this.dispatchEvent({type:"xpChanged",value:value});
   }
   function get XP()
   {
      return this._nXP;
   }
   function set XPhigh(value)
   {
      this._nXPHigh = Number(value);
   }
   function get XPhigh()
   {
      return this._nXPHigh;
   }
   function set Initiative(value)
   {
      this._nInitiative = Number(value);
      this.dispatchEvent({type:"initiativeChanged",value:value});
   }
   function get Initiative()
   {
      return this._nInitiative;
   }
   function set Discernment(value)
   {
      this._nDiscernment = Number(value);
      this.dispatchEvent({type:"discernmentChanged",value:value});
   }
   function get Discernment()
   {
      return this._nDiscernment;
   }
   function set Force(value)
   {
      this._nForce = Number(value);
      this.dispatchEvent({type:"forceChanged",value:value});
   }
   function get Force()
   {
      return this._nForce;
   }
   function set ForceXtra(value)
   {
      this._nForceXtra = Number(value);
      this.dispatchEvent({type:"forceXtraChanged",value:value});
   }
   function get ForceXtra()
   {
      return this._nForceXtra;
   }
   function set Vitality(value)
   {
      this._nVitality = Number(value);
      this.dispatchEvent({type:"vitalityChanged",value:value});
   }
   function get Vitality()
   {
      return this._nVitality;
   }
   function set VitalityXtra(value)
   {
      this._nVitalityXtra = Number(value);
      this.dispatchEvent({type:"vitalityXtraChanged",value:value});
   }
   function get VitalityXtra()
   {
      return this._nVitalityXtra;
   }
   function set Wisdom(value)
   {
      this._nWisdom = Number(value);
      this.dispatchEvent({type:"wisdomChanged",value:value});
   }
   function get Wisdom()
   {
      return this._nWisdom;
   }
   function set WisdomXtra(value)
   {
      this._nWisdomXtra = Number(value);
      this.dispatchEvent({type:"wisdomXtraChanged",value:value});
   }
   function get WisdomXtra()
   {
      return this._nWisdomXtra;
   }
   function set Chance(value)
   {
      this._nChance = Number(value);
      this.dispatchEvent({type:"chanceChanged",value:value});
   }
   function get Chance()
   {
      return this._nChance;
   }
   function set ChanceXtra(value)
   {
      this._nChanceXtra = Number(value);
      this.dispatchEvent({type:"chanceXtraChanged",value:value});
   }
   function get ChanceXtra()
   {
      return this._nChanceXtra;
   }
   function set Agility(value)
   {
      this._agility = Number(value);
      this.dispatchEvent({type:"agilityChanged",value:value});
   }
   function get Agility()
   {
      return this._agility;
   }
   function set AgilityXtra(value)
   {
      this._nAgilityXtra = Number(value);
      this.dispatchEvent({type:"agilityXtraChanged",value:value});
   }
   function get AgilityXtra()
   {
      return this._nAgilityXtra;
   }
   function set AgilityTotal(value)
   {
      this._nAgilityTotal = Number(value);
      this.dispatchEvent({type:"agilityTotalChanged",value:value});
   }
   function get AgilityTotal()
   {
      return this._nAgilityTotal;
   }
   function set Intelligence(value)
   {
      this._intelligence = Number(value);
      this.dispatchEvent({type:"intelligenceChanged",value:value});
   }
   function get Intelligence()
   {
      return this._intelligence;
   }
   function set IntelligenceXtra(value)
   {
      this._nIntelligenceXtra = Number(value);
      this.dispatchEvent({type:"intelligenceXtraChanged",value:value});
   }
   function get IntelligenceXtra()
   {
      return this._nIntelligenceXtra;
   }
   function set BonusPoints(value)
   {
      this._nBonusPoints = Number(value);
      this.dispatchEvent({type:"bonusPointsChanged",value:value});
   }
   function get BonusPoints()
   {
      return this._nBonusPoints;
   }
   function set BonusPointsSpell(value)
   {
      this._nBonusPointsSpell = Number(value);
      this.dispatchEvent({type:"bonusSpellsChanged",value:value});
   }
   function get BonusPointsSpell()
   {
      return this._nBonusPointsSpell;
   }
   function set RangeModerator(value)
   {
      this._nRangeModerator = Number(value);
   }
   function get RangeModerator()
   {
      return this._nRangeModerator;
   }
   function set Energy(value)
   {
      this._nEnergy = Number(value);
      this.dispatchEvent({type:"energyChanged",value:value});
   }
   function get Energy()
   {
      return this._nEnergy;
   }
   function set EnergyMax(value)
   {
      this._nEnergyMax = Number(value);
      this.dispatchEvent({type:"energyMaxChanged",value:value});
   }
   function get EnergyMax()
   {
      return this._nEnergyMax;
   }
   function set SummonedCreatures(value)
   {
      this._nSummonedCreatures = Number(value);
   }
   function get SummonedCreatures()
   {
      return this._nSummonedCreatures;
   }
   function set MaxSummonedCreatures(value)
   {
      this._nMaxSummonedCreatures = Number(value);
   }
   function get MaxSummonedCreatures()
   {
      return this._nMaxSummonedCreatures;
   }
   function set CriticalHitBonus(value)
   {
      this._nCriticalHitBonus = Number(value);
   }
   function get CriticalHitBonus()
   {
      return this._nCriticalHitBonus;
   }
   function get weaponItem()
   {
      return this._oWeaponItem;
   }
   function set FullStats(value)
   {
      this._aFullStats = value;
      this.dispatchEvent({type:"fullStatsChanged",value:value});
   }
   function get FullStats()
   {
      return this._aFullStats;
   }
   function set isDead(bDead)
   {
      this._bIsDead = bDead;
   }
   function get isDead()
   {
      return this._bIsDead;
   }
   function set currentJobID(value)
   {
      if(value == undefined)
      {
         delete this._nCurrentJobID;
      }
      else
      {
         this._nCurrentJobID = Number(value);
      }
      this.dispatchEvent({type:"currentJobChanged",value:value});
   }
   function get currentJobID()
   {
      return this._nCurrentJobID;
   }
   function get currentJob()
   {
      var _loc2_ = this.Jobs.findFirstItem("id",this._nCurrentJobID);
      return _loc2_.item;
   }
   function set currentWeight(value)
   {
      this._nCurrentWeight = value;
      this._nCurrentOverWeight = this._nCurrentWeight - this._nMaxWeight;
      this.dispatchEvent({type:"currentWeightChanged",value:value});
   }
   function get currentWeight()
   {
      return this._nCurrentWeight;
   }
   function get currentOverWeight()
   {
      return this._nCurrentOverWeight;
   }
   function set maxWeight(value)
   {
      this._nMaxWeight = value;
      this.dispatchEvent({type:"maxWeightChanged",value:value});
   }
   function get maxWeight()
   {
      return this._nMaxWeight;
   }
   function set maxOverWeight(value)
   {
      this._nMaxOverWeight = value;
      this.dispatchEvent({type:"maxOverWeightChanged",value:value});
   }
   function get maxOverWeight()
   {
      return this._nMaxOverWeight;
   }
   function get isMutant()
   {
      return this.data instanceof dofus.datacenter.Mutant;
   }
   function set restrictions(value)
   {
      this._nRestrictions = value;
   }
   function get restrictions()
   {
      return this._nRestrictions;
   }
   function set specialization(value)
   {
      this._oSpecialization = value;
      this.dispatchEvent({type:"specializationChanged",value:value});
   }
   function get specialization()
   {
      return this._oSpecialization;
   }
   function set alignment(value)
   {
      this._oAlignment = value;
      this.dispatchEvent({type:"alignmentChanged",alignment:value});
   }
   function get alignment()
   {
      return this._oAlignment;
   }
   function set fakeAlignment(value)
   {
      this._oFakeAlignment = value;
   }
   function get fakeAlignment()
   {
      return this._oFakeAlignment;
   }
   function set rank(value)
   {
      this._oRank = value;
      this.dispatchEvent({type:"rankChanged",rank:value});
   }
   function get rank()
   {
      return this._oRank;
   }
   function set mount(value)
   {
      this._oMount = value;
      this.dispatchEvent({type:"mountChanged",mount:value});
   }
   function get mount()
   {
      return this._oMount;
   }
   function get isRiding()
   {
      return this._bIsRiding;
   }
   function set isRiding(value)
   {
      this._bIsRiding = value;
   }
   function set mountXPPercent(value)
   {
      this._nMountXPPercent = value;
      this.dispatchEvent({type:"mountXPPercentChanged",value:value});
   }
   function get mountXPPercent()
   {
      return this._nMountXPPercent;
   }
   function set craftPublicMode(value)
   {
      this._bCraftPublicMode = value;
      this.dispatchEvent({type:"craftPublicModeChanged",value:value});
   }
   function get craftPublicMode()
   {
      return this._bCraftPublicMode;
   }
   function set inParty(value)
   {
      this._bInParty = value;
      this.dispatchEvent({type:"inPartyChanged",inParty:value});
   }
   function get inParty()
   {
      return this._bInParty;
   }
   function set huntMatchmakingStatus(value)
   {
      this._huntMatchmakingStatus = value;
      this.dispatchEvent({type:"huntMatchmakingStatusChanged",status:value});
   }
   function get huntMatchmakingStatus()
   {
      return this._huntMatchmakingStatus;
   }
   function get canAssault()
   {
      return (this._nRestrictions & 1) != 1;
   }
   function get canChallenge()
   {
      return (this._nRestrictions & 2) != 2;
   }
   function get canExchange()
   {
      return (this._nRestrictions & 4) != 4;
   }
   function get canAttack()
   {
      return (this._nRestrictions & 8) == 8;
   }
   function get canChatToAll()
   {
      return (this._nRestrictions & 0x10) != 16;
   }
   function get canBeMerchant()
   {
      return (this._nRestrictions & 0x20) != 32;
   }
   function get canUseObject()
   {
      return (this._nRestrictions & 0x40) != 64;
   }
   function get cantInteractWithTaxCollector()
   {
      return (this._nRestrictions & 0x80) == 128;
   }
   function get canUseInteractiveObjects()
   {
      return (this._nRestrictions & 0x0100) != 256;
   }
   function get cantSpeakNPC()
   {
      return (this._nRestrictions & 0x0200) == 512;
   }
   function get canAttackDungeonMonstersWhenMutant()
   {
      return (this._nRestrictions & 0x1000) == 4096;
   }
   function get canMoveInAllDirections()
   {
      return (this._nRestrictions & 0x2000) == 8192;
   }
   function get canAttackMonstersAnywhereWhenMutant()
   {
      return (this._nRestrictions & 0x4000) == 16384;
   }
   function get cantInteractWithPrism()
   {
      return (this._nRestrictions & 0x8000) == 32768;
   }
   function getSpellsDeck(nID)
   {
      return dofus.datacenter.spellscollection.SpellsDeck(this.SpellsDecks.getItemAt(nID));
   }
   function putSpellsDeck(nID, oSpellsDeck)
   {
      this.SpellsDecks.addItemAt(nID,oSpellsDeck);
      this.dispatchEvent({type:"spellsDeckPut",value:oSpellsDeck});
   }
   function resetSpellsDecks()
   {
      this.SpellsDecks = new ank.utils.ExtendedObject();
      var _loc2_ = 0;
      var _loc3_;
      while(_loc2_ < dofus.datacenter.LocalPlayer.MAX_SPELLS_DECKS_COUNT)
      {
         _loc3_ = dofus.datacenter.spellscollection.SpellsDeck.createEmptySpellsDeck(_loc2_);
         this.SpellsDecks.addItemAt(_loc2_,_loc3_);
         _loc2_ = _loc2_ + 1;
      }
   }
   function getRapidStuff(nID)
   {
      return dofus.datacenter.RapidStuff(this.RapidStuffs.getItemAt(nID));
   }
   function putRapidStuff(nID, oRapidStuff)
   {
      this.RapidStuffs.addItemAt(nID,oRapidStuff);
      this.dispatchEvent({type:"rapidStuffPut",value:oRapidStuff});
   }
   function resetRapidStuffs()
   {
      this.RapidStuffs = new ank.utils.ExtendedObject();
      var _loc2_ = 0;
      var _loc3_;
      while(_loc2_ < dofus.datacenter.LocalPlayer.MAX_RAPID_STUFFS_COUNT)
      {
         _loc3_ = dofus.datacenter.RapidStuff.createEmptyRapidStuff(_loc2_);
         this.RapidStuffs.addItemAt(_loc2_,_loc3_);
         _loc2_ = _loc2_ + 1;
      }
   }
   function isHuntMatchmakingActive()
   {
      return this._huntMatchmakingStatus != undefined && this._huntMatchmakingStatus.isActive;
   }
   function reset()
   {
      this.currentUseObject = null;
   }
   function canReceiveItems(aItems, bMount)
   {
      var _loc4_ = !bMount ? this.maxWeight - this.currentWeight : this.mount.podsMax - this.mount.pods;
      var _loc5_ = 0;
      var _loc6_ = 0;
      var _loc7_;
      while(_loc6_ < aItems.length)
      {
         _loc7_ = aItems[_loc6_];
         _loc5_ += _loc7_.weight * _loc7_.Quantity;
         _loc6_ = _loc6_ + 1;
      }
      return _loc5_ <= _loc4_;
   }
   function getPossibleItemReceiveQuantity(oRemoteInventoryItem, bMount)
   {
      var _loc4_ = !bMount ? this.maxWeight - this.currentWeight : this.mount.podsMax - this.mount.pods;
      var _loc5_ = oRemoteInventoryItem.weight;
      var _loc6_ = Math.floor(_loc4_ / _loc5_);
      if(_loc6_ > oRemoteInventoryItem.Quantity)
      {
         _loc6_ = oRemoteInventoryItem.Quantity;
      }
      return _loc6_;
   }
   function updateLP(dLP)
   {
      dLP = Number(dLP);
      if(this.LP + dLP > this.LPmax)
      {
         dLP = this.LPmax - this.LP;
      }
      this.LP += dLP;
   }
   function hasEnoughAP(wantedAP)
   {
      return this.data.AP >= wantedAP;
   }
   function addItem(oItem)
   {
      if(oItem.position == 1)
      {
         this.setWeaponItem(oItem);
      }
      this.Inventory.startNoEventDispatchsPeriod(dofus.Constants.DELAYED_INVENTORY_ITEMS_VISUAL_REFRESH);
      this.Inventory.push(oItem);
      if(oItem.isEquiped)
      {
         this.InventoryByItemPositions.addItemAt(oItem.position,oItem);
      }
      if(oItem.unicID == dofus.graphics.gapi.controls.temporis.TemporisGeneral.TEMPOTON_ID)
      {
         this.dispatchEvent({type:"tempotonsChanged"});
      }
   }
   function checkCanMoveItem()
   {
      var _loc2_ = this.api.datacenter.Game.isRunning;
      var _loc3_ = this.api.datacenter.Exchange != undefined;
      var _loc4_ = this.api.datacenter.Map.bCanEquipItem;
      var _loc5_ = this.api.datacenter.Map.bCanUseItem;
      if(_loc2_ || (_loc3_ || (!_loc4_ || !_loc5_)))
      {
         this.api.ui.loadUIComponent("AskOk","AskOkInventory",{title:this.api.lang.getText("INFORMATIONS"),text:this.api.lang.getText("CANT_MOVE_ITEM")});
      }
      return !(_loc2_ || (_loc3_ || (!_loc4_ || !_loc5_)));
   }
   function updateItem(oNewItem)
   {
      var _loc3_ = this.Inventory.findFirstItem("ID",oNewItem.ID);
      var _loc4_ = _loc3_.item;
      if(_loc4_.ID == oNewItem.ID && _loc4_.maxSkin != oNewItem.maxSkin)
      {
         if(!_loc4_.isLeavingItem && oNewItem.isLeavingItem)
         {
            this.api.kernel.SpeakingItemsManager.triggerPrivateEvent(dofus.managers.SpeakingItemsManager.SPEAK_TRIGGER_ASSOCIATE);
         }
         if(_loc4_.isLeavingItem && oNewItem.isLeavingItem)
         {
            this.api.kernel.SpeakingItemsManager.triggerPrivateEvent(dofus.managers.SpeakingItemsManager.SPEAK_TRIGGER_LEVEL_UP);
         }
      }
      if(_loc4_ != undefined && _loc4_.isEquiped)
      {
         this.InventoryByItemPositions.removeItemAt(_loc4_.position);
      }
      this.Inventory.startNoEventDispatchsPeriod(dofus.Constants.DELAYED_INVENTORY_ITEMS_VISUAL_REFRESH);
      this.Inventory.updateItem(_loc3_.index,oNewItem);
      if(oNewItem.isEquiped)
      {
         this.InventoryByItemPositions.addItemAt(oNewItem.position,oNewItem);
      }
   }
   function updateItemQuantity(nItemNum, nQuantity)
   {
      var _loc4_ = this.Inventory.findFirstItem("ID",nItemNum);
      var _loc5_ = _loc4_.item;
      _loc5_.Quantity = nQuantity;
      this.Inventory.startNoEventDispatchsPeriod(dofus.Constants.DELAYED_INVENTORY_ITEMS_VISUAL_REFRESH);
      this.Inventory.updateItem(_loc4_.index,_loc5_);
      if(_loc5_.unicID == dofus.graphics.gapi.controls.temporis.TemporisGeneral.TEMPOTON_ID)
      {
         this.dispatchEvent({type:"tempotonsChanged"});
      }
   }
   function updateItemPosition(nItemNum, nPosition)
   {
      var _loc4_ = this.Inventory.findFirstItem("ID",nItemNum);
      var _loc5_ = _loc4_.item;
      if(_loc5_.position == 1)
      {
         this.setWeaponItem();
      }
      else if(nPosition == 1)
      {
         this.setWeaponItem(_loc5_);
      }
      if(_loc5_.isEquiped)
      {
         this.InventoryByItemPositions.removeItemAt(_loc5_.position);
      }
      _loc5_.position = nPosition;
      this.Inventory.startNoEventDispatchsPeriod(dofus.Constants.DELAYED_INVENTORY_ITEMS_VISUAL_REFRESH);
      this.Inventory.removeItems(_loc4_.index,1);
      this.Inventory.push(_loc5_);
      if(_loc5_.isEquiped)
      {
         this.InventoryByItemPositions.addItemAt(_loc5_.position,_loc5_);
      }
   }
   function getInventoryItemQuantityByUnicID(nUnicID)
   {
      var _loc3_ = dofus.datacenter.Item(this.Inventory.findFirstItem("unicID",nUnicID).item);
      if(_loc3_ == undefined)
      {
         return 0;
      }
      return _loc3_.Quantity;
   }
   function dropItem(nItemNum)
   {
      var _loc3_ = this.Inventory.findFirstItem("ID",nItemNum);
      var _loc4_ = _loc3_.item;
      if(_loc4_ == undefined)
      {
         return undefined;
      }
      _loc4_.isRemovedFromInventory = true;
      if(_loc4_.position == 1)
      {
         this.setWeaponItem();
      }
      this.Inventory.startNoEventDispatchsPeriod(dofus.Constants.DELAYED_INVENTORY_ITEMS_VISUAL_REFRESH);
      this.Inventory.removeItems(_loc3_.index,1);
      if(_loc4_.isEquiped)
      {
         this.InventoryByItemPositions.removeItemAt(_loc4_.position);
      }
   }
   function getOwnedSpell(nSpell)
   {
      var _loc3_ = this.Spells.findFirstItem("ID",nSpell);
      var _loc4_;
      if(_loc3_.index != -1)
      {
         _loc4_ = _loc3_.item;
         return _loc4_;
      }
      return undefined;
   }
   function getOwnedSpellLevel(nSpell)
   {
      var _loc3_ = this.Spells.findFirstItem("ID",nSpell);
      var _loc4_;
      if(_loc3_.index != -1)
      {
         _loc4_ = _loc3_.item;
         return _loc4_.level;
      }
      return -1;
   }
   function getSpellIDFromLevelID(nLevelID)
   {
      if(this.spellIDByLevelID == undefined)
      {
         this.initSpellsDictionnary();
      }
      return this.spellIDByLevelID[nLevelID];
   }
   function initSpellsDictionnary()
   {
      this.spellIDByLevelID = {};
      var _loc2_ = this.api.lang.getSpells();
      var _loc3_;
      var _loc4_;
      var _loc5_;
      var _loc6_;
      for(var i in _loc2_)
      {
         _loc3_ = _loc2_[i];
         _loc4_ = 1;
         while(_loc4_ <= 6)
         {
            _loc5_ = _loc3_["l" + _loc4_];
            if(_loc5_ != undefined)
            {
               _loc6_ = _loc5_[20];
               this.spellIDByLevelID[_loc6_] = i;
            }
            _loc4_ = _loc4_ + 1;
         }
      }
   }
   function isSpellOwned(nSpell)
   {
      return this.getOwnedSpellLevel(nSpell) > -1;
   }
   function updateSpell(oSpell)
   {
      var _loc3_ = this.Spells.findFirstItem("ID",oSpell.ID);
      if(_loc3_.index != -1)
      {
         oSpell.position = _loc3_.item.position;
         this.Spells.updateItem(_loc3_.index,oSpell);
      }
      else
      {
         this.Spells.push(oSpell);
      }
   }
   function updateSpellPosition(oSpell)
   {
      var _loc3_ = this.Spells.findFirstItem("position",oSpell.position);
      var _loc4_ = this.Spells.findFirstItem("ID",oSpell.ID);
      if(_loc3_.index != -1)
      {
         _loc3_.item.position = undefined;
         this.Spells.updateItem(_loc3_.index,oSpell);
      }
      if(_loc4_.index != -1)
      {
         this.Spells.updateItem(_loc3_.index,oSpell);
      }
      else
      {
         this.Spells.push(oSpell);
      }
   }
   function removeSpell(nID)
   {
      var _loc3_ = this.Spells.findFirstItem("ID",nID);
      if(_loc3_.index != -1)
      {
         this.Spells.removeItems(_loc3_.index,1);
      }
   }
   function canBoost(nCharacID)
   {
      if(this.api.datacenter.Game.isRunning)
      {
         return false;
      }
      var _loc3_ = this.getBoostCostAndCountForCharacteristic(nCharacID).cost;
      if(this._nBonusPoints >= _loc3_)
      {
         return true;
      }
      return false;
   }
   function getStatDetail(nCharacID)
   {
      var _loc3_ = 0;
      switch(nCharacID)
      {
         case 10:
            _loc3_ = 11;
            break;
         case 11:
            _loc3_ = 12;
            break;
         case 12:
            _loc3_ = 13;
            break;
         case 13:
            _loc3_ = 14;
            break;
         case 14:
            _loc3_ = 15;
            break;
         case 15:
            _loc3_ = 16;
      }
      var _loc4_ = 0;
      while(_loc4_ < this.FullStats[0].length)
      {
         if(this.FullStats[0][_loc4_].id == _loc3_)
         {
            return this.FullStats[0][_loc4_];
         }
         _loc4_ = _loc4_ + 1;
      }
      return {};
   }
   function getCharacValueByID(nCharacID)
   {
      var _loc3_ = 0;
      switch(nCharacID)
      {
         case 10:
            _loc3_ = this._nForce;
            break;
         case 11:
            _loc3_ = this._nVitality;
            break;
         case 12:
            _loc3_ = this._nWisdom;
            break;
         case 13:
            _loc3_ = this._nChance;
            break;
         case 14:
            _loc3_ = this._agility;
            break;
         case 15:
            _loc3_ = this._intelligence;
      }
      return _loc3_;
   }
   function getBoostCostAndCountForCharacteristic(nCharacID)
   {
      var _loc3_ = this.api.lang.getClassText(this._nGuild)["b" + nCharacID];
      var _loc4_ = 1;
      var _loc5_ = 1;
      var _loc6_ = this.getCharacValueByID(nCharacID);
      var _loc7_;
      var _loc8_;
      if(this.api.datacenter.Basics.aks_current_server.isTemporis())
      {
         _loc8_ = this.api.datacenter.Player.getStatDetail(nCharacID);
         _loc6_ -= _loc8_.a;
      }
      var _loc10_ = 0;
      var _loc9_;
      while(_loc10_ < _loc3_.length)
      {
         _loc9_ = _loc3_[_loc10_][0];
         if(_loc6_ < _loc9_)
         {
            break;
         }
         _loc4_ = _loc3_[_loc10_][1];
         _loc5_ = _loc3_[_loc10_][2] != undefined ? _loc3_[_loc10_][2] : 1;
         _loc10_ = _loc10_ + 1;
      }
      var _loc11_ = _loc10_ == _loc3_.length;
      var _loc12_;
      var _loc13_;
      if(_loc11_)
      {
         _loc7_ = Math.floor(this._nBonusPoints / _loc4_);
      }
      else
      {
         _loc7_ = 0;
         _loc12_ = _loc6_;
         _loc13_ = this._nBonusPoints;
         while(_loc12_ < _loc9_ && _loc13_ >= _loc4_)
         {
            _loc12_ += _loc5_;
            _loc13_ -= _loc4_;
            _loc7_ = _loc7_ + 1;
         }
      }
      return {cost:_loc4_,count:_loc5_,possibleCount:_loc7_};
   }
   function getWeightText()
   {
      var _loc2_ = new ank.utils.ExtendedString(this._nCurrentWeight).addMiddleChar(" ",3);
      var _loc3_ = new ank.utils.ExtendedString(this._nMaxWeight).addMiddleChar(" ",3);
      var _loc4_ = new ank.utils.ExtendedString(this._nCurrentOverWeight).addMiddleChar(" ",3);
      var _loc5_ = new ank.utils.ExtendedString(this._nMaxOverWeight).addMiddleChar(" ",3);
      var _loc6_ = this.api.lang.getText("PLAYER_WEIGHT",[_loc2_,_loc3_]);
      if(this._nCurrentOverWeight > 0)
      {
         _loc6_ += "\n" + this.api.lang.getText("OVERWEIGHT") + " : " + this.api.lang.getText("PLAYER_WEIGHT",[_loc4_,_loc5_]);
      }
      return _loc6_;
   }
   function clearEmotes()
   {
      this.Emotes = new ank.utils.ExtendedObject();
   }
   function addEmote(nEmoteID)
   {
      this.Emotes.addItemAt(nEmoteID,true);
   }
   function hasEmote(nEmoteID)
   {
      return this.Emotes.getItemAt(nEmoteID) == true;
   }
   function updateCloseCombat()
   {
      this.Spells[0] = new dofus.datacenter.CloseCombat(this._oWeaponItem,this._nGuild);
   }
   function setWeaponItem(oItem)
   {
      this._oWeaponItem = oItem;
      this.updateCloseCombat();
   }
}
