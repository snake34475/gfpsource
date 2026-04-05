package com.gfp.app.ui.activity
{
   import com.gfp.app.info.ActivityNodeInfo;
   import com.gfp.app.toolBar.DynamicActivityEntry;
   import com.gfp.core.controller.StageResizeController;
   import com.gfp.core.manager.ActivityExchangeTimesManager;
   import com.gfp.core.manager.MainManager;
   import com.gfp.core.manager.ModuleManager;
   import com.gfp.core.manager.SOManager;
   import com.gfp.core.manager.TasksManager;
   import com.gfp.core.manager.TimeChangeManager;
   import com.gfp.core.map.CityMap;
   import com.gfp.core.player.MovieClipPlayerEx;
   import com.gfp.core.utils.DisplayObjectFlashUtil;
   import com.gfp.core.utils.StatisticsUtil;
   import flash.display.DisplayObject;
   import flash.display.DisplayObjectContainer;
   import flash.display.InteractiveObject;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.net.SharedObject;
   import org.taomee.player.data.FrameInfo;
   import org.taomee.utils.DisplayUtil;
   
   public class BaseActivitySprite extends Sprite
   {
      
      private static var _systemEffectData:Vector.<FrameInfo>;
      
      protected static const SYSTEM_EFFECT_ID:int = 99;
      
      protected static const SHOW_PROMPT_EFFECT:String = "SHOW_PROMPT_EFFECT";
      
      protected static const HIDE_PROMPT_EFFECT:String = "HIDE_PROMPT_EFFECT";
      
      protected var _info:ActivityNodeInfo;
      
      protected var _sprite:InteractiveObject;
      
      private var _yuanjian:MovieClip;
      
      private var _effects:Vector.<MovieClipPlayerEx>;
      
      protected var _hasProptEffect:Boolean = true;
      
      protected var _withinTime:Boolean;
      
      public function BaseActivitySprite(param1:ActivityNodeInfo)
      {
         super();
         this._info = param1;
         this.createChildren();
         this._withinTime = param1.withinTime;
         this.addEvent();
      }
      
      protected static function get systemEffectData() : Vector.<FrameInfo>
      {
         if(_systemEffectData == null)
         {
            _systemEffectData = DisplayObjectFlashUtil.generalFrameInfo(DynamicActivityEntry.getIconAggregateMc()["systemEffect"] as MovieClip,1,1);
         }
         return _systemEffectData;
      }
      
      public function get id() : uint
      {
         return this._info.id;
      }
      
      override public function get width() : Number
      {
         if(this._info.width > 0)
         {
            return this._info.width;
         }
         return super.width;
      }
      
      override public function get height() : Number
      {
         if(this._info.height > 0)
         {
            return this._info.height;
         }
         return super.height;
      }
      
      protected function createChildren() : void
      {
         var _loc1_:MovieClip = null;
         var _loc2_:SharedObject = null;
         if(this.info.uiClass)
         {
            _loc1_ = DynamicActivityEntry.getIconAggregateMc();
            this._sprite = _loc1_[this.info.uiClass] as InteractiveObject;
            this._sprite.x = this._sprite.y = 0;
            addChild(this._sprite);
         }
         this.x = this.info.x;
         this.y = this.info.y;
         this.createPlayer();
         if(this.info.oneShot)
         {
            _loc2_ = SOManager.getActorSO("gf_dynamic_entry/" + this.info.oneShotKey + "/" + this.info.params);
            if(_loc2_.data.shot == true)
            {
               this.hideProptEffect();
               this._hasProptEffect = false;
            }
            else
            {
               this._hasProptEffect = true;
               dispatchEvent(new Event(SHOW_PROMPT_EFFECT));
            }
         }
      }
      
      protected function resetPromptEffect() : void
      {
         if(this.hasProptEffect())
         {
            this.showProptEffect();
         }
         else
         {
            this.hideProptEffect();
         }
      }
      
      protected function showProptEffect() : void
      {
         var _loc1_:MovieClipPlayerEx = null;
         for each(_loc1_ in this._effects)
         {
            _loc1_.play();
            _loc1_.visible = true;
         }
      }
      
      protected function hideProptEffect() : void
      {
         var _loc1_:MovieClipPlayerEx = null;
         for each(_loc1_ in this._effects)
         {
            _loc1_.stop();
            _loc1_.visible = false;
         }
      }
      
      public function hasProptEffect() : Boolean
      {
         return this._hasProptEffect;
      }
      
      public function get sprite() : DisplayObject
      {
         var _loc1_:MovieClip = null;
         if(this._sprite)
         {
            return this._sprite as MovieClip;
         }
         return null;
      }
      
      protected function createPlayer() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         var _loc3_:MovieClipPlayerEx = null;
         var _loc4_:DisplayObject = null;
         if(this._sprite is MovieClip)
         {
            this._effects = new Vector.<MovieClipPlayerEx>();
            if(this._info.hasSystemEffect)
            {
               _loc3_ = new MovieClipPlayerEx(systemEffectData);
               _loc3_.id = SYSTEM_EFFECT_ID;
               _loc3_.mouseChildren = false;
               _loc3_.mouseEnabled = false;
               _loc3_.play();
               (this._sprite as DisplayObjectContainer).addChild(_loc3_);
               this._effects.push(_loc3_);
            }
            _loc1_ = (this._sprite as MovieClip).numChildren;
            _loc2_ = 0;
            while(_loc2_ < _loc1_)
            {
               _loc4_ = (this._sprite as MovieClip).getChildAt(_loc2_);
               this.handleEffectChild(_loc4_ as MovieClip);
               this._yuanjian = _loc4_ as MovieClip;
               _loc2_++;
            }
         }
      }
      
      public function get yuanjian() : MovieClip
      {
         return this._yuanjian;
      }
      
      private function handleEffectChild(param1:MovieClip) : void
      {
         var _loc2_:String = null;
         var _loc3_:Array = null;
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         var _loc6_:MovieClipPlayerEx = null;
         if(param1)
         {
            _loc2_ = param1.name;
            if(_loc2_.indexOf("effectbmp") == 0)
            {
               _loc3_ = _loc2_.split("_");
               if(_loc3_.length >= 2)
               {
                  _loc4_ = parseInt(_loc3_[1]);
               }
               if(_loc4_)
               {
                  _loc5_ = param1.parent.getChildIndex(param1);
                  _loc6_ = new MovieClipPlayerEx(param1);
                  param1.parent.addChildAt(_loc6_,_loc5_);
                  _loc6_.x = param1.x;
                  _loc6_.y = param1.y;
                  _loc6_.name = param1.name;
                  _loc6_.id = _loc4_;
                  _loc6_.mouseChildren = false;
                  _loc6_.mouseEnabled = false;
                  _loc6_.play();
                  this._effects.push(_loc6_);
                  DisplayUtil.removeForParent(param1);
               }
            }
         }
      }
      
      override public function set visible(param1:Boolean) : void
      {
         if(param1 != visible)
         {
            super.visible = param1;
            if(param1)
            {
               this.show();
            }
            else
            {
               this.hide();
            }
         }
      }
      
      public function getEffect(param1:int) : MovieClipPlayerEx
      {
         var _loc2_:MovieClipPlayerEx = null;
         if(this._effects)
         {
            for each(_loc2_ in this._effects)
            {
               if(_loc2_.id == param1)
               {
                  return _loc2_;
               }
            }
         }
         return null;
      }
      
      public function destoryEffect(param1:int) : void
      {
         var _loc3_:int = 0;
         var _loc2_:MovieClipPlayerEx = this.getEffect(param1);
         if(_loc2_)
         {
            _loc3_ = this._effects.indexOf(_loc2_);
            if(_loc3_ != -1)
            {
               this._effects.splice(_loc3_,1);
               _loc2_.destory();
            }
         }
      }
      
      private function show() : void
      {
         this.addEvent();
         if(this._sprite)
         {
            addChild(this._sprite);
         }
         this.resetPromptEffect();
      }
      
      private function hide() : void
      {
         var _loc1_:MovieClipPlayerEx = null;
         this.removeEvent();
         DisplayUtil.removeForParent(this._sprite,false);
         if(this._effects)
         {
            for each(_loc1_ in this._effects)
            {
               _loc1_.stop();
            }
         }
      }
      
      public function resetPostion() : void
      {
         if(!this._info.isAlign)
         {
            x = this._info.rectInfo.x;
            y = this._info.rectInfo.y;
         }
      }
      
      public function addEvent() : void
      {
         this.addEventListener(MouseEvent.CLICK,this.onMouseClick);
         if(!this.info.isAlign)
         {
            StageResizeController.instance.register(this.resetPostion);
         }
         if(this.info.limitedTime)
         {
            TimeChangeManager.getInstance().addEventListener(TimeChangeManager.MINUTE_CHANGE,this.minuteChangeHandle);
         }
      }
      
      protected function minuteChangeHandle(param1:Event) : void
      {
         var _loc2_:Boolean = this.info.withinTime;
         if(this._withinTime != _loc2_)
         {
            DynamicActivityEntry.instance.updateAlign();
            this._withinTime = _loc2_;
         }
      }
      
      public function removeEvent() : void
      {
         StageResizeController.instance.unregister(this.resetPostion);
         this.removeEventListener(MouseEvent.CLICK,this.onMouseClick);
         TimeChangeManager.getInstance().removeEventListener(TimeChangeManager.MINUTE_CHANGE,this.minuteChangeHandle);
      }
      
      public function destroy() : void
      {
         this.hide();
         this.destroyAllEffect();
      }
      
      public function executeShow() : Boolean
      {
         var _loc1_:Array = null;
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         if(MainManager.actorInfo.lv < 80 && this.info.unlockTaskID > 0 && TasksManager.isCompleted(this.info.unlockTaskID) == false)
         {
            return false;
         }
         if(MainManager.actorInfo.isTurnBack)
         {
            if(Boolean(this.info.minLevel2) && Boolean(this.info.maxLevel2))
            {
               if(MainManager.actorInfo.lv < this.info.minLevel2 || MainManager.actorInfo.lv > this.info.maxLevel2)
               {
                  return false;
               }
            }
         }
         if(!MainManager.actorInfo.isTurnBack)
         {
            if(Boolean(this.info.minLevel1) && Boolean(this.info.maxLevel1))
            {
               if(MainManager.actorInfo.lv < this.info.minLevel1 || MainManager.actorInfo.lv > this.info.maxLevel1)
               {
                  return false;
               }
            }
         }
         if(this.info.limitedTime && this.info.withinTime == false)
         {
            return false;
         }
         switch(this.info.uiClass)
         {
            case "UI_NewsTeiHuiButton":
               _loc1_ = [5468,5469,5470,5471,5472,5473,5474,5475,5476];
               for each(_loc2_ in _loc1_)
               {
                  if(ActivityExchangeTimesManager.getTimes(_loc2_) == 0)
                  {
                     return true;
                  }
               }
               return false;
            case "UI_QuickTurnButton":
               return MainManager.actorInfo.lv >= 30 && MainManager.actorInfo.isTurnBack == false;
            case "ToolBar_FeiSuShengJi":
               if(MainManager.actorInfo.lv <= 80)
               {
                  _loc3_ = DynamicActivityEntry.TempExpNums;
                  if(_loc3_ > 0)
                  {
                     this._sprite["mcInfo"].visible = true;
                     this._sprite["mcInfo"]["numTxt"].text = _loc3_.toString();
                  }
                  else
                  {
                     this._sprite["mcInfo"].visible = false;
                  }
               }
               return MainManager.actorInfo.lv <= 80;
            default:
               return true;
         }
      }
      
      private function onMouseClick(param1:MouseEvent) : void
      {
         var _loc2_:SharedObject = null;
         StatisticsUtil.sendStatistics(this._info.id + 100);
         this.doAction();
         if(this.info.parentNode)
         {
            param1.stopPropagation();
         }
         if(this.info.oneShot)
         {
            this.destroyAllEffect();
            _loc2_ = SOManager.getActorSO("gf_dynamic_entry/" + this.info.oneShotKey + "/" + this.info.params);
            if(Boolean(_loc2_.data.shot) == false)
            {
               _loc2_.data.shot = true;
               _loc2_.flush();
               this._hasProptEffect = false;
               dispatchEvent(new Event(HIDE_PROMPT_EFFECT));
            }
         }
      }
      
      protected function destroyAllEffect() : void
      {
         var _loc1_:MovieClipPlayerEx = null;
         if(this._effects)
         {
            while(this._effects.length)
            {
               _loc1_ = this._effects.pop();
               if(_loc1_.id != SYSTEM_EFFECT_ID)
               {
                  _loc1_.destory();
               }
               else
               {
                  _loc1_.stop();
               }
               DisplayUtil.removeForParent(_loc1_);
            }
         }
      }
      
      protected function doAction() : void
      {
         if(this.info.type == ActivityNodeInfo.TYPE_TRANSFER)
         {
            CityMap.instance.tranChangeMapByStr(this.info.params);
         }
         else if(this.info.type == ActivityNodeInfo.TYPE_OPEN_MODULE)
         {
            if(this.info.appenddata)
            {
               ModuleManager.turnAppModule(this.info.params,"正在加载...",int(this.info.appenddata));
            }
            else
            {
               ModuleManager.turnAppModule(this.info.params);
            }
         }
      }
      
      public function get info() : ActivityNodeInfo
      {
         return this._info;
      }
   }
}

