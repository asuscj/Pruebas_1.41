class dofus.aks.GameActions extends dofus.aks.Handler
{
   var _ex;
   var aks;
   var api;
   function GameActions(oAKS, oAPI)
   {
      super.initialize(oAKS,oAPI);
      this._ex = new dofus.aks.extend.GameActionsEx(oAPI,this);
   }
   function warning(sWarning)
   {
      this.infoImportanteDecompilo("Hello, we would like to tell you that modifying your Dofus client or sharing a modified client is strictly FORBIDDEN.");
      this.infoImportanteDecompilo("Modifying your client in any way will also flag you as a bot by our security systems.");
      this.infoImportanteDecompilo("Bonjour, nous souhaitons vous avertir que toute modification du client ou partage d\'un client modifié est strictement INTERDIT.");
      this.infoImportanteDecompilo("Modifier votre client (et ce quelque soit le type de modification) aura également pour conséquence de vous identifier comme un BOT par nos systèmes de sécurité.");
   }
   function infoImportanteDecompilo(sInfoPourLesMargoulins)
   {
   }
   function sendActions(nActionType, aParams)
   {
      var _loc4_ = new String();
      this.aks.send("GA" + new ank.utils.ExtendedString(nActionType).addLeftChar("0",3) + aParams.join(";"));
   }
   function actionAck(nActionID)
   {
      this.aks.send("GKK" + nActionID,false);
   }
   function actionCancel(nActionID, params)
   {
      this.aks.send("GKE" + nActionID + "|" + params,false);
   }
   function challenge(sSpriteID)
   {
      this.sendActions(900,[sSpriteID]);
   }
   function acceptChallenge(sSpriteID)
   {
      this.sendActions(901,[sSpriteID]);
   }
   function refuseChallenge(sSpriteID)
   {
      this.sendActions(902,[sSpriteID]);
   }
   function joinChallenge(nChallengeID, sSpriteID)
   {
      this.sendActions(903,[nChallengeID,sSpriteID]);
   }
   function joinChallengeAsSpectator(nChallengeID, sSpriteID)
   {
      if(this.api.datacenter.Game.isRunning || this.api.datacenter.Exchange != undefined)
      {
         this.api.kernel.showMessage(undefined,this.api.lang.getText("CANT_BECAUSE_BUSY"),"ERROR_CHAT");
         return undefined;
      }
      if(sSpriteID == undefined)
      {
         sSpriteID = "-1";
      }
      this.sendActions(976,[nChallengeID,sSpriteID]);
   }
   function attack(sSpriteID)
   {
      this.sendActions(906,[sSpriteID]);
   }
   function attackTaxCollector(sSpriteID)
   {
      this.sendActions(909,[sSpriteID]);
   }
   function mutantAttack(sSpriteID)
   {
      this.sendActions(910,[sSpriteID]);
   }
   function attackPrism(sSpriteID)
   {
      this.sendActions(912,[sSpriteID]);
   }
   function usePrism(sSpriteID)
   {
      this.sendActions(512,[sSpriteID]);
   }
   function acceptMarriage(sSpriteID)
   {
      this.sendActions(618,[sSpriteID]);
   }
   function refuseMarriage(sSpriteID)
   {
      this.sendActions(619,[sSpriteID]);
   }
   function bringHuntTarget()
   {
      this.sendActions(920,[]);
   }
   function onActionsStart(sExtraData)
   {
      var _loc3_ = sExtraData;
      if(_loc3_ != this.api.datacenter.Player.ID)
      {
         return undefined;
      }
      var _loc4_ = this.api.datacenter.Player.data;
      _loc4_.GameActionsManager.m_bNextAction = true;
      var _loc5_;
      if(this.api.datacenter.Game.isFight)
      {
         _loc5_ = _loc4_.sequencer;
         _loc5_.execute();
      }
   }
   function onActionsFinish(sExtraData)
   {
      var _loc3_ = sExtraData.split("|");
      var _loc4_ = Number(_loc3_[0]);
      var _loc5_ = _loc3_[1];
      if(_loc5_ != this.api.datacenter.Player.ID)
      {
         return undefined;
      }
      var _loc6_ = this.api.datacenter.Player.data;
      var _loc7_ = _loc6_.sequencer;
      _loc6_.GameActionsManager.m_bNextAction = false;
      if(this.api.datacenter.Game.isFight)
      {
         _loc7_.addAction(32,false,this.api.kernel.GameManager,this.api.kernel.GameManager.setEnabledInteractionIfICan,[ank.battlefield.Constants.INTERACTION_CELL_RELEASE_OVER_OUT]);
         if(_loc4_ != undefined)
         {
            _loc7_.addAction(33,false,this,this.actionAck,[_loc4_]);
         }
         _loc7_.addAction(34,false,this.api.kernel.GameManager,this.api.kernel.GameManager.cleanPlayer,[_loc5_]);
         this.api.gfx.mapHandler.resetEmptyCells();
         _loc7_.execute();
         if(_loc4_ == 2)
         {
            this.api.kernel.TipsManager.showNewTip(dofus.managers.TipsManager.TIP_FIGHT_ENDMOVE);
         }
      }
   }
   function onActions(sExtraData)
   {
      var _loc3_ = sExtraData.indexOf(";");
      var _loc4_ = Number(sExtraData.substring(0,_loc3_));
      if(dofus.Constants.SAVING_THE_WORLD)
      {
         if(sExtraData == ";0")
         {
            dofus.SaveTheWorld.getInstance().nextActionIfOnSafe();
         }
      }
      sExtraData = sExtraData.substring(_loc3_ + 1);
      _loc3_ = sExtraData.indexOf(";");
      var _loc5_ = Number(sExtraData.substring(0,_loc3_));
      sExtraData = sExtraData.substring(_loc3_ + 1);
      _loc3_ = sExtraData.indexOf(";");
      var _loc6_ = sExtraData.substring(0,_loc3_);
      var _loc7_ = sExtraData.substring(_loc3_ + 1);
      if(_loc6_.length == 0)
      {
         _loc6_ = this.api.datacenter.Player.ID;
      }
      var _loc9_ = this.api.datacenter.Game.currentPlayerID;
      var _loc8_;
      if(this.api.datacenter.Game.isFight && _loc9_ != undefined)
      {
         _loc8_ = _loc9_;
      }
      else
      {
         _loc8_ = _loc6_;
      }
      var _loc10_ = this.api.datacenter.Sprites.getItemAt(_loc8_);
      var _loc11_ = _loc10_.sequencer;
      var _loc12_ = _loc10_.GameActionsManager;
      var _loc13_ = {};
      _loc13_.bSequence = true;
      var _loc14_ = _loc12_.onServerResponse(_loc4_);
      if(!this._ex.onActionEx(sExtraData,_loc5_,_loc6_,_loc11_,_loc7_,_loc13_))
      {
         return undefined;
      }
      var _loc15_;
      var _loc16_;
      var _loc17_;
      var _loc18_;
      var _loc19_;
      var _loc20_;
      var _loc21_;
      var _loc22_;
      var _loc23_;
      var _loc24_;
      var _loc25_;
      var _loc26_;
      var _loc27_;
      var _loc28_;
      var _loc29_;
      var _loc30_;
      var _loc31_;
      var _loc32_;
      var _loc33_;
      var _loc34_;
      var _loc35_;
      var _loc36_;
      var _loc37_;
      var _loc38_;
      var _loc39_;
      var _loc40_;
      var _loc41_;
      var _loc42_;
      var _loc43_;
      var _loc44_;
      var _loc45_;
      var _loc46_;
      var _loc47_;
      var _loc48_;
      var _loc49_;
      var _loc50_;
      var _loc51_;
      var _loc52_;
      var _loc53_;
      var _loc54_;
      var _loc55_;
      var _loc56_;
      var _loc57_;
      var _loc58_;
      var _loc59_;
      var _loc60_;
      var _loc61_;
      var _loc62_;
      var _loc63_;
      var _loc64_;
      var _loc65_;
      var _loc66_;
      var _loc67_;
      var _loc68_;
      var _loc69_;
      var _loc70_;
      var _loc71_;
      var _loc72_;
      var _loc73_;
      var _loc74_;
      var _loc75_;
      var _loc76_;
      var _loc77_;
      var _loc78_;
      var _loc79_;
      var _loc80_;
      var _loc81_;
      var _loc82_;
      var _loc83_;
      var _loc84_;
      var _loc85_;
      var _loc86_;
      var _loc87_;
      var _loc88_;
      var _loc89_;
      var _loc90_;
      var _loc91_;
      var _loc92_;
      var _loc93_;
      var _loc94_;
      var _loc95_;
      var _loc96_;
      var _loc97_;
      var _loc98_;
      var _loc99_;
      var _loc100_;
      var _loc101_;
      var _loc102_;
      var _loc103_;
      var _loc104_;
      var _loc105_;
      var _loc106_;
      var _loc107_;
      var _loc108_;
      var _loc109_;
      var _loc110_;
      var _loc111_;
      var _loc112_;
      var _loc113_;
      var _loc114_;
      var _loc115_;
      var _loc116_;
      var _loc117_;
      var _loc118_;
      var _loc119_;
      var _loc120_;
      var _loc121_;
      var _loc122_;
      var _loc123_;
      var _loc124_;
      var _loc125_;
      var _loc126_;
      var _loc127_;
      var _loc128_;
      var _loc129_;
      var _loc130_;
      var _loc131_;
      var _loc132_;
      var _loc133_;
      var _loc134_;
      var _loc135_;
      var _loc136_;
      var _loc137_;
      var _loc138_;
      var _loc139_;
      var _loc140_;
      var _loc141_;
      var _loc142_;
      var _loc143_;
      var _loc144_;
      var _loc145_;
      var _loc146_;
      var _loc147_;
      var _loc148_;
      var _loc149_;
      var _loc150_;
      var _loc151_;
      var _loc152_;
      switch(_loc5_)
      {
         case 0:
            return undefined;
         case 11:
            _loc15_ = _loc7_.split(",");
            _loc16_ = _loc15_[0];
            _loc17_ = Number(_loc15_[1]);
            _loc11_.addAction(43,false,this.api.gfx,this.api.gfx.setSpriteDirection,[_loc16_,_loc17_]);
            break;
         case 50:
            _loc18_ = _loc7_;
            _loc11_.addAction(44,false,this.api.gfx,this.api.gfx.carriedSprite,[_loc18_,_loc6_]);
            _loc11_.addAction(45,false,this.api.gfx,this.api.gfx.removeSpriteExtraClip,[_loc18_]);
            break;
         case 51:
            _loc19_ = Number(_loc7_);
            _loc20_ = this.api.datacenter.Sprites.getItemAt(_loc6_);
            _loc21_ = _loc20_.carriedChild;
            _loc22_ = new ank.battlefield.datacenter.VisualEffect();
            _loc22_.file = dofus.Constants.SPELLS_PATH + "1200.swf";
            _loc22_.level = 1;
            _loc22_.bInFrontOfSprite = true;
            _loc22_.bTryToBypassContainerColor = false;
            this.api.gfx.spriteLaunchCarriedSprite(_loc6_,_loc22_,_loc19_,31,10);
            _loc11_.addAction(46,false,this.api.gfx,this.api.gfx.addSpriteExtraClip,[_loc21_.id,dofus.Constants.CIRCLE_FILE,dofus.Constants.TEAMS_COLOR[_loc21_.Team]]);
            break;
         case 52:
            _loc23_ = _loc7_.split(",");
            _loc24_ = _loc23_[0];
            _loc25_ = this.api.datacenter.Sprites.getItemAt(_loc24_);
            _loc26_ = Number(_loc23_[1]);
            if(_loc25_.hasCarriedParent() && !_loc25_.uncarryingSprite)
            {
               _loc25_.uncarryingSprite = true;
               _loc11_.addAction(47,false,this.api.gfx,this.api.gfx.uncarriedSprite,[_loc24_,_loc26_,true,_loc11_]);
               _loc11_.addAction(48,false,this.api.gfx,this.api.gfx.addSpriteExtraClip,[_loc24_,dofus.Constants.CIRCLE_FILE,dofus.Constants.TEAMS_COLOR[_loc25_.Team]]);
            }
            break;
         case 100:
         case 108:
         case 110:
            _loc27_ = _loc7_.split(",");
            _loc28_ = _loc27_[0];
            _loc29_ = this.api.datacenter.Sprites.getItemAt(_loc28_);
            _loc30_ = Number(_loc27_[1]);
            _loc31_ = Number(_loc27_[2]);
            _loc32_ = dofus.Constants.getElementColorById(_loc31_);
            _loc33_ = _loc30_ <= 0;
            _loc34_ = !_loc33_ ? "WIN_LP" : "LOST_LP";
            _loc35_ = [];
            _loc35_.push(Math.abs(_loc30_));
            if(_loc32_ != undefined && this.api.kernel.OptionsManager.getOption("SeeDamagesColor"))
            {
               _loc35_.push(_loc32_);
            }
            _loc11_.addAction(49,false,this.api.kernel.ChatManager.feMessagesBuffer,this.api.kernel.ChatManager.feMessagesBuffer.addFightEventMessage,[_loc5_,[_loc34_],_loc35_,_loc29_.id,_loc29_.name]);
            if(_loc30_ != 0)
            {
               _loc11_.addAction(50,false,_loc29_,_loc29_.updateLP,[_loc30_]);
               _loc11_.addAction(51,false,this.api.ui.getUIComponent("Timeline").timelineControl,this.api.ui.getUIComponent("Timeline").timelineControl.updateCharacters);
            }
            break;
         case 101:
         case 102:
         case 111:
         case 120:
         case 168:
            _loc36_ = _loc7_.split(",");
            _loc37_ = this.api.datacenter.Sprites.getItemAt(_loc36_[0]);
            _loc38_ = Number(_loc36_[1]);
            if(_loc38_ == 0)
            {
               break;
            }
            if(_loc5_ == 101 || (_loc5_ == 111 || (_loc5_ == 120 || _loc5_ == 168)))
            {
               _loc39_ = _loc38_ < 0;
               _loc40_ = !_loc39_ ? "WIN_AP" : "LOST_AP";
               _loc41_ = String(Math.abs(_loc38_));
               _loc11_.addAction(53,false,this.api.kernel.ChatManager.feMessagesBuffer,this.api.kernel.ChatManager.feMessagesBuffer.addFightEventMessage,[_loc5_,[_loc40_],[_loc41_],_loc37_.id,_loc37_.name]);
            }
            _loc11_.addAction(54,false,_loc37_,_loc37_.updateAP,[_loc38_,_loc5_ == 102]);
            break;
         case 127:
         case 129:
         case 128:
         case 78:
         case 169:
            _loc42_ = _loc7_.split(",");
            _loc43_ = _loc42_[0];
            _loc44_ = Number(_loc42_[1]);
            _loc45_ = this.api.datacenter.Sprites.getItemAt(_loc43_);
            if(_loc44_ == 0)
            {
               break;
            }
            if(_loc5_ == 127 || (_loc5_ == 128 || (_loc5_ == 169 || _loc5_ == 78)))
            {
               _loc46_ = _loc44_ < 0;
               _loc47_ = !_loc46_ ? "WIN_MP" : "LOST_MP";
               _loc48_ = String(Math.abs(_loc44_));
               _loc11_.addAction(55,false,this.api.kernel.ChatManager.feMessagesBuffer,this.api.kernel.ChatManager.feMessagesBuffer.addFightEventMessage,[_loc5_,[_loc47_],[_loc48_],_loc45_.id,_loc45_.name]);
            }
            _loc11_.addAction(56,false,_loc45_,_loc45_.updateMP,[_loc44_,_loc5_ == 129]);
            break;
         case 103:
            _loc49_ = _loc7_;
            _loc50_ = this.api.datacenter.Sprites.getItemAt(_loc49_);
            _loc51_ = _loc50_.mc;
            if(_loc51_ == undefined)
            {
               return undefined;
            }
            _loc50_.isPendingClearing = true;
            _loc52_ = _loc50_.sex != 1 ? "m" : "f";
            _loc11_.addAction(57,false,this.api.kernel.ChatManager.feMessagesBuffer,this.api.kernel.ChatManager.feMessagesBuffer.addFightEventMessage,[_loc5_,["DIE"],_loc52_,_loc50_.id,_loc50_.name]);
            _loc53_ = this.api.ui.getUIComponent("Timeline");
            _loc11_.addAction(58,false,_loc53_,_loc53_.hideItem,[_loc49_]);
            _loc11_.addAction(176,false,this.api.gfx,this.api.gfx.removeEffectsByCasterID,[_loc49_]);
            this.warning("You\'re not allowed to change the behaviour of the game animations. Please play legit !");
            this.warning("Toute modification du comportement des animations est détectée et sanctionnée car c\'est considéré comme de la triche, merci de jouer legit !");
            if(!this.api.datacenter.Player.isSkippingFightAnimations)
            {
               _loc11_.addAction(59,true,_loc51_,_loc51_.setAnim,["Die"],1500,true);
            }
            this.warning("Vous n\'êtes même pas sensé pouvoir lire ce message, mais un rappel de plus n\'est pas de trop pour certains : modification du client = ban ;)");
            _loc11_.addAction(61,false,_loc51_,_loc51_.clear);
            if(_loc50_.hasCarriedChild() && !_loc50_.uncarryingSprite)
            {
               _loc50_.uncarryingSprite = true;
               _loc11_.addAction(172,false,this.api.gfx,this.api.gfx.uncarriedSprite,[_loc50_.carriedSprite.id,_loc50_.cellNum,false,_loc11_]);
               _loc11_.addAction(60,false,this.api.gfx,this.api.gfx.addSpriteExtraClip,[_loc50_.carriedChild.id,dofus.Constants.CIRCLE_FILE,dofus.Constants.TEAMS_COLOR[_loc50_.carriedChild.Team]]);
            }
            if(this.api.datacenter.Player.summonedCreaturesID[_loc49_])
            {
               this.api.datacenter.Player.SummonedCreatures--;
               delete this.api.datacenter.Player.summonedCreaturesID[_loc49_];
               this.api.ui.getUIComponent("Banner").shortcuts.setSpellStateOnAllContainers();
            }
            if(_loc49_ == this.api.datacenter.Player.ID)
            {
               if(_loc6_ == this.api.datacenter.Player.ID)
               {
                  this.api.kernel.SpeakingItemsManager.triggerEvent(dofus.managers.SpeakingItemsManager.SPEAK_TRIGGER_KILLED_HIMSELF);
               }
               else
               {
                  _loc54_ = this.api.datacenter.Sprites.getItemAt(this.api.datacenter.Player.ID).Team;
                  _loc55_ = this.api.datacenter.Sprites.getItemAt(_global.parseInt(_loc6_)).Team;
                  if(_loc54_ == _loc55_)
                  {
                     this.api.kernel.SpeakingItemsManager.triggerEvent(dofus.managers.SpeakingItemsManager.SPEAK_TRIGGER_KILLED_BY_ALLY);
                  }
                  else
                  {
                     this.api.kernel.SpeakingItemsManager.triggerEvent(dofus.managers.SpeakingItemsManager.SPEAK_TRIGGER_KILLED_BY_ENEMY);
                  }
               }
               this.api.datacenter.Player.isDead = true;
               this.api.ui.getUIComponent("Banner").shortcuts.setSpellStateOnAllContainers();
               this.api.gfx.clearSpellPreview();
               break;
            }
            if(_loc6_ == this.api.datacenter.Player.ID)
            {
               _loc56_ = this.api.datacenter.Sprites.getItemAt(this.api.datacenter.Player.ID).Team;
               _loc57_ = this.api.datacenter.Sprites.getItemAt(_global.parseInt(_loc49_)).Team;
               if(_loc56_ == _loc57_)
               {
                  this.api.kernel.SpeakingItemsManager.triggerEvent(dofus.managers.SpeakingItemsManager.SPEAK_TRIGGER_KILL_ALLY);
                  break;
               }
               this.api.kernel.SpeakingItemsManager.triggerEvent(dofus.managers.SpeakingItemsManager.SPEAK_TRIGGER_KILL_ENEMY);
            }
            break;
         case 104:
            _loc58_ = this.api.datacenter.Sprites.getItemAt(_loc6_);
            _loc59_ = _loc58_.mc;
            _loc11_.addAction(62,false,this.api.kernel,this.api.kernel.showMessage,[undefined,this.api.lang.getText("CANT_MOVEOUT"),"INFO_FIGHT_CHAT"]);
            if(!this.api.datacenter.Player.isSkippingFightAnimations && this.api.electron.isWindowFocused)
            {
               _loc11_.addAction(63,false,_loc59_,_loc59_.setAnim,["Hit"]);
            }
            break;
         case 105:
         case 164:
            _loc60_ = _loc7_.split(",");
            _loc61_ = _loc60_[0];
            _loc62_ = _loc5_ != 164 ? _loc60_[1] : _loc60_[1] + "%";
            _loc63_ = this.api.datacenter.Sprites.getItemAt(_loc61_);
            _loc11_.addAction(64,false,this.api.kernel,this.api.kernel.showMessage,[undefined,this.api.lang.getText("REDUCE_DAMAGES",[_loc63_.name,_loc62_]),"INFO_FIGHT_CHAT"]);
            break;
         case 106:
            _loc64_ = _loc7_.split(",");
            _loc65_ = _loc64_[0];
            _loc66_ = _loc64_[1] == "1";
            _loc67_ = this.api.datacenter.Sprites.getItemAt(_loc65_);
            _loc68_ = !_loc66_ ? this.api.lang.getText("RETURN_SPELL_NO",[_loc67_.name]) : this.api.lang.getText("RETURN_SPELL_OK",[_loc67_.name]);
            _loc11_.addAction(65,false,this.api.kernel,this.api.kernel.showMessage,[undefined,_loc68_,"INFO_FIGHT_CHAT"]);
            break;
         case 107:
            _loc69_ = _loc7_.split(",");
            _loc70_ = _loc69_[0];
            _loc71_ = _loc69_[1];
            _loc72_ = this.api.datacenter.Sprites.getItemAt(_loc70_);
            _loc11_.addAction(66,false,this.api.kernel,this.api.kernel.showMessage,[undefined,this.api.lang.getText("RETURN_DAMAGES",[_loc72_.name,_loc71_]),"INFO_FIGHT_CHAT"]);
            break;
         case 130:
            _loc73_ = Number(_loc7_);
            _loc74_ = this.api.datacenter.Sprites.getItemAt(_loc6_);
            _loc11_.addAction(67,false,this.api.kernel,this.api.kernel.showMessage,[undefined,ank.utils.PatternDecoder.combine(this.api.lang.getText("STEAL_GOLD",[_loc74_.name,_loc73_]),"m",_loc73_ < 2),"INFO_FIGHT_CHAT"]);
            break;
         case 132:
            _loc75_ = this.api.datacenter.Sprites.getItemAt(_loc6_);
            _loc76_ = this.api.datacenter.Sprites.getItemAt(_loc7_);
            _loc11_.addAction(68,false,this.api.kernel,this.api.kernel.showMessage,[undefined,this.api.lang.getText("REMOVE_ALL_EFFECTS",[_loc75_.name,_loc76_.name]),"INFO_FIGHT_CHAT"]);
            _loc11_.addAction(69,false,_loc76_.CharacteristicsManager,_loc76_.CharacteristicsManager.terminateAllEffects);
            _loc11_.addAction(70,false,_loc76_.EffectsManager,_loc76_.EffectsManager.terminateAllEffects);
            break;
         case 140:
            _loc77_ = Number(_loc7_);
            _loc78_ = this.api.datacenter.Sprites.getItemAt(_loc6_);
            _loc79_ = this.api.datacenter.Sprites.getItemAt(_loc7_);
            _loc11_.addAction(71,false,this.api.kernel,this.api.kernel.showMessage,[undefined,this.api.lang.getText("A_PASS_NEXT_TURN",[_loc79_.name]),"INFO_FIGHT_CHAT"]);
            break;
         case 151:
            _loc80_ = Number(_loc7_);
            _loc81_ = this.api.datacenter.Sprites.getItemAt(_loc6_);
            _loc82_ = _loc80_ != -1 ? this.api.lang.getText("INVISIBLE_OBSTACLE",[_loc81_.name,this.api.lang.getSpellText(_loc80_).n]) : this.api.lang.getText("CANT_DO_INVISIBLE_OBSTACLE");
            _loc11_.addAction(72,false,this.api.kernel,this.api.kernel.showMessage,[undefined,_loc82_,"ERROR_CHAT"]);
            break;
         case 166:
            _loc83_ = _loc7_.split(",");
            _loc84_ = Number(_loc83_[0]);
            _loc85_ = this.api.datacenter.Sprites.getItemAt(_loc6_);
            _loc86_ = Number(_loc83_[1]);
            _loc11_.addAction(73,false,this.api.kernel,this.api.kernel.showMessage,[undefined,this.api.lang.getText("RETURN_AP",[_loc85_.name,_loc86_]),"INFO_FIGHT_CHAT"]);
            break;
         case 164:
            _loc87_ = _loc7_.split(",");
            _loc88_ = Number(_loc87_[0]);
            _loc89_ = this.api.datacenter.Sprites.getItemAt(_loc6_);
            _loc90_ = Number(_loc87_[1]);
            _loc11_.addAction(74,false,this.api.kernel,this.api.kernel.showMessage,[undefined,this.api.lang.getText("REDUCE_LP_DAMAGES",[_loc89_.name,_loc90_]),"INFO_FIGHT_CHAT"]);
            break;
         case 780:
            if(_loc6_ == this.api.datacenter.Player.ID)
            {
               this.api.datacenter.Player.SummonedCreatures = this.api.datacenter.Player.SummonedCreatures + 1;
               _loc91_ = _global.parseInt(_loc7_.split(";")[3]);
               this.api.datacenter.Player.summonedCreaturesID[_loc91_] = true;
            }
         case 147:
            _loc92_ = _loc7_.split(";")[3];
            _loc93_ = this.api.ui.getUIComponent("Timeline");
            _loc11_.addAction(75,false,_loc93_,_loc93_.showItem,[_loc92_]);
            _loc11_.addAction(76,false,this.aks.Game.extendIn,this.aks.Game.extendIn.onMovement,[_loc7_,true]);
            if(_loc92_ == this.api.datacenter.Player.ID)
            {
               this.api.datacenter.Player.isDead = false;
               this.api.ui.getUIComponent("Banner").shortcuts.setSpellStateOnAllContainers();
            }
            break;
         case 180:
         case 181:
            _loc94_ = _loc7_.split(";")[3];
            if(_loc6_ == this.api.datacenter.Player.ID)
            {
               this.api.datacenter.Player.SummonedCreatures = this.api.datacenter.Player.SummonedCreatures + 1;
               this.api.datacenter.Player.summonedCreaturesID[_loc94_] = true;
            }
            _loc11_.addAction(77,false,this.aks.Game.extendIn,this.aks.Game.extendIn.onMovement,[_loc7_,true]);
            break;
         case 185:
            _loc11_.addAction(78,false,this.aks.Game.extendIn,this.aks.Game.extendIn.onMovement,[_loc7_]);
            break;
         case 2144:
            _loc11_.addAction(179,false,this.aks.Game.extendIn,this.aks.Game.extendIn.onMovement,[_loc7_]);
            break;
         case 2011:
            _loc95_ = _loc7_.split(",");
            _loc96_ = _loc95_[0];
            _loc97_ = this.api.datacenter.Sprites.getItemAt(_loc96_);
            _loc98_ = _loc97_.EffectsManager;
            _loc98_.removeEffectsByType(2010);
         case 117:
         case 116:
         case 115:
         case 122:
         case 112:
         case 142:
         case 145:
         case 138:
         case 114:
         case 182:
         case 118:
         case 157:
         case 123:
         case 152:
         case 126:
         case 155:
         case 119:
         case 154:
         case 124:
         case 156:
         case 125:
         case 153:
         case 160:
         case 161:
         case 162:
         case 163:
         case 606:
         case 607:
         case 608:
         case 609:
         case 610:
         case 611:
         case 186:
         case 210:
         case 211:
         case 212:
         case 213:
         case 214:
         case 215:
         case 216:
         case 217:
         case 218:
         case 219:
         case 240:
         case 241:
         case 242:
         case 243:
         case 244:
         case 245:
         case 246:
         case 247:
         case 248:
         case 249:
         case 178:
         case 179:
         case 225:
         case 226:
         case 2008:
         case 2009:
         case 2010:
         case 2112:
         case 2113:
         case 2114:
            _loc99_ = _loc7_.split(",");
            _loc100_ = _loc99_[0];
            _loc101_ = this.api.datacenter.Sprites.getItemAt(_loc100_);
            _loc102_ = Number(_loc99_[1]);
            _loc103_ = Number(_loc99_[2]);
            _loc104_ = _loc101_.CharacteristicsManager;
            _loc105_ = new dofus.datacenter.Effect(undefined,_loc5_,_loc102_,undefined,undefined,undefined,_loc103_);
            _loc11_.addAction(79,false,_loc104_,_loc104_.addEffect,[_loc105_]);
            _loc11_.addAction(80,false,this.api.kernel.ChatManager.feMessagesBuffer,this.api.kernel.ChatManager.feMessagesBuffer.addFightEventMessage,[_loc5_,undefined,[_loc105_.description],_loc101_.id,_loc101_.name]);
            break;
         case 149:
            _loc106_ = _loc7_.split(",");
            _loc107_ = _loc106_[0];
            _loc108_ = this.api.datacenter.Sprites.getItemAt(_loc107_);
            _loc109_ = Number(_loc106_[1]);
            _loc110_ = Number(_loc106_[2]);
            _loc111_ = Number(_loc106_[3]);
            _loc112_ = Number(_loc106_[4]);
            _loc113_ = Number(_loc106_[5]);
            _loc11_.addAction(81,false,this.api.kernel,this.api.kernel.showMessage,[undefined,this.api.lang.getText("GFX",[_loc108_.name]),"INFO_FIGHT_CHAT"]);
            _loc114_ = _loc108_.CharacteristicsManager;
            _loc115_ = new dofus.datacenter.Effect(undefined,_loc5_,_loc109_,_loc110_,undefined,_loc112_ + "," + _loc113_,_loc111_);
            _loc11_.addAction(82,false,_loc114_,_loc114_.addEffect,[_loc115_]);
            break;
         case 150:
            _loc116_ = _loc7_.split(",");
            _loc117_ = _loc116_[0];
            _loc118_ = this.api.datacenter.Sprites.getItemAt(_loc117_);
            _loc119_ = Number(_loc116_[1]);
            _loc120_ = Number(_loc116_[2]) == 1;
            if(_loc119_ > 0)
            {
               _loc11_.addAction(83,false,this.api.kernel,this.api.kernel.showMessage,[undefined,this.api.lang.getText("INVISIBILITY",[_loc118_.name]),"INFO_FIGHT_CHAT"]);
               _loc11_.addAction(177,false,_loc118_,_loc118_.setInvisibleInFight,[true]);
               if(_loc117_ == this.api.datacenter.Player.ID || _loc120_)
               {
                  _loc11_.addAction(84,false,_loc118_.mc,_loc118_.mc.setAlpha,[40]);
                  break;
               }
               _loc11_.addAction(85,false,_loc118_.mc,_loc118_.mc.setVisible,[false]);
               break;
            }
            _loc11_.addAction(86,false,this.api.kernel,this.api.kernel.showMessage,[undefined,this.api.lang.getText("VISIBILITY",[_loc118_.name]),"INFO_FIGHT_CHAT"]);
            _loc11_.addAction(178,false,_loc118_,_loc118_.setInvisibleInFight,[false]);
            this.api.gfx.hideSprite(_loc117_,false);
            if(_loc118_.allowGhostMode && this.api.gfx.bGhostView)
            {
               this.api.gfx.setSpriteAlpha(_loc117_,ank.battlefield.Constants.GHOSTVIEW_SPRITE_ALPHA);
               break;
            }
            this.api.gfx.setSpriteAlpha(_loc117_,100);
            break;
         case 165:
            _loc121_ = _loc7_.split(",");
            _loc122_ = _loc121_[0];
            _loc123_ = Number(_loc121_[1]);
            _loc124_ = Number(_loc121_[2]);
            _loc125_ = Number(_loc121_[3]);
            break;
         case 200:
            _loc126_ = _loc7_.split(",");
            _loc127_ = Number(_loc126_[0]);
            _loc128_ = Number(_loc126_[1]);
            _loc11_.addAction(87,false,this.api.gfx,this.api.gfx.setObject2Frame,[_loc127_,_loc128_]);
            break;
         case 208:
            _loc129_ = _loc7_.split(",");
            _loc130_ = this.api.datacenter.Sprites.getItemAt(_loc6_);
            _loc131_ = Number(_loc129_[0]);
            _loc132_ = _loc129_[1];
            _loc133_ = Number(_loc129_[2]);
            _loc134_ = !_global.isNaN(Number(_loc129_[3])) ? "anim" + _loc129_[3] : String(_loc129_[3]).split("~");
            _loc135_ = _loc129_[4] == undefined ? 1 : Number(_loc129_[4]);
            _loc136_ = new ank.battlefield.datacenter.VisualEffect();
            _loc136_.file = dofus.Constants.SPELLS_PATH + _loc132_ + ".swf";
            _loc136_.level = _loc135_;
            _loc136_.bInFrontOfSprite = true;
            _loc136_.bTryToBypassContainerColor = true;
            this.api.gfx.spriteLaunchVisualEffect(_loc6_,_loc136_,_loc131_,_loc133_,_loc134_);
            break;
         case 228:
            _loc137_ = _loc7_.split(",");
            _loc138_ = this.api.datacenter.Sprites.getItemAt(_loc6_);
            _loc139_ = Number(_loc137_[0]);
            _loc140_ = _loc137_[1];
            _loc141_ = Number(_loc137_[2]);
            _loc142_ = !_global.isNaN(Number(_loc137_[3])) ? "anim" + _loc137_[3] : String(_loc137_[3]).split("~");
            _loc143_ = _loc137_[4] == undefined ? 1 : Number(_loc137_[4]);
            _loc144_ = new ank.battlefield.datacenter.VisualEffect();
            _loc144_.file = dofus.Constants.SPELLS_PATH + _loc140_ + ".swf";
            _loc144_.level = _loc143_;
            _loc144_.bInFrontOfSprite = true;
            _loc144_.bTryToBypassContainerColor = false;
            this.api.gfx.spriteLaunchVisualEffect(_loc6_,_loc144_,_loc139_,_loc141_,_loc142_);
            break;
         case 857:
            _loc145_ = _loc7_.split(",");
            _loc146_ = _loc145_[0];
            _loc147_ = !!Number(_loc145_[1]);
            _loc148_ = !!Number(_loc145_[2]);
            _loc149_ = !!Number(_loc145_[3]);
            _loc150_ = Number(_loc145_[4]);
            _loc151_ = !!Number(_loc145_[5]);
            _loc152_ = !!_loc145_[6];
            this.api.ui.loadUIComponent("Cinematic","Cinematic",{file:dofus.Constants.CINEMATICS_PATH + _loc146_ + ".swf",background:_loc147_,banner:_loc148_,npc:_loc149_,frameToStart:_loc150_,canCancel:_loc151_,monster:_loc152_});
            break;
         case 999:
            _loc11_.addAction(116,false,this.aks,this.aks.processCommand,[_loc7_]);
      }
      if(!_global.isNaN(_loc4_) && _loc6_ == this.api.datacenter.Player.ID)
      {
         _loc11_.addAction(117,false,_loc12_,_loc12_.ack,[_loc4_]);
      }
      else
      {
         _loc12_.end(_loc8_ == this.api.datacenter.Player.ID);
      }
      if(!_loc11_.isPlaying() && _loc13_.bSequence)
      {
         _loc11_.execute(true);
      }
   }
   function cancel(oEvent)
   {
      var _loc0_;
      if((_loc0_ = oEvent.target._name) === "AskCancelChallenge")
      {
         this.refuseChallenge(oEvent.params.spriteID);
      }
   }
   function yes(oEvent)
   {
      switch(oEvent.target._name)
      {
         case "AskYesNoIgnoreChallenge":
            this.acceptChallenge(oEvent.params.spriteID);
            break;
         case "AskYesNoMarriage":
            this.acceptMarriage(oEvent.params.refID);
            this.api.gfx.addSpriteBubble(oEvent.params.spriteID,this.api.lang.getText("YES"));
         default:
            return;
      }
   }
   function no(oEvent)
   {
      switch(oEvent.target._name)
      {
         case "AskYesNoIgnoreChallenge":
            this.refuseChallenge(oEvent.params.spriteID);
            break;
         case "AskYesNoMarriage":
            this.refuseMarriage(oEvent.params.refID);
            this.api.gfx.addSpriteBubble(oEvent.params.spriteID,this.api.lang.getText("NO"));
         default:
            return;
      }
   }
   function ignore(oEvent)
   {
      var _loc0_;
      if((_loc0_ = oEvent.target._name) === "AskYesNoIgnoreChallenge")
      {
         this.api.kernel.ChatManager.addToBlacklist(oEvent.params.player);
         this.api.kernel.showMessage(undefined,this.api.lang.getText("TEMPORARY_BLACKLISTED",[oEvent.params.player]),"INFO_CHAT");
         this.refuseChallenge(oEvent.params.spriteID);
      }
   }
}
