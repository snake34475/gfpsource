package com.gfp.app.npcDialog
{
   import com.gfp.app.cartoon.AnimatPlay;
   import com.gfp.app.cartoon.event.AnimatEvent;
   import com.gfp.app.config.xml.DialogXMLInfo;
   import com.gfp.app.fight.PveEntry;
   import com.gfp.app.info.dialog.DialogCustomInfo;
   import com.gfp.app.info.dialog.DialogInfoMultiple;
   import com.gfp.app.info.dialog.NpcDialogInfo;
   import com.gfp.app.question.OptionInfo;
   import com.gfp.app.question.PuzzleInfo;
   import com.gfp.app.question.PuzzleXMLInfo;
   import com.gfp.core.CommandID;
   import com.gfp.core.manager.ActivityExchangeTimesManager;
   import com.gfp.core.manager.AlertManager;
   import com.gfp.core.manager.LayerManager;
   import com.gfp.core.manager.UIManager;
   import com.gfp.core.net.SocketConnection;
   import com.gfp.core.ui.alert.TextAlert;
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.utils.ByteArray;
   import flash.utils.clearTimeout;
   import flash.utils.setTimeout;
   import org.taomee.net.SocketEvent;
   
   public class PuzzleController
   {
      
      private static var _instance:PuzzleController;
      
      public static const FOUR:int = 3;
      
      public static const THREE:int = 2;
      
      public static const TWO:int = 1;
      
      public static const ONE:int = 0;
      
      public static const ACTIVIYY_ID:int = 114;
      
      public static const MAX:int = 4;
      
      public static const EXE:int = 3228;
      
      public static const MAX_EXE:int = 48;
      
      private static const PUZZLE:Array = [[166,167,168,169,170,171,172,173,174],[175,176,177,178,179,180,181,182,183],[184,185,186,187,188,189,190,191,192],[193,194,195,196,197,198,199,200,201]];
      
      private static const DIALOG_ID:Object = {
         1040220:true,
         1040221:true,
         1004820:true,
         1004821:true,
         1012320:true,
         1012321:true
      };
      
      private var mNpc:int;
      
      private var mPuzzle:int;
      
      private var mHead:int;
      
      private var puzzleID:int;
      
      private var time:uint;
      
      private var allArray:Array;
      
      private var puzzleArray:Array;
      
      private var isNPCChange:Boolean;
      
      private var isEndHint:Boolean;
      
      public function PuzzleController()
      {
         super();
         this.allArray = [[10402,["咳咳~咳！小侠士你一定要帮帮我啊，我睡了一夜醒来就变的这么老，也不知道是谁下的毒手，而且整个功夫城广场的居民都变成这样，而且经过药师爷爷的诊断发现我已经180岁了，你一定要帮帮我啊！","线索？我想想.......有了，虽然我不知道作恶的是谁，但是另一个受害者也许知道。","别着急，我这也有一些线索，不过都是一些莫名其妙的问题，你要是足够聪明能回答对，就一定能发现一些蛛丝马迹，回答正确我再给你一些奖励助你查探。"],["我正是来查明此事的，您能不能提供一些线索？","另一个受害者是谁？","快让我看看什么样的线索！"],["这还是我第一次遭遇如此恶作剧，听说<font color=\'#FF0000\'>陆半仙</font>也遭遇毒手，你快去他那问问情况，说不定有发现。"],["非常感谢您，一百八十岁的万通通老爷爷！"],"万通通",this.nextHint],[10048,["重阳佳节，我本准备许多礼物赠送给各位老侠士，没想到我竟一夜白头，变成个老半仙，咳咳咳！这可怎么办呐？","我这也有一部分题目，小侠士快拿去看看，希望对你有所帮助。"],["我来就是帮你找凶手的！","谢谢半仙，让我来看看！"],["那些作恶的人，听口音好像是西部大陆的。在我后面遭遇毒手的应该是<font color=\'#FF0000\'>海振兴</font>，你快去他那问问情况，说不定有更大发现。"],["非常感谢您，一百八十岁陆半仙老爷爷！"],"陆半仙",this.nextHint],[10123,["老了老了，什么也干不了了。到底是谁这么可恶，连我这老骨头也不放过！","我这有一些跟他们不一样的线索，你快来看看，咳咳~咳咳咳！"],["您别生气，保重身体要紧。","让我来看看吧！"],["那些人好像裹着黑衣，会邪恶法术，我猜是黑暗军团的人。连<font color=\'#FF0000\'>张三金</font>那小孩也遭遇如此惨剧，你可要小心。"],["非常感谢您的线索，一百八十岁海振兴老爷爷！"],"海振兴",this.nextHint],[10123,["没想到我张三金也会遭此毒手！这么年轻英俊的我啊！太可恶了！","线索？就那些稀奇古怪的题目？有啊，当然有了！"],["你这没线索吗？","快给我看看！"],["好了，我能告诉你的就这些了,说不定是功夫城哪个捣蛋鬼在恶作剧,你快去其他地方查探。"]
         ,["奇怪，作恶的人来自西部大陆，又会邪恶法术，难道不是黑暗军团的人吗？"],"张三金",this.enterFight]];
      }
      
      public static function get instance() : PuzzleController
      {
         return _instance || (_instance = new PuzzleController());
      }
      
      public function getInfo() : void
      {
         SocketConnection.addCmdListener(CommandID.PUZZLE_INFO,this.onInfo);
         SocketConnection.send(CommandID.PUZZLE_INFO,ACTIVIYY_ID);
      }
      
      private function onInfo(param1:SocketEvent) : void
      {
         SocketConnection.removeCmdListener(CommandID.PUZZLE_INFO,this.onInfo);
         var _loc2_:ByteArray = param1.data as ByteArray;
         _loc2_.position = 0;
         var _loc3_:int = int(_loc2_.readUnsignedInt());
         if(_loc3_ != ACTIVIYY_ID)
         {
            return;
         }
         this.npc = _loc2_.readUnsignedInt();
         this.puzzle = _loc2_.readUnsignedInt();
      }
      
      private function sendPuzzle(param1:int) : void
      {
         SocketConnection.addCmdListener(CommandID.PUZZLE_FOR_DATI,this.onDaTi);
         SocketConnection.send(CommandID.PUZZLE_FOR_DATI,ACTIVIYY_ID,this.puzzleID,param1 + 1);
      }
      
      private function onDaTi(param1:SocketEvent) : void
      {
         SocketConnection.removeCmdListener(CommandID.PUZZLE_FOR_DATI,this.onDaTi);
         var _loc2_:ByteArray = param1.data as ByteArray;
         _loc2_.position = 0;
         var _loc3_:int = int(_loc2_.readUnsignedInt());
         var _loc4_:int = int(_loc2_.readUnsignedInt());
         var _loc5_:int = int(_loc2_.readUnsignedInt());
         if(_loc3_ != ACTIVIYY_ID)
         {
            return;
         }
         ActivityExchangeTimesManager.updataTimesByOnce(EXE);
         if(_loc5_ == 1)
         {
            TextAlert.show("恭喜你小侠士，回答正确！");
         }
         else
         {
            TextAlert.show("很遗憾小侠士，你回答错误了！");
         }
         this.nextPuzzle();
         this.getInfo();
      }
      
      private function nextPuzzle() : void
      {
         if(this.puzzle + 1 >= MAX)
         {
            this.onPuzzleEnd();
         }
         else
         {
            ++this.puzzle;
            this.doPuzzle();
         }
      }
      
      public function start(param1:int) : void
      {
         if(ActivityExchangeTimesManager.getTimes(EXE) >= MAX_EXE)
         {
            this.showOver(param1);
            return;
         }
         if(this.npc != param1)
         {
            this.showAlert(param1);
            return;
         }
         this.puzzleArray = (PUZZLE[this.npc] as Array).concat();
         this.isNPCChange = false;
         this.dialog(this.npc);
      }
      
      private function onPuzzleEnd() : void
      {
         this.end(this.npc);
         this.puzzle = 0;
      }
      
      private function doPuzzle() : void
      {
         var info:PuzzleInfo;
         var op:OptionInfo = null;
         var dialog:DialogInfoMultiple = null;
         var array:Array = this.puzzleArray;
         var index:int = int(Math.random() * array.length);
         this.puzzleID = array.splice(index,1)[0];
         info = PuzzleXMLInfo.getPuzzleInfo(this.puzzleID);
         info.options.sort(function(param1:OptionInfo, param2:OptionInfo):int
         {
            return param1.index - param2.index;
         });
         array = [];
         for each(op in info.options)
         {
            array.push(op.label);
         }
         dialog = new DialogInfoMultiple([info.qName],array);
         clearTimeout(this.time);
         this.time = setTimeout(NpcDialogController.showForMultipleEx,0,dialog,this.mHead,this.sendPuzzle,2);
         this.isEndHint = false;
      }
      
      private function dialog(param1:int) : void
      {
         this.mHead = this.allArray[param1][0];
         if(this.puzzle == 0)
         {
            NpcDialogController.showForSingles(this.allArray[param1][1],this.allArray[param1][2],this.mHead,this.doPuzzle);
         }
         else
         {
            this.doPuzzle();
         }
      }
      
      private function end(param1:int) : void
      {
         NpcDialogController.showForSingles(this.allArray[param1][3],this.allArray[param1][4],this.allArray[param1][0],this.allArray[param1][6],this.allArray[param1][6]);
      }
      
      private function nextHint() : void
      {
         this.isEndHint = true;
         if(this.isNPCChange)
         {
            this.showHint();
         }
      }
      
      private function enterFight() : void
      {
         AnimatPlay.startAnimat("ChongYang180",-1,false,0,0,false,true,true);
         AnimatPlay.addAnimatListener(AnimatEvent.ANIMAT_END,this.onPlayEnd);
      }
      
      private function onPlayEnd(param1:Event) : void
      {
         AnimatPlay.removeAnimatListener(AnimatEvent.ANIMAT_END,this.onPlayEnd);
         PveEntry.enterTollgate(591);
      }
      
      private function playMC(param1:String) : void
      {
         var _loc2_:Class = UIManager.getClass(param1);
         var _loc3_:MovieClip = new _loc2_();
         _loc3_.gotoAndPlay(1);
         _loc3_.addEventListener(Event.ENTER_FRAME,this.onEnterFrame);
         LayerManager.topLevel.addChild(_loc3_);
      }
      
      protected function onEnterFrame(param1:Event) : void
      {
         var _loc2_:MovieClip = param1.currentTarget as MovieClip;
         if(_loc2_.currentFrame == _loc2_.totalFrames)
         {
            _loc2_.removeEventListener(Event.ENTER_FRAME,this.onEnterFrame);
            if(_loc2_.parent)
            {
               _loc2_.parent.removeChild(_loc2_);
            }
         }
      }
      
      private function showAlert(param1:int) : void
      {
         var _loc2_:Array = ["我把我所知道的情况全部告诉你了，你应该去找<font color=\'#FF0000\'>" + this.allArray[this.npc][5] + "</font>。"];
         var _loc3_:Array = ["我知道了"];
         NpcDialogController.showForSingles(_loc2_,_loc3_,this.allArray[param1][0]);
      }
      
      private function showHint() : void
      {
         AlertManager.showSimpleAlarm("原来<font color=\'#FF0000\'>" + this.allArray[this.npc][5] + "</font>也变成了180岁老侠士，快去附近找他问问情况吧！");
         this.isNPCChange = false;
         this.isEndHint = false;
      }
      
      private function showOver(param1:int) : void
      {
         var _loc2_:Array = ["感谢你，热情的小侠士，不过你的次数已经用完了，你可以明天再来！"];
         var _loc3_:Array = ["我知道了"];
         NpcDialogController.showForSingles(_loc2_,_loc3_,this.allArray[param1][0]);
      }
      
      public function get puzzle() : int
      {
         return this.mPuzzle;
      }
      
      public function set puzzle(param1:int) : void
      {
         this.mPuzzle = param1;
      }
      
      public function get npc() : int
      {
         return this.mNpc;
      }
      
      public function set npc(param1:int) : void
      {
         var _loc2_:int = this.mNpc;
         this.mNpc = param1;
         this.setEnabled(this.allArray[1][0],this.mNpc == 1);
         this.setEnabled(this.allArray[2][0],this.mNpc == 2);
         if(this.mNpc != 0 && _loc2_ != this.mNpc)
         {
            this.isNPCChange = true;
            if(this.isEndHint)
            {
               this.showHint();
            }
         }
         else
         {
            this.isNPCChange = false;
         }
      }
      
      private function setEnabled(param1:int, param2:Boolean) : void
      {
         var _loc4_:DialogCustomInfo = null;
         var _loc3_:NpcDialogInfo = DialogXMLInfo.getInfos(param1);
         for each(_loc4_ in _loc3_.customDialogs)
         {
            if(DIALOG_ID[_loc4_.id])
            {
               if(param2)
               {
                  _loc4_.startTime = null;
                  _loc4_.endTime = null;
               }
               else
               {
                  _loc4_.startTime = new Date(2000);
                  _loc4_.endTime = new Date(2000);
               }
            }
         }
      }
   }
}

