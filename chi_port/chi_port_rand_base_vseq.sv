class chi_port_rand_base_vseq extends chiport_base_vseq;

  `uvm_object_utils(chi_port_rand_base_vseq)
  `uvm_declare_p_sequencer(my_vsqr)

  bit [255:0]      in_data;
  int              in_cnt = 10000;
  apb_rand_cfg_seq apb_rand_cfg;

  // Declare the sequences used below.
  // The base_rand_chi_seq variable must be declared in this class or an included base class.
  // Assume base_rand_chi_seq is already provided by chiport_base_vseq.

  function new(string name = "chi_port_rand_base_vseq");
    super.new(name);
  endfunction

  virtual task body();
    if (starting_phase) starting_phase.raise_objection(this);

    `uvm_info(get_type_name(), "Start base_rand_chi_seq...", UVM_LOW);
    `uvm_do_on(apb_rand_cfg, p_sequencer.apb_sqr_[0]);

    fork
      begin
        `uvm_do_on_with(base_rand_chi_seq, p_sequencer.chi_vsqr.Down_seqr_ch_[0], {
          base_rand_chi_seq.cnt                == in_cnt;
          base_rand_chi_seq.prefetch_mode      == 1'b1;
          base_rand_chi_seq.cmo_mode           == 1'b1;
          base_rand_chi_seq.low_boundary_addr  == `DMU_NOC_BASE_ADDR;
          base_rand_chi_seq.high_boundary_addr == `DMU_NOC_HIGH_ADDR;
        })
      end
      begin
        `ifdef MEM_ATTACHED_ddr5sdram
        `uvm_do_on_with(base_rand_chi_seq, p_sequencer.chi_vsqr.Down_seqr_ch_[1], {
          base_rand_chi_seq.cnt                == in_cnt;
          base_rand_chi_seq.prefetch_mode      == 1'b1;
          base_rand_chi_seq.cmo_mode           == 1'b1;
          base_rand_chi_seq.low_boundary_addr  == `DMU_NOC_BASE_ADDR;
          base_rand_chi_seq.high_boundary_addr == `DMU_NOC_HIGH_ADDR;
        })
        `endif
      end
      begin
        `uvm_do_on_with(base_rand_chi_seq, p_sequencer.chi_vsqr.Down_seqr_ch_[2], {
          base_rand_chi_seq.cnt                == in_cnt;
          base_rand_chi_seq.prefetch_mode      == 1'b1;
          base_rand_chi_seq.cmo_mode           == 1'b1;
          base_rand_chi_seq.low_boundary_addr  == `DMU_NCC_BASE_ADDR;
          base_rand_chi_seq.high_boundary_addr == `DMU_NCC_HIGH_ADDR;
        })
      end
      begin
        `ifdef MEM_ATTACHED_ddr5sdram
        `uvm_do_on_with(base_rand_chi_seq, p_sequencer.chi_vsqr.Down_seqr_ch_[3], {
          base_rand_chi_seq.cnt                == in_cnt;
          base_rand_chi_seq.prefetch_mode      == 1'b1;
          base_rand_chi_seq.cmo_mode           == 1'b1;
          base_rand_chi_seq.low_boundary_addr  == `DMU_NCC_BASE_ADDR;
          base_rand_chi_seq.high_boundary_addr == `DMU_NCC_HIGH_ADDR;
        })
        `endif
      end
    join

    repeat(10000) @(posedge tb.clk_noc);

    if (starting_phase) starting_phase.drop_objection(this);
  endtask
endclass
