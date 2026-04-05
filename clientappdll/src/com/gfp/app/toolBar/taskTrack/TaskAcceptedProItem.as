package com.gfp.app.toolBar.taskTrack
{
   import com.gfp.core.config.xml.NpcXMLInfo;
   import com.gfp.core.config.xml.TasksXMLInfo;
   import com.gfp.core.info.task.TaskBufInfo;
   import com.gfp.core.info.task.TaskConditionInfo;
   import com.gfp.core.info.task.TaskConfigInfo;
   import com.gfp.core.manager.MainManager;
   import com.gfp.core.manager.ModuleManager;
   import com.gfp.core.map.CityMap;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import flash.events.TextEvent;
   import flash.text.TextField;
   import org.taomee.utils.DisplayUtil;
   
   public class TaskAcceptedProItem extends Sprite
   {
      
      private var _mainUI:Sprite;
      
      private var _taskID:uint;
      
      private var _desc:TextField;
      
      private var _proc:TextField;
      
      private var _condition:TaskConditionInfo;
      
      private var _bufInfo:TaskBufInfo;
      
      private var _step:uint;
      
      public function TaskAcceptedProItem(param1:uint, param2:uint, param3:String = "", param4:TaskConditionInfo = null, param5:uint = 0)
      {
         super();
         this._mainUI = new UI_TaskAcceptedProItem();
         addChild(this._mainUI);
         this._desc = this._mainUI["desc"];
         this._proc = this._mainUI["proc"];
         this.pro = param3;
         this._condition = param4;
         this._desc.height = this._desc.textHeight + 5;
         this._desc.addEventListener(TextEvent.LINK,this.onTransport);
         this._taskID = param1;
         switch(param2)
         {
            case TaskAcceptedItem.TASK_READY:
               this._desc.htmlText = "回复<U><a href=\'event:REPLY\'>" + TasksXMLInfo.getEnd(this._taskID) + "</a></U>";
               break;
            case TaskAcceptedItem.TASK_CANACCEPT:
               this._desc.htmlText = "回复<U><a href=\'event:ACCEPT\'>" + TasksXMLInfo.getStart(this._taskID) + "</a></U>";
               break;
            case TaskAcceptedItem.TASK_PROCESS:
               this._desc.htmlText = "<U><a href=\'event:TRANS\'>" + param4.doc + "</a></U>";
         }
         this._desc.height = this._desc.textHeight + 4;
         this._step = param5;
      }
      
      public function set pro(param1:String) : void
      {
         this._proc.text = param1;
      }
      
      public function get step() : uint
      {
         return this._step;
      }
      
      private function onTransport(param1:TextEvent) : void
      {
         var _loc2_:String = null;
         var _loc3_:String = null;
         var _loc4_:int = 0;
         var _loc5_:TaskConfigInfo = null;
         var _loc6_:String = null;
         switch(param1.text)
         {
            case "ACCEPT":
               _loc2_ = TasksXMLInfo.getStart(this._taskID);
               _loc3_ = _loc2_.split("(")[0];
               _loc4_ = int(NpcXMLInfo.getNpcIdByName(_loc3_));
               if(_loc4_ > 0)
               {
                  _loc6_ = "NPC_" + _loc4_;
               }
               else
               {
                  _loc6_ = TasksXMLInfo.getStartTran(this._taskID);
               }
               CityMap.instance.tranChangeMapByStr(_loc6_);
               break;
            case "REPLY":
               _loc5_ = TasksXMLInfo.getTaskConfigInfoByID(this._taskID);
               if(_loc5_)
               {
                  _loc4_ = int(_loc5_.endNpc);
                  if(_loc4_ > 0)
                  {
                     _loc6_ = "NPC_" + _loc4_;
                  }
                  else
                  {
                     _loc6_ = TasksXMLInfo.getEndTran(this._taskID);
                  }
                  CityMap.instance.tranChangeMapByStr(_loc6_);
               }
               break;
            case "TRANS":
               if(this._condition.tran != null && this._condition.tran != "")
               {
                  if(this._taskID == 1924 && Boolean(MainManager.actorInfo.isTurnBack))
                  {
                     CityMap.instance.tranChangeMapByStr(this._condition.tran2);
                     break;
                  }
                  if(this._taskID == 1158)
                  {
                     ModuleManager.turnAppModule("VipFirstGetAwardPanel");
                     break;
                  }
                  CityMap.instance.tranChangeMapByStr(this._condition.tran);
               }
         }
      }
      
      public function destroy() : void
      {
         this._desc.removeEventListener(MouseEvent.CLICK,this.onTransport);
         this._desc = null;
         this._proc = null;
         DisplayUtil.removeForParent(this._mainUI);
         this._mainUI = null;
      }
   }
}

