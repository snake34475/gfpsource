package com.gfp.app.mapProcess
{
   import com.gfp.core.events.UserEvent;
   import com.gfp.core.manager.LayerManager;
   import com.gfp.core.manager.MainManager;
   import com.gfp.core.manager.UserManager;
   import com.gfp.core.map.BaseMapProcess;
   import com.gfp.core.model.UserModel;
   import com.greensock.TweenMax;
   import flash.display.MovieClip;
   import flash.utils.ByteArray;
   import org.taomee.net.SocketEvent;
   import org.taomee.utils.AlignType;
   import org.taomee.utils.DisplayUtil;
   
   public class MapProcess_1114501 extends BaseMapProcess
   {
      
      private var _txtWarnMc:MovieClip;
      
      public function MapProcess_1114501()
      {
         super();
      }
      
      override protected function init() : void
      {
         this.addEventListener();
         this._txtWarnMc = _mapModel.libManager.getMovieClip("UI_MachaoSpear");
         this._txtWarnMc.gotoAndStop(1);
      }
      
      private function addEventListener() : void
      {
         UserManager.addEventListener(UserEvent.DIE,this.onMonsterDie);
      }
      
      private function removeEventListener() : void
      {
         UserManager.removeEventListener(UserEvent.DIE,this.onMonsterDie);
      }
      
      private function onStageProChange(param1:SocketEvent) : void
      {
         var _loc2_:ByteArray = param1.data as ByteArray;
         _loc2_.position = 0;
         var _loc3_:uint = _loc2_.readUnsignedInt();
         var _loc4_:uint = _loc2_.readUnsignedInt();
      }
      
      private function onMonsterDie(param1:UserEvent) : void
      {
         var _loc3_:UserModel = null;
         var _loc4_:Number = NaN;
         var _loc2_:UserModel = param1.data as UserModel;
         if(_loc2_ == null || _loc2_.info == null)
         {
            return;
         }
         if(_loc2_.info.userID == MainManager.actorID)
         {
            _loc3_ = UserManager.getModelByRoleType(14383);
            _loc4_ = _loc3_.info.hp / _loc3_.info.maxHp;
            DisplayUtil.align(this._txtWarnMc,null,AlignType.MIDDLE_CENTER);
            LayerManager.topLevel.addChild(this._txtWarnMc);
            if(_loc4_ >= 0.9)
            {
               this._txtWarnMc.gotoAndStop(1);
            }
            else if(_loc4_ >= 0.6)
            {
               this._txtWarnMc.gotoAndStop(2);
            }
            else if(_loc4_ >= 0.3)
            {
               this._txtWarnMc.gotoAndStop(3);
            }
            else
            {
               this._txtWarnMc.gotoAndStop(4);
            }
            TweenMax.to(this._txtWarnMc,5,{
               "alpha":0,
               "delay":2,
               "onComplete":this.warnMcTweenOver
            });
         }
         else if(_loc2_.info.roleType == 14383)
         {
            DisplayUtil.align(this._txtWarnMc,null,AlignType.MIDDLE_CENTER);
            LayerManager.topLevel.addChild(this._txtWarnMc);
            this._txtWarnMc.gotoAndStop(5);
            TweenMax.to(this._txtWarnMc,5,{
               "alpha":0,
               "delay":2,
               "onComplete":this.warnMcTweenOver
            });
         }
      }
      
      private function warnMcTweenOver() : void
      {
         TweenMax.killChildTweensOf(this._txtWarnMc);
         LayerManager.topLevel.removeChild(this._txtWarnMc);
      }
      
      override public function destroy() : void
      {
         this.removeEventListener();
         TweenMax.killChildTweensOf(this._txtWarnMc);
         DisplayUtil.removeForParent(this._txtWarnMc);
      }
   }
}

