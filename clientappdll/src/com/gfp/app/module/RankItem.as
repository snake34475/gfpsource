package com.gfp.app.module
{
   import com.gfp.core.info.RankInfo;
   import flash.display.MovieClip;
   import flash.text.TextField;
   
   public class RankItem
   {
      
      private var _asset:MovieClip;
      
      private var _rankText:TextField;
      
      private var _mimiText:TextField;
      
      private var _nameText:TextField;
      
      private var _scoreText:TextField;
      
      private var _roleIcon:MovieClip;
      
      public function RankItem(param1:MovieClip)
      {
         super();
         this._asset = param1;
         this._rankText = param1["rankText"];
         this._mimiText = param1["mimiText"];
         this._nameText = param1["nameText"];
         this._scoreText = param1["scoreText"];
         this._roleIcon = param1["roleIcon"];
         this._roleIcon.gotoAndStop(1);
      }
      
      public function setInfo(param1:RankInfo) : void
      {
         if(param1 == null)
         {
            this._asset.visible = false;
            return;
         }
         this._asset.visible = true;
         this._rankText.text = param1.rankIndex + "";
         this._mimiText.text = param1.userID + "";
         this._nameText.text = param1.nick;
         this._scoreText.text = param1.socre + "";
         this._roleIcon.gotoAndStop(param1.roleType);
      }
      
      public function get asset() : MovieClip
      {
         return this._asset;
      }
      
      public function dispose() : void
      {
         this._asset = null;
         this._rankText = null;
         this._mimiText = null;
         this._nameText = null;
         this._scoreText = null;
         this._roleIcon = null;
      }
   }
}

