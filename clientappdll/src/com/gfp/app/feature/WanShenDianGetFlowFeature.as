package com.gfp.app.feature
{
   import com.gfp.core.manager.ActivityExchangeCommander;
   import com.gfp.core.manager.ActivityExchangeTimesManager;
   import com.gfp.core.manager.AlertManager;
   import com.gfp.core.manager.UIManager;
   import com.gfp.core.map.MapManager;
   import com.greensock.TweenLite;
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.geom.Point;
   import flash.utils.clearTimeout;
   import flash.utils.setTimeout;
   import org.taomee.manager.ToolTipManager;
   import org.taomee.utils.DisplayUtil;
   
   public class WanShenDianGetFlowFeature
   {
      
      private const SWAP_ID:Array = [0,0];
      
      private var flowersPoint:Array = [new Point(296,731),new Point(582,852),new Point(924,1004),new Point(1126,426),new Point(1574,640)];
      
      private var _flowers:Vector.<MovieClip> = new Vector.<MovieClip>();
      
      private var flowersPointOther:Array = [new Point(296,731),new Point(582,852),new Point(924,1004),new Point(1126,426),new Point(1574,640)];
      
      private var _flowersOther:Vector.<MovieClip> = new Vector.<MovieClip>();
      
      public function WanShenDianGetFlowFeature()
      {
         super();
         this.init();
         this.addEvent();
      }
      
      public function init() : void
      {
         var _loc1_:Point = null;
         var _loc2_:MovieClip = null;
         for each(_loc1_ in this.flowersPoint)
         {
            _loc2_ = UIManager.getMovieClip("UI_GetTrueFlower");
            _loc2_.x = _loc1_.x;
            _loc2_.y = _loc1_.y;
            _loc2_.buttonMode = true;
            _loc2_.useHandCursor = true;
            ToolTipManager.add(_loc2_,"采集物1号");
            MapManager.currentMap.contentLevel.addChild(_loc2_);
            this._flowers.push(_loc2_);
         }
         for each(_loc1_ in this.flowersPointOther)
         {
            _loc2_ = UIManager.getMovieClip("UI_GetTrueFlower");
            _loc2_.x = _loc1_.x;
            _loc2_.y = _loc1_.y;
            _loc2_.buttonMode = true;
            _loc2_.useHandCursor = true;
            ToolTipManager.add(_loc2_,"采集物二号");
            MapManager.currentMap.contentLevel.addChild(_loc2_);
            this._flowersOther.push(_loc2_);
         }
      }
      
      private function getCurrentCount() : int
      {
         return ActivityExchangeTimesManager.getTimes(this.SWAP_ID[0]) + ActivityExchangeTimesManager.getTimes(this.SWAP_ID[1]);
      }
      
      public function handleFlower(param1:MovieClip) : void
      {
         if(this.getCurrentCount() >= 20)
         {
            AlertManager.showSimpleAlarm("小侠士体力有限，每天只能采摘20次哦！请明天再来吧。");
            return;
         }
         param1.isClicking = true;
         var _loc2_:MovieClip = UIManager.getMovieClip("ReapAnimation");
         _loc2_.addEventListener(Event.ENTER_FRAME,this.onAnimation);
         _loc2_.x = param1.x;
         _loc2_.y = param1.y - 50;
         _loc2_.gotoAndPlay(2);
         _loc2_.model = param1;
         MapManager.currentMap.contentLevel.addChild(_loc2_);
      }
      
      private function onAnimation(param1:Event) : void
      {
         var _loc2_:MovieClip = param1.currentTarget as MovieClip;
         if(_loc2_.currentFrame == _loc2_.totalFrames - 20)
         {
            _loc2_.removeEventListener(Event.ENTER_FRAME,this.onAnimation);
            if(_loc2_)
            {
               _loc2_.stop();
               if(_loc2_.parent)
               {
                  _loc2_.parent.removeChild(_loc2_);
               }
               this.doGetFlower(_loc2_.model);
               _loc2_.model = null;
               delete _loc2_.model;
            }
         }
      }
      
      private function doGetFlower(param1:MovieClip) : void
      {
         var swapId:int = 0;
         var timer:int = 0;
         var sprite:MovieClip = param1;
         if(this._flowers.indexOf(sprite) != -1)
         {
            swapId = int(this.SWAP_ID[0]);
         }
         else if(this._flowersOther.indexOf(sprite) != -1)
         {
            swapId = int(this.SWAP_ID[1]);
         }
         if(swapId == 0)
         {
            return;
         }
         ActivityExchangeCommander.exchange(swapId);
         TweenLite.to(sprite,0.5,{
            "alpha":0,
            "onComplete":function():void
            {
               sprite.visible = false;
            }
         });
         timer = int(setTimeout(function(param1:MovieClip):void
         {
            param1.alpha = 1;
            param1.visible = true;
            param1.isClicking = false;
            clearTimeout(timer);
         },30000,sprite));
      }
      
      public function destory() : void
      {
         var _loc1_:MovieClip = null;
         this.removeEvent();
         for each(_loc1_ in this._flowers)
         {
            ToolTipManager.remove(_loc1_);
            DisplayUtil.removeForParent(_loc1_);
         }
         for each(_loc1_ in this._flowersOther)
         {
            ToolTipManager.remove(_loc1_);
            DisplayUtil.removeForParent(_loc1_);
         }
      }
      
      private function addEvent() : void
      {
         var _loc1_:MovieClip = null;
         for each(_loc1_ in this._flowers)
         {
            _loc1_.addEventListener(MouseEvent.CLICK,this.onFlowerClick);
         }
         for each(_loc1_ in this._flowersOther)
         {
            _loc1_.addEventListener(MouseEvent.CLICK,this.onFlowerClick);
         }
      }
      
      private function removeEvent() : void
      {
         var _loc1_:MovieClip = null;
         for each(_loc1_ in this._flowers)
         {
            _loc1_.removeEventListener(MouseEvent.CLICK,this.onFlowerClick);
         }
         for each(_loc1_ in this._flowersOther)
         {
            _loc1_.removeEventListener(MouseEvent.CLICK,this.onFlowerClick);
         }
      }
      
      private function onFlowerClick(param1:MouseEvent) : void
      {
         var _loc2_:MovieClip = param1.currentTarget as MovieClip;
         if(!_loc2_.isClicking)
         {
            this.handleFlower(_loc2_);
         }
      }
   }
}

