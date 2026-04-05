package com.gfp.app.fight.pvai
{
   import com.gfp.app.fight.FightLoader;
   import com.gfp.app.fight.FightRes;
   import com.gfp.app.fight.PvpTransitionLoading;
   import com.gfp.core.cache.CommonCache;
   import com.gfp.core.cache.EffectBitmapCache;
   import com.gfp.core.cache.SoundCache;
   import com.gfp.core.config.ClientConfig;
   import com.gfp.core.info.UserInfo;
   import com.gfp.core.manager.LayerManager;
   import com.gfp.core.model.SpriteModel;
   import com.gfp.core.utils.FightMode;
   import com.gfp.core.utils.SpriteType;
   
   public class PvaiLoader extends FightLoader
   {
      
      public function PvaiLoader()
      {
         super();
      }
      
      override public function loadPvP(param1:Array, param2:Array = null) : void
      {
         var _loc5_:UserInfo = null;
         fightModel = FightMode.PVP;
         _waitList = _fightReg.parseAll(param1,param2,true);
         var _loc3_:Array = _fightReg.parseSoundAll(param1,param2);
         _waitList = _waitList.concat(_loc3_);
         var _loc4_:Array = param1.concat();
         for each(_loc5_ in param2)
         {
            if(SpriteModel.getSpriteType(_loc5_.roleType) == SpriteType.PLAYER_OGRE)
            {
               _loc4_.push(_loc5_);
            }
         }
         pvpTransitionLoading = new PvpTransitionLoading(_loc4_,LayerManager.topLevel,pvpTransitionOverHandler,4000);
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

