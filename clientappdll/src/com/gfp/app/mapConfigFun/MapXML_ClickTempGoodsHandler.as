package com.gfp.app.mapConfigFun
{
   import com.gfp.app.control.SystemTimeController;
   import com.gfp.app.fight.PveEntry;
   import com.gfp.core.events.MapEvent;
   import com.gfp.core.manager.UIManager;
   import com.gfp.core.map.IMapConfigFun;
   import com.gfp.core.map.MapManager;
   import com.gfp.core.model.sensemodels.SightModel;
   import flash.display.MovieClip;
   import flash.events.Event;
   
   public class MapXML_ClickTempGoodsHandler implements IMapConfigFun
   {
      
      private static var _animation:MovieClip;
      
      private static var _openSm:SightModel;
      
      private const TOTALLY_ANIMATION:String = "totally_animation";
      
      private var _type:String;
      
      private var _xmlData:Array;
      
      private var _tollgateID:uint;
      
      private var _tollgateEnterTimeID:uint;
      
      public function MapXML_ClickTempGoodsHandler()
      {
         super();
         MapManager.addEventListener(MapEvent.MAP_DESTROY,this.onMapDestroy);
      }
      
      public function exec(param1:SightModel, param2:XML, param3:XMLList) : void
      {
         _openSm = param1;
         var _loc4_:XML = param2.child("aim")[0];
         this._type = _loc4_.@type;
         this._xmlData = _loc4_.toString().split(",");
         this.parseData();
      }
      
      private function parseData() : void
      {
         switch(this._type)
         {
            case this.TOTALLY_ANIMATION:
               this._tollgateID = uint(this._xmlData[0]);
               this._tollgateEnterTimeID = uint(this._xmlData[1]);
               this.onTotallyAnimation();
         }
      }
      
      private function onTotallyAnimation() : void
      {
         this.playReapLoadAnimation();
      }
      
      private function anmationPlayEnd() : void
      {
         switch(this._type)
         {
            case this.TOTALLY_ANIMATION:
               this.enterTollgateID();
         }
      }
      
      private function enterTollgateID() : void
      {
         if(this._tollgateEnterTimeID != 0)
         {
            if(SystemTimeController.instance.checkSysTimeAchieve(this._tollgateEnterTimeID))
            {
               PveEntry.instance.enterTollgate(this._tollgateID);
            }
            else
            {
               SystemTimeController.instance.showOutTimeAlert(this._tollgateEnterTimeID);
            }
         }
         else
         {
            PveEntry.instance.enterTollgate(this._tollgateID);
         }
      }
      
      public function playReapLoadAnimation() : void
      {
         if(_animation == null)
         {
            _animation = UIManager.getMovieClip("ReapAnimation");
            new ReapAnimation();
         }
         _animation.x = _openSm.x - 20;
         _animation.y = _openSm.y - _openSm.height - 20;
         MapManager.currentMap.contentLevel.addChild(_animation);
         _animation.gotoAndPlay(2);
         if(_animation.hasEventListener(Event.ENTER_FRAME))
         {
            _animation.removeEventListener(Event.ENTER_FRAME,this.onEnterFrameAnimation);
         }
         else
         {
            _animation.addEventListener(Event.ENTER_FRAME,this.onEnterFrameAnimation);
         }
      }
      
      private function onEnterFrameAnimation(param1:Event) : void
      {
         if(_animation.currentFrame == _animation.totalFrames - 20)
         {
            _animation.removeEventListener(Event.ENTER_FRAME,this.onEnterFrameAnimation);
            if(_animation)
            {
               _animation.stop();
               if(_animation.parent)
               {
                  _animation.parent.removeChild(_animation);
               }
               this.anmationPlayEnd();
            }
         }
      }
      
      private function onMapDestroy(param1:MapEvent) : void
      {
         MapManager.removeEventListener(MapEvent.MAP_DESTROY,this.onMapDestroy);
         _openSm = null;
         if(_animation)
         {
            _animation.stop();
            if(_animation.hasEventListener(Event.ENTER_FRAME))
            {
               _animation.removeEventListener(Event.ENTER_FRAME,this.onEnterFrameAnimation);
            }
         }
         _animation = null;
      }
   }
}

