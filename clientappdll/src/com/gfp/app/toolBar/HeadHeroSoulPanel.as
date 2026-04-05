package com.gfp.app.toolBar
{
   import com.gfp.app.fight.FightManager;
   import com.gfp.core.cache.SwfCache;
   import com.gfp.core.cache.SwfInfo;
   import com.gfp.core.config.ClientConfig;
   import com.gfp.core.config.xml.HeroSoulXMLInfo;
   import com.gfp.core.events.FightEvent;
   import com.gfp.core.events.UserEvent;
   import com.gfp.core.info.UserInfo;
   import com.gfp.core.manager.LayerManager;
   import com.gfp.core.manager.MainManager;
   import com.gfp.core.manager.UIManager;
   import com.gfp.core.manager.UserInfoManager;
   import flash.display.Sprite;
   import flash.geom.Rectangle;
   import flash.text.TextField;
   import org.taomee.utils.DisplayUtil;
   
   public class HeadHeroSoulPanel
   {
      
      private static var _instance:HeadHeroSoulPanel;
      
      private var _mainUI:Sprite;
      
      private var _lvTxt:TextField;
      
      private var _nameTxt:TextField;
      
      private var _headIcon:Sprite;
      
      private var _hpText:TextField;
      
      private var _hpBar:Sprite;
      
      private var _hpWidth:Number;
      
      private var _hpRect:Rectangle;
      
      public function HeadHeroSoulPanel()
      {
         super();
         this._mainUI = UIManager.getSprite("Head_HeroSoulInfoPanel");
         this._lvTxt = this._mainUI["lvTxt"];
         this._nameTxt = this._mainUI["nameTxt"];
         this._hpText = this._mainUI["hpTxt"];
         this._hpBar = this._mainUI["hpMC"];
         this._hpWidth = this._hpBar.width;
         this._hpRect = new Rectangle(0,0,0,this._hpBar.height);
         this._hpBar.scrollRect = this._hpRect;
         UserInfoManager.ed.addEventListener(UserEvent.HP_CHANGE,this.onHpChangeHandle);
         FightManager.instance.addEventListener(FightEvent.OGRE_DIEING,this.onSoulDieHandle);
      }
      
      public static function get instance() : HeadHeroSoulPanel
      {
         if(_instance == null)
         {
            _instance = new HeadHeroSoulPanel();
         }
         return _instance;
      }
      
      public static function destroy() : void
      {
         if(_instance)
         {
            _instance.destroy();
            _instance = null;
         }
      }
      
      public function init(param1:UserInfo) : void
      {
         this._lvTxt.text = param1.lv.toString();
         this._nameTxt.text = HeroSoulXMLInfo.getName(param1.roleType);
         this.initBars(param1);
         this.clearHeadIcon();
         SwfCache.getSwfInfo(ClientConfig.getRoleIcon(param1.roleType),this.onLoad);
         this.show();
      }
      
      private function onHpChangeHandle(param1:UserEvent) : void
      {
         var _loc2_:UserInfo = param1.data;
         if(_loc2_.roleType == MainManager.actorInfo.heroSoulType || _loc2_.roleType == 60162 || _loc2_.roleType == 60163)
         {
            this.initBars(_loc2_);
         }
      }
      
      private function onSoulDieHandle(param1:FightEvent) : void
      {
         var _loc2_:UserInfo = param1.data as UserInfo;
         if(_loc2_.roleType == MainManager.actorInfo.heroSoulType)
         {
            HeadHeroSoulPanel.destroy();
         }
      }
      
      private function show() : void
      {
         this._mainUI.x = 460;
         this._mainUI.y = 5;
         LayerManager.toolsLevel.addChild(this._mainUI);
      }
      
      public function destroy() : void
      {
         DisplayUtil.removeForParent(this._mainUI);
         UserInfoManager.ed.removeEventListener(UserEvent.HP_CHANGE,this.onHpChangeHandle);
         FightManager.instance.removeEventListener(FightEvent.OGRE_DIEING,this.onSoulDieHandle);
         SwfCache.cancel(ClientConfig.getRoleIcon(MainManager.actorInfo.heroSoulType),this.onLoad);
         this.clearHeadIcon();
         this._hpRect = null;
         this._lvTxt = null;
         this._nameTxt = null;
         this._hpText = null;
         this._mainUI = null;
      }
      
      private function initBars(param1:UserInfo) : void
      {
         this._lvTxt.text = param1.lv.toString();
         this._hpRect.width = param1.hp / param1.maxHp * this._hpWidth;
         this._hpBar.scrollRect = this._hpRect;
         this._hpText.text = param1.hp.toString() + "/" + param1.maxHp.toString();
      }
      
      private function clearHeadIcon() : void
      {
         if(this._headIcon)
         {
            this._headIcon.cacheAsBitmap = false;
            DisplayUtil.removeForParent(this._headIcon);
            this._headIcon = null;
         }
      }
      
      private function onLoad(param1:SwfInfo) : void
      {
         this._headIcon = param1.content as Sprite;
         this._headIcon.mouseChildren = false;
         this._headIcon.mouseEnabled = false;
         this._headIcon.cacheAsBitmap = true;
         this._headIcon.y = 4;
         this._headIcon.x = 4;
         DisplayUtil.uniformScale(this._headIcon,30);
         this._mainUI.addChild(this._headIcon);
      }
   }
}

