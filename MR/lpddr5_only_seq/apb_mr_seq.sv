`ifndef APB_MR_SEQ_SV
`define APB_MR_SEQ_SV

`ifdef SIMU_DMU_APB_FTVIP

class apb_mr_seq extends apb_base_uvddr_seq;

  `uvm_object_utils(apb_mr_seq)

  rand bit [`APB_ADDR_WIDTH-1:0]  addr;
  rand bit [`APB_DATA_WIDTH-1:0]  data;
  rand bit [1:0]                  mode;
  rand bit [5:0]                  ch_sel;
  rand bit                        bc_mode;

  function new(string name = "apb_mr_seq");
    super.new(name);
  endfunction

  `include "init_config_task.sv"

  virtual task pre_body();
    if(starting_phase) starting_phase.raise_objection(this);
    `uvm_info(get_full_name(), "wait rstn", UVM_LOW);
    repeat(5) @(posedge tb.clk_cfg);
    if(starting_phase) starting_phase.drop_objection(this);
  endtask

  virtual task body();
    if(starting_phase) starting_phase.raise_objection(this);
    `uvm_info(get_full_name(), "start apb_mr_seq...", UVM_LOW);
    repeat(5) @(posedge tb.clk_cfg);
    ctl_phy_reg_parser();
    ctl_phy_field_parser();
    ch_sel = `SIMU_DMU_CH_SEL;
    if(mode=='h0) begin
      mrr_test();
    end else if(mode=='h1) begin
      mrw2r_check();
    end else if(mode=='h2) begin
      mpc_test();
    end
    if(starting_phase) starting_phase.drop_objection(this);
  endtask

  extern virtual task mrr_test();
  extern virtual task mrw2r_check();
  extern virtual task mpc_test();

  task mrr_handle(bit[1:0] cs, bit[8:0] mraddr, output bit[31:0] mrdat, input logic[31:0] base_addr);
    set_field_by_apb("CTL_MRRANK", cs, base_addr);
    set_field_by_apb("CTL_MRADDR", mraddr, base_addr);
    set_field_by_apb("CTL_MRTYPE", 1, base_addr);
    set_field_by_apb("CTL_MRTRIG", 1, base_addr);
    get_field_poll_by_apb("CTL_MRTRIG", 0, base_addr);
    get_field_poll_by_apb("CTL_MRBUSY", 0, base_addr);

    get_field_by_apb("CTL_MRRDAT", mrdat, base_addr);
    `uvm_info(get_full_name(), $sformatf("mrr_handle done, base_addr is %0h, cs is %0h, mraddr is %0h, mrdat is %0h", base_addr, cs, mraddr, mrdat), UVM_LOW);
  endtask : mrr_handle

  task mrw_handle(bit[1:0] cs, bit[8:0] mraddr, bit[15:0] mrdat, input logic[31:0] base_addr);
    set_field_by_apb("CTL_MRRANK", cs, base_addr);
    set_field_by_apb("CTL_MRADDR", mraddr, base_addr);
    set_field_by_apb("CTL_MRWDAT", mrdat, base_addr);
    set_field_by_apb("CTL_MRTYPE", 0, base_addr);
    set_field_by_apb("CTL_MRTRIG", 1, base_addr);
    get_field_poll_by_apb("CTL_MRTRIG", 0, base_addr);
    get_field_poll_by_apb("CTL_MRBUSY", 0, base_addr);

    `uvm_info(get_full_name(), $sformatf("mrw_handle done, base_addr is %0h, cs is %0h, mraddr is %0h, mrdat is %0h", base_addr, cs, mraddr, mrdat), UVM_LOW);
  endtask : mrw_handle

  task sw_mpc_flow(input logic[31:0] base_addr, int mpc_dat, int mpc_rk);
    bit mpc_trig, mpc_busy;
    get_field_by_apb("CTL_MPCTRIG", mpc_trig, base_addr);
    get_field_by_apb("CTL_MPCBUSY", mpc_busy, base_addr);

    if(mpc_trig || mpc_busy) begin
      `uvm_info(get_full_name(), $sformatf("sw_mpc_flow, curr mpc_trig is %0d, mpc_busy is %0d, so do nothing", mpc_trig, mpc_busy), UVM_LOW);
    end else begin
      set_field_by_apb("CTL_MPCDAT", mpc_dat, base_addr);
      set_field_by_apb("CTL_MPCRANK", mpc_rk, base_addr);
      set_field_by_apb("CTL_MPCTRIG", 1, base_addr);
      get_field_poll_by_apb("CTL_MPCTRIG", 0, base_addr);
      get_field_poll_by_apb("CTL_MPCBUSY", 0, base_addr);
      `uvm_info(get_full_name(), $sformatf("sw_mpc_flow done, base_addr is %0h, mpc_dat is %0h, mpc_rk is %0h", base_addr, mpc_dat, mpc_rk), UVM_LOW);
    end
  endtask : sw_mpc_flow

endclass : apb_mr_seq

task apb_mr_seq::mrr_test();
  reg [7:0] mrdat;
  reg [1:0] cs;
  for (int i=0; i<6; i++) begin
    if(ch_sel[i]==1) begin
      for (int m=0; m< `RANK_NUM ; m++) begin
        if (m==0) begin
          cs='b01;
        end else begin
          cs='b10;
        end
        for (int j=0 ; j<128 ; j++) begin
          `uvm_info(get_full_name(), $sformatf("start ctl%0d mrr_test", i), UVM_LOW);
          mrr_handle(cs, j, mrdat, `CTL0_BASE_ADDR+i*'h0_0400);
        end
      end
    end
  end
endtask

task apb_mr_seq::mrw2r_check();
  reg [7:0] mrrdat_old;
  reg [7:0] mrrdat_new;
  reg [7:0] wrwdata;
  reg [1:0] cs;

  for (int i=0; i<6; i++) begin
    if(ch_sel[i]==1) begin
      for (int m=0; m< `RANK_NUM ; m++) begin
        if (m==0) begin
          cs='b01;
        end else begin
          cs='b10;
        end
        `uvm_info(get_full_name(), $sformatf("start ctl%0d mrw2r_check", i), UVM_LOW);
        mrr_handle(cs, 'd1, mrrdat_old, `CTL0_BASE_ADDR+i*'h0_0400);
        repeat(200) @(posedge tb.clk_cfg);
        wrwdata[7:0] = {mrrdat_old[7:4]+1, mrrdat_old[3:0]};
        mrw_handle(cs, 'd1, wrwdata, `CTL0_BASE_ADDR+i*'h0_0400);
        repeat(200) @(posedge tb.clk_cfg);
        mrr_handle(cs, 'd1, mrrdat_new, `CTL0_BASE_ADDR+i*'h0_0400);
        if (mrrdat_new[7:0] != wrwdata) begin
          `uvm_error(get_type_name(), $sformatf("mr WRITE AFTER READ fail: channel=%0d, rank=%0d, cs=%0b, mraddr=1, expected_data=%0h, actual_data=%0h, original_data=%0h",
                                                 i, m, cs, wrwdata, mrrdat_new[7:0], mrrdat_old[7:0]));
        end
      end
    end
  end
endtask

task apb_mr_seq::mpc_test();
  bit [1:0] cs;
  bit [7:0] mpc_dat;
  for (int i=0; i<6; i++) begin
    if(ch_sel[i]==1) begin
      for (int m=0; m< `RANK_NUM ; m++) begin
        if (m==0) begin
          cs='b01;
        end else begin
          cs='b10;
        end
        for (int j=0 ; j<6 ; j++) begin
          mpc_dat = 8'b10000001 + j; // 'b10000001 to 'b10000110
          if (mpc_dat == 'b10000101) begin
            `uvm_info(get_full_name(), $sformatf("ctl%0d mpc_test, cs=%0b, mpc_dat=%0b (zq_start) is not supported, skip", i, cs, mpc_dat), UVM_LOW);
          end else begin
            `uvm_info(get_full_name(), $sformatf("start ctl%0d mpc_test, cs=%0b, mpc_dat=%0b", i, cs, mpc_dat), UVM_LOW);
            sw_mpc_flow(`CTL0_BASE_ADDR+i*'h0_0400, mpc_dat, cs);
          end
        end
      end
    end
  end
endtask

`endif
`endif
