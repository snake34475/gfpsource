package com.gfp.app.mapProcess
{
   import com.gfp.core.action.ActionInfo;
   import com.gfp.core.action.BaseAction;
   import com.gfp.core.config.xml.ActionXMLInfo;
   import com.gfp.core.events.UserEvent;
   import com.gfp.core.manager.UserManager;
   import com.gfp.core.map.BaseMapProcess;
   import com.gfp.core.model.UserModel;
   import com.gfp.core.ui.alert.TextAlert;
   
   public class MapProcess_1004506 extends BaseMapProcess
   {
      
      private var _trackModel:UserModel;
      
      private var _firstHpInit:Boolean = false;
      
      public function MapProcess_1004506()
      {
         super();
      }
      
      override protected function init() : void
      {
         this.addEventLister();
      }
      
      private function addEventLister() : void
      {
         UserManager.addEventListener(UserEvent.HP_CHANGE,this.onUserHPChange);
      }
      
      private function removeEventListener() : void
      {
         UserManager.removeEventListener(UserEvent.HP_CHANGE,this.onUserHPChange);
      }
      
      private function onUserHPChange(param1:UserEvent) : void
      {
         var _loc3_:ActionInfo = null;
         var _loc2_:UserModel = param1.data;
         if(_loc2_.info.roleType == 11300)
         {
            if(this._firstHpInit)
            {
               if(_loc2_.getHP() >= _loc2_.getTotalHP())
               {
                  this._trackModel = UserManager.getModelByRoleType(11300);
                  if(this._trackModel)
                  {
                     _loc3_ = ActionXMLInfo.getInfo(10016);
                     this._trackModel.execAction(new BaseAction(_loc3_));
                     this.removeEventListener();
                  }
                  TextAlert.show("随着齿轮转动的声音，怒气山脊的某个装置终于停止了运转。");
               }
            }
            this._firstHpInit = true;
         }
      }
      
      override public function destroy() : void
      {
         super.destroy();
         this.removeEventListener();
         this._firstHpInit = false;
         this._trackModel = null;
      }
   }
}

