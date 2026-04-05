package com.gfp.app.glory
{
   import com.gfp.core.cache.SoundCache;
   import com.gfp.core.cache.SoundInfo;
   import com.gfp.core.config.ClientConfig;
   import com.gfp.core.sound.SoundManager;
   import com.gfp.core.utils.Logger;
   
   public class SoundGloryPlayer
   {
      
      public function SoundGloryPlayer()
      {
         super();
      }
      
      public static function play(param1:uint) : void
      {
         if(SoundManager.isMusicEnable)
         {
            SoundCache.load(ClientConfig.getSoundGlory(param1),onSoundComplete,onSoundError);
         }
      }
      
      private static function onSoundComplete(param1:SoundInfo) : void
      {
         SoundManager.playSound(param1.url,0,false,0.6);
      }
      
      private static function onSoundError(param1:String) : void
      {
         Logger.error(null,"sound url error：" + param1);
      }
   }
}

