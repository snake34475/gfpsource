package com.gfp.app.feature
{
   import com.gfp.app.cartoon.AnimationHelper;
   import com.gfp.app.fight.PveEntry;
   import com.gfp.core.CommandID;
   import com.gfp.core.manager.ActivityExchangeTimesManager;
   import com.gfp.core.manager.AlertManager;
   import com.gfp.core.manager.MainManager;
   import com.gfp.core.manager.UIManager;
   import com.gfp.core.map.CityMap;
   import com.gfp.core.map.MapManager;
   import com.gfp.core.net.SocketConnection;
   import com.greensock.TweenLite;
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.geom.Point;
   import flash.utils.ByteArray;
   import flash.utils.setTimeout;
   import org.taomee.manager.ToolTipManager;
   import org.taomee.net.SocketEvent;
   import org.taomee.utils.DisplayUtil;
   
   public class GetFlowFeature
   {
      
      private static const MAP_ID:int = 1053;
      
      private const SWAP_ID:int = 3236;
      
      private var flowersPoint:Array = [new Point(296,731),new Point(582,852),new Point(924,1004),new Point(1126,426),new Point(1574,640)];
      
      private var flowers:Vector.<MovieClip> = new Vector.<MovieClip>();
      
      private var flowerTimer:int;
      
      public function GetFlowFeature()
      {
         super();
         this.init();
         this.addEvent();
      }
      
      public static function setup() : void
      {
         if(MainManager.actorInfo.lv < 30)
         {
            AlertManager.showSimpleAlarm("前方有危险，小侠士30级再来吧。");
            return;
         }
         if(MapManager.currentMap.info.id != MAP_ID)
         {
            CityMap.instance.changeMap(MAP_ID);
            return;
         }
         AlertManager.showSimpleAlarm("小侠士，您已经在东篱场景中了哦。");
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
            ToolTipManager.add(_loc2_,"小雏菊");
            MapManager.currentMap.contentLevel.addChild(_loc2_);
            this.flowers.push(_loc2_);
         }
      }
      
      public function handleFlower(param1:MovieClip) : void
      {
         if(ActivityExchangeTimesManager.getTimes(this.SWAP_ID) >= 10)
         {
            AlertManager.showSimpleAlarm("小侠士体力有限，每天只能采摘10次哦！请明天再来吧。");
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
         var timer:int;
         var sprite:MovieClip = param1;
         SocketConnection.send(CommandID.GET_FLOWER_RESULT);
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
         },30000,sprite));
         ActivityExchangeTimesManager.updataTimesByOnce(this.SWAP_ID);
      }
      
      public function destory() : void
      {
         var _loc1_:MovieClip = null;
         this.removeEvent();
         for each(_loc1_ in this.flowers)
         {
            ToolTipManager.remove(_loc1_);
            DisplayUtil.removeForParent(_loc1_);
         }
      }
      
      private function addEvent() : void
      {
         var _loc1_:MovieClip = null;
         for each(_loc1_ in this.flowers)
         {
            _loc1_.addEventListener(MouseEvent.CLICK,this.onFlowerClick);
         }
         SocketConnection.addCmdListener(CommandID.GET_FLOWER_RESULT,this.onFlowerResult);
      }
      
      private function removeEvent() : void
      {
         var _loc1_:MovieClip = null;
         for each(_loc1_ in this.flowers)
         {
            _loc1_.removeEventListener(MouseEvent.CLICK,this.onFlowerClick);
         }
         SocketConnection.removeCmdListener(CommandID.GET_FLOWER_RESULT,this.onFlowerResult);
      }
      
      private function onFlowerResult(param1:SocketEvent) : void
      {
         var awardAnm:AnimationHelper = null;
         var fightAnm:AnimationHelper = null;
         var e:SocketEvent = param1;
         var data:ByteArray = e.data as ByteArray;
         var result:int = int(data.readUnsignedByte());
         if(result == 0)
         {
            awardAnm = new AnimationHelper();
            awardAnm.play("get_flower_1",null,"mc");
         }
         else if(result == 1)
         {
            fightAnm = new AnimationHelper();
            fightAnm.play("get_flower_2",function():void
            {
               PveEntry.enterTollgate(587);
            },"mc");
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

