package com.gfp.app.popup
{
   import org.taomee.utils.DisplayUtil;
   
   public class AddFriendPanel
   {
      
      private static var _instance:AddFriendPanelImpl;
      
      public function AddFriendPanel()
      {
         super();
      }
      
      private static function get instance() : AddFriendPanelImpl
      {
         if(_instance == null)
         {
            _instance = new AddFriendPanelImpl();
         }
         return _instance;
      }
      
      public static function show() : void
      {
         if(DisplayUtil.hasParent(instance))
         {
            instance.destroy();
         }
         else
         {
            instance.show();
         }
      }
   }
}

import com.gfp.core.language.AppLanguageDefine;
import com.gfp.core.manager.AlertManager;
import com.gfp.core.manager.LayerManager;
import com.gfp.core.manager.RelationManager;
import com.gfp.core.manager.UIManager;
import com.gfp.core.utils.TextUtil;
import flash.display.SimpleButton;
import flash.display.Sprite;
import flash.events.FocusEvent;
import flash.events.MouseEvent;
import flash.text.TextField;
import org.taomee.utils.AlignType;
import org.taomee.utils.Delegate;
import org.taomee.utils.DisplayUtil;

class AddFriendPanelImpl extends Sprite
{
   
   private static const TEXT:String = AppLanguageDefine.ADDFRIEND_CHARACTER_COLLECTION[0];
   
   private var _mainUI:Sprite;
   
   private var _txt:TextField;
   
   private var _applyBtn:SimpleButton;
   
   private var _cancelBtn:SimpleButton;
   
   private var _bgmc:Sprite;
   
   public function AddFriendPanelImpl()
   {
      super();
      this._mainUI = UIManager.getSprite("Popup_AddFriendPanel");
      this._txt = this._mainUI["txt"];
      this._applyBtn = this._mainUI["applyBtn"];
      this._cancelBtn = this._mainUI["cancelBtn"];
      this._bgmc = this._mainUI["bgMc"];
      addChild(this._mainUI);
      this._txt.restrict = "0-9";
      this._txt.maxChars = 20;
      this._txt.text = TEXT;
   }
   
   public function show() : void
   {
      LayerManager.topLevel.addChild(this);
      DisplayUtil.align(this,null,AlignType.MIDDLE_CENTER);
      this._applyBtn.addEventListener(MouseEvent.CLICK,this.onApply);
      this._cancelBtn.addEventListener(MouseEvent.CLICK,this.onCancel);
      this._txt.addEventListener(FocusEvent.FOCUS_IN,this.onFocusIn);
      this._bgmc.addEventListener(MouseEvent.MOUSE_DOWN,this.onBgDown);
   }
   
   public function destroy() : void
   {
      this._applyBtn.removeEventListener(MouseEvent.CLICK,this.onApply);
      this._cancelBtn.removeEventListener(MouseEvent.CLICK,this.onCancel);
      this._txt.removeEventListener(FocusEvent.FOCUS_IN,this.onFocusIn);
      this._bgmc.removeEventListener(MouseEvent.MOUSE_DOWN,this.onBgDown);
      DisplayUtil.removeForParent(this);
   }
   
   private function onBgDown(param1:MouseEvent) : void
   {
      startDrag();
      this._bgmc.addEventListener(MouseEvent.MOUSE_UP,this.onBgUp);
      this._bgmc.removeEventListener(MouseEvent.MOUSE_DOWN,this.onBgDown);
   }
   
   private function onBgUp(param1:MouseEvent) : void
   {
      stopDrag();
      this._bgmc.addEventListener(MouseEvent.MOUSE_DOWN,this.onBgDown);
      this._bgmc.removeEventListener(MouseEvent.MOUSE_UP,this.onBgUp);
   }
   
   private function onFocusIn(param1:FocusEvent) : void
   {
      this._txt.text = "";
      this._txt.removeEventListener(FocusEvent.FOCUS_IN,this.onFocusIn);
      this._txt.addEventListener(FocusEvent.FOCUS_OUT,this.onFocusOut);
   }
   
   private function onFocusOut(param1:FocusEvent) : void
   {
      if(this._txt.text == "")
      {
         this._txt.text = TEXT;
      }
      this._txt.removeEventListener(FocusEvent.FOCUS_OUT,this.onFocusOut);
      this._txt.addEventListener(FocusEvent.FOCUS_IN,this.onFocusIn);
   }
   
   private function onApply(param1:MouseEvent) : void
   {
      var _loc2_:int = 0;
      var _loc3_:String = null;
      var _loc4_:String = null;
      var _loc5_:Function = null;
      if(this._txt.text != "" && this._txt.text != TEXT)
      {
         _loc2_ = parseInt(this._txt.text);
         if(_loc2_ > 50000 && _loc2_ < 2000000000)
         {
            _loc3_ = TextUtil.getPeopleLink(String(_loc2_),_loc2_,0);
            _loc4_ = AppLanguageDefine.ADDFRIEND_CHARACTER_COLLECTION[1] + _loc3_ + AppLanguageDefine.ADDFRIEND_CHARACTER_COLLECTION[2];
            _loc5_ = Delegate.create(this.applyAddFriend,_loc2_);
            AlertManager.showSimpleAlert(_loc4_,_loc5_);
         }
         else
         {
            AlertManager.showSimpleAlarm(AppLanguageDefine.ADDFRIEND_CHARACTER_COLLECTION[3]);
         }
      }
      this.destroy();
   }
   
   private function applyAddFriend(param1:int) : void
   {
      RelationManager.requestAddFriend(param1);
   }
   
   private function onCancel(param1:MouseEvent) : void
   {
      this.destroy();
   }
}
