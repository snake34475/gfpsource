package com.gfp.app.mapProcess
{
   import com.gfp.core.events.UserEvent;
   import com.gfp.core.manager.LayerManager;
   import com.gfp.core.manager.UserManager;
   import com.gfp.core.map.BaseMapProcess;
   import com.gfp.core.model.UserModel;
   import com.gfp.core.ui.ExtenalUIPanel;
   import flash.geom.Point;
   import org.taomee.utils.AlignType;
   import org.taomee.utils.DisplayUtil;
   
   public class MapProcess_1062301 extends BaseMapProcess
   {
      
      private var getSummonStepUI:ExtenalUIPanel;
      
      private var getSummonSkillUI:ExtenalUIPanel;
      
      public function MapProcess_1062301()
      {
         super();
      }
      
      override protected function init() : void
      {
         UserManager.addEventListener(UserEvent.BORN,this.onUserBorn);
      }
      
      private function onUserBorn(param1:UserEvent) : void
      {
         var _loc2_:UserModel = param1.data as UserModel;
         if(_loc2_.info.roleType == 13311)
         {
            this.getSummonStepUI = new ExtenalUIPanel("get_summon_step");
            if(this.getSummonStepUI)
            {
               LayerManager.topLevel.addChild(this.getSummonStepUI);
               DisplayUtil.align(this.getSummonStepUI,null,AlignType.MIDDLE_LEFT);
            }
         }
      }
      
      private function onUserDie(param1:UserEvent) : void
      {
         var _loc2_:UserModel = param1.data as UserModel;
         if(_loc2_.info.roleType == 13311)
         {
            if(this.getSummonStepUI)
            {
               this.getSummonStepUI.gotoAndStop(2);
            }
            this.getSummonSkillUI = new ExtenalUIPanel("get_summon_skill");
            if(this.getSummonSkillUI)
            {
               LayerManager.topLevel.addChild(this.getSummonSkillUI);
               DisplayUtil.align(this.getSummonSkillUI,null,AlignType.BOTTOM_RIGHT,new Point(-88,-102));
            }
         }
      }
      
      override public function destroy() : void
      {
         DisplayUtil.removeForParent(this.getSummonStepUI);
         if(this.getSummonStepUI)
         {
            this.getSummonStepUI.destory();
            this.getSummonStepUI = null;
         }
         if(this.getSummonSkillUI)
         {
            this.getSummonSkillUI.destory();
            this.getSummonSkillUI = null;
         }
         super.destroy();
      }
   }
}

