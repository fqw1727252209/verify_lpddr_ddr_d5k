//---------------------------------------------------------
//-----------define uvc interface parameter----------------
//---------------------------------------------------------
`define SIMU_DMU_PIO_NUM 1
`define SIMU_DMU_REQ_NUM 4
//`define SIMU_DMU_REQ_SLV_NUM 1
`define SIMU_MAXMASTER_NUM 32

//for chi_vip
// `define CDN_CHIG_VERSION       1
`define TB_ADDR_WIDTH          44
`define TB_DATA_WIDTH          256
`define TB_NODE_ID_WIDTH       11
`define TB_REQ_RSVDC_WIDTH     4    //4 or 8?
`define TB_DATA_RSVDC_WIDTH    4
`define TB_DATA_CHECK          0    //?
`define TB_DATA_POISON         1
`define TB_TXNID_WIDTH         12
`define TB_MPAM_SUPPORT        1    //?
`define TB_REQ_ACTUAL_RSVDC_WIDTH 4
`define DATACHECKFEATURE   0
`define DATAPOISONFEATURE  1
`define HMV_SD   #1
`define TB_INTERFACE_TYPE   "Hn2Sn"
`define TB_REQOPCODE_WIDTH  7
`define TB_DATOPCODE_WIDTH  4
`define TB_RSPOPCODE_WIDTH  5

//CHI-G ADD
// `ifdef CDN_CHIG_VERSION
   `define TB_ODD_PARITY_BYTE_ALL_CHECK 0
   `define TB_MEMORY_TAG 0
   `define TB_PBHA_SUPPORT 0
   `define TB_NONSHAREABLE_CACHE 0
   `define TB_DEFERRABLE_WRITE 0
   `define TB_REALM_EXTENSION 1
   `define MPAM_VERSION 1
   `define DEVASSIGN_SUPPORT 0
   `define MECID_SUPPORT 1
   `define MECID_WIDTH 16
   `define NODE_TYPE_ACC 1
   `define TB_DEVASSIGN_DEVICE_STREAMID_SECSID1_SUPPORT 0
// `endif

`define TB_UIF_ADDR_WIDTH      35
`define TB_UIF_DATA_WIDTH      512
`define TB_UIF_ID_WIDTH        19
`define TB_UIF_CRDT_WIDTH      7
`define TB_UIF_SIZE_WIDTH      3
`define TB_UIF_OFFSET_WIDTH    6
`define TB_UIF_UVC_MST_DLY     #0
`define TB_UIF_UVC_SLV_DLY     #10ps

`define MC_CHI_DATAID_WIDTH 2

//for apb_uvc
`define APB_ADDR_WIDTH 21
`define APB_DATA_WIDTH 32

//for pad_mem_interface
//`define PAD_MEM_CLK_WIDTH          8
//`define PAD_MEM_CS_WIDTH           4
//`define PAD_MEM_ADDR_WIDTH         14
//`define DIMM_PAD_MEM_ADDR_B_WIDTH  28

//for chib_mon_if
`define CHIB_MON_REQADDR_WIDTH   `TB_ADDR_WIDTH
`define CHIB_MON_NODEID_WIDTH    `TB_NODE_ID_WIDTH
`define CHIB_MON_MAX_OS          7

//for perf_test ot
`ifdef SIMU_MST_OT40
   `define SIMU_MST_OT 40
`elsif SIMU_MST_OT60
   `define SIMU_MST_OT 60
`elsif SIMU_MST_OT80
   `define SIMU_MST_OT 80
`elsif SIMU_MST_OT100
   `define SIMU_MST_OT 100
`elsif SIMU_MST_OT120
   `define SIMU_MST_OT 120
`else
   `define SIMU_MST_OT 150 // (48*18)/6=144
`endif

//---------------------------------------------------------
//-------------------------for clk-------------------------
`ifndef CLK_DMU_PERIOD_F0
   `define CLK_DMU_PERIOD_F0           1124ps     // 900MHz/7200MTs
`endif

`define CLK_REG_PERIOD              3.88ns     //50M(20ns),200M(5ns),500M(2ns)
`define CLK_PHY_BYPASS_PERIOD       502ps      //2.0G
// `define CLK_PHY_BYPASS_PERIOD       314.5ps    //3.2G
// `define CLK_PHY_BYPASS_PERIOD       625ps      //1.6G

`ifdef SIMU_UDIMM_SOFTPHY
`define CLK_DMU_BASE0_PERIOD      250ps          // scp base0 4000M
`else
`define CLK_DMU_BASE0_PERIOD      1264ps         // scp base0 800M
`endif

`define CLK_DMU_NOC_PERIOD        500ps          // chi noc 2G
`define CLK_DMU_NCC_PERIOD        1667ps         // chi ncc 600M

`define CLK_DMU_BASE1_PERIOD      417ps          // scp base1 2400M


`define SIMU_DMU_JTAG_DLY #20ns
//---------------------------------------------------------

//---------------------------------------------------------
//-------------------------define for dmu id---------------
`define DDR_CH0_ID  30
`define DDR_CH1_ID  31
`define DDRID  'h8
`define HMID   'h4c
//---------------------------------------------------------



//-------------------------define for dmu addr-------------
//dmu
`define DMU_USR_BASE_ADDR        'h00_0000
`define MPAM0_BASE_ADDR          'h04_0000
`define UMPG0_BASE_ADDR          'h04_8000
`define TZE0_BASE_ADDR           'h04_a000
`define CHIP0_BASE_ADDR          'h04_b000
`define MPAM1_BASE_ADDR          'h05_0000
`define UMPG1_BASE_ADDR          'h05_8000
`define TZE1_BASE_ADDR           'h05_a000
`define CHIP1_BASE_ADDR          'h05_b000
`define DFS_FSM_BASE_ADDR        'h06_0000
`define PDM0_BASE_ADDR           'h06_8000
`define PDM1_BASE_ADDR           'h07_0000
`define RAS_BASE_ADDR            'h07_8000
`define TDBG_BASE_ADDR           'h07_c000
`define DDR_CTL0_BASE_ADDR       'h2_0000   //>>2 actuall 'h08_0000
`define DDR_CTL1_BASE_ADDR       'h3_0000   //>>2 actuall 'h0c_0000
`define DDR_PHY_BASE_ADDR        'h4_0000   //>>2 actuall 'h10_0000
//---------------------------------------------------------

//-------------------------define for ddr_capacity---------
   `define DMU_BASE0_ADDR        `TB_ADDR_WIDTH'h8000_0000            //region0 : base: 2GB
   `define DMU_HIGH0_ADDR        `TB_ADDR_WIDTH'hffff_ffff
   `define DMU_BASE1_ADDR        `TB_ADDR_WIDTH'h40_0000_0000         //region1 : base: 512GB
   `define DMU_HIGH1_ADDR        `TB_ADDR_WIDTH'h7f_ffff_ffff
   `define DMU_BASE2_ADDR        `TB_ADDR_WIDTH'h100_0000_0000
   `define DMU_HIGH2_ADDR        `TB_ADDR_WIDTH'hfff_ffff_ffff

`ifndef DDR_CAPACITY
   `define DDR_CAPACITY      (`TB_ADDR_WIDTH'h1<<33)    //8GB
`endif

`define DMU_NOC_BASE_ADDR `DMU_BASE0_ADDR
`define DMU_NOC_HIGH_ADDR `DMU_HIGH0_ADDR
`define DMU_NCC_BASE_ADDR `DMU_BASE1_ADDR
`define DMU_NCC_HIGH_ADDR `DMU_NCC_BASE_ADDR + `DDR_CAPACITY -(`DMU_NOC_HIGH_ADDR+1 - `DMU_NOC_BASE_ADDR)-1

//---------------------------------------------------------

/*---------------------- by zhangfeijuan 2025-02-28 -------------------------*/
`define TEST_TOP                 tb
`define DMU_TOP                  `TEST_TOP.dmu_top

`define DDR_SUB                  `DMU_TOP.u_ddr_lpddr_combo_subsystem
`define CTL0                     `DDR_SUB.inst_ddr_ctl_ch0
`define CTL1                     `DDR_SUB.inst_ddr_ctl_ch1
`define PHY                      `DDR_SUB.inst_ddr_phy_top
`define REGBANK_CH0              `CTL0.inst_regBank
`define REGBANK_CH1              `CTL1.inst_regBank
`define CLK_DIV                  `DMU_TOP.u_dmu_clk_div


`define ADDR_TRANS0              `DMU_TOP.u_dmu_addr_transform_ch0
`define ADDR_TRANS1              `DMU_TOP.u_dmu_addr_transform_ch1
`define APB_CTL                  `DMU_TOP.u_dmu_apb_ctrl
`define DMU_CLK_RST_GEN          `DMU_TOP.u_dmu_clk_rst_gen
`define RAS_WRAPPER              `DMU_TOP.u_dmu_ras_comp_wrapper
`define TDBG                     `RAS_WRAPPER.u_dmu_tdbg
`define TDBG_INST                `TDBG.inst_chi_mon
`define PDM0                     `DMU_TOP.u_pdm_ch0
`define PDM1                     `DMU_TOP.u_pdm_ch1
`define DFS_FSM                  `DMU_TOP.u_dmu_dfs_fsm
`define CLK_DIV                  `DMU_TOP.u_dmu_clk_div

`define TZE0                     `CHI_PORT0.tze_top_inst
`define TZE1                     `CHI_PORT1.tze_top_inst
`define TZE0_ALGO                `TZE0.algo_enc
`define TZE0_REG                 `TZE0.apb_controller_wrapper_inst
`define TZE1_ALGO                `TZE1.algo_enc
`define TZE1_REG                 `TZE1.apb_controller_wrapper_inst
`define TZE0_AW                  `TZE0.aw_w_channel_inst
`define TZE1_AW                  `TZE1.aw_w_channel_inst
`define TZE0_AR                  `TZE0.ar_r_channel_inst
`define TZE1_AR                  `TZE1.ar_r_channel_inst
// `define APB0_CONTROLLER         `TZE0.apb_controller_wrapper_inst.apb_controller_inst
// `define APB1_CONTROLLER         `TZE1.apb_controller_wrapper_inst.apb_controller_inst

`define BIST0                    `DMU_TOP.u_ddr5_2ch_subsystem.inst_ddr_ctl_ch0.inst_bist
`define BIST1                    `DMU_TOP.u_ddr5_2ch_subsystem.inst_ddr_ctl_ch1.inst_bist

`define UMPG0                    `DMU_TOP.u_ddr5_2ch_subsystem.inst_ddr_ctl_ch0.inst_chi_port_wrapper.umpg_inst
`define UMPG1                    `DMU_TOP.u_ddr5_2ch_subsystem.inst_ddr_ctl_ch1.inst_chi_port_wrapper.umpg_inst

`define MEMORY                   `TEST_TOP.memory.memory


//define for chi_port
`define CHI_PORT0  `TEST_TOP.chi_port.chi_port
`define PA0        `TEST_TOP.inst_pa

`define CHI_PORT1  `TEST_TOP.chi_port.chi_port
`define PA1        `TEST_TOP.inst_pa

`define TZE0                     `CHI_PORT0.tze_top_inst
`define TZE1                     `CHI_PORT1.tze_top_inst
`define TZE0_ALGO                `TZE0.algo_enc
`define TZE0_REG                 `TZE0.apb_controller_wrapper
`define TZE1_ALGO                `TZE1.algo_enc
`define TZE1_REG                 `TZE1.apb_controller_wrapper
`define TZE0_APB0_CONTROLLER     `TZE0.apb_controller_wrapper.apb_controller_inst
`define TZE1_APB1_CONTROLLER     `TZE1.apb_controller_wrapper.apb_controller_inst

//-------------------------define for dmu ip reg-----------------------------
`include "define_DMU.sv"
`include "define_pdm.sv"
`include "define_reg_offset.sv"
// `include "define_chiport.sv"

`define CLK_DMU_FREQ_NUM 1
`define CLK_DMU_INIT_FSP 0
`define SPEED 6400
`define DENSITY 16
`define DRAM_WIDTH 8
`define RANK_NUM 2
`define DIMM_WITH_ECC 1
`define CLK_DIV_50M 50

`define MACRO2STR(arg) `"arg`"