package com.gfp.app.glory
{
   import com.gfp.core.cache.SwfCache;
   import com.gfp.core.cache.SwfInfo;
   import com.gfp.core.config.ClientConfig;
   import com.gfp.core.config.xml.GloryXMLInfo;
   import com.gfp.core.info.GloryInfo;
   import com.gfp.core.info.HonorInfo;
   import com.gfp.core.player.NumSprite;
   import com.gfp.core.ui.ExtenalUIPanel;
   import com.gfp.core.utils.TimeUtil;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.utils.clearTimeout;
   import flash.utils.setTimeout;
   import org.taomee.utils.DisplayUtil;
   import org.taomee.utils.Tick;
   
   public class HonorAchievePopPanel extends Sprite
   {
      
      private var _timeID:uint;
      
      private var _honorID:uint;
      
      private var _mainUI:MovieClip;
      
      private var _animatMC:MovieClip;
      
      private var _icon:Sprite;
      
      private var _iconUrl:String = "";
      
      private var numMc:MovieClip;
      
      private var iconMc:MovieClip;
      
      private var _worldUI:ExtenalUIPanel;
      
      public function HonorAchievePopPanel(param1:HonorInfo)
      {
         super();
         this._worldUI = new ExtenalUIPanel("glory/name/" + param1.id + ".swf",0,1);
         this._honorID = param1.id;
         var _loc2_:GloryInfo = GloryXMLInfo.getHonorInfo(this._honorID);
         _loc2_.creatTime = param1.creatTime;
         this.setInfo(_loc2_);
         this._timeID = setTimeout(this.closePanel,3000);
      }
      
      public function setInfo(param1:GloryInfo) : void
      {
         this._mainUI = new ToolBar_HonorAchieve();
         addChild(this._mainUI);
         this.numMc = this._mainUI["numMc"];
         var _loc2_:NumSprite = new NumSprite(this.numMc,0,false,true);
         _loc2_.value = param1.point;
         this.iconMc = this._mainUI["iconMc"];
         this.iconMc.gotoAndStop(param1.iconID);
         this._animatMC = this._mainUI["animatMC"];
         this._mainUI["descTxt"].text = param1.desc;
         if(param1.creatTime == 0)
         {
            this._mainUI["timeTxt"].text = "未完成";
         }
         else
         {
            this._mainUI["timeTxt"].text = TimeUtil.getSimpleDateStringByTime(param1.creatTime);
         }
         this.setResID(param1.badgeID);
         this._mainUI["worldBed"].addChild(this._worldUI);
         this._worldUI.x = 0;
         this._worldUI.y = 0;
         this._animatMC.addEventListener("animat_end",this.onAnimatEnd);
      }
      
      public function setResID(param1:uint) : void
      {
         this._iconUrl = ClientConfig.getBadgeIcon(param1);
         this.loadIcon();
      }
      
      private function loadIcon() : void
      {
         this.unloadIcon();
         SwfCache.getSwfInfo(this._iconUrl,this.onIconLoaded);
      }
      
      private function onIconLoaded(param1:SwfInfo) : void
      {
         this._icon = param1.content as Sprite;
         this._icon.mouseEnabled = false;
         this._icon.mouseChildren = false;
         this._icon.width = 68;
         this._icon.height = 68;
         this._icon.y = 8;
         this._mainUI.addChild(this._icon);
         SoundGloryPlayer.play(1);
      }
      
      private function unloadIcon() : void
      {
         if(this._icon)
         {
            SwfCache.cancel(this._iconUrl,this.onIconLoaded);
            DisplayUtil.removeForParent(this._icon);
         }
      }
      
      public function destroy() : void
      {
         DisplayUtil.removeForParent(this._mainUI);
         this._mainUI = null;
      }
      
      private function onAnimatEnd(param1:Event) : void
      {
         this._animatMC.removeEventListener("animat_end",this.onAnimatEnd);
         DisplayUtil.removeForParent(this._animatMC);
         this._animatMC = null;
      }
      
      private function closePanel() : void
      {
         Tick.instance.addCallback(this.onTick);
      }
      
      private function onTick(param1:uint) : void
      {
         if(this._mainUI.alpha <= 0)
         {
            Tick.instance.removeCallback(this.onTick);
            this.destroy();
            clearTimeout(this._timeID);
            this._timeID = 0;
            return;
         }
         this._mainUI.alpha -= param1 / 1000;
      }
   }
}

