`ifndef CHI_FULL_WRARD_SEQ_SV
`define CHI_FULL_WRARD_SEQ_SV

class chi_full_wrard_seq extends chi_base_seq;

  `uvm_object_utils(chi_full_wrard_seq)
  // `uvm_declare_p_sequencer(cdnChiUvmUserVirtualSequencer)

  rand bit [31:0]                      cnt;
  rand bit [`TB_ADDR_WIDTH-1:0]        chi_addr;
  rand bit [`TB_DATA_WIDTH-1:0]        chi_wrdata;
  rand bit                             chi_ns;
  rand bit [`TB_REQ_RSVDC_WIDTH-1:0]   chi_rsvdc;
  rand denaliChiSizeT                  chi_size;

  constraint RSVDC_c {
    chi_rsvdc inside {[ `TB_REQ_ACTUAL_RSVDC_WIDTH'h0 : {`TB_REQ_ACTUAL_RSVDC_WIDTH{1'b1}} ]};
  }

  function new(string name="chi_full_wrard_seq");
    super.new(name);
  endfunction

  full_wrard_seq wrard_full_seq;

  virtual task body();
    bit [31:0]               start_req_cnt;
    bit [`TB_ADDR_WIDTH-1:0] start_chi_addr;
    bit                      start_chi_ns;

    if(starting_phase) starting_phase.raise_objection(this);
    start_req_cnt  = cnt;
    start_chi_addr = chi_addr;
    start_chi_ns   = chi_ns;

    for (int i=0; i<start_req_cnt; i++) begin
      `uvm_do_with(wrard_full_seq,
        {wrard_full_seq.address    == start_chi_addr;
         wrard_full_seq.non_secure == start_chi_ns;
         wrard_full_seq.txnId      == i%256;
         wrard_full_seq.in_data    == chi_wrdata;
         wrard_full_seq.rand_dly_mode == start_rand_dly_mode;
         wrard_full_seq.RSVDC      == chi_rsvdc;})
      start_chi_addr = start_chi_addr + `TB_ADDR_WIDTH'h40;
      assert(this.randomize() with {
        rand_dly_mode == start_rand_dly_mode;
      });
    end

    if(starting_phase) starting_phase.drop_objection(this);
  endtask

endclass

`endif
