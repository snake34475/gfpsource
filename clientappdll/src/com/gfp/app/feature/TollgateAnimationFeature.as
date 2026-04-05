package com.gfp.app.feature
{
   import com.gfp.core.CommandID;
   import com.gfp.core.action.events.ActionEvent;
   import com.gfp.core.model.CustomUserModel;
   import com.gfp.core.net.SocketConnection;
   import com.gfp.core.ui.alert.TextAlert;
   import com.gfp.core.utils.TextFormatUtil;
   import flash.geom.Point;
   import flash.utils.ByteArray;
   import org.taomee.net.SocketEvent;
   
   public class TollgateAnimationFeature
   {
      
      private var _models:Vector.<CustomUserModel> = new Vector.<CustomUserModel>();
      
      public var modelIds:Array = [];
      
      private var _modelPostions:Array = [new Point(1050,357),new Point(1174,297),new Point(1528,685),new Point(1639,435),new Point(1416,333)];
      
      public var rounds:Array = [];
      
      public var spTollgateId:int;
      
      public function TollgateAnimationFeature()
      {
         super();
      }
      
      public function setParams(param1:Array, param2:Array, param3:int) : void
      {
         this.modelIds = param1;
         this.rounds = param2;
         this.spTollgateId = param3;
      }
      
      public function setup() : void
      {
         this.initModels();
         this.addEvent();
      }
      
      private function initModels() : void
      {
         var _loc2_:CustomUserModel = null;
         var _loc1_:int = 0;
         while(_loc1_ < this.modelIds.length)
         {
            _loc2_ = new CustomUserModel(this.modelIds[_loc1_]);
            _loc2_.show(this._modelPostions[_loc1_]);
            this._models.push(_loc2_);
            _loc1_++;
         }
      }
      
      public function destory() : void
      {
         var _loc1_:CustomUserModel = null;
         this.removeEvent();
         for each(_loc1_ in this._models)
         {
            _loc1_.removeEventListener(ActionEvent.ACTION_FINISHED,this.onActionFinished);
            _loc1_.destroy();
         }
         this._models = null;
      }
      
      public function addEvent() : void
      {
         SocketConnection.addCmdListener(CommandID.STAGE_MONSTER_PRO_CHANGE,this.onStageProChange);
      }
      
      public function removeEvent() : void
      {
         SocketConnection.removeCmdListener(CommandID.STAGE_MONSTER_PRO_CHANGE,this.onStageProChange);
      }
      
      private function onStageProChange(param1:SocketEvent) : void
      {
         var _loc7_:int = 0;
         var _loc2_:ByteArray = param1.data as ByteArray;
         var _loc3_:uint = _loc2_.readUnsignedInt();
         var _loc4_:uint = _loc2_.readUnsignedInt();
         var _loc5_:uint = _loc2_.readUnsignedInt();
         var _loc6_:uint = _loc2_.readUnsignedInt();
         if(_loc3_ == this.spTollgateId)
         {
            TextAlert.show("第 " + TextFormatUtil.getRedText(_loc5_ + 1) + " 波怪物已经出现");
            _loc7_ = this.rounds.indexOf(_loc5_ + 1);
            if(_loc7_ != -1)
            {
               this._models[_loc7_].exeSkillAction(4120015);
               this._models[_loc7_].addEventListener(ActionEvent.ACTION_FINISHED,this.onActionFinished);
            }
         }
         else
         {
            TextAlert.show("第 " + TextFormatUtil.getRedText(_loc5_ + 1) + " 波怪物已经出现");
         }
      }
      
      private function onActionFinished(param1:ActionEvent) : void
      {
         var _loc2_:CustomUserModel = param1.currentTarget as CustomUserModel;
         var _loc3_:int = this._models.indexOf(_loc2_);
         SocketConnection.send(CommandID.STAGE_HIDDEN_STATE_CHANGE,1,this.rounds[_loc3_] - 1);
         _loc2_.remove();
      }
   }
}

