class ank.battlefield.SpriteHandler
{
   var _bAllSpritesMasked;
   var _mcBattlefield;
   var _mcContainer;
   var _oSprites;
   var api;
   var onEnterFrame;
   var updateCarriedPosition;
   static var DEFAULT_RUNLINIT = 6;
   static var _bPlayerSpritesHidden = false;
   static var _bShowMonstersTooltip = false;
   function SpriteHandler(b, c, d)
   {
      this.initialize(b,c,d);
   }
   function get isShowingMonstersTooltip()
   {
      return ank.battlefield.SpriteHandler._bShowMonstersTooltip;
   }
   function get isPlayerSpritesHidden()
   {
      return ank.battlefield.SpriteHandler._bPlayerSpritesHidden;
   }
   function initialize(b, c, d)
   {
      this._mcBattlefield = b;
      this._oSprites = d;
      this._mcContainer = c;
      this.api = _global.API;
   }
   function clear(bKeepData)
   {
      var _loc3_ = this._oSprites.getItems();
      for(var k in _loc3_)
      {
         this.removeSprite(k,bKeepData);
      }
   }
   function getSprites()
   {
      return this._oSprites;
   }
   function getSprite(sID)
   {
      return this._oSprites.getItemAt(sID);
   }
   function getSpriteMc(sID)
   {
      return this._mcContainer["sprite" + sID];
   }
   function addSprite(sID, oSprite)
   {
      var _loc4_ = true;
      if(oSprite == undefined)
      {
         _loc4_ = false;
         oSprite = this._oSprites.getItemAt(sID);
      }
      if(oSprite == undefined)
      {
         ank.utils.Logger.err("[addSprite] pas de spriteData");
         return undefined;
      }
      if(_loc4_)
      {
         this._oSprites.addItemAt(sID,oSprite);
      }
      this._mcContainer["sprite" + sID].removeMovieClip();
      var _loc5_ = ank.battlefield.utils.SpriteDepthFinder.getFreeDepthOnCell(this._mcBattlefield.mapHandler,this._oSprites,oSprite.cellNum,oSprite.allowGhostMode && this._mcBattlefield.bGhostView);
      var _loc6_ = this._mcContainer.getInstanceAtDepth(_loc5_);
      oSprite.mc = this._mcContainer.attachClassMovie(oSprite.clipClass,"sprite" + sID,_loc5_,[this._mcBattlefield,this._oSprites,oSprite]);
      oSprite.isHidden = this._bAllSpritesMasked;
      if(oSprite.allowGhostMode && this._mcBattlefield.bGhostView)
      {
         oSprite.mc.setAlpha(ank.battlefield.Constants.GHOSTVIEW_SPRITE_ALPHA);
      }
      if(dofus.Constants.INVADER_AREA)
      {
         if(!(oSprite instanceof dofus.datacenter.MonsterGroup || oSprite instanceof dofus.datacenter.Monster))
         {
            return undefined;
         }
         if(oSprite.gfxFileName == "1219" || oSprite.gfxFileName == "1635")
         {
            return undefined;
         }
         oSprite.mc.filters = [new flash.filters.GlowFilter(16711680,1,6,6,1,1,true,false)];
      }
   }
   function addLinkedSprite(sID, sParentID, nChildIndex, oSprite)
   {
      var _loc6_ = true;
      var _loc7_ = this._oSprites.getItemAt(sParentID);
      if(_loc7_ == undefined)
      {
         ank.utils.Logger.err("[addLinkedSprite] pas de spriteData parent");
         return undefined;
      }
      if(oSprite == undefined)
      {
         _loc6_ = false;
         oSprite = this._oSprites.getItemAt(sID);
      }
      if(oSprite == undefined)
      {
         ank.utils.Logger.err("[addLinkedSprite] pas de spriteData");
         return undefined;
      }
      if(_loc6_)
      {
         this._oSprites.addItemAt(sID,oSprite);
      }
      var _loc8_ = ank.battlefield.utils.Pathfinding.getArroundCellNum(this._mcBattlefield.mapHandler,_loc7_.cellNum,_loc7_.direction,nChildIndex);
      var _loc9_ = this._mcBattlefield.mapHandler.getCellData(_loc8_);
      if(_loc9_.movement > 0 && _loc9_.active)
      {
         oSprite.cellNum = _loc8_;
      }
      else
      {
         oSprite.cellNum = _loc7_.cellNum;
      }
      oSprite.linkedParent = _loc7_;
      oSprite.childIndex = nChildIndex;
      _loc7_.linkedChilds.addItemAt(sID,oSprite);
      this.addSprite(sID);
   }
   function carriedSprite(sID, sParentID)
   {
      var _loc4_ = this._oSprites.getItemAt(sID);
      if(_loc4_ == undefined)
      {
         ank.utils.Logger.err("[carriedSprite] pas de spriteData");
         return undefined;
      }
      var _loc5_ = this._oSprites.getItemAt(sParentID);
      if(_loc5_ == undefined)
      {
         ank.utils.Logger.err("[carriedSprite] pas de spriteData parent");
         return undefined;
      }
      var _loc6_;
      if(!_loc5_.hasCarriedChild())
      {
         this.autoCalculateSpriteDirection(sParentID,_loc4_.cellNum);
         _loc4_.direction = _loc5_.direction;
         _loc4_.carriedParent = _loc5_;
         _loc5_.carriedChild = _loc4_;
         _loc6_ = _loc5_.mc;
         _loc6_.setAnim("carring",false,false);
         _loc6_.onEnterFrame = function()
         {
            this.updateCarriedPosition();
            delete this.onEnterFrame;
         };
         _loc4_.mc.updateMap(_loc5_.cellNum,_loc4_.isVisible);
         _loc4_.mc.setNewCellNum(_loc5_.cellNum);
      }
   }
   function removeEffectsByCasterID(sCasterID)
   {
      if(!this.api.datacenter.Game.isFight || sCasterID == undefined)
      {
         return undefined;
      }
      var _loc3_ = this.getSprites().getItems();
      var _loc4_;
      var _loc5_;
      for(var sID in _loc3_)
      {
         _loc4_ = _loc3_[sID];
         _loc5_ = _loc4_.EffectsManager;
         if(_loc5_ != undefined)
         {
            _loc5_.removeEffectsByCasterID(sCasterID);
         }
      }
   }
   function uncarriedSprite(sID, nCellNum, bWithAnimation, oSeq)
   {
      var oSprite = this._oSprites.getItemAt(sID);
      if(oSprite == undefined)
      {
         ank.utils.Logger.err("[SpriteHandler] (addLinkedSprite) pas de spriteData parent");
         return undefined;
      }
      var _loc6_;
      var _loc7_;
      var _loc8_;
      var _loc9_;
      if(oSprite.hasCarriedParent())
      {
         oSprite.uncarryingSprite = true;
         _loc6_ = oSprite.mc;
         _loc7_ = oSprite.carriedParent;
         _loc8_ = _loc7_.mc;
         _loc9_ = _loc7_.sequencer;
         if(oSeq == undefined)
         {
            oSeq = _loc9_;
         }
         else if(bWithAnimation)
         {
            oSeq.addAction(1,false,this,function(oParent, oSequencer)
            {
               oParent.sequencer = oSequencer;
            }
            ,[_loc7_,oSeq]);
         }
         if(bWithAnimation)
         {
            oSeq.addAction(2,false,this,this.autoCalculateSpriteDirection,[_loc7_.id,nCellNum]);
            oSeq.addAction(3,true,_loc8_,_loc8_.setAnim,["carringEnd",false,false]);
            _loc8_.onEnterFrame = function()
            {
               this.updateCarriedPosition();
               delete this.onEnterFrame;
            };
         }
         oSeq.addAction(4,false,this,function(oChild, oParent)
         {
            oSprite.uncarryingSprite = false;
            oSprite.carriedParent = undefined;
            oParent.carriedChild = undefined;
         }
         ,[oSprite,_loc7_]);
         if(!oSeq.containsAction(_loc6_,_loc6_.setPosition))
         {
            oSeq.addAction(5,false,this,this.setSpritePosition,[oSprite.id,nCellNum]);
         }
         if(!_loc7_.isPendingClearing)
         {
            oSeq.addAction(6,false,_loc8_,_loc8_.setAnim,["static",false,false]);
         }
         if(bWithAnimation)
         {
            oSeq.addAction(7,false,this,function(oParent, oSequencer)
            {
               oParent.sequencer = oSequencer;
            }
            ,[_loc7_,_loc9_]);
         }
      }
   }
   function mountSprite(sID, oMount)
   {
      var _loc4_ = this._oSprites.getItemAt(sID);
      if(_loc4_ == undefined)
      {
         ank.utils.Logger.err("[mountSprite] Sprite " + sID + " inexistant");
         return undefined;
      }
      if(oMount != _loc4_.mount)
      {
         _loc4_.mount = oMount;
         _loc4_.mc.draw();
      }
   }
   function unmountSprite(sID)
   {
      var _loc3_ = this._oSprites.getItemAt(sID);
      if(_loc3_ == undefined)
      {
         ank.utils.Logger.err("[unmountSprite] Sprite " + sID + " inexistant");
         return undefined;
      }
      if(_loc3_.mount != undefined)
      {
         _loc3_.mount = undefined;
         _loc3_.mc.draw();
      }
   }
   function removeSprite(sID, bKeepData)
   {
      this._mcBattlefield.removeSpriteBubble(sID);
      this._mcBattlefield.hideSpriteOverHead(sID);
      if(bKeepData == undefined)
      {
         bKeepData = false;
      }
      var _loc4_ = this._oSprites.getItemAt(sID);
      if(_loc4_.mc != undefined && _loc4_.mc == this.api.gfx.rollOverMcSprite)
      {
         this.api.gfx.onSpriteRollOut(_loc4_.mc);
      }
      var _loc5_;
      if(_loc4_.hasChilds)
      {
         _loc5_ = _loc4_.linkedChilds.getItems();
         for(var k in _loc5_)
         {
            this.removeSprite(_loc5_[k].id,bKeepData);
         }
      }
      if(_loc4_.hasParent && !bKeepData)
      {
         _loc4_.linkedParent.linkedChilds.removeItemAt(sID);
      }
      if(_loc4_.hasCarriedChild())
      {
         _loc4_.carriedChild.carriedParent = undefined;
         _loc4_.carriedChild.mc.setPosition();
      }
      var _loc6_;
      if(_loc4_.hasCarriedParent())
      {
         _loc6_ = _loc4_.carriedParent;
         _loc4_.carriedParent.carriedChild = undefined;
         _loc6_.mc.setAnim("static",false,false);
      }
      this._mcContainer["sprite" + sID].__proto__ = MovieClip.prototype;
      this._mcContainer["sprite" + sID].removeMovieClip();
      this._mcBattlefield.mapHandler.getCellData(_loc4_.cellNum).removeSpriteOnID(_loc4_.id);
      if(!bKeepData)
      {
         this._oSprites.removeItemAt(sID);
      }
   }
   function hideSprite(sID, bHide)
   {
      var _loc4_ = this._oSprites.getItemAt(sID);
      var _loc5_;
      if(_loc4_.hasChilds)
      {
         _loc5_ = _loc4_.linkedChilds.getItems();
         for(var k in _loc5_)
         {
            this.hideSprite(_loc5_[k].id,bHide);
         }
      }
      _loc4_.mc.setVisible(!bHide);
   }
   function unmaskAllSprites()
   {
      this._bAllSpritesMasked = false;
      var _loc2_ = this._oSprites.getItems();
      for(var k in _loc2_)
      {
         _loc2_[k].isHidden = false;
      }
   }
   function maskAllSprites()
   {
      this._bAllSpritesMasked = true;
      var _loc2_ = this._oSprites.getItems();
      for(var k in _loc2_)
      {
         _loc2_[k].isHidden = true;
      }
   }
   function hideSprites(bHide, nType)
   {
      if(this.api.datacenter.Game.isFight)
      {
         return undefined;
      }
      ank.battlefield.SpriteHandler._bPlayerSpritesHidden = bHide != undefined ? bHide : true;
      var _loc5_ = this.getSprites().getItems();
      var _loc6_;
      var _loc7_;
      var _loc8_;
      var _loc4_;
      var _loc9_;
      var _loc10_;
      for(var sID in _loc5_)
      {
         if(sID != this.api.datacenter.Player.ID)
         {
            _loc6_ = _loc5_[sID];
            _loc7_ = _loc6_.mc;
            _loc8_ = _loc7_.data;
            switch(nType)
            {
               case 1:
                  _loc4_ = _loc8_ instanceof dofus.datacenter.Character || (_loc8_ instanceof dofus.datacenter.MonsterGroup || (_loc8_ instanceof dofus.datacenter.OfflineCharacter || _loc8_ instanceof dofus.datacenter.PrismSprite));
                  break;
               case 2:
                  _loc4_ = _loc8_ instanceof dofus.datacenter.NonPlayableCharacter;
                  break;
               case 3:
                  _loc4_ = _loc8_ instanceof dofus.datacenter.MonsterGroup;
                  break;
               case 4:
                  _loc4_ = _loc8_ instanceof dofus.datacenter.Character;
               default:
                  _loc4_ = true;
            }
            if(_loc4_)
            {
               _loc6_.mc.setVisible(!bHide);
               _loc9_ = _loc6_.linkedChilds.getItems();
               for(var sChildID in _loc9_)
               {
                  _loc10_ = _loc9_[sChildID];
                  _loc10_.mc.setVisible(!bHide);
               }
            }
         }
      }
   }
   function setSpriteDirection(sID, nDir)
   {
      if(nDir == undefined)
      {
         return undefined;
      }
      var _loc4_ = this._oSprites.getItemAt(sID);
      if(_loc4_ == undefined)
      {
         ank.utils.Logger.err("[setSpriteDirection] Sprite " + sID + " inexistant");
         return undefined;
      }
      var _loc5_;
      if(_loc4_.hasChilds)
      {
         _loc5_ = _loc4_.linkedChilds.getItems();
         for(var k in _loc5_)
         {
            this.setSpriteDirection(_loc5_[k].id,nDir);
         }
      }
      if(_loc4_.hasCarriedChild())
      {
         _loc4_.carriedChild.mc.setDirection(nDir);
      }
      var _loc6_ = _loc4_.mc;
      _loc6_.setDirection(nDir);
   }
   function setSpritePosition(sID, nCellNum, nDir)
   {
      var _loc5_ = this._oSprites.getItemAt(sID);
      if(_loc5_ == undefined)
      {
         ank.utils.Logger.err("[setSpritePosition] Sprite " + sID + " inexistant");
         return undefined;
      }
      if(_global.isNaN(Number(nCellNum)))
      {
         ank.utils.Logger.err("[setSpritePosition] cellNum n\'est pas un nombre");
         return undefined;
      }
      if(Number(nCellNum) < 0 || Number(nCellNum) > this._mcBattlefield.mapHandler.getCellCount())
      {
         ank.utils.Logger.err("[setSpritePosition] cellNum invalide");
         return undefined;
      }
      var _loc6_;
      var _loc7_;
      if(_loc5_.hasChilds)
      {
         _loc6_ = _loc5_.linkedChilds.getItems();
         for(var k in _loc6_)
         {
            _loc7_ = ank.battlefield.utils.Pathfinding.getArroundCellNum(this._mcBattlefield.mapHandler,nCellNum,nDir,_loc6_[k].childIndex);
            this.setSpriteDirection(_loc6_[k].id,_loc7_,nDir);
         }
      }
      this._mcBattlefield.removeSpriteBubble(sID);
      if(nDir != undefined)
      {
         _loc5_.direction = nDir;
      }
      var _loc8_ = _loc5_.mc;
      _loc8_.setPosition(nCellNum);
   }
   function stopSpriteMove(sID, oSeq, nCellNum)
   {
      oSeq.clearAllNextActions();
      var _loc5_ = this._oSprites.getItemAt(sID);
      var _loc6_ = _loc5_.mc;
      _loc5_.isInMove = false;
      oSeq.addAction(8,false,_loc6_,_loc6_.setPosition,[nCellNum]);
      oSeq.addAction(9,false,_loc6_,_loc6_.setAnim,["static"]);
   }
   function slideSprite(sID, cellNum, seq, sAnimation)
   {
      if(cellNum == -1)
      {
         return undefined;
      }
      if(sAnimation == undefined)
      {
         sAnimation = "static";
      }
      var _loc6_ = this._oSprites.getItemAt(sID);
      var _loc7_ = _loc6_.futureCellNum == -1 ? _loc6_.cellNum : _loc6_.futureCellNum;
      var _loc8_ = ank.battlefield.utils.Pathfinding.getDirectionFromCoordinates(this._mcBattlefield.mapHandler.getCellData(_loc7_).x,this._mcBattlefield.mapHandler.getCellData(_loc7_).rootY,this._mcBattlefield.mapHandler.getCellData(cellNum).x,this._mcBattlefield.mapHandler.getCellData(cellNum).rootY,false);
      var _loc9_ = ank.battlefield.utils.Compressor.makeFullPath(this._mcBattlefield.mapHandler,[{num:_loc7_},{num:cellNum,dir:_loc8_}]);
      if(_loc9_ != undefined)
      {
         this.moveSprite(sID,_loc9_,seq,false,sAnimation);
      }
   }
   function moveSprite(sID, path, seq, bClearSequencer, sAnimation, bForcedRun, bForcedWalk, runLimit)
   {
      this._mcBattlefield.removeSpriteBubble(sID);
      this._mcBattlefield.hideSpriteOverHead(sID);
      var _loc10_ = sAnimation != undefined;
      if(runLimit == undefined)
      {
         runLimit = ank.battlefield.SpriteHandler.DEFAULT_RUNLINIT;
      }
      if(bForcedRun == undefined)
      {
         bForcedRun = false;
      }
      if(bForcedWalk == undefined)
      {
         bForcedWalk = false;
      }
      var _loc11_ = !_loc10_ ? "walk" : "slide";
      if(bForcedWalk)
      {
         _loc11_ = "walk";
      }
      else if(bForcedRun)
      {
         _loc11_ = "run";
      }
      else if(!bForcedRun && (!bForcedWalk && !_loc10_))
      {
         if(path.length > runLimit)
         {
            _loc11_ = "run";
         }
      }
      var _loc12_ = this._oSprites.getItemAt(sID);
      if(_loc12_ == undefined)
      {
         ank.utils.Logger.err("[moveSprite] Sprite " + sID + " inexistant");
         return undefined;
      }
      if(seq == undefined)
      {
         seq = _loc12_.sequencer;
      }
      var _loc13_ = Number(path[path.length - 1]);
      _loc12_.futureCellNum = _loc13_;
      var _loc14_;
      var _loc15_;
      var _loc16_;
      var _loc17_;
      var _loc18_;
      if(_loc12_.hasChilds)
      {
         if(path.length > 1)
         {
            _loc14_ = ank.battlefield.utils.Pathfinding.getDirection(this._mcBattlefield.mapHandler,Number(path[path.length - 2]),_loc13_);
         }
         else
         {
            _loc14_ = _loc12_.direction;
         }
         _loc15_ = _loc12_.linkedChilds.getItems();
         for(var k in _loc15_)
         {
            _loc16_ = _loc15_[k];
            _loc17_ = ank.battlefield.utils.Pathfinding.getArroundCellNum(this._mcBattlefield.mapHandler,_loc13_,_loc14_,_loc16_.childIndex);
            _loc18_ = ank.battlefield.utils.Pathfinding.pathFind(this.api,this._mcBattlefield.mapHandler,_loc16_.cellNum,_loc17_,{bAllDirections:_loc16_.allDirections,bIgnoreSprites:true,bCellNumOnly:true,bWithBeginCellNum:true});
            if(_loc18_ != null)
            {
               ank.utils.Timer.setTimer(_loc16_,"battlefield",this,this.moveSprite,200 + (_loc12_.cellNum != _loc16_.cellNum ? 0 : 200),[_loc16_.id,_loc18_,_loc16_.sequencer,bClearSequencer,sAnimation,_loc16_.forceRun || bForcedRun,_loc16_.forceWalk || bForcedWalk,runLimit]);
            }
         }
      }
      var _loc19_ = _loc12_.mc;
      if(bClearSequencer)
      {
         if(!_loc10_)
         {
            seq.clearAllNextActions();
         }
      }
      seq.addAction(10,false,_loc19_,_loc19_.setPosition,[path[0]]);
      var _loc20_ = path.length;
      var _loc21_ = _loc20_ - 1;
      var _loc22_ = 0;
      var _loc23_;
      var _loc24_;
      var _loc25_;
      var _loc26_;
      var _loc27_;
      while(_loc22_ < _loc20_)
      {
         _loc23_ = sAnimation;
         _loc24_ = _loc11_;
         _loc25_ = false;
         if(_loc22_ != 0)
         {
            _loc26_ = this._mcBattlefield.mapHandler.getCellHeight(path[_loc22_ - 1]);
            _loc27_ = this._mcBattlefield.mapHandler.getCellHeight(path[_loc22_]);
            if(Math.abs(_loc26_ - _loc27_) > 0.5 && this._mcBattlefield.isJumpActivate)
            {
               _loc23_ = "jump";
               _loc24_ = "run";
               _loc25_ = true;
            }
         }
         seq.addAction(11,true,_loc19_,_loc19_.moveToCell,[seq,path[_loc22_],_loc22_ == _loc21_,_loc24_,_loc23_,_loc25_]);
         _loc22_ = _loc22_ + 1;
      }
      seq.execute();
   }
   function setCreatureMode(bEnabled)
   {
      var _loc3_ = this.api.datacenter.Sprites.getItems();
      var _loc4_;
      var _loc5_;
      var _loc6_;
      for(var k in _loc3_)
      {
         _loc4_ = _loc3_[k];
         if(_loc4_ instanceof dofus.datacenter.Character)
         {
            if(_loc4_.canSwitchInCreaturesMode)
            {
               if(!(_loc4_ instanceof dofus.datacenter.Mutant))
               {
                  if(bEnabled)
                  {
                     if(!_loc4_.bInCreaturesMode)
                     {
                        _loc4_.tmpGfxFile = _loc4_.gfxFile;
                        _loc4_.tmpMount = _loc4_.mount;
                        _loc4_.mount = undefined;
                        _loc5_ = dofus.Constants.CLIPS_PERSOS_PATH + _loc4_.Guild + "2.swf";
                        this.api.gfx.setSpriteGfx(_loc4_.id,_loc5_);
                        _loc4_.bInCreaturesMode = true;
                     }
                  }
                  else if(_loc4_.bInCreaturesMode)
                  {
                     _loc4_.mount = _loc4_.tmpMount;
                     delete _loc4_.tmpMount;
                     _loc6_ = _loc4_.tmpGfxFile != undefined ? _loc4_.tmpGfxFile : _loc4_.gfxFile;
                     delete _loc4_.tmpGfxFile;
                     this.api.gfx.setSpriteGfx(_loc4_.id,_loc6_);
                     _loc4_.bInCreaturesMode = false;
                  }
               }
            }
         }
      }
   }
   static function resetStaticVars()
   {
      ank.battlefield.SpriteHandler._bPlayerSpritesHidden = false;
      ank.battlefield.SpriteHandler._bShowMonstersTooltip = false;
   }
   function showMonstersTooltip(bShow)
   {
      ank.battlefield.SpriteHandler._bShowMonstersTooltip = bShow;
      var _loc3_ = this.api.gfx.spriteHandler.getSprites().getItems();
      var _loc4_;
      var _loc5_;
      for(var sID in _loc3_)
      {
         _loc4_ = _loc3_[sID].mc;
         _loc5_ = _loc4_.data;
         if(_loc5_ instanceof dofus.datacenter.MonsterGroup)
         {
            if(bShow)
            {
               _loc4_._rollOver(true);
            }
            else
            {
               _loc4_._rollOut(true);
            }
         }
      }
   }
   function launchVisualEffect(sID, oEffectData, nCellNum, nDisplayType, mSpriteAnimation, sTargetID, oSpriteToHideDuringAnimation, bForceVisible, bBlocking)
   {
      if(bBlocking == undefined)
      {
         bBlocking = true;
      }
      var _loc11_ = this._oSprites.getItemAt(sID);
      if(_loc11_ == undefined)
      {
         ank.utils.Logger.err("[launchVisualEffect] Sprite " + sID + " inexistant");
         return undefined;
      }
      var _loc12_ = this._oSprites.getItemAt(sTargetID);
      if(!this.api.electron.isWindowFocused)
      {
         oEffectData.file = undefined;
      }
      if(!bBlocking)
      {
         this._mcBattlefield.visualEffectHandler.addEffect(_loc11_,oEffectData,nCellNum,nDisplayType,_loc12_,!bForceVisible ? _loc11_.isVisible : true);
         return undefined;
      }
      var _loc13_ = _loc11_.mc;
      var _loc14_ = _loc11_.sequencer;
      var _loc15_ = true;
      var _loc16_;
      switch(nDisplayType)
      {
         case 0:
            _loc16_ = false;
            _loc15_ = false;
            break;
         case 10:
         case 11:
            _loc16_ = false;
            break;
         case 12:
            _loc16_ = true;
            break;
         case 20:
         case 21:
            _loc16_ = false;
            break;
         case 30:
         case 31:
            _loc16_ = true;
            break;
         case 40:
         case 41:
            _loc16_ = true;
            break;
         case 50:
            _loc16_ = false;
            break;
         case 51:
            _loc16_ = true;
            break;
         default:
            _loc16_ = false;
            _loc15_ = false;
      }
      _loc13_._ACTION = _loc11_;
      _loc13_._OBJECT = _loc13_;
      _loc14_.addAction(12,false,this,this.autoCalculateSpriteDirection,[sID,nCellNum]);
      var _loc17_;
      var _loc18_;
      var _loc19_;
      var _loc20_;
      var _loc21_;
      var _loc22_;
      var _loc23_;
      var _loc24_;
      if(mSpriteAnimation != undefined)
      {
         _loc17_ = typeof mSpriteAnimation;
         if(_loc17_ == "object")
         {
            if(mSpriteAnimation.length < 3)
            {
               ank.utils.Logger.err("[launchVisualEffect] l\'anim " + mSpriteAnimation + " est invalide");
               return undefined;
            }
            _loc18_ = _loc11_.cellNum;
            _loc19_ = this._mcBattlefield.mapHandler.getCellData(_loc18_);
            _loc20_ = this._mcBattlefield.mapHandler.getCellData(nCellNum);
            _loc21_ = ank.battlefield.utils.Pathfinding.getDirectionFromCoordinates(_loc19_.x,_loc19_.y,_loc20_.x,_loc20_.y,false);
            _loc22_ = ank.battlefield.utils.Compressor.makeFullPath(this._mcBattlefield.mapHandler,ank.battlefield.utils.Pathfinding.pathFind(this.api,this._mcBattlefield.mapHandler,_loc18_,nCellNum,{bIgnoreSprites:true,bWithBeginCellNum:true}));
            _loc22_.pop();
            _loc23_ = _loc22_[_loc22_.length - 1];
            this.moveSprite(sID,_loc22_,_loc14_,false,mSpriteAnimation[0],false,true);
            _loc14_.addAction(13,false,_loc13_,_loc13_.setDirection,[ank.battlefield.utils.Pathfinding.convertHeightToFourDirection(_loc21_)]);
            _loc14_.addAction(14,true,_loc13_,_loc13_.setAnim,[mSpriteAnimation[1]]);
            if(_loc15_)
            {
               _loc14_.addAction(15,_loc16_,this._mcBattlefield.visualEffectHandler,this._mcBattlefield.visualEffectHandler.addEffect,[_loc11_,oEffectData,nCellNum,nDisplayType,_loc12_,!bForceVisible ? _loc11_.isVisible : true]);
            }
            _loc24_ = ank.battlefield.utils.Compressor.makeFullPath(this._mcBattlefield.mapHandler,ank.battlefield.utils.Pathfinding.pathFind(this.api,this._mcBattlefield.mapHandler,_loc23_,_loc18_,{bIgnoreSprites:true,bWithBeginCellNum:true}));
            this.moveSprite(sID,_loc24_,_loc14_,false,mSpriteAnimation[2],false,true);
            _loc14_.addAction(16,false,_loc13_,_loc13_.setDirection,[_loc21_]);
            if(mSpriteAnimation[3] != undefined)
            {
               _loc14_.addAction(17,false,_loc13_,_loc13_.setAnim,[mSpriteAnimation[3]]);
            }
            _loc14_.execute();
            return undefined;
         }
         if(_loc17_ == "string")
         {
            _loc14_.addAction(18,true,_loc13_,_loc13_.setAnim,[mSpriteAnimation,false,true]);
         }
      }
      if(oSpriteToHideDuringAnimation != undefined)
      {
         _loc14_.addAction(19,false,this,this.hideSprite,[oSpriteToHideDuringAnimation.id,true]);
      }
      if(_loc15_)
      {
         _loc14_.addAction(20,_loc16_,this._mcBattlefield.visualEffectHandler,this._mcBattlefield.visualEffectHandler.addEffect,[_loc11_,oEffectData,nCellNum,nDisplayType,_loc12_,!bForceVisible ? _loc11_.isVisible : true]);
      }
      if(oSpriteToHideDuringAnimation != undefined)
      {
         _loc14_.addAction(21,false,this,this.hideSprite,[oSpriteToHideDuringAnimation.id,false]);
      }
      _loc14_.execute();
   }
   function launchCarriedSprite(sID, oEffectData, nCellNum, nDisplayType)
   {
      var _loc6_ = this._oSprites.getItemAt(sID);
      var _loc7_ = _loc6_.sequencer;
      if(_loc6_ == undefined)
      {
         ank.utils.Logger.err("[launchCarriedSprite] Sprite " + sID + " inexistant");
         return undefined;
      }
      var _loc8_ = _loc6_.carriedChild;
      this.launchVisualEffect(sID,oEffectData,nCellNum,nDisplayType,"carringThrow",undefined,_loc8_);
      _loc7_.addAction(22,false,this,this.setSpritePosition,[_loc8_.id,nCellNum]);
      this.uncarriedSprite(_loc8_.id,nCellNum,false,_loc7_);
      _loc7_.addAction(23,false,this,this.setSpriteAnim,[sID,"static"]);
      _loc7_.execute();
   }
   function autoCalculateSpriteDirection(sID, nCellNum)
   {
      var _loc4_ = this._oSprites.getItemAt(sID);
      if(_loc4_ == undefined)
      {
         ank.utils.Logger.err("[launchVisualEffect] Sprite " + sID + " inexistant");
         return undefined;
      }
      var _loc5_;
      var _loc6_;
      var _loc7_;
      var _loc8_;
      if(_loc4_.cellNum != nCellNum)
      {
         _loc5_ = _loc4_.mc;
         _loc6_ = this._mcBattlefield.mapHandler.getCellData(_loc4_.cellNum);
         _loc7_ = this._mcBattlefield.mapHandler.getCellData(nCellNum);
         _loc8_ = ank.battlefield.utils.Pathfinding.getDirectionFromCoordinates(_loc6_.x,_loc6_.rootY,_loc7_.x,_loc7_.rootY,false);
         _loc5_.setDirection(_loc8_);
      }
   }
   function convertHeightToFourSpriteDirection(sID)
   {
      var _loc3_ = this._oSprites.getItemAt(sID);
      if(_loc3_ == undefined)
      {
         ank.utils.Logger.err("[convertHeightToFourSpriteDirection] Sprite " + sID + " inexistant");
         return undefined;
      }
      this.setSpriteDirection(sID,ank.battlefield.utils.Pathfinding.convertHeightToFourDirection(_loc3_.direction));
   }
   function setSpriteAnim(sID, anim, bForced)
   {
      var _loc5_ = this._oSprites.getItemAt(sID);
      if(_loc5_ == undefined)
      {
         ank.utils.Logger.err("[setSpriteAnim(" + anim + ")] Sprite " + sID + " inexistant");
         return undefined;
      }
      ank.utils.Timer.removeTimer(_loc5_.mc,"battlefield");
      _loc5_.mc.setAnim(anim,false,bForced);
   }
   function setSpriteLoopAnim(sID, anim, nTimer)
   {
      var _loc5_ = this._oSprites.getItemAt(sID);
      if(_loc5_ == undefined)
      {
         ank.utils.Logger.err("[setSpriteLoopAnim] Sprite " + sID + " inexistant");
         return undefined;
      }
      ank.utils.Timer.removeTimer(_loc5_.mc,"battlefield");
      _loc5_.mc.setAnim(anim,true);
      ank.utils.Timer.setTimer(_loc5_.mc,"battlefield",_loc5_.mc,_loc5_.mc.setAnim,nTimer,["static"]);
   }
   function setSpriteTimerAnim(sID, anim, bForced, nTimer)
   {
      var _loc6_ = this._oSprites.getItemAt(sID);
      if(_loc6_ == undefined)
      {
         ank.utils.Logger.err("[setSpriteTimerAnim] Sprite " + sID + " inexistant");
         return undefined;
      }
      ank.utils.Timer.removeTimer(_loc6_.mc,"battlefield");
      _loc6_.mc.setAnimTimer(anim,false,bForced,nTimer);
   }
   function setSpriteGfx(sID, sFile)
   {
      var _loc4_ = this._oSprites.getItemAt(sID);
      if(_loc4_ == undefined)
      {
         ank.utils.Logger.err("[setSpriteGfx] Sprite " + sID + " inexistant");
         return undefined;
      }
      if(sFile != _loc4_.gfxFile)
      {
         _loc4_.gfxFile = sFile;
         _loc4_.mc.draw();
         if(_loc4_.allowGhostMode && this._mcBattlefield.bGhostView)
         {
            _loc4_.mc.setAlpha(ank.battlefield.Constants.GHOSTVIEW_SPRITE_ALPHA);
         }
      }
   }
   function setSpriteColorTransform(sID, t)
   {
      var _loc4_ = this._oSprites.getItemAt(sID);
      if(_loc4_ == undefined)
      {
         ank.utils.Logger.err("[setSpriteColorTransform] Sprite " + sID + " inexistant");
         return undefined;
      }
      _loc4_.mc.setColorTransform(t);
   }
   function setSpriteAlpha(sID, nAlpha)
   {
      var _loc4_ = this._oSprites.getItemAt(sID);
      if(_loc4_ == undefined)
      {
         ank.utils.Logger.err("[setSpriteAlpha] Sprite " + sID + " inexistant");
         return undefined;
      }
      _loc4_.mc.setAlpha(nAlpha);
   }
   function addSpriteExtraClip(sID, clipFile, col, bTop)
   {
      var _loc6_ = this._oSprites.getItemAt(sID);
      if(_loc6_ == undefined)
      {
         ank.utils.Logger.err("[addSpriteExtraClip] Sprite " + sID + " inexistant");
         return undefined;
      }
      _loc6_.mc.addExtraClip(clipFile,col,bTop);
   }
   function removeSpriteExtraClip(sID, bTop)
   {
      var _loc4_ = this._oSprites.getItemAt(sID);
      if(_loc4_ == undefined)
      {
         ank.utils.Logger.err("[removeSpriteExtraClip] Sprite " + sID + " inexistant");
         return undefined;
      }
      _loc4_.mc.removeExtraClip(bTop);
   }
   function showSpritePoints(sID, value, col)
   {
      var _loc5_ = this._oSprites.getItemAt(sID);
      if(_loc5_ == undefined)
      {
         ank.utils.Logger.err("[showSpritePoints] Sprite " + sID + " inexistant");
         return undefined;
      }
      _loc5_.mc.showPoints(value,col);
   }
   function setSpriteGhostView(bool)
   {
      var _loc3_ = this._oSprites.getItems();
      var _loc4_;
      for(var k in _loc3_)
      {
         _loc4_ = this._oSprites.getItemAt(k);
         _loc4_.mc.setGhostView(_loc4_.allowGhostMode && bool);
      }
   }
   function selectSprite(sID, bSelect)
   {
      var _loc4_ = this._oSprites.getItemAt(sID);
      if(_loc4_ == undefined)
      {
         ank.utils.Logger.err("[selectSprite] Sprite " + sID + " inexistant");
         return undefined;
      }
      var _loc5_;
      if(_loc4_.hasChilds)
      {
         _loc5_ = _loc4_.linkedChilds.getItems();
         for(var k in _loc5_)
         {
            this.selectSprite(_loc5_[k].id,bSelect);
         }
      }
      _loc4_.mc.select(bSelect);
   }
   function setSpriteScale(sID, nScaleX, nScaleY)
   {
      var _loc5_ = this._oSprites.getItemAt(sID);
      if(_loc5_ == undefined)
      {
         ank.utils.Logger.err("[selectSprite] Sprite " + sID + " inexistant");
         return undefined;
      }
      _loc5_.mc.setScale(nScaleX,nScaleY);
   }
}
