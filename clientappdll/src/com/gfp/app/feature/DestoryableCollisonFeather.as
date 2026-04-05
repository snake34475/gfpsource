package com.gfp.app.feature
{
   import com.gfp.app.fight.FightManager;
   import com.gfp.core.events.FightEvent;
   import com.gfp.core.info.UserInfo;
   import com.gfp.core.map.MapManager;
   import com.gfp.core.model.MapModel;
   import flash.geom.Rectangle;
   import flash.utils.Dictionary;
   
   public class DestoryableCollisonFeather
   {
      
      private var _mapModel:MapModel;
      
      private var _blockData:Dictionary = new Dictionary();
      
      public function DestoryableCollisonFeather()
      {
         super();
         this.init();
      }
      
      public function addBlock(param1:int, param2:Rectangle) : void
      {
         var _loc3_:Vector.<Rectangle> = this._blockData[param1];
         if(!_loc3_)
         {
            _loc3_ = new Vector.<Rectangle>();
            this._blockData[param1] = _loc3_;
         }
         _loc3_.push(param2);
         this._mapModel.updatePathData(param2.x * 10,param2.y * 10,param2.width * 10,param2.height * 10,false);
      }
      
      public function removeBlock(param1:int) : void
      {
         var _loc3_:Rectangle = null;
         var _loc2_:Vector.<Rectangle> = this._blockData[param1];
         if(_loc2_)
         {
            if(_loc2_.length == 1)
            {
               _loc3_ = _loc2_[0];
               this._mapModel.recoverPathData(_loc3_.x * 10,_loc3_.y * 10,_loc3_.width * 10,_loc3_.height * 10);
               delete this._blockData[param1];
            }
            else if(_loc2_.length > 1)
            {
               if(this.isNotRepeat(_loc2_))
               {
                  _loc3_ = _loc2_[0];
                  this._mapModel.recoverPathData(_loc3_.x * 10,_loc3_.y * 10,_loc3_.width * 10,_loc3_.height * 10);
               }
               _loc2_.splice(0,1);
            }
         }
      }
      
      private function isNotRepeat(param1:Vector.<Rectangle>) : Boolean
      {
         var _loc2_:Rectangle = param1[0];
         var _loc3_:int = int(param1.length);
         var _loc4_:int = 1;
         while(_loc4_ < _loc3_)
         {
            if(_loc2_.containsRect(param1[_loc4_]) && param1[_loc4_].containsRect(_loc2_))
            {
               return false;
            }
            _loc4_++;
         }
         return true;
      }
      
      public function hasBlock(param1:String) : Boolean
      {
         if(this._blockData[param1])
         {
            return true;
         }
         return false;
      }
      
      public function initData(param1:Array) : void
      {
         var _loc4_:Array = null;
         var _loc2_:int = int(param1.length);
         var _loc3_:int = 0;
         while(_loc3_ < _loc2_)
         {
            _loc4_ = param1[_loc3_];
            this.addBlock(_loc4_[0],_loc4_[1]);
            _loc3_++;
         }
      }
      
      private function init() : void
      {
         this._mapModel = MapManager.currentMap;
         FightManager.instance.addEventListener(FightEvent.OGRE_DIE,this.onOgreDie);
      }
      
      public function destory() : void
      {
         FightManager.instance.removeEventListener(FightEvent.OGRE_DIE,this.onOgreDie);
      }
      
      private function onOgreDie(param1:FightEvent) : void
      {
         var _loc2_:UserInfo = param1.data as UserInfo;
         if(this.hasBlock(_loc2_.roleType.toString()))
         {
            this.removeBlock(_loc2_.roleType);
         }
      }
   }
}

