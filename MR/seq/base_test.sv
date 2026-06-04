`define AXI_INCR    2'b01
`define AXI_16B     3'b100
`define AXI_32B     3'b101
`define AXI_64B     3'b110
`define AXI_LEN_0   1'b0
`define AXI_LEN_1   1'b1
`define AXI_QOS_0   3'b000
`define AXI_QOS_1   3'b001
`define AXI_QOS_2   3'b010
`define AXI_QOS_3   3'b011
`define AXI_RESP_OK 2'b00
`define AXI_RESP_EXOKAY 2'b01
`define AXI_RESP_SLVERR 2'b10
`define AXI_RESP_DECERR 2'b11

typedef string line_word_queue[$];

class base_test extends uvm_test;

    `uvm_component_utils(base_test)

    string memclass = "ddr5";

    virtual Jtag_if jtag_if;
    virtual Apb_if apb_if[3];
    virtual Axi_if axi_if[2];
    virtual Misc_if misc_if;

    string reg_name_array[10000];
    string dfs_reg_array[10000];
    string dfs_field_array[10000];
    string reg_addr_array[10000];
    string reg_value_array[10000];

    int csrvalue[string];
    int field_value[string];

    string field_reg_array[20000];
    string field_name_array[20000];
    string field_addr_array[20000];
    string field_offset_array[20000];
    string field_width_array[20000];
    bit [`AXI_ID_W-1:0] awid_pool[2][$];
    bit [`AXI_ID_W-1:0] arid_pool[2][$];
    bit [`AXI_DATA_W*2-1:0] data_q[2][$];
    bit [`AXI_DATA_W*2-1:0] mem_snap[2][int];
    bit [`AXI_DATA_W*2-1:0] mem_shadow[2][int];
    int written_addr[2][$];
    int brsp_written_addr[2][$];
    int wrtrans_rcv[2];
    int rdtrans_rcv[2];

    bit [31:0] up_dram_state[2];
    bit [31:0] up_arb_state[2];
    bit [31:0] up_trefiab[2];
    bit [15:0] up_trefiab_ori[2];
    bit [15:0] up_trefipb[2];
    bit [1:0]  up_refmode[2];
    bit [1:0]  up_refaben[2];
    bit [31:0] up_glb_state[2];
    bit [1:0]  up_dimm_type[2];
    bit        up_dram_type[2];

    bit [15:0] up_cntpost_r0[2];
    bit [15:0] up_cnttrefi_r0[2];
    bit [15:0] up_cntpost_r1[2];
    bit [15:0] up_cnttrefi_r1[2];
    bit [15:0] up_cntpost_r2[2];
    bit [15:0] up_cnttrefi_r2[2];
    bit [15:0] up_cntpost_r3[2];
    bit [15:0] up_cnttrefi_r3[2];
    bit [15:0] up_cntpost_r4[2];
    bit [15:0] up_cnttrefi_r4[2];
    bit [15:0] up_cntpost_r5[2];
    bit [15:0] up_cnttrefi_r5[2];
    bit [15:0] up_cntpost_r6[2];
    bit [15:0] up_cnttrefi_r6[2];
    bit [15:0] up_cntpost_r7[2];
    bit [15:0] up_cnttrefi_r7[2];
    bit [15:0] up_cntpost_r8[2];
    bit [15:0] up_cnttrefi_r8[2];
    bit [15:0] up_cntpost_r9[2];
    bit [15:0] up_cnttrefi_r9[2];
    bit [15:0] up_cntpost_r10[2];
    bit [15:0] up_cnttrefi_r10[2];
    bit [15:0] up_cntpost_r11[2];
    bit [15:0] up_cnttrefi_r11[2];
    bit [15:0] up_cntpost_r12[2];
    bit [15:0] up_cnttrefi_r12[2];
    bit [15:0] up_cntpost_r13[2];
    bit [15:0] up_cnttrefi_r13[2];
    bit [15:0] up_cntpost_r14[2];
    bit [15:0] up_cnttrefi_r14[2];
    bit [15:0] up_cntpost_r15[2];
    bit [15:0] up_cnttrefi_r15[2];
    bit [15:0] up_cntpost_r16[2];
    bit [15:0] up_cnttrefi_r16[2];
    bit [15:0] up_cntpost_r17[2];
    bit [15:0] up_cnttrefi_r17[2];
    bit [15:0] up_cntpost_r18[2];
    bit [15:0] up_cnttrefi_r18[2];
    bit [15:0] up_cntpost_r19[2];
    bit [15:0] up_cnttrefi_r19[2];
    bit [15:0] up_cntpost_r20[2];
    bit [15:0] up_cnttrefi_r20[2];
    bit [15:0] up_cntpost_r21[2];
    bit [15:0] up_cnttrefi_r21[2];
    bit [15:0] up_cntpost_r22[2];
    bit [15:0] up_cnttrefi_r22[2];
    bit [15:0] up_cntpost_r23[2];
    bit [15:0] up_cnttrefi_r23[2];
    bit [15:0] up_cntpost_r24[2];
    bit [15:0] up_cnttrefi_r24[2];
    bit [15:0] up_cntpost_r25[2];
    bit [15:0] up_cnttrefi_r25[2];
    bit [15:0] up_cntpost_r26[2];
    bit [15:0] up_cnttrefi_r26[2];
    bit [15:0] up_cntpost_r27[2];
    bit [15:0] up_cnttrefi_r27[2];
    bit [15:0] up_cntpost_r28[2];
    bit [15:0] up_cnttrefi_r28[2];
    bit [15:0] up_cntpost_r29[2];
    bit [15:0] up_cnttrefi_r29[2];
    bit [15:0] up_cntpost_r30[2];
    bit [15:0] up_cnttrefi_r30[2];
    bit [15:0] up_cntpost_r31[2];
    bit [15:0] up_cnttrefi_r31[2];

    string test_name;

    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
    endfunction : build_phase

    virtual function void error_report();
        $display("--------------------------------------------------------------------------------");
        $display("------------------- /$$$$$$$$ /$$$$$$$  /$$$$$$  /$$$$$$ -------------------");
        $display("------------------- | $$_____/| $$__  $$ /$$__  $$|_  $$_/ -------------------");
        $display("------------------- | $$      | $$  \\ $$| $$  \\__/  | $$   -------------------");
        $display("------------------- | $$$$$   | $$$$$$$/|  $$$$$$   | $$   -------------------");
        $display("------------------- | $$__/   | $$__  $$ \\____  $$  | $$   -------------------");
        $display("------------------- | $$      | $$  \\ $$ /$$  \\ $$  | $$   -------------------");
        $display("------------------- | $$      | $$  | $$|  $$$$$$/ /$$$$$$ -------------------");
        $display("------------------- |__/      |__/  |__/ \\______/ |______/ -------------------");
        $display("test_status: fail!");
        $finish;
    endfunction : error_report

    function line_word_queue handle_line_get_word(input string line);
        line_word_queue ret;
        string line_word="";
        for(int i=0; i< line.len(); i++) begin
            if( (line[i]!= " ") && (line[i]!= ",") ) begin
                line_word = {line_word, line[i]};
                if(i==(line.len()-1)) begin
                    ret.push_back(line_word);
                end
            end else begin
                if (line_word != "") begin
                    ret.push_back(line_word);
                end
                line_word = "";
            end
        end
        return ret;
    endfunction

    function line_word_queue handle_line_get_feild_struct(input string line);
        line_word_queue ret;
        string line_word="";
        for(int i=0; i< line.len(); i++) begin
            if( (line[i]!= " ") && (line[i]!= ":") ) begin
                line_word = {line_word, line[i]};
                if(i==(line.len()-1)) begin
                    ret.push_back(line_word);
                end
            end else begin
                if (line_word != "") begin
                    ret.push_back(line_word);
                end
                line_word = "";
            end
        end
        return ret;
    endfunction

    function void ctl_phy_reg_parser();
        int fh;
        string line;
        string get_define;
        string file_abs_path;
        int line_idx;

        file_abs_path = {`DEMO_ROOT , "/sim/config/csr_define.vh.reglist"};
        fh = $fopen(file_abs_path ,"r");
        if (!fh) begin
            $display($psprintf("Cannot open file %s", file_abs_path ));
            $finish;
        end

        line_idx = 0;
        while ($fgets(line,fh)) begin
            string q[$];
            string line_word;
            q = handle_line_get_word(line);
            reg_name_array[line_idx] = q[0];
            if(q[0].substr(0,2) == "CTL" || q[0].substr(0,7) == "PHY_BIST") begin
                reg_addr_array[line_idx] = q[1];
            end
            else begin
                reg_addr_array[line_idx] = q[1];
            end
            line_idx = line_idx + 1;
            if(line_idx >= $size(reg_addr_array)) begin
                $display("reg_addr_array not big");
                $finish;
            end
        end
    endfunction

    function void ctl_phy_field_parser();
        int fh;
        string line;
        string get_define;
        string file_abs_path;
        int line_idx;

        file_abs_path = {`DEMO_ROOT , "/sim/config/csr_define.vh.fieldlist"};
        fh = $fopen(file_abs_path ,"r");
        if (!fh) begin
            $display($psprintf("Cannot open file %s", file_abs_path ));
            $finish;
        end

        line_idx = 0;
        while ($fgets(line,fh)) begin
            string q[$];
            string line_word;
            q = handle_line_get_word(line);
            field_reg_array[line_idx]   = q[0];
            field_name_array[line_idx]  = q[1];
            if(q[0].substr(0,2) == "CTL") begin
                field_addr_array[line_idx] = q[2];
            end
            else begin
                $display("GG: %0x, %0x, line_idx=%0d", q[2].atohex(), q[2].atohex()+'h2000, line_idx);
                field_addr_array[line_idx] = q[2];
            end
            $display("reg_name:%0s,xx:=%0s, addr=%0s,field_addr_array=%0s", q[0], q[0].substr(0,2), q[2], field_addr_array[line_idx]);

            field_offset_array[line_idx] = q[3];
            field_width_array[line_idx]  = q[4];
            if (field_name_array[line_idx] == "PUM_TOP_PHYONDFI")
                field_value[field_name_array[line_idx]] = 1;
            else
                field_value[field_name_array[line_idx]] = 0;
            line_idx = line_idx + 1;
            if(line_idx >= $size(field_addr_array)) begin
                $display("field_addr_array not big");
                $finish;
            end
        end
    endfunction

    function void ctl_phy_dfs_reg_parser();
        int fh;
        string line;
        string get_define;
        string file_abs_path;
        int line_idx;

        file_abs_path = {`DEMO_ROOT , "/sim/config/dfs_csr_define.vh.fieldlist"};
        fh = $fopen(file_abs_path ,"r");
        if (!fh) begin
            $display($psprintf("Cannot open file %s", file_abs_path ));
            $finish;
        end

        line_idx = 0;
        while ($fgets(line,fh)) begin
            string q[$];
            string line_word;
            q = handle_line_get_word(line);
            dfs_reg_array[line_idx]   = q[0];
            dfs_field_array[line_idx] = q[1];
            line_idx = line_idx + 1;
        end
    endfunction

    function new (input string name, uvm_component parent = null);
        super.new(name, parent);
        $value$plusargs("MEMCLASS=%s", memclass);
    endfunction

    function set(virtual Jtag_if p_jtag_if, virtual Apb_if p_apb_if[],virtual Axi_if p_axi_if[], virtual Misc_if p_misc_if);
        jtag_if    = p_jtag_if;
        apb_if[0]  = p_apb_if[0];
        apb_if[1]  = p_apb_if[1];
        apb_if[2]  = p_apb_if[2];
        axi_if[0]  = p_axi_if[0];
        axi_if[1]  = p_axi_if[1];
        misc_if    = p_misc_if;

        ctl_phy_reg_parser();
        ctl_phy_field_parser();
        ctl_phy_dfs_reg_parser();
        $value$plusargs("UVM_TESTNAME=%s", test_name);
        if(test_name == "uvddr_lpbk_reg" || test_name == "uvddr_lpbk_bist" || test_name == "uvddr_ddl_reg" || test_name == "uvddr_ddl_bist") begin
        end else begin
            parse_csrcfg("ctl_csrconfig_f0.h");
            parse_csrcfg("phy_csrconfig_f0.h");
        end

        for (int ch = 0 ; ch < 2; ch++) begin
            for (int i = 0 ; i < 2**`AXI_ID_W; i++) begin
                awid_pool[ch].push_back(i);
            end
        end

        for (int ch = 0 ; ch < 2; ch++) begin
            for (int i = 0 ; i < 2**`AXI_ID_W; i++) begin
                arid_pool[ch].push_back(i);
            end
        end

    endfunction

    function parse_csrcfg(string csrCfgFile);
        string line;
        int fh= $fopen(csrCfgFile, "r");
        if (!fh) begin
            $display($psprintf("Cannot open csrCfg file %0s",csrCfgFile));
        end
        while ($fgets(line,fh)) begin
            if(line.substr(0,6) == "`define") begin
                string fieldname;
                string fieldvalue;
                string fieldstr;
                int value;
                bit name_start;
                bit value_start;
                int i,j;
                i = 0;
                line = line.substr(109,line.len()-1);
                while(i < line.len()) begin

                    if (line.getc(i) != " " && line.getc(i) != "\n") begin
                        fieldstr = {fieldstr,line.getc(i)};
                    end
                    if (line.getc(i) == " " || line.getc(i) == "\n" ) begin
                        if (fieldstr != "") begin
                            name_start=1;
                            value_start=0;
                            fieldname = "";
                            fieldvalue = "";
                            j = 0;
                            while(j < fieldstr.len())begin
                                if (name_start && fieldstr.getc(j) != ":")
                                    fieldname = {fieldname,fieldstr.getc(j)};
                                if (fieldstr.getc(j) == ":" && name_start)
                                    name_start = 0;

                                if (value_start)
                                    fieldvalue = {fieldvalue,fieldstr.getc(j)};
                                if (fieldstr.getc(j) == "=" && !value_start)
                                    value_start = 1;
                                j++;
                            end
                        end
                            fieldstr = "";
                            fieldvalue = fieldvalue.substr(2,fieldvalue.len()-1);
                            value = fieldvalue.atohex();
                            csrvalue[fieldname] = value;
                        end
                        i++;
                    end
                end else begin
                            continue;
                end
        end
        $fclose(fh);
    endfunction : parse_csrcfg

    virtual task init_ctl_reg(int freq_index=0, bit dfs_only = 0);
        int fh;
        int dfs_reg_index_queue[$];
        string line;
        string get_define;
        string file_abs_path;
        string fidx;

        $display("init_ctl_reg START at %0t", $realtime);
        fidx.itoa(freq_index);
        file_abs_path = { "./ctl_csrconfig_f", fidx, ".h"};
        $display($psprintf(" init_ctl_reg:: file: %s", file_abs_path));

        if(memclass == "ddr5")begin
            set_field_by_apb("CTL_FREQMULTICASTWR", 0);
        end
        set_field_by_apb("CTL_FREQACCEPOINT", freq_index);

        fh = $fopen(file_abs_path ,"r");
        if (!fh) begin
            $display($psprintf("Cannot open file"));
            $finish;
        end
        while ($fgets(line,fh)) begin
            string q[$];
            string line_word;

            q = handle_line_get_word(line);

            if(q[0] == "`define") begin
                string name;
                string value;
                string ch;
                name = q[1].substr(0,(q[1].len-6));
                value = q[2].substr(4,(q[2].len-1));
                if(name.substr(0,2) == "CTL") begin
                    string call_name;
                    ch = 0;
                    call_name = name.substr(4,(name.len-1));
                    if (dfs_only) begin
                        dfs_reg_index_queue = dfs_reg_array.find_first_index with (item == name);
                        if (dfs_reg_index_queue.size() == 0) begin
                            $display("Skipping reg %0s",name);
                            continue;
                        end
                    end
                    if (call_name == "CSRFREQACCE") begin
                        $display("CTL_FREQACCEPOINT/CTL_FREQMULTICASTWR skip");
                    end else begin
                        $display("call_name=%s, name=%s, value=%32b, ch=%s", call_name, name, value.atobin, ch);
                        set_reg_by_apb(name,value.atobin);
                    end

                end else begin

                    if (name=="PUM_TOP_CSRCHANSEL" || name=="PUM_TOP_CSRCSRACCESSCTRL" || name=="PUM_TOP_CSRCHANSEL" ) begin
                        $display($psprintf("%s do not need csr_load", name));
                    end else begin
                        if (dfs_only) begin
                            dfs_reg_index_queue = dfs_reg_array.find_first_index with (item == name);
                            if (dfs_reg_index_queue.size() == 0) begin
                                $display("Skipping reg %0s",name);
                                continue;
                            end
                        end
                        set_reg_by_apb(name,value.atobin);
                    end
                end
            end
        end
        $display("init_ctl_reg END at %0t", $realtime);
    endtask

    virtual task gen_firmware();
        string cmd_firmware;
        int firmware_define_file;
        int firmware_file;

        if((memclass == "ddr4") || (memclass == "ddr5"))begin
            $display("Test mem type is DDR", $time);
            firmware_file = $fopen($psprintf("firmware_mpu_file.h"),"r");
            if (!firmware_file) begin
                $display($psprintf("Cannot open file: firmware_mpu_file.h"));
                $finish;
            end else begin
                $fclose(firmware_file);
                misc_if.proc_sram_firmware_ready = 1;
                #100ns;
                misc_if.proc_sram_firmware_check = 1;
            end
        end

        if((memclass == "lpddr4") || (memclass == "lpddr5"))begin
            $display("Test mem type is LPDDR", $time);

            misc_if.proc_sram_firmware_lp54_ready_instruction = 1;
            misc_if.proc_sram_firmware_lp54_ready_data        = 1;
            misc_if.proc_sram_firmware_lp54_check_instruction = 0;
            misc_if.proc_sram_firmware_lp54_check_data        = 0;
            misc_if.ddr5_connect = 0;
        end

        $display("AAAAAAAAAA, misc_if.proc_sram_firmware_ready=%0d", misc_if.proc_sram_firmware_ready, $time);
        $display("AAAAAAAAAA, misc_if.proc_sram_firmware_check=%0d", misc_if.proc_sram_firmware_check, $time);
        $display("AAAAAAAAAA, misc_if.proc_sram_firmware_lp54_ready_instruction=%0d", misc_if.proc_sram_firmware_lp54_ready_instruction, $time);
        $display("AAAAAAAAAA, misc_if.proc_sram_firmware_lp54_ready_data=%0d", misc_if.proc_sram_firmware_lp54_ready_data, $time);
        $display("AAAAAAAAAA, misc_if.proc_sram_firmware_lp54_check_instruction=%0d", misc_if.proc_sram_firmware_lp54_check_instruction, $time);
        $display("AAAAAAAAAA, misc_if.proc_sram_firmware_lp54_check_data=%0d", misc_if.proc_sram_firmware_lp54_check_data, $time);
    endtask

    virtual task init_phy_reg(int freq_index=0, bit dfs_only = 0);

        int fh;
        int dfs_reg_index_queue[$];
        string line;
        string get_define;
        string file_abs_path;
        string fidx;

        $display("init_phy_reg START at %0t", $realtime);
        fidx.itoa(freq_index);
        file_abs_path = { "./phy_csrconfig_f", fidx, ".h"};
        $display($psprintf("init_phy_reg:: file: %s", file_abs_path));

        set_field_by_apb("PUM_TOP_DATAFREQACCEPOINT", freq_index);
        set_field_by_apb("PUM_TOP_FREQACCEPOINT", freq_index);
        set_field_by_apb("PUM_TOP_RANKMULTICASTWR", 1'b1);
        set_field_by_apb("PUM_TOP_DEVMULTICASTWR", 1'b1);
        set_field_by_apb("PUM_TOP_LANEMULTICASTWR", 1'b0);

        fh = $fopen(file_abs_path ,"r");
        if (!fh) begin
            $display($psprintf("Cannot open file"));
            $finish;
        end
        while ($fgets(line,fh)) begin
            string q[$];
            string line_word;

            q = handle_line_get_word(line);

            if(q[0] == "`define") begin
                string name;
                string value;
                string ch;
                name = q[1].substr(0,(q[1].len-6));
                value = q[2].substr(4,(q[2].len-1));

                if (name=="PUM_TOP_CSRCSRACCESSCTRL0" || name=="PUM_TOP_CSRCSRACCESSCTRL1") begin
                    $display($psprintf("%s do not need csr_load", name));
                end else begin
                    if (dfs_only) begin
                        dfs_reg_index_queue = dfs_reg_array.find_first_index with (item == name);
                        if (dfs_reg_index_queue.size() == 0) begin
                            $display("Skipping reg %0s",name);
                            continue;
                        end
                    end
                    set_reg_by_apb(name,value.atobin);
                end
            end
        end

        set_field_by_apb("PUM_TOP_RANKMULTICASTWR", 1'b0);
        set_field_by_apb("PUM_TOP_DEVMULTICASTWR", 1'b0);

        if(memclass == "ddr4")begin
            $display("Start DDR4 register config here", $realtime);
            set_field_by_apb("PUM_TOP_FREQMULTICASTWR", 1'b1);
            set_field_by_apb("PUM_TOP_RANKMULTICASTWR", 1'b1);
            set_field_by_apb("PUM_TOP_LANEMULTICASTWR", 1'b0);
            for(int i=0; i< 2; i++) begin
                set_field_by_apb($sformatf("LVLDARR_DLANE%0dDARRAYDLY%0d",9,6+i), 'h0c0);
            end
            for(int i=0; i< 9; i++) begin
                set_field_by_apb($sformatf("LVLDARR_DLANE%0dDARRAYDLY%0d",9,8+i), 'h080);
            end
        end

        $display("init_phy_reg END at %0t", $realtime);
    endtask

    virtual task start_phy();
        $display("start_phy START at %0t", $realtime);
        set_field_by_apb("PUM_TOP_MPU01HWSEL",1'b1);
        set_field_by_apb("PUM_TOP_MPUEN",1'b1);
        set_field_by_apb("PUM_TOP_MPUGO",1'b1);

        $display("start_phy END at %0t", $realtime);
    endtask

    virtual task init_phy_mpu();
        string test_name;
        int fh;
        int idx;
        string line;
        string get_define;
        string file_abs_path;
        int csr_inst_idx;

        string insNum;
        bit[140:0] insValue;
        bit[31:0] seq_value;
        bit[31:0] seq_index;

        file_abs_path = "./firmware_ddr_seq_file.h";
        $display($psprintf("firmware_ddr_seq_file:: file: %s", file_abs_path));
        fh = $fopen(file_abs_path, "r");
        if (!fh) begin
            $display($psprintf("Cannot open file"));
            $finish;
        end

        while ($fgets(line, fh)) begin
            if ($sscanf(line, "%*5s%141b", insValue)) begin
                for (int i = 0 ; i < 5 ; i++) begin
                    if (seq_index < 210) begin
                        seq_value = (insValue >> 32*i) & 'hFFFF_FFFF;
                        set_field_by_apb($psprintf("DFISEQ_DFISEQ%0d",seq_index), seq_value);
                        seq_index++;
                    end
                end
            end
        end
        $fclose(fh);

    endtask

    virtual task load_firmware(string FwFile);
        int inscnt = -1;
        string line;
        string insNum;
        int insValue;
        bit cmpRslt;
        bit csrErr;
        bit brchErr;
        int fhFw = $fopen(FwFile, "r");
        string mpu_curr_cmd_code;
        string mpu_curr_cmd_idx_tmp;
        bit cmpCmdRslt;
        string tag, key, value;
        int mpu_curr_cmd_idx;

        $display("Load fw firmware_mpu_file.h START @%0t", $realtime);
        if (!fhFw) begin
            $display($psprintf("Cannot open firmware file %0s", FwFile));
        end

        while ($fgets(line, fhFw)) begin

            cmpRslt = uvm_re_match("/.define*/", line);
            if(cmpRslt) begin
                continue;
            end
            csrErr = uvm_re_match(uvm_glob_to_re("`define*CSR_ERROR*"), line);
            brchErr = uvm_re_match(uvm_glob_to_re("`define*BRCH_ERROR*"), line);

            if ($sscanf(line, "%*s %s %*4s %16b", insNum, insValue)) begin
                `uvm_info(get_type_name(), $psprintf("inscnt = %0d, insNum = %0s, insValue = %0x", inscnt, insNum, insValue), UVM_HIGH);
                set_field_by_apb(insNum, insValue);
                if(!csrErr) begin
                    $display($sformatf("%s exists csr error, please check it!", insNum));
                end
                else if(!brchErr) begin
                    $display($sformatf("%s exists brch error which out of range, please check it!", insNum));
                end
            end
        end

        $fclose(fhFw);
        $display("Load fw firmware_mpu_file.h END @%0t", $realtime);
    endtask : load_firmware

    virtual task load_prgm_file();
        string test_name;
        int fh;
        int idx;
        string line;
        string get_define;
        string file_abs_path;
        int csr_inst_idx;

        string insNum;
        bit[31:0] insValue;
        bit[31:0] seq_value;
        bit[31:0] seq_index;

        $display("Load fw firmware_prgm_file.h START @%0t", $realtime);
        fh = $fopen("firmware_prgm_file.h", "r");
        if(!fh)begin
            $display($psprintf("Cannot open file"));
            $finish;
        end

        while($fgets(line, fh))begin
            if(line.substr(0,6) != "`define") begin
                continue;
            end

            if ($sscanf(line, "%*s %s %*4s %32b", insNum, insValue)) begin
                $display($psprintf("insNum = %0s, insValue = %0x", insNum, insValue));
                set_field_by_apb(insNum, insValue);
            end
        end
        $fclose(fh);
        $display("Load fw firmware_prgm_file.h END @%0t", $realtime);

    endtask : load_prgm_file

    virtual task init_ctl_perf_reg();

        $display("Excute init_ctl_perf_reg task", $time);

        set_field_by_apb("CTL_FREQACCEPOINT",      0);
        set_field_by_apb("CTL_PREIDLEBANKTIME",    0);
        set_field_by_apb("CTL_REFABEN",            1);
        set_field_by_apb("CTL_APENABLE",           0);

        set_field_by_apb("CTL_CTRLUPDEN"           , 0);
        set_field_by_apb("CTL_PHYUPDEN"            , 1);
        set_field_by_apb("CTL_PHYMSTREN"           , 1);
        set_field_by_apb("CTL_REFPOSTEN"           , 1);
        set_field_by_apb("CTL_SREN"                , 0);
        set_field_by_apb("CTL_AXICGEN"             , 0);
        set_field_by_apb("CTL_ZQCALSWEN"           , 0);
        set_field_by_apb("CTL_PDNEN"               , 0);
        set_field_by_apb("CTL_SWDFSEN"             , 0);

        set_field_by_apb("CTL_HPRCREDIT"           , 16);
        set_field_by_apb("CTL_LPRCREDIT"           , 16);
        set_field_by_apb("CTL_TPWCREDIT"           , 32);
        set_field_by_apb("CTL_GPWEXPIREDTIME"      , 0);
        set_field_by_apb("CTL_GPREXPIREDTIME"      , 0);

        set_field_by_apb("CTL_DFILPENSR"           , 0);
        set_field_by_apb("CTL_DFILPENPD"           , 0);


        set_field_by_apb("CTL_PARDWRSWITCHFAST", 1);


        set_field_by_apb("CTL_MAXRWBEFORESWITCH", 16);
        set_field_by_apb("CTL_OPPHITCNT", 8);
        set_field_by_apb("CTL_MODESWITCHPOLICY", 0);


        set_field_by_apb("CTL_HPRMAXSTARVE"        , 1000);
        set_field_by_apb("CTL_HPRCMDRUNLEN"        , 16);
        set_field_by_apb("CTL_LPRMAXSTARVE"        , 0);
        set_field_by_apb("CTL_LPRCMDRUNLEN"        , 16);
        set_field_by_apb("CTL_TPWMAXSTARVE"        , 1000);
        set_field_by_apb("CTL_TPWCMDRUNLEN"        , 16);
        set_field_by_apb("CTL_CQWRCAMHIGHTHR"      , 31);
        set_field_by_apb("CTL_CQWRCAMLOWTHR"       , 8);
        set_field_by_apb("CTL_CQPREFERHITHPR"      , 1);
        set_field_by_apb("CTL_CQRDHITLIMIT"        , 0);
        set_field_by_apb("CTL_CQWRHITLIMIT"        , 0);
        set_field_by_apb("CTL_CQWRCOMBINEEN"       , 1);
        set_field_by_apb("CTL_CQRDCMDAGINGLIMIT", 64);
        set_field_by_apb("CTL_CQWRCMDAGINGLIMIT", 64);


        set_field_by_apb("CTL_RDREGION0FIELD", 0);
        set_field_by_apb("CTL_RDREGION1FIELD", 0);
        set_field_by_apb("CTL_RDREGION2FIELD", 0);
        set_field_by_apb("CTL_WRREGION0FIELD", 0);
        set_field_by_apb("CTL_WRREGION1FIELD", 0);

    endtask

    virtual task config_ctl_reg();
        $display($psprintf("%0t,  START config_ctl_reg",$time));

        if(memclass == "lpddr5")begin

            set_field_by_apb("CTL_FREQINIT", 1);
            set_field_by_apb("CTL_FREQRATIOINIT", 2);
            set_field_by_apb("CTL_FREQFSPINIT", 2);

            set_field_by_apb("CTL_FREQHW0", 0);
            set_field_by_apb("CTL_FREQRATIOHW0", 1);
            set_field_by_apb("CTL_FREQFSPHW0", 0);

            set_field_by_apb("CTL_FREQHW1", 1);
            set_field_by_apb("CTL_FREQRATIOHW1", 2);
            set_field_by_apb("CTL_FREQFSPHW1", 2);

            set_field_by_apb("CTL_FREQHW2", 2);
            set_field_by_apb("CTL_FREQRATIOHW2", 1);
            set_field_by_apb("CTL_FREQFSPHW2", 2);

            set_field_by_apb("CTL_FREQHW3", 3);
            set_field_by_apb("CTL_FREQRATIOHW3", 1);
            set_field_by_apb("CTL_FREQFSPHW3", 0);

            set_field_by_apb("CTL_FREQHW4", 4);
            set_field_by_apb("CTL_FREQRATIOHW4", 1);
            set_field_by_apb("CTL_FREQFSPHW4", 1);

            set_field_by_apb("CTL_ZQCALSWEN", 1);
            set_field_by_apb("CTL_IECCEN", 0);
            set_field_by_apb("CTL_ERRSTATE0MASK", 0);
            set_field_by_apb("CTL_ERRSTATE1MASK", 0);
            set_field_by_apb("CTL_ERRSTATE2MASK", 0);

            set_field_by_apb("CTL_MCMASTEREN", 1'b1, 1);
            set_field_by_apb("CTL_MCMASTEREN", 1'b0, 2);
            set_field_by_apb("CTL_MCHASSLAVE", 1'b1, 1);
            set_field_by_apb("CTL_MCHASSLAVE", 1'b0, 2);

            set_field_by_apb("CTL_REFPOSTPB2ABTHR", 32'hc5);

            set_field_by_apb("CTL_FREQACCEPOINT", 0);
        end

        $display($psprintf("%0t,  END config_ctl_reg",$time));
    endtask

    virtual task start_ctl();
        $display($psprintf("%0t,  start_ctl",$time));

        set_field_by_apb("CTL_MCSTART",1'b1);

        begin
            bit[31:0] init_complete = 0;
            while(1) begin
                get_field_by_apb("CTL_DFSCOMPLETE", init_complete, 1);
                if(init_complete == 1) begin
                    break;
                end
            end

            while(1) begin
                get_field_by_apb("CTL_DFSCOMPLETE", init_complete, 2);
                if(init_complete == 1) begin
                    break;
                end
            end
        end

        #1000ns;
        $display($psprintf("%0t, init complete",$time));
    endtask

    virtual task Mpu_init();
        int dfi_frequency = ( 0 + 1 ) % 1;

        $display("Mpu_init START at %0t", $realtime);
        set_field_by_apb("PUM_TOP_WORKFREQ", 0);
        set_field_by_apb("PUM_TOP_FREQNUM", 1);
        if(test_name == "uvddr_dfs_test") begin
            set_field_by_apb("PUM_TOP_FREQNUM", 2);
            $display("test_name is %s",test_name);
        end

        set_field_by_apb("PUM_TOP_DFIFREQUENCY",{dfi_frequency[4:0],1'b1});

        set_field_by_apb("PUM_TOP_NTODTCSMAP0", 0);
        set_field_by_apb("PUM_TOP_NTODTCSMAP1", 0);
        set_field_by_apb("PUM_TOP_NTODTCSMAP2", 0);
        set_field_by_apb("PUM_TOP_NTODTCSMAP3", 0);
        $display("Mpu_init END at %0t", $realtime);
    endtask: Mpu_init

    virtual task Mpu_init_lpddr();

        $display("LPDDR Mpu_init START at %0t", $realtime);
        set_field_by_apb("PUM_TOP_WORKFREQ", 1);
        if(test_name == "uvddr_dfs_test") begin
            set_field_by_apb("PUM_TOP_FREQNUM", 3);
            $display("test_name is %s",test_name);
        end
        else begin
            set_field_by_apb("PUM_TOP_FREQNUM", 2);
        end

        set_field_by_apb("PUM_TOP_CMDENGADDRDFLT", 0);
        $display("LPDDR Mpu_init END at %0t", $realtime);
    endtask: Mpu_init_lpddr

    virtual task pll_init_bypass();
        int valid_freq_num = 1;
        set_field_by_apb("PUM_TOP_FREQMULTICASTWR", 0);
        if(test_name == "uvddr_dfs_test") begin
            valid_freq_num = 2;
        end
        for (int freq = 0; freq < valid_freq_num; freq++) begin
            set_field_by_apb("PUM_TOP_FREQACCEPOINT", freq);
            set_field_by_apb("PUM_TOP_PLLBYPMODE", 1);
        end
    endtask: pll_init_bypass

    virtual task ddr5rdimm_cai_init();

        bit [ 9:0] m_cai_sidebmap;
        bit [31:0] m_devside_info;
        m_devside_info = '1;
        m_cai_sidebmap = 10'b0000000000;

        $display("ddr5rdimm_cai_init START at %0t", $realtime);



        set_field_by_apb("PUM_TOP_DEVSIDE", 32'hffffffff);
        set_field_by_apb("PUM_TOP_DEVSIDE1", 32'hffffffff);
        set_field_by_apb("PUM_TOP_LVLENGSIDEBMAP", 32'h0);
        set_field_by_apb("PUM_TOP_CHASIDEAFIRSTDEV", 32'h0);
        set_field_by_apb("PUM_TOP_CHASIDEBFIRSTDEV", 32'h0);
        set_field_by_apb("PUM_TOP_CHBSIDEAFIRSTDEV", 32'h0);
        set_field_by_apb("PUM_TOP_CHBSIDEBFIRSTDEV", 32'h0);

        set_field_by_apb("PUM_TOP_DCALVLSMPNUM", 1 );
        set_field_by_apb("PUM_TOP_CALVLSMPNUM", 1 );


        set_field_by_apb("PUM_TOP_FREQMULTICASTWR", 1);
        set_field_by_apb("PUM_TOP_INITLVLEN", 8'b0);
        set_field_by_apb("PUM_TOP_FREQMULTICASTWR", 0);
        $display("ddr5rdimm_cai_init END at %0t", $realtime);
    endtask: ddr5rdimm_cai_init

    virtual task set_reg_by_apb (input string reg_name, input bit[31:0] wdata, input logic[2:0] apb_bitmap=0);
        int reg_idx;
        int reg_idx_queue[$];
        int addr;
        logic[2:0] apb_bitmap_name = 0;

        if(reg_name.substr(0,2) == "CTL") begin
            apb_bitmap_name = 3'h3;
        end
        else begin
            apb_bitmap_name = 3'h4;
        end
        if(apb_bitmap!=0) begin
            apb_bitmap_name = apb_bitmap;
        end

        reg_idx_queue = reg_name_array.find_first_index with (item == reg_name);
        if(reg_idx_queue.size()>0) begin
            reg_idx = reg_idx_queue[0];
            addr = reg_addr_array[reg_idx].atohex();
        end else begin
            $display($psprintf("INFO=: invalid reg_name=%s", reg_name));
            addr = 0;
            $finish;
        end

        for(int i=0; i<3; i++) begin
            if(apb_bitmap_name[i] == 1) begin
                @(posedge apb_if[i].clk);
                #1ps;
                apb_if[i].paddr = addr;
                apb_if[i].pwdata = wdata;
                apb_if[i].psel = 1;
                apb_if[i].pstrb = 4'b1111;
                apb_if[i].pwrite = 1;
                @(posedge apb_if[i].clk);
                #1ps;
                apb_if[i].penable = 1;
                @(negedge apb_if[i].pready);
                #1ps;
                apb_if[i].psel = 0;
                apb_if[i].penable = 0;
                @(posedge apb_if[i].clk);
            end
        end
        $display($psprintf("%0t, Set register:name:%s, addr(0x%0h) = value('h%0h), sys_addr=%0h",$time, reg_name, addr, wdata, (addr<<2)));
    endtask

    virtual task wait_field(input string field_name, bit[31:0] field_rdata);

        while(1) begin
            bit[31:0] rd_data = 0;
            get_field_by_apb(field_name, rd_data);
            if(field_rdata == rd_data) begin
                break;
            end
        end
    endtask

    virtual task get_reg_by_apb (input string reg_name, output bit[31:0] rdata, input logic[2:0] apb_bitmap=0);
        int reg_idx;
        int reg_idx_queue[$];
        int addr;
        logic[2:0] apb_bitmap_name = 0;

        if(reg_name.substr(0,2) == "CTL") begin
            apb_bitmap_name = 3'h1;
        end
        else begin
            apb_bitmap_name = 3'h4;
        end
        if(apb_bitmap!=0) begin
            apb_bitmap_name = apb_bitmap;
        end

        reg_idx_queue = reg_name_array.find_first_index with (item == reg_name);
        if(reg_idx_queue.size()>0) begin
            reg_idx = reg_idx_queue[0];
            addr = reg_addr_array[reg_idx].atohex();
        end else begin
            $display($psprintf("INFO=: invalid reg_name=%s", reg_name));
            addr = 0;
            $finish;
        end
        for(int i=0; i<3; i++) begin
            if(apb_bitmap_name[i] == 1) begin
                @(posedge apb_if[i].clk);
                #1ps;
                apb_if[i].paddr = addr;
                apb_if[i].pwdata = 0;
                apb_if[i].psel = 1;
                apb_if[i].pstrb = 0;
                apb_if[i].pwrite = 0;
                @(posedge apb_if[i].clk);
                #1ps;
                apb_if[i].penable = 1;
                @(negedge apb_if[i].pready);
                #1ps;
                apb_if[i].psel = 0;
                apb_if[i].penable = 0;
                rdata = apb_if[i].prdata;
                @(posedge apb_if[i].clk);
            end
        end
        $display($psprintf("Get register:name:%s, addr(0x%0h) = value('h%0h)",reg_name, addr, rdata));
    endtask

    virtual task set_field_by_apb (input string field_name, input bit[31:0] wdata, input logic[2:0] apb_bitmap=0);
        int field_idx;
        int field_idx_queue[$];
        int addr;
        int offset;
        int width;
        logic[2:0] apb_bitmap_name = 0;

        if(field_name.substr(0,2) == "CTL") begin
            apb_bitmap_name = 3'h3;
        end
        else begin
            apb_bitmap_name = 3'h4;
        end
        if(apb_bitmap!=0) begin
            apb_bitmap_name = apb_bitmap;
        end

        field_idx_queue = field_name_array.find_first_index with (item == field_name);
        if(field_idx_queue.size()>0) begin
            field_idx = field_idx_queue[0];
        end else begin
            $display($psprintf("INFO=: invalid field_name=%s", field_name));
            field_idx = 0;
            $finish;
        end
        addr   = field_addr_array[field_idx].atohex();
        offset = field_offset_array[field_idx].atoi();
        width  = field_width_array[field_idx].atoi();

        for(int i=0; i<3; i++) begin
            if(apb_bitmap_name[i] == 1) begin
                @(posedge apb_if[i].clk);
                #1ps;
                apb_if[i].paddr = addr;
                apb_if[i].pwdata = wdata << offset;
                apb_if[i].psel = 1;
                apb_if[i].pstrb = ((2**(width/9 + 1))-1) << (offset/8);
                apb_if[i].pwrite = 1;
                @(posedge apb_if[i].clk);
                #1ps;
                apb_if[i].penable = 1;
                @(negedge apb_if[i].pready);
                #1ps;
                apb_if[i].psel = 0;
                apb_if[i].penable = 0;
                @(posedge apb_if[i].clk);
            end
        end
        $display($psprintf("%0t, Set field:name:%s, addr(0x%0h) = value('h%0h), sys_addr=%0h",$time, field_name, addr, wdata, (addr<<2)));
    endtask

    virtual task get_field_by_apb (input string field_name, output bit[31:0] rdata, input logic[2:0] apb_bitmap=0);
        int field_idx;
        int field_idx_queue[$];
        int addr;
        int offset;
        int width;
        int rdata_temp;
        logic[2:0] apb_bitmap_name = 0;

        if(field_name.substr(0,2) == "CTL") begin
            apb_bitmap_name = 3'h1;
        end
        else begin
            apb_bitmap_name = 3'h4;
        end
        if(apb_bitmap!=0) begin
            apb_bitmap_name = apb_bitmap;
        end

        field_idx_queue = field_name_array.find_first_index with (item == field_name);
        if(field_idx_queue.size()>0) begin
            field_idx = field_idx_queue[0];
        end else begin
            $display($psprintf("INFO=: invalid field_name=%s", field_name));
            field_idx = 0;
            $finish;
        end
        addr   = field_addr_array[field_idx].atohex();
        offset = field_offset_array[field_idx].atoi();
        width  = field_width_array[field_idx].atoi();

        for(int ii=0; ii<3; ii++) begin
            if(apb_bitmap_name[ii] == 1) begin
                @(posedge apb_if[ii].clk);
                #1ps;
                apb_if[ii].paddr = addr;
                apb_if[ii].pwdata = 0;
                apb_if[ii].psel = 1;
                apb_if[ii].pstrb = 0;
                apb_if[ii].pwrite = 0;
                @(posedge apb_if[ii].clk);
                #1ps;
                apb_if[ii].penable = 1;
                @(negedge apb_if[ii].pready);
                #1ps;
                apb_if[ii].psel = 0;
                apb_if[ii].penable = 0;

                rdata = apb_if[ii].prdata;
                rdata_temp = 0;
                for (int i = offset+width-1 ; i >= offset; i--) begin
                    rdata_temp = rdata_temp << 1;
                    rdata_temp[0] = rdata[i];
                end
                rdata = rdata_temp;
                @(posedge apb_if[ii].clk);
            end
        end
        $display($psprintf("%0t, Get field:name:%s, addr(0x%0h) = value('h%0h), width is %0h, offset is %0h",$time, field_name, addr, rdata, width, offset));
    endtask

    virtual task get_reg_by_jtag (input string reg_name, output bit[31:0] rdata);
        int reg_idx;
        int reg_idx_queue[$];
        bit [31:0] trans;
        bit [13:0] addr;
        bit bist;

        reg_idx_queue = reg_name_array.find_first_index with (item == reg_name);
        if(reg_idx_queue.size()>0) begin
            reg_idx = reg_idx_queue[0];
            if (reg_name.substr(0,7) == "PHY_BIST") begin
                bist = 1;
                addr = reg_addr_array[reg_idx].atoi();
            end else begin
                bist = 0;
                addr = reg_addr_array[reg_idx].atohex();
            end
        end else begin
            $display($psprintf("INFO=: invalid reg_name=%s", reg_name));
            addr = 0;
            $finish;
        end

        @(negedge jtag_if.tck);
        #1ps;
        jtag_if.ir_flag = 1;

        jtag_if.ir_trans = 'b1001;
        if (bist == 1)
            jtag_if.dr_trans = {bist,1'b1,1'b0,addr};
        else
            jtag_if.dr_trans = {bist,1'b0,1'b0,addr};
        jtag_if.ir_cnt = 2;
        jtag_if.dr_cnt = 14;
        jtag_if.instr_cnt = 1;
        jtag_if.wait_cnt = 0;
        wait(jtag_if.state== 'h8);

        jtag_if.ir_trans = 'b1011;
        jtag_if.dr_trans = 16'hFFFF;
        jtag_if.ir_cnt = 2;
        jtag_if.dr_cnt = 0;
        jtag_if.instr_cnt = 2;
        jtag_if.wait_cnt = 0;
        wait(jtag_if.state== 'h1);

        wait(jtag_if.state== 'h8);

        jtag_if.ir_trans = 'b1010;
        jtag_if.ir_cnt = 2;
        jtag_if.dr_cnt = 30;
        jtag_if.instr_cnt = 3;
        jtag_if.wait_cnt = 48;

        wait(jtag_if.state== 'h4);

        for(int tdo_index = 0; tdo_index < 32; tdo_index++) begin
            @(posedge jtag_if.tck);
            trans[tdo_index] = jtag_if.tdo;
        end
        rdata = trans;

        wait(jtag_if.state== 'h8);
        wait(jtag_if.state== 'h1);
        $display($psprintf("Get field by jtag :name:%s,bist=%0d, addr(0x%0h) = value('h%0h)", reg_name, bist, addr, rdata));

    endtask

    virtual task set_reg_by_jtag (input string reg_name, input bit[31:0] wdata);
        int reg_idx;
        int reg_idx_queue[$];
        bit [13:0] addr;
        bit bist;

        reg_idx_queue = reg_name_array.find_first_index with (item == reg_name);
        if(reg_idx_queue.size()>0) begin
            reg_idx = reg_idx_queue[0];
            if (reg_name.substr(0,7) == "PHY_BIST") begin
                bist = 1;
                addr = reg_addr_array[reg_idx].atoi();
            end else begin
                bist = 0;
                addr = reg_addr_array[reg_idx].atohex();
            end
        end else begin
            $display($psprintf("INFO=: invalid reg_name=%s", reg_name));
            addr = 0;
            $finish;
        end

        @(negedge jtag_if.tck);
        #1ps;
        jtag_if.ir_flag = 1;

        jtag_if.ir_trans = 'b1001;
if (bist == 1)
            jtag_if.dr_trans = {bist,1'b1,1'b1,addr};
        else
            jtag_if.dr_trans = {bist,1'b0,1'b1,addr};
        jtag_if.ir_cnt = 2;
        jtag_if.dr_cnt = 14;
        jtag_if.wait_cnt = 0;
        jtag_if.instr_cnt = 1;

        wait(jtag_if.state== 'h8);

        jtag_if.ir_trans = 'b1010;
        jtag_if.dr_trans = wdata;
        jtag_if.ir_cnt = 2;
        jtag_if.dr_cnt = 30;
        jtag_if.wait_cnt = 0;
        jtag_if.instr_cnt = 2;
        wait(jtag_if.state== 'h1);
        wait(jtag_if.state== 'h8);

        jtag_if.ir_trans = 'b1011;
        jtag_if.dr_trans = 'hFF;
        jtag_if.ir_cnt = 2;
        jtag_if.dr_cnt = 0;
        jtag_if.instr_cnt = 3;
        jtag_if.wait_cnt = 0;
        wait(jtag_if.state== 'h1);
        wait(jtag_if.state== 'h8);
        wait(jtag_if.state== 'h1);
        $display($psprintf("Set field by jtag :name:%s,bist=%0d, addr(0x%0h) = value('h%0h)", reg_name, bist, addr, wdata));

    endtask

    virtual task set_field_by_jtag (input string field_name, input bit[31:0] wdata);
        int field_idx;
        int field_idx_queue[$];
        int reg_idx_queue[$];
        int addr;
        int offset;
        int width;
        string reg_name;
        bit [31:0] reg_data;

        field_idx_queue = field_name_array.find_first_index with (item == field_name);
        if(field_idx_queue.size()>0) begin
            field_idx = field_idx_queue[0];
        end else begin
            $display($psprintf("INFO=: invalid field_name=%s", field_name));
            field_idx = 0;
            $finish;
        end
        addr   = field_addr_array[field_idx].atohex();
        offset = field_offset_array[field_idx].atoi();
        width  = field_width_array[field_idx].atoi();
        reg_data = wdata << offset;

        reg_name = field_reg_array[field_idx];
        reg_idx_queue = field_reg_array.find_index with (item == reg_name);
        foreach (reg_idx_queue[i]) begin
            if (reg_idx_queue[i] == field_idx) begin
                $display("Same field found, skip");
                continue;
            end
            else begin
                offset = field_offset_array[reg_idx_queue[i]].atoi();
                reg_data = reg_data | (field_value[field_name_array[reg_idx_queue[i]]] << offset);
                $display("found %0s, value is %0d reg_data is %0h",field_name_array[reg_idx_queue[i]],field_value[field_name_array[reg_idx_queue[i]]],reg_data);
            end
        end

        field_value[field_name] = wdata;
        set_reg_by_jtag(reg_name,reg_data);
        $display($psprintf("%0t, Set field:name:%s, addr(0x%0h) = value('h%0h)",$time, field_name, addr, wdata));
    endtask

    virtual task get_field_by_jtag (input string field_name, output bit[31:0] rdata, input bit[31:0] ch=16 );

        int field_idx;
        int field_idx_queue[$];
        int addr;
        int offset;
        int width;
        int rdata_temp;
        int rdata_reg;
        string reg_name;

        field_idx_queue = field_name_array.find_first_index with (item == field_name);
        if(field_idx_queue.size()>0) begin
            field_idx = field_idx_queue[0];
        end else begin
            $display($psprintf("INFO=: invalid field_name=%s", field_name));
            field_idx = 0;
            $finish;
        end
        addr   = field_addr_array[field_idx].atohex();
        offset = field_offset_array[field_idx].atoi();
        width  = field_width_array[field_idx].atoi();

        reg_name = field_reg_array[field_idx];

        get_reg_by_jtag(reg_name,rdata_reg);
        rdata_temp = 0;
        for (int i = offset+width-1 ; i >= offset; i--) begin
            rdata_temp = rdata_temp << 1;
            rdata_temp[0] = rdata_reg[i];
        end
        rdata = rdata_temp;
        $display($psprintf("Get register:name:%s, addr(0x%0h) = value('h%0h)",reg_name, addr, rdata));
    endtask

    task set_field (input string reg_name, input bit [31:0] wdata);
        if ($test$plusargs("JTAG"))
            set_field_by_jtag(reg_name,wdata);
        else
            set_field_by_apb(reg_name,wdata);
    endtask : set_field

    task get_field (input string reg_name, output bit [31:0] rdata);
        if ($test$plusargs("JTAG"))
            get_field_by_jtag(reg_name,rdata);
        else
            get_field_by_apb(reg_name,rdata);
    endtask : get_field

    function int rand_axi_addr();
        int gen_addr;
        static int index = 'h0;
        gen_addr = 'h0 + ('h100)*index;
        index++;
        return gen_addr;
    endfunction:rand_axi_addr

    function int find_index_by_id(input bit [`AXI_ID_W-1:0] id, input int ch);
        automatic int m_ch = ch;
        for(int i = 0 ; i < awid_pool[m_ch].size(); i++) begin
            if (awid_pool[m_ch][i] == id)
                return 0;
        end
        return 1;
    endfunction : find_index_by_id

    task send_write_command (input logic [`AXI_ADDR_W-1:0] addr, input logic [`AXI_ID_W-1:0] id, input logic [1:0] burst, input logic [2:0] size, input logic [2:0] len, input logic [`AXI_QOS_W-1:0] qos, input int ch);
        automatic logic [`AXI_ADDR_W-1:0] m_addr = addr;
        automatic logic [`AXI_ID_W-1:0] m_id = id;
        automatic logic [1:0] m_burst = burst;
        automatic logic [2:0] m_size = size;
        automatic logic [`AXI_LEN_W-1:0] m_len = len;
        automatic logic [`AXI_QOS_W-1:0] m_qos = qos;
        automatic int m_ch = ch;
        automatic bit write_address_accept;

        axi_if[m_ch].awvalid_i = 1;
        axi_if[m_ch].awaddr_i = m_addr;
        axi_if[m_ch].awid_i = m_id;
        axi_if[m_ch].awburst_i = m_burst;
        axi_if[m_ch].awsize_i = m_size;
        axi_if[m_ch].awlen_i = m_len;
        axi_if[m_ch].awqos_i = m_qos;

        @(posedge axi_if[m_ch].aclk);
        write_address_accept = axi_if[m_ch].awready_i ;

        while (write_address_accept == 0) begin
            @(posedge axi_if[m_ch].aclk);
            write_address_accept = axi_if[m_ch].awready_i ;
        end

        axi_if[m_ch].awvalid_i = 0;
        axi_if[m_ch].awaddr_i = 0;
        axi_if[m_ch].awid_i = 0;
        axi_if[m_ch].awburst_i = 0;
        axi_if[m_ch].awsize_i = 0;
        axi_if[m_ch].awlen_i = 0;
        axi_if[m_ch].awqos_i = 0;
    endtask: send_write_command

    task send_read_command (input logic [`AXI_ADDR_W-1:0] addr, input logic [`AXI_ID_W-1:0] id, input logic [1:0] burst, input logic [2:0] size, input logic [2:0] len, input logic [`AXI_QOS_W-1:0] qos, input int ch);
        automatic logic [`AXI_ADDR_W-1:0] m_addr = addr;
        automatic logic [`AXI_ID_W-1:0] m_id = id;
        automatic logic [1:0] m_burst = burst;
        automatic logic [2:0] m_size = size;
        automatic logic [`AXI_LEN_W-1:0] m_len = len;
        automatic logic [`AXI_QOS_W-1:0] m_qos = qos;
        automatic int m_ch = ch;
        automatic bit read_address_accept;

        axi_if[m_ch].arvalid_i = 1;
        axi_if[m_ch].araddr_i = m_addr;
        axi_if[m_ch].arid_i = m_id;
        axi_if[m_ch].arburst_i = m_burst;
        axi_if[m_ch].arsize_i = m_size;
        axi_if[m_ch].arlen_i = m_len;
        axi_if[m_ch].arqos_i = m_qos;

        @(posedge axi_if[m_ch].aclk);
        read_address_accept = axi_if[m_ch].arready_i ;

        while (read_address_accept == 0) begin
            @(posedge axi_if[m_ch].aclk);
            read_address_accept = axi_if[m_ch].arready_i ;
        end

        axi_if[m_ch].arvalid_i = 0;
        axi_if[m_ch].araddr_i = 0;
        axi_if[m_ch].arid_i = 0;
        axi_if[m_ch].arburst_i = 0;
        axi_if[m_ch].arsize_i = 0;
        axi_if[m_ch].arlen_i = 0;
        axi_if[m_ch].arqos_i = 0;
    endtask: send_read_command

    task send_write_data (input int ch, input logic [`AXI_DATA_W*2-1:0] data, input logic [(`AXI_DATA_W*2/8)-1:0] strb);

        automatic int m_ch = ch;
        automatic logic [`AXI_DATA_W*2-1:0] m_data = data;
        automatic logic [(`AXI_DATA_W*2/8)-1:0] m_wstrb = strb;
        automatic bit write_data_accept;

        axi_if[m_ch].wvalid_i = 1;
        axi_if[m_ch].wlast_i = 0;
        axi_if[m_ch].wdata_i = m_data[`AXI_DATA_W-1:0];
        axi_if[m_ch].wstrb_i = m_wstrb[(`AXI_DATA_W/8)-1:0];
        @(posedge axi_if[m_ch].aclk);
        write_data_accept = axi_if[m_ch].wready_i ;

        while (write_data_accept == 0) begin
            @(posedge axi_if[m_ch].aclk);
            write_data_accept = axi_if[m_ch].wready_i ;
        end

        axi_if[m_ch].wvalid_i = 1;
        axi_if[m_ch].wlast_i = 1;
        axi_if[m_ch].wdata_i = m_data[`AXI_DATA_W*2-1:`AXI_DATA_W];
        axi_if[m_ch].wstrb_i = m_wstrb[(`AXI_DATA_W/8)*2-1:`AXI_DATA_W/8];
        @(posedge axi_if[m_ch].aclk);
        write_data_accept = axi_if[m_ch].wready_i ;

        while (write_data_accept == 0) begin
            @(posedge axi_if[m_ch].aclk);
            write_data_accept = axi_if[m_ch].wready_i ;
        end

        axi_if[m_ch].wvalid_i = 0;
        axi_if[m_ch].wstrb_i = 0;
        axi_if[m_ch].wlast_i = 0;
    endtask: send_write_data

    task send_write_channel(input int ch, input bit [(`AXI_DATA_W*2/8)-1:0] wstrb);
        automatic int m_ch = ch;
        bit [`AXI_DATA_W*2-1:0] data;
        forever begin
            wait(data_q[m_ch].size() > 0);
            data = data_q[m_ch].pop_front();
            send_write_data(m_ch,data, wstrb);
        end
    endtask : send_write_channel

    task collect_read_data (input int ch, output logic [`AXI_ID_W-1:0] id, output logic [1:0] resp, output logic [`AXI_DATA_W*2-1:0] data);

        automatic int m_ch = ch;
        automatic bit read_data_valid = 0;

        @(posedge axi_if[m_ch].aclk);
        read_data_valid = axi_if[m_ch].rvalid_i ;

        while (read_data_valid == 0) begin
            @(posedge axi_if[m_ch].aclk);
            read_data_valid = axi_if[m_ch].rvalid_i ;
        end

        axi_if[m_ch].rready_i = 1;
        id = axi_if[m_ch].rid_i;
        resp = axi_if[m_ch].rresp_i;
        data[`AXI_DATA_W-1:0] = axi_if[m_ch].rdata_i;
        @(posedge axi_if[m_ch].aclk);
        axi_if[m_ch].rready_i = 0;

        @(posedge axi_if[m_ch].aclk);
        read_data_valid = axi_if[m_ch].rvalid_i ;

        while (read_data_valid == 0) begin
            @(posedge axi_if[m_ch].aclk);
            read_data_valid = axi_if[m_ch].rvalid_i ;
        end

        axi_if[m_ch].rready_i = 1;
        id = axi_if[m_ch].rid_i;
        resp = axi_if[m_ch].rresp_i;
        data[`AXI_DATA_W*2-1:`AXI_DATA_W] = axi_if[m_ch].rdata_i;
        @(posedge axi_if[m_ch].aclk);
        axi_if[m_ch].rready_i = 0;
    endtask: collect_read_data

    task send_read_response(input int ch);

        automatic int m_ch = ch;
        automatic bit[`AXI_ID_W-1:0] rid;
        automatic bit[1:0] rresp;
        automatic bit[`AXI_DATA_W*2-1:0] rdata;

        forever begin
            collect_read_data(m_ch,rid,rresp,rdata);
            arid_pool[m_ch].push_back(rid);
            if (mem_snap[m_ch].exists(rid)) begin
                $display("ch %2d Matched read transaction found with id 0x%0x",m_ch,rid);
                if (mem_snap[m_ch][rid] != rdata) begin
                    $display ("%0t, [ERROR] ch %2d Expected axi read data is 0x%0x act read data is 0x%0x",$time ,m_ch, mem_snap[m_ch][rid], rdata);
                    error_report();
                end
                else begin
                    $display ("%0t, [PASS] ch %2d Expected axi read data 0x%0x received",$time , m_ch, rdata);
                end
            end
            else begin
                $display("%0t, [ERROR] ch%0d read transaction id %0d not found",$time,m_ch,rid);
                error_report();
            end
            rdtrans_rcv[m_ch]++;
        end
    endtask : send_read_response

    task ack_write_response(input int ch, output logic [`AXI_ID_W-1:0] id, output logic resp);
        automatic int m_ch = ch;
        automatic bit write_resp_valid;

        @(posedge axi_if[m_ch].aclk);
        write_resp_valid = axi_if[m_ch].bvalid_i;

        while (write_resp_valid == 0) begin
            @(posedge axi_if[m_ch].aclk);
            write_resp_valid = axi_if[m_ch].bvalid_i;
        end
        axi_if[m_ch].bready_i = 1;
        id = axi_if[m_ch].bid_i;
        resp = axi_if[m_ch].bresp_i;

        @(posedge axi_if[m_ch].aclk);
        axi_if[m_ch].bready_i = 0;
        wrtrans_rcv[m_ch]++;
    endtask: ack_write_response

    task send_write_response(input int ch);

        automatic int m_ch = ch;
        automatic bit[`AXI_ID_W-1:0] bid;
        automatic bit[1:0] bresp;
        automatic int id_idx;

        forever begin
            ack_write_response(m_ch,bid,bresp);
            if (find_index_by_id(bid,m_ch)) begin
                $display("%0t, [PASS] ch%2d Expected write response received",$time , m_ch);
            end else begin
                $display("%0t, [ERROR] ch%2d write transaction id %0d not found",$time,m_ch,bid);
                error_report();
            end
            brsp_written_addr[m_ch].push_back(written_addr[m_ch].pop_front());
            awid_pool[m_ch].push_back(bid);
        end
    endtask : send_write_response

    task AXI_WR32B_SEQ(input int ch);
        automatic int m_ch = ch;
        int trans_cnt = 20;
        bit [`AXI_DATA_W*2-1:0] rand_data;
        automatic int addr_idx;
        rdtrans_rcv[m_ch] = 0;
        wrtrans_rcv[m_ch] = 0;

        @(posedge axi_if[m_ch].aclk);
        fork

            for (int trans = 0 ; trans < trans_cnt ; trans++) begin
                bit [`AXI_ADDR_W-1 : 0] awaddr;
                bit [`AXI_ID_W-1:0] awid;
                automatic int awid_idx;

                wait (awid_pool[m_ch].size() > 0);
                void'(std::randomize(awid_idx) with {awid_idx inside {[0:awid_pool[m_ch].size()-1]};});
                awid = awid_pool[m_ch][awid_idx];

                awaddr = rand_axi_addr();

                void'(std::randomize(rand_data));
                data_q[m_ch].push_back(rand_data);

                send_write_command(awaddr, awid, `AXI_INCR, `AXI_32B, `AXI_LEN_1, `AXI_QOS_0, m_ch);

                awid_pool[m_ch].delete(awid_idx);

                written_addr[m_ch].push_back(awaddr);

                mem_shadow[m_ch][awaddr] = rand_data;
            end

            for (int trans = 0 ; trans < trans_cnt ; trans++) begin
                bit [`AXI_ADDR_W-1 : 0] araddr;
                bit [`AXI_ID_W-1:0] arid;
                automatic int arid_idx;

                wait (arid_pool[m_ch].size() > 0);
                void'(std::randomize(arid_idx) with {arid_idx inside {[0:arid_pool[m_ch].size()-1]};});
                arid = arid_pool[m_ch][arid_idx];
                arid_pool[m_ch].delete(arid_idx);

                wait (brsp_written_addr[m_ch].size() > 0);
                void'(std::randomize(addr_idx) with {addr_idx inside {[0:brsp_written_addr[m_ch].size()-1]};});
                araddr = brsp_written_addr[m_ch][addr_idx];

                send_read_command(araddr, arid, `AXI_INCR, `AXI_32B, `AXI_LEN_1, `AXI_QOS_0, m_ch);

                mem_snap[m_ch][arid] = mem_shadow[m_ch][araddr];

                brsp_written_addr[m_ch].delete(addr_idx);
            end

            fork
                send_write_channel(m_ch, 64'hFFFF_FFFF_FFFF_FFFF);
            join_none

            fork
                send_read_response(m_ch);
            join_none

            fork
                send_write_response(m_ch);
            join_none
        join

        wait (wrtrans_rcv[m_ch] == trans_cnt);
        $display($psprintf("All write response received ch: %2d finish", m_ch));
        wait (rdtrans_rcv[m_ch] == trans_cnt);
        $display($psprintf("All read response received ch: %2d finish", m_ch));
        disable fork;

        #2000;
        $display("AXI_WR32B_SEQ ch[%2d] complete",m_ch);
    endtask : AXI_WR32B_SEQ

    task data_check();

        AXI_WR32B_SEQ(0);
        AXI_WR32B_SEQ(1);

    endtask

    task pll_ctrl_setting(input int freq);

        bit [31:0] pll_ctrl;
        bit [2:0] pll_postdiv;
        bit [1:0] pll_vcosel;
        bit [1:0] pll_fbdiv;
        bit [1:0] pll_refdiv;
        bit       pll_bypass;
        bit       pll_pdcal;

        `ifdef USE_UV_PLL
            int pll_base_freq = 10000;
        `else
            int pll_base_freq = 6400;
        `endif

        int pll_mult_freq;

        pll_mult_freq = 2 * freq;

        if (pll_mult_freq <= (pll_base_freq/128)) begin
            pll_postdiv = 3'd7;
        end else if (pll_mult_freq <= (pll_base_freq/64)) begin
            pll_postdiv = 3'd6;
        end else if (pll_mult_freq <= (pll_base_freq/32)) begin
            pll_postdiv = 3'd5;
        end else if (pll_mult_freq <= (pll_base_freq/16)) begin
            pll_postdiv = 3'd4;
        end else if (pll_mult_freq <= (pll_base_freq/8)) begin
            pll_postdiv = 3'd3;
        end else if (pll_mult_freq <= (pll_base_freq/4)) begin
            pll_postdiv = 3'd2;
        end else if (pll_mult_freq <= (pll_base_freq/2)) begin
            pll_postdiv = 3'd1;
        end else begin
            pll_postdiv = 3'b0;
        end

        pll_vcosel = 2'd3;
        pll_fbdiv  = 2'b10;
        pll_refdiv = 2'b10;
        pll_bypass = 1'b0;
        pll_pdcal  = 1'b0;

        pll_ctrl = {pll_vcosel,pll_postdiv,pll_fbdiv,pll_refdiv,pll_bypass,pll_pdcal,1'b1};
        set_field_by_apb("PUM_TOP_PLLCTRL",pll_ctrl);
    endtask: pll_ctrl_setting

    function bit [2:0] plldiv_calc(int freq);
        int pll_mult_freq;
        bit [2:0] pll_postdiv;
        `ifdef USE_UV_PLL
            int pll_base_freq = 10000;
        `else
            int pll_base_freq = 6400;
        `endif

        pll_mult_freq = 2 * freq;

        if (pll_mult_freq <= (pll_base_freq/128)) begin
            pll_postdiv = 3'd7;
        end else if (pll_mult_freq <= (pll_base_freq/64)) begin
            pll_postdiv = 3'd6;
        end else if (pll_mult_freq <= (pll_base_freq/32)) begin
            pll_postdiv = 3'd5;
        end else if (pll_mult_freq <= (pll_base_freq/16)) begin
            pll_postdiv = 3'd4;
        end else if (pll_mult_freq <= (pll_base_freq/8)) begin
            pll_postdiv = 3'd3;
        end else if (pll_mult_freq <= (pll_base_freq/4)) begin
            pll_postdiv = 3'd2;
        end else if (pll_mult_freq <= (pll_base_freq/2)) begin
            pll_postdiv = 3'd1;
        end else begin
            pll_postdiv = 3'b0;
        end
        return pll_postdiv;
    endfunction: plldiv_calc

    task bist_pll_setting(int freq);
        bit [31:0] bist_pll_mode;
        bit [2:0] bist_pll_post_div;
        bist_pll_post_div = plldiv_calc(freq);

        bist_pll_mode = { 3'h0,3'b001,3'b101,1'b0,2'b11,bist_pll_post_div,4'b1010,3'b001,1'b1};
        set_reg_by_jtag("PHY_BIST_PLL_MODE",bist_pll_mode);
    endtask

    task hold_xmu_uif(int ch_id);
        bit[31:0] rd_data;

        set_field_by_apb("CTL_XMUHOLD", 1, ch_id);
        while(1) begin
            get_field_by_apb("CTL_XMUIDLE", rd_data, ch_id);
            if(rd_data == 1) begin
                break;
            end
        end

        set_field_by_apb("CTL_UIFHOLD", 1, ch_id);

        while(1) begin
            get_field_by_apb("CTL_MCIDLE", rd_data, ch_id);
            if(rd_data == 1) begin
                break;
            end
        end
    endtask : hold_xmu_uif

    task unhold_xmu_uif(int ch_id);
        set_field_by_apb("CTL_UIFHOLD", 0, ch_id);
        set_field_by_apb("CTL_XMUHOLD", 0, ch_id);
    endtask : unhold_xmu_uif

    task sr_exit(int ch_id);
        bit sr_trig, sr_busy, swsr;

        wait_field_2ch("CTL_SRTRIG", 0, ch_id);
        wait_field_2ch("CTL_SRBUSY", 0, ch_id);

        get_field_by_apb("CTL_SWSR",swsr,ch_id);
        if(swsr == 1) begin
            set_field_by_apb("CTL_SRTYPE", 0, ch_id);
            set_field_by_apb("CTL_SRTRIG", 1, ch_id);

            wait_field_2ch("CTL_SRTRIG", 0, ch_id);
            wait_field_2ch("CTL_SRBUSY", 0, ch_id);
        end else begin
            $display($psprintf("%0t,  sr_exit, curr state is not sr state, do nothing",$time));
        end
    endtask : sr_exit

    task sr_entry(int ch_id);
        bit sr_trig, sr_busy, swsr;
        wait_field_2ch("CTL_SRTRIG", 0, ch_id);
        wait_field_2ch("CTL_SRBUSY", 0, ch_id);

        get_field_by_apb("CTL_SWSR",swsr,ch_id);
        if(swsr == 0) begin
            set_field_by_apb("CTL_SRTYPE", 1, ch_id);
            set_field_by_apb("CTL_SRTRIG", 1, ch_id);

            wait_field_2ch("CTL_SRTRIG", 0, ch_id);
            wait_field_2ch("CTL_SRBUSY", 0, ch_id);
        end else begin
            $display($psprintf("%0t,  sr_entry, curr state is sr state, do nothing",$time));
        end
    endtask : sr_entry

    task mpsmx_flow(int ch_id);
        int mr2_value;
        get_field_by_apb("CTL_MR2VALUE", mr2_value, ch_id);
        mr2_value[3] = 0;
        set_field_by_apb("CTL_MR2VALUE", mr2_value, ch_id);

        set_field_by_apb("CTL_MPSMTYPE", 0, ch_id);
        set_field_by_apb("CTL_MPSMTRIG", 1, ch_id);
        wait_field_2ch("CTL_MPSMTRIG", 0, ch_id);
        wait_field_2ch("CTL_MPSMBUSY", 0, ch_id);
    endtask : mpsmx_flow

    task wait_field_2ch(string field_name, int need_state, int ch_id);
        int state;
        while(1) begin
            get_field_by_apb(field_name, state, ch_id);
            if(state == need_state) begin
                break;
            end
        end
    endtask : wait_field_2ch

    task exit_low_power_state(int ch_id, output bit pdnen, bit sren);
        bit swmpsm;
        get_field_by_apb("CTL_PDNEN", pdnen, ch_id);
        get_field_by_apb("CTL_SREN", sren , ch_id);
        set_field_by_apb("CTL_PDNEN", 0   , ch_id);
        set_field_by_apb("CTL_SREN" , 0   , ch_id);

        sr_exit(ch_id);

        get_field_by_apb("CTL_SWMPSM", swmpsm, ch_id);
        if(swmpsm == 1) begin
            mpsmx_flow(ch_id);
            set_field_by_apb("CTL_SWCMDSTART", 0, ch_id);
        end

        wait_field_2ch("CTL_DDRLPSTATE", 0, ch_id);
    endtask : exit_low_power_state

    task disable_auto_cmd(int ch_id, output bit zq, bit ctrlupd, bit mrr4);
        get_field_by_apb("CTL_ZQCALSWEN", zq, ch_id);
        get_field_by_apb("CTL_MRR4EN", mrr4, ch_id);
        get_field_by_apb("CTL_CTRLUPDEN", ctrlupd, ch_id);

        set_field_by_apb("CTL_ZQCALSWEN", 1, ch_id);
        set_field_by_apb("CTL_MRR4EN", 0, ch_id);
        set_field_by_apb("CTL_CTRLUPDEN", 0, ch_id);
    endtask : disable_auto_cmd

    task polling_periodic_sw_event(int ch_id);
        wait_field_2ch("CTL_MPCTRIG", 0, ch_id);
        wait_field_2ch("CTL_MPCBUSY", 0, ch_id);
        wait_field_2ch("CTL_CTRLUPDTRIG", 0, ch_id);
        wait_field_2ch("CTL_CTRLUPDBUSY", 0, ch_id);
    endtask : polling_periodic_sw_event

    task sce_send_cmd(int ch_id, bit cmd_code, bit[7:0] cmd_type, bit[31:0] cmd_body, bit seq_last, bit ongoing);
        bit cmd_err;

        set_field_by_apb("CTL_CMDCODE", cmd_code, ch_id);
        set_field_by_apb("CTL_CMDTYPE", cmd_type, ch_id);
        set_field_by_apb("CTL_CMDBODY", cmd_body, ch_id);
        set_field_by_apb("CTL_CMDSEQLAST", seq_last, ch_id);
        set_field_by_apb("CTL_CMDSEQONGOING", ongoing, ch_id);
        set_field_by_apb("CTL_CMDTRIG", 1, ch_id);
        wait_field_2ch("CTL_CMDTRIG", 0, ch_id);
        wait_field_2ch("CTL_CMDCOMPLETE", 1, ch_id);

        get_field_by_apb("CTL_CMDERR", cmd_err, ch_id);
        if(cmd_err==1) begin
            $display($psprintf("%0t,  sce send cmd fail, cmd_code is %0h, cmd_type is %0h, cmd_body is %0h, seq_last is %0h, ongoing is %0h, ch_id is %0h",$time, cmd_code, cmd_type, cmd_body, seq_last, ongoing, ch_id));
        end else begin
            $display($psprintf("%0t,  sce send cmd success, cmd_code is %0h, cmd_type is %0h, cmd_body is %0h, seq_last is %0h, ongoing is %0h, ch_id is %0h",$time, cmd_code, cmd_type, cmd_body, seq_last, ongoing, ch_id));
        end
    endtask : sce_send_cmd

    task sce_send_act(int ch_id, bit[3:0] cs, bit[2:0] cid, bit[2:0] bg, bit[1:0] ba, bit[17:0] row, bit seq_last, bit ongoing);
        bit[31:0] cmd_body;
        cmd_body[29:27] = cid;
        cmd_body[26:23] = cs;
        cmd_body[22:20] = bg;
        cmd_body[19:18] = ba;
        cmd_body[17:0]  = row;

        sce_send_cmd(ch_id, 0, 2, cmd_body, seq_last, ongoing);
    endtask : sce_send_act

    task sce_send_rd(int ch_id, bit[3:0] cs, bit[2:0] cid, bit[2:0] bg, bit[1:0] ba, bit[7:0] col, bit seq_last, bit ongoing);
        bit[31:0] cmd_body;
        cmd_body[29:27] = cid;
        cmd_body[26:23] = cs;
        cmd_body[22:20] = bg;
        cmd_body[19:18] = ba;
        cmd_body[17]    = 1;
        cmd_body[12]    = 1;
        cmd_body[11]    = col[0];
        cmd_body[6:0]   = col[7:1];

        sce_send_cmd(ch_id, 0, 7, cmd_body, seq_last, ongoing);
    endtask : sce_send_rd

    task sce_send_wr(int ch_id, bit[3:0] cs, bit[2:0] cid, bit[2:0] bg, bit[1:0] ba, bit[7:0] col, bit seq_last, bit ongoing, bit wr0_mwr1, bit bl);
        bit[31:0] cmd_body;
        cmd_body[29:27] = cid;
        cmd_body[26:23] = cs;
        cmd_body[22:20] = bg;
        cmd_body[19:18] = ba;
        cmd_body[17]    = 1;
        cmd_body[12]    = bl;
        cmd_body[11]    = col[0];
        cmd_body[6:0]   = col[7:1];

        if(wr0_mwr1 == 0) begin
            sce_send_cmd(ch_id, 0, 6, cmd_body, seq_last, ongoing);
        end else begin
            sce_send_cmd(ch_id, 0, 5, cmd_body, seq_last, ongoing);
        end
    endtask : sce_send_wr

    task sce_send_pre(int ch_id, bit[3:0] cs, bit[2:0] cid, bit[2:0] bg, bit[1:0] ba, bit pb0_ab1, bit seq_last, bit ongoing);
        bit[31:0] cmd_body;
        cmd_body[29:27] = cid;
        cmd_body[26:23] = cs;
        if(pb0_ab1 == 0) begin
            cmd_body[22:20] = bg;
            cmd_body[19:18] = ba;
            sce_send_cmd(ch_id, 0, 3, cmd_body, seq_last, ongoing);
        end else begin
            cmd_body[10] = 0;
            sce_send_cmd(ch_id, 0, 'h11, cmd_body, seq_last, ongoing);
        end
    endtask : sce_send_pre

    task sce_send_ref(int ch_id, bit[3:0] cs, bit[2:0] cid, bit[1:0] ba, bit ref0_rfm1, bit seq_last, bit ongoing);
        bit[31:0] cmd_body;
        cmd_body[29:27] = cid;
        cmd_body[26:23] = cs;
        cmd_body[19:18] = ba;
        cmd_body[10]    = 1;
        cmd_body[9]     = ref0_rfm1;
        sce_send_cmd(ch_id, 0, 4, cmd_body, seq_last, ongoing);
    endtask : sce_send_ref

    task sce_wrdata_prepare(int ch_id, bit wr0_mwr1, bit wrdata_type);
        bit[31:0] dq0, dq1;
        bit[15:0] ecc_code;
        bit[7:0]  data_mask;
        bit[1:0]  ecc_mask;

        dq0       = 'h8888;
        dq1       = 'h6666;
        ecc_code  = 'h9999;
        if(wr0_mwr1 == 0) begin
            data_mask = 'hff;
            ecc_mask  = 'h3;
        end else begin
            data_mask = 'h33;
            ecc_mask  = 'h2;
        end

        set_field_by_apb("CTL_WRDATATYPE", wrdata_type, ch_id);

        if(wrdata_type == 1) begin
            set_field_by_apb("CTL_WRDATADQ0",         dq0,       ch_id);
            set_field_by_apb("CTL_WRDATADQ1",         dq1,       ch_id);
            set_field_by_apb("CTL_WRDATAECCCODE",     ecc_code,  ch_id);
            set_field_by_apb("CTL_WRDATADQMASK",      data_mask, ch_id);
            set_field_by_apb("CTL_WRDATAECCCODEMASK", ecc_mask,  ch_id);
            $display($psprintf("%0t,  sce_wrdata_prepare done, ch_id is %0h, wr0_mwr1 is %0h, wrdata_type is %0h, dq0 is %0h, dq1 is %0h, ecc_code is %0h, data_mask is %0h, ecc_mask is %0h",$time, ch_id, wr0_mwr1, wrdata_type, dq0, dq1, ecc_code, data_mask, ecc_mask));
        end else begin
            for(int i=0; i<8; i++) begin
                dq0 = i;
                dq1 = 2*i;
                set_field_by_apb("CTL_WRDATADQ0",         dq0,       ch_id);
                set_field_by_apb("CTL_WRDATADQ1",         dq1,       ch_id);
                set_field_by_apb("CTL_WRDATAECCCODE",     ecc_code,  ch_id);
                set_field_by_apb("CTL_WRDATADQMASK",      data_mask, ch_id);
                set_field_by_apb("CTL_WRDATAECCCODEMASK", ecc_mask,  ch_id);

                set_field_by_apb("CTL_BUFADDR",  i, ch_id);
                set_field_by_apb("CTL_BUFRWTYPE", 0, ch_id);
                set_field_by_apb("CTL_BUFRWTRIG", 1, ch_id);
                wait_field_2ch("CTL_BUFRWTRIG", 0, ch_id);
                $display($psprintf("%0t,  sce_wrdata_prepare done, ch_id is %0h, wr0_mwr1 is %0h, wrdata_type is %0h, dq0 is %0h, dq1 is %0h, ecc_code is %0h, data_mask is %0h, ecc_mask is %0h, buf_addr is %0h",$time, ch_id, wr0_mwr1, wrdata_type, dq0, dq1, ecc_code, data_mask, ecc_mask, i));
            end
        end
    endtask : sce_wrdata_prepare

    task sce_rddata_get(int ch_id, bit[2:0] buf_addr, output bit[31:0] dq0, bit[31:0] dq1);
        wait_field_2ch("CTL_RDDATAVLD", 1, ch_id);
        set_field_by_apb("CTL_BUFADDR", buf_addr, ch_id);
        set_field_by_apb("CTL_BUFRWTYPE", 1, ch_id);
        set_field_by_apb("CTL_BUFRWTRIG", 1, ch_id);
        wait_field_2ch("CTL_BUFRWTRIG", 0, ch_id);
        get_field_by_apb("CTL_RDDATADQ0", dq0, ch_id);
        get_field_by_apb("CTL_RDDATADQ1", dq1, ch_id);

        $display($psprintf("%0t,  sce_rddata_get done, ch_id is %0h, buf_addr is %0h, dq0 is %0h, dq1 is %0h",$time, ch_id, buf_addr, dq0, dq1));
    endtask : sce_rddata_get

    task ppr_source_check(int ch_id, bit[3:0] cs, bit[3:0] cid, bit[2:0] bg, output [7:0] ppr_src);
        bit [7:0] mr14;
        mrr_handle(ch_id, cs, 14, mr14);
        mr14[3:0] = cid;
        mrw_handle(ch_id, cs, 14, mr14);

        case(bg)
            3'b000,3'b001: mrr_handle(ch_id, cs, 'd54, ppr_src);
            3'b010,3'b011: mrr_handle(ch_id, cs, 'd55, ppr_src);
            3'b100,3'b101: mrr_handle(ch_id, cs, 'd56, ppr_src);
            3'b110,3'b111: mrr_handle(ch_id, cs, 'd57, ppr_src);
        endcase
        $display($psprintf("%0t,  ppr_source_check done, ch_id is %0h, cs is %0h, cid is %0h, bg is %0h, ppr_src is %0h",$time, ch_id, cs, cid, bg, ppr_src));
    endtask : ppr_source_check

    task mrr_handle(int ch_id, bit[3:0] cs, bit[8:0] mraddr, output bit[15:0] mrdat);
        set_field_by_apb("CTL_MRRANK", cs, ch_id);
        set_field_by_apb("CTL_MRADDR", mraddr, ch_id);
        set_field_by_apb("CTL_MRTYPE", 1, ch_id);
        set_field_by_apb("CTL_MRTRIG", 1, ch_id);
        wait_field_2ch("CTL_MRTRIG", 0, ch_id);
        wait_field_2ch("CTL_MRBUSY", 0, ch_id);

        get_field_by_apb("CTL_MRRDAT0", mrdat, ch_id);
        $display($psprintf("%0t,  mrr_handle done, ch_id is %0h, cs is %0h, mraddr is %0h, mrdat is %0h",$time, ch_id, cs, mraddr, mrdat));
    endtask : mrr_handle

    task mrw_handle(int ch_id, bit[3:0] cs, bit[8:0] mraddr, bit[15:0] mrdat);
        set_field_by_apb("CTL_MRRANK", cs, ch_id);
        set_field_by_apb("CTL_MRADDR", mraddr, ch_id);
        set_field_by_apb("CTL_MRWDAT", mrdat, ch_id);
        set_field_by_apb("CTL_MRTYPE", 0, ch_id);
        set_field_by_apb("CTL_MRTRIG", 1, ch_id);
        wait_field_2ch("CTL_MRTRIG", 0, ch_id);
        wait_field_2ch("CTL_MRBUSY", 0, ch_id);

        $display($psprintf("%0t,  mrw_handle done, ch_id is %0h, cs is %0h, mraddr is %0h, mrdat is %0h",$time, ch_id, cs, mraddr, mrdat));
    endtask : mrw_handle

    task mpr_rd_handle(int ch_id, bit [3:0] prank, int lrank, output bit [31:0] mpr_data);
        int mpr_read_addr;
        std::randomize(mpr_read_addr) with {mpr_read_addr >= 0; mpr_read_addr < 4;};

        set_field_by_apb("CTL_MRRANK", prank, ch_id);
        set_field_by_apb("CTL_MPRCID", lrank, ch_id);
        set_field_by_apb("CTL_MRADDR", mpr_read_addr, ch_id);
        set_field_by_apb("CTL_MRTYPE", 1, ch_id);
        set_field_by_apb("CTL_MRTRIG", 1, ch_id);
        wait_field_2ch("CTL_MRTRIG", 0, ch_id);
        wait_field_2ch("CTL_MRBUSY", 0, ch_id);

        get_field_by_apb("CTL_MPRDAT0", mpr_data, ch_id);
        $display($psprintf("%0t,  mpr_rd_handle done, ch_id is %0h, cs is %0h, mraddr is %0h, mrdat is %0h",$time, ch_id, prank, mpr_read_addr, mpr_data));
    endtask : mpr_rd_handle

    task mpr_wr_handle(int ch_id, bit [3:0] prank, int lrank, bit [31:0] mpr_data);
        set_field_by_apb("CTL_MRRANK", prank, ch_id);
        set_field_by_apb("CTL_MPRCID", lrank, ch_id);
        set_field_by_apb("CTL_MRADDR", 0, ch_id);
        set_field_by_apb("CTL_MRWDAT", mpr_data, ch_id);
        set_field_by_apb("CTL_MRTYPE", 0, ch_id);
        set_field_by_apb("CTL_MRTRIG", 1, ch_id);
        wait_field_2ch("CTL_MRTRIG", 0, ch_id);
        wait_field_2ch("CTL_MRBUSY", 0, ch_id);
    endtask : mpr_wr_handle

    task mrr_flow(int ch_id, bit[3:0] cs, bit[8:0] mraddr, output bit[15:0] mrdat);
        bit pdnen, sren;
        hold_xmu_uif(ch_id);
        exit_low_power_state(ch_id, pdnen, sren);
        set_field_by_apb("CTL_SWCMDSTART", 1, ch_id);
        mrr_handle(ch_id, cs, mraddr, mrdat);
        set_field_by_apb("CTL_PDNEN", pdnen, ch_id);
        set_field_by_apb("CTL_SREN", sren, ch_id);
        unhold_xmu_uif(ch_id);
        set_field_by_apb("CTL_SWCMDSTART", 0, ch_id);

        $display($psprintf("%0t,  mrr_flow done, ch_id is %0h, cs is %0h, mraddr is %0h, mrdat is %0h",$time, ch_id, cs, mraddr, mrdat));
    endtask : mrr_flow

    task mrw_flow(int ch_id, bit[3:0] cs, bit[8:0] mraddr, bit[15:0] mrdat);
        bit pdnen, sren;
        hold_xmu_uif(ch_id);
        exit_low_power_state(ch_id, pdnen, sren);
        set_field_by_apb("CTL_SWCMDSTART", 1, ch_id);
        mrw_handle(ch_id, cs, mraddr, mrdat);
        set_field_by_apb("CTL_PDNEN", pdnen, ch_id);
        set_field_by_apb("CTL_SREN", sren, ch_id);
        unhold_xmu_uif(ch_id);
        set_field_by_apb("CTL_SWCMDSTART", 0, ch_id);

        $display($psprintf("%0t,  mrw_flow done, ch_id is %0h, cs is %0h, mraddr is %0h, mrdat is %0h",$time, ch_id, cs, mraddr, mrdat));
    endtask : mrw_flow

    task sce_preab_all_lk(int ch_id, bit[3:0] cs);
        bit[31:0] cmd_body;
        cmd_body[10] = 0;
        cmd_body[26:23] = cs;
        for(int i=0; i<`CTL_LRANK_NUM; i++) begin
            cmd_body[29:27] = i;
            sce_send_cmd(ch_id, 0, 'h11, cmd_body, 1, 1);
        end

        $display($psprintf("%0t,  sce_preab_all_lk done, ch_id is %0h, cs is %0h",$time, ch_id, cs));
    endtask : sce_preab_all_lk

    task ppr_guard_key(int ch_id, bit[3:0] cs);
        mrw_handle(ch_id, cs, 'd24, 8'b1100_1111);
        mrw_handle(ch_id, cs, 'd24, 8'b0111_0011);
        mrw_handle(ch_id, cs, 'd24, 8'b1011_1011);
        mrw_handle(ch_id, cs, 'd24, 8'b0011_1011);
    endtask : ppr_guard_key

    task ppr_wrdata_gen(int ch_id, int device_id, int mem_width);
        bit[31:0] wr_data_dq;
        bit[7:0]  wr_data_dq_mask;
        bit[15:0] wr_data_ecc_dq;
        bit[1:0]  wr_data_ecc_dq_mask;
        bit wr_data_type = 1;

        set_field_by_apb("CTL_WRDATATYPE", wr_data_type, ch_id);
        wr_data_dq = '1;
        wr_data_ecc_dq = '1;

        if(device_id < (32/mem_width)) begin
            if(mem_width=='d4) begin
                wr_data_dq[device_id*4 +: 4] = '0;
            end else if(mem_width=='d8) begin
                wr_data_dq[device_id*8 +: 8] = '0;
            end else if(mem_width=='d16) begin
                wr_data_dq[device_id*16 +: 16] = '0;
            end else begin
                assert(0);
            end
        end else begin
            if(mem_width=='d4) begin
                if(device_id=='d8) begin
                    wr_data_ecc_dq = 16'hf0f0;
                end else if(device_id=='d9) begin
                    wr_data_ecc_dq = 16'h0f0f;
                end
            end else if( (mem_width=='d8 && device_id=='d4) || (mem_width=='d16 && device_id=='d2) ) begin
                wr_data_ecc_dq = 16'h0000;
            end else begin
                assert(0);
            end
        end

        wr_data_dq_mask = '1;
        wr_data_ecc_dq_mask = '1;

        set_field_by_apb("CTL_WRDATADQ0", wr_data_dq, ch_id);
        set_field_by_apb("CTL_WRDATADQ1", wr_data_dq, ch_id);
        set_field_by_apb("CTL_WRDATADQMASK", wr_data_dq_mask, ch_id);
        set_field_by_apb("CTL_WRDATAECCCODE", wr_data_ecc_dq, ch_id);
        set_field_by_apb("CTL_WRDATAECCCODEMASK", wr_data_ecc_dq_mask, ch_id);

        $display($psprintf("%0t,  ppr_wrdata_gen done, ch_id is %0h, device_id is %0h, mem_width is %0h, wr_data_dq is %0h, wr_data_dq_mask is %0h, wr_data_ecc_dq is %0h, wr_data_ecc_dq_mask is %0h",$time, ch_id, device_id, mem_width, wr_data_dq, wr_data_dq_mask, wr_data_ecc_dq, wr_data_ecc_dq_mask));
    endtask : ppr_wrdata_gen

    task sce_pause_ref(int ch_id, bit[3:0] cs, bit seq_last, bit ongoing);
        bit[31:0] cmd_body;
        cmd_body[0] = 1;
        cmd_body[1] = 0;
        cmd_body[26:23] = cs;

        sce_send_cmd(ch_id, 1, 2, cmd_body, seq_last, ongoing);
    endtask : sce_pause_ref

    task sce_resume_ref(int ch_id, bit[3:0] cs, bit seq_last, bit ongoing);
        bit[31:0] cmd_body;
        cmd_body[0] = 0;
        cmd_body[26:23] = cs;

        sce_send_cmd(ch_id, 1, 2, cmd_body, seq_last, ongoing);
    endtask : sce_resume_ref

    task sce_flush_ref(int ch_id, bit[3:0] cs, bit seq_last, bit ongoing);
        bit[31:0] cmd_body;
        cmd_body[26:23] = cs;

        sce_send_cmd(ch_id, 1, 1, cmd_body, seq_last, ongoing);
    endtask : sce_flush_ref

    task sce_sppr_flow(int ch_id, bit[31:0] cmd_body, bit[31:0] addi_cfg, bit seq_last, bit ongoing);
        set_field_by_apb("CTL_CMDADDICFG", addi_cfg, ch_id);

        sce_send_cmd(ch_id, 1, 3, cmd_body, seq_last, ongoing);
        $display($psprintf("%0t,  sce_sppr_flow done, ch_id is %0h, cmd_body is %0h, addi_cfg is %0h, seq_last is %0h, ongoing is %0h",$time, ch_id, cmd_body, addi_cfg, seq_last, ongoing));
    endtask : sce_sppr_flow

    task ppr_recovery_procedure(int ch_id, bit sren, bit pdnen, bit zq, bit ctrlupd, bit mrr4);
        sce_resume_ref(ch_id, 4'b1111, 1, 1);

        set_field_by_apb("CTL_ZQCALSWEN", zq, ch_id);
        set_field_by_apb("CTL_MRR4EN", mrr4, ch_id);
        set_field_by_apb("CTL_CTRLUPDEN", ctrlupd, ch_id);

        set_field_by_apb("CTL_PDNEN", pdnen, ch_id);
        set_field_by_apb("CTL_SREN", sren, ch_id);
    endtask : ppr_recovery_procedure

    task sw_mpc_flow(int ch_id, int mpc_dat, int mpc_rk);
        bit mpc_trig, mpc_busy;
        get_field_by_apb("CTL_MPCTRIG", mpc_trig, ch_id);
        get_field_by_apb("CTL_MPCBUSY", mpc_busy, ch_id);

        if(mpc_trig || mpc_busy) begin
            $display($psprintf("%0t,  sw_mpc_flow, curr mpc_trig is %0d, mpc_busy is %0d, so do nothing",$time, mpc_trig, mpc_busy));
        end else begin
            set_field_by_apb("CTL_MPCDAT", mpc_dat, ch_id);
            set_field_by_apb("CTL_MPCRANK", mpc_rk, ch_id);
            set_field_by_apb("CTL_MPCTRIG", 1, ch_id);
            wait_field_2ch("CTL_MPCTRIG", 0, ch_id);
            wait_field_2ch("CTL_MPCBUSY", 0, ch_id);
            $display($psprintf("%0t,  sw_mpc_flow done, ch_id is %0d, mpc_dat is %0h, mpc_rk is %0h",$time, ch_id, mpc_dat, mpc_rk));
        end
    endtask : sw_mpc_flow

    task fgr_flow(int ch_id, bit ref_ab1_sb0, bit[1:0] ref_mode);
        bit swmpsm, pdnen, sren, dfilpensr, sdramcgen;
        $display($psprintf("%0t,  fgr_flow step 1, ch_id is %0d",$time, ch_id));
        hold_xmu_uif(ch_id);

        $display($psprintf("%0t,  fgr_flow step 2, ch_id is %0d",$time, ch_id));
        exit_low_power_state(ch_id, pdnen, sren);

        $display($psprintf("%0t,  fgr_flow step 3, ch_id is %0d",$time, ch_id));
        polling_periodic_sw_event(ch_id);

        $display($psprintf("%0t,  fgr_flow step 4, ch_id is %0d",$time, ch_id));
        set_field_by_apb("CTL_FGRSTART",1, ch_id);
        wait_field_2ch("CTL_ARBSTATE", 'h200, ch_id);
        wait_field_2ch("CTL_ARBSTATE", 'h200, ch_id);

        $display($psprintf("%0t,  fgr_flow step 5, ch_id is %0d",$time, ch_id));
        get_field_by_apb("CTL_DFILPENSR", dfilpensr, ch_id);
        get_field_by_apb("CTL_SDRAMCGENSRSW", sdramcgen, ch_id);
        set_field_by_apb("CTL_DFILPENSR", 0, ch_id);
        set_field_by_apb("CTL_SDRAMCGENSRSW", 0, ch_id);
        sr_entry(ch_id);
        set_field_by_apb("CTL_REFMODE", ref_mode, ch_id);
        begin
            bit refswen;
            int mr4;
            get_field_by_apb("CTL_REFSWEN",refswen, ch_id);
            if(refswen) begin
                $display($psprintf("%0t,  fgr_flow step 5, refswen is not 0, mode only can be refab, ch_id is %0d",$time, ch_id));
            end else begin
                set_field_by_apb("CTL_REFABEN", ref_ab1_sb0, ch_id);
            end
            get_field_by_apb("CTL_MR4VALUE", mr4, ch_id);
            mr4[4] = ref_mode;
            set_field_by_apb("CTL_MR4VALUE", mr4, ch_id);
        end
        sr_exit(ch_id);

        $display($psprintf("%0t,  fgr_flow step 6, ch_id is %0d",$time, ch_id));
        wait_field_2ch("CTL_SWOPBUSY", 0, ch_id);
        set_field_by_apb("CTL_PDNEN", pdnen, ch_id);
        set_field_by_apb("CTL_SREN", sren, ch_id);
        set_field_by_apb("CTL_DFILPENSR", dfilpensr, ch_id);
        set_field_by_apb("CTL_SDRAMCGENSRSW", sdramcgen, ch_id);
        unhold_xmu_uif(ch_id);

        $display($psprintf("%0t,  fgr_flow step 7, ch_id is %0d",$time, ch_id));
        set_field_by_apb("CTL_FGRSTART",0,ch_id);

    endtask : fgr_flow

    task ctrlupd_flow(int ch_id, bit hw0_sw1, int sw_cnt);
        bit ctrlupd_en;
        bit pdnen, sren;
        get_field_by_apb("CTL_CTRLUPDEN", ctrlupd_en, ch_id);

        if( (hw0_sw1==0 && ctrlupd_en==0) || (hw0_sw1==1 && ctrlupd_en==1) ) begin
            hold_xmu_uif(ch_id);
            exit_low_power_state(ch_id, pdnen, sren);
            polling_periodic_sw_event(ch_id);
            set_field_by_apb("CTL_SWCMDSTART",1, ch_id);
            wait_field_2ch("CTL_ARBSTATE", 'h200, ch_id);
            wait_field_2ch("CTL_ARBSTATE", 'h200, ch_id);
            set_field_by_apb("CTL_CTRLUPDEN", ~hw0_sw1, ch_id);
            set_field_by_apb("CTL_PDNEN", pdnen, ch_id);
            set_field_by_apb("CTL_SREN", sren, ch_id);
            set_field_by_apb("CTL_SWCMDSTART",0, ch_id);
            unhold_xmu_uif(ch_id);
        end

        if(hw0_sw1) begin
            for(int i=0; i<sw_cnt; i++) begin
                wait_field_2ch("CTL_DDRLPSTATE", 0, ch_id);
                wait_field_2ch("CTL_CTRLUPDTRIG", 0, ch_id);
                wait_field_2ch("CTL_CTRLUPDBUSY", 0, ch_id);

                set_field_by_apb("CTL_CTRLUPDTRIG", 1, ch_id);
                wait_field_2ch("CTL_CTRLUPDBUSY", 0, ch_id);
                $display($psprintf("%0t,  sw_ctrlupd_flow done, ch_id is %0d, sw_cnt is %0d",$time, ch_id, sw_cnt));
            end
        end else begin
            $display($psprintf("%0t,  hw_ctrlupd_flow done, ch_id is %0d",$time, ch_id));
        end
    endtask : ctrlupd_flow

    task sren_pden_sdramcgen_change_flow(int ch_id, bit sren_en, bit pdnen_en, bit cgen_en);
        bit sren, pdnen;
        hold_xmu_uif(ch_id);
        exit_low_power_state(ch_id, pdnen, sren);
        wait_field_2ch("CTL_MPCTRIG", 0, ch_id);
        wait_field_2ch("CTL_MPCBUSY", 0, ch_id);
        wait_field_2ch("CTL_CTRLUPDTRIG", 0, ch_id);
        wait_field_2ch("CTL_CTRLUPDBUSY", 0, ch_id);

        set_field_by_apb("CTL_SWCMDSTART", 1, ch_id);
        wait_field_2ch("CTL_ARBSTATE", 'h200, ch_id);
        wait_field_2ch("CTL_ARBSTATE", 'h200, ch_id);

        if(sren_en) begin
            set_field_by_apb("CTL_SREN", 1, ch_id);
        end else if(pdnen_en) begin
            set_field_by_apb("CTL_PDNEN", 1, ch_id);
        end else if(cgen_en) begin
            set_field_by_apb("CTL_SDRAMCGENSRSW", 1, ch_id);
        end

        if(sren) begin
            set_field_by_apb("CTL_SREN", 1, ch_id);
        end

        if(pdnen) begin
            set_field_by_apb("CTL_PDNEN", 1, ch_id);
        end

        unhold_xmu_uif(ch_id);
        set_field_by_apb("CTL_SWCMDSTART", 0, ch_id);

    endtask : sren_pden_sdramcgen_change_flow

    task sw_mpsm_flow(int ch_id, bit[1:0] mpsm_state);
        bit pdnen, sren, zq, ctrlupd, mrr4;
        bit[7:0] mr2;
        hold_xmu_uif(ch_id);
        exit_low_power_state(ch_id, pdnen, sren);
        disable_auto_cmd(ch_id, zq, ctrlupd, mrr4);
        polling_periodic_sw_event(ch_id);
        set_field_by_apb("CTL_SWCMDSTART", 1, ch_id);
        get_field_by_apb("CTL_MR2VALUE", mr2, ch_id);
        mr2[3] = 1;
        set_field_by_apb("CTL_MR2VALUE", mr2, ch_id);

        set_field_by_apb("CTL_MPSMTYPE", 1, ch_id);
        set_field_by_apb("CTL_MPSMSTATESEL", mpsm_state, ch_id);
        set_field_by_apb("CTL_MPSMTRIG", 1, ch_id);
        wait_field_2ch("CTL_MPSMTRIG", 0, ch_id);
        wait_field_2ch("CTL_MPSMBUSY", 0, ch_id);
        $display($psprintf("%0t,  sw_mpsm enter",$time));

        #5000ns;
        $display($psprintf("%0t,  sw_mpsm will exit",$time));
        mr2[3] = 0;
        set_field_by_apb("CTL_MR2VALUE", mr2, ch_id);
        set_field_by_apb("CTL_MPSMTYPE", 0, ch_id);
        set_field_by_apb("CTL_MPSMTRIG", 1, ch_id);
        wait_field_2ch("CTL_MPSMTRIG", 0, ch_id);
        wait_field_2ch("CTL_MPSMBUSY", 0, ch_id);

        sw_mpc_flow(ch_id, 5, 1);
        sw_mpc_flow(ch_id, 4, 1);

        set_field_by_apb("CTL_ZQCALSWEN", zq, ch_id);
        set_field_by_apb("CTL_MRR4EN", mrr4, ch_id);
        set_field_by_apb("CTL_PDNEN", pdnen, ch_id);
        set_field_by_apb("CTL_SREN", sren, ch_id);
        set_field_by_apb("CTL_SWCMDSTART", 0, ch_id);

        wait_field_2ch("CTL_DDRLPSTATE", 0, ch_id);
        wait_field_2ch("CTL_CTRLUPDTRIG", 0, ch_id);
        wait_field_2ch("CTL_CTRLUPDBUSY", 0, ch_id);
        set_field_by_apb("CTL_CTRLUPDTRIG", 1, ch_id);
        wait_field_2ch("CTL_CTRLUPDBUSY", 0, ch_id);
        set_field_by_apb("CTL_CTRLUPDEN", ctrlupd, ch_id);
        unhold_xmu_uif(ch_id);
        $display($psprintf("%0t,  sw_mpsm exit",$time));
    endtask : sw_mpsm_flow

    task sw_mpsm_ddr4_flow(int ch_id, bit[1:0] mpsm_state, bit[3:0] cs);
        bit pdnen, sren, zq, ctrlupd, mrr4;
        bit [15:0] mr4value_save, mr4value_set, mr5value_save, mr5value_set;
        bit dfilp_en_sr, sdram_cg_en;
        bit geardown_en;
        hold_xmu_uif(ch_id);
        exit_low_power_state(ch_id, pdnen, sren);
        polling_periodic_sw_event(ch_id);
        set_field_by_apb("CTL_SWCMDSTART", 1, ch_id);
        get_field_by_apb("CTL_MR4VALUE", mr4value_save, ch_id);
        get_field_by_apb("CTL_MR5VALUE", mr5value_save, ch_id);
        mr4value_set = mr4value_save;
        mr5value_set = mr5value_save;
        mr4value_set[8:6] = 3'b000;
        mr5value_set[2:0] = 3'b000;

        mrw_handle(ch_id, cs, 4, mr4value_set);
        mrw_handle(ch_id, cs, 5, mr5value_set);
        set_field_by_apb("CTL_DISSRXZQ", 1, ch_id);

        get_field_by_apb("CTL_ZQCALSWEN", zq, ch_id);
        get_field_by_apb("CTL_CTRLUPDEN", ctrlupd, ch_id);

        set_field_by_apb("CTL_ZQCALSWEN", 1, ch_id);
        set_field_by_apb("CTL_CTRLUPDEN", 0, ch_id);

        get_field_by_apb("CTL_DFI2NMODE", geardown_en, ch_id);
        get_field_by_apb("CTL_SDRAMCGENSRSW", sdram_cg_en, ch_id);
        get_field_by_apb("CTL_DFILPENSR", dfilp_en_sr, ch_id);
        if (geardown_en == 1) begin
            set_field_by_apb("CTL_GEARDOWNSTART", 1, ch_id);
            set_field_by_apb("CTL_DFILPENSR", 0, ch_id);
            set_field_by_apb("CTL_SDRAMCGENSRSW", 0, ch_id);
            sr_entry(1);
            set_field_by_apb("CTL_DFI2NMODE", 0, ch_id);
            sr_exit(1);
            set_field_by_apb("CTL_DFILPENSR", dfilp_en_sr, ch_id);
            set_field_by_apb("CTL_SDRAMCGENSRSW", sdram_cg_en, ch_id);
            set_field_by_apb("CTL_GEARDOWNSTART", 0, ch_id);
        end

        set_field_by_apb("CTL_MPSMTYPE", 1, ch_id);

        set_field_by_apb("CTL_MPSMTRIG", 1, ch_id);
        wait_field_2ch("CTL_MPSMTRIG", 0, ch_id);
        wait_field_2ch("CTL_MPSMBUSY", 0, ch_id);
        $display($psprintf("%0t,  sw_mpsm enter",$time));

        #5000ns;
        $display($psprintf("%0t,  sw_mpsm will exit",$time));

        set_field_by_apb("CTL_MPSMTYPE", 0, ch_id);
        set_field_by_apb("CTL_MPSMTRIG", 1, ch_id);
        wait_field_2ch("CTL_MPSMTRIG", 0, ch_id);
        wait_field_2ch("CTL_MPSMBUSY", 0, ch_id);

        if (geardown_en == 1) begin
            set_field_by_apb("CTL_GEARDOWNSTART", 1, ch_id);
            set_field_by_apb("CTL_DFILPENSR", 0, ch_id);
            set_field_by_apb("CTL_SDRAMCGENSRSW", 0, ch_id);
            sr_entry(1);
            set_field_by_apb("CTL_DFI2NMODE", 1, ch_id);
            sr_exit(1);
            set_field_by_apb("CTL_DFILPENSR", dfilp_en_sr, ch_id);
            set_field_by_apb("CTL_SDRAMCGENSRSW", sdram_cg_en, ch_id);
            set_field_by_apb("CTL_GEARDOWNSTART", 0, ch_id);
        end

        mrw_handle(ch_id, cs, 4, mr4value_save);
        mrw_handle(ch_id, cs, 5, mr5value_save);

        set_field_by_apb("CTL_DISSRXZQ", 0);

        set_field_by_apb("CTL_ZQCALSWEN", zq, ch_id);
        set_field_by_apb("CTL_PDNEN", pdnen, ch_id);
        set_field_by_apb("CTL_SREN", sren, ch_id);
        set_field_by_apb("CTL_SWCMDSTART", 0, ch_id);

        wait_field_2ch("CTL_DDRLPSTATE", 0, ch_id);
        wait_field_2ch("CTL_CTRLUPDTRIG", 0, ch_id);
        wait_field_2ch("CTL_CTRLUPDBUSY", 0, ch_id);
        set_field_by_apb("CTL_CTRLUPDTRIG", 1, ch_id);
        wait_field_2ch("CTL_CTRLUPDBUSY", 0, ch_id);
        set_field_by_apb("CTL_CTRLUPDEN", ctrlupd, ch_id);
        unhold_xmu_uif(ch_id);
        $display($psprintf("%0t,  sw_mpsm exit",$time));
    endtask : sw_mpsm_ddr4_flow

    task core_clk_disable(int ch_id);
        set_field_by_apb("CTL_AXICGEN", 0, ch_id);
        set_field_by_apb("CTL_CORECLKEN", 0, ch_id);
        wait_field_2ch("CTL_MCCGSUCCESS", 1, ch_id);
        #3000ns;
        set_field_by_apb("CTL_CORECLKEN", 1, ch_id);
    endtask : core_clk_disable

    task mr4_en_flow(int ch_id, int mr4_rd_inter, bit[3:0] cs);
        set_field_by_apb("CTL_MR4RDINTER", mr4_rd_inter, ch_id);
        set_field_by_apb("CTL_MRR4RANK", cs, ch_id);
        set_field_by_apb("CTL_MRR4EN", 1, ch_id);
    endtask : mr4_en_flow

    task cfg_mbist(input bit [31:0] mbistaddrbegin_mode3, input bit [31:0] mbistaddrend_mode3, input bit [31:0] mbistaddrstep_mode3, input bit [31:0] mbistrepeattime_mode3, input bit [31:0] mbistmodelist,input bit [7:0] mbistcs, input bit [31:0] mbistpattlist, input bit [3:0] prbsptnidx, input bit [1:0] mbistbkbbl, input bit [2:0] mbistcolbbl);
        set_field("PUM_TOP_MBISTMODELIST",mbistmodelist);

        set_field("PUM_TOP_MBISTBANKBBL",mbistbkbbl);
        set_field("PUM_TOP_MBISTCOLBBL",mbistcolbbl);
        set_field("PUM_TOP_PRBSPTNIDX",prbsptnidx);
        set_field("PUM_TOP_MBISTPATLIST",mbistpattlist);
        set_field("PUM_TOP_MBISTCS",mbistcs);
        set_field("PUM_TOP_MBISTADDRBEGIN1",mbistaddrbegin_mode3);
        set_field("PUM_TOP_MBISTADDREND1",mbistaddrend_mode3);
        set_field("PUM_TOP_MBISTWRRDREPEAT1",mbistrepeattime_mode3);
        set_field("PUM_TOP_MBISTADDRSTEP1",mbistaddrstep_mode3);

        set_field("PUM_TOP_SWINT",1'b1);
    endtask

    task do_mbist( );
        bit [31:0] mbist_done = 0 ;
        do begin
            get_field("PUM_TOP_SWINT",mbist_done);

        end while(mbist_done != 0);
        $display("mbist done...");
    endtask

    virtual task check_mbist_rslt();

        bit [31:0] csrMbistErrCnt[5] ;
        bit [31:0] csrMbistErrAddr[5] ;
        bit [31:0] csrMbistRslt[5] ;
        bit [31:0] csrMbistDone ;
        bit [31:0] csrMbistEn ;
        bit [31:0] csrMbistModeList ;
        bit [31:0] csrTestErrPatt[5][3] ;
        bit [31:0] csrTestExpPatt[5][3] ;

        for(int byte_num = 0 ; byte_num < 5; byte_num++ ) begin
            get_field($sformatf("PUM_TOP_MBISTERRCNT%0d",byte_num),csrMbistErrCnt[byte_num] );
            get_field($sformatf("PUM_TOP_MBISTERRADDR%0d",byte_num),csrMbistErrAddr[byte_num]);
            get_field($sformatf("PUM_TOP_MBISTRSLT%0d",byte_num),csrMbistRslt[byte_num]);
            $display("check_mbist_rslt: Byte:%0d, Err_cnt:%0d, ErrAddr:%0h, MbistRslt:%0h",byte_num,csrMbistErrCnt[byte_num], csrMbistErrAddr[byte_num],csrMbistRslt[byte_num]);
        end

        foreach(csrMbistErrCnt[byte_num]) begin
            if(csrMbistErrCnt[byte_num] != 0) begin

                for(int part = 0 ; part < 3 ; part++) begin
                    case({byte_num[2:0],part[2:0]})
                        {byte_num[2:0],part[2:0]}:set_field("PUM_TOP_TESTPATTOBSSEL",{byte_num[2:0],part[2:0]});
                    endcase
                    #20ns;
                    get_field("PUM_TOP_TESTERRPATT",csrTestErrPatt[byte_num][part]);
                    get_field("PUM_TOP_TESTEXPPATT",csrTestExpPatt[byte_num][part]);
                    $display("check_mbist_rslt: ErrPatt:%0h, ExpPatt:%0h",csrTestErrPatt[byte_num][part],csrTestExpPatt[byte_num][part]);
                end
            end
        end
    endtask

    task retention_phy_reg(input string act);

        static string    dr_save_reg_name[int][int][$];
        static bit [31:0] dr_save_reg_value[int][int][$];
        int fh;
        string line;
        string csrCfgFile;
        int freq_index=0;

        if (act == "normal_low_power") begin
            set_field_by_apb("PUM_TOP_CLKPUMGATEEN", 'h1f);
            return;
        end
        set_field_by_apb("PUM_TOP_DEVNUMCURR", 0);
        if(act=="save")
            $display("phy_reg_save");
        else
            $display("phy_reg_restore");
        for (int rank = 0 ; rank < 2; rank++) begin
            set_field_by_apb("PUM_TOP_RANKACCEPOINT", rank);
            csrCfgFile = $psprintf("./phy_csrconfig_f%0d.h",freq_index);
            fh= $fopen(csrCfgFile,"r");
            if (!fh) begin
                $display($psprintf("Cannot open file"));
                $finish;
            end
            set_field_by_apb("PUM_TOP_DATAFREQACCEPOINT", freq_index);
            set_field_by_apb("PUM_TOP_FREQACCEPOINT", freq_index);
            set_field_by_apb("PUM_TOP_FREQMULTICASTWR", 1'b0);
            set_field_by_apb("PUM_TOP_RANKMULTICASTWR", 1'b0);
            set_field_by_apb("PUM_TOP_LANEMULTICASTWR", 1'b0);

            while ($fgets(line,fh)) begin
                if(line.substr(0,6) == "`define") begin
                    string fieldname;
                    string fieldvalue;
                    string fieldstr;
                    bit [31:0] value;
                    bit name_start;
                    bit value_start;
                    int i,j;
                    i = 0;
                    line = line.substr(109,line.len()-1);
                    while(i < line.len()) begin

                        if (line.getc(i) != " " && line.getc(i) != "\n") begin
                            fieldstr = {fieldstr,line.getc(i)};
                        end
                        if (line.getc(i) == " " || line.getc(i) == "\n" ) begin
                            if (fieldstr != "") begin
                                name_start=1;
                                value_start=0;
                                fieldname = "";
                                fieldvalue = "";
                                j = 0;
                                while(j < fieldstr.len())begin
                                    if (name_start && fieldstr.getc(j) != ":")
                                        fieldname = {fieldname,fieldstr.getc(j)};
                                    if (fieldstr.getc(j) == ":" && name_start)
                                        name_start = 0;

                                    if (value_start)
                                        fieldvalue = {fieldvalue,fieldstr.getc(j)};
                                    if (fieldstr.getc(j) == "=" && !value_start)
                                        value_start = 1;
                                    j++;
                                end
                                end
                                fieldstr = "";
                                if (fieldname inside {"PUM_TOP_CSRCSRACCESSCTRL0", "PUM_TOP_CSRCSRACCESSCTRL1", "PUM_TOP_PLLCTRLBOOT", "PUM_TOP_PLLCTRL8XBOOT", "PUM_TOP_CMDFREQRATIOBOOT", "PUM_TOP_FREQACCEPOINT","PUM_TOP_RANKACCEPOINT", "PUM_TOP_LANEMULTICASTWR", "PUM_TOP_FREQMULTICASTWR", "PUM_TOP_RANKMULTICASTWR", "PUM_TOP_DATAFREQACCEPOINT", "PUM_TOP_DFIINITSTART", "PUM_TOP_DFIINITCOMPLETE","PUM_TOP_DATARETENTIONEN", "PUM_TOP_CLKPUMGATEEN", "PUM_TOP_CMDENGEN"}) begin
                                    //$display($psprintf("%s do not need csr_load", fieldname));
                                end else if ((fieldname.substr(0,4)=="DLANE" && (fieldname.substr(7,16)=="DLYTXCLKDQ" || fieldname.substr(7,16)=="DLYTXCLKDM" || fieldname.substr(7,16)=="DLYUPDCTRL" ))|| (fieldname.substr(0,4)=="CLANE" && fieldname.substr(7,15)=="DLYCMDBIT" ) ) begin
                                end else if (fieldname.substr(0,4)=="DLANE" && ((fieldname.substr(7,22) inside {"RXDQSSHAREENGENC","RXDQSSHAREPOSENC"}) || fieldname.substr(7,13)=="RXDMENC" || (fieldname.substr(7,14) inside {"RXDQ0ENC","RXDQ1ENC","RXDQ2ENC","RXDQ4ENC","RXDQ5ENC","RXDQ6ENC","RXDQ7ENC"}) )) begin
                                end else begin
                                    if(act=="save") begin
                                        get_field_by_apb(fieldname,value);
                                        dr_save_reg_name[rank][freq_index].push_back(fieldname);
                                        dr_save_reg_value[rank][freq_index].push_back(value);
                                    end else begin
                                        fieldname = dr_save_reg_name[rank][freq_index].pop_front();
                                        value     = dr_save_reg_value[rank][freq_index].pop_front();
                                        set_field_by_apb(fieldname,value);
                                    end
                                end
                            end
                            i++;
                        end
                    end else begin
                            continue;
                    end
            end
            $fclose(fh);
        end
        load_dfiprgm(act,"./firmware_prgm_file.h");
        save_restore_reg(act);
        if(act=="restore")begin
            set_field_by_apb("PUM_TOP_PUMNORMAL",1'b1);
            set_field_by_apb("PUM_TOP_PHYONDFI",1'b0);
            set_field_by_apb("PUM_TOP_MPUEN", 1'b1);
            set_field_by_apb("PUM_TOP_MPU01HWSEL", 1'b1);
            set_field_by_apb("PUM_TOP_MEMRESETCTRL", 'h3);
            set_field_by_apb("PUM_TOP_LANEMULTICASTWR", 1'b1);
            set_field_by_apb("CLANE0_CLANEOE", 'hf);
            set_field_by_apb("CLANEM_CLANEOE", 'hf);
            set_field_by_apb("PUM_TOP_LANEMULTICASTWR", 1'b0);

            set_field_by_apb("PUM_TOP_DATARETENTIONEN", 1'b1);
            set_field_by_apb("PUM_TOP_PUMINTMASK", 'h3F);
            set_field_by_apb(("PUM_TOP_RANKACCEPOINT"), 0);
            set_field_by_apb(("PUM_TOP_FREQACCEPOINT"), 0);
            set_field_by_apb(("PUM_TOP_DATAFREQACCEPOINT"), 0);
        end
    endtask

    virtual task load_dfiprgm(string act,string DfiPrgmFile);
        static string    dr_save_reg_name1[$];
        static bit [31:0] dr_save_reg_value1[$];
        string line;
        string insNum;
        bit[31:0] insValue;
        bit cmpRslt;
        int fhFw = $fopen(DfiPrgmFile, "r");
        if (!fhFw) begin
            $display($psprintf("Cannot open firmware file %0s", DfiPrgmFile));
            $finish;
        end
        while ($fgets(line, fhFw)) begin

            if(line.substr(0,6) != "`define") begin
                continue;
            end

            if ($sscanf(line, "%*s %s %*4s%32b", insNum, insValue)) begin
                $display($psprintf("insNum = %0s, insValue = %0x", insNum, insValue));
                if(act=="save")begin
                    get_field_by_apb(insNum,insValue);
                    dr_save_reg_name1.push_back(insNum);
                    dr_save_reg_value1.push_back(insValue);
                end else begin
                    insNum = dr_save_reg_name1.pop_front();
                    insValue   = dr_save_reg_value1.pop_front();
                    set_field_by_apb(insNum,insValue);
                end
            end
        end

        $fclose(fhFw);
        if(act=="save")
            $display("dfiprgmfile_save done");
        else
            $display("dfiprgmfile_restore done");
    endtask

    task save_restore_reg(input string action);
        bit[31:0] reg_data;
        bit[31:0] reg_value;
        string field_name;
        static string    dr_save_top[int][int][$];
        static bit [31:0] dr_save_top_val[int][int][$];
        get_field_by_apb("PUM_TOP_MPU01HWSEL", reg_data);
        set_field_by_apb("PUM_TOP_MPU01HWSEL", 1'b0);
        set_field_by_apb("PUM_TOP_DEVNUMCURR", 0);

        for (int rank = 0 ; rank <2; rank++) begin

            set_field_by_apb("PUM_TOP_RANKACCEPOINT", rank);
            for(int i=0;i<10;i++)begin
                field_name=$psprintf("PUM_TOP_DQBITSWAP_DL%0d",i);
                if(action=="save")begin
                    get_field_by_apb(field_name, reg_value);
                    dr_save_top[rank][0].push_back(field_name);
                    dr_save_top_val[rank][0].push_back(reg_value);
                end else begin
                    field_name = dr_save_top[rank][0].pop_front();
                    reg_value  = dr_save_top_val[rank][0].pop_front();
                    set_field_by_apb(field_name,reg_value);
                end
            end
            for(int i=0;i<10;i++)begin
                field_name=$psprintf("PUM_TOP_DMBITSWAP_DL%0d",i);
                if(action=="save")begin
                    get_field_by_apb(field_name, reg_value);
                    dr_save_top[rank][0].push_back(field_name);
                    dr_save_top_val[rank][0].push_back(reg_value);
                end else begin
                    field_name = dr_save_top[rank][0].pop_front();
                    reg_value  = dr_save_top_val[rank][0].pop_front();
                    set_field_by_apb(field_name,reg_value);
                end
            end
            for(int i=0;i<10;i++)begin
                field_name=$psprintf("DLANE%0d_DQBITSWAP",i);
                if(action=="save")begin
                    get_field_by_apb(field_name, reg_value);
                    dr_save_top[rank][0].push_back(field_name);
                    dr_save_top_val[rank][0].push_back(reg_value);
                end else begin
                    field_name = dr_save_top[rank][0].pop_front();
                    reg_value  = dr_save_top_val[rank][0].pop_front();
                    set_field_by_apb(field_name,reg_value);
                end
            end
            for(int i=0;i<10;i++)begin
                field_name=$psprintf("DLANE%0d_DMBITSWAP",i);
                if(action=="save")begin
                    get_field_by_apb(field_name, reg_value);
                    dr_save_top[rank][0].push_back(field_name);
                    dr_save_top_val[rank][0].push_back(reg_value);
                end else begin
                    field_name = dr_save_top[rank][0].pop_front();
                    reg_value  = dr_save_top_val[rank][0].pop_front();
                    set_field_by_apb(field_name,reg_value);
                end
            end
        end
        for (int rank = 0 ; rank < 2; rank++) begin
            int dev_num;
            int data_reg[132];
            int data_reg_index;
            set_field_by_apb("PUM_TOP_RANKACCEPOINT", rank);
            set_field_by_apb("PUM_TOP_DATAFREQACCEPOINT", 0);
            set_field_by_apb("PUM_TOP_FREQACCEPOINT", 0);

            data_reg='{0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,200,201,202,203,204,205,206,207,208,209,210,211,216,217,218,219,220,221,222,223,224,225,226,227,228,229,230,231,232,233,234,235,236,237,238,239,248,249,250,251,256,257,258,259,260,261,262,263,264,265,266,267,268,269,270,271,272,273,274,275,280,281,282,283,284,285,286,287,288,289,290,291,312,313,314,315,328,329,330,331,332,333,334,335,336,337,338,339,344,345,346,347,348,349,350,351,352,353,354,355,356,357,358,359,360,361,362,363,368,369,370,371,372,373,374,375};
            foreach(data_reg[i])begin
                data_reg_index=data_reg[i];
                if(data_reg_index<16) dev_num=10;
                if(data_reg_index>=200 && data_reg_index<=363) dev_num=1;
                if(data_reg_index>=368 && data_reg_index<=371) dev_num=10;
                if(data_reg_index>=372 && data_reg_index<=375) dev_num=5;
                field_name=$psprintf("PUM_DATA_DATA%0d",data_reg_index);
                for (int dev_index = 0; dev_index < dev_num; dev_index++)begin
                    set_field_by_apb("PUM_TOP_DEVNUMCURR", dev_index);
                    if(action=="save")begin
                        get_field_by_apb(field_name, reg_value);
                        dr_save_top[rank][dev_index].push_back(field_name);
                        dr_save_top_val[rank][dev_index].push_back(reg_value);
                    end else begin
                        field_name = dr_save_top[rank][dev_index].pop_front();
                        reg_value  = dr_save_top_val[rank][dev_index].pop_front();
                        set_field_by_apb(field_name,reg_value);
                    end
                end
            end
        end
        set_field_by_apb("PUM_TOP_MPU01HWSEL", reg_data);
        if(action=="save")
            $display("pumdata_save done");
        else
            $display("pumdata_restore done");

    endtask

    task vdd_force();
        uvm_hdl_force("top.ddrss_top.DRINT_VDDAO", 1);
    endtask

    task vdd_release();
        uvm_hdl_release("top.ddrss_top.DRINT_VDDAO");
    endtask

    task rst_force();
        uvm_hdl_force("top.rst_n", 1);
    endtask

    task rst_release();
        uvm_hdl_release("top.rst_n");
    endtask

    task change_to_hwref_flow(int ch_id );
        bit sw_ref_en;
        bit dfilpensr, sdramcgen;

        get_field_by_apb("CTL_REFSWEN", sw_ref_en, ch_id);
        if(sw_ref_en) begin
            get_field_by_apb("CTL_DFILPENSR", dfilpensr, ch_id);
            get_field_by_apb("CTL_SDRAMCGENSRSW", sdramcgen, ch_id);
            set_field_by_apb("CTL_DFILPENSR", 0, ch_id);
            set_field_by_apb("CTL_SDRAMCGENSRSW", 0, ch_id);

            sr_entry(ch_id);
            set_field_by_apb("CTL_REFSWEN", 0, ch_id);
            sr_exit(ch_id);
        end
    endtask

    task change_to_normal_ref_flow(int ch_id);
        bit [1:0] ref_mode;
        get_field_by_apb("CTL_REFMODE", ref_mode, ch_id);
        if(ref_mode !=0) begin
            fgr_flow(ch_id,1,0);
        end
    endtask

    task trig_sre_flow(int ch_id);
        bit pdnen, sren, zq, ctrlupd, mrr4;
        hold_xmu_uif(ch_id);

        exit_low_power_state(ch_id, pdnen, sren);

        disable_auto_cmd(ch_id, zq, ctrlupd, mrr4);

        polling_periodic_sw_event(ch_id);

        wait_field_2ch("CTL_CTLPDRAAISZERO", 1, ch_id);
        set_field_by_apb("CTL_SDRAMCGENSRSW", 1, ch_id);
        sr_entry(ch_id);
    endtask

    task mc_store_flow(int ch_id );
        int i;
        i = ch_id-1;
        set_field_by_apb("CTL_CTLPDSTATUSUPLOAD", 0, ch_id);
        set_field_by_apb("CTL_CTLPDSTATUSUPLOAD", 1, ch_id);

        get_field_by_apb("CTL_CTLPDUPDRAMSTATE",   up_dram_state[i],   ch_id);
        get_field_by_apb("CTL_CTLPDUPARBSTATE",   up_arb_state[i],    ch_id);
        get_field_by_apb("CTL_CTLPDUPTREFIEAB",     up_trefiab[i],      ch_id);
        get_field_by_apb("CTL_CTLPDUPTREFIEABORI", up_trefiab_ori[i],  ch_id);
        get_field_by_apb("CTL_CTLPDUPTREFIEPB",    up_trefipb[i],      ch_id);
        get_field_by_apb("CTL_CTLPDUPREFMODE",     up_refmode[i],      ch_id);
        get_field_by_apb("CTL_CTLPDUPREFABEN",     up_refaben[i],      ch_id);
        get_field_by_apb("CTL_CTLPDUPGLBSTATE",    up_glb_state[i],    ch_id);
        get_field_by_apb("CTL_CTLPDUPDIMMTYPE",    up_dimm_type[i],    ch_id);
        get_field_by_apb("CTL_CTLPDUPDDR45CFG",    up_dram_type[i],    ch_id);

        get_field_by_apb("CTL_CTLPDUPCNTPOSTPONER0",   up_cntpost_r0[i],  ch_id);
        get_field_by_apb("CTL_CTLPDUPCNTTREFIER0",     up_cnttrefi_r0[i], ch_id);
        get_field_by_apb("CTL_CTLPDUPCNTPOSTPONER1",   up_cntpost_r1[i],  ch_id);
        get_field_by_apb("CTL_CTLPDUPCNTTREFIER1",     up_cnttrefi_r1[i], ch_id);
        get_field_by_apb("CTL_CTLPDUPCNTPOSTPONER2",   up_cntpost_r2[i],  ch_id);
        get_field_by_apb("CTL_CTLPDUPCNTTREFIER2",     up_cnttrefi_r2[i], ch_id);
        get_field_by_apb("CTL_CTLPDUPCNTPOSTPONER3",   up_cntpost_r3[i],  ch_id);
        get_field_by_apb("CTL_CTLPDUPCNTTREFIER3",     up_cnttrefi_r3[i], ch_id);
        get_field_by_apb("CTL_CTLPDUPCNTPOSTPONER4",   up_cntpost_r4[i],  ch_id);
        get_field_by_apb("CTL_CTLPDUPCNTTREFIER4",     up_cnttrefi_r4[i], ch_id);
        get_field_by_apb("CTL_CTLPDUPCNTPOSTPONER5",   up_cntpost_r5[i],  ch_id);
        get_field_by_apb("CTL_CTLPDUPCNTTREFIER5",     up_cnttrefi_r5[i], ch_id); 
        get_field_by_apb("CTL_CTLPDUPCNTTREFIER6",     up_cnttrefi_r6[i], ch_id);
        get_field_by_apb("CTL_CTLPDUPCNTTREFIER6",     up_cnttrefi_r6[i], ch_id);
        get_field_by_apb("CTL_CTLPDUPCNTPOSTPONER7",   up_cntpost_r7[i],  ch_id);
        get_field_by_apb("CTL_CTLPDUPCNTTREFIER7",     up_cnttrefi_r7[i], ch_id);
        get_field_by_apb("CTL_CTLPDUPCNTPOSTPONER8",   up_cntpost_r8[i],  ch_id);
        get_field_by_apb("CTL_CTLPDUPCNTTREFIER8",     up_cnttrefi_r8[i], ch_id);
        get_field_by_apb("CTL_CTLPDUPCNTPOSTPONER9",   up_cntpost_r9[i],  ch_id);
        get_field_by_apb("CTL_CTLPDUPCNTTREFIER9",     up_cnttrefi_r9[i], ch_id);
        get_field_by_apb("CTL_CTLPDUPCNTPOSTPONER10",  up_cntpost_r10[i], ch_id);
        get_field_by_apb("CTL_CTLPDUPCNTTREFIER10",    up_cnttrefi_r10[i], ch_id);
        get_field_by_apb("CTL_CTLPDUPCNTPOSTPONER11",  up_cntpost_r11[i], ch_id);
        get_field_by_apb("CTL_CTLPDUPCNTTREFIER11",    up_cnttrefi_r11[i], ch_id);
        get_field_by_apb("CTL_CTLPDUPCNTPOSTPONER12",  up_cntpost_r12[i], ch_id);
        get_field_by_apb("CTL_CTLPDUPCNTTREFIER12",    up_cnttrefi_r12[i], ch_id);
        get_field_by_apb("CTL_CTLPDUPCNTPOSTPONER13",  up_cntpost_r13[i], ch_id);
        get_field_by_apb("CTL_CTLPDUPCNTTREFIER13",    up_cnttrefi_r13[i], ch_id);
        get_field_by_apb("CTL_CTLPDUPCNTPOSTPONER14",  up_cntpost_r14[i], ch_id);
        get_field_by_apb("CTL_CTLPDUPCNTTREFIER14",    up_cnttrefi_r14[i], ch_id);
        get_field_by_apb("CTL_CTLPDUPCNTPOSTPONER15",  up_cntpost_r15[i], ch_id);
        get_field_by_apb("CTL_CTLPDUPCNTTREFIER15",    up_cnttrefi_r15[i], ch_id);
        get_field_by_apb("CTL_CTLPDUPCNTPOSTPONER16",  up_cntpost_r16[i], ch_id);
        get_field_by_apb("CTL_CTLPDUPCNTTREFIER16",    up_cnttrefi_r16[i], ch_id);
        get_field_by_apb("CTL_CTLPDUPCNTPOSTPONER17",  up_cntpost_r17[i], ch_id);
        get_field_by_apb("CTL_CTLPDUPCNTTREFIER17",    up_cnttrefi_r17[i], ch_id);
        get_field_by_apb("CTL_CTLPDUPCNTPOSTPONER18",  up_cntpost_r18[i], ch_id);
        get_field_by_apb("CTL_CTLPDUPCNTTREFIER18",    up_cnttrefi_r18[i], ch_id);
        get_field_by_apb("CTL_CTLPDUPCNTPOSTPONER19",  up_cntpost_r19[i], ch_id);
        get_field_by_apb("CTL_CTLPDUPCNTTREFIER19",    up_cnttrefi_r19[i], ch_id);
        get_field_by_apb("CTL_CTLPDUPCNTPOSTPONER20",  up_cntpost_r20[i], ch_id);
        get_field_by_apb("CTL_CTLPDUPCNTTREFIER20",    up_cnttrefi_r20[i], ch_id);
        get_field_by_apb("CTL_CTLPDUPCNTPOSTPONER21",  up_cntpost_r21[i], ch_id);
        get_field_by_apb("CTL_CTLPDUPCNTTREFIER21",    up_cnttrefi_r21[i], ch_id);
        get_field_by_apb("CTL_CTLPDUPCNTPOSTPONER22",  up_cntpost_r22[i], ch_id);
        get_field_by_apb("CTL_CTLPDUPCNTTREFIER22",    up_cnttrefi_r22[i], ch_id);
        get_field_by_apb("CTL_CTLPDUPCNTPOSTPONER23",  up_cntpost_r23[i], ch_id);
        get_field_by_apb("CTL_CTLPDUPCNTTREFIER23",    up_cnttrefi_r23[i], ch_id);
        get_field_by_apb("CTL_CTLPDUPCNTPOSTPONER24",  up_cntpost_r24[i], ch_id);
        get_field_by_apb("CTL_CTLPDUPCNTTREFIER24",    up_cnttrefi_r24[i], ch_id);
        get_field_by_apb("CTL_CTLPDUPCNTPOSTPONER25",  up_cntpost_r25[i], ch_id);
        get_field_by_apb("CTL_CTLPDUPCNTTREFIER25",    up_cnttrefi_r25[i], ch_id);
        get_field_by_apb("CTL_CTLPDUPCNTPOSTPONER26",  up_cntpost_r26[i], ch_id);
        get_field_by_apb("CTL_CTLPDUPCNTTREFIER26",    up_cnttrefi_r26[i], ch_id);
        get_field_by_apb("CTL_CTLPDUPCNTPOSTPONER27",  up_cntpost_r27[i], ch_id);
        get_field_by_apb("CTL_CTLPDUPCNTTREFIER27",    up_cnttrefi_r27[i], ch_id);
        get_field_by_apb("CTL_CTLPDUPCNTPOSTPONER28",  up_cntpost_r28[i], ch_id);
        get_field_by_apb("CTL_CTLPDUPCNTTREFIER28",    up_cnttrefi_r28[i], ch_id);
        get_field_by_apb("CTL_CTLPDUPCNTPOSTPONER29",  up_cntpost_r29[i], ch_id);
        get_field_by_apb("CTL_CTLPDUPCNTTREFIER29",    up_cnttrefi_r29[i], ch_id);
        get_field_by_apb("CTL_CTLPDUPCNTPOSTPONER30",  up_cntpost_r30[i], ch_id);
        get_field_by_apb("CTL_CTLPDUPCNTTREFIER30",    up_cnttrefi_r30[i], ch_id);
        get_field_by_apb("CTL_CTLPDUPCNTPOSTPONER31",  up_cntpost_r31[i], ch_id);
        get_field_by_apb("CTL_CTLPDUPCNTTREFIER31",    up_cnttrefi_r31[i], ch_id);
    endtask

    task mc_reload_flow(int ch_id );
        int i;
        i = ch_id-1;

        set_field_by_apb("CTL_SDRAMCGENSRSW", 1);

        set_field_by_apb("CTL_CTLPDDNDRAMSTATE",   up_dram_state[i],   ch_id);
        set_field_by_apb("CTL_CTLPDDNARBSTATE",    up_arb_state[i],    ch_id);
        set_field_by_apb("CTL_CTLPDDNTREFIEAB",     up_trefiab[i],      ch_id);
        set_field_by_apb("CTL_CTLPDDNTREFIEABORI", up_trefiab_ori[i],  ch_id);
        set_field_by_apb("CTL_CTLPDDNTREFIEPB",    up_trefipb[i],      ch_id);
        set_field_by_apb("CTL_CTLPDDNREFMODE",     up_refmode[i],      ch_id);
        set_field_by_apb("CTL_CTLPDDNREFABEN",     up_refaben[i],      ch_id);
        set_field_by_apb("CTL_CTLPDDNGLBSTATE",    up_glb_state[i],    ch_id);
        set_field_by_apb("CTL_CTLPDDNDIMMTYPE",    up_dimm_type[i],    ch_id);
        set_field_by_apb("CTL_CTLPDDNDDR45CFG",    up_dram_type[i],    ch_id);

        get_field_by_apb("CTL_CTLPDDNCNTPOSTPONER0",   up_cntpost_r0[i],  ch_id);
        get_field_by_apb("CTL_CTLPDDNCNTTREFIER0",     up_cnttrefi_r0[i], ch_id);
        get_field_by_apb("CTL_CTLPDDNCNTPOSTPONER1",   up_cntpost_r1[i],  ch_id);
        get_field_by_apb("CTL_CTLPDDNCNTTREFIER1",     up_cnttrefi_r1[i], ch_id);
        get_field_by_apb("CTL_CTLPDDNCNTPOSTPONER2",   up_cntpost_r2[i],  ch_id);
        get_field_by_apb("CTL_CTLPDDNCNTTREFIER2",     up_cnttrefi_r2[i], ch_id);
        get_field_by_apb("CTL_CTLPDDNCNTPOSTPONER3",   up_cntpost_r3[i],  ch_id);
        get_field_by_apb("CTL_CTLPDDNCNTTREFIER3",     up_cnttrefi_r3[i], ch_id);
        get_field_by_apb("CTL_CTLPDDNCNTPOSTPONER4",   up_cntpost_r4[i],  ch_id);
        get_field_by_apb("CTL_CTLPDDNCNTTREFIER4",     up_cnttrefi_r4[i], ch_id);
        get_field_by_apb("CTL_CTLPDDNCNTPOSTPONER5",   up_cntpost_r5[i],  ch_id);
        get_field_by_apb("CTL_CTLPDDNCNTTREFIER5",     up_cnttrefi_r5[i], ch_id);
        get_field_by_apb("CTL_CTLPDDNCNTPOSTPONER6",   up_cntpost_r6[i],  ch_id);
        get_field_by_apb("CTL_CTLPDDNCNTTREFIER6",     up_cnttrefi_r6[i], ch_id);
        get_field_by_apb("CTL_CTLPDDNCNTPOSTPONER7",   up_cntpost_r7[i],  ch_id);
        get_field_by_apb("CTL_CTLPDDNCNTTREFIER7",     up_cnttrefi_r7[i], ch_id);
        get_field_by_apb("CTL_CTLPDDNCNTPOSTPONER8",   up_cntpost_r8[i],  ch_id);
        get_field_by_apb("CTL_CTLPDDNCNTTREFIER8",     up_cnttrefi_r8[i], ch_id);
        get_field_by_apb("CTL_CTLPDDNCNTPOSTPONER9",   up_cntpost_r9[i],  ch_id);
        get_field_by_apb("CTL_CTLPDDNCNTTREFIER9",     up_cnttrefi_r9[i], ch_id);
        get_field_by_apb("CTL_CTLPDDNCNTPOSTPONER10",  up_cntpost_r10[i], ch_id);
        get_field_by_apb("CTL_CTLPDDNCNTTREFIER10",    up_cnttrefi_r10[i], ch_id);
        get_field_by_apb("CTL_CTLPDDNCNTPOSTPONER11",  up_cntpost_r11[i], ch_id);
        get_field_by_apb("CTL_CTLPDDNCNTTREFIER11",    up_cnttrefi_r11[i], ch_id);
        get_field_by_apb("CTL_CTLPDDNCNTPOSTPONER12",  up_cntpost_r12[i], ch_id);
        get_field_by_apb("CTL_CTLPDDNCNTTREFIER12",    up_cnttrefi_r12[i], ch_id);
        get_field_by_apb("CTL_CTLPDDNCNTPOSTPONER13",  up_cntpost_r13[i], ch_id);
        get_field_by_apb("CTL_CTLPDDNCNTTREFIER13",    up_cnttrefi_r13[i], ch_id);
        get_field_by_apb("CTL_CTLPDDNCNTPOSTPONER14",  up_cntpost_r14[i], ch_id);
        get_field_by_apb("CTL_CTLPDDNCNTTREFIER14",    up_cnttrefi_r14[i], ch_id);
        get_field_by_apb("CTL_CTLPDDNCNTPOSTPONER15",  up_cntpost_r15[i], ch_id);
        get_field_by_apb("CTL_CTLPDDNCNTTREFIER15",    up_cnttrefi_r15[i], ch_id);
        get_field_by_apb("CTL_CTLPDDNCNTPOSTPONER16",  up_cntpost_r16[i], ch_id);
        get_field_by_apb("CTL_CTLPDDNCNTTREFIER16",    up_cnttrefi_r16[i], ch_id);
        get_field_by_apb("CTL_CTLPDDNCNTPOSTPONER17",  up_cntpost_r17[i], ch_id);
        get_field_by_apb("CTL_CTLPDDNCNTTREFIER17",    up_cnttrefi_r17[i], ch_id);
        get_field_by_apb("CTL_CTLPDDNCNTPOSTPONER18",  up_cntpost_r18[i], ch_id);
        get_field_by_apb("CTL_CTLPDDNCNTTREFIER18",    up_cnttrefi_r18[i], ch_id);
        get_field_by_apb("CTL_CTLPDDNCNTPOSTPONER19",  up_cntpost_r19[i], ch_id);
        get_field_by_apb("CTL_CTLPDDNCNTTREFIER19",    up_cnttrefi_r19[i], ch_id);
        get_field_by_apb("CTL_CTLPDDNCNTPOSTPONER20",  up_cntpost_r20[i], ch_id);
        get_field_by_apb("CTL_CTLPDDNCNTTREFIER20",    up_cnttrefi_r20[i], ch_id);
        get_field_by_apb("CTL_CTLPDDNCNTPOSTPONER21",  up_cntpost_r21[i], ch_id);
        get_field_by_apb("CTL_CTLPDDNCNTTREFIER21",    up_cnttrefi_r21[i], ch_id);
        get_field_by_apb("CTL_CTLPDDNCNTPOSTPONER22",  up_cntpost_r22[i], ch_id);
        get_field_by_apb("CTL_CTLPDDNCNTTREFIER22",    up_cnttrefi_r22[i], ch_id);
        get_field_by_apb("CTL_CTLPDDNCNTPOSTPONER23",  up_cntpost_r23[i], ch_id);
        get_field_by_apb("CTL_CTLPDDNCNTTREFIER23",    up_cnttrefi_r23[i], ch_id);
        get_field_by_apb("CTL_CTLPDDNCNTPOSTPONER24",  up_cntpost_r24[i], ch_id);
        get_field_by_apb("CTL_CTLPDDNCNTTREFIER24",    up_cnttrefi_r24[i], ch_id);
        get_field_by_apb("CTL_CTLPDDNCNTPOSTPONER25",  up_cntpost_r25[i], ch_id);
        get_field_by_apb("CTL_CTLPDDNCNTTREFIER25",    up_cnttrefi_r25[i], ch_id);
        get_field_by_apb("CTL_CTLPDDNCNTPOSTPONER26",  up_cntpost_r26[i], ch_id);
        get_field_by_apb("CTL_CTLPDDNCNTTREFIER26",    up_cnttrefi_r26[i], ch_id);
        get_field_by_apb("CTL_CTLPDDNCNTPOSTPONER27",  up_cntpost_r27[i], ch_id);
        get_field_by_apb("CTL_CTLPDDNCNTTREFIER27",    up_cnttrefi_r27[i], ch_id);
        get_field_by_apb("CTL_CTLPDDNCNTPOSTPONER28",  up_cntpost_r28[i], ch_id);
        get_field_by_apb("CTL_CTLPDDNCNTTREFIER28",    up_cnttrefi_r28[i], ch_id);
        get_field_by_apb("CTL_CTLPDDNCNTPOSTPONER29",  up_cntpost_r29[i], ch_id);
        get_field_by_apb("CTL_CTLPDDNCNTTREFIER29",    up_cnttrefi_r29[i], ch_id);
        get_field_by_apb("CTL_CTLPDDNCNTPOSTPONER30",  up_cntpost_r30[i], ch_id);
        get_field_by_apb("CTL_CTLPDDNCNTTREFIER30",    up_cnttrefi_r30[i], ch_id);
        get_field_by_apb("CTL_CTLPDDNCNTPOSTPONER31",  up_cntpost_r31[i], ch_id);
        get_field_by_apb("CTL_CTLPDDNCNTTREFIER31",    up_cnttrefi_r31[i], ch_id);

        set_field_by_apb("CTL_CTLPDSTATUSDNLOAD", 0, ch_id);
        set_field_by_apb("CTL_CTLPDSTATUSDNLOAD", 1, ch_id);
    endtask

    task isolation_cell_force();
        uvm_hdl_force("top.ddrss_top.inst_ddr_ctl_ch0.inst_core.dfi_alert_n_a0", 1);
        uvm_hdl_force("top.ddrss_top.inst_ddr_ctl_ch0.inst_core.dfi_alert_n_a1", 1);
        uvm_hdl_force("top.ddrss_top.inst_ddr_ctl_ch0.inst_core.dfi_alert_n_a2", 1);
        uvm_hdl_force("top.ddrss_top.inst_ddr_ctl_ch0.inst_core.dfi_alert_n_a3", 1);
        uvm_hdl_force("top.ddrss_top.inst_ddr_ctl_ch1.inst_core.dfi_alert_n_a0", 1);
        uvm_hdl_force("top.ddrss_top.inst_ddr_ctl_ch1.inst_core.dfi_alert_n_a1", 1);
        uvm_hdl_force("top.ddrss_top.inst_ddr_ctl_ch1.inst_core.dfi_alert_n_a2", 1);
        uvm_hdl_force("top.ddrss_top.inst_ddr_ctl_ch1.inst_core.dfi_alert_n_a3", 1);
    endtask

    task isolation_cell_release();
        uvm_hdl_release("top.ddrss_top.inst_ddr_ctl_ch0.inst_core.dfi_alert_n_a0");
        uvm_hdl_release("top.ddrss_top.inst_ddr_ctl_ch0.inst_core.dfi_alert_n_a1");
        uvm_hdl_release("top.ddrss_top.inst_ddr_ctl_ch0.inst_core.dfi_alert_n_a2");
        uvm_hdl_release("top.ddrss_top.inst_ddr_ctl_ch0.inst_core.dfi_alert_n_a3");
        uvm_hdl_release("top.ddrss_top.inst_ddr_ctl_ch1.inst_core.dfi_alert_n_a0");
        uvm_hdl_release("top.ddrss_top.inst_ddr_ctl_ch1.inst_core.dfi_alert_n_a1");
        uvm_hdl_release("top.ddrss_top.inst_ddr_ctl_ch1.inst_core.dfi_alert_n_a2");
        uvm_hdl_release("top.ddrss_top.inst_ddr_ctl_ch1.inst_core.dfi_alert_n_a3");
    endtask

    task refmode_1x_cfg(int ch_id);
        for(int i=0; i<4; i++) begin
            set_field_by_apb("CTL_FREQACCEPOINT", i, ch_id);
            set_field_by_apb("CTL_REFMODE", 0, ch_id);
            set_field_by_apb("CTL_REFABEN", 1, ch_id);
            set_field_by_apb("CTL_MR4VALUE", 1, ch_id);
        end
    endtask

endclass     