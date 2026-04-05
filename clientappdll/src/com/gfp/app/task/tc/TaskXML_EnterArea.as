package com.gfp.app.task.tc
{
   import com.gfp.app.task.TaskXML_Base;
   import com.gfp.core.config.xml.TasksXMLInfo;
   import com.gfp.core.events.MoveEvent;
   import com.gfp.core.events.UserEvent;
   import com.gfp.core.manager.MainManager;
   import com.gfp.core.manager.TasksManager;
   import com.gfp.core.manager.UserManager;
   import com.gfp.core.model.UserModel;
   import com.gfp.core.ui.alert.TextAlert;
   import com.gfp.core.utils.Logger;
   import com.gfp.core.utils.StringConstants;
   import flash.geom.Point;
   
   public class TaskXML_EnterArea extends TaskXML_Base
   {
      
      private var _pos:Point;
      
      private var _radius:uint;
      
      public function TaskXML_EnterArea()
      {
         super();
      }
      
      override public function setup(param1:uint, param2:uint, param3:String, param4:Boolean) : void
      {
         super.setup(param1,param2,param3,param4);
         var _loc5_:String = Logger.createLogMsgByArr("TaskXML_EnterArea setup:",_params,param1,param2);
         Logger.info(this,_loc5_);
         var _loc6_:Array = _params.split(StringConstants.TASK_PARAM_SIGN);
         this._pos = new Point(uint(_loc6_[0]),uint(_loc6_[1]));
         this._radius = uint(_loc6_[2]);
      }
      
      override protected function addListener() : void
      {
         if(MainManager.actorModel != null)
         {
            this.addActorMoveEvent();
         }
         else
         {
            UserManager.addEventListener(UserEvent.ADD_TO_STAGE,this.onActorAdded);
         }
      }
      
      private function onActorAdded(param1:UserEvent) : void
      {
         UserManager.removeEventListener(UserEvent.ADD_TO_STAGE,this.onActorAdded);
         var _loc2_:UserModel = param1.data;
         if(_loc2_.info.userID == MainManager.actorID)
         {
            this.addActorMoveEvent();
         }
      }
      
      private function addActorMoveEvent() : void
      {
         MainManager.actorModel.addEventListener(MoveEvent.MOVE_ENTER,this.onActorMove);
      }
      
      private function onActorMove(param1:MoveEvent) : void
      {
         if(Point.distance(param1.pos,this._pos) <= this._radius)
         {
            TasksManager.taskProComplete(_taskID,_proID);
            TextAlert.show(this.getTaskProcName(_taskID,_proID) + " (完成)");
            this.uninit();
         }
      }
      
      override public function uninit() : void
      {
         MainManager.actorModel.removeEventListener(MoveEvent.MOVE_ENTER,this.onActorMove);
      }
      
      override public function get isComplete() : Boolean
      {
         return TasksManager.getTaskProStatus(_taskID,_proID) == TasksManager.STEP_COMPLETE;
      }
      
      private function getTaskProcName(param1:uint, param2:uint) : String
      {
         return TasksXMLInfo.getProDoc(param1,param2);
      }
   }
}

