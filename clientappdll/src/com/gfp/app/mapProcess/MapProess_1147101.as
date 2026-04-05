package com.gfp.app.mapProcess
{
   import com.gfp.core.events.BuffEvent;
   import com.gfp.core.events.UserEvent;
   import com.gfp.core.manager.LayerManager;
   import com.gfp.core.manager.UserManager;
   import com.gfp.core.map.BaseMapProcess;
   import com.gfp.core.model.OgreModel;
   import com.gfp.core.model.UserModel;
   import flash.display.MovieClip;
   import flash.utils.Dictionary;
   import org.taomee.utils.DisplayUtil;
   
   public class MapProess_1147101 extends BaseMapProcess
   {
      
      private static const TARGETS:Array = [15377,15378];
      
      private static const NOTICE_BUFFID:int = 3471;
      
      private var _listeningMonsters:Array;
      
      private var _noticeMap:Dictionary;
      
      private var _stageNotice:MovieClip;
      
      public function MapProess_1147101()
      {
         super();
      }
      
      override protected function init() : void
      {
         var _loc2_:UserModel = null;
         this._listeningMonsters = [];
         this._noticeMap = new Dictionary();
         var _loc1_:Array = UserManager.getModels();
         for each(_loc2_ in _loc1_)
         {
            this._addBuffListenerAndCheckBuff(_loc2_);
         }
         UserManager.addEventListener(UserEvent.BORN,this._monsterAddHandler);
         this._stageNotice = _mapModel.libManager.getMovieClip("StageNotice1141301");
         this._stageNotice.x = LayerManager.stageWidth - this._stageNotice.width;
         LayerManager.topLevel.addChild(this._stageNotice);
      }
      
      private function _monsterAddHandler(param1:UserEvent) : void
      {
         this._addBuffListenerAndCheckBuff(param1.data as UserModel);
      }
      
      private function _addBuffListenerAndCheckBuff(param1:UserModel) : void
      {
         if(param1 is OgreModel && TARGETS.indexOf(param1.info.roleType) != -1)
         {
            param1.addEventListener(BuffEvent.BUFF_START_ON_SERVER,this._buffAddHandler);
            param1.addEventListener(BuffEvent.BUFF_END_ON_SERVER,this._buffRemoveHandler);
            param1.addEventListener(BuffEvent.BUFFS_CLEAR,this._buffAllRemovedHandler);
            this._listeningMonsters.push(param1);
            this._checkBuff(param1);
         }
      }
      
      private function _checkBuff(param1:UserModel) : void
      {
         this._changeNotice(param1,param1.buffManager.ishasBuff(NOTICE_BUFFID));
      }
      
      private function _changeNotice(param1:UserModel, param2:Boolean) : void
      {
         var _loc3_:MovieClip = this._noticeMap[param1];
         if(_loc3_ == null)
         {
            _loc3_ = _mapModel.libManager.getMovieClip("BuffNotice");
            _loc3_.stop();
            _loc3_.x = -25;
            _loc3_.y = -265;
            param1.addChild(_loc3_);
            this._noticeMap[param1] = _loc3_;
         }
         _loc3_.gotoAndStop(param2 ? 1 : 2);
      }
      
      protected function _buffAddHandler(param1:BuffEvent) : void
      {
         var _loc2_:OgreModel = param1.currentTarget as OgreModel;
         if(Boolean(_loc2_) && param1.buffID == NOTICE_BUFFID)
         {
            this._changeNotice(_loc2_,true);
         }
      }
      
      private function _whenRemoveBuff(param1:OgreModel, param2:uint = 1) : void
      {
         if(Boolean(param1) && (param2 == -1 || param2 == NOTICE_BUFFID))
         {
            this._changeNotice(param1,false);
         }
      }
      
      protected function _buffRemoveHandler(param1:BuffEvent) : void
      {
         this._whenRemoveBuff(param1.currentTarget as OgreModel,param1.buffID);
      }
      
      protected function _buffAllRemovedHandler(param1:BuffEvent) : void
      {
         var _loc2_:UserModel = null;
         for each(_loc2_ in this._listeningMonsters)
         {
            this._whenRemoveBuff(_loc2_ as OgreModel);
         }
      }
      
      override public function destroy() : void
      {
         var _loc1_:MovieClip = null;
         var _loc2_:UserModel = null;
         super.destroy();
         UserManager.removeEventListener(UserEvent.BORN,this._monsterAddHandler);
         for each(_loc2_ in this._listeningMonsters)
         {
            _loc2_.removeEventListener(BuffEvent.BUFF_START_ON_SERVER,this._buffAddHandler);
            _loc2_.removeEventListener(BuffEvent.BUFF_END_ON_SERVER,this._buffRemoveHandler);
            _loc2_.removeEventListener(BuffEvent.BUFFS_CLEAR,this._buffAllRemovedHandler);
            _loc1_ = this._noticeMap[_loc2_];
            if(_loc1_)
            {
               _loc2_.removeChild(_loc1_);
               _loc1_.stop();
               delete this._noticeMap[_loc2_];
            }
         }
         this._listeningMonsters.length = 0;
         this._listeningMonsters = null;
         this._noticeMap = null;
         DisplayUtil.removeForParent(this._stageNotice);
         this._stageNotice = null;
      }
   }
}

