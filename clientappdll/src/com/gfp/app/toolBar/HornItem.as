package com.gfp.app.toolBar
{
   import com.gfp.core.info.ReceiveHornInfo;
   import com.gfp.core.manager.UIManager;
   import flash.display.Sprite;
   import flash.text.TextField;
   import org.taomee.utils.DisplayUtil;
   
   public class HornItem extends Sprite
   {
      
      private static const POS:int = 130;
      
      private static const MAX_DISPLAY_TIME:int = 15000;
      
      private var _mainUI:Sprite;
      
      private var _messageTxt:TextField;
      
      private var _isFinished:Boolean = false;
      
      private var _time:int = 15000;
      
      private var _expoItemUI:Sprite;
      
      private var _hornItemUI:Sprite;
      
      public function HornItem()
      {
         super();
      }
      
      public function setInfo(param1:ReceiveHornInfo) : void
      {
         this.clear();
         this.initView(param1.type);
         this.setText(param1.sendNickName + ": " + param1.messageContent);
         this.receive();
      }
      
      public function receive() : void
      {
         this._isFinished = false;
         this._time = MAX_DISPLAY_TIME;
         alpha = 1;
      }
      
      private function initView(param1:int) : void
      {
         if(param1 == HornPanel.TYPE_EXPO)
         {
            this._mainUI = this.getExpoitemUI();
         }
         else
         {
            this._mainUI = this.getHornItem();
         }
         this._messageTxt = this._mainUI["hronText"];
         addChild(this._mainUI);
      }
      
      private function getExpoitemUI() : Sprite
      {
         if(this._expoItemUI == null)
         {
            this._expoItemUI = UIManager.getSprite("com.gfp.app.toolBar.HornExpoItemUI");
         }
         return this._expoItemUI;
      }
      
      private function getHornItem() : Sprite
      {
         if(this._hornItemUI == null)
         {
            this._hornItemUI = UIManager.getSprite("com.gfp.app.toolBar.HornUserItemUI");
         }
         return this._hornItemUI;
      }
      
      private function clear() : void
      {
         if(this._mainUI)
         {
            DisplayUtil.removeAllChild(this._mainUI);
            DisplayUtil.removeForParent(this._mainUI);
         }
      }
      
      private function setText(param1:String) : void
      {
         this._messageTxt.text = param1;
      }
      
      public function destroy() : void
      {
         this._isFinished = true;
         DisplayUtil.removeForParent(this._mainUI);
         this._mainUI = null;
      }
      
      public function setInvTime(param1:int) : void
      {
         if(this._time <= 0)
         {
            if(alpha <= 0)
            {
               this._isFinished = true;
               return;
            }
            alpha -= param1 / 1000;
         }
         else
         {
            this._time -= param1;
         }
      }
      
      public function get isFinished() : Boolean
      {
         return this._isFinished;
      }
   }
}

