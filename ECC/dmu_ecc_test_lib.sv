/*
 * @Project Name: Tiger LPDDR5
 * @Team: verify.emu
 * @Author: AntiGravity
 * @Descripttion: Test library declarations for Inline ECC and Link ECC
 * @Version: 1.0
 */

//---------------------------------------------------------
//------------------ Inline ECC Testcases -----------------
//---------------------------------------------------------
`UVM_TESTCASE(dmu_inline_ecc_hw_inject_tc,  dmu_inline_ecc_hw_inject_vseq,  apb_init_tj_seq)
`UVM_TESTCASE(dmu_inline_ecc_rdeccc_tc,     dmu_inline_ecc_rdeccc_vseq,     apb_init_tj_seq)
`UVM_TESTCASE(dmu_inline_ecc_rdeccu_tc,     dmu_inline_ecc_rdeccu_vseq,     apb_init_tj_seq)
`UVM_TESTCASE(dmu_inline_ecc_wreccc_tc,     dmu_inline_ecc_wreccc_vseq,     apb_init_tj_seq)
`UVM_TESTCASE(dmu_inline_ecc_wreccu_tc,     dmu_inline_ecc_wreccu_vseq,     apb_init_tj_seq)
`UVM_TESTCASE(dmu_inline_ecc_tc,            dmu_inline_ecc_vseq,            apb_init_tj_seq)

//---------------------------------------------------------
//------------------- Link ECC Testcases ------------------
//---------------------------------------------------------
`UVM_TESTCASE(dmu_linkecc_rddatac_tc,       dmu_linkecc_rddatac_vseq,       apb_init_tj_seq)
`UVM_TESTCASE(dmu_linkecc_rddatau_tc,       dmu_linkecc_rddatau_vseq,       apb_init_tj_seq)
`UVM_TESTCASE(dmu_linkecc_rd_dbic_tc,       dmu_linkecc_rd_dbic_vseq,       apb_init_tj_seq)
`UVM_TESTCASE(dmu_linkecc_rd_dbiu_tc,       dmu_linkecc_rd_dbiu_vseq,       apb_init_tj_seq)
`UVM_TESTCASE(dmu_linkecc_wr_datac_tc,      dmu_linkecc_wr_datac_vseq,      apb_init_tj_seq)
`UVM_TESTCASE(dmu_linkecc_wr_datau_tc,      dmu_linkecc_wr_datau_vseq,      apb_init_tj_seq)
`UVM_TESTCASE(dmu_linkecc_wr_maskc_tc,      dmu_linkecc_wr_maskc_vseq,      apb_init_tj_seq)
`UVM_TESTCASE(dmu_linkecc_wr_masku_tc,      dmu_linkecc_wr_masku_vseq,      apb_init_tj_seq)
`UVM_TESTCASE(dmu_linkecc_wrc_tc,           dmu_linkecc_wrc_vseq,           apb_init_tj_seq)
`UVM_TESTCASE(dmu_linkecc_smoke_tc,         dmu_linkecc_smoke_vseq,         apb_init_tj_seq)
`UVM_TESTCASE(dmu_linkecc_tc,               dmu_linkecc_vseq,               apb_init_tj_seq)
