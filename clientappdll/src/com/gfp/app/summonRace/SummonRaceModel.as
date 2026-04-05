package com.gfp.app.summonRace
{
   import com.gfp.app.config.xml.SummonRaceXMLInfo;
   import com.gfp.app.info.summonRace.RaceInfo;
   import com.gfp.app.manager.SummonRaceForecastMananger;
   import com.gfp.core.action.ActionInfo;
   import com.gfp.core.action.events.ActionEvent;
   import com.gfp.core.action.normal.MoveAction;
   import com.gfp.core.config.xml.ActionXMLInfo;
   import com.gfp.core.info.UserInfo;
   import com.gfp.core.model.UserModel;
   import com.greensock.TweenLite;
   import flash.display.DisplayObjectContainer;
   import flash.events.Event;
   import flash.geom.Point;
   import flash.utils.clearInterval;
   import flash.utils.setInterval;
   import org.taomee.utils.DisplayUtil;
   
   public class SummonRaceModel
   {
      
      private const STAGE_POS:Array = [];
      
      private var _summonID:uint;
      
      private var _userModel:UserModel;
      
      private var _intervalID:uint;
      
      private var _gameTime:uint;
      
      private var _raceInfo:RaceInfo;
      
      private var _moveAction:MoveAction;
      
      public function SummonRaceModel(param1:uint, param2:uint, param3:Point)
      {
         super();
         this._summonID = param2;
         var _loc4_:UserInfo = new UserInfo();
         _loc4_.roleType = this._summonID;
         _loc4_.pos = param3;
         this._userModel = new UserModel(_loc4_);
         this._userModel.disableUserClick = true;
         this._userModel.hideNick();
         this._userModel.speed = 1e-8;
         var _loc5_:ActionInfo = ActionXMLInfo.getInfo(10002);
         this._moveAction = new MoveAction(_loc5_,0,false);
         this._raceInfo = SummonRaceXMLInfo.getInfos(param1).getRaceInfo(this._summonID);
      }
      
      public function show(param1:DisplayObjectContainer) : void
      {
         param1.addChild(this._userModel);
         this.addEvent();
      }
      
      private function addEvent() : void
      {
         SummonRaceForecastMananger.addEventListener(SummonRaceForecastMananger.SUMMON_RACE_BEGIN,this.onRaceBegin);
         SummonRaceForecastMananger.addEventListener(SummonRaceForecastMananger.SUMMON_RACE_END,this.onRaceEnd);
      }
      
      private function removeEvent() : void
      {
         SummonRaceForecastMananger.removeEventListener(SummonRaceForecastMananger.SUMMON_RACE_BEGIN,this.onRaceBegin);
         SummonRaceForecastMananger.removeEventListener(SummonRaceForecastMananger.SUMMON_RACE_END,this.onRaceEnd);
      }
      
      private function onRaceBegin(param1:Event) : void
      {
         this._userModel.execAction(this._moveAction);
         this._intervalID = setInterval(this.onSummonMoveChannel,1000);
      }
      
      private function onActionFinished(param1:ActionEvent) : void
      {
         this._userModel.execAction(this._moveAction);
      }
      
      private function onSummonMoveChannel() : void
      {
         var _loc2_:Number = NaN;
         var _loc3_:String = null;
         var _loc4_:int = 0;
         ++this._gameTime;
         var _loc1_:int = this._raceInfo.getNextChannel(this._gameTime);
         if(_loc1_ != -1)
         {
            _loc2_ = SummonRaceForecastMananger.instance.getPosX(_loc1_);
            if(_loc2_ == 0)
            {
               _loc4_ = this._raceInfo.getActionDuration(this._gameTime);
               if(_loc4_ > 0)
               {
                  TweenLite.to(this._userModel,_loc4_,{
                     "x":-10,
                     "onComplete":this.destroy
                  });
               }
               else
               {
                  TweenLite.to(this._userModel,0.8,{
                     "x":-10,
                     "onComplete":this.destroy
                  });
               }
            }
            else
            {
               _loc4_ = this._raceInfo.getActionDuration(this._gameTime);
               if(_loc4_ > 0)
               {
                  TweenLite.to(this._userModel,_loc4_,{"x":_loc2_});
               }
               else
               {
                  TweenLite.to(this._userModel,0.8,{"x":_loc2_});
               }
            }
            _loc3_ = this._raceInfo.getDialog(this._gameTime);
            if(Boolean(_loc3_) && _loc3_ != "")
            {
               this._userModel.showBox(_loc3_);
            }
         }
      }
      
      private function onRaceEnd(param1:Event) : void
      {
         this._userModel.removeEventListener(ActionEvent.ACTION_FINISHED,this.onActionFinished);
         this._userModel.actionManager.clear();
         this._userModel.execStandAction(false);
      }
      
      public function destroy() : void
      {
         clearInterval(this._intervalID);
         this.removeEvent();
         if(this._userModel)
         {
            TweenLite.killTweensOf(this._userModel);
            this._userModel.removeEventListener(ActionEvent.ACTION_FINISHED,this.onActionFinished);
            DisplayUtil.removeForParent(this._userModel);
            this._userModel.destroy();
            this._userModel = null;
         }
      }
   }
}

