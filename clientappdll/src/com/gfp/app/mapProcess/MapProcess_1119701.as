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
   
   public class MapProcess_1119701 extends BaseMapProcess
   {
      
      private var _exp:int;
      
      private var _born:int;
      
      private var _mc:MovieClip;
      
      private var fuckoff:uint;
      
      private var _isBossdead:Boolean = false;
      
      private var _timer:uint;
      
      private var _totalTime:int = 180000;
      
      private var _startTime:Number;
      
      public function MapProcess_1119701()
      {
         super();
         UserManager.addEventListener(UserEvent.DIE,this.onDie);
         SwfCache.getSwfInfo(ClientConfig.getCartoon("bitchWolfShield"),this.onLoadOver);
      }
      
      private function onDie(param1:UserEvent) : void
      {
         var _loc2_:UserModel = param1.data as UserModel;
         var _loc3_:UserInfo = _loc2_.info;
         if(_loc2_.info.roleType >= 14546 && _loc2_.info.roleType <= 14550)
         {
            if(_loc2_.info.roleType == 14549)
            {
               this.exp += 300000;
               this._isBossdead = true;
            }
            if(_loc2_.info.roleType == 14550)
            {
               this.born += 4;
            }
            else
            {
               this.exp += (_loc2_.info.roleType - 14545) * 3000;
            }
            if(this._isBossdead && FightOgreManager.ogreNum == 1)
            {
               AlertManager.showSimpleAlarm("恭喜小侠士成功平乱!");
            }
         }
         if(_loc2_.info.roleType == 14545)
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
         this.born = 0;
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
            if(param1 >= 3000000)
            {
               this._mc["expTxt"].text = "300" + "万";
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
      
      private function set born(param1:int) : void
      {
         this._born = param1;
         if(!this._mc)
         {
            return;
         }
         if(param1 >= 40)
         {
            this._mc["bornTxt"].text = "40";
         }
         else
         {
            this._mc["bornTxt"].text = this._born.toString();
         }
      }
      
      private function get born() : int
      {
         return this._born;
      }
      
      override public function destroy() : void
      {
         ItemManager.addItem(2740637,1);
         AlertManager.showSimpleItemAlarmFly(ItemXMLInfo.getName(2740637),ClientConfig.getItemIcon(2740637),{"num":1});
         UserManager.removeEventListener(UserEvent.DIE,this.onDie);
         SwfCache.cancel(ClientConfig.getCartoon("bitchWolfShield"),this.onLoadOver);
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

