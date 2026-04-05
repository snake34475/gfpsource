package com.gfp.app.toolBar.taskTrack
{
   import com.gfp.core.config.xml.TasksXMLInfo;
   import com.gfp.core.map.CityMap;
   import flash.display.SimpleButton;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.TextEvent;
   import flash.text.TextField;
   import org.taomee.utils.DisplayUtil;
   
   public class TaskAcceptableDetailItem extends Sprite
   {
      
      private var _taskID:uint;
      
      private var _mainUI:Sprite;
      
      private var _transBtn:SimpleButton;
      
      private var _nameTxt:TextField;
      
      public function TaskAcceptableDetailItem(param1:uint)
      {
         super();
         this._taskID = param1;
         this._mainUI = new UI_TaskAcceptableDetailItem();
         addChild(this._mainUI);
         this._nameTxt = this._mainUI["nameTxt"];
         this._nameTxt.htmlText = "<u><a href=\'event:TRANS\'>" + TasksXMLInfo.getName(this._taskID) + "</a></u>";
         this._nameTxt.height = this._nameTxt.textHeight + 4;
         this._nameTxt.mouseWheelEnabled = false;
         this._nameTxt.addEventListener(TextEvent.LINK,this.onTrans);
      }
      
      private function onTrans(param1:Event) : void
      {
         var _loc3_:String = null;
         var _loc2_:int = int(TasksXMLInfo.getStartNpc(this._taskID));
         if(_loc2_ > 0)
         {
            _loc3_ = "NPC_" + _loc2_;
         }
         else
         {
            _loc3_ = TasksXMLInfo.getEndTran(this._taskID);
         }
         CityMap.instance.tranChangeMapByStr(_loc3_);
      }
      
      public function destroy() : void
      {
         this._nameTxt.removeEventListener(TextEvent.LINK,this.onTrans);
         DisplayUtil.removeForParent(this._mainUI);
         this._mainUI = null;
      }
   }
}

