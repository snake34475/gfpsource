package com.gfp.app.dragonMaze
{
   import com.gfp.app.user.UserInfoController;
   import com.gfp.core.info.UserInfo;
   import flash.display.SimpleButton;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import flash.text.TextField;
   import org.taomee.utils.DisplayUtil;
   
   public class DragonMazeRankItem extends Sprite
   {
      
      private var _mainUI:Sprite;
      
      private var _infoBtn:SimpleButton;
      
      private var _userID:uint;
      
      private var _creatTime:uint;
      
      private var _indexTxt:TextField;
      
      private var _nickTxt:TextField;
      
      private var _floorTxt:TextField;
      
      public function DragonMazeRankItem()
      {
         super();
         addChild(this._mainUI);
         this._infoBtn = this._mainUI["infoBtn"];
         this._infoBtn.addEventListener(MouseEvent.CLICK,this.onInfoClick);
         this._indexTxt = this._mainUI["indexTxt"];
         this._nickTxt = this._mainUI["nickTxt"];
         this._floorTxt = this._mainUI["floorTxt"];
      }
      
      public function setData(param1:DragonMazeRankInfo, param2:uint) : void
      {
         this._userID = param1.userID;
         this._creatTime = param1.creatTime;
         this._indexTxt.text = param2.toString();
         this._nickTxt.text = param1.nickName;
         this._floorTxt.text = param1.floor.toString();
         this._infoBtn.mouseEnabled = true;
      }
      
      public function setInfo(param1:UserInfo, param2:uint) : void
      {
         this._userID = param1.userID;
         this._creatTime = param1.createTime;
         this._indexTxt.text = param2.toString();
         this._nickTxt.text = param1.nick;
         this._floorTxt.text = "1";
         this._infoBtn.mouseEnabled = true;
      }
      
      public function clear() : void
      {
         this._userID = 0;
         this._creatTime = 0;
         this._indexTxt.text = "";
         this._nickTxt.text = "";
         this._floorTxt.text = "";
         this._infoBtn.mouseEnabled = false;
      }
      
      private function onInfoClick(param1:MouseEvent) : void
      {
         if(this._userID != 0 && this._creatTime != 0)
         {
            UserInfoController.showForID(this._userID,false,this._creatTime,true);
         }
      }
      
      public function destroy() : void
      {
         this._infoBtn.removeEventListener(MouseEvent.CLICK,this.onInfoClick);
         DisplayUtil.removeForParent(this);
         this._mainUI = null;
      }
   }
}

