package com.gfp.app.ui.activity
{
   import com.gfp.app.info.ActivityMultiNodeInfo;
   import com.gfp.core.CommandID;
   import com.gfp.core.config.ClientConfig;
   import com.gfp.core.controller.ToolBarQuickKey;
   import com.gfp.core.manager.AlertManager;
   import com.gfp.core.manager.ModuleManager;
   import com.gfp.core.manager.SOManager;
   import com.gfp.core.map.MapManager;
   import com.gfp.core.map.MapType;
   import com.gfp.core.net.SocketConnection;
   import com.gfp.core.popup.ModalType;
   import com.gfp.core.utils.StatisticsType;
   import flash.display.MovieClip;
   import flash.net.SharedObject;
   import flash.net.URLRequest;
   import flash.net.sendToURL;
   import org.taomee.utils.DisplayUtil;
   
   public class NewsPaperButton extends BaseActivityMultiSprite
   {
      
      private var _newsFlash:MovieClip;
      
      private var _curNewVersion:uint;
      
      public function NewsPaperButton(param1:ActivityMultiNodeInfo)
      {
         super(param1);
      }
      
      override protected function createChildren() : void
      {
         var _loc2_:uint = 0;
         super.createChildren();
         var _loc1_:SharedObject = SOManager.getUserSO(SOManager.NEW_BOOK);
         if(SOManager.NEW_BOOK in _loc1_.data)
         {
            _loc2_ = uint(_loc1_.data[SOManager.NEW_BOOK]);
         }
         this._curNewVersion = ClientConfig.newsVersion;
         this._newsFlash = _sprite["ToolBar_News_flash"];
         this._newsFlash.mouseChildren = false;
         this._newsFlash.mouseEnabled = false;
         this._newsFlash.visible = _loc2_ != this._curNewVersion;
      }
      
      override public function addEvent() : void
      {
         super.addEvent();
         ToolBarQuickKey.addTip(_sprite,1);
         ToolBarQuickKey.registQuickKey(1,this.onQuickKey);
      }
      
      override public function removeEvent() : void
      {
         super.removeEvent();
         ToolBarQuickKey.removeTip(_sprite);
         ToolBarQuickKey.unRegistQuickKey(1);
      }
      
      private function onQuickKey() : void
      {
         this.doAction();
      }
      
      override protected function doAction() : void
      {
         if(MapManager.currentMap.info.mapType == MapType.TRADE)
         {
            AlertManager.showTradeMapUnavailableAlarm();
            return;
         }
         if(this._newsFlash)
         {
            DisplayUtil.removeForParent(this._newsFlash);
            this.flushCurrVersion();
         }
         SocketConnection.send(CommandID.STATISTICS,StatisticsType.NEWS,1,ClientConfig.newsVersion);
         sendToURL(new URLRequest("http://e.cn.miaozhen.com/r.gif?k=1001445&p=3xdTv0&o="));
         ModuleManager.turnModule(ClientConfig.getAppModule("NewspaperLoadPanel"),"正在加载面板……",{
            "newsId":ClientConfig.newsVersion,
            "displayType":1,
            "modalType":ModalType.DARK
         });
      }
      
      private function flushCurrVersion() : void
      {
         var _loc1_:SharedObject = SOManager.getUserSO(SOManager.NEW_BOOK);
         _loc1_.data[SOManager.NEW_BOOK] = this._curNewVersion;
         SOManager.flush(_loc1_);
      }
   }
}

