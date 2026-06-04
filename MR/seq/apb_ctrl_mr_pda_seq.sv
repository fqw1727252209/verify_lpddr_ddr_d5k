`ifdef SIMU_DMU_APB_FTVIP
class apb_ctrl_mr_pda_seq extends apb_base_uvddr_seq;

  reg[143:0] mprr_data_out[];
  bit [31:0] rdata;
  bit[63:0] mrdat_data_out;
  bit[15:0] mrdatecc_out;
  int i;
  int csmask0;
  int csmask1;
  `uvm_object_utils(apb_ctrl_mr_pda_seq)

  function new(string name = "apb_ctrl_mr_pda_seq");
    super.new(name);
  endfunction

  virtual task body();

    repeat(1000) @(tb.clk_noc);

    if(starting_phase) starting_phase.raise_objection(this);

      `ifdef MEM_ATTACHED_ddr5sdram
      get_field_by_apb("CTL_CSMASK",csmask0,`DDR_CTL0_BASE_ADDR);
      get_field_by_apb("CTL_CSMASK",csmask1,`DDR_CTL1_BASE_ADDR);
      if(`DRAM_WIDTH==8) begin
        for(i=0;i<5;i++)begin
          //rank0
          // ctrl_pda_config(1,`DDR_CTL0_BASE_ADDR,i); //pda enumerate config
          // ctrl_pda_config(1,`DDR_CTL1_BASE_ADDR,i); //pda enumerate config
          ctrl_mpc_test(8'b01110000+i,1,`DDR_CTL0_BASE_ADDR,i);//pda select id
          ctrl_mpc_test(8'b01110000+i,1,`DDR_CTL1_BASE_ADDR,i);//pda select id


        end
        if(csmask0 == 1 && csmask1 == 1)begin
          for(i=0;i<5;i++)begin
          //rank1
          // ctrl_pda_config(2,`DDR_CTL0_BASE_ADDR,i); //pda enumerate config
          // ctrl_pda_config(2,`DDR_CTL1_BASE_ADDR,i); //pda enumerate config
          ctrl_mpc_test(8'b01110000+i,2,`DDR_CTL0_BASE_ADDR,i);//pda select id
          ctrl_mpc_test(8'b01110000+i,2,`DDR_CTL1_BASE_ADDR,i);//pda select id
          end
        end
        if(csmask0 == 3 && csmask1 == 3)begin
          for(i=0;i<5;i++)begin
          //rank1
          // ctrl_pda_config(2,`DDR_CTL0_BASE_ADDR,i); //pda enumerate config
          // ctrl_pda_config(2,`DDR_CTL1_BASE_ADDR,i); //pda enumerate config
          ctrl_mpc_test(8'b01110000+i,2,`DDR_CTL0_BASE_ADDR,i);//pda select id
          ctrl_mpc_test(8'b01110000+i,2,`DDR_CTL1_BASE_ADDR,i);//pda select id
          //rank2
          // ctrl_pda_config(4,`DDR_CTL0_BASE_ADDR,i); //pda enumerate config
          // ctrl_pda_config(4,`DDR_CTL1_BASE_ADDR,i); //pda enumerate config
          ctrl_mpc_test(8'b01110000+i,4,`DDR_CTL0_BASE_ADDR,i);//pda select id
          ctrl_mpc_test(8'b01110000+i,4,`DDR_CTL1_BASE_ADDR,i);//pda select id
          //rank3
          // ctrl_pda_config(8,`DDR_CTL0_BASE_ADDR,i); //pda enumerate config
          // ctrl_pda_config(8,`DDR_CTL1_BASE_ADDR,i); //pda enumerate config
          ctrl_mpc_test(8'b01110000+i,8,`DDR_CTL0_BASE_ADDR,i);//pda select id
          ctrl_mpc_test(8'b01110000+i,8,`DDR_CTL1_BASE_ADDR,i);//pda select id
          end
        end
      end else begin
        for(i=0;i<10;i++)begin
          // ctrl_pda_config(1,`DDR_CTL0_BASE_ADDR,i); //pda enumerate config
          // ctrl_pda_config(1,`DDR_CTL1_BASE_ADDR,i); //pda enumerate config
          ctrl_mpc_test(8'b01110000+i,1,`DDR_CTL0_BASE_ADDR,i);//pda select id
          ctrl_mpc_test(8'b01110000+i,1,`DDR_CTL1_BASE_ADDR,i);//pda select id
        end
        if(csmask0 == 1 && csmask1 == 1)begin
          for(i=0;i<10;i++)begin
          //rank1
          // ctrl_pda_config(2,`DDR_CTL0_BASE_ADDR,i); //pda enumerate config
          // ctrl_pda_config(2,`DDR_CTL1_BASE_ADDR,i); //pda enumerate config
          ctrl_mpc_test(8'b01110000+i,2,`DDR_CTL0_BASE_ADDR,i);//pda select id
          ctrl_mpc_test(8'b01110000+i,2,`DDR_CTL1_BASE_ADDR,i);//pda select id
          end
        end
        if(csmask0 == 3 && csmask1 == 3)begin
          for(i=0;i<10;i++)begin
          //rank1
          // ctrl_pda_config(2,`DDR_CTL0_BASE_ADDR,i); //pda enumerate config
          // ctrl_pda_config(2,`DDR_CTL1_BASE_ADDR,i); //pda enumerate config
          ctrl_mpc_test(8'b01110000+i,2,`DDR_CTL0_BASE_ADDR,i);//pda select id
          ctrl_mpc_test(8'b01110000+i,2,`DDR_CTL1_BASE_ADDR,i);//pda select id
          //rank2
          // ctrl_pda_config(4,`DDR_CTL0_BASE_ADDR,i); //pda enumerate config
          // ctrl_pda_config(4,`DDR_CTL1_BASE_ADDR,i); //pda enumerate config
          ctrl_mpc_test(8'b01110000+i,4,`DDR_CTL0_BASE_ADDR,i);//pda select id
          ctrl_mpc_test(8'b01110000+i,4,`DDR_CTL1_BASE_ADDR,i);//pda select id
          //rank3
          // ctrl_pda_config(8,`DDR_CTL0_BASE_ADDR,i); //pda enumerate config
          // ctrl_pda_config(8,`DDR_CTL1_BASE_ADDR,i); //pda enumerate config
          ctrl_mpc_test(8'b01110000+i,8,`DDR_CTL0_BASE_ADDR,i);//pda select id
          ctrl_mpc_test(8'b01110000+i,8,`DDR_CTL1_BASE_ADDR,i);//pda select id
          end
        end
      end


      `uvm_info(get_full_name(),$sformatf("finish ddr5 ctrl MR with PDA test"), UVM_LOW);

      `endif

    if(starting_phase) starting_phase.drop_objection(this);

  endtask

  extern virtual task ctrl_mrw_check(input bit[63:0] MRW_DAT,input bit[15:0]MRDATECC,input bit[7:0]MR_OP,input bit [3:0] id);
  extern virtual task ctrl_mpc_test(input bit[7:0]MPC_DAT,input bit[3:0]MPC_RANK,input bit[31:0]base_addr,input int i);
  extern virtual task ctrl_pda_config(input bit[3:0]MPC_RANK,input bit[31:0]base_addr,input int i);
  // extern virtual task ctrl_multicycle_mpc_test(input bit[7:0]MPC_DAT,input bit[3:0]MPC_RANK,input bit[31:0]base_addr);

endclass : apb_ctrl_mr_pda_seq


task apb_ctrl_mr_pda_seq::ctrl_mrw_check(input bit[63:0] MRW_DAT,input bit[15:0]MRDATECC,input bit[7:0]MR_OP,input bit [3:0] id);

  if(`DRAM_WIDTH==8) begin
    case(id)
    0:
    if(MRW_DAT[7:0]!=MR_OP)
      `uvm_error(get_type_name(),$sformatf("mrr_data_dev0:%0h",MRW_DAT[7:0]))
    1:
    if(MRW_DAT[15:8]!=MR_OP)
      `uvm_error(get_type_name(),$sformatf("mrr_data_dev1:%0h",MRW_DAT[15:8]))
    2:
    if(MRW_DAT[23:16]!=MR_OP)
      `uvm_error(get_type_name(),$sformatf("mrr_data_dev2:%0h",MRW_DAT[23:16]))
    3:
    if(MRW_DAT[31:24]!=MR_OP)
      `uvm_error(get_type_name(),$sformatf("mrr_data_dev3:%0h",MRW_DAT[31:24]))
    4:
    if(MRDATECC[7:0]!=MR_OP)
      `uvm_error(get_type_name(),$sformatf("mrr_data_ecc:%0h",MRDATECC[7:0]))
    endcase
  end else if(`DRAM_WIDTH==16) begin
    case(id)
    0:
    if(MRW_DAT[7:0]!=MR_OP)
      `uvm_error(get_type_name(),$sformatf("mrr_data_dev0:%0h",MRW_DAT[7:0]))
    1:
    if(MRW_DAT[15:8]!=MR_OP)
      `uvm_error(get_type_name(),$sformatf("mrr_data_dev1:%0h",MRW_DAT[15:8]))
    endcase
  end
endtask

task apb_ctrl_mr_pda_seq::ctrl_mpc_test(input bit[7:0]MPC_DAT,input bit[3:0]MPC_RANK,input bit[31:0]base_addr,input int i);
  bit[31:0] mrr_data_out;
  sw_mpc_flow(base_addr,MPC_DAT,MPC_RANK);
  //ctrl_mpc_test(8'b01110000+i,1,`DDR_CTL0_BASE_ADDR);//pda select id
  mrw_flow(51,MPC_RANK,'h2a,base_addr);
  mrw_flow(52,MPC_RANK,'h3c,base_addr);
  mrr_flow(51,MPC_RANK,mrdat_data_out,base_addr,mrdatecc_out);
  ctrl_mrw_check(mrdat_data_out,mrdatecc_out,'h2a,i);
  mrr_flow(52,MPC_RANK,mrdat_data_out,base_addr,mrdatecc_out);
  ctrl_mrw_check(mrdat_data_out,mrdatecc_out,'h3c,i);

endtask

task apb_ctrl_mr_pda_seq::ctrl_pda_config(input bit[3:0]MPC_RANK,input bit[31:0]base_addr,input int i);
  sw_mpc_flow(base_addr,8'b00001011,MPC_RANK);//Enter PDA Enumerate Programming Mode
  sw_mpc_flow(base_addr,8'b01100000+i,MPC_RANK);//pda Enumerate id
  sw_mpc_flow(base_addr,8'b00001010,MPC_RANK);//Exit PDA Enumerate Programming Mode
endtask
`endif
