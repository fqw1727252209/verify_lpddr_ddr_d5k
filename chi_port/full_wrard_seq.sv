`ifndef FULL_WRARD_SEQ_SV
`define FULL_WRARD_SEQ_SV

class full_wrard_seq extends cdnChiUvmUserSequence;
  // @listItem This sequence sends one item 'writeReq' and one item 'readReq', both of type 'myChiTransaction'
  myChiTransaction wr_trans;
  myChiTransaction rd_trans;

  // @listItem The user can control the value for address, non_secure, txnId and size.
  rand reg [`TB_ADDR_WIDTH-1:0]       address;
  rand reg                            non_secure;
  rand reg [`TB_REQ_RSVDC_WIDTH-1:0]  RSVDC;
  rand reg [`TB_TXNID_WIDTH-1:0]      txnId;
  rand reg [`TB_TXNID_WIDTH-1:0]      returntxnId;
  rand denaliChiSizeT                 size;
  rand reg [255:0]                    in_data;
  rand reg [255:0]                    in_data0;
  rand reg [511:0]                    in_data_all;
  bit [7:0] wr_data[];
  int n;
  int m;

  reg [7:0] writeData [];
  reg writeBE [];

  uvm_sequence_item item;

  constraint base_size_const {
    size != DENALI_CHI_SIZE_UNSET;
    size != DENALI_CHI_SIZE_RESERVED7;
  }

  constraint RSVDC_c {
    RSVDC inside {[ `TB_REQ_ACTUAL_RSVDC_WIDTH'h0 : {`TB_REQ_ACTUAL_RSVDC_WIDTH{1'b1}} ]};
  }

  `uvm_object_utils(full_wrard_seq)
  `uvm_declare_p_sequencer(cdnChiUvmSequencer)

  function new(string name = "full_wrard_seq");
    super.new(name);
  endfunction : new

  task body();
    // @listItem The sequence generates a WriteNoSnpPtl request.
    `uvm_info(get_type_name(), "full_wrard_seq sequence issuing a WriteNoSnp Request", UVM_MEDIUM);
    wr_trans = new("wr_trans");
    in_data0 = address;
    in_data_all = {in_data, in_data0};
    wr_data = {<< byte{in_data_all}};
    start_item(wr_trans);
    if (!wr_trans.randomize() with {
      wr_trans.ReqOpCode == DENALI_CHI_REQOPCODE_WriteNoSnpFull;
      wr_trans.Size      == DENALI_CHI_SIZE_FULLLINE;
      wr_trans.Addr      == address;
      wr_trans.NonSecure == non_secure;
      wr_trans.TxnId     == txnId;
      wr_trans.CancelWrite == 'b0;
      wr_trans.CancelOnRetryAck == 'b0;
      foreach(wr_trans.Data[i]) wr_trans.Data[i] == wr_data[i];
      wr_trans.DynReqFlitDelay      == local::DynReqFlitDelay;
      wr_trans.SnpFlitDelay         == local::SnpFlitDelay;
      wr_trans.RetryAckFlitDelay    == local::RetryAckFlitDelay;
      wr_trans.PCrdGrantFlitDelay   == local::PCrdGrantFlitDelay;
      wr_trans.PACrdReqFlitDelay    == local::PACrdReqFlitDelay;
      wr_trans.ReadReceiptFlitDelay == local::ReadReceiptFlitDelay;
      wr_trans.CompFlitDelay        == local::CompFlitDelay;
      wr_trans.DBIDFlitDelay        == local::DBIDFlitDelay;
      wr_trans.CompAckFlitDelay     == local::CompAckFlitDelay;
      wr_trans.SnpRespFlitDelay     == local::SnpRespFlitDelay;
      wr_trans.PersistFlitDelay     == local::PersistFlitDelay;
      wr_trans.CompCMOFlitDelay     == local::CompCMOFlitDelay;
      wr_trans.TagMatchFlitDelay    == local::TagMatchFlitDelay;
      wr_trans.StashDoneFlitDelay   == local::StashDoneFlitDelay;
    }) begin
      `uvm_fatal(get_full_name(),"randomize failed!!!")
    end
    
    // `ifdef SIMU_TZE_ENV
    wr_trans.RSVDC = RSVDC;
    // `endif
    // n = (n+1)%256;
    finish_item(wr_trans);

    `uvm_info(get_full_name(), $sformatf("Randomize write trans is \n%s\n", wr_trans.sprint()), UVM_MEDIUM)

    // @listItem Blocking sequence. wait until the write transaction ends.
    get_response(item, wr_trans.get_transaction_id());
    if (!$cast(wr_trans, item))
      `uvm_fatal(get_type_name(), "$cast(wr_trans, item) call failed!");

    writeData = new[wr_trans.Data.size()];
    writeBE   = new[wr_trans.BE.size()];

    // @listItem Keep the write data value for future reference
    for (int i=0; i<writeData.size(); i++) begin
      writeData[i] = wr_trans.Data[i];
      writeBE[i]   = wr_trans.BE[(((i/8)*8)+(8-(i%8)-1))];
    end

    // @listItem The sequence generates a ReadNoSnp request to the same location.
    `uvm_info(get_type_name(), "full_wrard_seq sequence issuing a ReadNoSnp Request", UVM_MEDIUM);
    rd_trans = new("rd_trans");
    start_item(rd_trans);
    if (!rd_trans.randomize() with {
      rd_trans.ReqOpCode == DENALI_CHI_REQOPCODE_ReadNoSnp;
      rd_trans.Size      == DENALI_CHI_SIZE_FULLLINE;
      rd_trans.Addr      == address;
      rd_trans.NonSecure == non_secure;
      rd_trans.TxnId     == txnId;
      rd_trans.ReturnTxnID == returntxnId;
      rd_trans.MemAttr   == wr_trans.MemAttr;
      // `ifndef SIMU_TZE_ENV
      // rd_trans.RSVDC     == RSVDC;
      // `endif
      rd_trans.DynReqFlitDelay      == local::DynReqFlitDelay;
      rd_trans.SnpFlitDelay         == local::SnpFlitDelay;
      rd_trans.RetryAckFlitDelay    == local::RetryAckFlitDelay;
      rd_trans.PCrdGrantFlitDelay   == local::PCrdGrantFlitDelay;
      rd_trans.PACrdReqFlitDelay    == local::PACrdReqFlitDelay;
      rd_trans.ReadReceiptFlitDelay == local::ReadReceiptFlitDelay;
      rd_trans.CompFlitDelay        == local::CompFlitDelay;
      rd_trans.DBIDFlitDelay        == local::DBIDFlitDelay;
      rd_trans.CompAckFlitDelay     == local::CompAckFlitDelay;
      rd_trans.SnpRespFlitDelay     == local::SnpRespFlitDelay;
      rd_trans.PersistFlitDelay     == local::PersistFlitDelay;
      rd_trans.CompCMOFlitDelay     == local::CompCMOFlitDelay;
      rd_trans.TagMatchFlitDelay    == local::TagMatchFlitDelay;
      rd_trans.StashDoneFlitDelay   == local::StashDoneFlitDelay;
    }) begin
      `uvm_fatal(get_full_name(),"randomize failed!!!")
    end

    // m = (m+1)%256;
    // `ifdef SIMU_TZE_ENV
    rd_trans.RSVDC = RSVDC;
    // `endif
    finish_item(rd_trans);

    `uvm_info(get_full_name(), $sformatf("Randomize read trans is \n%s\n", rd_trans.sprint()), UVM_MEDIUM)
    // @listItem Blocking sequence. wait until the read transaction ends.
    get_response(item, rd_trans.get_transaction_id());
    if (!$cast(rd_trans, item))
      `uvm_fatal(get_type_name(), "$cast(rd_trans, item) call failed!");

    // @listItem After the completion of the Read request, check for data consistency
    for (int i=0; i<rd_trans.Data.size(); i++) begin
      if (writeBE[i] == 1 && rd_trans.Data[i] != writeData[i]) begin
        `uvm_error(get_type_name(), $sformatf("ERROR: DATA INCONSISTENCY in address (%d)\nData after WRITE: %x\nData after READ: %x", rd_trans.Addr+i, writeData[i], rd_trans.Data[i]))
      end
    end
    // #10;

  endtask

endclass : full_wrard_seq

`endif
