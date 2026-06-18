/*
 * @Project Name: Tiger LPDDR5
 * @Team: verify.emu
 * @Descripttion: Test library declarations for MR related testcases
 * @Version: 1.0
 */

//---------------------------------------------------------
//-------------------- MR Testcases -----------------------
//---------------------------------------------------------
`UVM_TESTCASE(dmu_ctrl_mr_tc,      dmu_ctrl_mr_vseq,      apb_init_tj_seq)
`UVM_TESTCASE(dmu_ctrl_mpc_tc,     dmu_ctrl_mpc_vseq,     apb_init_tj_seq)
`UVM_TESTCASE(dmu_ctrl_mr_pda_tc,  dmu_ctrl_mr_pda_vseq,  apb_init_tj_seq)
`UVM_TESTCASE(dmu_ctrl_dmi_tc,     dmu_ctrl_dmi_vseq,     apb_init_tj_seq)
`UVM_TESTCASE(dmu_ctrl_dmi_dm_on_dbi_off_tc, dmu_ctrl_dmi_vseq, apb_init_tj_seq)
`UVM_TESTCASE(dmu_ctrl_dmi_dm_off_dbi_on_tc, dmu_ctrl_dmi_vseq, apb_init_tj_seq)
`UVM_TESTCASE(dmu_ctrl_dmi_dm_on_dbi_on_tc,  dmu_ctrl_dmi_vseq, apb_init_tj_seq)
