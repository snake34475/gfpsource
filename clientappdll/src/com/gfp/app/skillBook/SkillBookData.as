package com.gfp.app.skillBook
{
   import com.gfp.core.config.xml.SkillXMLInfo;
   import com.gfp.core.manager.ActivityExchangeCommander;
   import com.gfp.core.manager.ActivityExchangeTimesManager;
   import com.gfp.core.manager.MainManager;
   
   public class SkillBookData
   {
      
      public static var isLearnMcPlayed:Boolean;
      
      public static var isBookOpened:Boolean;
      
      private static const checkSwapID:int = 2322;
      
      private static var skillOldArray:Array = [[100204,100207,100208,100209,100203,100211,100215,100214,100206,100205,100201,100210,100212,100213,100202],[200201,200204,200209,200211,200202,200210,200205,200206,200203,200208,200213,200212,200214,200207,200215],[300210,300204,300211,300205,300212,300214,300201,300203,300202,300213,300206,300207,300215,300208,300209],[400201,400301,400101,400401,400302,400102,400203,400202,400103,400402,400204,400303,400205,400206,400403]];
      
      public static var skillNewVerArray:Array = [[100204,100203,100206,100211,100201,100215],[200201,200211,200202,200214,200208,200207],[300204,300211,300212,300210,300201,300209],[400201,400401,400202,400203,400303,400204],[500201,500202,500203,500204,500205,500206],[600201,600202,600203,600204,600205,600206],[700101,700102,700103,700104,700105,700106]];
      
      public static var slotOldPosArray:Array = [[0,1,2,3,5,6,8,9,10,11,13,14,17,18,21],[0,1,2,3,5,6,9,10,11,13,14,17,18,21,22],[0,1,2,3,5,6,8,9,10,11,14,15,17,18,21],[0,1,2,3,5,6,8,9,10,11,13,15,17,21,22],[0,1,2,3,5,6,8,9,10,11,13,15,17,21,22],[0,1,2,3,5,6,8,9,10,11,13,15,17,21,22],[0,1,2,3,5,6,8,9,10,11,13,15,17,21,22]];
      
      public static var slotNewVerPosArray:Array = [[0,1,2,4,5,6],[0,1,2,4,5,6],[0,1,2,4,5,6],[0,1,2,4,5,6],[0,1,2,4,5,6],[0,1,2,4,5,6],[0,1,2,4,5,6]];
      
      public static var skillOldPositionID:Array = [200203,200205,200208,200207,400403,400402,400401,300201,300209,300215,300210];
      
      public static var skillOldNamePage:Array = [100201,100202,100203,100204,100205,100206,100207,100208,100209,100210,100211,100212,100213,100214,100215,200201,200202,200203,200204,200205,200206,200207,200208,200209,200210,200211,200212,200213,200214,200215,300201,300202,300203,300204,300205,300206,300207,300208,300209,300210,300211,300212,300213,300214,300215,400101,400102,400103,400201,400202,400203,400204,400205,400206,400301,400302,400303,400401,400402,400403,500101,500102,500103,500201,500202,500203,500204,500205,500206,500301,500302,500303,500401,500402,500403,600101,600102,600103,600201,600202,600203,600204,600205,600206,600301,600302,600303,600401,600402,600403,700101,700102,700103,700201,700202,700203,700204,700205,700206,700301,700302,700303,700401,700402,700403];
      
      private static var _activeSkills:Array = [[100601,100602,100603,100604,100605,100606],[200601,200602,200603,200604,200605,200606],[300601,300602,300603,300604,300605,300606],[400601,400602,400603,400604,400605,400606],[500601,500602,500603,500604,500605,500606],[600601,600602,600603,600604,600605,600606],[700601,700602,700603,700604,700605,700606]];
      
      private static var _superSkills:Array = [[100701,100702,100703,100704,100705,100706],[200701,200702,200703,200704,200705,200706],[300701,300702,300703,300704,300705,300706],[400701,400702,400703,400704,400705,400706],[500701,500702,500703,500704,500705,500706],[600701,600702,600703,600704,600705,600706],[700701,700702,700703,700704,700705,700706],[800701,800702,800703,800704,800705,800706,800707,800708,800709]];
      
      private static var _passiveSkills:Array = [[100611,100612,100613],[200611,200612,200613],[300611,300612,300613],[400611,400612,400613],[500611,500612,500613],[600611,600612,600613],[700607,700608,700609],[800710,800711,800712]];
      
      private static var _understandSkills:Array = [[100607,100608],[200607,200608],[300607,300608],[400607,400608],[500607],[600607],[],[]];
      
      private static var _turnBackUnderstandSkills:Array = [[100810],[200810],[300810],[400810],[500810],[600810],[700810],[]];
      
      private static var slotNewPosArray:Array = [[0,1,2,3,5,6,8,9,10,11,13,14,17,18,21],[0,1,2,3,5,6,9,10,11,13,14,17,18,21,22],[0,1,2,3,5,6,8,9,10,11,14,15,17,18,21],[0,1,2,3,5,6,8,9,10,11,13,15,17,21,22],[0,1,2,3,5,6,8,9,10,11,13,15,17,21,22],[0,1,2,3,5,6,8,9,10,11,13,15,17,21,22],[0,1,2,3,5,6,8,9,10,11,13,15,17,21,22]];
      
      private static var skillNewPositionID:Array = [200203,200205,200208,200207,400403,400402,400401,300201,300209,300215,300210];
      
      private static var skillNewNamePage:Array = [100601,100602,100603,100604,100605,100606,200601,200602,200603,200604,200605,200606,300601,300602,300603,300604,300605,300606,400601,400602,400603,400604,400605,400606,400607,200607,300607,100607,100608,200608,300608,400608];
      
      private static var _turnbackSkills:Array = [[100801,100802,100803,100804,100805,100806],[200801,200802,200803,200804,200805,200806],[300801,300802,300803,300804,300805,300806],[400801,400802,400803,400804,400805,400806],[500801,500802,500803,500804,500805,500806],[600801,600802,600803,600804,600805,600806],[700801,700802,700803,700804,700805,700806],[800801,800802,800803,800804,800805,800806,800807,800808,800809]];
      
      private static var _turnbackPassiveSkills:Array = [[100807,100808,100809],[200807,200808,200809],[300807,300808,300809],[400807,400808,400809],[500807,500808,500809],[600807,600808,600809],[700807,700808,700809],[800810,800811,800812]];
      
      private static var _awakenSkills:Array = [[100811,100812,100813,100814,100815],[200811,200812,200813,200814,200815],[300811,300812,300813,300814,300815],[400811,400812,400813,400814,400815],[500811,500812,500813,500814,500815],[600811,600812,600813,600814,600815],[700811,700812,700813,700814,700815],[800813,800814,800815,800816,800817]];
      
      private static var _secondTurnbackSkills:Array = [[[100901,100902,100903,100904,100905,100906],[101001,101002,101003,101004,101005,101006]],[[200901,200902,200903,200904,200905,200906],[201001,201002,201003,201004,201005,201006]],[[300901,300902,300903,300904,300905,300906],[301001,301002,301003,301004,301005,301006]],[[400901,400902,400903,400904,400905,400906],[401001,401002,401003,401004,401005,401006]],[[500901,500902,500903,500904,500905,500906],[501001,501002,501003,501004,501005,501006]],[[600901,600902,600903,600904,600905,600906],[601001,601002,601003,601004,601005,601006]],[[700901,700902,700903,700904,700905,700906],[701001,701002,701003,701004,701005,701006]],[[800901,800902,800903,800904,800905,800906,800907,800908,800909,800910],[801001,801002,801003,801004,801005,801006,801007,801008,801009,801010]]];
      
      private static var _secondTurnbackPassiveSkills:Array = [[[100910,100911,100912],[101010,101011,101012]],[[200910,200911,200912],[201010,201011,201012]],[[300910,300911,300912],[301010,301011,301012]],[[400910,400911,400912],[401010,401011,401012]],[[500910,500911,500912],[501010,501011,501012]],[[600910,600911,600912],[601010,601011,601012]],[[700910,700911,700912],[701010,701011,701012]],[[800914,800915,800916],[801014,801015,801016]]];
      
      private static var _secondTurnbackAwakenSkills:Array = [[[100907,100908,100909],[101007,101008,101009]],[[200907,200908,200909],[201007,201008,201009]],[[300907,300908,300909],[301007,301008,301009]],[[400907,400908,400909],[401007,401008,401009]],[[500907,500908,500909],[501007,501008,501009]],[[600907,600908,600909],[601007,601008,601009]],[[700907,700908,700909],[701007,701008,701009]],[[800911,800912,800913],[801011,801012,801013]]];
      
      public function SkillBookData()
      {
         super();
      }
      
      public static function get understandSkills() : Array
      {
         if(MainManager.actorInfo.secondTurnBackType)
         {
            return [];
         }
         if(MainManager.actorInfo.isTurnBack)
         {
            return _turnBackUnderstandSkills;
         }
         return _understandSkills;
      }
      
      public static function get awakenSkills() : Array
      {
         if(MainManager.actorInfo.secondTurnBackType)
         {
            return _secondTurnbackAwakenSkills;
         }
         return _awakenSkills;
      }
      
      public static function isAwakenSkill(param1:int) : Boolean
      {
         var _loc3_:Array = null;
         var _loc4_:int = 0;
         var _loc2_:int = 0;
         while(_loc2_ < _awakenSkills.length)
         {
            _loc3_ = _awakenSkills[_loc2_];
            _loc4_ = 0;
            while(_loc4_ < _loc3_.length)
            {
               if(_loc3_[_loc4_] == param1)
               {
                  return true;
               }
               _loc4_++;
            }
            _loc2_++;
         }
         return false;
      }
      
      public static function set understandSkills(param1:Array) : void
      {
         if(MainManager.actorInfo.isTurnBack)
         {
            _turnBackUnderstandSkills = param1;
            return;
         }
         _understandSkills = param1;
      }
      
      public static function get skillArray() : Array
      {
         if(MainManager.actorInfo.secondTurnBackType > 0)
         {
            return _secondTurnbackSkills;
         }
         if(MainManager.actorInfo.isTurnBack)
         {
            return _turnbackSkills;
         }
         if(isUseSuperSkillsUser())
         {
            return _superSkills;
         }
         if(MainManager.actorInfo.isSuperAdvc)
         {
            return _superSkills;
         }
         if(MainManager.actorInfo.isAdvanced)
         {
            return _activeSkills;
         }
         if(skillType())
         {
            return skillNewVerArray;
         }
         return skillOldArray;
      }
      
      public static function skillType() : int
      {
         if(MainManager.roleType > 4)
         {
            return 1;
         }
         if(MainManager.actorInfo.lv > 30)
         {
            if(ActivityExchangeTimesManager.getTimes(checkSwapID) == 0)
            {
               return 0;
            }
            return 1;
         }
         if(ActivityExchangeTimesManager.getTimes(checkSwapID) == 0)
         {
            ActivityExchangeCommander.exchange(checkSwapID);
         }
         return 1;
      }
      
      public static function get passiveSkills() : Array
      {
         if(MainManager.actorInfo.secondTurnBackType)
         {
            return _secondTurnbackPassiveSkills;
         }
         if(MainManager.actorInfo.isTurnBack)
         {
            return _turnbackPassiveSkills;
         }
         return _passiveSkills;
      }
      
      public static function get slotPosArray() : Array
      {
         if(MainManager.actorInfo.isAdvanced)
         {
            return slotNewPosArray;
         }
         if(skillType())
         {
            return slotNewVerPosArray;
         }
         return slotOldPosArray;
      }
      
      public static function get skillPositionID() : Array
      {
         if(MainManager.actorInfo.isAdvanced)
         {
            return skillNewPositionID;
         }
         return skillOldPositionID;
      }
      
      public static function get skillNamePage() : Array
      {
         if(MainManager.actorInfo.isAdvanced)
         {
            return skillNewNamePage;
         }
         return skillOldNamePage;
      }
      
      public static function isUseSuperSkillsUser() : Boolean
      {
         return MainManager.actorInfo.createTime >= 1408636800;
      }
      
      public static function getUserMaxSkillLevel(param1:int) : int
      {
         return SkillXMLInfo.getInfo(param1).maxLevel;
      }
   }
}

