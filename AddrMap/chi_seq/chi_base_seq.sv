// +FHDR------------------------------------------------------------------------
// Copyright (c) 2022 Phytium.co.Ltd.

//---------------------------------------------------------------------------------
// chi_base_seq
//---------------------------------------------------------------------------------
`ifdef SIMU_DMU_CHI_VIP
class chi_base_seq extends cdnchi_base_seq;

    `uvm_object_utils(chi_base_seq)
    rand bit [31:0]                  cnt;
    rand bit [`TB_ADDR_WIDTH-1:0]    chi_addr;
    rand bit [`TB_DATA_WIDTH-1:0]    chi_wrdata;
    rand bit                         chi_ns;
    rand bit                         chi_cancelOnRetryAck;
    rand bit [3:0]                   chi_qos;
    rand bit [1:0]                   chi_order;
    rand bit [`TB_TXNID_WIDTH-1:0]   chi_txnid;
    rand bit [`TB_REQ_RSVDC_WIDTH-1:0] chi_rsvdc;
    rand denaliChiSizeT              chi_size;

    bit                              start_rand_dly_mode;
    static int                       rand_num=0;

    function new(string name="chi_base_seq");
        super.new(name);
    endfunction

    constraint order_c {chi_order inside {0,1};}

    constraint read_no_snp_size {
        chi_size != DENALI_CHI_SIZE_UNSET;
        chi_size != DENALI_CHI_SIZE_RESERVED7;
    }

    constraint RSVDC_c {
        chi_rsvdc inside {[ `TB_REQ_ACTUAL_RSVDC_WIDTH'h0 : {`TB_REQ_ACTUAL_RSVDC_WIDTH{1'b1}} ]};
    }

    function void post_randomize();
        if(rand_num==0)begin
            start_rand_dly_mode = rand_dly_mode;
        end
        rand_num++;
    endfunction

    virtual task body();
        if(starting_phase) starting_phase.raise_objection(this);
        if(starting_phase) starting_phase.drop_objection(this);
    endtask

    virtual task chi_req_finish();
        repeat(5) @(posedge tb.clk_noc);
        // wait(`TEST_TOP.RXLINKACTIVEREQ_p0==0 && `TEST_TOP.RXLINKACTIVEREQ_p1==0);
        wait(req_if_loop[0].chi_user_if.chi_interface.DownLinkActiveReq==0);
        wait(req_if_loop[2].chi_user_if.chi_interface.DownLinkActiveReq==0);
        `ifdef MEM_ATTACHED_ddr5sdram
        wait(req_if_loop[1].chi_user_if.chi_interface.DownLinkActiveReq==0);
        wait(req_if_loop[3].chi_user_if.chi_interface.DownLinkActiveReq==0);
        `endif
        repeat(500) @(posedge tb.clk_noc);
    endtask

endclass

//---------------------------------------------------------------------------------
// chi_wr_seq: only_write
//---------------------------------------------------------------------------------
class chi_wr_seq extends chi_base_seq;

    `uvm_object_utils(chi_wr_seq)
    //`uvm_declare_p_sequencer(my_vsqr)
    rand bit [31:0]                  cnt;
    rand bit [`TB_ADDR_WIDTH-1:0]    chi_addr;
    rand bit [`TB_DATA_WIDTH-1:0]    chi_wrdata;
    rand bit                         chi_ns;
    rand bit                         chi_cancelOnRetryAck;
    rand bit [3:0]                   chi_qos;
    rand bit [`TB_TXNID_WIDTH-1:0]   chi_txnid;
    rand denaliChiSizeT              chi_size;

    function new(string name="chi_wr_seq");
        super.new(name);
    endfunction

    constraint order_c {chi_order inside {0,1};}

    constraint read_no_snp_size {
        chi_size != DENALI_CHI_SIZE_UNSET;
        chi_size != DENALI_CHI_SIZE_RESERVED7;
    }

    virtual task body();
        bit [31:0]                   start_req_cnt;
        bit [`TB_ADDR_WIDTH-1:0]     start_chi_wraddr;
        bit [`TB_ADDR_WIDTH-1:0]     start_chi_rdaddr;
        bit                          start_chi_ns;
        bit                          start_chi_cancelOnRetryAck;
        bit [1:0]                    start_chi_order;
        bit [3:0]                    start_chi_qos;
        bit [`TB_REQ_RSVDC_WIDTH-1:0] start_chi_rsvdc;
        denaliChiSizeT               start_chi_size;

        if(starting_phase) starting_phase.raise_objection(this);

        start_req_cnt              = cnt;
        start_chi_wraddr           = chi_addr;
        start_chi_ns               = chi_ns;
        start_chi_cancelOnRetryAck = chi_cancelOnRetryAck;
        start_chi_qos              = chi_qos;
        start_chi_rsvdc            = chi_rsvdc;
        for (int i=0;i<start_req_cnt;i++) begin
            //chi_full_write(bit [`TB_ADDR_WIDTH-1:0] in_addr,bit [`TB_DATA_WIDTH-1:0] in_data, bit in_ns,bit in_cancelOnRetryAck, bit [3:0] in_qos, bit [7:0] in_txnid, bit [3:0] in_rsvdc);
            `ifndef SIMU_TZE_TXNID_TEST
            chi_txnid = p_sequencer.pAgent.regInst.readReg(DENALI_CHI_REG_RandomFreeTxnId);
            `endif
            chi_full_write(start_chi_wraddr, chi_wrdata, start_chi_ns, start_chi_cancelOnRetryAck, start_chi_qos, chi_txnid, start_chi_rsvdc);
            start_chi_wraddr = start_chi_wraddr + `TB_ADDR_WIDTH'h40;
            assert(this.randomize with {
                rand_dly_mode==start_rand_dly_mode;
            });
        end

        if(starting_phase) starting_phase.drop_objection(this);
    endtask

endclass

//---------------------------------------------------------------------------------
// chi_ptlwr_seq: only_ptlwrite
//---------------------------------------------------------------------------------
class chi_ptlwr_seq extends chi_base_seq;

    `uvm_object_utils(chi_ptlwr_seq)
    //`uvm_declare_p_sequencer(my_vsqr)
    rand bit [31:0]                  cnt;
    rand bit [`TB_ADDR_WIDTH-1:0]    chi_addr;
    rand bit [`TB_ADDR_WIDTH-1:0]    step_addr;
    rand bit [`TB_DATA_WIDTH-1:0]    chi_wrdata;
    rand bit [63:0]                  chi_wrdata_be;
    rand bit                         chi_ns;
    rand bit                         chi_cancelOnRetryAck;
    rand bit [3:0]                   chi_qos;
    rand bit [`TB_TXNID_WIDTH-1:0]   chi_txnid;
    rand denaliChiSizeT              chi_size;

    function new(string name="chi_ptlwr_seq");
        super.new(name);
    endfunction

    constraint order_c {chi_order inside {0,1};}

    constraint read_no_snp_size {
        chi_size != DENALI_CHI_SIZE_UNSET;
        chi_size != DENALI_CHI_SIZE_RESERVED7;
    }

    virtual task body();
        bit [31:0]                   start_req_cnt;
        bit [`TB_ADDR_WIDTH-1:0]     start_chi_wraddr;
        bit [`TB_ADDR_WIDTH-1:0]     start_chi_rdaddr;
        bit [`TB_ADDR_WIDTH-1:0]     start_step_addr;
        bit                          start_chi_ns;
        bit                          start_chi_cancelOnRetryAck;
        bit [1:0]                    start_chi_order;
        bit [3:0]                    start_chi_qos;
        bit [`TB_REQ_RSVDC_WIDTH-1:0] start_chi_rsvdc;
        denaliChiSizeT               start_chi_size;

        if(starting_phase) starting_phase.raise_objection(this);

        start_req_cnt              = cnt;
        start_chi_wraddr           = chi_addr;
        start_step_addr            = step_addr;
        start_chi_ns               = chi_ns;
        start_chi_cancelOnRetryAck = chi_cancelOnRetryAck;
        start_chi_qos              = chi_qos;
        start_chi_rsvdc            = chi_rsvdc;

        for (int i=0;i<start_req_cnt;i++) begin
        //chi_ptl_write(bit [`TB_ADDR_WIDTH-1:0] in_addr,bit [`TB_DATA_WIDTH-1:0] in_data, bit [63:0] in_data_be, bit in_ns, denaliChiSizeT in_size, bit in_cancelOnRetryAck, bit [3:0] in_qos, bit [7:0] in_txnid, bit [3:0] in_rsvdc);
        
            chi_txnid = p_sequencer.pAgent.regInst.readReg(DENALI_CHI_REG_RandomFreeTxnId);
            
            chi_ptl_write(start_chi_wraddr, chi_wrdata, chi_wrdata_be, start_chi_ns, chi_size, start_chi_cancelOnRetryAck, start_chi_qos, chi_txnid, start_chi_rsvdc);
            start_chi_wraddr = start_chi_wraddr + start_step_addr;
            assert(this.randomize() with {
                rand_dly_mode==start_rand_dly_mode;
                chi_size != DENALI_CHI_SIZE_UNSET;
                chi_size != DENALI_CHI_SIZE_RESERVED7;
            });
        end

        if(starting_phase) starting_phase.drop_objection(this);
    endtask

endclass

//---------------------------------------------------------------------------------
// chi_wr_compare: only_write,but for compare
//---------------------------------------------------------------------------------
class chi_wr_compare_seq extends chi_base_seq;

    `uvm_object_utils(chi_wr_compare_seq)
    //`uvm_declare_p_sequencer(my_vsqr)
    rand bit [31:0]                  cnt;
    rand bit [`TB_ADDR_WIDTH-1:0]    chi_addr;
    rand bit [`TB_DATA_WIDTH-1:0]    chi_wrdata;
    rand bit                         chi_ns;
    rand bit                         chi_cancelOnRetryAck;
    rand bit [3:0]                   chi_qos;
    rand bit [`TB_TXNID_WIDTH-1:0]   chi_txnid;
    rand denaliChiSizeT              chi_size;

    function new(string name="chi_wr_seq");
        super.new(name);
    endfunction

    constraint order_c {chi_order inside {0,1};}

    constraint read_no_snp_size {
        chi_size != DENALI_CHI_SIZE_UNSET;
        chi_size != DENALI_CHI_SIZE_RESERVED7;
    }

    virtual task body();
        bit [31:0]                   start_req_cnt;
        bit [`TB_ADDR_WIDTH-1:0]     start_chi_wraddr;
        bit [`TB_DATA_WIDTH-1:0]     start_chi_wrdata;
        bit [`TB_ADDR_WIDTH-1:0]     start_chi_rdaddr;
        bit [`TB_ADDR_WIDTH-1:0]     start_step_addr;
        bit                          start_chi_ns;
        bit                          start_chi_cancelOnRetryAck;
        bit [1:0]                    start_chi_order;
        bit [3:0]                    start_chi_qos;
        bit [`TB_REQ_RSVDC_WIDTH-1:0] start_chi_rsvdc;
        denaliChiSizeT               start_chi_size;

        if(starting_phase) starting_phase.raise_objection(this);
        start_req_cnt              = cnt;
        start_chi_wraddr           = chi_addr;
        start_chi_wrdata           = chi_wrdata;
        start_chi_ns               = chi_ns;
        start_chi_cancelOnRetryAck = chi_cancelOnRetryAck;
        start_chi_qos              = chi_qos;
        start_chi_rsvdc            = chi_rsvdc;

        for (int i=0;i<start_req_cnt;i++) begin
            //chi_write_compare(bit [`TB_ADDR_WIDTH-1:0] in_addr,bit [`TB_DATA_WIDTH-1:0] in_data, bit in_ns,bit in_cancelOnRetryAck, bit [3:0] in_qos, bit [7:0] in_txnid, bit [3:0] in_rsvdc);
            chi_write_compare(start_chi_wraddr, start_chi_wrdata, start_chi_ns, start_chi_cancelOnRetryAck, start_chi_qos, chi_txnid, start_chi_rsvdc);
            start_chi_wraddr = start_chi_wraddr + `TB_ADDR_WIDTH'h40;
            assert(this.randomize with {
                rand_dly_mode==start_rand_dly_mode;
            });
        end

        if(starting_phase) starting_phase.drop_objection(this);
    endtask

endclass

//---------------------------------------------------------------------------------
// chi_rd_seq: only_read
//---------------------------------------------------------------------------------
class chi_rd_seq extends chi_base_seq;

    `uvm_object_utils(chi_rd_seq)
    //`uvm_declare_p_sequencer(my_vsqr)
    rand bit [31:0]                  cnt;
    rand bit [`TB_ADDR_WIDTH-1:0]    chi_addr;
    rand bit [`TB_DATA_WIDTH-1:0]    chi_wrdata;
    rand bit                         chi_ns;
    rand bit                         chi_cancelOnRetryAck;
    rand bit [1:0]                   chi_order;
    rand bit [3:0]                   chi_qos;
    rand bit [`TB_TXNID_WIDTH-1:0]   chi_txnid;
    rand bit [`TB_TXNID_WIDTH-1:0]   chi_returnTxnid;
    rand denaliChiSizeT              chi_size;
    rand bit                         chi_rdsize_randmode;

    function new(string name="chi_rd_seq");
        super.new(name);
    endfunction

    constraint order_c {chi_order inside {0,1};}

    constraint read_no_snp_size {
        chi_size != DENALI_CHI_SIZE_UNSET;
        chi_size != DENALI_CHI_SIZE_RESERVED7;
    }

    virtual task body();
        bit [31:0]                   start_req_cnt;
        bit [`TB_ADDR_WIDTH-1:0]     start_chi_wraddr;
        bit [`TB_ADDR_WIDTH-1:0]     start_chi_rdaddr;
        bit [`TB_ADDR_WIDTH-1:0]     start_step_addr;
        bit                          start_chi_ns;
        bit                          start_chi_cancelOnRetryAck;
        bit [1:0]                    start_chi_order;
        bit [3:0]                    start_chi_qos;
        bit [`TB_REQ_RSVDC_WIDTH-1:0] start_chi_rsvdc;
        denaliChiSizeT               start_chi_size;
        bit                          start_chi_rdsize_randmode;

        if(starting_phase) starting_phase.raise_objection(this);
        start_req_cnt              = cnt;
        start_chi_rdaddr           = chi_addr;
        start_chi_ns               = chi_ns;
        start_chi_cancelOnRetryAck = chi_cancelOnRetryAck;
        start_chi_qos              = chi_qos;
        start_chi_rsvdc            = chi_rsvdc;
        start_chi_size             = chi_size;
        start_chi_rdsize_randmode  = chi_rdsize_randmode;
        start_chi_order            = chi_order;

        //chi_addr[5:0] = 6'b0;
        for (int i=0;i<start_req_cnt;i++) begin
            //chi_read(bit [`TB_ADDR_WIDTH-1:0] in_addr, bit in_ns, denaliChiSizeT in_size, bit in_cancelOnRetryAck,bit[1:0] in_order, bit [3:0] in_qos, bit [7:0] in_txnid, bit [7:0] in_returntxid,bit [3:0] in_rsvdc); 
            if(start_chi_rdsize_randmode) begin
                chi_read(start_chi_rdaddr, start_chi_ns, chi_size, start_chi_cancelOnRetryAck, chi_order, start_chi_qos, chi_txnid, chi_returnTxnid, start_chi_rsvdc);
            end else begin
                chi_read(start_chi_rdaddr, start_chi_ns, start_chi_size, start_chi_cancelOnRetryAck, start_chi_order, start_chi_qos, chi_txnid, chi_returnTxnid, start_chi_rsvdc);
            end
            start_chi_rdaddr = start_chi_rdaddr + `TB_ADDR_WIDTH'h40;
            assert(this.randomize() with {
                rand_dly_mode==start_rand_dly_mode;
                chi_size != DENALI_CHI_SIZE_UNSET;
                chi_size != DENALI_CHI_SIZE_RESERVED7;
                chi_order >= 0 && chi_order <= 1;
            });
        end

        if(starting_phase) starting_phase.drop_objection(this);
    endtask

endclass

//---------------------------------------------------------------------------------
// chi_prefetch_seq: only_pref
//---------------------------------------------------------------------------------
class chi_prefetch_seq extends chi_base_seq;

    `uvm_object_utils(chi_prefetch_seq)
    //rand reg [7:0] TxnID;
    rand bit [31:0]                  cnt;
    rand reg [`TB_ADDR_WIDTH-1:0]    Addr;
    rand reg                         NonSecure;
    rand denaliChiSizeT              Size; // size of data, associated with the transaction
    rand reg [`TB_REQ_RSVDC_WIDTH-1:0] RSVDC;
    rand reg [3:0]                   QoS;
    rand reg [3:0]                   Order;
    rand reg [`TB_TXNID_WIDTH-1:0]   ReturnTxnID;

    prefetchSeq prefetchSeq;
    constraint read_no_snp_size {
        Size != DENALI_CHI_SIZE_UNSET;
        Size != DENALI_CHI_SIZE_RESERVED7;
    }

    function new(string name="chi_prefetch_seq");
        super.new(name);
        RSVDC = 0;
        //QoS   = 'hf;
    endfunction // new

    virtual task body();

        for (int i=0;i<cnt;i++) begin
            `uvm_do_with(prefetchSeq, {
                prefetchSeq.Addr == local::Addr;
                prefetchSeq.NonSecure == local::NonSecure;
                prefetchSeq.Order == 0;
                prefetchSeq.QoS == 0;
                prefetchSeq.Size == local::Size;
                prefetchSeq.RSVDC == local::RSVDC;
                prefetchSeq.ReturnTxnID == 0;
                prefetchSeq.rand_dly_mode == local::rand_dly_mode;
            })
            Addr = Addr + `TB_ADDR_WIDTH'h40;
        end

    endtask // body

endclass

//---------------------------------------------------------------------------------
// chi_rd_compare_seq: only_read,but for compare
//---------------------------------------------------------------------------------
class chi_rd_compare_seq extends chi_base_seq;

    `uvm_object_utils(chi_rd_compare_seq)
    //`uvm_declare_p_sequencer(my_vsqr)
    rand bit [31:0]                  cnt;
    rand bit [`TB_ADDR_WIDTH-1:0]    chi_addr;
    rand bit [(2*`TB_DATA_WIDTH)-1:0] chi_data;
    rand bit                         chi_ns;
    rand bit                         chi_cancelOnRetryAck;
    rand denaliChiSizeT              chi_size;

    function new(string name="chi_rd_compare_seq");
        super.new(name);
    endfunction

    constraint order_c {chi_order inside {0,1};}

    constraint read_no_snp_size {
        chi_size != DENALI_CHI_SIZE_UNSET;
        chi_size != DENALI_CHI_SIZE_RESERVED7;
    }

    virtual task body();

        if(starting_phase) starting_phase.raise_objection(this);
        for (int i=0;i<cnt;i++) begin
            //chi_read_compare(bit [`TB_ADDR_WIDTH-1:0] in_addr, bit in_ns, denaliChiSizeT in_size, bit in_cancelOnRetryAck, bit [3:0] in_rsvdc,bit [255:0] in_data);
            chi_read_compare(chi_addr, chi_ns, chi_size, chi_cancelOnRetryAck, chi_rsvdc , chi_data);
            chi_addr = chi_addr + `TB_ADDR_WIDTH'h40;
        end

        if(starting_phase) starting_phase.drop_objection(this);
    endtask

endclass

//---------------------------------------------------------------------------------
// chi_full_wrard_seq: one full_read after one full_write with get response
//---------------------------------------------------------------------------------
class chi_full_wrard_seq extends chi_base_seq;

    `uvm_object_utils(chi_full_wrard_seq)
    //`uvm_declare_p_sequencer(cdnChiUvmUserVirtualSequencer)

    rand bit [31:0]                  cnt;
    rand bit [`TB_ADDR_WIDTH-1:0]    chi_addr;
    rand bit [`TB_DATA_WIDTH-1:0]    chi_wrdata;
    rand bit                         chi_ns;
    rand bit [`TB_REQ_RSVDC_WIDTH-1:0] chi_rsvdc;
    rand denaliChiSizeT              chi_size;

    constraint RSVDC_c {
        chi_rsvdc inside {[ `TB_REQ_ACTUAL_RSVDC_WIDTH'h0 : {`TB_REQ_ACTUAL_RSVDC_WIDTH{1'b1}} ]};
    }

    function new(string name="chi_full_wrard_seq");
        super.new(name);
    endfunction
    full_wrard_seq wrard_full_seq;

    virtual task body();
        bit [31:0]                   start_req_cnt;
        bit [`TB_ADDR_WIDTH-1:0]     start_chi_addr;
        bit                          start_chi_ns;

        if(starting_phase) starting_phase.raise_objection(this);
        start_req_cnt              = cnt;
        start_chi_addr             = chi_addr;
        start_chi_ns               = chi_ns;

        for (int i=0; i<start_req_cnt; i++) begin
            `uvm_do_with(wrard_full_seq,
                         {wrard_full_seq.address       == start_chi_addr;
                          wrard_full_seq.non_secure    == start_chi_ns;
                          wrard_full_seq.txnId         == i%256;
                          wrard_full_seq.in_data       == chi_wrdata;
                          wrard_full_seq.rand_dly_mode == start_rand_dly_mode;
                          wrard_full_seq.RSVDC         == chi_rsvdc;})
            start_chi_addr = start_chi_addr + `TB_ADDR_WIDTH'h40;
            assert(this.randomize() with {
                rand_dly_mode==start_rand_dly_mode;
            });
        end

        if(starting_phase) starting_phase.drop_objection(this);
    endtask

endclass

//---------------------------------------------------------------------------------
// chi_readAfterWrite_seq: one read after one ptl_write with get reponse
//---------------------------------------------------------------------------------
class chi_readAfterWrite_seq extends chi_base_seq;

    `uvm_object_utils(chi_readAfterWrite_seq)
    //`uvm_declare_p_sequencer(cdnChiUvmUserVirtualSequencer)

    function new(string name="chi_readAfterWrite_seq");
        super.new(name);
    endfunction

    readAfterWriteSeq readAfterWrite_seq;
    rand bit [31:0] cnt;
    virtual task body();
        bit [31:0]                   start_req_cnt;

        if(starting_phase) starting_phase.raise_objection(this);
        start_req_cnt = cnt;

        for (int i=0; i<start_req_cnt; i++) begin
            `uvm_do_with(readAfterWrite_seq,
                         {readAfterWrite_seq.address >= `DMU_BASE0_ADDR;
                          readAfterWrite_seq.address <= `DMU_HIGH0_ADDR;
                          //readAfterWrite_seq.address[5:0] == 'b0;
                          readAfterWrite_seq.rand_dly_mode == start_rand_dly_mode;
                          readAfterWrite_seq.txnId == i%256;})
            assert(this.randomize() with {
                rand_dly_mode==start_rand_dly_mode;
            });
        end

        if(starting_phase) starting_phase.drop_objection(this);
    endtask

endclass

//---------------------------------------------------------------------------------
// chi_ptl_wrrd_seq: continue read after contiune ptl_write
//---------------------------------------------------------------------------------
class chi_ptl_wrrd_seq extends chi_base_seq;

    `uvm_object_utils(chi_ptl_wrrd_seq)
    //`uvm_declare_p_sequencer(cdnChiUvmUserVirtualSequencer)

    rand bit [31:0]                  cnt;
    rand bit [`TB_ADDR_WIDTH-1:0]    chi_addr;
    rand bit [`TB_ADDR_WIDTH-1:0]    step_addr;
    rand bit [`TB_DATA_WIDTH-1:0]    chi_wrdata;
    rand bit [63:0]                  chi_wrdata_be;
    rand bit                         chi_ns;
    rand bit                         chi_cancelOnRetryAck;
    rand bit [1:0]                   chi_order;
    rand bit [3:0]                   chi_qos;
    rand bit [`TB_TXNID_WIDTH-1:0]   chi_txnid;
    rand bit [`TB_TXNID_WIDTH-1:0]   chi_returnTxnid;
    rand bit                         rand_mo;
    rand denaliChiSizeT              chi_size;

    function new(string name="chi_ptl_wrrd_seq");
        super.new(name);
    endfunction

    constraint order_c {chi_order inside {0,1};}

    constraint read_no_snp_size {
        chi_size != DENALI_CHI_SIZE_UNSET;
        chi_size != DENALI_CHI_SIZE_RESERVED7;
    }

    constraint RSVDC_c {
        chi_rsvdc inside {[ `TB_REQ_ACTUAL_RSVDC_WIDTH'h0 : {`TB_REQ_ACTUAL_RSVDC_WIDTH{1'b1}} ]};
    }

    constraint write_no_snp_cancel_wr {
        in_cancelWrite dist {0:=9, 1:=0};
    }

    virtual task body();
        bit [31:0]                   start_req_cnt;
        bit [`TB_ADDR_WIDTH-1:0]     start_chi_wraddr;
        bit [`TB_ADDR_WIDTH-1:0]     start_chi_rdaddr;
        bit [`TB_ADDR_WIDTH-1:0]     start_step_addr;
        bit [63:0]                   start_chi_wrdata_be;
        bit                          start_chi_ns;
        bit                          start_chi_cancelOnRetryAck;
        bit [1:0]                    start_chi_order;
        bit [3:0]                    start_chi_qos;
        bit [`TB_REQ_RSVDC_WIDTH-1:0] start_chi_rsvdc;
        denaliChiSizeT               start_chi_size;
        bit                          start_rand_mo;

        if(starting_phase) starting_phase.raise_objection(this);
        start_req_cnt              = cnt;
        start_chi_wraddr           = chi_addr;
        start_chi_rdaddr           = chi_addr;
        start_step_addr            = step_addr;
        start_chi_wrdata_be        = chi_wrdata_be;
        start_chi_ns               = chi_ns;
        start_chi_cancelOnRetryAck = chi_cancelOnRetryAck;
        start_chi_order            = chi_order;
        start_chi_qos              = chi_qos;
        start_chi_rsvdc            = chi_rsvdc;
        start_rand_mo              = rand_mo;
        start_chi_size             = chi_size;

        //chi_order = 'h0;
        for (int i=0;i<start_req_cnt;i++) begin
            //chi_ptl_write(bit [`TB_ADDR_WIDTH-1:0] in_addr,bit [`TB_DATA_WIDTH-1:0] in_data, bit [63:0] in_data_be, bit in_ns, denaliChiSizeT in_size, bit in_cancelOnRetryAck, bit [3:0] in_qos, bit [7:0] in_txnid, bit [3:0] in_rsvdc);
            if(start_rand_mo) begin
                chi_ptl_write(start_chi_wraddr, chi_wrdata, chi_wrdata_be, start_chi_ns, chi_size, chi_cancelOnRetryAck, start_chi_qos, chi_txnid, chi_rsvdc);
            end else begin
                start_chi_wrdata_be = (1<<(2**(start_chi_size-1)))-1;
                chi_ptl_write(start_chi_wraddr, chi_wrdata, start_chi_wrdata_be, start_chi_ns, start_chi_size, start_chi_cancelOnRetryAck, start_chi_qos, chi_txnid, start_chi_rsvdc);
            end
            start_chi_wraddr = start_chi_wraddr + start_step_addr;
            assert(this.randomize() with {
                rand_dly_mode==start_rand_dly_mode;
                chi_size != DENALI_CHI_SIZE_UNSET;
                chi_size != DENALI_CHI_SIZE_RESERVED7;
                chi_order >= 0 && chi_order <= 1;
            });
        end
        chi_req_finish();

        for (int i=0;i<start_req_cnt;i++) begin
            //chi_read(bit [`TB_ADDR_WIDTH-1:0] in_addr, bit in_ns, denaliChiSizeT in_size, bit in_cancelOnRetryAck,bit[1:0] in_order, bit [3:0] in_qos,bit [7:0] in_txnid, bit [7:0] in_returntxid,bit [3:0] in_rsvdc);
            if(start_rand_mo) begin
                chi_read(start_chi_rdaddr, start_chi_ns, chi_size, chi_cancelOnRetryAck, chi_order, start_chi_qos, chi_txnid, chi_returnTxnid, chi_rsvdc);
            end else begin
                chi_read(start_chi_rdaddr, start_chi_ns, start_chi_size, start_chi_cancelOnRetryAck, start_chi_order, start_chi_qos, chi_txnid, chi_returnTxnid, start_chi_rsvdc);
            end
            start_chi_rdaddr = start_chi_rdaddr + start_step_addr;
            assert(this.randomize() with {
                rand_dly_mode==start_rand_dly_mode;
                chi_size != DENALI_CHI_SIZE_UNSET;
                chi_size != DENALI_CHI_SIZE_RESERVED7;
                chi_order >= 0 && chi_order <= 1;
            });
        end
        chi_req_finish();

        if(starting_phase) starting_phase.drop_objection(this);
    endtask

endclass


//---------------------------------------------------------------------------------
// chi_wrrd_seq: continue full_read after contiune full_write with cacheline
//---------------------------------------------------------------------------------
class chi_wrrd_seq extends chi_base_seq;

    `uvm_object_utils(chi_wrrd_seq)
    //`uvm_declare_p_sequencer(my_vsqr)
    rand bit [31:0]                  cnt;
    rand bit [`TB_ADDR_WIDTH-1:0]    chi_addr;
    rand bit [`TB_DATA_WIDTH-1:0]    chi_wrdata;
    rand bit                         chi_ns;
    rand bit                         chi_cancelOnRetryAck;
    rand bit [1:0]                   chi_order;
    rand bit [3:0]                   chi_qos;
    rand bit [`TB_ADDR_WIDTH-1:0]   chi_txnid;
    rand bit [`TB_TXNID_WIDTH-1:0]   chi_returnTxnid;
    rand denaliChiSizeT              chi_size;
    rand bit                         read_sep_en;

    function new(string name="chi_wrrd_seq");
        super.new(name);
    endfunction

    constraint order_c {chi_order inside {0,1};}

    constraint read_no_snp_size {
        chi_size != DENALI_CHI_SIZE_UNSET;
        chi_size != DENALI_CHI_SIZE_RESERVED7;
    }

    virtual task body();
        bit [31:0]                   start_req_cnt;
        bit [`TB_ADDR_WIDTH-1:0]     start_chi_wraddr;
        bit [`TB_ADDR_WIDTH-1:0]     start_chi_rdaddr;
        bit [63:0]                   start_chi_wrdata_be;
        bit                          start_chi_ns;
        bit                          start_chi_cancelOnRetryAck;
        bit [1:0]                    start_chi_order;
        bit [3:0]                    start_chi_qos;
        bit [`TB_REQ_RSVDC_WIDTH-1:0] start_chi_rsvdc;
        denaliChiSizeT               start_chi_size;

        if(starting_phase) starting_phase.raise_objection(this);
        start_req_cnt              = cnt;
        start_chi_wraddr           = chi_addr;
        start_chi_rdaddr           = chi_addr;
        start_chi_ns               = chi_ns;
        start_chi_cancelOnRetryAck = chi_cancelOnRetryAck;
        start_chi_order            = chi_order;
        start_chi_qos              = chi_qos;
        start_chi_rsvdc            = chi_rsvdc;
        start_chi_size             = chi_size;

        //chi_order = 'b0;
        for (int i=0;i<start_req_cnt;i++) begin
            //chi_full_write(bit [`TB_ADDR_WIDTH-1:0] in_addr,bit [`TB_DATA_WIDTH-1:0] in_data, bit in_ns,bit in_cancelOnRetryAck, bit [3:0] in_qos, bit [7:0] in_txnid, bit [3:0] in_rsvdc);
            chi_full_write(start_chi_wraddr, chi_wrdata, start_chi_ns, start_chi_cancelOnRetryAck, start_chi_qos, chi_txnid, start_chi_rsvdc);
            start_chi_wraddr = start_chi_wraddr + `TB_ADDR_WIDTH'h40;
            assert(this.randomize() with {
                rand_dly_mode==start_rand_dly_mode;
                chi_size != DENALI_CHI_SIZE_UNSET;
                chi_size != DENALI_CHI_SIZE_RESERVED7;
                chi_order >= 0 && chi_order <= 1;
            });
        end
        chi_req_finish();

        for (int i=0;i<start_req_cnt;i++) begin
            //chi_read(bit [`TB_ADDR_WIDTH-1:0] in_addr, bit in_ns, denaliChiSizeT in_size, bit in_cancelOnRetryAck,bit[1:0] in_order, bit [3:0] in_qos,bit [7:0] in_txnid, bit [7:0] in_returntxid,bit [3:0] in_rsvdc);
            if (read_sep_en) begin
                chi_read_sep(start_chi_rdaddr, start_chi_ns, start_chi_size, start_chi_cancelOnRetryAck, chi_order, start_chi_qos, chi_txnid, chi_returnTxnid, start_chi_rsvdc);
            end else begin
                chi_read(start_chi_rdaddr, start_chi_ns, start_chi_size, start_chi_cancelOnRetryAck, chi_order, start_chi_qos, chi_txnid, chi_returnTxnid, start_chi_rsvdc);
            end
            start_chi_rdaddr = start_chi_rdaddr + `TB_ADDR_WIDTH'h40;
            assert(this.randomize() with {
                rand_dly_mode==start_rand_dly_mode;
                chi_size != DENALI_CHI_SIZE_UNSET;
                chi_size != DENALI_CHI_SIZE_RESERVED7;
                chi_order >= 0 && chi_order <= 1;
            });
        end
        chi_req_finish();

        if(starting_phase) starting_phase.drop_objection(this);
    endtask

endclass

//---------------------------------------------------------------------------------
// chi_wrrd_map_seq: continue read after contiune full_write with diff step_addr
//---------------------------------------------------------------------------------
class chi_wrrd_map_seq extends chi_base_seq;

    `uvm_object_utils(chi_wrrd_map_seq)
    //`uvm_declare_p_sequencer(my_vsqr)
    rand bit [31:0]                  cnt;
    rand bit [`TB_ADDR_WIDTH-1:0]    chi_addr;
    rand bit [`TB_ADDR_WIDTH-1:0]    step_addr;
    rand bit [`TB_DATA_WIDTH-1:0]    chi_wrdata;
    rand bit                         chi_ns;
    rand bit                         chi_cancelOnRetryAck;
    rand bit [1:0]                   chi_order;
    rand bit [3:0]                   chi_qos;
    rand bit [`TB_TXNID_WIDTH-1:0]   chi_txnid;
    rand bit [`TB_TXNID_WIDTH-1:0]   chi_returnTxnid;
    rand denaliChiSizeT              chi_size;

    function new(string name="chi_wrrd_map_seq");
        super.new(name);
    endfunction

    constraint order_c {chi_order inside {0,1};}

    constraint read_no_snp_size {
        chi_size != DENALI_CHI_SIZE_UNSET;
        chi_size != DENALI_CHI_SIZE_RESERVED7;
    }

    virtual task body();
        bit [31:0]                   start_req_cnt;
        bit [`TB_ADDR_WIDTH-1:0]     start_chi_wraddr;
        bit [`TB_ADDR_WIDTH-1:0]     start_chi_rdaddr;
        bit [`TB_ADDR_WIDTH-1:0]     start_step_addr;
        bit [63:0]                   start_chi_wrdata_be;
        bit                          start_chi_ns;
        bit                          start_chi_cancelOnRetryAck;
        bit [1:0]                    start_chi_order;
        bit [3:0]                    start_chi_qos;
        bit [`TB_REQ_RSVDC_WIDTH-1:0] start_chi_rsvdc;
        denaliChiSizeT               start_chi_size;

        if(starting_phase) starting_phase.raise_objection(this);
        start_req_cnt              = cnt;
        start_chi_wraddr           = chi_addr;
        start_chi_rdaddr           = chi_addr;
        start_step_addr            = step_addr;
        start_chi_ns               = chi_ns;
        start_chi_cancelOnRetryAck = chi_cancelOnRetryAck;
        //start_chi_order            = chi_order;
        //start_chi_qos              = chi_qos;
        //start_chi_rsvdc            = chi_rsvdc;

        for (int i=0;i<start_req_cnt;i++) begin
            //chi_full_write(bit [`TB_ADDR_WIDTH-1:0] in_addr,bit [`TB_DATA_WIDTH-1:0] in_data, bit in_ns,bit in_cancelOnRetryAck, bit [3:0] in_qos, bit [7:0] in_txnid, bit [3:0] in_rsvdc);
            chi_full_write(start_chi_wraddr, chi_wrdata, start_chi_ns, start_chi_cancelOnRetryAck, chi_qos, chi_txnid, chi_rsvdc);
            start_chi_wraddr = start_chi_wraddr + start_step_addr;
            assert(this.randomize() with {
                rand_dly_mode==start_rand_dly_mode;
                chi_size != DENALI_CHI_SIZE_UNSET;
                chi_size != DENALI_CHI_SIZE_RESERVED7;
                chi_order >= 0 && chi_order <= 1;
            });
        end
        chi_req_finish();

        for (int i=0;i<start_req_cnt;i++) begin
            //chi_read(bit [`TB_ADDR_WIDTH-1:0] in_addr, bit in_ns, denaliChiSizeT in_size, bit in_cancelOnRetryAck,bit[1:0] in_order, bit [3:0] in_qos,bit [7:0] in_txnid, bit [7:0] in_returntxid,bit [3:0] in_rsvdc);
            chi_read(start_chi_rdaddr, start_chi_ns, chi_size, start_chi_cancelOnRetryAck, chi_order, chi_qos, chi_txnid, chi_returnTxnid, chi_rsvdc);
            start_chi_rdaddr = start_chi_rdaddr + start_step_addr;
            assert(this.randomize() with {
                rand_dly_mode==start_rand_dly_mode;
                chi_size != DENALI_CHI_SIZE_UNSET;
                chi_size != DENALI_CHI_SIZE_RESERVED7;
                chi_order >= 0 && chi_order <= 1;
            });
        end
        chi_req_finish();

        if(starting_phase) starting_phase.drop_objection(this);
    endtask

endclass

//---------------------------------------------------------------------------------
// chi_rd_delay_seq: for cal cycle_num with rdat/retryack/readrecipt after req
//---------------------------------------------------------------------------------
class chi_rd_delay_seq extends chi_base_seq;

    `uvm_object_utils(chi_rd_delay_seq)
    rand bit [31:0]                  cnt;
    rand bit [`TB_ADDR_WIDTH-1:0]    chi_addr;
    rand bit [`TB_DATA_WIDTH-1:0]    chi_wrdata;
    rand bit                         chi_ns;
    rand bit                         chi_cancelOnRetryAck;
    rand denaliChiSizeT              chi_size;

    function new(string name="chi_wrrd_map_seq");
        super.new(name);
    endfunction
    writeNoSnpFullSeq wr_nosnpfull_seq;
    readNoSnpSeq      rd_nosnp_seq;

    virtual task body();
        bit [31:0]                   start_req_cnt;

        if(starting_phase) starting_phase.raise_objection(this);

        start_req_cnt              = cnt;

        for (int i=0;i<start_req_cnt;i++) begin
            `uvm_do_with(wr_nosnpfull_seq,
                         {wr_nosnpfull_seq.TxnID             == i%256;
                          wr_nosnpfull_seq.NonSecure         == 0;
                          wr_nosnpfull_seq.QoS               == 'hf;
                          wr_nosnpfull_seq.CancelOnRetryAck  == 0;
                          wr_nosnpfull_seq.Addr              == `TB_ADDR_WIDTH'h9000_0000+(i*`TB_ADDR_WIDTH'h40);})
        end
        chi_req_finish();

        for (int i=0;i<start_req_cnt;i++) begin
            `uvm_do_with(rd_nosnp_seq,
                         {rd_nosnp_seq.TxnID             == i%256;
                          rd_nosnp_seq.NonSecure         == 0;
                          rd_nosnp_seq.QoS               == 'hf;
                          rd_nosnp_seq.Order             == 0;
                          rd_nosnp_seq.Size              == DENALI_CHI_SIZE_FULLLINE;
                          rd_nosnp_seq.CancelOnRetryAck  == 0;
                          rd_nosnp_seq.Addr              == `TB_ADDR_WIDTH'h9000_0000+(i*`TB_ADDR_WIDTH'h40);})
        end
        chi_req_finish();

        for (int i=0;i<start_req_cnt;i++) begin
            `uvm_do_with(rd_nosnp_seq,
                         {rd_nosnp_seq.TxnID             == i%256;
                          rd_nosnp_seq.NonSecure         == 0;
                          rd_nosnp_seq.QoS               == 'hf;
                          rd_nosnp_seq.Order             == 1;
                          rd_nosnp_seq.Size              == DENALI_CHI_SIZE_FULLLINE;
                          rd_nosnp_seq.CancelOnRetryAck  == 0;
                          rd_nosnp_seq.Addr              == `TB_ADDR_WIDTH'h9000_0000+(i*`TB_ADDR_WIDTH'h40);})
        end
        chi_req_finish();

        if(starting_phase) starting_phase.drop_objection(this);
    endtask

endclass

//------------------------------------------------------------------------------
// chi_ptl_wrard_seq
//------------------------------------------------------------------------------
class chi_ptl_wrard_seq extends chi_base_seq;

    `uvm_object_utils(chi_ptl_wrard_seq)
    //`uvm_declare_p_sequencer(cdnChiUvmUserVirtualSequencer)

    rand bit [31:0]                  cnt;
    rand bit [`TB_ADDR_WIDTH-1:0]    chi_addr;
    rand bit [`TB_ADDR_WIDTH-1:0]    step_addr;
    rand bit [`TB_DATA_WIDTH-1:0]    chi_wrdata;
    rand bit [63:0]                  chi_wrdata_be;
    rand bit                         chi_ns;
    rand bit                         chi_cancelOnRetryAck;
    rand bit [1:0]                   chi_order;
    rand bit [3:0]                   chi_qos;
    rand bit [`TB_TXNID_WIDTH-1:0]   chi_txnid;
    rand bit [`TB_TXNID_WIDTH-1:0]   chi_returnTxnid;
    rand bit                         rand_mo;
    rand denaliChiSizeT              chi_size;

    class rand_be;
        rand bit [63:0] chi_rand_be;
        constraint be_c{
            chi_rand_be dist {
                64'hffffffffffffffff:/1,
                [0:64'hfffffffffffffffe]:/2
            };
        }
    endclass //rand_be

    function new(string name="chi_ptl_wrard_seq");
        super.new(name);
    endfunction

    constraint order_c {chi_order inside {0,1};}

    constraint read_no_snp_size {
        chi_size != DENALI_CHI_SIZE_UNSET;
        chi_size != DENALI_CHI_SIZE_RESERVED7;
    }

    virtual task body();
        bit [31:0]                   start_req_cnt;
        bit [`TB_ADDR_WIDTH-1:0]     start_chi_wraddr;
        bit [`TB_ADDR_WIDTH-1:0]     start_chi_rdaddr;
        bit [`TB_ADDR_WIDTH-1:0]     start_step_addr;
        bit [63:0]                   start_chi_wrdata_be;
        bit                          start_chi_ns;
        bit                          start_chi_cancelOnRetryAck;
        bit [1:0]                    start_chi_order;
        bit [3:0]                    start_chi_qos;
        bit [`TB_REQ_RSVDC_WIDTH-1:0] start_chi_rsvdc;
        denaliChiSizeT               start_chi_size;

        rand_be                      rand_be_obj;

        if(starting_phase) starting_phase.raise_objection(this);
        start_req_cnt              = cnt;
        start_chi_wraddr           = chi_addr;
        start_chi_rdaddr           = chi_addr;
        start_step_addr            = step_addr;
        start_chi_wrdata_be        = chi_wrdata_be;
        start_chi_ns               = chi_ns;
        start_chi_cancelOnRetryAck = chi_cancelOnRetryAck;
        start_chi_order            = chi_order;
        start_chi_qos              = chi_qos;
        start_chi_rsvdc            = chi_rsvdc;
        rand_be_obj                = new();

        //chi_order = 'h0;
        for (int i=0;i<start_req_cnt;i++) begin
            //chi_ptl_write(bit [`TB_ADDR_WIDTH-1:0] in_addr, bit [`TB_DATA_WIDTH-1:0] in_data, bit [63:0] in_data_be, bit in_ns, denaliChiSizeT in_size, bit in_cancelOnRetryAck, bit [3:0] in_qos, bit [7:0] in_txnid, bit [3:0] in_rsvdc);
            rand_be_obj.randomize();
            chi_wrdata_be = rand_be_obj.chi_rand_be;
            if(rand_mo) begin
                chi_ptl_write(start_chi_wraddr, chi_wrdata, chi_wrdata_be, start_chi_ns, chi_size, chi_cancelOnRetryAck, start_chi_qos, chi_txnid, chi_rsvdc);
            end else begin
                chi_ptl_write(start_chi_wraddr, chi_wrdata, start_chi_wrdata_be, start_chi_ns, chi_size, start_chi_cancelOnRetryAck, start_chi_qos, chi_txnid, start_chi_rsvdc);
            end
            start_chi_wraddr = start_chi_wraddr + start_step_addr;
            assert(this.randomize() with {
                rand_dly_mode == start_rand_dly_mode;
                chi_size != DENALI_CHI_SIZE_UNSET;
                chi_size != DENALI_CHI_SIZE_RESERVED7;
                chi_order >= 0 && chi_order <= 1;
            });

            if(rand_mo) begin
                chi_read(start_chi_rdaddr, start_chi_ns, chi_size, chi_cancelOnRetryAck, chi_order, start_chi_qos, chi_txnid, chi_returnTxnid, chi_rsvdc);
            end else begin
                chi_read(start_chi_rdaddr, start_chi_ns, chi_size, start_chi_cancelOnRetryAck, start_chi_order, start_chi_qos, chi_txnid, chi_returnTxnid, start_chi_rsvdc);
            end
            start_chi_rdaddr = start_chi_rdaddr + start_step_addr;
            assert(this.randomize() with {
                rand_dly_mode == start_rand_dly_mode;
                chi_size != DENALI_CHI_SIZE_UNSET;
                chi_size != DENALI_CHI_SIZE_RESERVED7;
                chi_order >= 0 && chi_order <= 1;
            });
        end
        chi_req_finish();

        if(starting_phase) starting_phase.drop_objection(this);
    endtask

endclass : chi_ptl_wrard_seq
`endif
