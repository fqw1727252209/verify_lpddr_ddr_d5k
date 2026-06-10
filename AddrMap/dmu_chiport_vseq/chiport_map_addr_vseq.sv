class chiport_strip_addr_vseq extends chiport_base_vseq;
  `uvm_object_utils(chiport_strip_addr_vseq)
  `uvm_declare_p_sequencer(my_vsqr)

  writeNoSnpPtlSeq    wr_nosnp_ptl_seq;
  writeNoSnpFullSeq   wr_nosnp_full_seq;
  readNoSnpSeq        rd_nosnp_seq;

  apb_chiport_strip_addr_seq    strip_addr_apb_seq;
  chi_wrrd_map_seq              wrrd_map_chi_seq;

  bit [255:0]         in_data;
  int                 in_cnt = 10;
  rand bit [38:0]     data;
  rand bit [`TB_ADDR_WIDTH-1:0] addr_gen;
  rand bit [`TB_ADDR_WIDTH-1:0] step_gen;
  bit      [`TB_ADDR_WIDTH-1:0] strip_data[40];

  task automatic run_strip_addr_task(
    int ch_i = 0,
    bit [`TB_ADDR_WIDTH-1:0] base_addr = `DMU_NOC_BASE_ADDR,
    int i = 0
  );
    for (int j = 0; j < in_cnt; j++) begin
      if (i < 15) begin
        addr_gen = base_addr + addr_2n_gen(j * `TB_ADDR_WIDTH'h40, strip_data[i]);
      end else begin
        addr_gen = base_addr + addr_3snf_gen(j * `TB_ADDR_WIDTH'h40, strip_data[i]);
      end
      $display("Send ADDR is %h", addr_gen);
      `uvm_do_on_with(wr_nosnp_full_seq, p_sequencer.chi_vsqr.Down_seqr_ch_[ch_i], {
                      wr_nosnp_full_seq.NonSecure        == 0;
                      wr_nosnp_full_seq.CancelOnRetryAck == 1;
                      wr_nosnp_full_seq.Addr             == addr_gen;
                      wr_nosnp_full_seq.rand_dly_mode    == 0;
      })
    end
    vsqr_chireq_finish(ch_i);

    for (int j = 0; j < in_cnt; j++) begin
      if (i < 15) begin
        addr_gen = base_addr + addr_2n_gen(j * `TB_ADDR_WIDTH'h40, strip_data[i]);
      end else begin
        addr_gen = base_addr + addr_3snf_gen(j * `TB_ADDR_WIDTH'h40, strip_data[i]);
      end
      $display("Send ADDR is %h", addr_gen);
      `uvm_do_on_with(rd_nosnp_seq, p_sequencer.chi_vsqr.Down_seqr_ch_[ch_i], {
                      rd_nosnp_seq.NonSecure        == 0;
                      rd_nosnp_seq.CancelOnRetryAck == 1;
                      rd_nosnp_seq.Addr             == addr_gen;
      })
    end
    vsqr_chireq_finish(ch_i);
  endtask

  //constraint data_c {data inside {'h0000_0180,'h0000_0100,'h0000_0080};}
  virtual task body();
    if (starting_phase) starting_phase.raise_objection(this);

    //bit[5:0] not strip
    `uvm_info(get_full_name(), "Start strip_addr_apb_seq...", UVM_LOW)
    //2^N
    strip_data[0]  = `TB_ADDR_WIDTH'h40;  //bit6
    strip_data[1]  = `TB_ADDR_WIDTH'h80;  //bit7
    strip_data[2]  = `TB_ADDR_WIDTH'hc0;  //bit7,6
    strip_data[3]  = `TB_ADDR_WIDTH'h100; //bit8
    strip_data[4]  = `TB_ADDR_WIDTH'h180; //bit8,7
    strip_data[5]  = `TB_ADDR_WIDTH'h1c0; //bit8,7,6
    strip_data[6]  = `TB_ADDR_WIDTH'h200; //bit9
    strip_data[7]  = `TB_ADDR_WIDTH'h300; //bit9,8
    strip_data[8]  = `TB_ADDR_WIDTH'h380; //bit9,8,7
    strip_data[9]  = `TB_ADDR_WIDTH'h3c0; //bit9,8,7,6
    strip_data[10] = `TB_ADDR_WIDTH'h400; //bit10
    strip_data[11] = `TB_ADDR_WIDTH'h600; //bit10,9
    strip_data[12] = `TB_ADDR_WIDTH'h700; //bit10,9,8
    strip_data[13] = `TB_ADDR_WIDTH'h780; //bit10,9,8,7
    strip_data[14] = `TB_ADDR_WIDTH'h7c0; //bit10,9,8,7,6
    strip_data[15] = `TB_ADDR_WIDTH'hfc0; //bit11,10,9,8,7,6
    strip_data[16] = `TB_ADDR_WIDTH'h1fc0; //bit12,11,10,9,8,7,6
    strip_data[17] = `TB_ADDR_WIDTH'h7c0; //bit10,9,8,7,6

    //3SNF
    strip_data[18] = `TB_ADDR_WIDTH'h3_0000_0400;   //18v6, nps1, 1G per DMU: bit33,32,10
    strip_data[19] = `TB_ADDR_WIDTH'h0_c000_0400;   //18v6, nps4, 1G per DMU: bit31,30,10
    strip_data[20] = `TB_ADDR_WIDTH'h400_0000_0400; //64v24, nps2, 1T per DMU: bit42,10
    strip_data[21] = `TB_ADDR_WIDTH'h600_0000_0400; //64v24, nps2, 512G per DMU: bit42,41,10
    strip_data[22] = `TB_ADDR_WIDTH'h2000_0600;     //bit29,10,9
    strip_data[23] = `TB_ADDR_WIDTH'h2000_0600;     //bit29,10,9
    strip_data[24] = `TB_ADDR_WIDTH'h4000_0600;     //bit30,10,9
    strip_data[25] = `TB_ADDR_WIDTH'h8000_0600;     //bit31,10,9
    strip_data[26] = `TB_ADDR_WIDTH'h1_0000_0600;   //bit32,10,9
    strip_data[27] = `TB_ADDR_WIDTH'h2_0000_0600;   //bit33,10,9
    strip_data[28] = `TB_ADDR_WIDTH'h4_0000_0600;   //bit34,10,9
    strip_data[29] = `TB_ADDR_WIDTH'h8_0000_0600;   //bit35,10,9
    strip_data[30] = `TB_ADDR_WIDTH'h10_0000_0600;  //bit36,10,9
    strip_data[31] = `TB_ADDR_WIDTH'h20_0000_0600;  //bit37,10,9
    strip_data[32] = `TB_ADDR_WIDTH'h40_0000_0600;  //bit38,10,9
    strip_data[33] = `TB_ADDR_WIDTH'h80_0000_0600;  //bit39,10,9
    strip_data[34] = `TB_ADDR_WIDTH'h100_0000_0600; //bit40,10,9
    strip_data[35] = `TB_ADDR_WIDTH'h200_0000_0600; //bit41,10,9
    strip_data[36] = `TB_ADDR_WIDTH'h400_0000_0600; //bit42,10,9
    strip_data[37] = `TB_ADDR_WIDTH'h100_0000_0600; //bit40,10,9
    strip_data[38] = `TB_ADDR_WIDTH'h200_0000_0600; //bit41,10,9
    strip_data[39] = `TB_ADDR_WIDTH'h400_0000_0600; //bit42,10,9

    for (int i = 0; i < 40; i++) begin
      `uvm_info(get_full_name(), "Start strip_addr_apb_seq...", UVM_LOW)
      `uvm_do_on_with(strip_addr_apb_seq, p_sequencer.apb_sqr_[0], {
                      strip_addr_apb_seq.wrdata == strip_data[i];
      })

      // addr_gen = addr_strip_2n_gen(, strip_data[i]);
      // step_gen = addr_2n_gen(`TB_ADDR_WIDTH'h40, strip_data[i]);

      fork
        begin
          run_strip_addr_task(0, `DMU_NOC_BASE_ADDR + `TB_ADDR_WIDTH'h5555_5555, i);
        end

        begin
          `ifdef MEM_ATTACHED_ddr5sdram
          run_strip_addr_task(1, `DMU_NOC_BASE_ADDR + `TB_ADDR_WIDTH'h5555_5555, i);
          `endif
        end

        begin
          run_strip_addr_task(2, `DMU_NCC_BASE_ADDR, i);
        end

        begin
          `ifdef MEM_ATTACHED_ddr5sdram
          run_strip_addr_task(3, `DMU_NCC_BASE_ADDR, i);
          `endif
        end
      join
      
      vsqr_chireq_finish(4);
    end
    repeat(20000) @(tb.clk_noc);

    if (starting_phase) starting_phase.drop_objection(this);
  endtask

  function bit[`TB_ADDR_WIDTH-1:0] addr_2n_gen(bit[`TB_ADDR_WIDTH-1:0] step, bit[`TB_ADDR_WIDTH-1:0] strip_bits);
    int ptr;
    ptr = 0;
    for (int i = 0; i < `TB_ADDR_WIDTH; i++) begin
      if (strip_bits[i] != 1) begin
        addr_2n_gen[i] = step[ptr];
        ptr++;
      end else begin
        addr_2n_gen[i] = 0;
      end
    end
  endfunction

  function bit[`TB_ADDR_WIDTH-1:0] addr_3snf_gen(bit[`TB_ADDR_WIDTH-1:0] step, bit[`TB_ADDR_WIDTH-1:0] strip_bits);
    int ptr;
    ptr = 0;
    for (int i = 0; i < `TB_ADDR_WIDTH; i++) begin
      if ((strip_bits[i] != 1)) begin
        addr_3snf_gen[i] = step[ptr];
        ptr++;
      end else begin
        addr_3snf_gen[i] = 0;
      end
    end

    if (({addr_3snf_gen[10:8], addr_3snf_gen[13:11], addr_3snf_gen[16:14]} % 3) != 0) begin
      {addr_3snf_gen[10:8], addr_3snf_gen[13:11], addr_3snf_gen[16:14]} =
      {addr_3snf_gen[10:8], addr_3snf_gen[13:11], addr_3snf_gen[16:14]} -
      {addr_3snf_gen[10:8], addr_3snf_gen[13:11], addr_3snf_gen[16:14]} % 3;
    end
  endfunction
endclass

class chiport_strip_rand_vseq extends chiport_base_vseq;
  `uvm_object_utils(chiport_strip_rand_vseq)
  `uvm_declare_p_sequencer(my_vsqr)

  writeNoSnpPtlSeq    wr_nosnp_ptl_seq;
  writeNoSnpFullSeq   wr_nosnp_full_seq;
  readNoSnpSeq        rd_nosnp_seq;

  apb_chiport_strip_addr_seq    strip_addr_apb_seq;
  chi_wrrd_map_seq              wrrd_map_chi_seq;

  bit [255:0]         in_data;
  int                 in_cnt = 100;
  rand bit [38:0]     data;
  rand bit [`TB_ADDR_WIDTH-1:0] clp0_addr_gen;
  rand bit [`TB_ADDR_WIDTH-1:0] clp1_addr_gen;
  bit      [`TB_ADDR_WIDTH-1:0] strip_data[40];
  bit      [`TB_ADDR_WIDTH-1:0] clp0_wr_addr_q[$];
  bit      [`TB_ADDR_WIDTH-1:0] clp0_rd_addr_q[$];
  bit      [`TB_ADDR_WIDTH-1:0] clp1_wr_addr_q[$];
  bit      [`TB_ADDR_WIDTH-1:0] clp1_rd_addr_q[$];

  //constraint data_c {data inside {'h0000_0180,'h0000_0100,'h0000_0080};}
  virtual task body();
    if(starting_phase) starting_phase.raise_objection(this);
    `uvm_info(get_full_name(), "Start strip_addr_apb_seq...", UVM_LOW)
    //2^N
    strip_data[0]  = `TB_ADDR_WIDTH'h40;  //bit6
    strip_data[1]  = `TB_ADDR_WIDTH'h80;  //bit7
    strip_data[2]  = `TB_ADDR_WIDTH'hc0;  //bit7,6
    strip_data[3]  = `TB_ADDR_WIDTH'h100; //bit8
    strip_data[4]  = `TB_ADDR_WIDTH'h180; //bit8,7
    strip_data[5]  = `TB_ADDR_WIDTH'h1c0; //bit8,7,6
    strip_data[6]  = `TB_ADDR_WIDTH'h200; //bit9
    strip_data[7]  = `TB_ADDR_WIDTH'h300; //bit9,8
    strip_data[8]  = `TB_ADDR_WIDTH'h380; //bit9,8,7
    strip_data[9]  = `TB_ADDR_WIDTH'h3c0; //bit9,8,7,6
    strip_data[10] = `TB_ADDR_WIDTH'h400; //bit10
    strip_data[11] = `TB_ADDR_WIDTH'h600; //bit10,9
    strip_data[12] = `TB_ADDR_WIDTH'h700; //bit10,9,8
    strip_data[13] = `TB_ADDR_WIDTH'h780; //bit10,9,8,7
    strip_data[14] = `TB_ADDR_WIDTH'h7c0; //bit10,9,8,7,6
    strip_data[15] = `TB_ADDR_WIDTH'hfc0; //bit11,10,9,8,7,6
    strip_data[16] = `TB_ADDR_WIDTH'h1fc0; //bit12,11,10,9,8,7,6
    strip_data[17] = `TB_ADDR_WIDTH'h7c0; //bit10,9,8,7,6
    //3SNF
    strip_data[18] = `TB_ADDR_WIDTH'h3_0000_0600;   //bit33,32,10,9
    strip_data[19] = `TB_ADDR_WIDTH'h3_0000_0200;   //bit33,32,9
    strip_data[20] = `TB_ADDR_WIDTH'h400_0000_0600; //bit42,10,9
    strip_data[21] = `TB_ADDR_WIDTH'h600_0000_0600; //bit42,41,10,9
    strip_data[22] = `TB_ADDR_WIDTH'h2000_0600;     //bit29,10,9
    strip_data[23] = `TB_ADDR_WIDTH'h2000_0600;     //bit29,10,9
    strip_data[24] = `TB_ADDR_WIDTH'h4000_0600;     //bit30,10,9
    strip_data[25] = `TB_ADDR_WIDTH'h8000_0600;     //bit31,10,9
    strip_data[26] = `TB_ADDR_WIDTH'h1_0000_0600;   //bit32,10,9
    strip_data[27] = `TB_ADDR_WIDTH'h2_0000_0600;   //bit33,10,9
    strip_data[28] = `TB_ADDR_WIDTH'h4_0000_0600;   //bit34,10,9
    strip_data[29] = `TB_ADDR_WIDTH'h8_0000_0600;   //bit35,10,9
    strip_data[30] = `TB_ADDR_WIDTH'h10_0000_0600;  //bit36,10,9
    strip_data[31] = `TB_ADDR_WIDTH'h20_0000_0600;  //bit37,10,9
    strip_data[32] = `TB_ADDR_WIDTH'h40_0000_0600;  //bit38,10,9
    strip_data[33] = `TB_ADDR_WIDTH'h80_0000_0600;  //bit39,10,9
    strip_data[34] = `TB_ADDR_WIDTH'h100_0000_0600; //bit40,10,9
    strip_data[35] = `TB_ADDR_WIDTH'h200_0000_0600; //bit41,10,9
    strip_data[36] = `TB_ADDR_WIDTH'h400_0000_0600; //bit42,10,9
    strip_data[37] = `TB_ADDR_WIDTH'h100_0000_0600; //bit40,10,9
    strip_data[38] = `TB_ADDR_WIDTH'h200_0000_0600; //bit41,10,9
    strip_data[39] = `TB_ADDR_WIDTH'h400_0000_0600; //bit42,10,9

    for (int i = 0; i < 40; i++) begin
      `uvm_info(get_full_name(), "Start strip_addr_apb_seq...", UVM_LOW)
      `uvm_do_on_with(strip_addr_apb_seq, p_sequencer.apb_sqr_[0], {
                      strip_addr_apb_seq.wrdata == strip_data[i];
      })

      while (clp0_wr_addr_q.size() < in_cnt) begin
        bit [`TB_ADDR_WIDTH-1:0] rand_addr_gen;
        std::randomize(rand_addr_gen);
        rand_addr_gen = `DMU_NOC_BASE_ADDR + ((rand_addr_gen % (`DMU_NOC_HIGH_ADDR - `DMU_NOC_BASE_ADDR + 1)) >> $countones(strip_data[i]));

        if (i < 15) begin
          // 2N mode: simple address generation
          rand_addr_gen = `DMU_NOC_BASE_ADDR + addr_2n_gen(rand_addr_gen - `DMU_NOC_BASE_ADDR, strip_data[i]);
        end else begin
          // 3SNF mode: 3SNF address generation
          rand_addr_gen = `DMU_NOC_BASE_ADDR + addr_3snf_gen(rand_addr_gen - `DMU_NOC_BASE_ADDR, strip_data[i]);
        end
        clp0_wr_addr_q.push_back(rand_addr_gen);
        clp0_rd_addr_q.push_back(rand_addr_gen);
      end

      while (clp1_wr_addr_q.size() < in_cnt) begin
        bit [`TB_ADDR_WIDTH-1:0] rand_addr_gen;
        std::randomize(rand_addr_gen);
        rand_addr_gen = `DMU_NCC_BASE_ADDR + ((rand_addr_gen % (`DMU_NCC_HIGH_ADDR - `DMU_NCC_BASE_ADDR + 1)) >> $countones(strip_data[i]));

        if (i < 15) begin
          // 2N mode: simple address generation
          rand_addr_gen = `DMU_NCC_BASE_ADDR + addr_2n_gen(rand_addr_gen - `DMU_NCC_BASE_ADDR, strip_data[i]);
        end else begin
          // 3SNF mode: 3SNF address generation
          rand_addr_gen = `DMU_NCC_BASE_ADDR + addr_3snf_gen(rand_addr_gen - `DMU_NCC_BASE_ADDR, strip_data[i]);
        end
        clp1_wr_addr_q.push_back(rand_addr_gen);
        clp1_rd_addr_q.push_back(rand_addr_gen);
      end

      fork
        begin
          while (clp0_wr_addr_q.size() > 0) begin
            clp0_addr_gen = clp0_wr_addr_q.pop_front;
            fork
              begin
                `uvm_do_on_with(wr_nosnp_full_seq, p_sequencer.chi_vsqr.Down_seqr_ch_[0], {
                                wr_nosnp_full_seq.NonSecure        == 0;
                                wr_nosnp_full_seq.CancelOnRetryAck == 1;
                                wr_nosnp_full_seq.Addr             == clp0_addr_gen;
                })
              end

              begin
                `ifdef MEM_ATTACHED_ddr5sdram
                `uvm_do_on_with(wr_nosnp_full_seq, p_sequencer.chi_vsqr.Down_seqr_ch_[1], {
                                wr_nosnp_full_seq.NonSecure        == 0;
                                wr_nosnp_full_seq.CancelOnRetryAck == 1;
                                wr_nosnp_full_seq.Addr             == clp0_addr_gen;
                })
                `endif
              end
            join
          end
          vsqr_chireq_finish(0);
          vsqr_chireq_finish(1);

          while (clp0_rd_addr_q.size() > 0) begin
            clp0_addr_gen = clp0_rd_addr_q.pop_front;
            fork
              begin
                `uvm_do_on_with(rd_nosnp_seq, p_sequencer.chi_vsqr.Down_seqr_ch_[0], {
                                rd_nosnp_seq.NonSecure        == 0;
                                rd_nosnp_seq.CancelOnRetryAck == 1;
                                rd_nosnp_seq.Addr             == clp0_addr_gen;
                })
              end

              begin
                `ifdef MEM_ATTACHED_ddr5sdram
                `uvm_do_on_with(rd_nosnp_seq, p_sequencer.chi_vsqr.Down_seqr_ch_[1], {
                                rd_nosnp_seq.NonSecure        == 0;
                                rd_nosnp_seq.CancelOnRetryAck == 1;
                                rd_nosnp_seq.Addr             == clp0_addr_gen;
                })
                `endif
              end
            join
          end
        end

        begin
          while (clp1_wr_addr_q.size() > 0) begin
            clp1_addr_gen = clp1_wr_addr_q.pop_front;
            fork
              begin
                `uvm_do_on_with(wr_nosnp_full_seq, p_sequencer.chi_vsqr.Down_seqr_ch_[2], {
                                wr_nosnp_full_seq.NonSecure        == 0;
                                wr_nosnp_full_seq.CancelOnRetryAck == 1;
                                wr_nosnp_full_seq.Addr             == clp1_addr_gen;
                })
              end

              begin
                `ifdef MEM_ATTACHED_ddr5sdram
                `uvm_do_on_with(wr_nosnp_full_seq, p_sequencer.chi_vsqr.Down_seqr_ch_[3], {
                                wr_nosnp_full_seq.NonSecure        == 0;
                                wr_nosnp_full_seq.CancelOnRetryAck == 1;
                                wr_nosnp_full_seq.Addr             == clp1_addr_gen;
                })
                `endif
              end
            join
          end
          vsqr_chireq_finish(2);
          vsqr_chireq_finish(3);

          while (clp1_rd_addr_q.size() > 0) begin
            clp1_addr_gen = clp1_rd_addr_q.pop_front;
            fork
              begin
                `uvm_do_on_with(rd_nosnp_seq, p_sequencer.chi_vsqr.Down_seqr_ch_[2], {
                                rd_nosnp_seq.NonSecure        == 0;
                                rd_nosnp_seq.CancelOnRetryAck == 1;
                                rd_nosnp_seq.Addr             == clp1_addr_gen;
                })
              end

              begin
                `ifdef MEM_ATTACHED_ddr5sdram
                `uvm_do_on_with(rd_nosnp_seq, p_sequencer.chi_vsqr.Down_seqr_ch_[3], {
                                rd_nosnp_seq.NonSecure        == 0;
                                rd_nosnp_seq.CancelOnRetryAck == 1;
                                rd_nosnp_seq.Addr             == clp1_addr_gen;
                })
                `endif
              end
            join
          end
        end
      join

      repeat(20000) @(tb.clk_noc);
      vsqr_chireq_finish(4);
    end
    repeat(20000) @(tb.clk_noc);

    if (starting_phase) starting_phase.drop_objection(this);
  endtask

  function bit[`TB_ADDR_WIDTH-1:0] addr_2n_gen(bit[`TB_ADDR_WIDTH-1:0] step, bit[`TB_ADDR_WIDTH-1:0] strip_bits);
    int ptr;
    ptr = 0;
    for (int i = 0; i < `TB_ADDR_WIDTH; i++) begin
      if (strip_bits[i] != 1) begin
        addr_2n_gen[i] = step[ptr];
        ptr++;
      end else begin
        addr_2n_gen[i] = 0;
      end
    end
  endfunction

  function bit[`TB_ADDR_WIDTH-1:0] addr_3snf_gen(bit[`TB_ADDR_WIDTH-1:0] step, bit[`TB_ADDR_WIDTH-1:0] strip_bits);
    int ptr;
    ptr = 0;
    for (int i = 0; i < `TB_ADDR_WIDTH; i++) begin
      if ((strip_bits[i] != 1)) begin
        addr_3snf_gen[i] = step[ptr];
        ptr++;
      end else begin
        addr_3snf_gen[i] = 0;
      end
    end

    if (({addr_3snf_gen[10:8], addr_3snf_gen[13:11], addr_3snf_gen[16:14]} % 3) != 0) begin
      {addr_3snf_gen[10:8], addr_3snf_gen[13:11], addr_3snf_gen[16:14]} =
      {addr_3snf_gen[10:8], addr_3snf_gen[13:11], addr_3snf_gen[16:14]} -
      {addr_3snf_gen[10:8], addr_3snf_gen[13:11], addr_3snf_gen[16:14]} % 3;
    end
  endfunction
endclass