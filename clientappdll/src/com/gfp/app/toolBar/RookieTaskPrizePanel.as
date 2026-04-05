package com.gfp.app.toolBar
{
   import com.gfp.app.toolBar.chat.MultiChatPanel;
   import com.gfp.core.cache.SwfCache;
   import com.gfp.core.cache.SwfInfo;
   import com.gfp.core.config.ClientConfig;
   import com.gfp.core.controller.StageResizeController;
   import com.gfp.core.events.DataEvent;
   import com.gfp.core.events.ExchangeEvent;
   import com.gfp.core.events.UserEvent;
   import com.gfp.core.manager.ActivityExchangeCommander;
   import com.gfp.core.manager.ActivityExchangeTimesManager;
   import com.gfp.core.manager.LayerManager;
   import com.gfp.core.manager.MainManager;
   import com.gfp.core.manager.ModuleManager;
   import com.gfp.core.manager.TasksManager;
   import com.gfp.core.manager.UserManager;
   import com.greensock.TweenLite;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import org.taomee.utils.DisplayUtil;
   
   public class RookieTaskPrizePanel extends Sprite
   {
      
      private static var _instance:RookieTaskPrizePanel;
      
      private static var _showChapaterIndex:int;
      
      private var _mainUI:Sprite;
      
      public function RookieTaskPrizePanel()
      {
         super();
         if(MainManager.actorInfo.isTurnBack == false)
         {
            ActivityExchangeCommander.addEventListener(ExchangeEvent.EXCHANGE_COMPLETE,this.onExchangeComplete);
            UserManager.addEventListener(UserEvent.TURN_BACK,this.onTurnBackSuccess);
            MultiChatPanel.instance.addEventListener(MultiChatPanel.POSITION_CHANGE,this.updatePosition);
            this.addEventListener(MouseEvent.MOUSE_OVER,this.onMouseOver);
            this.addEventListener(MouseEvent.MOUSE_OUT,this.onMouseOut);
            this.creatUIAndShow();
         }
      }
      
      public static function show() : void
      {
         if(getWillShow())
         {
            if(_instance == null)
            {
               _instance = new RookieTaskPrizePanel();
            }
            LayerManager.toolsLevel.addChild(_instance);
         }
      }
      
      public static function hide() : void
      {
         if(_instance)
         {
            DisplayUtil.removeForParent(_instance,false);
         }
      }
      
      private static function getWillShow() : Boolean
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         if(MainManager.actorInfo.isTurnBack == false)
         {
            _loc1_ = 0;
            while(_loc1_ < 5)
            {
               _loc2_ = int(TasksManager.getRookieChapterSwap(_loc1_));
               if(ActivityExchangeTimesManager.getTimes(_loc2_) <= 0)
               {
                  _showChapaterIndex = Math.max(1,_loc1_);
                  return true;
               }
               _loc1_++;
            }
         }
         return false;
      }
      
      private function creatUIAndShow() : void
      {
         if(this._mainUI == null)
         {
            SwfCache.getSwfInfo(ClientConfig.getSubUI("rookie_task_prize"),this.onUILoaded);
         }
         else
         {
            this.updateUI();
         }
      }
      
      private function onUILoaded(param1:SwfInfo) : void
      {
         if(this._mainUI == null)
         {
            this._mainUI = param1.content as Sprite;
            this._mainUI["mc1"]["content"].gotoAndStop(MainManager.roleType);
            this._mainUI["mc2"]["content"].gotoAndStop(MainManager.roleType);
            this._mainUI["mc4"]["content"].gotoAndStop(MainManager.roleType);
            this.updateUI();
            addChild(this._mainUI);
            _instance.x = MultiChatPanel.instance.isChatShow == false ? 4.75 - 239.15 + 275 : 275;
            this.onMouseOut(null);
            StageResizeController.instance.register(this.layout);
            this.layout();
            this._mainUI.addEventListener(MouseEvent.CLICK,this.clickHandle);
         }
      }
      
      protected function clickHandle(param1:MouseEvent) : void
      {
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc2_:int = -1;
         if(MainManager.actorInfo.isTurnBack == false)
         {
            _loc3_ = 0;
            while(_loc3_ < 5)
            {
               if(_loc3_ == 4)
               {
                  if(MainManager.actorInfo.isTurnBack == false)
                  {
                     _loc2_ = _loc3_;
                  }
               }
               else
               {
                  _loc4_ = int(TasksManager.getRookieChapterSwap(_loc3_));
                  if(ActivityExchangeTimesManager.getTimes(_loc4_) <= 0)
                  {
                     _loc2_ = _loc3_;
                     break;
                  }
               }
               _loc3_++;
            }
         }
         if(_loc2_ > -1 && _loc2_ < 5)
         {
            ModuleManager.turnAppModule("RookieChapterTask" + (_loc2_ + 1) + "Panel");
         }
      }
      
      private function layout() : void
      {
         _instance.y = LayerManager.stageHeight - 420;
      }
      
      private function updateUI() : void
      {
         var _loc1_:int = 1;
         while(_loc1_ < 5)
         {
            if(_loc1_ == _showChapaterIndex)
            {
               this._mainUI.addChild(this._mainUI["mc" + _loc1_]);
            }
            else
            {
               DisplayUtil.removeForParent(this._mainUI["mc" + _loc1_],false);
            }
            _loc1_++;
         }
      }
      
      private function desroy() : void
      {
         this.removeListeners();
         this.destroyUI();
         _instance = null;
      }
      
      private function destroyUI() : void
      {
         if(this._mainUI)
         {
            DisplayUtil.removeAllChild(this._mainUI);
            DisplayUtil.removeForParent(this._mainUI);
            StageResizeController.instance.unregister(this.layout);
            this._mainUI.removeEventListener(MouseEvent.CLICK,this.clickHandle);
            this._mainUI = null;
         }
      }
      
      private function onExchangeComplete(param1:ExchangeEvent) : void
      {
         var _loc4_:int = 0;
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         while(_loc3_ < 5)
         {
            _loc4_ = int(TasksManager.getRookieChapterSwap(_loc3_));
            if(ActivityExchangeTimesManager.getTimes(_loc4_) > 0)
            {
               _loc2_++;
            }
            if(_loc4_ == param1.info.id)
            {
               if(getWillShow())
               {
                  this.creatUIAndShow();
               }
            }
            _loc3_++;
         }
         if(_loc2_ >= 5)
         {
            this.desroy();
         }
      }
      
      private function onTurnBackSuccess(param1:Event) : void
      {
         if(MainManager.actorInfo.isTurnBack == true)
         {
            this.desroy();
         }
      }
      
      private function updatePosition(param1:DataEvent) : void
      {
         var _loc2_:int = int(param1.data);
         _instance.x = _loc2_ + 275;
      }
      
      private function removeListeners() : void
      {
         ActivityExchangeCommander.removeEventListener(ExchangeEvent.EXCHANGE_COMPLETE,this.onExchangeComplete);
         UserManager.removeEventListener(UserEvent.TURN_BACK,this.onTurnBackSuccess);
         MultiChatPanel.instance.removeEventListener(MultiChatPanel.POSITION_CHANGE,this.updatePosition);
         this.removeEventListener(MouseEvent.MOUSE_OVER,this.onMouseOver);
         this.removeEventListener(MouseEvent.MOUSE_OUT,this.onMouseOut);
      }
      
      private function onMouseOut(param1:MouseEvent) : void
      {
         TweenLite.to(this._mainUI["background"],1,{"alpha":0.6});
      }
      
      private function onMouseOver(param1:MouseEvent) : void
      {
         TweenLite.to(this._mainUI["background"],1,{"alpha":1});
      }
   }
}

