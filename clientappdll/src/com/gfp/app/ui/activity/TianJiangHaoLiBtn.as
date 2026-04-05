package com.gfp.app.ui.activity
{
   import com.gfp.app.feature.LeftTimeTxtFeater;
   import com.gfp.app.info.ActivityNodeInfo;
   import com.gfp.app.manager.TianJiangHaoLiManager;
   import com.gfp.app.toolBar.DynamicActivityEntry;
   import com.gfp.core.events.DataEvent;
   import com.gfp.core.events.ExchangeEvent;
   import com.gfp.core.manager.ActivityExchangeCommander;
   import com.gfp.core.manager.ModuleManager;
   import com.gfp.core.manager.UserInfoManager;
   
   public class TianJiangHaoLiBtn extends BaseActivitySprite
   {
      
      private var _leftTimeTxtFeather:LeftTimeTxtFeater;
      
      public function TianJiangHaoLiBtn(param1:ActivityNodeInfo)
      {
         super(param1);
      }
      
      override public function addEvent() : void
      {
         super.addEvent();
         UserInfoManager.ed.addEventListener(DataEvent.DATA_UPDATE,this.dataChangeHandler);
         ActivityExchangeCommander.addEventListener(ExchangeEvent.EXCHANGE_COMPLETE,this.onExchangeComplete);
      }
      
      override public function removeEvent() : void
      {
         super.removeEvent();
         ActivityExchangeCommander.removeEventListener(ExchangeEvent.EXCHANGE_COMPLETE,this.onExchangeComplete);
      }
      
      private function onExchangeComplete(param1:ExchangeEvent) : void
      {
         if(param1.info.id >= 7000 && param1.info.id <= 7009)
         {
            this.tryHide();
         }
      }
      
      override public function executeShow() : Boolean
      {
         if(TianJiangHaoLiManager.getInstance().getCurUsingObj())
         {
            this.startRun();
            return true;
         }
         return false;
      }
      
      private function startRun() : void
      {
         this._leftTimeTxtFeather = new LeftTimeTxtFeater(TianJiangHaoLiManager.getInstance().getCurUsingObj().offtime * 1000,_sprite["txtTime"],this.tryHide,1,true);
         this._leftTimeTxtFeather.start();
      }
      
      override protected function doAction() : void
      {
         if(TianJiangHaoLiManager.getInstance().panelName)
         {
            ModuleManager.turnAppModule(TianJiangHaoLiManager.getInstance().panelName);
         }
      }
      
      private function tryHide() : void
      {
         TianJiangHaoLiManager.getInstance().refresh(false);
      }
      
      protected function dataChangeHandler(param1:DataEvent) : void
      {
         if(!TianJiangHaoLiManager.getInstance().getCurUsingObj())
         {
            DynamicActivityEntry.instance.updateAlign();
         }
      }
   }
}

