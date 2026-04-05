package com.gfp.app.ui.activity
{
   import com.gfp.app.info.ActivityNodeInfo;
   import com.gfp.core.manager.ModuleManager;
   import com.gfp.core.utils.TimeUtil;
   import flash.display.MovieClip;
   
   public class StrongestGuardButton extends BaseActivitySprite
   {
      
      private var _btnMC:MovieClip;
      
      private var _startDate:Date = new Date(2017,4,12,0,0,0);
      
      private var _frame:int;
      
      private var _panelName:Array = ["StrongestGuardKuanPanel","StrongestGuardJiePanel","StrongestGuardChengPanel","StrongestGuardXiPanel","StrongestGuardYiPanel","StrongestGuardKangPanel"];
      
      public function StrongestGuardButton(param1:ActivityNodeInfo)
      {
         super(param1);
      }
      
      override protected function createChildren() : void
      {
         super.createChildren();
         this._btnMC = _sprite["btnMC"];
         var _loc1_:Date = TimeUtil.getSeverDateObject();
         this._frame = (_loc1_.time - this._startDate.time) / 604800000 % 6;
         if(this._frame < 0)
         {
            this._frame = 0;
         }
         this._btnMC.gotoAndStop(this._frame + 1);
      }
      
      override protected function doAction() : void
      {
         ModuleManager.turnAppModule(this._panelName[this._frame]);
      }
   }
}

