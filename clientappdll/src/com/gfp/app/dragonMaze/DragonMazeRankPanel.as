package com.gfp.app.dragonMaze
{
   import com.gfp.app.manager.DragonMazeManager;
   import com.gfp.core.manager.LayerManager;
   import com.gfp.core.uic.UIPanel;
   import com.gfp.core.utils.PanelType;
   import flash.display.DisplayObjectContainer;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import flash.geom.Point;
   import org.taomee.utils.AlignType;
   import org.taomee.utils.DisplayUtil;
   
   public class DragonMazeRankPanel extends UIPanel
   {
      
      private var _rankList:Vector.<DragonMazeRankItem>;
      
      private var _panelBg:MovieClip;
      
      public function DragonMazeRankPanel()
      {
         var _loc2_:DragonMazeRankItem = null;
         super(new Sprite());
         _type = PanelType.SHOW;
         this._rankList = new Vector.<DragonMazeRankItem>();
         var _loc1_:int = 0;
         while(_loc1_ < 10)
         {
            _loc2_ = new DragonMazeRankItem();
            _loc2_.x = 24.1;
            _loc2_.y = 39.5 + _loc1_ * 16;
            _mainUI.addChild(_loc2_);
            this._rankList.push(_loc2_);
            _loc1_++;
         }
         this._panelBg = _mainUI["panelBg"];
         this._panelBg.gotoAndStop(1);
         _closeBtn.visible = false;
      }
      
      override public function show(param1:DisplayObjectContainer = null) : void
      {
         super.show(param1);
         DisplayUtil.align(_mainUI,null,AlignType.MIDDLE_LEFT,new Point(0,-50));
      }
      
      public function setData(param1:Array) : void
      {
         var _loc2_:uint = param1.length;
         var _loc3_:int = 0;
         while(_loc3_ < 10)
         {
            if(_loc3_ < _loc2_)
            {
               this._rankList[_loc3_].setData(param1[_loc3_],_loc3_ + 1);
            }
            else
            {
               this._rankList[_loc3_].clear();
            }
            _loc3_++;
         }
      }
      
      public function setInfo(param1:Array) : void
      {
         var _loc2_:uint = param1.length;
         var _loc3_:int = 0;
         while(_loc3_ < 10)
         {
            if(_loc3_ < _loc2_)
            {
               this._rankList[_loc3_].setInfo(param1[_loc3_],_loc3_ + 1);
            }
            else
            {
               this._rankList[_loc3_].clear();
            }
            _loc3_++;
         }
      }
      
      public function setStatus(param1:Boolean) : void
      {
         if(param1)
         {
            this.show(LayerManager.topLevel);
            DisplayUtil.align(_mainUI,null,AlignType.MIDDLE_CENTER);
            _closeBtn.visible = true;
            this._panelBg.gotoAndStop(2);
            _type = PanelType.DESTROY;
         }
      }
      
      override protected function onClose(param1:MouseEvent) : void
      {
         super.onClose(param1);
         DragonMazeManager.instance.quit();
      }
      
      override public function destroy() : void
      {
         var _loc1_:DragonMazeRankItem = null;
         super.destroy();
         if(this._rankList)
         {
            for each(_loc1_ in this._rankList)
            {
               if(_loc1_)
               {
                  DisplayUtil.removeForParent(_loc1_);
                  _loc1_.destroy();
                  _loc1_ = null;
               }
            }
            this._rankList.length = 0;
            this._rankList = null;
         }
      }
   }
}

