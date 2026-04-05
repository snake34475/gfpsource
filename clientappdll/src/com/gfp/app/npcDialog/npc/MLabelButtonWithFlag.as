package com.gfp.app.npcDialog.npc
{
   import com.gfp.core.manager.UIManager;
   import flash.display.Sprite;
   import org.taomee.component.control.MLabelButton;
   import org.taomee.utils.DisplayUtil;
   
   public class MLabelButtonWithFlag extends MLabelButton
   {
      
      private var _flag:Sprite;
      
      private var _icon:Sprite;
      
      private var _index:uint;
      
      public function MLabelButtonWithFlag(param1:uint, param2:String = "Button")
      {
         super(param2);
         this._flag = UIManager.getMovieClip("NPC_FLAG_MC");
         this._flag.x = 5;
         this._flag.y = 3;
         this.setIcon(param1);
         this._icon.x = 20;
         _label.x = 40;
         addChild(this._flag);
         addChild(this._icon);
         this.flag = false;
      }
      
      public function get index() : uint
      {
         return this._index;
      }
      
      public function set index(param1:uint) : void
      {
         this._index = param1;
      }
      
      private function setIcon(param1:uint) : void
      {
         switch(param1)
         {
            case QuestionInfo.PROC_SHOP:
               this._icon = UIManager.getMovieClip("NPC_SHOPPING_ICON");
               break;
            case QuestionInfo.PROC_TASKACCEPT:
               this._icon = UIManager.getMovieClip("NPC_UNACCEPTTASK_ICON");
               break;
            case QuestionInfo.PROC_TASKOVER:
               this._icon = UIManager.getMovieClip("NPC_TASKCOMPLETED_ICON");
               break;
            case QuestionInfo.PROC_DIALOG:
               this._icon = UIManager.getMovieClip("NPC_TALK_ICON");
               break;
            case QuestionInfo.PROC_MINIGAME:
               this._icon = UIManager.getMovieClip("NPC_MINIGAME_ICON");
               break;
            case QuestionInfo.PROC_TOLLGATE:
               this._icon = UIManager.getMovieClip("NPC_SPECIALTOLLGATE_ICON");
               break;
            default:
               this._icon = UIManager.getMovieClip("NPC_SPECIALTOLLGATE_ICON");
         }
      }
      
      public function set flag(param1:Boolean) : void
      {
         this._flag.visible = param1;
      }
      
      override public function destroy() : void
      {
         DisplayUtil.removeForParent(this._flag);
         this._flag = null;
         super.destroy();
      }
   }
}

