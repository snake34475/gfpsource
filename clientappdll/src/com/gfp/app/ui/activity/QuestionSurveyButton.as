package com.gfp.app.ui.activity
{
   import com.gfp.app.info.ActivityNodeInfo;
   import com.gfp.core.utils.WebURLUtil;
   
   public class QuestionSurveyButton extends BaseActivitySprite
   {
      
      public function QuestionSurveyButton(param1:ActivityNodeInfo)
      {
         super(param1);
      }
      
      override protected function doAction() : void
      {
         WebURLUtil.intance.navigateBBS("http://dc.61.com/Question/realQ?qn_id=84");
      }
   }
}

