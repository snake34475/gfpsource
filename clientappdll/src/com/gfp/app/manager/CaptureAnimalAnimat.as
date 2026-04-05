package com.gfp.app.manager
{
   import com.gfp.core.action.BaseAction;
   import com.gfp.core.config.xml.ActionXMLInfo;
   import com.gfp.core.events.SummonEvent;
   import com.gfp.core.manager.MainManager;
   import com.gfp.core.manager.SummonManager;
   import com.gfp.core.map.MapManager;
   import com.gfp.core.model.UserModel;
   import com.gfp.core.ui.alert.TextAlert;
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.geom.Point;
   import org.taomee.utils.Delegate;
   import org.taomee.utils.DisplayUtil;
   
   public class CaptureAnimalAnimat
   {
      
      private static const speed:int = 10;
      
      public var domesticatedSuccessMc:MovieClip;
      
      public var domesticatedfailedMc:MovieClip;
      
      public var domesticatedCageMc:MovieClip;
      
      public var flyMc:MovieClip;
      
      public var hasCurMc:Boolean;
      
      public var isdomesticatedSuccessed:Boolean;
      
      public var isOtherPeople:Boolean;
      
      public var isInstance:Boolean;
      
      private var _user:*;
      
      private var _summon:UserModel;
      
      public function CaptureAnimalAnimat(param1:*, param2:UserModel, param3:Boolean, param4:Boolean)
      {
         super();
         if(param4 == true)
         {
            this.domesticatedSuccessMc = new UI_CatchAnimalSuccess();
            this.domesticatedfailedMc = new UI_SummonLoseMC();
            this.domesticatedCageMc = new UI_SummonCatchedMC();
            this.flyMc = new UI_CatchSummonMC();
         }
         this._user = param1;
         this._summon = param2;
         if(this._summon.pos == null)
         {
         }
         if(!param3)
         {
            this.addEvent();
         }
      }
      
      private function addEvent() : void
      {
         SummonManager.addEventListener(SummonEvent.SUMMON_CATCH_COMPLETE,this.onSummonCatchComplete);
         SummonManager.addEventListener(SummonEvent.SUMMON_CATCH_FAILED,this.onSummonFailed);
      }
      
      private function onSummonFailed(param1:SummonEvent) : void
      {
         this.isdomesticatedSuccessed = false;
         this.flyFromFixedToMoved();
      }
      
      private function onSummonCatchComplete(param1:SummonEvent) : void
      {
         if(SummonTalkInTollgate.TOLLGAGE_ID.indexOf(MainManager.pveTollgateId) != -1)
         {
            SummonTalkInTollgate.instance.showTalk(11);
         }
         this.isdomesticatedSuccessed = true;
         this.flyFromFixedToMoved();
      }
      
      public function flyFromFixedToMoved() : void
      {
         if(this.hasCurMc)
         {
            TextAlert.show("仙兽正在被驯化，请小侠士耐心等待！");
            return;
         }
         if(this._summon == null)
         {
            return;
         }
         var _loc1_:Point = new Point(this._user.x,this._user.y);
         this.flyMc.play();
         this.flyMc.x = _loc1_.x;
         this.flyMc.y = _loc1_.y;
         this.hasCurMc = true;
         MapManager.currentMap.contentLevel.addChild(this.flyMc);
         if(!this.flyMc.hasEventListener(Event.ENTER_FRAME))
         {
            this.flyMc.addEventListener(Event.ENTER_FRAME,this.onEnterFlyMcFrameNew);
         }
      }
      
      private function onEnterFlyMcFrameNew(param1:Event) : void
      {
         var _loc3_:Point = null;
         if(this._summon == null || this._summon.pos == null)
         {
            this.flyMc.removeEventListener(Event.ENTER_FRAME,this.onEnterFlyMcFrameNew);
            DisplayUtil.removeForParent(this.flyMc);
            return;
         }
         var _loc2_:Point = new Point(this._summon.x - this.flyMc.x,this._summon.y - this.flyMc.y);
         _loc2_.normalize(1);
         this.flyMc.x += 10 * _loc2_.x;
         this.flyMc.y += 10 * _loc2_.y;
         if(Point.distance(new Point(this.flyMc.x,this.flyMc.y),new Point(this._summon.x,this._summon.y)) < 20)
         {
            this.flyMc.removeEventListener(Event.ENTER_FRAME,this.onEnterFlyMcFrameNew);
            DisplayUtil.removeForParent(this.flyMc);
            _loc3_ = new Point(this._summon.x,this._summon.y);
            if(this.isdomesticatedSuccessed)
            {
               this.animatSuccess(_loc3_);
            }
            else
            {
               this.animatFailed(_loc3_);
            }
         }
      }
      
      private function animatSuccess(param1:Point) : void
      {
         MapManager.currentMap.contentLevel.addChild(this.domesticatedSuccessMc);
         this.domesticatedSuccessMc.x = param1.x;
         this.domesticatedSuccessMc.y = param1.y;
         this.domesticatedSuccessMc.gotoAndPlay(1);
         var _loc2_:Object = {};
         _loc2_.point = param1;
         var _loc3_:Function = Delegate.create(this.onSuccessedAnimat,_loc2_);
         _loc2_.func = _loc3_;
         this.domesticatedSuccessMc.addEventListener(Event.ENTER_FRAME,_loc3_);
      }
      
      private function onSuccessedAnimat(param1:Event, param2:Object) : void
      {
         var _loc3_:Point = param2.point;
         if(this._summon == null || this.domesticatedSuccessMc == null)
         {
            this.domesticatedSuccessMc.removeEventListener(Event.ENTER_FRAME,param2.func);
            return;
         }
         if(this.domesticatedSuccessMc.currentFrame == this.domesticatedSuccessMc.totalFrames)
         {
            this.domesticatedSuccessMc.removeEventListener(Event.ENTER_FRAME,param2.func);
            MapManager.currentMap.contentLevel.removeChild(this.domesticatedSuccessMc);
            MapManager.currentMap.contentLevel.addChild(this.domesticatedCageMc);
            this.domesticatedCageMc.x = _loc3_.x;
            this.domesticatedCageMc.y = _loc3_.y;
            this.cageFlyformFixedPointToUser();
         }
      }
      
      private function cageFlyformFixedPointToUser() : void
      {
         this.domesticatedCageMc.addEventListener(Event.ENTER_FRAME,this.onEnterCageFlyMcFrame);
      }
      
      private function onEnterCageFlyMcFrame(param1:Event) : void
      {
         var _loc2_:Point = new Point(this._user.pos.x - this.domesticatedCageMc.x,this._user.pos.y - this.domesticatedCageMc.y);
         _loc2_.normalize(1);
         this.domesticatedCageMc.x += 10 * _loc2_.x;
         this.domesticatedCageMc.y += 10 * _loc2_.y;
         this._summon.x = this.domesticatedCageMc.x;
         this._summon.y = this.domesticatedCageMc.y;
         if(Point.distance(new Point(this.domesticatedCageMc.x,this.domesticatedCageMc.y),new Point(this._user.pos.x,this._user.pos.y)) < 20)
         {
            this.domesticatedCageMc.removeEventListener(Event.ENTER_FRAME,this.onEnterCageFlyMcFrame);
            DisplayUtil.removeForParent(this.domesticatedCageMc);
            this.destorySummon(this._summon);
            this._summon = null;
            this.hasCurMc = false;
         }
      }
      
      private function destorySummon(param1:UserModel) : void
      {
         param1.hide();
      }
      
      private function animatFailed(param1:Point) : void
      {
         MapManager.currentMap.contentLevel.addChild(this.domesticatedfailedMc);
         this._summon.execAction(new BaseAction(ActionXMLInfo.getInfo(40008),false));
         this.domesticatedfailedMc.x = param1.x;
         this.domesticatedfailedMc.y = param1.y;
         this.domesticatedfailedMc.addEventListener(Event.ENTER_FRAME,this.onFailedAnimatEnd);
      }
      
      private function onFailedAnimatEnd(param1:Event) : void
      {
         if(this.domesticatedfailedMc.currentFrame == this.domesticatedfailedMc.totalFrames)
         {
            this.domesticatedfailedMc.removeEventListener(Event.ENTER_FRAME,this.onFailedAnimatEnd);
            MapManager.currentMap.contentLevel.removeChild(this.domesticatedfailedMc);
            this.hasCurMc = false;
         }
      }
      
      public function destory() : void
      {
         SummonManager.removeEventListener(SummonEvent.SUMMON_CATCH_COMPLETE,this.onSummonCatchComplete);
         SummonManager.removeEventListener(SummonEvent.SUMMON_CATCH_FAILED,this.onSummonFailed);
         if(this.flyMc)
         {
            this.flyMc.removeEventListener(Event.ENTER_FRAME,this.onEnterFlyMcFrameNew);
         }
         if(this.domesticatedCageMc)
         {
            this.domesticatedCageMc.removeEventListener(Event.ENTER_FRAME,this.onEnterCageFlyMcFrame);
         }
         this.domesticatedSuccessMc = null;
         this.domesticatedfailedMc = null;
         this.domesticatedCageMc = null;
         this.flyMc = null;
         if(this._summon != null)
         {
            this.destorySummon(this._summon);
         }
      }
   }
}

