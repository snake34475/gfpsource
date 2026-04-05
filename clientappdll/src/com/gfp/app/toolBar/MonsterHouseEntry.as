package com.gfp.app.toolBar
{
   import com.gfp.core.controller.ToolBarQuickKey;
   import com.gfp.core.info.UserSummonInfos;
   import com.gfp.core.language.AppLanguageDefine;
   import com.gfp.core.manager.AlertManager;
   import com.gfp.core.manager.SummonManager;
   import com.gfp.core.manager.UIManager;
   import com.gfp.core.map.CityMap;
   import com.gfp.core.map.MapManager;
   import com.gfp.core.map.MapType;
   import com.gfp.core.ui.alert.TextAlert;
   import flash.display.MovieClip;
   import flash.display.SimpleButton;
   import flash.events.MouseEvent;
   import org.taomee.utils.DisplayUtil;
   
   public class MonsterHouseEntry
   {
      
      private static var _instance:MonsterHouseEntry;
      
      private var _clickBtn:SimpleButton;
      
      private var _moveIn:MovieClip;
      
      private var _mainUI:MovieClip;
      
      public function MonsterHouseEntry()
      {
         super();
         this._mainUI = UIManager.getMovieClip("ToolBar_MonsterHouse");
         this._moveIn = this._mainUI["moveIn"];
         this._moveIn.gotoAndStop(1);
         this._moveIn.visible = false;
      }
      
      public static function get instance() : MonsterHouseEntry
      {
         if(_instance == null)
         {
            _instance = new MonsterHouseEntry();
         }
         return _instance;
      }
      
      public static function destroy() : void
      {
         if(_instance)
         {
            _instance.destroy();
            _instance = null;
         }
      }
      
      public function destroy() : void
      {
         this.hide();
         this._mainUI = null;
      }
      
      public function playMove() : void
      {
         this._moveIn.gotoAndPlay(1);
         this._moveIn.visible = true;
      }
      
      public function onStop() : void
      {
         this._moveIn.gotoAndStop(1);
         this._moveIn.visible = false;
      }
      
      public function show() : void
      {
      }
      
      public function hide() : void
      {
         if(this._mainUI)
         {
            this._mainUI.removeEventListener(MouseEvent.CLICK,this.turnMonsterHouse);
            ToolBarQuickKey.unRegistQuickKey(6);
            ToolBarQuickKey.removeTip(this._mainUI);
            DisplayUtil.removeForParent(this._mainUI,false);
         }
      }
      
      private function onQuickKey() : void
      {
         this.turnMonsterHouse(new MouseEvent(MouseEvent.CLICK));
      }
      
      private function turnMonsterHouse(param1:MouseEvent) : void
      {
         var _loc2_:UserSummonInfos = SummonManager.getActorSummonInfo();
         if(_loc2_.summonList.length == 0)
         {
            AlertManager.showSimpleAlarm(AppLanguageDefine.CITYTOOLBAR_CHARACTER_COLLECTION[8]);
            return;
         }
         if(!MapManager.isFightMap)
         {
            if(MapManager.mapInfo.mapType == MapType.MINI_ROOM)
            {
               TextAlert.show(AppLanguageDefine.TOLLGATE_CHARACTER_COLLECTION[8]);
            }
            else
            {
               CityMap.instance.changeMiniHome();
            }
         }
         else
         {
            TextAlert.show(AppLanguageDefine.TOLLGATE_CHARACTER_COLLECTION[7]);
         }
      }
   }
}

