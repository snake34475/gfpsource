package com.gfp.app.ui.model
{
   import com.gfp.core.cache.SwfCache;
   import com.gfp.core.cache.SwfInfo;
   import com.gfp.core.config.ClientConfig;
   import com.gfp.core.config.xml.RoleXMLInfo;
   import com.gfp.core.manager.UIManager;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.text.TextField;
   import org.taomee.utils.DisplayUtil;
   
   public class BossBlood extends Sprite
   {
      
      private var bossMainUI:Sprite;
      
      private var bossNameTxt:TextField;
      
      private var bossHpBar:MovieClip;
      
      private var bossHeadIcon:Sprite;
      
      public function BossBlood()
      {
         super();
         this.init();
      }
      
      private function init() : void
      {
         this.bossMainUI = UIManager.getSprite("Boss_OgreInfoPanel");
         this.bossNameTxt = this.bossMainUI["nameTxt"];
         this.bossHpBar = this.bossMainUI["hp_mc"];
         addChild(this.bossMainUI);
      }
      
      public function set nickName(param1:String) : void
      {
         this.bossNameTxt.text = param1;
      }
      
      public function setBlood(param1:int, param2:int) : void
      {
         this.bossHpBar.scaleX = Math.min(param1 / param2,1);
      }
      
      public function setIcon(param1:int) : void
      {
         SwfCache.getSwfInfo(ClientConfig.getRoleIcon(RoleXMLInfo.getResID(param1)),this.bossOnLoad);
      }
      
      private function bossOnLoad(param1:SwfInfo) : void
      {
         var _loc2_:Sprite = param1.content as Sprite;
         _loc2_.mouseChildren = false;
         _loc2_.mouseEnabled = false;
         _loc2_.cacheAsBitmap = true;
         _loc2_.y = 38;
         _loc2_.x = 430;
         DisplayUtil.uniformScale(_loc2_,50);
         this.addChild(_loc2_);
      }
   }
}

