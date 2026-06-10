`ifdef SIMU_DMU_APB_FTVIP
`define ADDR0_STRIP_BASE_ADDR   'h0050
`define ADDR1_STRIP_BASE_ADDR   'h0058

//************************apb_max_region_addr_seq************************
class apb_max_region_addr_seq extends apb_base_seq;

  `uvm_object_utils(apb_max_region_addr_seq)

  rand bit [38:0]      wrdata;
  function new(string name = "apb_max_region_addr_seq");
    super.new(name);
  endfunction

  virtual task body();

    if(starting_phase) starting_phase.raise_objection(this);
    //2 addr_trans
    //bit[31:24] addr_size,bit[18:0] addr_base
    `ifdef MEM_ATTACHED_ddr5sdram    //ch0:64G ch1:64G   all:128G
    USR_REGWR(`DMU_USR_BASE_ADDR+'h0010,'h0000_0002);   //CTL0_ADDR_SIZE_0 2GB      0x8000_0000-0xffff_ffff
    USR_REGWR(`DMU_USR_BASE_ADDR+'h0014,'h0000_0002);   //CTL0_ADDR_BASE_0 2GB 
    USR_REGWR(`DMU_USR_BASE_ADDR+'h0018,'h0000_0002);   //CTL0_ADDR_SIZE_1 2GB      0x100_0000_0000-0x100_7fff_ffff
    USR_REGWR(`DMU_USR_BASE_ADDR+'h001c,'h0000_0400);   //CTL0_ADDR_BASE_1 1TB

    USR_REGWR(`DMU_USR_BASE_ADDR+'h0020,(`DDR_CAPACITY>>30)-5);   //CTL0_ADDR_SIZE_2 2TB-2TB+(`DDR_CAPACITY>>30-5)     0x200_0000_0000-
    USR_REGWR(`DMU_USR_BASE_ADDR+'h0024,'h0000_0800);
    USR_REGWR(`DMU_USR_BASE_ADDR+'h0028,'h0000_0001);   //CTL0_ADDR_SIZE_3 3TB-3TB+1G   0x300_0000_0000-0x300_3fff_ffff
    USR_REGWR(`DMU_USR_BASE_ADDR+'h002c,'h0000_1000);

    USR_REGWR(`DMU_USR_BASE_ADDR+'h0030,'h0000_0002);   //CTL1_ADDR_SIZE_0 2GB-4GB      0x8000_0000-0xffff_ffff
    USR_REGWR(`DMU_USR_BASE_ADDR+'h0034,'h0000_0002);
    USR_REGWR(`DMU_USR_BASE_ADDR+'h0038,'h0000_0014);   //CTL1_ADDR_SIZE_1 1TB-1TB+20G  0x100_0000_0000-0x105_0000_0000
    USR_REGWR(`DMU_USR_BASE_ADDR+'h003c,'h0000_0400);

    USR_REGWR(`DMU_USR_BASE_ADDR+'h0040,(`DDR_CAPACITY>>30)-5);   //CTL1_ADDR_SIZE_2 2TB-2TB+(`DDR_CAPACITY>>30)-5     0x200_0000_0000-
    USR_REGWR(`DMU_USR_BASE_ADDR+'h0044,'h0000_0800);
    USR_REGWR(`DMU_USR_BASE_ADDR+'h0048,'h0000_0001);   //CTL1_ADDR_SIZE_3 3TB-3TB+1G   0x300_0000_0000-0x300_3fff_ffff
    USR_REGWR(`DMU_USR_BASE_ADDR+'h004c,'h0000_1000);

    // `else
    // // `ifdef MEM_ATTACHED_ddr4sdram    //32g
    // USR_REGWR(`DMU_USR_BASE_ADDR+'h0010,'h0002_0002);   //CTL0_ADDR_MAP_0 0x8000_0000-0xffff_ffff(2GB-4GB)
    // USR_REGWR(`DMU_USR_BASE_ADDR+'h0014,'h000e_0400);   //CTL0_ADDR_MAP_1 1TB-1TB+14G   0x100_0000_0000-0x103_8000_0000
    // USR_REGWR(`DMU_USR_BASE_ADDR+'h0018,'h0008_0800);   //CTL0_ADDR_MAP_2 2TB-2TB+8G    0x200_0000_0000-0x202_0000_0000
    // USR_REGWR(`DMU_USR_BASE_ADDR+'h001c,'h0008_0c00);   //CTL0_ADDR_MAP_3 3TB-3TB+8G    0x300_0000_0000-0x302_0000_0000
    `endif

    if(starting_phase) starting_phase.drop_objection(this);

  endtask

endclass :apb_max_region_addr_seq

class apb_map_region_addr_seq extends apb_base_seq;

  `uvm_object_utils(apb_map_region_addr_seq)

  rand bit [38:0]      wrdata;
  function new(string name = "apb_map_region_addr_seq");
    super.new(name);
  endfunction

  virtual task body();


    if(starting_phase) starting_phase.raise_objection(this);
    //2 addr_trans
    //bit[31:24] addr_size,bit[18:0] addr_base
    `ifdef MEM_ATTACHED_ddr5sdram    //ch0:64G ch1:64G   all:128G
    USR_REGWR(`DMU_USR_BASE_ADDR+'h0010,'h0000_0002);   //CTL0_ADDR_SIZE_0 2GB      0x8000_0000-0xffff_ffff
    USR_REGWR(`DMU_USR_BASE_ADDR+'h0014,'h0000_0002);   //CTL0_ADDR_BASE_0 2GB 
    USR_REGWR(`DMU_USR_BASE_ADDR+'h0018,'h0000_0014);   //CTL0_ADDR_SIZE_1 255TB-255TB+20G
    USR_REGWR(`DMU_USR_BASE_ADDR+'h001c,'h0002_FC00);   //CTL0_ADDR_BASE_1 

    USR_REGWR(`DMU_USR_BASE_ADDR+'h0020,'h0000_0010);   //CTL0_ADDR_SIZE_2 55TB+960G-255TB+976G
    USR_REGWR(`DMU_USR_BASE_ADDR+'h0024,'h0002_FFC0);
    USR_REGWR(`DMU_USR_BASE_ADDR+'h0028,'h0000_0010);   //CTL0_ADDR_SIZE_3 255TB+1008G-255TB+1024G
    USR_REGWR(`DMU_USR_BASE_ADDR+'h002c,'h0002_FFF0);

    USR_REGWR(`DMU_USR_BASE_ADDR+'h0030,'h0000_0002);   //CTL1_ADDR_SIZE_0 2GB-4GB      0x8000_0000-0xffff_ffff
    USR_REGWR(`DMU_USR_BASE_ADDR+'h0034,'h0000_0002);
    USR_REGWR(`DMU_USR_BASE_ADDR+'h0038,'h0000_0014);   //CTL1_ADDR_SIZE_1 255TB-255TB+20G
    USR_REGWR(`DMU_USR_BASE_ADDR+'h003c,'h0002_FC00);

    USR_REGWR(`DMU_USR_BASE_ADDR+'h0040,'h0000_0010);   //CTL1_ADDR_SIZE_2 255TB+960G-255TB+976G
    USR_REGWR(`DMU_USR_BASE_ADDR+'h0044,'h0002_FFC0);
    USR_REGWR(`DMU_USR_BASE_ADDR+'h0048,'h0000_0010);   //CTL1_ADDR_SIZE_3 255TB+1008G-255TB+1024G
    USR_REGWR(`DMU_USR_BASE_ADDR+'h004c,'h0002_FFF0);

    // USR_REGWR(`DMU_USR_BASE_ADDR+'h0010,'h0002_0002);   //CTL0_ADDR_MAP_0 0x8000_0000-0xffff_ffff(2GB-4GB)  //2g
    // USR_REGWR(`DMU_USR_BASE_ADDR+'h0014,'h0012_3C00);   //CTL0_ADDR_MAP_1 15TBG-15TB+18G  0xf00_0000_0000-0xf04_8000_0000  //18g
    // USR_REGWR(`DMU_USR_BASE_ADDR+'h0018,'h0010_3FC0);   //CTL0_ADDR_MAP_2 15TB+960G-15TB+976G   0xff0_0000_0000-0xff4_0000_0000  //16g
    // USR_REGWR(`DMU_USR_BASE_ADDR+'h001c,'h0010_3FF0);   //CTL0_ADDR_MAP_3 15TB+1008G-15TB+1024G 0xffc_0000_0000-0xfff_ffff_ffff  //16g


    // `else
    // // `ifdef MEM_ATTACHED_ddr4sdram    //32g
    // USR_REGWR(`DMU_USR_BASE_ADDR+'h0010,'h0002_0002);   //CTL0_ADDR_MAP_0 0x8000_0000-0xffff_ffff(2GB-4GB)  //2g
    // USR_REGWR(`DMU_USR_BASE_ADDR+'h0014,'h000e_3C00);   //CTL0_ADDR_MAP_1 15TB-15TB+14G         0xf00_0000_0000-0xf03_8000_0000  //14g
    // USR_REGWR(`DMU_USR_BASE_ADDR+'h0018,'h0008_3FF0);   //CTL0_ADDR_MAP_2 15TB+1008G-15TB+1016G 0xffc_0000_0000-0xffe_0000_0000  //8g
    // USR_REGWR(`DMU_USR_BASE_ADDR+'h001c,'h0008_3FF8);   //CTL0_ADDR_MAP_3 15TB+1016G-15TB+1024G 0xffe_0000_0000-0xfff_ffff_ffff  //8g
    `endif

    if(starting_phase) starting_phase.drop_objection(this);

  endtask

endclass :apb_map_region_addr_seq

//************************apb_strip_addr_seq************************
class apb_strip_addr_seq extends apb_base_seq;

  `uvm_object_utils(apb_strip_addr_seq)

  rand bit [`TB_ADDR_WIDTH-1:0]      wrdata;
  function new(string name = "apb_strip_addr_seq");
    super.new(name);
  endfunction

  virtual task body();


    if(starting_phase) starting_phase.raise_objection(this);

    
    //addr0_strip_en0
    USR_REGWR(`DMU_USR_BASE_ADDR+`ADDR0_STRIP_BASE_ADDR+'h0,wrdata[31:0]);

    //addr0_strip_en1
    USR_REGWR(`DMU_USR_BASE_ADDR+`ADDR0_STRIP_BASE_ADDR+'h4,wrdata[`TB_ADDR_WIDTH-1:32]);

    `ifdef MEM_ATTACHED_ddr5sdram
    //addr1_strip_en0
    USR_REGWR(`DMU_USR_BASE_ADDR+`ADDR1_STRIP_BASE_ADDR+'h0,wrdata[31:0]);

    //addr1_strip_en1
    USR_REGWR(`DMU_USR_BASE_ADDR+`ADDR1_STRIP_BASE_ADDR+'h4,wrdata[`TB_ADDR_WIDTH-1:32]);
    `endif

    if(starting_phase) starting_phase.drop_objection(this);

  endtask

endclass :apb_strip_addr_seq
`endif