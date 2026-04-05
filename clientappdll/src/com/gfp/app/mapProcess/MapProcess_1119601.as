package com.gfp.app.mapProcess
{
   import com.gfp.app.fight.FightOgreManager;
   import com.gfp.core.cache.SwfCache;
   import com.gfp.core.cache.SwfInfo;
   import com.gfp.core.config.ClientConfig;
   import com.gfp.core.config.xml.ItemXMLInfo;
   import com.gfp.core.events.UserEvent;
   import com.gfp.core.info.UserInfo;
   import com.gfp.core.manager.AlertManager;
   import com.gfp.core.manager.ItemManager;
   import com.gfp.core.manager.LayerManager;
   import com.gfp.core.manager.UserManager;
   import com.gfp.core.map.BaseMapProcess;
   import com.gfp.core.model.UserModel;
   import flash.display.MovieClip;
   import flash.utils.clearInterval;
   import flash.utils.clearTimeout;
   import org.taomee.utils.DisplayUtil;
   
   public class MapProcess_1119601 extends BaseMapProcess
   {
      
      private var _exp:int;
      
      private var _mc:MovieClip;
      
      private var _isBossdead:Boolean = false;
      
      private var fuckoff:uint;
      
      private var _timer:uint;
      
      private var _totalTime:int = 180000;
      
      private var _startTime:Number;
      
      private var isSb:Boolean = false;
      
      public function MapProcess_1119601()
      {
         super();
         UserManager.addEventListener(UserEvent.DIE,this.onDie);
         SwfCache.getSwfInfo(ClientConfig.getCartoon("bitchWolfSword"),this.onLoadOver);
      }
      
      private function onDie(param1:UserEvent) : void
      {
         var _loc2_:UserModel = param1.data as UserModel;
         var _loc3_:UserInfo = _loc2_.info;
         if(_loc2_.info.roleType >= 14541 && _loc2_.info.roleType <= 14544)
         {
            if(_loc2_.info.roleType == 14544)
            {
               this.exp += 100000;
               this._isBossdead = true;
            }
            else
            {
               this.exp += (_loc2_.info.roleType - 14540) * 1000;
            }
            if(this._isBossdead && FightOgreManager.ogreNum == 1)
            {
               AlertManager.showSimpleAlarm("恭喜小侠士成功平乱!");
            }
         }
         if(_loc2_.info.roleType == 14540)
         {
            AlertManager.showSimpleAlarm("很遗憾，狼王饮恨沙场，请小侠士重新来战。");
         }
      }
      
      private function onLoadOver(param1:SwfInfo) : void
      {
         this._mc = param1.content as MovieClip;
         this._mc.x = LayerManager.stageWidth - this._mc.width + 46;
         this._mc.y = 206;
         LayerManager.topLevel.addChild(this._mc);
         this.exp = 0;
      }
      
      private function set exp(param1:int) : void
      {
         this._exp = param1;
         if(!this._mc)
         {
            return;
         }
         if(param1 >= 10000)
         {
            if(param1 >= 1000000)
            {
               this._mc["expTxt"].text = "100" + "万";
            }
            else
            {
               this._mc["expTxt"].text = this._exp / 10000 + "万";
            }
         }
         else
         {
            this._mc["expTxt"].text = this._exp.toString();
         }
      }
      
      private function get exp() : int
      {
         return this._exp;
      }
      
      override public function destroy() : void
      {
         ItemManager.addItem(2740637,1);
         AlertManager.showSimpleItemAlarmFly(ItemXMLInfo.getName(2740637),ClientConfig.getItemIcon(2740637),{"num":1});
         UserManager.removeEventListener(UserEvent.DIE,this.onDie);
         SwfCache.cancel(ClientConfig.getCartoon("bitchWolfSword"),this.onLoadOver);
         super.destroy();
         clearTimeout(this.fuckoff);
         clearInterval(this._timer);
         if(this._mc)
         {
            DisplayUtil.removeForParent(this._mc);
         }
      }
   }
}

