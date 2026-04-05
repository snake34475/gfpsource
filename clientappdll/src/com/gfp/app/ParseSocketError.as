package com.gfp.app
{
   import com.gfp.app.toolBar.chat.MultiChatPanel;
   import com.gfp.core.config.ClientConfig;
   import com.gfp.core.events.SocketErrorCodeEvent;
   import com.gfp.core.manager.AlertManager;
   import com.gfp.core.manager.alert.AlertType;
   import com.gfp.core.map.CityMap;
   import com.gfp.core.map.MapManager;
   import com.gfp.core.ui.alert.TextAlert;
   import com.gfp.core.utils.Logger;
   import com.gfp.core.utils.TextUtil;
   import com.taomee.analytics.Analytics;
   import com.taomee.analytics.type.ErrorTypes;
   import flash.events.EventDispatcher;
   import org.taomee.ds.HashMap;
   import org.taomee.net.tmf.HeadInfo;
   
   public class ParseSocketError
   {
      
      private static var _ed:EventDispatcher;
      
      private static var errorCodeMap:HashMap = new HashMap();
      
      errorCodeMap.add(10001,"小侠士输入的密码是错误的，请重新试试吧！");
      errorCodeMap.add(10002,"系统错误");
      errorCodeMap.add(10003,"系统繁忙");
      errorCodeMap.add(10004,"您的账号已经在别处登录！如非本人操作，请立即更改密码！");
      errorCodeMap.add(10005,"小侠士不能使用与功夫派无关的用语哦！");
      errorCodeMap.add(10006,"你所寻找的小侠士不在线哦！");
      errorCodeMap.add(10008,"\r\r\r \t\t您的功力严重消耗，没有足够的能力参与战斗！休息一下，明天体力充沛了再来吧。");
      errorCodeMap.add(10009,"\r\r\r 小英雄：\r \t\t夜已经深了，再过15分钟就要睡觉休息啦！让我们恢复一下功力明天再来闯荡江湖吧！");
      errorCodeMap.add(10017,"这件物品无法购买哦，请小侠士再试试其他的吧！");
      errorCodeMap.add(10020,"因为等级不够，你还无法修炼这个技能哦！");
      errorCodeMap.add(10021,"背包满了，先清理一下吧！");
      errorCodeMap.add(10022,"背包满了，物品已通过邮件发送，请查收！");
      errorCodeMap.add(10041,"小侠士已经拥有月灵兔了哦");
      errorCodeMap.add(10042,"小侠士你的超灵侠士等级不够！");
      errorCodeMap.add(10043,"小侠士你还未开通年费超灵侠士哦！");
      errorCodeMap.add(10046,"小侠士昵称修改后需要20天后才能再次修改！");
      errorCodeMap.add(10047,"侠士团加入失败！");
      errorCodeMap.add(10103,"这件物品无法购买哦，小侠士再试试其他的吧！");
      errorCodeMap.add(10104,"小侠士身上的功夫豆或银票不够多哦，下次再来吧！");
      errorCodeMap.add(10105,"此物品不存在！");
      errorCodeMap.add(10106,"小侠士的等级不够哦！");
      errorCodeMap.add(10108,"这个技能无法使用快捷键哦，请换一个试试吧！");
      errorCodeMap.add(10107,"你没有足够的琥珀之力哦！\n(小侠士可以在每次等级提升以及一些活动奖励中获得琥珀之力)");
      errorCodeMap.add(10109,"当前技能已修炼到最高重");
      errorCodeMap.add(10111,"这件物品无法出售哦，小侠士再试试其他的吧！");
      errorCodeMap.add(10113,"对战中不能使用普通药品");
      errorCodeMap.add(10114,"你没有足够的武勋哦！");
      errorCodeMap.add(10115,"不能用武勋购买此物");
      errorCodeMap.add(10120,"恭喜你完成这个任务啦，勇气在你心中！");
      errorCodeMap.add(10121,"主线任务是无法放弃的，小侠士要努力哦！");
      errorCodeMap.add(10122,"任务不能重复接取，小侠士再试试其他的吧！");
      errorCodeMap.add(10125,"战斗中无法领取双倍经验！");
      errorCodeMap.add(10127,"你的超灵侠士等级不够！");
      errorCodeMap.add(10128,"小侠士，在关卡中不能使用该物品！");
      errorCodeMap.add(10129,"小侠士，经验加倍道具不能叠加使用！");
      errorCodeMap.add(10134,"你已成功召唤仙兽,快带上它战斗吧！");
      errorCodeMap.add(10133,"小侠士，你的仙兽当前无法升级！");
      errorCodeMap.add(10135,"商城装备不能分解哟！");
      errorCodeMap.add(10136,"无法分配经验，宠物不存在！");
      errorCodeMap.add(10137,"灵魔宝盒中经验不足，请重新分配经验！");
      errorCodeMap.add(10138,"仙兽不能再获得更多经验了，请重新分配经验！");
      errorCodeMap.add(10139,"你的仙兽等级不能高于人物等级！");
      errorCodeMap.add(10146,"小侠士,你没有取得争霸赛参赛资格,先历练自己吧,下一届中也许你就是天下第一");
      errorCodeMap.add(10148,"小侠士你今天接取探宝任务已到上限了哟！");
      errorCodeMap.add(10149,"小侠士请先完成已接取的探宝任务在接取新的吧！");
      errorCodeMap.add(10152,"每天只可以领取一次双倍经验时间！");
      errorCodeMap.add(10162,"如果在4月1日10：00~4月15日10：00期间累计充值3个月以上超灵侠士还可以额外获得“特殊奖励”，可以与“侠士礼包”一起领取哦，小侠士现在要开通吗？");
      errorCodeMap.add(10169,"伏魔塔里不能携带仙兽哦！");
      errorCodeMap.add(10185,"伏魔奖励只能当周领取一次哦！");
      errorCodeMap.add(10186,"小侠士请休息30秒再发号角！");
      errorCodeMap.add(10187,"小侠士请休息3分钟再发公告！");
      errorCodeMap.add(10195,"小侠士你要进入的家园人数已满,请稍后再进吧！");
      errorCodeMap.add(11001,"小侠士不能邀请自己对战哦！");
      errorCodeMap.add(11003,"当前不能取消对战");
      errorCodeMap.add(11004,"战斗已结束");
      errorCodeMap.add(11006,"对战系统出错，战斗结束");
      errorCodeMap.add(11007,"你所进入的关卡不存在，请试试其他的吧！");
      errorCodeMap.add(11008,"你的等级不够，无法进入这个关卡哦，努力后再来试试吧！");
      errorCodeMap.add(11009,"你所进入的关卡不存在，请试试其他的吧！");
      errorCodeMap.add(11010,"你所在的地图还有其他的怪物哦！");
      errorCodeMap.add(11013,"小侠士！你的动作太慢了没能成功组成队伍哦！");
      errorCodeMap.add(11014,"队伍已满,再看看其他队伍吧！");
      errorCodeMap.add(11015,"当前还没有队伍,你可以创建一个！");
      errorCodeMap.add(11016,"小侠士，这个位置已经有人占有了，请选择其他的位置进行切磋吧！");
      errorCodeMap.add(11017,"小侠士！你的动作太慢了没能成功加入切磋哦！");
      errorCodeMap.add(11062,"等级没有达到学习副职的要求!");
      errorCodeMap.add(11107,"小侠士青龙只有12点到22点才能被唤醒！");
      errorCodeMap.add(11108,"小侠士，你未达到领奖条件");
      errorCodeMap.add(11109,"小侠士，你支付密码错误次数过于频繁，请稍等30秒再试！");
      errorCodeMap.add(12001,"empty");
      errorCodeMap.add(11005,"empty");
      errorCodeMap.add(12005,"怒气值不足");
      errorCodeMap.add(10110,"你的身上还没有需要修理的装备哦！");
      errorCodeMap.add(101001,"数据繁忙");
      errorCodeMap.add(101002,"数据出错!");
      errorCodeMap.add(101003,"网络出错");
      errorCodeMap.add(101006,"物品数量超过最大限制");
      errorCodeMap.add(101105,"你输入的米米号不存在，再试试其他的吧！");
      errorCodeMap.add(103103,"该好友已存在！");
      errorCodeMap.add(103105,"你的好友个数已达上限！");
      errorCodeMap.add(105164,"小侠士，此次进化失败，魔龙之鳞消失，请继续努力！");
      errorCodeMap.add(103140,"你已学会这个技能啦，再试试其他的吧！");
      errorCodeMap.add(103141,"技能不存在！");
      errorCodeMap.add(103200,"小侠士身上的功夫豆或银票不够多哦，下次再来吧！");
      errorCodeMap.add(103121,"很抱歉，没有这个物品哦！");
      errorCodeMap.add(103111,"很抱歉，没有这个物品哦！");
      errorCodeMap.add(103122,"很抱歉，需要的物品的数量不足！");
      errorCodeMap.add(103113,"背包满了，先清理一下吧！");
      errorCodeMap.add(103123,"背包满了，先清理一下吧！");
      errorCodeMap.add(11052,"背包满了，先清理一下吧！");
      errorCodeMap.add(11053,"背包满了，先清理一下吧！");
      errorCodeMap.add(11063,"背包满了，先清理一下吧！");
      errorCodeMap.add(11064,"小侠士,你还不是学院新秀,不能加入战队！");
      errorCodeMap.add(11065,"小侠士,你的复活草数量不足！");
      errorCodeMap.add(11066,"小侠士,你还没有加入任何战队！");
      errorCodeMap.add(11101,"小侠士,青龙已经被其他小侠士召唤出来了,快去\t功夫城许愿吧!");
      errorCodeMap.add(11102,"小侠士,龙珠的灵气不够,无法唤醒青龙!");
      errorCodeMap.add(11103,"小侠士,你已经许过愿了,下周再来吧！");
      errorCodeMap.add(11104,"小侠士，五颗龙珠的灵气达到1000的时候在武圣处召唤青龙后才可许愿哦~");
      errorCodeMap.add(11105,"小侠士,青龙还未苏醒快去收集齐5个龙珠唤醒青龙许愿吧！");
      errorCodeMap.add(11106,"小侠士,你还没有捐献灵气,青龙无法满足你的愿望！快到" + TextUtil.getHtmlCodeByNpcId(10001) + "那里召唤青龙捐献灵气吧");
      errorCodeMap.add(103200,"小侠士身上的功夫豆不够哦，下次再来吧！");
      errorCodeMap.add(11050,"小侠士身上的功夫豆不够哦，下次再来吧！");
      errorCodeMap.add(10150,"小侠士,你已达次数上限。");
      errorCodeMap.add(103151,"小侠士,你已达次数上限。");
      errorCodeMap.add(10151,"小侠士您开通的超灵侠士月数不符合本兑换！");
      errorCodeMap.add(10153,"小侠士，你已达今天次数上限，明天再来吧。");
      errorCodeMap.add(10154,"小侠士，你已达这周次数上限，下周再来吧。");
      errorCodeMap.add(10155,"小侠士，你已兑换过了。");
      errorCodeMap.add(103181,"小侠士，你已兑换过了。");
      errorCodeMap.add(10156,"小侠士，你已达今年次数上限，明年再来吧。");
      errorCodeMap.add(10157,"亲爱的小侠士，你已经领取过啦！");
      errorCodeMap.add(10119,"小侠士的伏魔点不够哦，下次再来吧!");
      errorCodeMap.add(101017,"网络超时！");
      errorCodeMap.add(10011,"你的等级未到领取要求，不能领取！");
      errorCodeMap.add(10124,"小侠士接了太多任务啦，完成一部分后再来接任务吧！");
      errorCodeMap.add(10141,"清崖的祝福不能重复使用！");
      errorCodeMap.add(10142,"对不起，你还没有参加淘汰赛的资格！");
      errorCodeMap.add(10143,"对不起，你还不能领取该奖励！");
      errorCodeMap.add(10144,"对不起，你已经没有挑战机会了！");
      errorCodeMap.add(10145,"对不起，你还不能获得进阶赛奖品！");
      errorCodeMap.add(11051,"仓库已满。");
      errorCodeMap.add(105104,"仓库已满。");
      errorCodeMap.add(105121,"对方邮箱已满");
      errorCodeMap.add(11054,"不能将这件物品放入仓库哟。");
      errorCodeMap.add(11055,"错误的副职类型");
      errorCodeMap.add(11056,"副职已经存在");
      errorCodeMap.add(11057,"副职不存在");
      errorCodeMap.add(11058,"错误的物品");
      errorCodeMap.add(11059,"级别太低，无法制作该物品");
      errorCodeMap.add(11060,"功夫豆不够，无法学习申请成为学徒");
      errorCodeMap.add(11061,"材料不够");
      errorCodeMap.add(11067,"小侠士你的鲜花不够哦");
      errorCodeMap.add(11072,"小侠士请稍后再来");
      errorCodeMap.add(10126,"战斗中无法领取!");
      errorCodeMap.add(11080,"重复的邮件ID!");
      errorCodeMap.add(11081,"邮件ID不存在!");
      errorCodeMap.add(11082,"请整理背包一边取邮件附件!");
      errorCodeMap.add(11083,"小侠士，你的功夫豆不足!");
      errorCodeMap.add(11087,"小侠士，你的银锭不足!");
      errorCodeMap.add(11084,"错误的收件人!");
      errorCodeMap.add(11085,"邮件没有附件!");
      errorCodeMap.add(10032,"超灵剩余天数不足");
      errorCodeMap.add(10031,"超灵侠士专属，请开通超灵侠士！");
      errorCodeMap.add(10147,"小侠士请带上白玉狐才能升级哦!");
      errorCodeMap.add(10159,"不在规定时间内!");
      errorCodeMap.add(10160,"小侠士只能在周五周六和周日挑战");
      errorCodeMap.add(10161,"小侠士你的等级不对哦！");
      errorCodeMap.add(10163,"你现在还不能进入副本哦。\n挑战时间为每天的19:00—21:00!");
      errorCodeMap.add(10164,"小侠士只能在周五周六和周日挑战刀郎哦！");
      errorCodeMap.add(10165,"刀郎建议你不要让仙兽参与战斗，请收回仙兽。");
      errorCodeMap.add(10166,"小侠士只能在周五周六和周日挑战哦！");
      errorCodeMap.add(10167,"经验值不能再增加！");
      errorCodeMap.add(10170,"小侠士你的材料不够哦！");
      errorCodeMap.add(10171,"小侠士你的材料不能强化该品质装备");
      errorCodeMap.add(10172,"小侠士你的材料不能强化该等级的装备！");
      errorCodeMap.add(10173,"小侠士你的魂石选择错误哦！");
      errorCodeMap.add(10174,"你的魂石不能强化该品质装备");
      errorCodeMap.add(10175,"你的魂石不能强化该等级的装备");
      errorCodeMap.add(10176,"小侠士你的装备强化等级太高已经不能被强化了！");
      errorCodeMap.add(10177,"小侠士你不能带仙兽进入此关卡！");
      errorCodeMap.add(10178,"小侠士，你正处在交易房间不能参加战斗！");
      errorCodeMap.add(10179,"对不起，对方正处在战斗中！");
      errorCodeMap.add(10188,"你现在还不能进入副本哦。\n挑战时间为每天的12：00～21：00\n或者从药师爷爷处获得功夫圣纹，即可进入副本");
      errorCodeMap.add(10189,"你现在还不能进入副本哦。\n挑战时间为周一至周五的12:00~13:00,19:00~20:00，周六周日的9:00~11:00,14:00~16：00");
      errorCodeMap.add(10190,"你现在还不能进入副本哦。\n挑战时间为周一至周五的12:00~13:00,19:00~20:00，周六周日的9:00~11:00,14:00~16：00");
      errorCodeMap.add(10191,"亲爱的小侠士 \n 你输入的米米号不存在");
      errorCodeMap.add(10192,"亲爱的小侠士 \n 对方设置了禁止别人加他为好友");
      errorCodeMap.add(10193,"小侠士你使用的圣光魂石数量不对");
      errorCodeMap.add(10194,"比赛正式时间为周末 13:00~15:00");
      errorCodeMap.add(10198,"小侠士你的互助度不足");
      errorCodeMap.add(10200,"小侠士你已经投过票了！");
      errorCodeMap.add(10228,"小侠士不可重复押镖");
      errorCodeMap.add(11068,"不在活动期间内。");
      errorCodeMap.add(11069,"抱歉小侠士，你还没有取得领奖资格。");
      errorCodeMap.add(11070,"抱歉小侠士，你所在的队伍没有获得该阶段的胜利。");
      errorCodeMap.add(11071,"抱歉小侠士，你不能领取该奖励。");
      errorCodeMap.add(11090,"抱歉小侠士，你一天最多只能购买20份糯米。");
      errorCodeMap.add(110199,"小侠士，你的伏魔点不足。");
      errorCodeMap.add(11110,"小侠士，交易时间为早上7点到23点。注意休息哟");
      errorCodeMap.add(12002,"小侠士，您已经持续在线太长时间了，请注意休息。");
      errorCodeMap.add(12003,"小侠士，库存不足，请下次活动再来！");
      errorCodeMap.add(12004,"小侠士，青龙已经被其他侠士唤醒了,快去功夫城许愿吧!");
      errorCodeMap.add(12005,"小侠士，目前龙珠拥有的灵气不足,无法召唤!");
      errorCodeMap.add(14004,"小侠士，你的家园等级不足");
      errorCodeMap.add(103203,"小侠士，你的伏魔点不足!");
      errorCodeMap.add(300001,"无效操作!");
      errorCodeMap.add(300002,"数据格式错误!");
      errorCodeMap.add(300003,"参数不合法!");
      errorCodeMap.add(300004,"系统出错!");
      errorCodeMap.add(300009,"商品项数过大!");
      errorCodeMap.add(300010,"小侠士商品不存在哦!");
      errorCodeMap.add(300011,"米米号不存在!");
      errorCodeMap.add(300012,"小侠士输入的购买支付密码不正确哦。" + "\n" + "如果未设置支付密码请点击确认后" + "\n" + "再点击“设置密码”进行设置!");
      errorCodeMap.add(300013,"小侠士请求购买商品数量超出当前商品库存!");
      errorCodeMap.add(300014,"小侠士不是超灵侠士，无权兑换通宝哦!");
      errorCodeMap.add(300015,"小侠士购买的数量超过了每位小侠士购买的上限了哦!");
      errorCodeMap.add(300016,"小侠士购买的数量超过了每位小侠士购买的上限了哦!");
      errorCodeMap.add(300017,"小侠士购买的数量超过了每位小侠士购买的上限了哦!");
      errorCodeMap.add(300018,"小侠士，商品不存在!");
      errorCodeMap.add(300019,"小侠士购买的数量超过了每位小侠士购买的上限了哦!");
      errorCodeMap.add(300020,"小侠士背包已满哦!");
      errorCodeMap.add(300021,"小侠士你购买的物品超过堆叠上限了哦!");
      errorCodeMap.add(300022,"小侠士购买的数量超过了每位小侠士购买的上限了哦!");
      errorCodeMap.add(300023,"小侠士购买的装备不存在哦!");
      errorCodeMap.add(300102,"小侠士你的米币账户不存在哦!");
      errorCodeMap.add(300104,"小侠士你的米币账户未激活哦!");
      errorCodeMap.add(300105,"小侠士你的米币账户余额不足!");
      errorCodeMap.add(300106,"购买数量出错!");
      errorCodeMap.add(300107,"小侠士超过当月消费限制了，要养成要合理消费的好习惯呢!");
      errorCodeMap.add(300108,"小侠士超过单笔消费限制了，要养成要合理消费的好习惯呢!");
      errorCodeMap.add(300202,"小侠士你的通宝账户不存在哦!");
      errorCodeMap.add(300204,"小侠士你的通宝账户未激活!");
      errorCodeMap.add(300205,"小侠士你的通宝账户余额不足!");
      errorCodeMap.add(300206,"购买数量出错!");
      errorCodeMap.add(300207,"小侠士超过当月消费限制了，要养成要合理消费的好习惯呢!");
      errorCodeMap.add(300208,"小侠士超过单笔消费限制了，要养成要合理消费的好习惯呢!");
      errorCodeMap.add(10044,"小侠士你的金币数量不足!");
      errorCodeMap.add(10180,"你指定的交易房间已经满了!");
      errorCodeMap.add(10181,"已经开店啦!");
      errorCodeMap.add(10182,"没在交易房间!");
      errorCodeMap.add(10183,"此物品无法交易!");
      errorCodeMap.add(13001,"不存在该市场房间!");
      errorCodeMap.add(13002,"不存在该商店!");
      errorCodeMap.add(13003,"市场满了!");
      errorCodeMap.add(13004,"在规定时间内不能连续在同一摊位开!");
      errorCodeMap.add(13005,"你对该摊位的使用时间已到，请选择其他的摊位使用！");
      errorCodeMap.add(13006,"已经有店铺了!");
      errorCodeMap.add(13007,"店铺暂停营业中!");
      errorCodeMap.add(13008,"该物品正在被交易!");
      errorCodeMap.add(11111,"小侠士，你身上的功夫豆已经达到了最大限额!");
      errorCodeMap.add(11040,"不存在该称号!");
      errorCodeMap.add(11041,"玩家还没有获得这个称号!");
      errorCodeMap.add(14001,"小侠士，当前植物不能采集!");
      errorCodeMap.add(14002,"不能在该地上种植!");
      errorCodeMap.add(14003,"不能频繁浇水!");
      errorCodeMap.add(1009,"家园等级不足!");
      errorCodeMap.add(11073,"小侠士，你的活力值不足,保持在线每分钟获得2点活力值!");
      errorCodeMap.add(10201,"小侠士，你的仙兽必须达到最终期以上阶段才能进行该操作!");
      errorCodeMap.add(10202,"小侠士，你的仙兽还没有这个技能!");
      errorCodeMap.add(10211,"小侠士，比武大会该段已结束!");
      errorCodeMap.add(10212,"资格赛时间为10月1日~10月5日,每天下午13:00~15:00");
      errorCodeMap.add(105135,"小侠士，你的动作慢了一步，对方侠士团人员已满！");
      errorCodeMap.add(105136,"小侠士，你的团队资金已达到上限！");
      errorCodeMap.add(105137,"对不起，你的该孵化物品只能炼化对应的仙兽！");
      errorCodeMap.add(105138,"对不起，该仙兽暂时不能被放生！");
      errorCodeMap.add(105139,"对不起，你的仙兽数量已经达到上限！");
      errorCodeMap.add(105140,"出战中的仙兽技能才能被禁用！");
      errorCodeMap.add(10130,"小侠士，你还没有这个仙兽！");
      errorCodeMap.add(10131,"小侠士，你还不能召唤该仙兽！");
      errorCodeMap.add(11019,"小侠士，你还没有获得该关卡的挑战资格，请继续努力！");
      errorCodeMap.add(10213,"小侠士，你还没满足参加活动的条件！");
      errorCodeMap.add(10214,"小侠士，你的侠士团已经报名了，不能重复报名！");
      errorCodeMap.add(10215,"小侠士，你的团队资金不够！");
      errorCodeMap.add(10216,"小侠士，你不是团长，不能进行该操作！");
      errorCodeMap.add(10217,"小侠士，你不是侠士团成员！");
      errorCodeMap.add(10218,"小侠士，你的团队资金已达到上限！");
      errorCodeMap.add(10219,"小侠士，此活动为30分钟一次,请稍后再来砸南瓜吧！");
      errorCodeMap.add(10220,"师徒关系解除失败！师徒关系处在保护时间内或者关系已解除！");
      errorCodeMap.add(10221,"小侠士已有师傅！");
      errorCodeMap.add(10231,"小侠士你为侠士团增加的贡献值还不够呢，需要增加500点贡献值才能领取奖励哦！");
      errorCodeMap.add(10248,"只有转生前玩家才可以报名参赛~ ");
      errorCodeMap.add(10049,"小侠士，该用户已经有师傅或收徒人数达到上限！");
      errorCodeMap.add(14005,"雪人已堆好，不需要再堆了！");
      errorCodeMap.add(10222,"对不起小侠士，你还没有开启伏魔阵！");
      errorCodeMap.add(10223,"小侠士，烟花只能在功夫城使用哦，快去看吧！");
      errorCodeMap.add(10224,"小侠士，庆典烟花要间隔20秒才能使用一次哦！");
      errorCodeMap.add(20004,"对不起小侠士，你输入的米米号非法！");
      errorCodeMap.add(20005,"对不起小侠士，你已经提交过一次了！");
      errorCodeMap.add(20006,"该职位人数已满，无法任命！");
      errorCodeMap.add(20007,"对不起，小侠士，只有团长可以进行该操作。");
      errorCodeMap.add(20008,"对不起，这位小侠士已经不在侠士团中。");
      errorCodeMap.add(20009,"小侠士，你已经报名武林盛典了！");
      errorCodeMap.add(20010,"小侠士，你没有足够的武勋！");
      errorCodeMap.add(20011,"对不起，参赛人员还没满，不能进行冠军竞猜！");
      errorCodeMap.add(20012,"小侠士，你还没有报名武林盛典！");
      errorCodeMap.add(20013,"小侠士，武林盛典系统维护中，暂时不能报名！");
      errorCodeMap.add(20014,"对不起，现在不在武林盛典活动期间内！");
      errorCodeMap.add(20015,"现在不能竞猜哦，只有凑齐16人，第一轮比赛前可竞猜。");
      errorCodeMap.add(301001,"系统错误!");
      errorCodeMap.add(301002,"数据库错误!");
      errorCodeMap.add(301004,"命令号未定义!");
      errorCodeMap.add(301005,"协议长度不对!");
      errorCodeMap.add(301009,"参数有误!");
      errorCodeMap.add(302001,"渠道验证失败!");
      errorCodeMap.add(302108,"不在活动范围内!");
      errorCodeMap.add(302109,"每日许愿次数超过5次!");
      errorCodeMap.add(10227,"亲爱的小侠士，从现在开始保持在线15分钟后再来领取!");
      errorCodeMap.add(302109,"每日许愿次数超过5次!");
      errorCodeMap.add(130004,"不在侠士团荣誉之战服务器!");
      errorCodeMap.add(130005,"小侠士，你已经参加报名了！");
      errorCodeMap.add(130006,"服务器已经满，请选择其他服务器！");
      errorCodeMap.add(130007,"对不起小侠士，你的侠士团还没报名！");
      errorCodeMap.add(130008,"不在比赛时间内！");
      errorCodeMap.add(130009,"小侠士，你动作太慢了，未能获得奖励");
      errorCodeMap.add(130010,"小侠士，现在还不能报名！");
      errorCodeMap.add(130011,"小侠士，荣誉之战没有找到对手！");
      errorCodeMap.add(130012,"小侠士，为了加强侠士的团队荣誉感，每天只能加入一次侠士团");
      errorCodeMap.add(130013,"旧装备强化等级不能低于2级！");
      errorCodeMap.add(130014,"被传承的装备等级必须高于传承装备！");
      errorCodeMap.add(130015,"传承的新旧物品品质必须一样！");
      errorCodeMap.add(130016,"武器只能和武器传承！");
      errorCodeMap.add(130017,"衣服不能传承给武器！");
      errorCodeMap.add(130018,"小侠士，交易，家园，战斗地图不能参加组队战斗！");
      errorCodeMap.add(130019,"小侠士，您没有达到领取奖励的要求，您不能领取奖励！");
      errorCodeMap.add(130020,"小侠士，您已经激活了一个大使招募卷轴，不能重复激活！");
      errorCodeMap.add(130021,"小侠士，您已经有角色超过20级，不能激活大使招募卷轴！");
      errorCodeMap.add(130022,"小侠士，您的大使招募卷轴不正确，请重新输入！");
      errorCodeMap.add(130023,"小侠士，你已经激活过了，不能重复激活！");
      errorCodeMap.add(130039,"小侠士，该大使招募卷轴已经被别的小侠士激活过了，不能重复激活！");
      errorCodeMap.add(10012,"小侠士，系统已检测到你触犯了《侠士行为准则》，你将会被封号一段时间。如对封号时间和原因有疑问，请<font color=\'#FF0000\'><b>重登游戏或咨询客服</b></font>了解详情。");
      errorCodeMap.add(130024,"小侠士，这个礼品我已经足够多了，下次您可以加快速度哦！");
      errorCodeMap.add(130025,"物品数量不足!");
      errorCodeMap.add(130026,"武器淬炼失败!");
      errorCodeMap.add(130027,"淬炼道具错误!");
      errorCodeMap.add(130028,"小侠士，你今天竞速次数已经达到上限!");
      errorCodeMap.add(130029,"小侠士，老兵召回需要在2012年8月1号以后没有登录过功夫派的侠士!");
      errorCodeMap.add(130030,"小侠士，你已经加入，可在经验回环花附近吸取经验，注意不要离开太远");
      errorCodeMap.add(130031,"小侠士，你来晚啦，此株经验回环花已有20人在吸取经验了!");
      errorCodeMap.add(130032,"小侠士，你距离经验回环花太远，请靠近点！");
      errorCodeMap.add(130033,"小侠士，你的疾风试炼任务没有完成，不能进入挑战！");
      errorCodeMap.add(130034,"小侠士，你已经进阶！");
      errorCodeMap.add(130037,"很遗憾，小侠士，你没有参加过资格赛！");
      errorCodeMap.add(10400,"物品换新失败！");
      errorCodeMap.add(10023,"小侠士，交易房间不能更换装备！");
      errorCodeMap.add(11112,"搜索玩家不存在！");
      errorCodeMap.add(11113,"位置编号不对!");
      errorCodeMap.add(11114,"使用圣光魂石超过最大限制!");
      errorCodeMap.add(11115,"小侠士，动作慢了，该位置已经被人抢走了！");
      errorCodeMap.add(11116,"小侠士，你只能抢占一个推荐位！");
      errorCodeMap.add(11117,"小侠士，你还没报名！");
      errorCodeMap.add(11118,"小侠士，充值超灵侠士后才能领取超灵火种哦！");
      errorCodeMap.add(11119,"对不起，不在活动时间内！");
      errorCodeMap.add(11120,"小侠士，你的等级太低还不能接取该任务！");
      errorCodeMap.add(105143,"小侠士，该仙兽此时不能被放入仓库或者放入仙兽栏！");
      errorCodeMap.add(20056,"米米号或者邀请码错误！");
      errorCodeMap.add(20057,"该玩家已经被绑定！");
      errorCodeMap.add(20058,"该玩家不是新用户！");
      errorCodeMap.add(105145,"小侠士，请先让当前仙兽进入下个形态后再使用特权!");
      errorCodeMap.add(105146,"对不起小侠士，每人只有一次炼化机会。");
      errorCodeMap.add(105148,"不允许这样护法。");
      errorCodeMap.add(105149,"小侠士，你已经领取过来。");
      errorCodeMap.add(11099,"小侠士，你暂时不满足锻造的条件哦");
      errorCodeMap.add(10401,"小侠士挑战完四灵才能领取奖励！");
      errorCodeMap.add(130050,"小侠士，你的积分没有达到5000，无法领取奖励");
      errorCodeMap.add(130042,"小侠士，你已经选取了100组仙兽组合，到达次数上限。");
      errorCodeMap.add(10230,"小侠士，你现在没有领奖资格。");
      errorCodeMap.add(10232,"因侠士违反公平竞赛原则，需去海振兴处缴纳罚金，否则将无法继续参加比武！");
      errorCodeMap.add(10240,"小侠士，您的活力值不够哦。");
      errorCodeMap.add(10919,"需要充值1个月超灵侠士才能领取奖励哦！");
      errorCodeMap.add(105166,"小侠士，你许愿失败！");
      errorCodeMap.add(105157,"小侠士，你今天已经领取过一只仙兽了，明天再来领取吧");
      errorCodeMap.add(105154,"小侠士，治疗次数已经用完啦，明天再来吧");
      errorCodeMap.add(100919,"小侠士，您已经领取过奖励或者不符合领奖条件。");
      errorCodeMap.add(20032,"3分钟之内不能点击");
      errorCodeMap.add(20033,"玩家不是南瓜罐");
      errorCodeMap.add(20022,"小侠士购物车太满了，请分批次购买哦");
      errorCodeMap.add(10099,"小侠士，需要转生后才能进入该关卡。");
      errorCodeMap.add(10100,"小侠士，当前的活力值不足哦。");
      errorCodeMap.add(105163,"小侠士，您已经有仙兽参评。");
      errorCodeMap.add(130003,"没有带仙兽。");
      errorCodeMap.add(20043,"小侠士下手过慢，这颗树上的桃子刚被摘掉了哦。");
      errorCodeMap.add(10402,"小侠士，队伍中有队员不满足挑战条件！");
      errorCodeMap.add(12007,"小侠士这个米米号已经被邀请过了哦，换一个吧~");
      errorCodeMap.add(10249,"该任务放弃次数过多，已经不能再接取了哦。");
      errorCodeMap.add(10506,"小侠士，当前状态下不能变身哦！");
      errorCodeMap.add(10510,"国王指派攻打自己国家。");
      errorCodeMap.add(10511,"国王指派的国家不接壤。");
      errorCodeMap.add(10512,"首都不能被攻打。");
      errorCodeMap.add(10513,"城市编号非法。");
      errorCodeMap.add(10514,"不是国王 不能指派。");
      errorCodeMap.add(10515,"当天只有一次指派机会。");
      errorCodeMap.add(10516,"没有可以攻打的城市。");
      errorCodeMap.add(10517,"没有可以防御的城市。");
      errorCodeMap.add(10250,"不能把团长转给自己");
      errorCodeMap.add(10251,"目标团长不是自己团员");
      errorCodeMap.add(10252,"增加推荐值失败");
      errorCodeMap.add(10254,"申请侠士团的预留位置已满");
      errorCodeMap.add(10255,"无法再批准更多小侠士加入！");
      errorCodeMap.add(10256,"在自己侠士团申请列表没有这个玩家");
      errorCodeMap.add(10257,"这个玩家已经被其他侠士团先抢了");
      errorCodeMap.add(10258,"设置错误");
      errorCodeMap.add(10259,"侠士团禁止加入");
      errorCodeMap.add(10264,"守护兽成长已满，请先进化");
      errorCodeMap.add(20051,"小侠士你已经在这里领取过菲欧娜姐姐的奖励了，等下个地方吧~");
      errorCodeMap.add(10519,"据点参数错误");
      errorCodeMap.add(10520,"非法移动");
      errorCodeMap.add(10521,"地图不符");
      errorCodeMap.add(10522,"超过最大出战守护神的数目");
      errorCodeMap.add(20052,"检测到使用非法程序！");
      errorCodeMap.add(20053,"小侠士，你慢了一步，这个宝物已被其它侠士抢走啦！");
      errorCodeMap.add(20054,"小侠士，你当前输入的米米号已经绑定了三个玩家，无法继续绑定哦~");
      errorCodeMap.add(20055,"小侠士，被召集者之间无法互相绑定哦~");
      errorCodeMap.add(130052,"小侠士，你的银票已经达到上限~");
      
      public function ParseSocketError()
      {
         super();
      }
      
      public static function parse(param1:HeadInfo) : void
      {
         var errorMsg:String;
         var isAlreadyNotice:Boolean;
         var info:HeadInfo = param1;
         Logger.error(null,"cmdID:" + info.commandID + "错误码——————————————" + info.error);
         errorMsg = errorCodeMap.getValue(info.error);
         if(errorMsg == null || errorMsg == "")
         {
            if(!(!ClientConfig.isRelease() || info.error == 105164))
            {
               return;
            }
            errorMsg = "命令号：" + info.commandID + "  错误码编号：" + info.error;
         }
         isAlreadyNotice = false;
         isAlreadyNotice = errorMsg == "empty";
         switch(info.error)
         {
            case 10002:
               Analytics.submitErrorInfo(ErrorTypes.SYSTEM_ERROR,"系统错误");
               break;
            case 10003:
               Analytics.submitErrorInfo(ErrorTypes.SYSTEM_BUSY,"系统繁忙");
               break;
            case 10005:
               isAlreadyNotice = true;
               MultiChatPanel.instance.showSystemNotice(errorMsg);
               break;
            case 10008:
               isAlreadyNotice = true;
               AlertManager.show(AlertType.PREVENT_ADDICTED_ALARM,errorMsg);
               break;
            case 10009:
               isAlreadyNotice = true;
               AlertManager.show(AlertType.PREVENT_ADDICTED_ALARM,errorMsg);
               Analytics.enabledSubmit = false;
               break;
            case 10113:
               isAlreadyNotice = true;
               TextAlert.show(errorMsg);
               break;
            case 10232:
               isAlreadyNotice = true;
               AlertManager.showSimpleAlert(errorMsg,function():void
               {
                  CityMap.instance.tranToNpc(10123);
               });
               break;
            case 11006:
               Analytics.submitErrorInfo(ErrorTypes.SYSTEM_ERROR_FIGHT,"对战系统出错，战斗结束");
               break;
            case 12005:
               isAlreadyNotice = true;
               TextAlert.show(errorMsg);
               break;
            case 11072:
               isAlreadyNotice = true;
               TextAlert.show(errorMsg);
               break;
            case 105150:
               isAlreadyNotice = true;
               break;
            case 103113:
            case 103123:
            case 101006:
               isAlreadyNotice = true;
               TextAlert.show(errorMsg);
         }
         if(!isAlreadyNotice)
         {
            if(info.error != 12006)
            {
               if(ClientConfig.isRelease())
               {
                  if(info.error == 300012)
                  {
                     AlertManager.showSetPayPasswordAlarm("小侠士，你输入的支付密码不正确。");
                  }
                  else if(info.error == 10180)
                  {
                     TextAlert.show(errorMsg);
                  }
                  else
                  {
                     AlertManager.showSimpleAlarm(errorMsg);
                  }
               }
               else if(info.error == 300012)
               {
                  AlertManager.showSetPayPasswordAlarm("小侠士，你输入的支付密码不正确。");
               }
               else
               {
                  AlertManager.showSimpleAlarm("命令号：" + info.commandID + "，错误码：" + info.error + errorMsg);
               }
            }
         }
         dispatchErrorCodeEvent(info.commandID,info);
         if(info.commandID != 0)
         {
            MapManager.clearMapEndAction();
         }
      }
      
      private static function getED() : EventDispatcher
      {
         if(_ed == null)
         {
            _ed = new EventDispatcher();
         }
         return _ed;
      }
      
      public static function addErrorCodeListener(param1:int, param2:Function) : void
      {
         getED().addEventListener(param1.toString(),param2);
      }
      
      public static function removeErrorCodeListener(param1:int, param2:Function) : void
      {
         getED().removeEventListener(param1.toString(),param2);
      }
      
      public static function dispatchErrorCodeEvent(param1:int, param2:HeadInfo) : void
      {
         if(hasErrorCodeListener(param1))
         {
            getED().dispatchEvent(new SocketErrorCodeEvent(param1.toString(),param2));
         }
      }
      
      public static function hasErrorCodeListener(param1:int) : Boolean
      {
         return getED().hasEventListener(param1.toString());
      }
   }
}

