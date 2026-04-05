package com.gfp.app.tips
{
   import com.gfp.core.cache.SwfCache;
   import com.gfp.core.cache.SwfInfo;
   import com.gfp.core.config.ClientConfig;
   import com.gfp.core.config.xml.GodGuardXMLInfo;
   import com.gfp.core.config.xml.RoleXMLInfo;
   import com.gfp.core.info.GodInstanceInfo;
   import com.gfp.core.info.GodSummonGuardInfo;
   import com.gfp.core.info.RoleInfo;
   import com.gfp.core.manager.GodGuardManager;
   import com.gfp.core.ui.tips.BaseTips;
   import flash.display.MovieClip;
   
   public class MatrixGodTips extends BaseTips
   {
      
      private var _godInfo:GodInstanceInfo;
      
      private var _ui:MovieClip;
      
      public function MatrixGodTips(param1:GodInstanceInfo)
      {
         this._godInfo = param1;
         super(param1);
         SwfCache.getSwfInfo(ClientConfig.getResPath("tips/MatrixGodTipsUI.swf"),this.onIconLoaded);
      }
      
      private function onIconLoaded(param1:SwfInfo) : void
      {
         if(mcContainer == null)
         {
            this._ui = param1.content as MovieClip;
            this.setup();
         }
      }
      
      override public function setup() : void
      {
         if(!this._ui)
         {
            return;
         }
         mcContainer = this._ui;
         addChild(mcContainer);
         var _loc1_:GodSummonGuardInfo = GodGuardXMLInfo.getGodGuardInfo(this._godInfo.roleType,GodSummonGuardInfo.GOD_TYPE);
         var _loc2_:int = int(GodGuardManager.instance.getMatrixIndex(this._godInfo.roleType));
         if(_loc2_ != 7 && _loc2_ != 8)
         {
            mcContainer["settedLabel"].visible = false;
         }
         else
         {
            mcContainer["unSettedMC"].visible = false;
         }
         mcContainer["hpLabel"].text = "" + (_loc1_.hp == 0 ? "0" : _loc1_.hp + "%");
         mcContainer["mpLabel"].text = "" + (_loc1_.mp == 0 ? "0" : _loc1_.mp + "%");
         mcContainer["atkLabel"].text = "" + (_loc1_.atk == 0 ? "0" : _loc1_.atk + "%");
         mcContainer["defLabel"].text = "" + (_loc1_.def == 0 ? "0" : _loc1_.def + "%");
         mcContainer["hitLabel"].text = "" + (_loc1_.hit == 0 ? "0" : _loc1_.hit + "%");
         mcContainer["dodgeLabel"].text = "" + (_loc1_.dodge == 0 ? "0" : _loc1_.dodge + "%");
         mcContainer["critLabel"].text = "" + (_loc1_.crit == 0 ? "0" : _loc1_.crit + "%");
         var _loc3_:RoleInfo = RoleXMLInfo.getInfo(this._godInfo.roleType);
         if(_loc3_)
         {
            mcContainer["hpForJudian"].text = _loc3_.hp == 0 ? "0" : _loc3_.hp.toString();
            mcContainer["atkForJudian"].text = _loc3_.atk == 0 ? "0" : _loc3_.atk.toString();
            mcContainer["atkDurForJudian"].text = _loc3_.atkDuration == 0 ? "0" : _loc3_.atkDuration.toString();
            mcContainer["jieForJudian"].text = _loc3_.gradation == 0 ? "0" : _loc3_.gradation.toString();
         }
         else
         {
            mcContainer["hpForJudian"].text = "0";
            mcContainer["attForJudian"].text = "0";
            mcContainer["atkDurForJudian"].text = "0";
            mcContainer["jieForJudian"].text = "0";
         }
         if(_loc1_.featureType == 0)
         {
            mcContainer["specialityLabel"].text = "无";
         }
         else
         {
            mcContainer["specialityLabel"].text = GodGuardXMLInfo.typeLanguageMap[_loc1_.featureType] + "+" + _loc1_.featureValue;
         }
      }
   }
}

