package com.gfp.app.task
{
   import com.gfp.app.module.BaseExchangeModule;
   import com.gfp.core.config.xml.TasksXMLInfo;
   import com.gfp.core.info.task.TaskConditionInfo;
   import com.gfp.core.info.task.TaskConfigInfo;
   import com.gfp.core.manager.ActivityExchangeCommander;
   import com.gfp.core.manager.ActivityExchangeTimesManager;
   import com.gfp.core.manager.AlertManager;
   import com.gfp.core.manager.LayerManager;
   import com.gfp.core.manager.TasksManager;
   import com.gfp.core.map.CityMap;
   import flash.display.DisplayObject;
   import flash.display.MovieClip;
   import flash.display.SimpleButton;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   
   public class WeekTaskAwardBasePanel extends BaseExchangeModule
   {
      
      protected var tranBtns:Vector.<DisplayObject> = new Vector.<DisplayObject>();
      
      protected var getBtns:Vector.<SimpleButton> = new Vector.<SimpleButton>();
      
      protected var completes:Vector.<MovieClip> = new Vector.<MovieClip>();
      
      protected var swapIds:Array = [];
      
      protected var taskCompleteIds:Array = [];
      
      protected var tranTaskIds:Array = [];
      
      protected var taskTips:Array = [];
      
      public function WeekTaskAwardBasePanel()
      {
         super();
      }
      
      override public function setup() : void
      {
         super.setup();
      }
      
      override protected function addEvent() : void
      {
         var _loc1_:DisplayObject = null;
         super.addEvent();
         for each(_loc1_ in this.tranBtns)
         {
            _loc1_.addEventListener(MouseEvent.CLICK,this.onTranBtnClick);
         }
         for each(_loc1_ in this.getBtns)
         {
            _loc1_.addEventListener(MouseEvent.CLICK,this.onGetBtnClick);
         }
      }
      
      override protected function removeEvent() : void
      {
         var _loc1_:DisplayObject = null;
         super.removeEvent();
         for each(_loc1_ in this.tranBtns)
         {
            _loc1_.removeEventListener(MouseEvent.CLICK,this.onTranBtnClick);
         }
         for each(_loc1_ in this.getBtns)
         {
            _loc1_.removeEventListener(MouseEvent.CLICK,this.onGetBtnClick);
         }
      }
      
      protected function onGetBtnClick(param1:MouseEvent) : void
      {
         var _loc2_:int = this.getBtns.indexOf(param1.currentTarget as SimpleButton);
         var _loc3_:int = int(this.taskCompleteIds[_loc2_]);
         if(TasksManager.isCompleted(_loc3_))
         {
            ActivityExchangeCommander.exchange(this.swapIds[_loc2_]);
            this.getBtns[_loc2_].visible = false;
         }
         else
         {
            AlertManager.showSimpleAlarm(this.taskTips[_loc2_]);
         }
      }
      
      private function onTranBtnClick(param1:MouseEvent) : void
      {
         var _loc2_:int = this.tranBtns.indexOf(param1.currentTarget as SimpleButton);
         var _loc3_:int = int(this.taskCompleteIds[_loc2_]);
         if(TasksManager.isCompleted(_loc3_))
         {
            AlertManager.showSimpleAlarm("小侠士，您已经完成了该系列任务。");
         }
         else
         {
            this.gotoTask(this.tranTaskIds[_loc2_]);
         }
      }
      
      private function gotoTask(param1:Array) : void
      {
         var _loc4_:String = null;
         var _loc2_:uint = param1.length;
         var _loc3_:int = 0;
         while(_loc3_ < _loc2_)
         {
            _loc4_ = this.getTranStr(param1[_loc3_]);
            if(_loc4_ != "")
            {
               CityMap.instance.tranChangeMapByStr(_loc4_);
               destroy();
               return;
            }
            _loc3_++;
         }
      }
      
      private function getTranStr(param1:uint) : String
      {
         var _loc3_:Array = null;
         var _loc4_:uint = 0;
         var _loc5_:int = 0;
         var _loc6_:TaskConditionInfo = null;
         if(TasksManager.isCompleted(param1))
         {
            return "";
         }
         var _loc2_:TaskConfigInfo = TasksXMLInfo.getTaskConfigInfoByID(param1);
         if(TasksManager.isAcceptable(param1))
         {
            return "NPC_" + _loc2_.startNpc;
         }
         if(!TasksManager.isReady(param1))
         {
            _loc3_ = _loc2_.condition.conditionList;
            _loc4_ = _loc3_.length;
            _loc5_ = 0;
            while(_loc5_ < _loc4_)
            {
               if(TasksManager.isProcess(param1,_loc5_))
               {
                  _loc6_ = _loc3_[_loc5_];
                  return _loc6_.tran;
               }
               _loc5_++;
            }
         }
         return "NPC_" + _loc2_.endNpc;
      }
      
      override protected function setMainUI(param1:Sprite) : void
      {
         super.setMainUI(param1);
         var _loc2_:int = int(this.swapIds.length);
         var _loc3_:int = 0;
         while(_loc3_ < _loc2_)
         {
            this.getBtns.push(param1["getBtn" + _loc3_]);
            _loc3_++;
         }
         _loc3_ = 0;
         while(_loc3_ < _loc2_)
         {
            this.tranBtns.push(param1["tranBtn" + _loc3_]);
            _loc3_++;
         }
         _loc3_ = 0;
         while(_loc3_ < _loc2_)
         {
            (param1["complete" + _loc3_] as MovieClip).visible = false;
            this.completes.push(param1["complete" + _loc3_]);
            _loc3_++;
         }
      }
      
      override public function show() : void
      {
         showFor(LayerManager.topLevel);
         this.checkBtnStatus();
      }
      
      private function checkBtnStatus() : void
      {
         var _loc3_:int = 0;
         var _loc1_:int = int(this.swapIds.length);
         var _loc2_:int = 0;
         while(_loc2_ < _loc1_)
         {
            if(ActivityExchangeTimesManager.getTimes(this.swapIds[_loc2_]) != 0)
            {
               this.getBtns[_loc2_].visible = false;
            }
            _loc3_ = int(this.taskCompleteIds[_loc2_]);
            if(TasksManager.isCompleted(_loc3_))
            {
               this.completes[_loc2_].visible = true;
            }
            else
            {
               this.completes[_loc2_].visible = false;
            }
            _loc2_++;
         }
      }
   }
}

