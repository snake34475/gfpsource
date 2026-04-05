package com.gfp.app.feature
{
   import com.gfp.app.fight.FightManager;
   import com.gfp.core.cache.SwfCache;
   import com.gfp.core.cache.SwfInfo;
   import com.gfp.core.config.ClientConfig;
   import com.gfp.core.events.FightEvent;
   import com.gfp.core.events.UserEvent;
   import com.gfp.core.info.UserInfo;
   import com.gfp.core.info.fight.BruiseInfo;
   import com.gfp.core.manager.LayerManager;
   import com.gfp.core.manager.MainManager;
   import com.gfp.core.manager.SummonManager;
   import com.gfp.core.manager.UserManager;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.text.TextField;
   import org.taomee.utils.DisplayUtil;
   
   public class SanGuoHitInfoFeather
   {
      
      private var _mode:int;
      
      private var _ui:Sprite;
      
      private var _infoMc:MovieClip;
      
      private var _countTxt:TextField;
      
      private var _totalDPS:int;
      
      private var _feather:LeftTimeFeather;
      
      public function SanGuoHitInfoFeather(param1:int)
      {
         super();
         this._mode = param1;
         this.init();
         this.addEvent();
      }
      
      private function init() : void
      {
         this._feather = new LeftTimeFeather(60 * 3 * 1000,"剩余时间");
         SwfCache.getSwfInfo(ClientConfig.getSubUI("san_guo_hit_info"),this.onUILoaded);
      }
      
      private function addEvent() : void
      {
         if(this._mode == 0)
         {
            UserManager.addEventListener(UserEvent.USER_DPS_HIT,this.onDpsHit);
         }
         else
         {
            FightManager.instance.addEventListener(FightEvent.OGRE_DIE,this.onOgreDie);
         }
      }
      
      private function removeEvent() : void
      {
         UserManager.removeEventListener(UserEvent.USER_DPS_HIT,this.onDpsHit);
         FightManager.instance.removeEventListener(FightEvent.OGRE_DIE,this.onOgreDie);
      }
      
      private function onOgreDie(param1:FightEvent) : void
      {
         var _loc2_:UserInfo = param1.data as UserInfo;
         if(_loc2_.roleType >= 20 && _loc2_.troop != MainManager.actorInfo.troop)
         {
            ++this._totalDPS;
            this.updateValue();
         }
      }
      
      private function onDpsHit(param1:UserEvent) : void
      {
         var _loc2_:BruiseInfo = param1.data as BruiseInfo;
         if(Boolean(SummonManager.getActorSummonInfo().fightSummonInfo) && _loc2_.atkerID == SummonManager.getActorSummonInfo().fightSummonInfo.stageID)
         {
            this._totalDPS += _loc2_.decHP;
         }
         if(_loc2_.atkerID == MainManager.actorID)
         {
            this._totalDPS += _loc2_.decHP;
         }
         this.updateValue();
      }
      
      private function onUILoaded(param1:SwfInfo) : void
      {
         if(this._ui == null)
         {
            this._ui = param1.content as MovieClip;
            this._infoMc = this._ui["infoMc"];
            this._infoMc.gotoAndStop(this._mode + 1);
            this._countTxt = this._ui["countTxt"];
            this._countTxt.text = "0";
            this._ui.y = 200;
            this._ui.x = LayerManager.stageWidth - 30 - this._ui.width;
            LayerManager.uiLevel.addChild(this._ui);
            this.updateValue();
         }
      }
      
      public function destory() : void
      {
         this.removeEvent();
         SwfCache.cancel(ClientConfig.getSubUI("san_guo_hit_info"),this.onUILoaded);
         if(this._ui)
         {
            DisplayUtil.removeForParent(this._ui);
         }
         if(this._feather)
         {
            this._feather.destroy();
         }
      }
      
      public function updateValue() : void
      {
         if(this._countTxt)
         {
            if(this._totalDPS >= 100 * 1000)
            {
               this._countTxt.text = Math.floor(this._totalDPS / 10000) + "w";
            }
            else
            {
               this._countTxt.text = this._totalDPS.toString();
            }
         }
      }
   }
}

