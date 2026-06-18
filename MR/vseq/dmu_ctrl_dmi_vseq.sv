class dmu_dmi_ptl_wrard_seq extends chi_base_seq;

  `uvm_object_utils(dmu_dmi_ptl_wrard_seq)

  rand bit [`TB_ADDR_WIDTH-1:0]      chi_addr;
  rand bit [`TB_DATA_WIDTH-1:0]      chi_wrdata;
  rand bit [63:0]                   chi_wrdata_be;
  rand bit                          chi_ns;
  rand bit                          chi_cancelOnRetryAck;
  rand bit [1:0]                    chi_order;
  rand bit [3:0]                    chi_qos;
  rand bit [`TB_TXNID_WIDTH-1:0]    chi_txnid;
  rand bit [`TB_TXNID_WIDTH-1:0]    chi_returnTxnid;
  rand bit [`TB_REQ_RSVDC_WIDTH-1:0] chi_rsvdc;
  rand denaliChiSizeT               chi_size;

  constraint dmi_size_c {
    chi_size == DENALI_CHI_SIZE_FULLLINE;
  }

  function new(string name="dmu_dmi_ptl_wrard_seq");
    super.new(name);
  endfunction

  virtual task body();
    if(starting_phase) starting_phase.raise_objection(this);

    `uvm_info(get_full_name(), $sformatf("DMI partial write/read: addr=0x%0h, be=0x%0h, data=0x%0h",
                                         chi_addr, chi_wrdata_be, chi_wrdata), UVM_LOW);
    chi_ptl_write(chi_addr, chi_wrdata, chi_wrdata_be, chi_ns, chi_size,
                  chi_cancelOnRetryAck, chi_qos, chi_txnid, chi_rsvdc);
    chi_req_finish();
    chi_read(chi_addr, chi_ns, chi_size, chi_cancelOnRetryAck, chi_order,
             chi_qos, chi_txnid, chi_returnTxnid, chi_rsvdc);
    chi_req_finish();

    if(starting_phase) starting_phase.drop_objection(this);
  endtask

endclass

class dmu_ctrl_dmi_vseq extends dmu_base_vseq;

  `uvm_object_utils(dmu_ctrl_dmi_vseq)
  `uvm_declare_p_sequencer(my_vsqr)

  function new(string name="dmu_ctrl_dmi_vseq");
    super.new(name);
  endfunction

  `ifdef SIMU_DMU_APB_FTVIP
    apb_ctrl_dmi_seq       apb_ctrl_dmi_seq;
  `endif

  chi_base_rand_seq        base_rand_chi_seq;
  chi_full_wrard_seq       full_wrard_chi_seq;
  dmu_dmi_ptl_wrard_seq    dmi_ptl_wrard_seq;
  int                      in_cnt = 200;
  int                      dmi_scene = 0;

  function automatic string dmi_scene_name(input int scene);
    case(scene)
      1: return "DM=ON, DBI=OFF";
      2: return "DM=OFF, DBI=ON";
      3: return "DM=ON, DBI=ON";
      default: return "UNKNOWN";
    endcase
  endfunction

  function automatic int dmi_scene_from_testname(input string test_name);
    if(test_name == "dmu_ctrl_dmi_dm_on_dbi_off_tc") begin
      return 1;
    end else if(test_name == "dmu_ctrl_dmi_dm_off_dbi_on_tc") begin
      return 2;
    end else if(test_name == "dmu_ctrl_dmi_dm_on_dbi_on_tc") begin
      return 3;
    end else begin
      return 0;
    end
  endfunction

  function automatic int resolve_dmi_scene();
    string test_name;
    int scene;

    if($value$plusargs("DMI_SCENE=%0d", scene)) begin
      return scene;
    end

    if($value$plusargs("UVM_TESTNAME=%s", test_name)) begin
      scene = dmi_scene_from_testname(test_name);
      if(scene != 0) begin
        return scene;
      end
    end

    return 0;
  endfunction

  function automatic bit [63:0] dmi_be_pattern(input int pattern_idx);
    case(pattern_idx)
      0: return 64'hffff_ffff_ffff_ffff;
      1: return 64'haaaa_aaaa_aaaa_aaaa;
      2: return 64'h5555_5555_5555_5555;
      default: return 64'he4e4_e4e4_e4e4_e4e4;
    endcase
  endfunction

  function automatic bit [`TB_DATA_WIDTH-1:0] dmi_data_pattern(input int scene, input int port, input int pattern_idx);
    bit [`TB_DATA_WIDTH-1:0] data;

    case(pattern_idx)
      0: data = {(`TB_DATA_WIDTH/8){8'h00}};
      1: data = {(`TB_DATA_WIDTH/8){8'hff}};
      2: data = {(`TB_DATA_WIDTH/8){8'ha5}};
      default: data = {(`TB_DATA_WIDTH/8){8'h3c}};
    endcase
    data[31:0] = data[31:0] ^ {scene[7:0], port[7:0], pattern_idx[7:0], 8'h5a};
    return data;
  endfunction

  function automatic bit [`TB_ADDR_WIDTH-1:0] dmi_port_base_addr(input int port);
    if(port < 2) begin
      return `DMU_NOC_BASE_ADDR;
    end else begin
      return `DMU_NCC_BASE_ADDR;
    end
  endfunction

  virtual task run_directed_traffic(input int scene);
    bit [`TB_ADDR_WIDTH-1:0] base_addr;
    bit [`TB_ADDR_WIDTH-1:0] full_addr;
    bit [`TB_ADDR_WIDTH-1:0] ptl_addr;

    `uvm_info(get_full_name(), $sformatf("DMI scene%0d directed traffic start", scene), UVM_LOW);

    for(int port = 0; port < 4; port++) begin
      base_addr = dmi_port_base_addr(port) + (scene * 'h1000) + (port * 'h400);

      for(int data_idx = 0; data_idx < 4; data_idx++) begin
        bit [`TB_DATA_WIDTH-1:0] wr_data;

        full_addr = base_addr + (data_idx * 'h40);
        wr_data = dmi_data_pattern(scene, port, data_idx);
        `uvm_do_on_with(full_wrard_chi_seq, p_sequencer.chi_vsqr.Down_seqr_ch_[port], {
          full_wrard_chi_seq.cnt        == 1;
          full_wrard_chi_seq.chi_addr   == full_addr;
          full_wrard_chi_seq.chi_wrdata == wr_data;
          full_wrard_chi_seq.chi_ns     == 0;
          full_wrard_chi_seq.chi_rsvdc  == 0;
        })
      end

      if(scene != 2) begin
        for(int be_idx = 0; be_idx < 4; be_idx++) begin
          bit [`TB_DATA_WIDTH-1:0] wr_data;
          bit [63:0]              wr_be;

          ptl_addr = base_addr + 'h200 + (be_idx * 'h40);
          wr_data = dmi_data_pattern(scene, port, be_idx);
          wr_be   = dmi_be_pattern(be_idx);
          `uvm_do_on_with(dmi_ptl_wrard_seq, p_sequencer.chi_vsqr.Down_seqr_ch_[port], {
            dmi_ptl_wrard_seq.chi_addr             == ptl_addr;
            dmi_ptl_wrard_seq.chi_wrdata           == wr_data;
            dmi_ptl_wrard_seq.chi_wrdata_be        == wr_be;
            dmi_ptl_wrard_seq.chi_ns               == 0;
            dmi_ptl_wrard_seq.chi_cancelOnRetryAck == 0;
            dmi_ptl_wrard_seq.chi_order            == 0;
            dmi_ptl_wrard_seq.chi_qos              == 'hf;
            dmi_ptl_wrard_seq.chi_txnid            == (scene * 16 + port * 4 + be_idx) % 256;
            dmi_ptl_wrard_seq.chi_returnTxnid      == (scene * 16 + port * 4 + be_idx) % 256;
            dmi_ptl_wrard_seq.chi_rsvdc            == 0;
            dmi_ptl_wrard_seq.chi_size             == DENALI_CHI_SIZE_FULLLINE;
          })
        end
      end else begin
        `uvm_info(get_full_name(), "DMI scene2 skips partial/mask writes because DM is disabled", UVM_LOW);
      end
    end

    `uvm_info(get_full_name(), $sformatf("DMI scene%0d directed traffic done", scene), UVM_LOW);
  endtask

  virtual task run_random_traffic(input int scene);
    `uvm_info(get_full_name(), $sformatf("DMI scene%0d random CHI traffic start", scene), UVM_LOW);
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
        `uvm_do_on_with(base_rand_chi_seq, p_sequencer.chi_vsqr.Down_seqr_ch_[2], {
          base_rand_chi_seq.cnt                == in_cnt;
          base_rand_chi_seq.prefetch_mode      == 1'b1;
          base_rand_chi_seq.cmo_mode           == 1'b1;
          base_rand_chi_seq.low_boundary_addr  == `DMU_NCC_BASE_ADDR;
          base_rand_chi_seq.high_boundary_addr == `DMU_NCC_HIGH_ADDR;
        })
      end
      begin
        `uvm_do_on_with(base_rand_chi_seq, p_sequencer.chi_vsqr.Down_seqr_ch_[1], {
          base_rand_chi_seq.cnt                == in_cnt;
          base_rand_chi_seq.prefetch_mode      == 1'b1;
          base_rand_chi_seq.cmo_mode           == 1'b1;
          base_rand_chi_seq.low_boundary_addr  == `DMU_NOC_BASE_ADDR;
          base_rand_chi_seq.high_boundary_addr == `DMU_NOC_HIGH_ADDR;
        })
      end
      begin
        `uvm_do_on_with(base_rand_chi_seq, p_sequencer.chi_vsqr.Down_seqr_ch_[3], {
          base_rand_chi_seq.cnt                == in_cnt;
          base_rand_chi_seq.prefetch_mode      == 1'b1;
          base_rand_chi_seq.cmo_mode           == 1'b1;
          base_rand_chi_seq.low_boundary_addr  == `DMU_NCC_BASE_ADDR;
          base_rand_chi_seq.high_boundary_addr == `DMU_NCC_HIGH_ADDR;
        })
      end
    join
    `uvm_info(get_full_name(), $sformatf("DMI scene%0d random CHI traffic done", scene), UVM_LOW);
  endtask

  virtual task run_chi_traffic(input int scene);
    `uvm_info(get_full_name(), $sformatf("DMI scene%0d CHI traffic start", scene), UVM_LOW);

    run_directed_traffic(scene);

    if(scene == 2) begin
      `uvm_info(get_full_name(), "DMI scene2 runs directed DBI read traffic only", UVM_LOW);
    end else begin
      run_random_traffic(scene);
    end

    `uvm_info(get_full_name(), $sformatf("DMI scene%0d CHI traffic done", scene), UVM_LOW);
  endtask

  virtual task body();
    if(starting_phase) starting_phase.raise_objection(this);

    repeat(10) @(tb.clk_noc);

    `uvm_info(get_full_name(), "Start ctrl DMI test...", UVM_LOW);

`ifdef dram_lpddr5
    dmi_scene = resolve_dmi_scene();
    if(!(dmi_scene inside {[0:3]})) begin
      `uvm_fatal(get_full_name(), $sformatf("Unsupported DMI scene %0d. Valid values: 1(DM=ON DBI=OFF), 2(DM=OFF DBI=ON), 3(DM=ON DBI=ON).", dmi_scene))
    end

    `uvm_do_on_with(apb_ctrl_dmi_seq, p_sequencer.apb_sqr_[0], {
      apb_ctrl_dmi_seq.dmi_scene == local::dmi_scene;
    })

    if(dmi_scene == 0) begin
      dmi_scene = apb_ctrl_dmi_seq.detected_scene;
      if(dmi_scene == 0) begin
        `uvm_fatal(get_full_name(), "Cannot infer DMI scene from init CSR state. Please set DBI/DM_EN to a supported combination or pass +DMI_SCENE=1/2/3.")
      end
      `uvm_info(get_full_name(), $sformatf("DMI scene inferred from init parameters: scene%0d (%s)",
                                           dmi_scene, dmi_scene_name(dmi_scene)), UVM_LOW);
    end

    `uvm_info(get_full_name(), $sformatf("Run DMI scene%0d (%s). DBI/DM_EN must be set by init parameters before this vseq starts.",
                                         dmi_scene, dmi_scene_name(dmi_scene)), UVM_LOW);

    run_chi_traffic(dmi_scene);
`else
    `uvm_error(get_full_name(), "dmu_ctrl_dmi_vseq is LPDDR5-only. Please compile with dram_lpddr5.")
`endif

    `uvm_info(get_full_name(), "End ctrl DMI test...", UVM_LOW);
    repeat(100) @(tb.clk_noc);

    if(starting_phase) starting_phase.drop_objection(this);

  endtask

endclass
