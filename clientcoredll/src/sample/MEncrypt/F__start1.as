package sample.MEncrypt
{
   import avm2.intrinsics.memory.*;
   import sample.MEncrypt__3A__5C_Crossbridge_5C_cygwin_5C_tmp_5C_cc3cftGb_2E_lto_2E_bc_3A_6272de50_2D_9bd4_2D_49c1_2D_a979_2D_24c41198111b.*;
   
   public function F__start1() : void
   {
      var _loc1_:int = 0;
      var _loc9_:int = 0;
      var _loc3_:int = 0;
      var _loc4_:int = 0;
      var _loc8_:int = 0;
      var _loc7_:int = 0;
      var _loc6_:int = 0;
      var _loc5_:int = 0;
      var _loc2_:int = sample.MEncrypt.ESP;
      _loc1_ = _loc2_;
      _loc2_ -= 16;
      _loc3_ = li32(_loc1_ + 4);
      _loc4_ = _loc3_ << 2;
      _loc5_ = li32(_loc1_ + 8);
      _loc6_ = _loc4_ + _loc5_;
      _loc4_ = _loc6_ + 4;
      si32(_loc4_,sample.MEncrypt__3A__5C_Crossbridge_5C_cygwin_5C_tmp_5C_cc3cftGb_2E_lto_2E_bc_3A_6272de50_2D_9bd4_2D_49c1_2D_a979_2D_24c41198111b._environ);
      if(_loc3_ >= 1)
      {
         _loc5_ = li32(_loc5_);
         if(_loc5_ != 0)
         {
            si32(_loc5_,sample.MEncrypt__3A__5C_Crossbridge_5C_cygwin_5C_tmp_5C_cc3cftGb_2E_lto_2E_bc_3A_6272de50_2D_9bd4_2D_49c1_2D_a979_2D_24c41198111b.___progname);
            _loc7_ = 0;
            while(true)
            {
               _loc3_ = _loc5_ + _loc7_;
               _loc8_ = li8(_loc3_);
               if(_loc8_ == 0)
               {
                  break;
               }
               if(_loc8_ != 47)
               {
                  _loc7_ += 1;
               }
               else
               {
                  _loc7_ += 1;
                  si32(int(_loc5_ + _loc7_),sample.MEncrypt__3A__5C_Crossbridge_5C_cygwin_5C_tmp_5C_cc3cftGb_2E_lto_2E_bc_3A_6272de50_2D_9bd4_2D_49c1_2D_a979_2D_24c41198111b.___progname);
               }
            }
         }
      }
      _loc9_ = _loc6_ + 8;
      do
      {
         _loc7_ = _loc9_ + 4;
         _loc3_ = li32(_loc9_ - 4);
         _loc6_ = 0;
         _loc9_ = _loc7_;
         _loc5_ = _loc6_;
         _loc8_ = _loc6_;
      }
      while(_loc3_ != 0);
      while(true)
      {
         _loc9_ = li32(_loc7_ - 4);
         if(_loc9_ <= 3)
         {
            if(_loc9_ == 0)
            {
               break;
            }
            if(_loc9_ == 3)
            {
               _loc8_ = li32(_loc7_);
            }
         }
         else if(_loc9_ != 4)
         {
            if(_loc9_ == 5)
            {
               _loc6_ = li32(_loc7_);
            }
         }
         else
         {
            _loc5_ = li32(_loc7_);
         }
         _loc7_ += 8;
      }
      if(_loc5_ == 32)
      {
         if(_loc8_ != 0)
         {
            if(_loc6_ != 0)
            {
               if(_loc6_ != 0)
               {
                  _loc5_ = _loc8_ + 16;
                  do
                  {
                     _loc3_ = li32(_loc5_ - 16);
                     if(_loc3_ == 7)
                     {
                        _loc3_ = li32(_loc5_ + 12);
                        _loc4_ = li32(_loc5_ + 4);
                        _loc4_ = _loc4_ + _loc3_;
                        si32(int(_loc4_ + -1) & int(0 - _loc3_),sample.MEncrypt__3A__5C_Crossbridge_5C_cygwin_5C_tmp_5C_cc3cftGb_2E_lto_2E_bc_3A_6272de50_2D_9bd4_2D_49c1_2D_a979_2D_24c41198111b._tls_static_space);
                        si32(li32(_loc5_),sample.MEncrypt__3A__5C_Crossbridge_5C_cygwin_5C_tmp_5C_cc3cftGb_2E_lto_2E_bc_3A_6272de50_2D_9bd4_2D_49c1_2D_a979_2D_24c41198111b._tls_init_size);
                        si32(li32(_loc5_ - 8),sample.MEncrypt__3A__5C_Crossbridge_5C_cygwin_5C_tmp_5C_cc3cftGb_2E_lto_2E_bc_3A_6272de50_2D_9bd4_2D_49c1_2D_a979_2D_24c41198111b._tls_init);
                     }
                     _loc5_ += 32;
                  }
                  while(_loc6_ += -1, _loc6_ != 0);
               }
               _loc3_ = li32(sample.MEncrypt__3A__5C_Crossbridge_5C_cygwin_5C_tmp_5C_cc3cftGb_2E_lto_2E_bc_3A_6272de50_2D_9bd4_2D_49c1_2D_a979_2D_24c41198111b._tls_static_space);
               ESP = _loc2_;
               F_malloc_init();
               _loc3_ += 3;
               _loc6_ = _loc3_ & -4;
               _loc3_ = sample.MEncrypt.eax;
               loop12:
               while(true)
               {
                  if(_loc3_ == 0)
                  {
                     while(true)
                     {
                        _loc5_ = _loc6_ + 12;
                        if(_loc5_ == 0)
                        {
                           _loc5_ = 1;
                           if(li8(sample.MEncrypt__3A__5C_Crossbridge_5C_cygwin_5C_tmp_5C_cc3cftGb_2E_lto_2E_bc_3A_6272de50_2D_9bd4_2D_49c1_2D_a979_2D_24c41198111b._opt_sysv_2E_b) != 0)
                           {
                              break;
                           }
                        }
                        _loc3_ = li32(sample.MEncrypt__3A__5C_Crossbridge_5C_cygwin_5C_tmp_5C_cc3cftGb_2E_lto_2E_bc_3A_6272de50_2D_9bd4_2D_49c1_2D_a979_2D_24c41198111b._arena_maxclass);
                        if(uint(_loc3_) < uint(_loc5_))
                        {
                           _loc4_ = li32(sample.MEncrypt__3A__5C_Crossbridge_5C_cygwin_5C_tmp_5C_cc3cftGb_2E_lto_2E_bc_3A_6272de50_2D_9bd4_2D_49c1_2D_a979_2D_24c41198111b._chunksize_mask);
                           _loc5_ = int(_loc4_ + _loc5_) & (_loc4_ ^ -1);
                           if(_loc5_ != 0)
                           {
                              _loc7_ = li32(sample.MEncrypt__3A__5C_Crossbridge_5C_cygwin_5C_tmp_5C_cc3cftGb_2E_lto_2E_bc_3A_6272de50_2D_9bd4_2D_49c1_2D_a979_2D_24c41198111b._base_nodes);
                              if(_loc7_ != 0)
                              {
                                 si32(li32(_loc7_),sample.MEncrypt__3A__5C_Crossbridge_5C_cygwin_5C_tmp_5C_cc3cftGb_2E_lto_2E_bc_3A_6272de50_2D_9bd4_2D_49c1_2D_a979_2D_24c41198111b._base_nodes);
                              }
                              else
                              {
                                 _loc7_ = li32(sample.MEncrypt__3A__5C_Crossbridge_5C_cygwin_5C_tmp_5C_cc3cftGb_2E_lto_2E_bc_3A_6272de50_2D_9bd4_2D_49c1_2D_a979_2D_24c41198111b._base_next_addr);
                                 var _temp_15:* = int(_loc7_ + 64);
                                 _loc4_ = li32(sample.MEncrypt__3A__5C_Crossbridge_5C_cygwin_5C_tmp_5C_cc3cftGb_2E_lto_2E_bc_3A_6272de50_2D_9bd4_2D_49c1_2D_a979_2D_24c41198111b._base_past_addr);
                                 if(uint(_temp_15) > uint(_loc4_))
                                 {
                                    _loc2_ -= 16;
                                    si32(64,_loc2_);
                                    ESP = _loc2_;
                                    F_base_pages_alloc();
                                    _loc2_ += 16;
                                    if(sample.MEncrypt.eax != 0)
                                    {
                                       break;
                                    }
                                    _loc7_ = li32(sample.MEncrypt__3A__5C_Crossbridge_5C_cygwin_5C_tmp_5C_cc3cftGb_2E_lto_2E_bc_3A_6272de50_2D_9bd4_2D_49c1_2D_a979_2D_24c41198111b._base_next_addr);
                                 }
                                 _loc3_ = _loc7_ + 64;
                                 si32(_loc3_,sample.MEncrypt__3A__5C_Crossbridge_5C_cygwin_5C_tmp_5C_cc3cftGb_2E_lto_2E_bc_3A_6272de50_2D_9bd4_2D_49c1_2D_a979_2D_24c41198111b._base_next_addr);
                                 if(_loc7_ == 0)
                                 {
                                    break;
                                 }
                              }
                              _loc2_ -= 16;
                              si32(1,_loc2_ + 4);
                              si32(_loc5_,_loc2_);
                              ESP = _loc2_;
                              F_chunk_alloc();
                              _loc2_ += 16;
                              _loc8_ = sample.MEncrypt.eax;
                              if(_loc8_ == 0)
                              {
                                 si32(li32(sample.MEncrypt__3A__5C_Crossbridge_5C_cygwin_5C_tmp_5C_cc3cftGb_2E_lto_2E_bc_3A_6272de50_2D_9bd4_2D_49c1_2D_a979_2D_24c41198111b._base_nodes),_loc7_);
                                 si32(_loc7_,sample.MEncrypt__3A__5C_Crossbridge_5C_cygwin_5C_tmp_5C_cc3cftGb_2E_lto_2E_bc_3A_6272de50_2D_9bd4_2D_49c1_2D_a979_2D_24c41198111b._base_nodes);
                                 break;
                              }
                              si32(_loc8_,_loc7_ + 16);
                              si32(_loc5_,_loc7_ + 20);
                              _loc2_ -= 16;
                              si32(_loc7_,_loc2_ + 4);
                              si32(sample.MEncrypt__3A__5C_Crossbridge_5C_cygwin_5C_tmp_5C_cc3cftGb_2E_lto_2E_bc_3A_6272de50_2D_9bd4_2D_49c1_2D_a979_2D_24c41198111b._huge,_loc2_);
                              ESP = _loc2_;
                              F_extent_tree_ad_insert();
                              _loc2_ += 16;
                              break loop12;
                           }
                           break;
                        }
                        var _temp_20:* = li32(li32(sample.MEncrypt__3A__5C_Crossbridge_5C_cygwin_5C_tmp_5C_cc3cftGb_2E_lto_2E_bc_3A_6272de50_2D_9bd4_2D_49c1_2D_a979_2D_24c41198111b._arenas));
                        _loc2_ -= 16;
                        si32(1,_loc2_ + 8);
                        si32(_loc5_,_loc2_ + 4);
                        si32(_temp_20,_loc2_);
                        ESP = _loc2_;
                        F_arena_malloc();
                        _loc2_ += 16;
                        _loc8_ = sample.MEncrypt.eax;
                        if(_loc8_ == 0)
                        {
                           break;
                        }
                        break loop12;
                     }
                  }
                  _loc3_ = li8(sample.MEncrypt__3A__5C_Crossbridge_5C_cygwin_5C_tmp_5C_cc3cftGb_2E_lto_2E_bc_3A_6272de50_2D_9bd4_2D_49c1_2D_a979_2D_24c41198111b._opt_xmalloc_2E_b);
                  if(_loc3_ == 1)
                  {
                     _loc6_ = li32(sample.MEncrypt__3A__5C_Crossbridge_5C_cygwin_5C_tmp_5C_cc3cftGb_2E_lto_2E_bc_3A_6272de50_2D_9bd4_2D_49c1_2D_a979_2D_24c41198111b.___progname);
                     _loc8_ = _loc6_ & -4;
                     _loc4_ = li32(_loc8_);
                     var _temp_28:* = int(_loc4_ + -16843009);
                     if(((_loc4_ = (_loc4_ &= -2139062144) ^ -2139062144) & _temp_28) != 0)
                     {
                        _loc5_ = _loc8_ + 4;
                        _loc9_ = 0;
                        while(true)
                        {
                           _loc7_ = _loc6_ + _loc9_;
                           if((uint(_loc7_)) >= uint(_loc5_))
                           {
                              addr0409:
                              _loc5_ = _loc8_ + 4;
                              while(true)
                              {
                                 _loc8_ = li32(_loc5_);
                                 _loc3_ = _loc8_ + -16843009;
                                 _loc4_ = _loc8_ & -2139062144;
                                 _loc4_ = _loc4_ ^ -2139062144;
                                 _loc3_ = _loc4_ & _loc3_;
                                 if(_loc3_ != 0)
                                 {
                                    if((_loc8_ & 0xFF) == 0)
                                    {
                                       _loc9_ = _loc5_ - _loc6_;
                                       break;
                                    }
                                    if(li8(_loc5_ + 1) == 0)
                                    {
                                       _loc9_ = int(1 - _loc6_) + _loc5_;
                                       break;
                                    }
                                    if(li8(_loc5_ + 2) == 0)
                                    {
                                       _loc9_ = int(2 - _loc6_) + _loc5_;
                                       break;
                                    }
                                    if(li8(_loc5_ + 3) == 0)
                                    {
                                       _loc9_ = int(3 - _loc6_) + _loc5_;
                                       break;
                                    }
                                 }
                                 _loc5_ += 4;
                              }
                           }
                           else if(li8(_loc7_) != 0)
                           {
                              continue;
                           }
                           _loc2_ -= 16;
                           si32(_loc9_,_loc2_ + 8);
                           si32(_loc6_,_loc2_ + 4);
                           si32(2,_loc2_);
                           ESP = _loc2_;
                           F___sys_write();
                           _loc2_ += 16;
                           _loc5_ = sample.MEncrypt__3A__5C_Crossbridge_5C_cygwin_5C_tmp_5C_cc3cftGb_2E_lto_2E_bc_3A_6272de50_2D_9bd4_2D_49c1_2D_a979_2D_24c41198111b.L__2E_str46 & -4;
                           _loc4_ = li32(_loc5_);
                           _loc3_ = _loc4_ + -16843009;
                           _loc4_ &= -2139062144;
                           _loc4_ = _loc4_ ^ -2139062144;
                           _loc3_ = _loc4_ & _loc3_;
                           _loc8_ = _loc5_ + 4;
                           _loc6_ = 0;
                           if(_loc3_ != 0)
                           {
                              while(true)
                              {
                                 _loc3_ = sample.MEncrypt__3A__5C_Crossbridge_5C_cygwin_5C_tmp_5C_cc3cftGb_2E_lto_2E_bc_3A_6272de50_2D_9bd4_2D_49c1_2D_a979_2D_24c41198111b.L__2E_str46 + _loc6_;
                                 _loc8_ = _loc5_ + 4;
                                 if(uint(_loc3_) >= uint(_loc8_))
                                 {
                                    while(true)
                                    {
                                       _loc6_ = li32(_loc8_);
                                       _loc3_ = _loc6_ + -16843009;
                                       _loc4_ = _loc6_ & -2139062144;
                                       _loc4_ = _loc4_ ^ -2139062144;
                                       _loc3_ = _loc4_ & _loc3_;
                                       if(_loc3_ != 0)
                                       {
                                          if((_loc6_ & 0xFF) == 0)
                                          {
                                             _loc8_ -= sample.MEncrypt__3A__5C_Crossbridge_5C_cygwin_5C_tmp_5C_cc3cftGb_2E_lto_2E_bc_3A_6272de50_2D_9bd4_2D_49c1_2D_a979_2D_24c41198111b.L__2E_str46;
                                             break;
                                          }
                                          if(li8(_loc8_ + 1) == 0)
                                          {
                                             var _temp_68:* = int(1 - sample.MEncrypt__3A__5C_Crossbridge_5C_cygwin_5C_tmp_5C_cc3cftGb_2E_lto_2E_bc_3A_6272de50_2D_9bd4_2D_49c1_2D_a979_2D_24c41198111b.L__2E_str46);
                                             _loc8_ += _temp_68;
                                             break;
                                          }
                                          if(li8(_loc8_ + 2) == 0)
                                          {
                                             var _temp_69:* = int(2 - sample.MEncrypt__3A__5C_Crossbridge_5C_cygwin_5C_tmp_5C_cc3cftGb_2E_lto_2E_bc_3A_6272de50_2D_9bd4_2D_49c1_2D_a979_2D_24c41198111b.L__2E_str46);
                                             _loc8_ += _temp_69;
                                             break;
                                          }
                                          if(li8(_loc8_ + 3) == 0)
                                          {
                                             var _temp_70:* = int(3 - sample.MEncrypt__3A__5C_Crossbridge_5C_cygwin_5C_tmp_5C_cc3cftGb_2E_lto_2E_bc_3A_6272de50_2D_9bd4_2D_49c1_2D_a979_2D_24c41198111b.L__2E_str46);
                                             _loc8_ += _temp_70;
                                             break;
                                          }
                                       }
                                       _loc8_ += 4;
                                    }
                                    addr0594:
                                 }
                                 else
                                 {
                                    _loc8_ = _loc5_ + 4;
                                    _loc7_ = sample.MEncrypt__3A__5C_Crossbridge_5C_cygwin_5C_tmp_5C_cc3cftGb_2E_lto_2E_bc_3A_6272de50_2D_9bd4_2D_49c1_2D_a979_2D_24c41198111b.L__2E_str46;
                                    if(uint(sample.MEncrypt__3A__5C_Crossbridge_5C_cygwin_5C_tmp_5C_cc3cftGb_2E_lto_2E_bc_3A_6272de50_2D_9bd4_2D_49c1_2D_a979_2D_24c41198111b.L__2E_str46) <= uint(_loc8_))
                                    {
                                       _loc7_ = _loc8_;
                                    }
                                    _loc3_ = _loc7_ ^ -1;
                                    _loc8_ = sample.MEncrypt__3A__5C_Crossbridge_5C_cygwin_5C_tmp_5C_cc3cftGb_2E_lto_2E_bc_3A_6272de50_2D_9bd4_2D_49c1_2D_a979_2D_24c41198111b.L__2E_str46 + _loc3_;
                                    if((uint(_loc8_)) <= 4294967251)
                                    {
                                       _loc8_ = -45;
                                    }
                                    _loc8_ ^= -1;
                                    _loc6_ += 1;
                                    if(_loc6_ != 45)
                                    {
                                       continue;
                                    }
                                 }
                                 _loc2_ -= 16;
                                 si32(_loc8_,_loc2_ + 8);
                                 si32(sample.MEncrypt__3A__5C_Crossbridge_5C_cygwin_5C_tmp_5C_cc3cftGb_2E_lto_2E_bc_3A_6272de50_2D_9bd4_2D_49c1_2D_a979_2D_24c41198111b.L__2E_str46,_loc2_ + 4);
                                 si32(2,_loc2_);
                                 ESP = _loc2_;
                                 F___sys_write();
                                 _loc2_ += 16;
                                 _loc5_ = sample.MEncrypt__3A__5C_Crossbridge_5C_cygwin_5C_tmp_5C_cc3cftGb_2E_lto_2E_bc_3A_6272de50_2D_9bd4_2D_49c1_2D_a979_2D_24c41198111b.L__2E_str242 & -4;
                                 _loc4_ = li32(_loc5_);
                                 _loc3_ = _loc4_ + -16843009;
                                 _loc4_ &= -2139062144;
                                 _loc4_ = _loc4_ ^ -2139062144;
                                 _loc3_ = _loc4_ & _loc3_;
                                 _loc8_ = _loc5_ + 4;
                                 _loc6_ = 0;
                                 loop16:
                                 while(true)
                                 {
                                    if(_loc3_ != 0)
                                    {
                                       var _temp_78:* = int(_loc5_ + 4);
                                       _loc7_ = _loc6_;
                                       if(uint(sample.MEncrypt__3A__5C_Crossbridge_5C_cygwin_5C_tmp_5C_cc3cftGb_2E_lto_2E_bc_3A_6272de50_2D_9bd4_2D_49c1_2D_a979_2D_24c41198111b.L__2E_str242) < uint(_temp_78))
                                       {
                                          break;
                                       }
                                    }
                                    while(true)
                                    {
                                       _loc7_ = li32(_loc8_);
                                       _loc3_ = _loc7_ + -16843009;
                                       _loc4_ = _loc7_ & -2139062144;
                                       _loc4_ = _loc4_ ^ -2139062144;
                                       _loc3_ = _loc4_ & _loc3_;
                                       if(_loc3_ != 0)
                                       {
                                          if((_loc7_ & 0xFF) == 0)
                                          {
                                             _loc7_ = _loc8_ - sample.MEncrypt__3A__5C_Crossbridge_5C_cygwin_5C_tmp_5C_cc3cftGb_2E_lto_2E_bc_3A_6272de50_2D_9bd4_2D_49c1_2D_a979_2D_24c41198111b.L__2E_str242;
                                             break loop16;
                                          }
                                          if(li8(_loc8_ + 1) == 0)
                                          {
                                             var _temp_82:* = int(1 - sample.MEncrypt__3A__5C_Crossbridge_5C_cygwin_5C_tmp_5C_cc3cftGb_2E_lto_2E_bc_3A_6272de50_2D_9bd4_2D_49c1_2D_a979_2D_24c41198111b.L__2E_str242);
                                             _loc7_ = _loc8_ + _temp_82;
                                             break loop16;
                                          }
                                          if(li8(_loc8_ + 2) == 0)
                                          {
                                             var _temp_83:* = int(2 - sample.MEncrypt__3A__5C_Crossbridge_5C_cygwin_5C_tmp_5C_cc3cftGb_2E_lto_2E_bc_3A_6272de50_2D_9bd4_2D_49c1_2D_a979_2D_24c41198111b.L__2E_str242);
                                             _loc7_ = _loc8_ + _temp_83;
                                             break loop16;
                                          }
                                          if(li8(_loc8_ + 3) == 0)
                                          {
                                             var _temp_84:* = int(3 - sample.MEncrypt__3A__5C_Crossbridge_5C_cygwin_5C_tmp_5C_cc3cftGb_2E_lto_2E_bc_3A_6272de50_2D_9bd4_2D_49c1_2D_a979_2D_24c41198111b.L__2E_str242);
                                             _loc7_ = _loc8_ + _temp_84;
                                             break loop16;
                                          }
                                       }
                                       _loc8_ += 4;
                                    }
                                    break;
                                 }
                                 _loc2_ -= 16;
                                 si32(_loc7_,_loc2_ + 8);
                                 si32(2,_loc2_);
                                 si32(sample.MEncrypt__3A__5C_Crossbridge_5C_cygwin_5C_tmp_5C_cc3cftGb_2E_lto_2E_bc_3A_6272de50_2D_9bd4_2D_49c1_2D_a979_2D_24c41198111b.L__2E_str242,_loc2_ + 4);
                                 ESP = _loc2_;
                                 F___sys_write();
                                 _loc2_ += 16;
                                 _loc4_ = li32(_loc5_);
                                 _loc3_ = _loc4_ + -16843009;
                                 _loc4_ &= -2139062144;
                                 _loc4_ = _loc4_ ^ -2139062144;
                                 _loc3_ = _loc4_ & _loc3_;
                                 _loc8_ = _loc5_ + 4;
                                 loop17:
                                 while(true)
                                 {
                                    if(_loc3_ != 0)
                                    {
                                       var _temp_89:* = int(_loc5_ + 4);
                                       if(uint(sample.MEncrypt__3A__5C_Crossbridge_5C_cygwin_5C_tmp_5C_cc3cftGb_2E_lto_2E_bc_3A_6272de50_2D_9bd4_2D_49c1_2D_a979_2D_24c41198111b.L__2E_str242) < uint(_temp_89))
                                       {
                                          break;
                                       }
                                    }
                                    while(true)
                                    {
                                       _loc6_ = li32(_loc8_);
                                       _loc3_ = _loc6_ + -16843009;
                                       _loc4_ = _loc6_ & -2139062144;
                                       _loc4_ = _loc4_ ^ -2139062144;
                                       _loc3_ = _loc4_ & _loc3_;
                                       if(_loc3_ != 0)
                                       {
                                          if((_loc6_ & 0xFF) == 0)
                                          {
                                             _loc6_ = _loc8_ - sample.MEncrypt__3A__5C_Crossbridge_5C_cygwin_5C_tmp_5C_cc3cftGb_2E_lto_2E_bc_3A_6272de50_2D_9bd4_2D_49c1_2D_a979_2D_24c41198111b.L__2E_str242;
                                             break loop17;
                                          }
                                          if(li8(_loc8_ + 1) == 0)
                                          {
                                             var _temp_93:* = int(1 - sample.MEncrypt__3A__5C_Crossbridge_5C_cygwin_5C_tmp_5C_cc3cftGb_2E_lto_2E_bc_3A_6272de50_2D_9bd4_2D_49c1_2D_a979_2D_24c41198111b.L__2E_str242);
                                             _loc6_ = _loc8_ + _temp_93;
                                             break loop17;
                                          }
                                          if(li8(_loc8_ + 2) == 0)
                                          {
                                             var _temp_94:* = int(2 - sample.MEncrypt__3A__5C_Crossbridge_5C_cygwin_5C_tmp_5C_cc3cftGb_2E_lto_2E_bc_3A_6272de50_2D_9bd4_2D_49c1_2D_a979_2D_24c41198111b.L__2E_str242);
                                             _loc6_ = _loc8_ + _temp_94;
                                             break loop17;
                                          }
                                          if(li8(_loc8_ + 3) == 0)
                                          {
                                             var _temp_95:* = int(3 - sample.MEncrypt__3A__5C_Crossbridge_5C_cygwin_5C_tmp_5C_cc3cftGb_2E_lto_2E_bc_3A_6272de50_2D_9bd4_2D_49c1_2D_a979_2D_24c41198111b.L__2E_str242);
                                             _loc6_ = _loc8_ + _temp_95;
                                             break loop17;
                                          }
                                       }
                                       _loc8_ += 4;
                                    }
                                    break;
                                 }
                                 _loc2_ -= 16;
                                 si32(_loc6_,_loc2_ + 8);
                                 si32(sample.MEncrypt__3A__5C_Crossbridge_5C_cygwin_5C_tmp_5C_cc3cftGb_2E_lto_2E_bc_3A_6272de50_2D_9bd4_2D_49c1_2D_a979_2D_24c41198111b.L__2E_str242,_loc2_ + 4);
                                 si32(2,_loc2_);
                                 ESP = _loc2_;
                                 F___sys_write();
                                 _loc2_ += 16;
                                 ESP = _loc2_;
                                 F_abort();
                                 addr08dc:
                                 si32(12,sample.MEncrypt__3A__5C_Crossbridge_5C_cygwin_5C_tmp_5C_cc3cftGb_2E_lto_2E_bc_3A_6272de50_2D_9bd4_2D_49c1_2D_a979_2D_24c41198111b._errno);
                                 _loc8_ = 0;
                                 break loop12;
                              }
                           }
                           §§goto(addr0594);
                           _loc9_ += 1;
                        }
                     }
                     §§goto(addr0409);
                  }
                  §§goto(addr08dc);
               }
               _loc2_ -= 16;
               si32(12,_loc2_);
               _loc3_ = _loc8_ + _loc6_;
               ESP = _loc2_;
               F_malloc();
               _loc2_ += 16;
               var _loc10_:int = sample.MEncrypt.eax;
               si32(_loc3_,_loc3_);
               si32(_loc10_,_loc3_ + 4);
               si32(1,_loc10_);
               si32(1,_loc10_ + 4);
               _loc4_ = li32(sample.MEncrypt__3A__5C_Crossbridge_5C_cygwin_5C_tmp_5C_cc3cftGb_2E_lto_2E_bc_3A_6272de50_2D_9bd4_2D_49c1_2D_a979_2D_24c41198111b._tls_static_space);
               _loc4_ = _loc3_ - _loc4_;
               si32(_loc4_,_loc10_ + 8);
               _loc10_ = li32(sample.MEncrypt__3A__5C_Crossbridge_5C_cygwin_5C_tmp_5C_cc3cftGb_2E_lto_2E_bc_3A_6272de50_2D_9bd4_2D_49c1_2D_a979_2D_24c41198111b._tls_init);
               var _loc11_:int = li32(sample.MEncrypt__3A__5C_Crossbridge_5C_cygwin_5C_tmp_5C_cc3cftGb_2E_lto_2E_bc_3A_6272de50_2D_9bd4_2D_49c1_2D_a979_2D_24c41198111b._tls_init_size);
               _loc2_ -= 16;
               si32(_loc11_,_loc2_ + 8);
               si32(_loc10_,_loc2_ + 4);
               si32(_loc4_,_loc2_);
               ESP = _loc2_;
               Fmemcpy();
               _loc2_ += 16;
               _loc4_ = li32(sample.MEncrypt__3A__5C_Crossbridge_5C_cygwin_5C_tmp_5C_cc3cftGb_2E_lto_2E_bc_3A_6272de50_2D_9bd4_2D_49c1_2D_a979_2D_24c41198111b._tls_init_size);
               _loc10_ = li32(sample.MEncrypt__3A__5C_Crossbridge_5C_cygwin_5C_tmp_5C_cc3cftGb_2E_lto_2E_bc_3A_6272de50_2D_9bd4_2D_49c1_2D_a979_2D_24c41198111b._tls_static_space);
               _loc11_ = _loc10_ - _loc4_;
               _loc2_ -= 16;
               si32(_loc11_,_loc2_ + 8);
               si32(0,_loc2_ + 4);
               _loc3_ -= _loc10_;
               _loc3_ += _loc4_;
               si32(_loc3_,_loc2_);
               ESP = _loc2_;
               Fmemset();
               _loc2_ += 16;
               ESP = _loc2_;
               F_abort();
            }
         }
      }
      _loc6_ = li32(sample.MEncrypt__3A__5C_Crossbridge_5C_cygwin_5C_tmp_5C_cc3cftGb_2E_lto_2E_bc_3A_6272de50_2D_9bd4_2D_49c1_2D_a979_2D_24c41198111b.___atexit);
      if(_loc6_ == 0)
      {
         _loc6_ = sample.MEncrypt__3A__5C_Crossbridge_5C_cygwin_5C_tmp_5C_cc3cftGb_2E_lto_2E_bc_3A_6272de50_2D_9bd4_2D_49c1_2D_a979_2D_24c41198111b.___atexit0_2E_2738;
         si32(_loc6_,sample.MEncrypt__3A__5C_Crossbridge_5C_cygwin_5C_tmp_5C_cc3cftGb_2E_lto_2E_bc_3A_6272de50_2D_9bd4_2D_49c1_2D_a979_2D_24c41198111b.___atexit);
         _loc5_ = li32(sample.MEncrypt__3A__5C_Crossbridge_5C_cygwin_5C_tmp_5C_cc3cftGb_2E_lto_2E_bc_3A_6272de50_2D_9bd4_2D_49c1_2D_a979_2D_24c41198111b.___atexit0_2E_2738 + 4);
      }
      else
      {
         while(true)
         {
            _loc5_ = li32(_loc6_ + 4);
            if(_loc5_ <= 31)
            {
               addr0a95:
               _loc3_ = _loc5_ << 4;
               _loc3_ = _loc6_ + _loc3_;
               si32(1,_loc3_ + 8);
               si32(sample.MEncrypt__3A__5C_Crossbridge_5C_cygwin_5C_tmp_5C_cc3cftGb_2E_lto_2E_bc_3A_6272de50_2D_9bd4_2D_49c1_2D_a979_2D_24c41198111b.__fini,_loc3_ + 12);
               si32(0,_loc3_ + 16);
               si32(0,_loc3_ + 20);
               _loc3_ = _loc5_ + 1;
               si32(_loc3_,_loc6_ + 4);
            }
            else
            {
               _loc2_ -= 16;
               si32(520,_loc2_);
               ESP = _loc2_;
               F_malloc();
               _loc2_ += 16;
               _loc8_ = sample.MEncrypt.eax;
               if(_loc8_ != 0)
               {
                  _loc5_ = li32(sample.MEncrypt__3A__5C_Crossbridge_5C_cygwin_5C_tmp_5C_cc3cftGb_2E_lto_2E_bc_3A_6272de50_2D_9bd4_2D_49c1_2D_a979_2D_24c41198111b.___atexit);
                  if(_loc6_ != _loc5_)
                  {
                     _loc2_ -= 16;
                     si32(_loc8_,_loc2_);
                     ESP = _loc2_;
                     F_idalloc();
                     _loc2_ += 16;
                     _loc6_ = li32(sample.MEncrypt__3A__5C_Crossbridge_5C_cygwin_5C_tmp_5C_cc3cftGb_2E_lto_2E_bc_3A_6272de50_2D_9bd4_2D_49c1_2D_a979_2D_24c41198111b.___atexit);
                  }
                  else
                  {
                     si32(0,_loc8_