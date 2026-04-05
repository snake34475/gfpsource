package com.gfp.app.fight
{
   import com.gfp.core.cache.CommonCache;
   import com.gfp.core.cache.EffectBitmapCache;
   import com.gfp.core.cache.SoundCache;
   import com.gfp.core.config.ClientConfig;
   import com.gfp.core.manager.LayerManager;
   import com.gfp.core.utils.FightMode;
   
   public class WatchFightLoader extends FightLoader
   {
      
      public function WatchFightLoader()
      {
         super();
      }
      
      override public function loadPvP(param1:Array, param2:Array = null) : void
      {
         fightModel = FightMode.PVP;
         _waitList = _fightReg.parseAll(param1,param2,true);
         var _loc3_:Array = _fightReg.parseSoundAll(param1,param2);
         _waitList = _waitList.concat(_loc3_);
         pvpTransitionLoading = new PvpTransitionLoading(param1,LayerManager.topLevel,pvpTransitionOverHandler,400);
         this.nextLoad();
      }
      
      override protected function nextLoad() : void
      {
         var _loc1_:int = 0;
         var _loc2_:String = null;
         if(!isLoading)
         {
            _loc1_ = int(_waitList.length);
            if(_loc1_ > 0)
            {
               isLoading = true;
               _currInfo = _waitList.pop();
               if(_currInfo.type == FightRes.EQUIP)
               {
                  CommonCache.getSpngInfoByUrl(_currInfo.url,onEquipComplete,onEquipError);
               }
               else if(_currInfo.type == FightRes.EFFECT)
               {
                  _loc2_ = ClientConfig.getEffectBmp(_currInfo.itemID);
                  if(_loc2_.indexOf("?") != -1)
                  {
                     EffectBitmapCache.getSpngInfoByUrl(_loc2_,onEffectComplete,onEffectError);
                  }
                  else
                  {
                     onEffectError(_loc2_);
                  }
               }
               else if(_currInfo.type == FightRes.NPC)
               {
                  CommonCache.getSpngInfoByUrl(_currInfo.url,onNpcComplete,onNpcError);
               }
               else if(_currInfo.type == FightRes.SOUND)
               {
                  SoundCache.load(_currInfo.url,onSoundComplete,onSoundError);
               }
            }
         }
      }
   }
}

