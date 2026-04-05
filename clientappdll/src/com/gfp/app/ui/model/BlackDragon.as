package com.gfp.app.ui.model
{
   import com.gfp.app.info.BlackDragonInfo;
   import com.gfp.core.manager.MainManager;
   import com.gfp.core.ui.FightBloodBar;
   import com.gfp.core.utils.LineType;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.text.TextField;
   import flash.text.TextFormat;
   import flash.text.TextFormatAlign;
   import flash.utils.getDefinitionByName;
   import flash.utils.getQualifiedClassName;
   
   public class BlackDragon extends Sprite
   {
      
      private var blood:FightBloodBar;
      
      private var sprite:MovieClip;
      
      private var bloodTxt:TextField;
      
      public var info:BlackDragonInfo;
      
      public var isBeated:Boolean = false;
      
      public function BlackDragon()
      {
         super();
         this.buttonMode = true;
         this.useHandCursor = true;
      }
      
      private function init() : void
      {
         var _loc1_:Class = getDefinitionByName("UI_BlackDragon") as Class;
         this.sprite = new _loc1_();
         addChild(this.sprite);
         this.blood = new FightBloodBar(2);
         this.blood.y = -180;
         this.blood.x = -40;
         if(MainManager.loginInfo.lineType == LineType.LINE_TYPE_CT)
         {
            this.blood.init(10000);
         }
         else if(MainManager.loginInfo.lineType == LineType.LINE_TYPE_CT2)
         {
            this.blood.init(1000);
         }
         else
         {
            this.blood.init(6000);
         }
         addChild(this.blood);
         this.bloodTxt = new TextField();
         var _loc2_:TextFormat = new TextFormat();
         _loc2_.align = TextFormatAlign.CENTER;
         this.bloodTxt.defaultTextFormat = _loc2_;
         this.bloodTxt.setTextFormat(_loc2_);
         this.bloodTxt.text = this.blood.bloodCurrent.toString() + "/" + this.blood.bloodTotal.toString();
         this.bloodTxt.width = 105;
         this.bloodTxt.height = 16;
         this.bloodTxt.x = this.blood.x;
         this.bloodTxt.y = this.blood.y - 4;
         addChild(this.bloodTxt);
      }
      
      public function setBlood(param1:int) : void
      {
         var _loc2_:Class = null;
         if(param1 != 0)
         {
            if(this.blood == null)
            {
               this.init();
            }
            this.blood.bloodCurrent = param1;
            this.bloodTxt.text = this.blood.bloodCurrent.toString() + "/" + this.blood.bloodTotal.toString();
         }
         else
         {
            if(Boolean(this.blood) && this.blood.parent == this)
            {
               removeChild(this.blood);
            }
            if(Boolean(this.bloodTxt) && this.bloodTxt.parent == this)
            {
               removeChild(this.bloodTxt);
            }
            if(this.sprite == null || getQualifiedClassName(this.sprite).indexOf("UI_BlackDragon") != -1)
            {
               if(Boolean(this.sprite) && this.sprite.parent == this)
               {
                  removeChild(this.sprite);
               }
               this.isBeated = true;
               _loc2_ = getDefinitionByName("UI_BlackDragonJiao") as Class;
               this.sprite = new _loc2_();
               addChild(this.sprite);
            }
         }
      }
      
      public function destory() : void
      {
         if(this.blood)
         {
            this.blood.destroy();
            this.blood = null;
         }
         this.sprite = null;
      }
   }
}

