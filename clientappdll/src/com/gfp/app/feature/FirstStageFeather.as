package com.gfp.app.feature
{
   import com.gfp.core.CommandID;
   import com.gfp.core.info.GuideInfo;
   import com.gfp.core.info.GuideNodeInfo;
   import com.gfp.core.manager.MainManager;
   import com.gfp.core.net.SocketConnection;
   import com.gfp.core.ui.controller.GuideAdapter;
   import flash.utils.clearTimeout;
   import flash.utils.setTimeout;
   
   public class FirstStageFeather
   {
      
      private var adapter:GuideAdapter;
      
      public function FirstStageFeather()
      {
         super();
         this.init();
         this.addEvent();
      }
      
      private function init() : void
      {
         var timer:int = 0;
         var hp:int = MainManager.actorInfo.hp / 2;
         MainManager.actorModel.setDecHP(hp);
         MainManager.actorModel.setHP(hp);
         SocketConnection.send(CommandID.FIGHT_ACTIVITY_EFFECT,7,1,0);
         this.adapter = new GuideAdapter(2,this.guideBack);
         this.adapter.show();
         timer = int(setTimeout(function():void
         {
            clearTimeout(timer);
            if(Boolean(adapter.currentStep) && adapter.currentStep.id == 1)
            {
               adapter.nextStep();
            }
         },2000));
      }
      
      private function guideBack(param1:GuideNodeInfo, param2:GuideInfo) : void
      {
         if(param2.id == 2)
         {
         }
      }
      
      private function addEvent() : void
      {
      }
      
      private function removeEvent() : void
      {
      }
      
      public function destory() : void
      {
         this.removeEvent();
         if(this.adapter)
         {
            this.adapter.destory();
         }
      }
   }
}

