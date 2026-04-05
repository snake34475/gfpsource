package com.gfp.app.toolBar.taskTrack
{
   import flash.events.Event;
   
   public class TaskAcceptablePanel extends TaskBasePreviewPanel
   {
      
      public static const TASK_TRACK_TYPES:Array = [1,2,3,5,4];
      
      public function TaskAcceptablePanel()
      {
         super();
         this.initList();
      }
      
      private function initList() : void
      {
         var _loc2_:TaskAcceptableItem = null;
         var _loc1_:int = 0;
         while(_loc1_ < 5)
         {
            _loc2_ = new TaskAcceptableItem(TASK_TRACK_TYPES[_loc1_]);
            if(isExpanded)
            {
               _loc2_.expandOn();
            }
            _loc2_.addEventListener(TaskAcceptableItem.LIST_FOLDCHANGE,this.onListFoldChange);
            _list.push(_loc2_);
            _list.sortOn("index",Array.NUMERIC);
            _loc1_++;
         }
         updateListShow();
      }
      
      private function onListFoldChange(param1:Event) : void
      {
         updateListShow();
      }
      
      override public function set isExpanded(param1:Boolean) : void
      {
         var _loc2_:TaskAcceptableItem = null;
         if(isExpanded == param1)
         {
            return;
         }
         super.isExpanded = param1;
         if(param1)
         {
            for each(_loc2_ in _list)
            {
               _loc2_.expandOn();
            }
         }
         else
         {
            for each(_loc2_ in _list)
            {
               _loc2_.expandOff();
            }
         }
         updateListShow();
      }
      
      override protected function removeEvent() : void
      {
         var _loc1_:TaskAcceptableItem = null;
         super.removeEvent();
         for each(_loc1_ in _list)
         {
            _loc1_.removeEventListener(TaskAcceptableItem.LIST_FOLDCHANGE,this.onListFoldChange);
         }
      }
   }
}

