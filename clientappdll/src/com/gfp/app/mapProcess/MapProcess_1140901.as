package com.gfp.app.mapProcess
{
   import com.gfp.core.info.CDInfo;
   import com.gfp.core.info.KeyInfo;
   import com.gfp.core.manager.CDManager;
   import com.gfp.core.manager.MainManager;
   import com.gfp.core.map.BaseMapProcess;
   import com.gfp.core.utils.TickManager;
   
   public class MapProcess_1140901 extends BaseMapProcess
   {
      
      public var _skills:Vector.<KeyInfo>;
      
      public var cd:CDInfo;
      
      private var _skillArray:Array = [];
      
      public function MapProcess_1140901()
      {
         super();
      }
      
      override protected function init() : void
      {
         this._skills = MainManager.actorInfo.skills;
         var _loc1_:int = 0;
         while(_loc1_ < this._skills.length)
         {
            this._skillArray.push(this._skills[_loc1_].dataID);
            _loc1_++;
         }
         this.cd = new CDInfo();
         TickManager.instance.addRender(this.settimers,15000);
      }
      
      private function settimers() : void
      {
         this.cd = new CDInfo();
         var _loc1_:int = Math.random() * this._skills.length;
         if(this.cd)
         {
            CDManager.skillCD.remove(this.cd.id);
         }
         this.cd.id = this._skillArray[_loc1_];
         this.cd.runTime = 0;
         this.cd.cdTime = 15000;
         CDManager.skillCD.add(this.cd);
      }
   }
}

