package com.gfp.app.npcDialog
{
   import com.gfp.app.config.xml.DialogXMLInfo;
   import com.gfp.app.info.dialog.DialogInfo;
   import com.gfp.app.info.dialog.DialogInfoMultiple;
   import com.gfp.app.info.dialog.DialogInfoSimple;
   import com.gfp.app.info.dialog.DialogOptionsInfo;
   import com.gfp.app.info.dialog.DialogTaskInfo;
   import com.gfp.app.info.dialog.NpcDialogInfo;
   import com.gfp.app.manager.EscortManager;
   import com.gfp.app.npcDialog.npc.MLabelButtonWithFlag;
   import com.gfp.app.npcDialog.npc.NpcDialogCustomProcess;
   import com.gfp.app.npcDialog.npc.NpcDialogItemFilter;
   import com.gfp.app.npcDialog.npc.QuestionInfo;
   import com.gfp.core.cache.SwfCache;
   import com.gfp.core.cache.SwfInfo;
   import com.gfp.core.config.ClientConfig;
   import com.gfp.core.config.xml.EscortXMLInfo;
   import com.gfp.core.config.xml.RoleXMLInfo;
   import com.gfp.core.controller.FocusKeyController;
   import com.gfp.core.controller.KeyController;
   import com.gfp.core.controller.StageResizeController;
   import com.gfp.core.events.CommEvent;
   import com.gfp.core.language.AppLanguageDefine;
   import com.gfp.core.manager.ActivityExchangeTimesManager;
   import com.gfp.core.manager.FocusManager;
   import com.gfp.core.manager.FunctionManager;
   import com.gfp.core.manager.LayerManager;
   import com.gfp.core.manager.MainManager;
   import com.gfp.core.manager.TasksManager;
   import com.gfp.core.manager.UIManager;
   import com.gfp.core.uic.UIPanel;
   import com.gfp.core.utils.Logger;
   import com.gfp.core.utils.PanelType;
   import com.gfp.core.utils.StringConstants;
   import com.gfp.core.utils.WallowUtil;
   import flash.display.DisplayObjectContainer;
   import flash.display.MovieClip;
   import flash.display.SimpleButton;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.text.TextField;
   import flash.ui.Keyboard;
   import org.taomee.component.containers.HBox;
   import org.taomee.component.containers.VBox;
   import org.taomee.component.control.MLabelButton;
   import org.taomee.component.layout.FlowLayout;
   import org.taomee.text.TextMix;
   import org.taomee.utils.DisplayUtil;
   
   public class NpcDialogPanel extends UIPanel
   {
      
      private static const MODE_TASK:uint = 0;
      
      private static const MODE_NORMAL:uint = 1;
      
      private static const MODE_SIMPLE:uint = 2;
      
      private static const MODE_MULTIPLE:uint = 3;
      
      private static const MODE_ESCORT:uint = 4;
      
      private static const TXT_PAGE_COUNT:uint = 6;
      
      private static const MODE_OPTIONS:uint = 7;
      
      private static const MODE_SINGLES:uint = 8;
      
      private var _npcDialogCustonPrecess:NpcDialogCustomProcess;
      
      private var _questionMode:uint;
      
      private var _npcMc:Sprite;
      
      private var _dialogA:Array;
      
      private var _questionA:Array;
      
      private var _taskInfo:DialogTaskInfo;
      
      private var _stepIndex:int;
      
      private var _nextBtn:MovieClip;
      
      private var _curNpcPath:String;
      
      private var txtBox:TextMix;
      
      private var btnBoxLeft:VBox;
      
      private var btnBoxRight:VBox;
      
      private var btnBoxH:HBox;
      
      private var _curIndex:uint = 0;
      
      private var _btnA:Array = [];
      
      private var _btnM:Array = [];
      
      private var _btnOptions:Array = [];
      
      private var _npcInfo:NpcDialogInfo;
      
      private var _selectedBtn:MLabelButtonWithFlag;
      
      private var _simpleConfirm:Function;
      
      private var _simpleCancel:Function;
      
      private var _upBtn:SimpleButton;
      
      private var _downBtn:SimpleButton;
      
      private var _selectAreaMC:MovieClip;
      
      private var _curNewVersion:uint;
      
      private var _npcTxt:TextField;
      
      private var _roleName:String;
      
      private var _isChooseShow:Boolean;
      
      public var targetNpc:int;
      
      private var multipleFuncs:Array;
      
      private var multipleFunc:Function;
      
      private var _npcSayArr:Array;
      
      private var _dialogArr:Array;
      
      private var _row:int;
      
      public function NpcDialogPanel()
      {
         super(UIManager.getMovieClip("NPC_BG_MC"));
         _type = PanelType.HIDE;
         this._nextBtn = _mainUI["nextBtn"];
         this._upBtn = _mainUI["upBtn"];
         this._downBtn = _mainUI["downBtn"];
         this._selectAreaMC = _mainUI["selectAreaMC"];
         this._npcTxt = _mainUI["npcNameTxt"];
         this._upBtn.visible = false;
         this._downBtn.visible = false;
         this._selectAreaMC.visible = false;
         this.initBoxAndTxt();
         _mainUI.addChild(this.btnBoxH);
         var _loc1_:uint = uint(_mainUI.getChildIndex(_mainUI["closeBtn"]));
         _mainUI.addChildAt(this.txtBox,_loc1_);
         this._npcDialogCustonPrecess = new NpcDialogCustomProcess();
      }
      
      public function get mainUI() : Sprite
      {
         return _mainUI;
      }
      
      private function initBoxAndTxt() : void
      {
         this.txtBox = new TextMix(630);
         this.txtBox.x = 255;
         this.txtBox.y = 10;
         this.btnBoxLeft = new VBox();
         this.btnBoxLeft.setSizeWH(325,112);
         this.btnBoxRight = new VBox();
         this.btnBoxRight.setSizeWH(325,112);
         this.btnBoxH = new HBox();
         this.btnBoxH.setSizeWH(650,112);
         this.btnBoxH.x = 235;
         this.btnBoxH.y = 72;
         this.btnBoxH.append(this.btnBoxLeft);
         this.btnBoxH.append(this.btnBoxRight);
         this.btnBoxH.valign = FlowLayout.TOP;
      }
      
      private function clear() : void
      {
         var _loc1_:MLabelButtonWithFlag = null;
         var _loc2_:MLabelButtonWithFlag = null;
         var _loc3_:MLabelButtonWithFlag = null;
         if(this._curNpcPath != "")
         {
            SwfCache.cancel(this._curNpcPath,this.onComHandler);
         }
         if(this._npcMc)
         {
            DisplayUtil.removeForParent(this._npcMc);
            this._npcMc = null;
         }
         this.txtBox.text = "";
         this.btnBoxLeft.removeAll(false);
         this.btnBoxRight.removeAll(false);
         while(this._btnA.length > 0)
         {
            _loc1_ = this._btnA.pop();
            _loc1_.removeEventListener(MouseEvent.CLICK,this.onTxtBtnClick);
            _loc1_.destroy();
         }
         while(this._btnM.length > 0)
         {
            _loc2_ = this._btnM.pop();
            _loc2_.removeEventListener(MouseEvent.CLICK,this.onTxtBtnMultipleClick);
            _loc2_.destroy();
         }
         while(this._btnOptions.length > 0)
         {
            _loc3_ = this._btnOptions.pop();
            _loc3_.removeEventListener(MouseEvent.CLICK,this.onOptionBtnClickHandler);
            _loc3_.destroy();
         }
         this._simpleConfirm = null;
         this._simpleCancel = null;
         this._selectedBtn = null;
         this._downBtn.visible = false;
         this._upBtn.visible = false;
         this._selectAreaMC.visible = false;
      }
      
      public function initForNpc(param1:uint) : void
      {
         var _loc2_:DialogInfo = null;
         var _loc3_:int = 0;
         this.clear();
         MainManager.closeOperate(false,true,false);
         this._npcInfo = DialogXMLInfo.getInfos(param1);
         if(this._npcInfo)
         {
            this._taskInfo = NpcDialogItemFilter.getTaskQuestion(this._npcInfo);
            _loc3_ = EscortManager.instance.escortPathId;
            if(_loc3_ > 0)
            {
               this._questionMode = MODE_ESCORT;
               if(_loc3_ < 16)
               {
                  this.addTxtBtnSingle("我来送镖的。");
                  this.npcDialogsBegin(["你是来送镖的吗？"]);
               }
               else
               {
                  switch(_loc3_)
                  {
                     case 35:
                        this.addTxtBtnSingle("我把黄鼠狼佳佳的礼物送来了，他说你懂的。");
                        this.npcDialogsBegin(["又是那只黄鼠狼么？哎，何必呢？不过还是感觉有一点淡淡的忧伤。"]);
                        break;
                     case 36:
                        this.addTxtBtnSingle("对，我就是来送冰块的");
                        this.npcDialogsBegin(["立夏之后，天气转热，有些有钱的侠士们就受不了，我想趁机从冰河小镇采集冰块转手卖给那些高富帅侠士，可惜啊我的武功太弱，经常被黑暗军团袭扰，想请一些厉害的小侠士来帮我运送冰块，小侠士你是来帮我的吗？"]);
                        break;
                     default:
                        this._questionMode = MODE_NORMAL;
                        this._questionA = NpcDialogItemFilter.getQuestions(this._npcInfo);
                        this.addTxtBtn();
                        this.npcDialogsBegin(this._npcInfo.firstDialog.npcDialogs);
                  }
               }
            }
            else if(this._taskInfo)
            {
               this._questionMode = MODE_TASK;
               this._stepIndex = 0;
               _loc2_ = this._taskInfo.nodeArray[this._stepIndex];
               this.addTxtBtnSingle(_loc2_.selectDesc);
               this.npcDialogsBegin(_loc2_.npcDialogs);
            }
            else
            {
               this._questionMode = MODE_NORMAL;
               this._questionA = NpcDialogItemFilter.getQuestions(this._npcInfo);
               this.addTxtBtn();
               this.npcDialogsBegin(this._npcInfo.firstDialog.npcDialogs);
            }
            this.initNpcView(this._npcInfo.npcID);
            this._isChooseShow = false;
            return;
         }
         this._nextBtn.visible = false;
         Logger.error(this,"未配置的NPC对话");
      }
      
      public function initForSimple(param1:DialogInfoSimple, param2:uint = 0, param3:Function = null, param4:Function = null) : void
      {
         this.clear();
         MainManager.closeOperate(false,true,false);
         this._questionMode = MODE_SIMPLE;
         this._simpleConfirm = param3;
         this._simpleCancel = param4;
         this.addTxtBtnSingle(param1.selectDesc);
         this.npcDialogsBegin(param1.npcDialogs);
         this.initNpcView(param2);
         this._isChooseShow = false;
      }
      
      public function initForMultiple(param1:DialogInfoMultiple, param2:uint, param3:Array, param4:int = 3) : void
      {
         this.multipleFunc = null;
         this.clear();
         MainManager.closeOperate(false,true,false);
         this._questionMode = MODE_MULTIPLE;
         this.multipleFuncs = param3;
         this._row = param4;
         this.npcDialogsBegin(param1.npcDialogs);
         var _loc5_:Array = param1.playerDialogs;
         this.addMultipleBtn(_loc5_);
         this.initNpcView(param2);
         this._isChooseShow = false;
      }
      
      public function initForMultipleEx(param1:DialogInfoMultiple, param2:uint, param3:Function, param4:int = 3) : void
      {
         this.multipleFuncs = null;
         this.clear();
         MainManager.closeOperate(false,true,false);
         this._questionMode = MODE_MULTIPLE;
         this.multipleFunc = param3;
         this._row = param4;
         this.npcDialogsBegin(param1.npcDialogs);
         var _loc5_:Array = param1.playerDialogs;
         this.addMultipleBtn(_loc5_);
         this.initNpcView(param2);
         this._isChooseShow = false;
      }
      
      public function initForSingles(param1:Array, param2:Array, param3:uint, param4:Function = null, param5:Function = null, param6:int = 3) : void
      {
         this.clear();
         MainManager.closeOperate(false,true,false);
         this._npcInfo = DialogXMLInfo.getInfos(param3);
         this._questionMode = MODE_SINGLES;
         this._simpleConfirm = param4;
         this._simpleCancel = param5;
         this._npcSayArr = param1;
         this._dialogArr = param2;
         this._stepIndex = 0;
         this._row = param6;
         this.addTxtBtnSingle(this._dialogArr[this._stepIndex]);
         var _loc7_:Array = new Array();
         _loc7_.push(this._npcSayArr[this._stepIndex]);
         this.npcDialogsBegin(_loc7_);
         this.initNpcView(param3);
         this._isChooseShow = false;
      }
      
      public function initForArr(param1:int, param2:Array, param3:Array, param4:int = 3) : void
      {
         this.clear();
         MainManager.closeOperate(false,true,false);
         this._npcInfo = DialogXMLInfo.getInfos(param1);
         this._questionMode = MODE_NORMAL;
         this._questionA = param3;
         this._row = 3;
         this.addTxtBtn();
         this.npcDialogsBegin(param2);
         this.initNpcView(param1);
      }
      
      public function initForOptions(param1:uint, param2:int) : void
      {
         var _loc3_:DialogOptionsInfo = null;
         this.clear();
         MainManager.closeOperate(false,true,false);
         this._npcInfo = DialogXMLInfo.getInfos(param1);
         if(this._npcInfo)
         {
            this._questionMode = MODE_OPTIONS;
            _loc3_ = DialogOptionsInfo(this._npcInfo.optionsArray[param2]);
            this.addOptionsBtn(_loc3_.options,param2);
            this.npcDialogsBegin(_loc3_.npcDialogs);
            this.initNpcView(param1);
            this._isChooseShow = false;
            return;
         }
         this._nextBtn.visible = false;
         Logger.error(this,"未配置的NPC对话");
      }
      
      private function initNpcView(param1:uint) : void
      {
         this.targetNpc = param1;
         var _loc2_:uint = uint(RoleXMLInfo.getResID(param1));
         if(param1 == 10001)
         {
            if(TasksManager.isCompleted(2083))
            {
               if(Boolean(TasksManager.isCompleted(2148)) || Boolean(TasksManager.isAccepted(2148)) && Boolean(TasksManager.isTaskProComplete(2148,1)))
               {
                  _loc2_ = uint(RoleXMLInfo.getResID(10555));
               }
               else
               {
                  _loc2_ = uint(RoleXMLInfo.getResID(10215));
               }
            }
         }
         this._curNpcPath = ClientConfig.getRoleHead(_loc2_);
         SwfCache.getSwfInfo(this._curNpcPath,this.onComHandler);
         this.initRoleName(param1);
      }
      
      override public function show(param1:DisplayObjectContainer = null) : void
      {
         var _loc2_:int = 0;
         if(EscortManager.instance.escortPathId > 0 && this._npcInfo != null)
         {
            _loc2_ = int(EscortXMLInfo.getEndNpcById(EscortManager.instance.escortPathId));
            if(_loc2_ != this._npcInfo.npcID)
            {
               FunctionManager.dispatchDisabledEvt();
               this.hide();
               return;
            }
         }
         if(param1 == null)
         {
            param1 = LayerManager.topLevel;
         }
         super.show(param1);
         this.layout();
         this.addFocusKeyListener();
         StageResizeController.instance.register(this.layout);
      }
      
      private function layout() : void
      {
         _mainUI.x = LayerManager.stageWidth - _mainUI.width >> 1;
         _mainUI.y = LayerManager.stageHeight - 160;
      }
      
      override protected function onClose(param1:MouseEvent) : void
      {
         if((this._questionMode == MODE_SIMPLE || this._questionMode == MODE_SINGLES) && this._simpleCancel != null)
         {
            this._simpleCancel();
         }
         super.onClose(param1);
         this.targetNpc = 0;
      }
      
      override public function hide() : void
      {
         super.hide();
         this.clear();
         MainManager.openOperate();
         this._npcDialogCustonPrecess.removeEvent();
         StageResizeController.instance.unregister(this.layout);
      }
      
      override public function destroy() : void
      {
         super.destroy();
         this.clear();
         StageResizeController.instance.unregister(this.layout);
      }
      
      override protected function addEvent() : void
      {
         super.addEvent();
         this._nextBtn.addEventListener(MouseEvent.CLICK,this.onNextClickHandler);
         this._downBtn.addEventListener(MouseEvent.CLICK,this.onDownClick);
         this._upBtn.addEventListener(MouseEvent.CLICK,this.onUpClick);
         this.addFocusKeyListener();
      }
      
      override protected function removeEvent() : void
      {
         super.removeEvent();
         this._nextBtn.removeEventListener(MouseEvent.CLICK,this.onNextClickHandler);
         this._downBtn.removeEventListener(MouseEvent.CLICK,this.onDownClick);
         this._upBtn.removeEventListener(MouseEvent.CLICK,this.onUpClick);
         this.removeFocusKeyListener();
      }
      
      private function initRoleName(param1:uint) : void
      {
         var _loc2_:String = RoleXMLInfo.getName(param1);
         var _loc3_:Array = _loc2_.split(" ");
         if(_loc3_.length > 0)
         {
            this._roleName = _loc3_[0];
         }
         this._npcTxt.text = this._roleName;
      }
      
      private function addFocusKeyListener() : void
      {
         MainManager.actorModel.execStandAction();
         KeyController.instance.clear();
         FocusKeyController.instance.setTarget(_mainUI);
         FocusKeyController.addFocusKeyListener(Keyboard.J,this.onKeyConfirm);
         FocusKeyController.addFocusKeyListener(Keyboard.C,this.onKeyConfirm);
         FocusKeyController.addFocusKeyListener(88,this.onKeyCancel);
         FocusKeyController.addFocusKeyListener(38,this.onKeyUp);
         FocusKeyController.addFocusKeyListener(40,this.onKeyDown);
      }
      
      private function removeFocusKeyListener() : void
      {
         KeyController.instance.init();
         FocusKeyController.removeFocusKeyListener(Keyboard.J,this.onKeyConfirm);
         FocusKeyController.removeFocusKeyListener(Keyboard.C,this.onKeyConfirm);
         FocusKeyController.removeFocusKeyListener(88,this.onKeyCancel);
         FocusKeyController.removeFocusKeyListener(67,this.onKeyUp);
         FocusKeyController.removeFocusKeyListener(88,this.onKeyDown);
         FocusKeyController.instance.resetTarget();
      }
      
      private function onKeyConfirm(param1:Event) : void
      {
         if(this._isChooseShow == false)
         {
            if(this._selectedBtn != null)
            {
               this._isChooseShow = true;
               this._selectedBtn.flag = true;
            }
            return;
         }
         if(this._nextBtn.visible)
         {
            this.onNextClickHandler();
         }
         else if(this._selectedBtn != null)
         {
            this.onSelectedTxtBtn();
         }
      }
      
      private function onKeyCancel(param1:Event) : void
      {
         this.hide();
      }
      
      private function onKeyUp(param1:Event) : void
      {
         var _loc2_:* = 0;
         if(this._isChooseShow == false)
         {
            if(this._selectedBtn != null)
            {
               this._isChooseShow = true;
               this._selectedBtn.flag = true;
            }
            return;
         }
         if(this._btnA.length > 1)
         {
            _loc2_ = this._btnA.indexOf(this._selectedBtn);
            if(_loc2_ > 0)
            {
               _loc2_--;
               this.showTxtBtnIndex(_loc2_);
            }
         }
      }
      
      private function onKeyDown(param1:Event) : void
      {
         var _loc2_:int = 0;
         if(this._isChooseShow == false)
         {
            if(this._selectedBtn != null)
            {
               this._isChooseShow = true;
               this._selectedBtn.flag = true;
            }
            return;
         }
         if(this._btnA.length > 1)
         {
            _loc2_ = this._btnA.indexOf(this._selectedBtn);
            if(_loc2_ < this._btnA.length - 1)
            {
               _loc2_++;
               this.showTxtBtnIndex(_loc2_);
            }
         }
      }
      
      private function addTxtBtn() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         var _loc3_:MLabelButtonWithFlag = null;
         if(this._questionA != null)
         {
            _loc1_ = int(this._questionA.length);
            _loc2_ = 0;
            for(; _loc2_ < _loc1_; _loc2_++)
            {
               if((this._questionA[_loc2_] as QuestionInfo).visible != "" && (this._questionA[_loc2_] as QuestionInfo).visible != null)
               {
                  if(!this[this._questionA[_loc2_].visible]())
                  {
                     continue;
                  }
               }
               _loc3_ = new MLabelButtonWithFlag(QuestionInfo(this._questionA[_loc2_]).procType,QuestionInfo(this._questionA[_loc2_]).desc);
               _loc3_.overColor = 13311;
               _loc3_.outColor = 16777188;
               _loc3_.underLine = true;
               _loc3_.buttonMode = true;
               _loc3_.visible = false;
               _loc3_.name = "btn" + _loc2_;
               _loc3_.addEventListener(MouseEvent.CLICK,this.onTxtBtnClick);
               this._btnA.push(_loc3_);
            }
            if(this._btnA.length > 0)
            {
               this.showTxtBtnIndex(0);
               this._selectedBtn.flag = false;
            }
         }
      }
      
      public function isTongGuan() : Boolean
      {
         return NpcDialogController.isTongGuanSMTOrBHLY();
      }
      
      public function isExe4471() : Boolean
      {
         return ActivityExchangeTimesManager.getTimes(4471) == 0;
      }
      
      private function showTxtBtnIndex(param1:uint) : void
      {
         if(this._selectedBtn)
         {
            this._selectedBtn.flag = false;
         }
         this._selectedBtn = this._btnA[param1] as MLabelButtonWithFlag;
         this._selectedBtn.flag = true;
         if(this.btnBoxH.numChildren < 2)
         {
            this.btnBoxH.removeAll(false);
            this.btnBoxH.append(this.btnBoxLeft);
            this.btnBoxH.append(this.btnBoxRight);
            this.btnBoxH.y = 70;
         }
         this.btnBoxLeft.removeAll(false);
         this.btnBoxRight.removeAll(false);
         var _loc2_:int = int(param1 / TXT_PAGE_COUNT);
         var _loc3_:int = int((this._btnA.length - 1) / TXT_PAGE_COUNT);
         var _loc4_:uint = Math.min(TXT_PAGE_COUNT,this._btnA.length - _loc2_ * TXT_PAGE_COUNT);
         var _loc5_:int = 0;
         while(_loc5_ < _loc4_)
         {
            if(_loc5_ < 3)
            {
               this.btnBoxLeft.append(this._btnA[_loc5_ + _loc2_ * TXT_PAGE_COUNT]);
            }
            else
            {
               this.btnBoxRight.append(this._btnA[_loc5_ + _loc2_ * TXT_PAGE_COUNT]);
            }
            _loc5_++;
         }
         this._downBtn.visible = false;
         this._upBtn.visible = false;
         this._selectAreaMC.visible = false;
         _mainUI.addChild(this._upBtn);
         _mainUI.addChild(this._downBtn);
         if(_loc2_ > 0)
         {
            this._upBtn.visible = true;
         }
         if(_loc2_ < _loc3_)
         {
            this._downBtn.visible = true;
         }
         if(this._upBtn.visible || this._downBtn.visible)
         {
            this._selectAreaMC.visible = true;
         }
      }
      
      private function addTxtBtnSingle(param1:String) : void
      {
         this.btnBoxH.removeAll(false);
         this.btnBoxH.y = 120;
         this._btnA = [];
         var _loc2_:MLabelButtonWithFlag = new MLabelButtonWithFlag(QuestionInfo.PROC_DIALOG,param1);
         _loc2_.overColor = 13311;
         _loc2_.outColor = 16777188;
         _loc2_.underLine = true;
         _loc2_.buttonMode = true;
         _loc2_.visible = false;
         this.btnBoxH.append(_loc2_);
         this._selectedBtn = _loc2_;
         _loc2_.addEventListener(MouseEvent.CLICK,this.onTxtBtnSingleClick);
         this._btnA.push(_loc2_);
      }
      
      private function addMultipleBtn(param1:Array) : void
      {
         var _loc3_:MLabelButtonWithFlag = null;
         this.btnBoxH.removeAll(false);
         this.btnBoxLeft.removeAll(false);
         this.btnBoxRight.removeAll(false);
         this.btnBoxH.append(this.btnBoxLeft);
         this.btnBoxH.append(this.btnBoxRight);
         this.btnBoxH.y = 70;
         this._btnM = [];
         var _loc2_:uint = 0;
         while(_loc2_ < param1.length)
         {
            _loc3_ = new MLabelButtonWithFlag(QuestionInfo.PROC_DIALOG,param1[_loc2_]);
            _loc3_.overColor = 13311;
            _loc3_.outColor = 16777188;
            _loc3_.underLine = true;
            _loc3_.buttonMode = true;
            _loc3_.visible = true;
            if(_loc2_ < this._row)
            {
               this.btnBoxLeft.append(_loc3_);
            }
            else
            {
               this.btnBoxRight.append(_loc3_);
            }
            _loc3_.index = _loc2_;
            _loc3_.addEventListener(MouseEvent.CLICK,this.onTxtBtnMultipleClick);
            this._btnM.push(_loc3_);
            _loc2_++;
         }
      }
      
      private function onTxtBtnMultipleClick(param1:Event) : void
      {
         var _loc2_:MLabelButtonWithFlag = param1.currentTarget as MLabelButtonWithFlag;
         this.hide();
         if(Boolean(this.multipleFuncs) && Boolean(this.multipleFuncs[_loc2_.index]))
         {
            this.multipleFuncs[_loc2_.index]();
         }
         else if(this.multipleFunc != null)
         {
            this.multipleFunc(_loc2_.index);
         }
      }
      
      private function addOptionsBtn(param1:Array, param2:int) : void
      {
         var _loc4_:MLabelButtonWithFlag = null;
         this.btnBoxH.removeAll(false);
         this.btnBoxLeft.removeAll(false);
         this.btnBoxRight.removeAll(false);
         this.btnBoxH.append(this.btnBoxLeft);
         this.btnBoxH.append(this.btnBoxRight);
         this.btnBoxH.y = 70;
         this._btnOptions = [];
         var _loc3_:uint = 0;
         while(_loc3_ < param1.length)
         {
            _loc4_ = new MLabelButtonWithFlag(QuestionInfo.PROC_DIALOG,param1[_loc3_]);
            _loc4_.overColor = 13311;
            _loc4_.outColor = 16777188;
            _loc4_.underLine = true;
            _loc4_.buttonMode = true;
            _loc4_.visible = true;
            this.btnBoxLeft.append(_loc4_);
            _loc4_.index = _loc3_;
            _loc4_.name = param2 + StringConstants.SIGN + _loc3_;
            _loc4_.addEventListener(MouseEvent.CLICK,this.onOptionBtnClickHandler);
            this._btnOptions.push(_loc4_);
            _loc3_++;
         }
      }
      
      private function onOptionBtnClickHandler(param1:MouseEvent) : void
      {
         var _loc2_:MLabelButtonWithFlag = param1.currentTarget as MLabelButtonWithFlag;
         this.hide();
         var _loc3_:String = this._npcInfo.npcID + StringConstants.SIGN + _loc2_.name;
         NpcDialogController.ed.dispatchEvent(new CommEvent(NpcDialogController.NPC_DIALOG_OPTIONS_MODEL_SELECT,_loc3_));
      }
      
      private function btnVisible(param1:Boolean) : void
      {
         var _loc4_:MLabelButton = null;
         var _loc2_:int = int(this._btnA.length);
         var _loc3_:int = 0;
         while(_loc3_ < _loc2_)
         {
            _loc4_ = this._btnA[_loc3_] as MLabelButton;
            _loc4_.visible = param1;
            _loc3_++;
         }
      }
      
      private function onTxtBtnClick(param1:MouseEvent) : void
      {
         var _loc2_:String = (param1.currentTarget as MLabelButton).name;
         var _loc3_:uint = uint(_loc2_.slice(3,_loc2_.length));
         var _loc4_:QuestionInfo = this._questionA[_loc3_] as QuestionInfo;
         this.processQuestion(_loc4_);
      }
      
      private function onSelectedTxtBtn() : void
      {
         var _loc1_:String = null;
         var _loc2_:uint = 0;
         var _loc3_:QuestionInfo = null;
         if(this._questionMode == MODE_NORMAL)
         {
            _loc1_ = this._selectedBtn.name;
            _loc2_ = uint(_loc1_.slice(3,_loc1_.length));
            _loc3_ = this._questionA[_loc2_] as QuestionInfo;
            this.processQuestion(_loc3_);
         }
         else if(this._questionMode == MODE_TASK || this._questionMode == MODE_SIMPLE || this._questionMode == MODE_ESCORT || this._questionMode == MODE_SINGLES)
         {
            this.onTxtBtnSingleClick();
         }
      }
      
      private function processQuestion(param1:QuestionInfo) : void
      {
         if(param1.procType == QuestionInfo.PROC_DIALOG)
         {
            this.npcDialogsBegin(param1.dialogs);
         }
         else
         {
            this._npcDialogCustonPrecess.processQuestion(param1);
         }
      }
      
      private function onTxtBtnSingleClick(param1:MouseEvent = null) : void
      {
         var _loc2_:DialogInfo = null;
         var _loc3_:Function = null;
         var _loc4_:QuestionInfo = null;
         var _loc5_:Array = null;
         var _loc6_:Function = null;
         if(this._btnA.length == 1)
         {
            MLabelButtonWithFlag(this._btnA[0]).removeEventListener(MouseEvent.CLICK,this.onTxtBtnSingleClick);
         }
         if(this._questionMode == MODE_TASK)
         {
            if(this._stepIndex < this._taskInfo.nodeArray.length - 1)
            {
               ++this._stepIndex;
               _loc2_ = this._taskInfo.nodeArray[this._stepIndex];
               this.addTxtBtnSingle(_loc2_.selectDesc);
               this.npcDialogsBegin(_loc2_.npcDialogs);
            }
            else
            {
               this.hide();
               if(this._taskInfo.taskType == DialogTaskInfo.TYPE_ACCEPT)
               {
                  TasksManager.accept(this._taskInfo.taskID);
               }
               else if(this._taskInfo.taskType == DialogTaskInfo.TYPE_PROCESS)
               {
                  TasksManager.taskProComplete(this._taskInfo.taskID,this._taskInfo.proID);
               }
               else if(this._taskInfo.taskType == DialogTaskInfo.TYPE_OVER)
               {
                  if(WallowUtil.isWallow())
                  {
                     WallowUtil.showWallowMsg(AppLanguageDefine.WALLOW_MSG_ARR[5]);
                  }
                  else
                  {
                     TasksManager.taskComplete(this._taskInfo.taskID);
                  }
               }
            }
         }
         else if(this._questionMode == MODE_SIMPLE)
         {
            _loc3_ = this._simpleConfirm;
            this.hide();
            if(_loc3_ != null)
            {
               _loc3_();
            }
         }
         else if(this._questionMode == MODE_ESCORT)
         {
            this.hide();
            _loc4_ = new QuestionInfo();
            _loc4_.procType = QuestionInfo.PROC_ESCORT;
            this._npcDialogCustonPrecess.processQuestion(_loc4_);
         }
         else if(this._questionMode == MODE_SINGLES)
         {
            if(this._stepIndex < this._npcSayArr.length - 1)
            {
               ++this._stepIndex;
               this.addTxtBtnSingle(this._dialogArr[this._stepIndex]);
               _loc5_ = new Array();
               _loc5_.push(this._npcSayArr[this._stepIndex]);
               this.npcDialogsBegin(_loc5_);
            }
            else
            {
               _loc6_ = this._simpleConfirm;
               this.hide();
               if(_loc6_ != null)
               {
                  _loc6_();
               }
            }
         }
      }
      
      private function npcDialogsBegin(param1:Array) : void
      {
         if(this._isChooseShow == true)
         {
            this._isChooseShow = false;
         }
         this._curIndex = 0;
         this._dialogA = param1;
         if(this._dialogA.length <= 1)
         {
            this._nextBtn.visible = false;
            this._nextBtn.gotoAndStop(1);
         }
         else
         {
            this._nextBtn.visible = true;
            this._nextBtn.play();
         }
         this.shwoTxt(this._curIndex);
         FocusManager.setFocus(this);
      }
      
      private function onComHandler(param1:SwfInfo) : void
      {
         if(this._npcMc)
         {
            DisplayUtil.removeForParent(this._npcMc);
            this._npcMc = null;
         }
         this._npcMc = param1.content as Sprite;
         this._npcMc.x = 125;
         this._npcMc.y = 115;
         _mainUI.addChild(this._npcMc);
      }
      
      private function onNextClickHandler(param1:MouseEvent = null) : void
      {
         ++this._curIndex;
         if(this._curIndex >= this._dialogA.length)
         {
            this._nextBtn.visible = false;
            this._nextBtn.stop();
         }
         else
         {
            this.shwoTxt(this._curIndex);
            if(this._curIndex == this._dialogA.length - 1)
            {
               this._nextBtn.visible = false;
               this._nextBtn.stop();
            }
         }
      }
      
      private function onDownClick(param1:MouseEvent) : void
      {
         var _loc2_:int = this._btnA.indexOf(this._selectedBtn);
         var _loc3_:int = int(_loc2_ / TXT_PAGE_COUNT);
         this.showTxtBtnIndex((_loc3_ + 1) * TXT_PAGE_COUNT);
      }
      
      private function onUpClick(param1:MouseEvent) : void
      {
         var _loc2_:int = this._btnA.indexOf(this._selectedBtn);
         var _loc3_:int = int(_loc2_ / TXT_PAGE_COUNT);
         this.showTxtBtnIndex((_loc3_ - 1) * TXT_PAGE_COUNT);
      }
      
      private function shwoTxt(param1:uint) : void
      {
         if(param1 >= 0 && param1 < this._dialogA.length - 1)
         {
            this.btnVisible(false);
         }
         else
         {
            if(param1 != this._dialogA.length - 1)
            {
               return;
            }
            this.btnVisible(true);
         }
         var _loc2_:String = this._dialogA[param1];
         var _loc3_:RegExp = /xxx|XXX/g;
         var _loc4_:String = "<![CDATA[" + MainManager.actorInfo.nick + "]]>";
         _loc2_ = _loc2_.replace(_loc3_,_loc4_);
         this.txtBox.text = "<font size=\'14\' color=\'#ffffff\' face=\'宋体\'>" + _loc2_ + "</font>";
      }
   }
}

