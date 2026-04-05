package com.gfp.app.ui.activity
{
   import com.gfp.app.info.ActivityNodeInfo;
   import com.gfp.app.toolBar.DynamicActivityEntry;
   import com.gfp.core.events.ExchangeEvent;
   import com.gfp.core.events.TaskEvent;
   import com.gfp.core.events.UserEvent;
   import com.gfp.core.manager.ActivityExchangeCommander;
   import com.gfp.core.manager.ActivityExchangeTimesManager;
   import com.gfp.core.manager.MainManager;
   import com.gfp.core.manager.ModuleManager;
   import com.gfp.core.manager.TasksManager;
   import com.gfp.core.manager.UserInfoManager;
   import com.gfp.core.player.MovieClipPlayerEx;
   import flash.display.MovieClip;
   
   public class RookieTaskBtn extends BaseActivitySprite
   {
      
      private var _content:MovieClip;
      
      private var _taskIndex:int = -1;
      
      public function RookieTaskBtn(param1:ActivityNodeInfo)
      {
         super(param1);
         this._content = _sprite["content"];
         getEffect(1).stop();
         this._content.gotoAndStop(1);
         if(MainManager.actorInfo.lv < 80)
         {
            ActivityExchangeCommander.addEventListener(ExchangeEvent.EXCHANGE_COMPLETE,this.onExchangeComplete);
            TasksManager.addListener(TaskEvent.COMPLETE,this.onTaskComplete);
            UserInfoManager.ed.addEventListener(UserEvent.LVL_CHANGE,this.onLevelChange);
         }
      }
      
      private function onExchangeComplete(param1:ExchangeEvent) : void
      {
         var _loc5_:int = 0;
         var _loc2_:Boolean = false;
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         while(_loc4_ < 5)
         {
            _loc5_ = int(TasksManager.getRookieChapterSwap(_loc4_));
            if(ActivityExchangeTimesManager.getTimes(_loc5_) > 0)
            {
               _loc3_++;
            }
            if(_loc5_ == param1.info.id)
            {
               _loc2_ = true;
            }
            _loc4_++;
         }
         if(_loc2_)
         {
            DynamicActivityEntry.instance.updateAlign();
         }
         if(_loc3_ >= 5)
         {
            this.removeListeners();
         }
      }
      
      private function onTaskComplete(param1:TaskEvent) : void
      {
         var _loc3_:Array = null;
         var _loc2_:int = 0;
         while(_loc2_ < 5)
         {
            _loc3_ = TasksManager.getRookieChapterTask(_loc2_);
            if(_loc3_[_loc3_.length] == param1.taskID)
            {
               DynamicActivityEntry.instance.updateAlign();
               break;
            }
            _loc2_++;
         }
      }
      
      private function onLevelChange(param1:UserEvent) : void
      {
         if(MainManager.actorInfo.lv == 80)
         {
            this.removeListeners();
            DynamicActivityEntry.instance.updateAlign();
         }
      }
      
      private function removeListeners() : void
      {
         ActivityExchangeCommander.removeEventListener(ExchangeEvent.EXCHANGE_COMPLETE,this.onExchangeComplete);
         TasksManager.removeListener(TaskEvent.COMPLETE,this.onTaskComplete);
         UserInfoManager.ed.removeEventListener(UserEvent.LVL_CHANGE,this.onLevelChange);
      }
      
      override protected function doAction() : void
      {
         if(this._taskIndex != -1)
         {
            ModuleManager.turnAppModule("RookieChapterTask" + (this._taskIndex + 1) + "Panel");
         }
      }
      
      override public function executeShow() : Boolean
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:Array = null;
         var _loc5_:int = 0;
         var _loc6_:int = 0;
         var _loc7_:MovieClipPlayerEx = null;
         var _loc1_:Boolean = super.executeShow();
         this._taskIndex = -1;
         if(_loc1_ && MainManager.actorInfo.lv < 80)
         {
            _loc2_ = 0;
            while(_loc2_ < 5)
            {
               _loc3_ = int(TasksManager.getRookieChapterSwap(_loc2_));
               if(ActivityExchangeTimesManager.getTimes(_loc3_) <= 0)
               {
                  this._content.gotoAndStop(_loc2_ + 1);
                  _loc4_ = TasksManager.getRookieChapterTask(_loc2_);
                  _loc5_ = 0;
                  _loc6_ = 0;
                  while(_loc6_ < _loc4_.length)
                  {
                     if(TasksManager.isCompleted(_loc4_[_loc6_]))
                     {
                        _loc5_++;
                     }
                     _loc6_++;
                  }
                  _loc7_ = getEffect(1);
                  if(_loc5_ == _loc4_.length)
                  {
                     _loc7_.play();
                     _loc7_.visible = true;
                  }
                  else
                  {
                     _loc7_.stop();
                     _loc7_.visible = false;
                  }
                  this._taskIndex = _loc2_;
                  return true;
               }
               _loc2_++;
            }
         }
         return false;
      }
   }
}

