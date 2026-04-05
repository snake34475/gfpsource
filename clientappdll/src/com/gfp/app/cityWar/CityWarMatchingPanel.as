package com.gfp.app.cityWar
{
   import com.gfp.app.manager.CityWarManager;
   import com.gfp.core.CommandID;
   import com.gfp.core.info.UserInfo;
   import com.gfp.core.manager.FocusManager;
   import com.gfp.core.manager.LayerManager;
   import com.gfp.core.manager.MainManager;
   import com.gfp.core.manager.UIManager;
   import com.gfp.core.net.SocketConnection;
   import flash.display.SimpleButton;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import org.taomee.ds.HashMap;
   import org.taomee.utils.DisplayUtil;
   
   public class CityWarMatchingPanel
   {
      
      private static var _instance:CityWarMatchingPanel;
      
      private var _mainUI:Sprite;
      
      private var _closeBtn:SimpleButton;
      
      private var _redCon:Sprite;
      
      private var _blueCon:Sprite;
      
      private var _redHash:HashMap;
      
      private var _blueHash:HashMap;
      
      public function CityWarMatchingPanel()
      {
         super();
         this._mainUI = UIManager.getSprite("UI_CityWarMatchingPanel");
         this._redCon = new Sprite();
         this._redCon.x = -150;
         this._redCon.y = 121;
         this._mainUI.addChild(this._redCon);
         this._blueCon = new Sprite();
         this._blueCon.x = 201.65;
         this._blueCon.y = 334;
         this._mainUI.addChild(this._blueCon);
         this._redHash = new HashMap();
         this._blueHash = new HashMap();
         this._closeBtn = this._mainUI["closeBtn"];
         this._closeBtn.addEventListener(MouseEvent.CLICK,this.onCloseHandler);
      }
      
      public static function get instance() : CityWarMatchingPanel
      {
         if(_instance == null)
         {
            _instance = new CityWarMatchingPanel();
         }
         return _instance;
      }
      
      public static function removeMember(param1:uint) : void
      {
         if(_instance)
         {
            _instance.removeMember(param1);
         }
      }
      
      public static function destroy() : void
      {
         if(_instance)
         {
            _instance.destroy();
         }
         _instance = null;
      }
      
      public function show() : void
      {
         if(this._mainUI.parent == null)
         {
            LayerManager.topLevel.addChild(this._mainUI);
            MainManager.closeOperate();
         }
      }
      
      public function addMember(param1:UserInfo) : void
      {
         var _loc3_:Sprite = null;
         if(Boolean(this._redHash.containsKey(param1.userID)) || Boolean(this._blueHash.containsKey(param1.userID)))
         {
            return;
         }
         var _loc2_:MatchingHeadPanel = new MatchingHeadPanel(param1);
         if(param1.overHeadState == 1)
         {
            _loc3_ = this._redCon;
            this._redHash.add(param1.userID,_loc2_);
         }
         else
         {
            _loc3_ = this._blueCon;
            this._blueHash.add(param1.userID,_loc2_);
         }
         _loc2_.show(_loc3_);
         this.show();
      }
      
      public function removeMember(param1:uint) : void
      {
         var headPanel:MatchingHeadPanel = null;
         var userID:uint = param1;
         if(this._redHash.containsKey(userID))
         {
            headPanel = this._redHash.remove(userID);
            headPanel.destory();
            DisplayUtil.removeAllChild(this._redCon);
            this._redHash.getValues().forEach(function(param1:MatchingHeadPanel, param2:int, param3:Array):void
            {
               param1.updatePos();
            });
         }
         if(this._blueHash.containsKey(userID))
         {
            headPanel = this._blueHash.remove(userID);
            headPanel.destory();
            DisplayUtil.removeAllChild(this._blueCon);
            this._blueHash.getValues().forEach(function(param1:MatchingHeadPanel, param2:int, param3:Array):void
            {
               param1.updatePos();
            });
         }
      }
      
      private function onCloseHandler(param1:MouseEvent) : void
      {
         CityWarManager.instance.quit();
         CityWarMatchingPanel.destroy();
         FocusManager.setDefaultFocus();
      }
      
      public function destroy() : void
      {
         MainManager.openOperate();
         SocketConnection.send(CommandID.MAP_PLAYERLIST);
         DisplayUtil.removeForParent(this._mainUI);
         this._redHash.getValues().forEach(function(param1:MatchingHeadPanel, param2:int, param3:Array):void
         {
            param1.destory();
            param1 = null;
         });
         this._redHash.clear();
         this._redHash = null;
         this._redCon = null;
         this._blueHash.getValues().forEach(function(param1:MatchingHeadPanel, param2:int, param3:Array):void
         {
            param1.destory();
            param1 = null;
         });
         this._blueHash.clear();
         this._blueHash = null;
         this._blueCon = null;
         this._closeBtn.removeEventListener(MouseEvent.CLICK,this.onCloseHandler);
         this._mainUI = null;
      }
   }
}

