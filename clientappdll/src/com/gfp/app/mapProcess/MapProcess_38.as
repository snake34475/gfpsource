package com.gfp.app.mapProcess
{
   import com.gfp.app.cartoon.AnimatPlay;
   import com.gfp.app.cartoon.event.AnimatEvent;
   import com.gfp.app.fight.FightManager;
   import com.gfp.app.fight.PveEntry;
   import com.gfp.app.info.dialog.DialogInfoSimple;
   import com.gfp.app.npcDialog.NpcDialogController;
   import com.gfp.core.CommandID;
   import com.gfp.core.config.ClientConfig;
   import com.gfp.core.events.ExchangeEvent;
   import com.gfp.core.events.FightEvent;
   import com.gfp.core.info.ActivityExchangeAwardInfo;
   import com.gfp.core.manager.ActivityExchangeCommander;
   import com.gfp.core.manager.ActivityExchangeTimesManager;
   import com.gfp.core.manager.AlertManager;
   import com.gfp.core.manager.MainManager;
   import com.gfp.core.manager.ModuleManager;
   import com.gfp.core.manager.SightManager;
   import com.gfp.core.map.BaseMapProcess;
   import com.gfp.core.map.MapManager;
   import com.gfp.core.model.sensemodels.SightModel;
   import com.gfp.core.net.SocketConnection;
   import com.gfp.core.sound.SoundManager;
   import com.gfp.core.ui.alert.TextAlert;
   import com.gfp.core.utils.LineType;
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.utils.clearTimeout;
   import flash.utils.setTimeout;
   import org.taomee.utils.Delegate;
   import org.taomee.utils.DisplayUtil;
   
   public class MapProcess_38 extends BaseMapProcess
   {
      
      private var _heroMeetMC:MovieClip;
      
      private var _jianMC:MovieClip;
      
      private var _fitmentMC:MovieClip;
      
      private var _isWinTeam:Boolean;
      
      private var isWinner:Boolean;
      
      private var swapArr:Array = [2370,2371,2372,2373,2374];
      
      private var npcArr:Array = [10441,10442,10443,10444,10445];
      
      private var tollgateArr:Array = [693,694,695,696,697];
      
      private var nameArr:Array = ["东邪","西毒","南帝","北丐","中神通"];
      
      private var talkArr0:Array = [["我从桃花岛来，世间没我不知道的事，小子，你觉得你能接下我几招？","不试怎么知道？"],["自从我离开白驼山后，唯一的追求只有至高的武学了，最好离我远点，否则你会不好受的。","领教阁下高招"],["小施主从何而来，要往何处而去? 曾经痛苦，才知道真正的痛苦；曾经执著，才能放下执著；曾经牵挂，了无牵挂。","请大师指点"],["小兄弟我跟你说啊，天下最好跟最坏的事都是美食，我这九指就是吃的这个亏哟！怎么？想找我练练？","望前辈赐教"],["我在活死人墓中待了七年，后创全真教，收徒七名；道有三乘，量力而行。小居士寻我何事？","请道长指点"]];
      
      private var talkArr1:Array = [["哼！三百招之内居然没取你性命，就算你赢了！","小子我凑巧罢了！","哈哈哈！小子我欣赏你！。你觉得我打败他们需要几柱香？你觉得我拿得到《九阴真经》吗？","呃。。。（东邪的实力深不可测啊！）"],["你用的是什么武功？你师承何处？","武圣爷爷教我的！","虽然老夫刚才只使出了三分实力，但你刚才那两下还是不错的，想不想看《九阴真经》，老夫一会拿到了就给你看两眼？","呃。。。（老毒物的实力不可小觑！）"],["小施主资质甚高，老衲甘拜下风。","大师谦虚了！","老衲观你天性善良，不如论剑结束后，老衲若侥幸取得真经，便交予小施主保管如何？","多谢大师青睐。"],["哎哟？小兄弟身手不错嘛！老乞丐我都不小心输给你啦！","前辈肯定让着我了！","老乞丐我看你年纪轻轻的就有一身横练的筋骨，简直百年一见的练武奇才啊！小兄弟觉得老乞丐华山论剑有几分把握？","呃。。。（降龙十八掌果然名不虚传！）"],["咦？小居士刚才手法奇特，果然英雄出少年！","道长过誉了！","我那七个不争气的徒儿若有你一半武功就好哩！小居士觉得我们五人之中谁能更胜一筹？赢得这华山论剑！","呃。。。（中神通内力好深厚！）"]];
      
      private var talkArr2:Array = [["小子，你还是太年轻了啊，练练再来吧！","我还会回来的！"],["知道老夫的厉害了吧？哈哈哈！","哼！"],["小施主，出家人慈悲为怀。","多谢大师手下留情。"],["怎么样？老乞丐我有两下子吧？","前辈厉害！"],["小居士，道有三乘，量力而行。","多谢道长教诲"]];
      
      private var talkArr3:Array = [["我从桃花岛来，世间没我不知道的事，小子，你觉得你能接下我几招？（3月22日来看华山论剑结果，谁能夺得《九阴真经》！）","领教前辈高招"],["自从我离开白驼山后，唯一的追求只有至高的武学了，最好离我远点，否则你会不好受的。（3月22日来看华山论剑结果，谁能夺得《九阴真经》！）","领教前辈高招"],["小施主从何而来，要往何处而去? 曾经痛苦，才知道真正的痛苦；曾经执著，才能放下执著；曾经牵挂，了无牵挂。（3月22日来看华山论剑结果，谁能夺得《九阴真经》！）","领教前辈高招"],["小兄弟我跟你说啊，天下最好跟最坏的事都是美食，我这九指就是吃的这个亏哟！怎么？想找我练练？（3月22日来看华山论剑结果，谁能夺得《九阴真经》！）","领教前辈高招"],["我在活死人墓中待了七年，后创全真教，收徒七名；道有三乘，量力而行。小居士寻我何事？（3月22日来看华山论剑结果，谁能夺得《九阴真经》！）","领教前辈高招"]];
      
      private var talkArr4:Array = [["小子，看我谈笑间取胜他们四人！（3月22日来看华山论剑结果，谁能夺得《九阴真经》！）","老邪，看你的了！"],["看老夫怎么收拾他们！（3月22日来看华山论剑结果，谁能夺得《九阴真经》！）","老毒物给力啊！"],["小施主，老衲尽力而为！（3月22日来看华山论剑结果，谁能夺得《九阴真经》！）","大师加油！"],["小兄弟，老乞丐赢了要请我喝酒吃肉啊！（3月22日来看华山论剑结果，谁能夺得《九阴真经》！）","老乞丐，我看好你！"],["小居士，看我如何赢了这华山论剑！（3月22日来看华山论剑结果，谁能夺得《九阴真经》！）","看道长表演！"]];
      
      private var talkArr5:Array = [["小侠士一定是错过了华山论剑的第一阶段，下次举行记得准时参加！","下次一定来！"],["小侠士一定是错过了华山论剑的第一阶段，下次举行记得准时参加！","下次一定来！"],["小侠士一定是错过了华山论剑的第一阶段，下次举行记得准时参加！","下次一定来！"],["小侠士一定是错过了华山论剑的第一阶段，下次举行记得准时参加！","下次一定来！"],["小侠士一定是错过了华山论剑的第一阶段，下次举行记得准时参加！","下次一定来！"]];
      
      private var talkArr6:Array = [["小子果然守信，我这边比武分不开身，你去帮我做点事情？","老邪有何吩咐？"],["老夫忙于清理他们这群战斗力只有5的渣滓，你去帮老夫做点事如何？","老毒物有何吩咐？"],["小施主，老衲与诸位施主比武分身乏术，你能否帮我去完成两三件小事？","大师有何吩咐？"],["老乞丐我打的真是意犹未尽，小兄弟能不能帮我做几件事？","老乞丐有何吩咐？"],["小居士，贫道还需再次多待几日，你能否帮我去完成几件事？","道长有何吩咐？"]];
      
      private var talkArr7:Array = [["小子你鬼鬼祟祟的来我这干什么？","看什么看！走错路罢了！"],["老夫正在忙，你来想干什么？","看什么看！走错路罢了！"],["小施主，苦海无边回头是岸呐。","看什么看！走错路罢了！"],["小兄弟，跟我喝酒吃肉去！天下美食才是我的最爱！","看什么看！走错路罢了！"],["小居士！道有三乘，量力而行，找我有何事？","看什么看！走错路罢了！"]];
      
      private var talkArr8:Array = [["小子我们下次华山论剑再见！","好的！"],["老夫要走了，我们下次华山论剑走着瞧！","好的！"],["小施主，老衲要继续修行去了，你多保重，咱们下次华山论剑再相会！","好的！"],["小兄弟，下次华山论剑我再带你吃香的喝辣的！","好的！"],["小居士，我徒儿要有你一半就好了，哎！有缘下次华山论剑再见！","好的！"]];
      
      private var talkArr9:Array = [["老子对那几株桃花就是喜爱啊，这次就先放过他们了，下次华山论剑一定赢，这里有几样小礼，你选一样拿走吧，可别贪心。","好的！"],["老夫是利益至上的，陆半仙那定有好东西出来了，我得先去那，这次华山论剑就不打了，下次来拿九阴真经。我这有几样东西，你选一样拿走吧！","多谢老毒物！"],["",""],["老乞丐我还是败给了天下美食啊，啧啧，刚才的叫花鸡真香！这次虽然没拿下真经，但也不能亏了小兄弟你，拿走一分奖励吧！","多谢老乞丐！"],["小居士，这就是祸福无门, 唯人自召啊！不过你还是可以再我这取走一样奖励的！","多谢道长！"]];
      
      private var npcVec:Vector.<SightModel>;
      
      private var taskIDArr:Array = [1,1,1,1];
      
      private var count:int;
      
      private var _currNpcInd:int;
      
      public function MapProcess_38()
      {
         super();
      }
      
      override protected function init() : void
      {
         this.initFitmentMC();
         this.initHeroMC();
      }
      
      private function initFitmentMC() : void
      {
         this._jianMC = MapManager.currentMap.downLevel["jianMC"];
         this._fitmentMC = MapManager.currentMap.downLevel["fitmentMC"];
         if(ActivityExchangeTimesManager.getTimes(1439) <= 0)
         {
            if(this._fitmentMC)
            {
               this._fitmentMC.buttonMode = true;
               this._fitmentMC.addEventListener(MouseEvent.CLICK,this.onFitmentClick);
            }
         }
         else
         {
            DisplayUtil.removeForParent(this._jianMC);
         }
      }
      
      private function onFitmentEnter(param1:Event) : void
      {
         if(this._fitmentMC.currentFrame == this._fitmentMC.totalFrames)
         {
            ActivityExchangeCommander.addEventListener(ExchangeEvent.EXCHANGE_COMPLETE,this.exchangeHandler);
            ActivityExchangeCommander.exchange(1439);
         }
      }
      
      private function onFitmentClick(param1:MouseEvent) : void
      {
         AlertManager.showSimpleAlert("小侠士，我们正需要你的帮忙，扩建比武会场可是个体力活，确定要帮忙吗？",this.confirmApply);
      }
      
      private function confirmApply() : void
      {
         this._fitmentMC.gotoAndPlay(2);
         this._fitmentMC.addEventListener(Event.ENTER_FRAME,this.onFitmentEnter);
      }
      
      private function onExchageComplete(param1:ExchangeEvent) : void
      {
         var _loc2_:ActivityExchangeAwardInfo = param1.info as ActivityExchangeAwardInfo;
         if(_loc2_.id == 1439)
         {
            AlertManager.showSimpleAlarm("小侠士，谢谢你的帮忙，你今天将获得防御力提升10%，并且今天打关卡获得的功夫豆将翻倍哟");
            this._fitmentMC.buttonMode = false;
            this._fitmentMC.removeEventListener(MouseEvent.CLICK,this.onFitmentClick);
            this._fitmentMC.gotoAndStop(1);
            DisplayUtil.removeForParent(this._jianMC);
         }
      }
      
      private function initHeroMC() : void
      {
         this._heroMeetMC = MapManager.currentMap.libManager.getMovieClip("statueMC");
         if(ClientConfig.clientType <= 1)
         {
            _mapModel.contentLevel.addChild(this._heroMeetMC);
            this._heroMeetMC.x = 980;
            this._heroMeetMC.y = 380;
            switch(MainManager.loginInfo.lineType)
            {
               case LineType.LINE_TYPE_CT:
                  this._heroMeetMC.gotoAndStop(1);
                  break;
               case LineType.LINE_TYPE_CT2:
                  this._heroMeetMC.gotoAndStop(6);
                  break;
               case LineType.LINE_TYPE_CNC:
                  this._heroMeetMC.gotoAndStop(2);
            }
         }
      }
      
      override public function destroy() : void
      {
         super.destroy();
         ActivityExchangeCommander.removeEventListener(ExchangeEvent.EXCHANGE_COMPLETE,this.onExchageComplete);
         if(this._fitmentMC)
         {
            this._fitmentMC.removeEventListener(MouseEvent.CLICK,this.onFitmentClick);
         }
         if(this._heroMeetMC)
         {
            this._heroMeetMC = null;
         }
      }
      
      private function initHuaShan() : void
      {
         var _loc1_:int = 0;
         this._isWinTeam = this.checkIsWinTeam();
         this.npcVec = new Vector.<SightModel>();
         var _loc2_:int = int(this.npcArr.length);
         _loc1_ = 0;
         while(_loc1_ < _loc2_)
         {
            this.npcVec.push(SightManager.getSightModel(this.npcArr[_loc1_]));
            this.npcVec[_loc1_].addEventListener(MouseEvent.CLICK,this.onNPCClicked);
            _loc1_++;
         }
      }
      
      private function checkIsWinTeam() : Boolean
      {
         return ActivityExchangeTimesManager.getTimes(2372) >= 2;
      }
      
      private function destoryHuaShan() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = int(this.npcArr.length);
         _loc1_ = 0;
         while(_loc1_ < _loc2_)
         {
            this.npcVec[_loc1_].removeEventListener(MouseEvent.CLICK,this.onNPCClicked);
            _loc1_++;
         }
         this.npcVec = null;
      }
      
      private function onNPCClicked(param1:MouseEvent) : void
      {
         var join:HuaShanItem;
         var count:int = 0;
         var e:MouseEvent = param1;
         var index:int = this.npcVec.indexOf(e.currentTarget as SightModel);
         this._currNpcInd = index;
         join = this.getJoinCheck();
         if(join.count == 0)
         {
            NpcDialogController.showForSimple(new DialogInfoSimple([this.talkArr5[index][0]],this.talkArr5[index][1]),this.npcArr[index]);
         }
         else if(join.index == index)
         {
            count = this.getProgress();
            if(ActivityExchangeTimesManager.getTimes(2389) > 0)
            {
               count = 5;
            }
            else if(count == 5 && ActivityExchangeTimesManager.getTimes(2389) == 0)
            {
               count = 4;
            }
            if(count == 0)
            {
               NpcDialogController.showForSimple(new DialogInfoSimple([this.talkArr6[index][0]],this.talkArr6[index][1]),this.npcArr[index],function():void
               {
                  setProgress(1);
                  ModuleManager.turnAppModule("HuaShanResultPanel","正在加载",{
                     "type":0,
                     "go_getAwardHandler":openGetAwardPanel
                  });
               });
            }
            else if(count == 1)
            {
               ModuleManager.turnAppModule("HuaShanResultPanel","正在加载",{
                  "type":0,
                  "go_getAwardHandler":this.openGetAwardPanel
               });
            }
            else if(count == 2)
            {
               ModuleManager.turnAppModule("HuaShanCartoon","正在加载...",{
                  "className":"UI_HuaShanCartoon",
                  "desFunc":this.desFunc1
               });
            }
            else if(count == 3)
            {
               this.showDialog2(index);
            }
            else if(count == 4)
            {
               ModuleManager.turnAppModule("HuaShanResultPanel","正在加载",{
                  "type":1,
                  "finalHandler":this.finalFunc
               });
            }
            else if(count == 5)
            {
               NpcDialogController.showForSimple(new DialogInfoSimple([this.talkArr8[index][0]],this.talkArr8[index][1]),this.npcArr[index]);
            }
         }
         else
         {
            NpcDialogController.showForSimple(new DialogInfoSimple([this.talkArr7[index][0]],this.talkArr7[index][1]),this.npcArr[index]);
         }
      }
      
      private function showDialog2(param1:int) : void
      {
         var index:int = param1;
         if(this._isWinTeam)
         {
            NpcDialogController.showForSimple(new DialogInfoSimple(["果然还是我出家人四大皆空，无欲无求啊。这华山论剑居然是我赢了！"],"恭喜大师！"),this.npcArr[index],function():void
            {
               NpcDialogController.showForSimple(new DialogInfoSimple(["我们来看这《九阴真经》到底是何神物，小施主还可以再老衲这拿走一份礼物，切记莫有贪念！"],"多谢大师！"),npcArr[index],playAnimat2);
            });
         }
         else
         {
            NpcDialogController.showForSimple(new DialogInfoSimple([this.talkArr9[index][0]],this.talkArr9[index][1]),this.npcArr[index],function():void
            {
               setProgress(4);
               ModuleManager.turnAppModule("HuaShanResultPanel","正在加载",{
                  "type":1,
                  "finalHandler":finalFunc
               });
            });
         }
      }
      
      private function playAnimat2() : void
      {
         SoundManager.setMusicEnable(false);
         AnimatPlay.addAnimatListener(AnimatEvent.ANIMAT_END,this.onAnimateEnd);
         AnimatPlay.startAnimat("huashanlunjian_",1,false,0,0,false,false,false);
      }
      
      private function onAnimateEnd(param1:AnimatEvent) : void
      {
         SoundManager.setMusicEnable(true);
         this.setProgress(4);
         ModuleManager.turnAppModule("HuaShanResultPanel","正在加载",{
            "type":1,
            "finalHandler":this.finalFunc
         });
         AnimatPlay.removeAnimatListener(AnimatEvent.ANIMAT_END,this.onAnimateEnd);
      }
      
      private function finalFunc() : void
      {
         this.setProgress(5);
      }
      
      private function desFunc1() : void
      {
         this.setProgress(3);
         this.showDialog2(this._currNpcInd);
      }
      
      private function openGetAwardPanel() : void
      {
         this.setProgress(2);
         ModuleManager.turnAppModule("HuaShanCartoon","正在加载...",{
            "className":"UI_HuaShanCartoon",
            "desFunc":this.desFunc1
         });
      }
      
      private function setProgress(param1:int) : void
      {
         var _loc2_:int = int(ActivityExchangeTimesManager.getTimes(2388));
         if(param1 > 0)
         {
            if(_loc2_ == param1 - 1)
            {
               ActivityExchangeCommander.exchange(2388);
            }
         }
      }
      
      private function getProgress() : int
      {
         return int(ActivityExchangeTimesManager.getTimes(2388));
      }
      
      private function playCartoon(param1:int) : void
      {
         ModuleManager.turnAppModule("HuaShanCartoon");
      }
      
      private function checkLevel() : Boolean
      {
         return MainManager.actorInfo.lv >= 30;
      }
      
      private function toTollgate(param1:int) : void
      {
         FightManager.instance.addEventListener(FightEvent.QUITE,this.fightQuiteHandler);
         FightManager.instance.addEventListener(FightEvent.WINNER,this.onWinner);
         PveEntry.instance.enterTollgate(this.tollgateArr[param1]);
      }
      
      private function justToTollgate(param1:int) : void
      {
         PveEntry.instance.enterTollgate(this.tollgateArr[param1]);
      }
      
      private function fightQuiteHandler(param1:FightEvent) : void
      {
         var curID:int;
         var index:int = 0;
         var tt:int = 0;
         var e:FightEvent = param1;
         FightManager.instance.removeEventListener(FightEvent.QUITE,this.fightQuiteHandler);
         FightManager.instance.removeEventListener(FightEvent.WINNER,this.onWinner);
         curID = int(MapManager.mapInfo.id.toString().slice(2,5));
         index = this.tollgateArr.indexOf(curID);
         tt = int(setTimeout(function():void
         {
            clearTimeout(tt);
            if(index != -1)
            {
               if(isWinner)
               {
                  if(ActivityExchangeTimesManager.getTimes(swapArr[index]) == 0)
                  {
                     ActivityExchangeCommander.addEventListener(ExchangeEvent.EXCHANGE_COMPLETE,exchangeHandler);
                     ActivityExchangeCommander.exchange(swapArr[index]);
                  }
                  else
                  {
                     NpcDialogController.showForSimple(new DialogInfoSimple([talkArr1[index][0]],talkArr1[index][1]),npcArr[index],Delegate.create(onWinNPCTalk,index));
                  }
               }
               else
               {
                  NpcDialogController.showForSimple(new DialogInfoSimple([talkArr2[index][0]],talkArr2[index][1]),npcArr[index]);
               }
            }
         },1000));
      }
      
      private function exchangeHandler(param1:ExchangeEvent) : void
      {
         var _loc2_:ActivityExchangeAwardInfo = param1.info;
         var _loc3_:int = this.swapArr.indexOf(_loc2_.id);
         if(_loc3_ != -1)
         {
            if(ActivityExchangeTimesManager.getTimes(this.swapArr[_loc3_]) == 1)
            {
               SocketConnection.removeCmdListener(CommandID.ACTIVITY_EXCHANGE,this.exchangeHandler);
               NpcDialogController.showForSimple(new DialogInfoSimple([this.talkArr1[_loc3_][0]],this.talkArr1[_loc3_][1]),this.npcArr[_loc3_],Delegate.create(this.onWinNPCTalk,_loc3_));
            }
            else if(ActivityExchangeTimesManager.getTimes(this.swapArr[_loc3_]) == 2)
            {
               SocketConnection.removeCmdListener(CommandID.ACTIVITY_EXCHANGE,this.exchangeHandler);
               TextAlert.show("获得称号:小" + this.nameArr[_loc3_]);
               this.playCartoon(_loc3_);
            }
         }
      }
      
      private function onWinNPCTalk(param1:int) : void
      {
         NpcDialogController.showForSimple(new DialogInfoSimple([this.talkArr1[param1][2]],this.talkArr1[param1][3]),this.npcArr[param1],Delegate.create(this.onJoinNPCTalk,param1));
      }
      
      private function onJoinNPCTalk(param1:int) : void
      {
         AlertManager.showSimpleAlert("小侠士，你已拥有加入" + this.nameArr[param1] + "队伍的资格，加入后就不可更换队伍，确定加入吗？",Delegate.create(this.onSureJoin,param1));
      }
      
      private function onSureJoin(param1:int) : void
      {
         ActivityExchangeCommander.addEventListener(ExchangeEvent.EXCHANGE_COMPLETE,this.exchangeHandler);
         ActivityExchangeCommander.exchange(this.swapArr[param1]);
      }
      
      private function onWinner(param1:FightEvent) : void
      {
         this.isWinner = true;
      }
      
      public function getCheck(param1:int) : HuaShanItem
      {
         var _loc2_:HuaShanItem = new HuaShanItem();
         _loc2_.count = ActivityExchangeTimesManager.getTimes(this.swapArr[param1]);
         _loc2_.swapID = this.swapArr[param1];
         _loc2_.taskID = this.taskIDArr[param1];
         _loc2_.index = param1;
         return _loc2_;
      }
      
      public function getJoinCheck() : HuaShanItem
      {
         var _loc1_:int = 0;
         var _loc2_:int = int(this.swapArr.length);
         var _loc3_:HuaShanItem = new HuaShanItem();
         _loc1_ = 0;
         while(_loc1_ < this.swapArr.length)
         {
            if(ActivityExchangeTimesManager.getTimes(this.swapArr[_loc1_]) == 2)
            {
               _loc3_.count = ActivityExchangeTimesManager.getTimes(this.swapArr[_loc1_]);
               _loc3_.swapID = this.swapArr[_loc1_];
               _loc3_.taskID = this.taskIDArr[_loc1_];
               _loc3_.index = _loc1_;
               break;
            }
            _loc1_++;
         }
         return _loc3_;
      }
   }
}

class HuaShanItem
{
   
   public var count:int = 0;
   
   public var swapID:int = 0;
   
   public var index:int = 0;
   
   public var taskID:int = 0;
   
   public function HuaShanItem()
   {
      super();
   }
}
