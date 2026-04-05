package com.gfp.app.tips
{
   import com.gfp.core.config.xml.RoleXMLInfo;
   import com.gfp.core.manager.UIManager;
   import com.gfp.core.model.CustomUserModel;
   import com.gfp.core.model.SpriteModel;
   import com.gfp.core.utils.SpriteType;
   import flash.display.Sprite;
   import flash.geom.Point;
   import flash.text.TextField;
   
   public class RoleTipsMC extends Sprite
   {
      
      private var _mainUI:Sprite;
      
      private var _descTxt:TextField;
      
      private var _userModel:CustomUserModel;
      
      private var _px:Number = 0;
      
      private var _py:Number = 0;
      
      private var _sx:Number = 1;
      
      private var _sy:Number = 1;
      
      public function RoleTipsMC()
      {
         super();
         this._mainUI = UIManager.getSprite("Tip_Role");
         addChild(this._mainUI);
      }
      
      public function get descTxt() : TextField
      {
         return this._descTxt;
      }
      
      public function set descStr(param1:String) : void
      {
         this._descTxt = this._mainUI["descTxt"];
         this._descTxt.text = param1;
      }
      
      public function setPosAndScale(param1:int, param2:int, param3:Number, param4:Number) : void
      {
         this._px = param1;
         this._py = param2;
         this._sx = param3;
         this._sy = param4;
      }
      
      public function setData(param1:*) : void
      {
         var _loc2_:uint = 0;
         var _loc3_:int = 0;
         if(param1 is uint)
         {
            if(this._userModel)
            {
               this._userModel.destroy();
               this._userModel = null;
            }
            _loc2_ = uint(RoleXMLInfo.getHeight(param1));
            if(_loc2_ > 190 || Boolean(RoleXMLInfo.isRide(param1)))
            {
               _loc3_ = 0;
               this._mainUI["bg"].gotoAndStop(2);
            }
            else if(SpriteModel.getSpriteType(param1) == SpriteType.GOD)
            {
               _loc3_ = 50;
               this._mainUI["bg"].gotoAndStop(1);
            }
            else
            {
               _loc3_ = (_loc2_ - 170) / 2 - 10;
               this._mainUI["bg"].gotoAndStop(1);
            }
            this._userModel = new CustomUserModel(param1);
            this._userModel.show(new Point(0 + this._px,_loc3_ + this._py),this._mainUI["userCon"],false,this._sx,this._sy);
         }
      }
      
      public function destroy() : void
      {
         if(this._userModel)
         {
            this._userModel.destroy();
            this._userModel = null;
         }
         this._mainUI = null;
      }
   }
}

