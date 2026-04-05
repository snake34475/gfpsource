package com.gfp.app.manager
{
   import com.gfp.app.fight.FightManager;
   import com.gfp.core.cache.SoundCache;
   import com.gfp.core.config.ClientConfig;
   import com.gfp.core.manager.AlertManager;
   import com.gfp.core.manager.LayerManager;
   import com.gfp.core.manager.ModuleManager;
   import com.gfp.core.sound.SoundManager;
   import flash.display.MovieClip;
   import flash.utils.clearTimeout;
   import flash.utils.setTimeout;
   import org.taomee.media.ListSoundPlayer;
   
   public class SummonTalkInTollgate
   {
      
      private static var _instance:SummonTalkInTollgate;
      
      private static var currentIndex:int;
      
      public static const TOLLGAGE_ID:Array = [516];
      
      public static const SOUND_NAME_ARRAY:Array = ["1.mp3","2.mp3","3.mp3","4.mp3","5.mp3","6.mp3","7.mp3","8.mp3","9.mp3","10.mp3","11.mp3"];
      
      private var textMc:MovieClip;
      
      private var timeID:int;
      
      private var pl:ListSoundPlayer;
      
      private var curTextMovie:MovieClip;
      
      public function SummonTalkInTollgate()
      {
         super();
         this.textMc = new ToolBar_SummonText();
      }
      
      public static function get instance() : SummonTalkInTollgate
      {
         if(_instance == null)
         {
            _instance = new SummonTalkInTollgate();
         }
         var _loc1_:int = 0;
         while(_loc1_ < 10)
         {
            SoundCache.load(ClientConfig.getSoundOther(SOUND_NAME_ARRAY[_loc1_]),null,null);
            _loc1_++;
         }
         return _instance;
      }
      
      public function showTalk(param1:int, param2:int = 0, param3:int = 0) : void
      {
         currentIndex = param1;
         var _loc4_:String = SOUND_NAME_ARRAY[param1 - 1];
         SoundManager.playSound(ClientConfig.getSoundOther(_loc4_));
         this.curTextMovie = this.textMc["text_" + String(param1)];
         LayerManager.topLevel.addChild(this.curTextMovie);
         this.curTextMovie.y = 400 + param3;
         this.curTextMovie.x = (LayerManager.stageWidth - this.curTextMovie.width) / 2 + param2;
         this.timeID = setTimeout(this.overShow,2000);
      }
      
      private function overShow() : void
      {
         LayerManager.topLevel.removeChild(this.curTextMovie);
         this.curTextMovie = null;
         clearTimeout(this.timeID);
         if(currentIndex == 10)
         {
            FightManager.quit();
            _instance = null;
            AlertManager.showSimpleAlert("看来剑灵似乎不愿意你成为它的主人，想要再次尝试吗？",this.oKFun);
         }
      }
      
      private function oKFun() : void
      {
         ModuleManager.turnAppModule("DonateDragenBallPannel");
      }
      
      public function destroy() : void
      {
         SoundCache.clearCache();
         if(this.curTextMovie != null)
         {
            LayerManager.topLevel.removeChild(this.curTextMovie);
         }
         clearTimeout(this.timeID);
         _instance = null;
      }
   }
}

