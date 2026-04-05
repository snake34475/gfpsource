package com.gfp.app.test
{
   import com.gfp.core.CommandID;
   import com.gfp.core.action.ActionInfo;
   import com.gfp.core.action.normal.SkillAction;
   import com.gfp.core.config.ClientConfig;
   import com.gfp.core.config.xml.ActionXMLInfo;
   import com.gfp.core.config.xml.SkillXMLInfo;
   import com.gfp.core.events.UILoadEvent;
   import com.gfp.core.info.UserInfo;
   import com.gfp.core.info.fight.SkillLevelInfo;
   import com.gfp.core.manager.ActivityExchangeCommander;
   import com.gfp.core.manager.ActivityExchangeTimesManager;
   import com.gfp.core.manager.LayerManager;
   import com.gfp.core.manager.MainManager;
   import com.gfp.core.manager.ModuleManager;
   import com.gfp.core.manager.TasksManager;
   import com.gfp.core.map.MapManager;
   import com.gfp.core.model.OgreModel;
   import com.gfp.core.model.UserModel;
   import com.gfp.core.net.SocketConnection;
   import com.gfp.core.ui.UILoader;
   import com.gfp.core.utils.UploadImageUtil;
   import flash.display.BitmapData;
   import flash.display.MovieClip;
   import flash.geom.Point;
   import flash.text.TextField;
   import flash.utils.setInterval;
   import org.taomee.bean.BaseBean;
   import org.taomee.component.control.MButton;
   import org.taomee.component.event.ButtonEvent;
   import org.taomee.utils.AlignType;
   import org.taomee.utils.DisplayUtil;
   
   public class TestTool extends BaseBean
   {
      
      private var _debugBtn:MButton;
      
      private var _testBtn:MButton;
      
      private var _fpsBtn:MButton;
      
      private var _stats:Stats;
      
      private var arr:Array = new Array();
      
      private var txt:TextField = new TextField();
      
      private var _testNum:Number = 0;
      
      private var skillId:int;
      
      private var _testModel:UserModel;
      
      private var _hp:uint;
      
      private var _cnt:int;
      
      public function TestTool()
      {
         super();
      }
      
      override public function start() : void
      {
         if(ClientConfig.isRelease())
         {
            finish();
            return;
         }
         this._debugBtn = new MButton("Debug");
         DisplayUtil.align(this._debugBtn,null,AlignType.TOP_RIGHT,new Point(-360,5));
         LayerManager.stage.addChild(this._debugBtn);
         this._debugBtn.addEventListener(ButtonEvent.RELEASE,this.onRelease);
         this._testBtn = new MButton("test");
         LayerManager.stage.addChild(this._testBtn);
         DisplayUtil.align(this._testBtn,null,AlignType.TOP_RIGHT,new Point(-260,5));
         this._testBtn.addEventListener(ButtonEvent.RELEASE,this.onTest);
         this._fpsBtn = new MButton("show fps");
         LayerManager.stage.addChild(this._fpsBtn);
         DisplayUtil.align(this._fpsBtn,null,AlignType.TOP_RIGHT,new Point(-160,5));
         this._fpsBtn.addEventListener(ButtonEvent.RELEASE,this.onFPS);
         finish();
      }
      
      public function hide() : void
      {
         this._debugBtn.visible = false;
      }
      
      public function show() : void
      {
         this._debugBtn.visible = true;
      }
      
      private function onRelease(param1:ButtonEvent) : void
      {
         ModuleManager.turnModule(ClientConfig.getAppModule("TestPanel"),"正在爆Tommy菊花……");
      }
      
      private function testSkill(param1:UserModel, param2:uint) : void
      {
         var _loc3_:SkillLevelInfo = SkillXMLInfo.getLevelInfo(param2,1);
         var _loc4_:ActionInfo = ActionXMLInfo.getInfo(_loc3_.actionID);
         param1.execAction(new SkillAction(_loc4_,_loc3_));
      }
      
      private function saveWife3() : void
      {
      }
      
      private function onFPS(param1:ButtonEvent) : void
      {
         if(this._stats == null)
         {
            this._stats = new Stats();
            LayerManager.stage.addChild(this._stats);
            this._fpsBtn.text = "hide fps";
         }
         else
         {
            LayerManager.stage.removeChild(this._stats);
            this._stats = null;
            this._fpsBtn.text = "show fps";
         }
      }
      
      private function onTest(param1:ButtonEvent) : void
      {
         var array:Array = null;
         var event:ButtonEvent = param1;
         var arr:Array = [13824,13825,13828,13827,13826];
         var i:int = 0;
         while(i < arr.length)
         {
            ActivityExchangeCommander.exchange(arr[i]);
            i++;
         }
         UploadImageUtil.loadLocalFile(this.selectImage);
         if(this._cnt == 0)
         {
         }
         if(this._cnt == 1)
         {
            ++this._cnt;
         }
         if(this._cnt == 2)
         {
            this._cnt = 0;
         }
         ActivityExchangeCommander.exchange(6171,100);
         array = [2057,2058,2059,2060,2061,2069,2070,2071,2099,2100,2101,2105].concat([2035,2036,2037,2038,2039,2040,2041,2042,2043,2044,2093,2094,2102,2103]).concat([2045,2046,2047,2048,2049,2050,2051,2052,2053,2054,2055,2056,2095,2096,2097,2098,2104]).concat([2057,2058,2059,2060,2061,2069,2070,2071,2099,2100,2101,2105]);
         array.push(2008);
         array.push(2009);
         array.push(2010);
         setInterval(function():void
         {
            if(array.length > 0)
            {
               TasksManager.taskComplete(array.shift());
            }
         },200);
         SocketConnection.send(CommandID.EXPLODE_MONSTER,2,0,0,400);
         i = 0;
         while(i < 4)
         {
            ActivityExchangeTimesManager.getActiviteTimeInfo(4721 + i);
            i++;
         }
      }
      
      private function selectImage(param1:BitmapData) : void
      {
         var bitmapData:BitmapData = param1;
         var id:int = int(MainManager.actorInfo.fightTeamId);
         UploadImageUtil.postGonghuiData(bitmapData,UploadImageUtil.getRealIdLocation(id),function(param1:BitmapData):void
         {
         });
      }
      
      private function loadSkillEffect(param1:uint) : void
      {
         var _loc3_:UILoader = null;
         var _loc2_:int = int(SkillXMLInfo.getInfo(param1).useEffect);
         if(_loc2_)
         {
            _loc3_ = new UILoader(ClientConfig.getSkillEffect(param1.toString()));
            _loc3_.addEventListener(UILoadEvent.COMPLETE,this.skillEfffectHandler);
            _loc3_.load();
         }
      }
      
      private function skillEfffectHandler(param1:UILoadEvent) : void
      {
         var animat:MovieClip = null;
         var evt:UILoadEvent = param1;
         var loader:UILoader = evt.currentTarget as UILoader;
         animat = loader.content as MovieClip;
         loader.removeEventListener(UILoadEvent.COMPLETE,this.skillEfffectHandler);
         loader.close();
         loader = null;
         if(animat == null)
         {
            return;
         }
         LayerManager.topLevel.addChild(animat);
         animat.addFrameScript(animat.totalFrames - 1,function():void
         {
            animat.stop();
            DisplayUtil.removeForParent(animat);
         });
      }
      
      private function sendSkill() : void
      {
         var _loc1_:SkillLevelInfo = SkillXMLInfo.getLevelInfo(100501,1);
         var _loc2_:ActionInfo = ActionXMLInfo.getInfo(_loc1_.actionID);
         _loc2_.skillID = 100501;
         MainManager.actorInfo.userID;
      }
      
      private function creatMonsters(param1:uint, param2:Number) : void
      {
         var _loc4_:UserInfo = null;
         var _loc5_:OgreModel = null;
         var _loc3_:int = 0;
         while(_loc3_ < param2)
         {
            _loc4_ = new UserInfo();
            _loc4_.roleType = param1;
            _loc4_.userID = 24646545;
            _loc4_.pos = MainManager.actorModel.pos.add(new Point(Math.random() * 50,Math.random() * 50));
            _loc5_ = new OgreModel(_loc4_);
            _loc5_.setNicStyle(16777215);
            OgreModel(_loc5_).setOgreNicStyle();
            MapManager.currentMap.addUser(_loc4_.userID,_loc5_);
            _loc3_++;
         }
      }
   }
}

