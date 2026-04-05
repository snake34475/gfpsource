package com.gfp.app.mapProcess
{
   import com.gfp.core.cache.SoundCache;
   import com.gfp.core.cache.SoundInfo;
   import com.gfp.core.config.ClientConfig;
   import com.gfp.core.sound.SoundManager;
   
   public class MapProcess_1040801 extends MapProcess_1040201
   {
      
      private var _skillIDs:Array = [4120479,4120480];
      
      public function MapProcess_1040801()
      {
         super();
      }
      
      override protected function init() : void
      {
         super.init();
         monsterIDs = [11801,11802,11803,11804,11786,11787,11788,11789,11790,11791,11800];
         if(SoundManager.isMusicEnable)
         {
            this.nextLoad();
         }
      }
      
      private function nextLoad() : void
      {
         var _loc1_:uint = 0;
         var _loc2_:String = null;
         if(this._skillIDs.length > 0)
         {
            _loc1_ = this._skillIDs.pop();
            _loc2_ = ClientConfig.getSoundSkill(_loc1_);
            SoundCache.load(_loc2_,this.onSoundComplete,this.onSoundError);
         }
      }
      
      private function onSoundComplete(param1:SoundInfo) : void
      {
         this.nextLoad();
      }
      
      private function onSoundError(param1:String) : void
      {
      }
   }
}

