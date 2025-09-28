class dofus.datacenter.Basics extends dofus.utils.ApiElement
{
   var _aks_infos_highlightCoords;
   var _banner_targetCoords;
   var _sLogin;
   var _worldUniqueDropsStates;
   var aks_a_logs;
   var aks_a_prompt;
   var aks_chat_lastActionTime;
   var aks_current_server;
   var aks_current_team;
   var aks_debug_command_line;
   var aks_emote_lastActionTime;
   var aks_exchange_echangeType;
   var aks_gameserver_ip;
   var aks_gameserver_port;
   var aks_gifts_stack;
   var aks_identity;
   var aks_infos_lifeRestoreInterval;
   var aks_rescue_count;
   var aks_server_will_disconnect;
   var aks_servers;
   var aks_team1_starts;
   var aks_team2_starts;
   var aks_ticket;
   var allowedAdminCommands;
   var api;
   var canUseSeeAllSpell;
   var chatParams;
   var chat_type_visible;
   var connexionKey;
   var craftViewer_filter;
   var createCharacter;
   var dispatchEvent;
   var exp_lastGained;
   var first_connection_from_miniclip;
   var first_movement;
   var forceFlashChat;
   var gfx_canLaunch;
   var gfx_lastActionTime;
   var gfx_lastArea;
   var guildExp_lastGained;
   var inGame;
   var inactivity_signaled;
   var interactionsManager_path;
   var inventory_filter;
   var isLogged;
   var isSubscribedConquestFeed;
   var kamas_lastGained;
   var lastDateUpdate;
   var lastPingTimer;
   var mapExplorer_coord;
   var mapExplorer_filter;
   var mapExplorer_grid;
   var mapExplorer_zoom;
   var mountExp_lastGained;
   var payzone_isFirst;
   var pvpHuntedSpriteID;
   var quests_lastID;
   var serverMessageID;
   var spellManager_errorMsg;
   var aks_current_regional_version = Number.POSITIVE_INFINITY;
   var currentSessionFightCount = -1;
   function Basics()
   {
      super();
      this.initialize();
   }
   function get worldUniqueDropsStates()
   {
      return this._worldUniqueDropsStates;
   }
   function set worldUniqueDropsStates(worldUniqueDropsStates)
   {
      this._worldUniqueDropsStates = worldUniqueDropsStates;
      this.dispatchEvent({type:"worldUniqueDropsStatesRefresh",value:worldUniqueDropsStates});
   }
   function set login(sLogin)
   {
      this._sLogin = sLogin.toLowerCase();
   }
   function get login()
   {
      return this._sLogin;
   }
   function get aks_infos_highlightCoords()
   {
      return this._aks_infos_highlightCoords;
   }
   function set aks_infos_highlightCoords(aCoord)
   {
      this._aks_infos_highlightCoords = aCoord;
      var _loc3_ = dofus.graphics.gapi.ui.Banner(this.api.ui.getUIComponent("Banner"));
      _loc3_.illustration.updateFlags();
      _loc3_.chat.miniMapReplacementPanel.updateFlags();
      _loc3_.chat.shortcutsReplacementPanel.miniMap.updateFlags();
   }
   function set banner_targetCoords(aCoord)
   {
      this._banner_targetCoords = aCoord;
      var _loc3_ = dofus.graphics.gapi.ui.Banner(this.api.ui.getUIComponent("Banner"));
      _loc3_.illustration.updateFlags();
      _loc3_.chat.miniMapReplacementPanel.updateFlags();
      _loc3_.chat.shortcutsReplacementPanel.miniMap.updateFlags();
   }
   function get banner_targetCoords()
   {
      return this._banner_targetCoords;
   }
   function team(nTeamNumber)
   {
      var _loc3_ = new ank.utils.ExtendedArray();
      var _loc4_ = this.api.datacenter.Sprites.getItems();
      for(var i in _loc4_)
      {
         if(this.api.datacenter.Sprites.getItemAt(i).Team == nTeamNumber)
         {
            _loc3_.push(this.api.datacenter.Sprites.getItemAt(i));
         }
      }
      return _loc3_;
   }
   function initialize()
   {
      delete this.connexionKey;
      delete this.lastPingTimer;
      delete this.allowedAdminCommands;
      delete this._worldUniqueDropsStates;
      delete this.gfx_lastActionTime;
      delete this.gfx_canLaunch;
      delete this.gfx_lastArea;
      this.lastDateUpdate = -1000000;
      this.aks_server_will_disconnect = false;
      this.aks_gifts_stack = [];
      delete this.aks_chat_lastActionTime;
      this.chat_type_visible = {};
      delete this.aks_emote_lastActionTime;
      delete this.aks_exchange_echangeType;
      _global.clearInterval(this.aks_infos_lifeRestoreInterval);
      delete this.aks_infos_lifeRestoreInterval;
      delete this._aks_infos_highlightCoords;
      delete this.aks_ticket;
      delete this.aks_gameserver_ip;
      delete this.aks_gameserver_port;
      this.aks_rescue_count = -1;
      this.aks_servers = new ank.utils.ExtendedArray();
      delete this.aks_current_server;
      delete this.aks_identity;
      if(this.aks_a_logs == undefined)
      {
         this.aks_a_logs = "";
      }
      this.aks_a_prompt = "";
      this.api.electron.retroConsoleSetHeaderLabel(this.aks_a_prompt);
      this.aks_debug_command_line = "";
      delete this.spellManager_errorMsg;
      delete this.interactionsManager_path;
      delete this.inventory_filter;
      delete this.banner_targetCoords;
      this.payzone_isFirst = true;
      delete this.quests_lastID;
      delete this.pvpHuntedSpriteID;
      this.forceFlashChat = false;
      delete this.exp_lastGained;
      delete this.kamas_lastGained;
      delete this.guildExp_lastGained;
      delete this.mountExp_lastGained;
      this.craftViewer_filter = [true,true,true,true,true,true,true,true];
      this.mapExplorer_filter = [true,true,true,true,true,false,true];
      this.mapExplorer_zoom = 50;
      this.mapExplorer_coord = undefined;
      this.mapExplorer_grid = false;
      this.isSubscribedConquestFeed = false;
      this.isLogged = false;
      this.inGame = false;
      this.serverMessageID = -1;
      this.createCharacter = false;
      this.chatParams = {};
      this.aks_current_team = -1;
      this.aks_team1_starts = null;
      this.aks_team2_starts = null;
      this.inactivity_signaled = 0;
      this.first_connection_from_miniclip = false;
      this.first_movement = false;
      this.canUseSeeAllSpell = true;
      this.api.ui.isComponentHiddingSprites = false;
      _global.API.kernel.SpellsBoostsManager.clear();
      mx.events.EventDispatcher.initialize(this);
   }
   function aks_infos_highlightCoords_clear(nFlagType)
   {
      var _loc3_;
      var _loc4_;
      if(_global.isNaN(nFlagType))
      {
         this._aks_infos_highlightCoords = [];
      }
      else
      {
         _loc3_ = [];
         _loc4_ = 0;
         while(_loc4_ < this._aks_infos_highlightCoords.length)
         {
            if(this._aks_infos_highlightCoords[_loc4_].type != nFlagType)
            {
               _loc3_.push(this._aks_infos_highlightCoords[_loc4_]);
            }
            _loc4_ = _loc4_ + 1;
         }
         this._aks_infos_highlightCoords = _loc3_;
      }
      var _loc5_ = dofus.graphics.gapi.ui.Banner(this.api.ui.getUIComponent("Banner"));
      _loc5_.illustration.updateFlags();
      _loc5_.chat.miniMapReplacementPanel.updateFlags();
      _loc5_.chat.shortcutsReplacementPanel.miniMap.updateFlags();
   }
   function isWorldUniqueItemAlreadyDropped(nItemGenericID)
   {
      if(this._worldUniqueDropsStates == undefined)
      {
         return false;
      }
      var _loc3_ = this._worldUniqueDropsStates.getItemAt(nItemGenericID);
      if(_loc3_ == undefined)
      {
         return false;
      }
      var _loc4_ = dofus.datacenter.evenemential.WorldUniqueDropState(_loc3_);
      return _loc4_.dropped;
   }
}
