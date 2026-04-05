package com.gfp.app.toolBar.taskTrack
{
   import com.gfp.app.config.xml.ActivityTransportXMLInfo;
   import com.gfp.app.info.ActivityTansInfo;
   
   public class ActivityTrackPanel extends TaskBasePreviewPanel
   {
      
      public function ActivityTrackPanel()
      {
         super();
         this.initList();
      }
      
      private function initList() : void
      {
         var _loc2_:ActivityTansInfo = null;
         var _loc3_:ActivityTrackItem = null;
         var _loc1_:Array = ActivityTransportXMLInfo.getAllTansport();
         for each(_loc2_ in _loc1_)
         {
            _loc3_ = new ActivityTrackItem(_loc2_);
            _list.push(_loc3_);
         }
         updateListShow();
      }
   }
}

