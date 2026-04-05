package com.gfp.app.manager
{
   import com.gfp.app.fight.CustomEvent;
   import com.gfp.app.info.rank.SanGuoRankInfo;
   import com.gfp.core.CommandID;
   import com.gfp.core.info.SanGuoCityNodeInfo;
   import com.gfp.core.manager.CustomEventMananger;
   import com.gfp.core.net.SocketConnection;
   import com.gfp.core.utils.RankType;
   import com.gfp.core.xmlconfig.SanGuoXmlInfo;
   import flash.utils.ByteArray;
   import flash.utils.clearTimeout;
   import flash.utils.setTimeout;
   import org.taomee.net.SocketEvent;
   
   public class SanGuoCityFightManager
   {
      
      private static var _instance:SanGuoCityFightManager;
      
      private var _cityInfos:Array = [[],[],[]];
      
      private var _fightCitys:Array = [0,0,0];
      
      private var _isRequestingCityInfos:Boolean = false;
      
      private var _rankSource:Array = [];
      
      private var _selfScores:Array = [0,0];
      
      private const POINT_IDS:Array = [201409231,201409232,201409233];
      
      public var zhanPoints:Array = [0,0,0];
      
      public function SanGuoCityFightManager()
      {
         super();
      }
      
      public static function getInstance() : SanGuoCityFightManager
      {
         if(_instance == null)
         {
            _instance = new SanGuoCityFightManager();
         }
         return _instance;
      }
      
      public function getSideCitys(param1:int) : Array
      {
         var _loc4_:int = 0;
         var _loc5_:SanGuoCityNodeInfo = null;
         var _loc6_:int = 0;
         var _loc2_:Array = [];
         var _loc3_:Array = this._cityInfos[param1];
         for each(_loc4_ in _loc3_)
         {
            _loc5_ = SanGuoXmlInfo.getCity(_loc4_);
            for each(_loc6_ in _loc5_.connectCitys)
            {
               if(this.isEnemyCity(param1,_loc6_))
               {
                  _loc2_.push(_loc5_);
               }
            }
         }
         return _loc2_;
      }
      
      public function getCityNum(param1:int) : int
      {
         var _loc2_:Array = this._cityInfos[param1];
         return _loc2_.length;
      }
      
      public function isEnemyCity(param1:int, param2:int) : Boolean
      {
         var _loc3_:int = int(this._cityInfos.length);
         var _loc4_:int = 0;
         while(_loc4_ < _loc3_)
         {
            if(_loc4_ != param1)
            {
               if(this._cityInfos[_loc4_].indexOf(param2) != -1)
               {
                  return true;
               }
            }
            _loc4_++;
         }
         return false;
      }
      
      public function isCityCanAttack(param1:int, param2:int) : Boolean
      {
         var _loc5_:SanGuoCityNodeInfo = null;
         if(param2 < 1 && param2 > 31)
         {
            return false;
         }
         var _loc3_:SanGuoCityNodeInfo = SanGuoXmlInfo.getCity(param2);
         if(_loc3_.isShouDu)
         {
            return false;
         }
         var _loc4_:Array = this.getSideCitys(param1);
         for each(_loc5_ in _loc4_)
         {
            if(_loc5_.connectCitys.indexOf(param2) != -1 && this.isEnemyCity(param1,param2) && this._fightCitys.indexOf(param2) == -1)
            {
               return true;
            }
         }
         return false;
      }
      
      public function getSideEnemyCitys(param1:int) : Array
      {
         var _loc2_:Array = [];
         var _loc3_:int = 1;
         while(_loc3_ < 32)
         {
            if(this.isCityCanAttack(param1,_loc3_))
            {
               _loc2_.push(_loc3_);
            }
            _loc3_++;
         }
         return _loc2_;
      }
      
      public function getCountryId(param1:int, param2:Boolean = false) : int
      {
         var _loc4_:int = 0;
         var _loc5_:Array = null;
         var _loc3_:int = this.getCityTakeBy(param1);
         if(param2 && _loc3_ != -1)
         {
            return _loc3_;
         }
         _loc4_ = 0;
         while(_loc4_ < 3)
         {
            _loc5_ = this._cityInfos[_loc4_];
            if(_loc5_.indexOf(param1) != -1)
            {
               return _loc4_;
            }
            _loc4_++;
         }
         return 3;
      }
      
      public function getCityTakeBy(param1:int) : int
      {
         var _loc3_:SanGuoCityNodeInfo = null;
         var _loc2_:int = this._fightCitys.indexOf(param1);
         if(_loc2_ != -1)
         {
            _loc3_ = SanGuoXmlInfo.getCity(param1);
            if(_loc3_.leftDef == 0)
            {
               return _loc2_;
            }
         }
         return -1;
      }
      
      public function requestCityInfos() : void
      {
         if(!this._isRequestingCityInfos)
         {
            this._isRequestingCityInfos = true;
            SocketConnection.addCmdListener(CommandID.SAN_GUO_CITY_INFOS,this.onCityInfoBack);
            SocketConnection.send(CommandID.SAN_GUO_CITY_INFOS);
         }
      }
      
      private function onCityInfoBack(param1:SocketEvent) : void
      {
         var data:ByteArray;
         var i:int;
         var timer:uint = 0;
         var info:SanGuoCityNodeInfo = null;
         var e:SocketEvent = param1;
         this._cityInfos = [[],[],[]];
         SocketConnection.removeCmdListener(CommandID.SAN_GUO_CITY_INFOS,this.onCityInfoBack);
         timer = setTimeout(function():void
         {
            clearTimeout(timer);
            _isRequestingCityInfos = false;
         },1 * 1000);
         data = e.data as ByteArray;
         i = 0;
         while(i < 32)
         {
            info = SanGuoXmlInfo.getCity(i);
            if(info)
            {
               info.countryId = data.readUnsignedInt() - 1;
               info.def = data.readUnsignedInt() * 10000;
               info.leftDef = data.readUnsignedInt();
               info.fightCountry = data.readUnsignedInt();
               info.isShouDu = data.readByte() == 1;
               if(info.countryId >= 0 && info.countryId <= 2)
               {
                  this._cityInfos[info.countryId].push(info.id);
               }
            }
            else
            {
               data.readUnsignedInt();
               data.readUnsignedInt();
               data.readUnsignedInt();
               data.readUnsignedInt();
               data.readByte();
            }
            i++;
         }
         i = 0;
         while(i < 4)
         {
            if(i == 0)
            {
               data.readUnsignedInt();
            }
            else
            {
               this._fightCitys[i - 1] = data.readUnsignedInt();
            }
            i++;
         }
         CustomEventMananger.dispatchEvent(new CustomEvent(CustomEvent.SAN_GUO_CITY_LOAD_COMPLETE));
      }
      
      public function getFightCitys() : Array
      {
         return this._fightCitys;
      }
      
      public function requestRankData() : void
      {
         SocketConnection.addCmdListener(CommandID.SINGLE_ACTIVITY_RANK,this.onActivityRank);
         SocketConnection.send(CommandID.SINGLE_ACTIVITY_RANK,RankType.SAN_GUO_GONG_CHENG,0,99);
      }
      
      private function onActivityRank(param1:SocketEvent) : void
      {
         var _loc4_:int = 0;
         var _loc5_:Array = null;
         var _loc2_:ByteArray = param1.data as ByteArray;
         _loc2_.position = 0;
         var _loc3_:int = _loc2_.readInt();
         if(_loc3_ == RankType.SAN_GUO_GONG_CHENG)
         {
            SocketConnection.send(CommandID.SINGLE_ACTIVITY_RANK,RankType.SAN_GUO_SHOU_CHENG,0,99);
            _loc4_ = 0;
         }
         else
         {
            if(_loc3_ != RankType.SAN_GUO_SHOU_CHENG)
            {
               return;
            }
            SocketConnection.removeCmdListener(CommandID.SINGLE_ACTIVITY_RANK,this.onActivityRank);
            _loc4_ = 1;
         }
         _loc5_ = this.loadRankData(_loc2_);
         this._rankSource[_loc4_] = _loc5_;
         if(_loc3_ == RankType.SAN_GUO_SHOU_CHENG)
         {
            CustomEventMananger.dispatchEvent(new CustomEvent(CustomEvent.SAN_GUO_CITY_RANK_LOAD_COMPLETE));
         }
      }
      
      public function getCityRankSource() : Array
      {
         return this._rankSource;
      }
      
      private function loadRankData(param1:ByteArray) : Array
      {
         var _loc8_:SanGuoRankInfo = null;
         var _loc2_:Array = [];
         param1.position = 0;
         var _loc3_:int = int(param1.readUnsignedInt());
         var _loc4_:int = param1.readInt();
         _loc4_ = _loc4_ < 0 ? 0 : _loc4_;
         var _loc5_:int = param1.readInt();
         _loc2_["rankIndex"] = _loc5_;
         param1.readShort();
         param1.readShort();
         param1.readShort();
         param1.readShort();
         if(_loc3_ == RankType.SAN_GUO_GONG_CHENG)
         {
            this._selfScores[0] = _loc4_;
         }
         else
         {
            this._selfScores[1] = _loc4_;
         }
         var _loc6_:uint = param1.readUnsignedInt();
         var _loc7_:int = 0;
         while(_loc7_ < _loc6_)
         {
            _loc8_ = new SanGuoRankInfo(param1);
            _loc8_.rankIndex = _loc7_ + 1;
            _loc8_.countryId = param1.readShort() - 1;
            param1.readShort();
            param1.readShort();
            param1.readShort();
            _loc2_.push(_loc8_);
            _loc7_++;
         }
         return _loc2_;
      }
      
      public function getSelfScores() : Array
      {
         return this._selfScores;
      }
      
      public function isCityBeTaken(param1:int) : Boolean
      {
         var _loc3_:SanGuoCityNodeInfo = null;
         var _loc2_:int = this.getHittedCity(param1);
         if(_loc2_ != 0)
         {
            _loc3_ = SanGuoXmlInfo.getCity(_loc2_);
            if(_loc3_.leftDef == 0)
            {
               return true;
            }
         }
         return false;
      }
      
      public function getHittedCity(param1:int) : int
      {
         var _loc2_:int = 0;
         for each(_loc2_ in this._fightCitys)
         {
            if(_loc2_ != 0 && this.getCountryId(_loc2_) == param1)
            {
               return _loc2_;
            }
         }
         return 0;
      }
   }
}

