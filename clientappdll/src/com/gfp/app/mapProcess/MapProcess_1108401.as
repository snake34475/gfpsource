package com.gfp.app.mapProcess
{
   import com.gfp.core.config.MagicChangeConfig;
   import com.gfp.core.config.xml.MagicChangeXMLInfo;
   import com.gfp.core.events.MagicChangeEvent;
   import com.gfp.core.info.KeyInfo;
   import com.gfp.core.info.MagicChangeInfo;
   import com.gfp.core.info.fight.SkillInfo;
   import com.gfp.core.manager.KeyManager;
   import com.gfp.core.manager.MagicChangeManager;
   import com.gfp.core.manager.MainManager;
   import com.gfp.core.map.BaseMapProcess;
   import com.gfp.core.ui.alert.TextAlert;
   import flash.events.Event;
   
   public class MapProcess_1108401 extends BaseMapProcess
   {
      
      private var _originalChangeType:int;
      
      private var _originalTurnback:Boolean;
      
      public function MapProcess_1108401()
      {
         super();
      }
      
      override protected function init() : void
      {
         super.init();
         this._originalTurnback = MainManager.actorInfo.isTurnBack;
         MainManager.actorInfo.isTurnBack = true;
         MagicChangeManager.instance.installBlockFilter(this.magicFilter);
         MagicChangeManager.instance.addEventListener(MagicChangeEvent.CALL_FIGHT_END,this.onMagicEnd);
         this.update();
      }
      
      private function magicFilter() : Boolean
      {
         TextAlert.show("当前关卡不允许变身哦！",16711680);
         return true;
      }
      
      protected function onMagicEnd(param1:Event) : void
      {
         this.update();
      }
      
      private function update() : void
      {
         var _loc4_:KeyInfo = null;
         this._originalChangeType = MainManager.actorInfo.magicID;
         MainManager.actorModel.magicChange(MagicChangeConfig.FUDO);
         var _loc1_:Vector.<SkillInfo> = MagicChangeXMLInfo.getSkills(MagicChangeConfig.FUDO,99,true);
         var _loc2_:Vector.<KeyInfo> = new Vector.<KeyInfo>();
         var _loc3_:int = 0;
         while(_loc3_ < _loc1_.length)
         {
            if(_loc1_[_loc3_].lv != 0)
            {
               _loc4_ = new KeyInfo();
               _loc4_.funcID = KeyManager.skillQuickKeys[_loc3_];
               _loc4_.dataID = _loc1_[_loc3_].id;
               _loc4_.lv = _loc1_[_loc3_].lv;
               _loc2_.push(_loc4_);
            }
            _loc3_++;
         }
         KeyManager.reset();
         KeyManager.upDateSkillQuickKeys(_loc2_);
         KeyManager.upDateItemQuickKeys(MainManager.actorInfo.items);
      }
      
      override public function destroy() : void
      {
         var _loc1_:MagicChangeInfo = null;
         MainManager.actorInfo.isTurnBack = this._originalTurnback;
         MagicChangeManager.instance.uninstallBlockFilter(this.magicFilter);
         MagicChangeManager.instance.removeEventListener(MagicChangeEvent.CALL_FIGHT_END,this.onMagicEnd);
         if(this._originalChangeType)
         {
            _loc1_ = MagicChangeManager.instance.getInfo(this._originalChangeType);
            if(_loc1_)
            {
               MainManager.actorModel.magicChange(this._originalChangeType,_loc1_.clothID,_loc1_.weaponID,_loc1_.jewelryID);
            }
         }
         else
         {
            MainManager.actorModel.magicChange(0);
         }
         MagicChangeManager.instance.updateActorSkillController();
         super.destroy();
      }
   }
}

