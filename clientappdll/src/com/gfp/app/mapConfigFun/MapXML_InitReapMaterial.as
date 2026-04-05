package com.gfp.app.mapConfigFun
{
   import com.gfp.core.config.xml.DailyActivityXMLInfo;
   import com.gfp.core.config.xml.ItemXMLInfo;
   import com.gfp.core.info.dailyActivity.RewardInfo;
   import com.gfp.core.manager.MainManager;
   import com.gfp.core.manager.SOManager;
   import com.gfp.core.manager.SightManager;
   import com.gfp.core.manager.TasksManager;
   import com.gfp.core.map.IMapConfigFun;
   import com.gfp.core.map.MapManager;
   import com.gfp.core.model.sensemodels.SightModel;
   import flash.events.Event;
   import flash.net.SharedObject;
   import org.taomee.manager.ToolTipManager;
   
   public class MapXML_InitReapMaterial implements IMapConfigFun
   {
      
      private var _openSm:SightModel;
      
      private var _closeSm:SightModel;
      
      private var _maxReapTime:int;
      
      private var _reapId:uint;
      
      private var _taskID:uint;
      
      public function MapXML_InitReapMaterial()
      {
         super();
      }
      
      public function exec(param1:SightModel, param2:XML, param3:XMLList) : void
      {
         this._openSm = param1;
         var _loc4_:Array = param2.toString().split(",");
         this._reapId = int(_loc4_[0]);
         this._maxReapTime = int(_loc4_[1]);
         this._taskID = int(_loc4_[2]);
         this._closeSm = SightManager.getSightModel(this._openSm.info.id - 1);
         this._openSm.addEventListener(Event.ADDED_TO_STAGE,this.onAddToStage);
         this._openSm.addEventListener(Event.REMOVED_FROM_STAGE,this.onRemoveFromStage);
      }
      
      private function checkSighModelShow() : Boolean
      {
         if(this._taskID != 0)
         {
            if(!TasksManager.isAccepted(this._taskID) || Boolean(TasksManager.isCompleted(this._taskID)))
            {
               this._openSm.hide();
               return false;
            }
         }
         return true;
      }
      
      private function getSo() : SharedObject
      {
         return SOManager.getUserSO(SOManager.DAILY_REAP);
      }
      
      private function onAddToStage(param1:Event) : void
      {
         if(!this.checkSighModelShow())
         {
            return;
         }
         var _loc2_:SharedObject = this.getSo();
         var _loc3_:Date = new Date();
         _loc3_.setTime(MainManager.loginTimeInSecond * 1000);
         var _loc4_:String = _loc3_.getFullYear() + "-" + (_loc3_.getMonth() + 1) + "-" + _loc3_.getDate();
         var _loc5_:String = MapManager.currentMap.info.id.toString() + "-" + this._openSm.info.id.toString();
         var _loc6_:String = MainManager.actorInfo.createTime.toString();
         var _loc7_:String = _loc6_ + "#" + _loc4_ + "#" + _loc5_;
         if(int(_loc2_.data[_loc7_]) >= this._maxReapTime)
         {
            if(this._closeSm)
            {
               this._closeSm.show();
            }
            this._openSm.hide();
         }
         else
         {
            this._openSm.show();
            if(this._closeSm)
            {
               this._closeSm.hide();
            }
         }
         this.addToolTip();
      }
      
      private function addToolTip() : void
      {
         var _loc2_:String = null;
         var _loc3_:uint = 0;
         var _loc1_:RewardInfo = DailyActivityXMLInfo.getAwardInfoById(this._reapId);
         if(_loc1_)
         {
            _loc3_ = uint(_loc1_.id);
            _loc2_ = ItemXMLInfo.getName(_loc3_);
         }
         else
         {
            _loc2_ = "采集物";
         }
         ToolTipManager.add(this._openSm,_loc2_);
      }
      
      private function removeToolTip() : void
      {
         ToolTipManager.remove(this._openSm);
      }
      
      private function onRemoveFromStage(param1:Event) : void
      {
         this.removeToolTip();
      }
   }
}

