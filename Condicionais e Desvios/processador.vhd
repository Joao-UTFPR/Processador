library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity processador is
    port(
        clock:          IN std_logic;
        reset:          IN std_logic;
        clock_o:        OUT std_logic;
        reset_o:        OUT std_logic;
        estado_o:       OUT unsigned(1 downto 0);
        pc_o:           OUT unsigned(6 downto 0);
        instruction_o:  OUT unsigned(15 downto 0);
        reg1_o:         OUT unsigned(15 downto 0);
        reg2_o:         OUT unsigned(15 downto 0);
        ula_o:          OUT unsigned(15 downto 0)
    );
end;

architecture a_processador of processador is
    component PC is 
        port(
            clock:          in std_logic;
            reset :         in std_logic;
            writeEnable :   in std_logic;
            data_in :       in unsigned(6 downto 0);
            data_out :      out unsigned(6 downto 0)
        );
    end component;

    component UC is
        port(
            clock:                          IN std_logic;
            reset:                          IN std_logic;
            instruction:                    IN unsigned(15 downto 0);
            pcPrevious:                     IN unsigned(6 downto 0);
            branchFlag:                     IN std_logic;
            pcNext:                         OUT unsigned(6 downto 0);
            memoryReadEnable:               OUT std_logic;
            instructionRegisterWriteEnable: OUT std_logic;
            ulaSel:                         OUT unsigned(2 downto 0);
            muxUlaBSel:                     OUT std_logic;
            registerBankWriteEnable:        OUT std_logic;
            estado:                         OUT unsigned(1 downto 0);
            BranchTypeSel:                  OUT std_logic
        );
    end component;

    component rom is
        port( 
            clock :     IN std_logic;
            endereco :  IN unsigned(6 downto 0);
            readEnable: IN std_logic;
            memoryOut : OUT unsigned(15 downto 0)
         );
    end component;

    component instructionRegister is
        port(
            clock:              IN std_logic;
            reset :             IN std_logic;
            writeEnable :       IN std_logic;
            instruction_in :    IN unsigned(15 downto 0);
            instruction_out :   OUT unsigned(15 downto 0)
        );
    end component;

    component ula is
        port(
            A,B :               in unsigned(15 downto 0);
            ULA_sel:            in unsigned(2 downto 0);
            ULA_out:            out unsigned(15 downto 0);
            carrySubtr, eqSign: out std_logic
        );
    end component;

    component registerBank is
        port(
            selRegRead1, selRegRead2:   IN unsigned(2 downto 0);
            writeData:                  IN unsigned(15 downto 0);
            selRegWrite:                IN unsigned(2 downto 0);
            writeEnable:                IN std_logic;
            clock:                      IN std_logic;
            reset:                      IN std_logic;
            Reg1Data, Reg2Data:         OUT unsigned(15 downto 0)
        );
    end component;

    component mux2x1 port(
        sel            : in std_logic;
        in0, in1       : in unsigned;
        saida          : out unsigned(15 downto 0)
    );
    end component;

    component mux2x1_std_logic port
    (
        sel            : in std_logic;
        in0, in1       : in std_logic;
        saida          : out std_logic
    );
    end component;

    component branchFlag is
        port(
            clock:          in std_logic;
            reset :         in std_logic;
            writeEnable :   in std_logic;
            data_in :       in std_logic;
            data_out :      out std_logic
        );
    end component;

    signal pc_in_s, pc_out_s: unsigned(6 downto 0);
    signal memory_data_s, instruction_s : unsigned(15 downto 0);
    signal memory_read_enable_s,instructionRegisterWriteEnable_s, registerBankWriteEnable_s, pcWriteEnable_s, branchFlagWriteEnable_s: std_logic;
    signal ulaSel_s: unsigned(2 downto 0);
    signal ulaOut_s: unsigned(15 downto 0);
    signal carrySubtr_s, overFlow_s, muxUlaBSel_s, branch_flag_s, branch_flag_data_in_s,BranchTypeSel_s,eqSign_s: std_logic;
    signal reg1Data_s, reg2Data_s, muxUlaBOut_S: unsigned(15 downto 0);
    signal estado_s: unsigned(1 downto 0);


begin
    read_only_memory:rom port map(
        clock       =>clock,
        endereco    =>pc_out_s,
        memoryOut   =>memory_data_s,
        readEnable  =>memory_read_enable_s
        );

    control_unity:UC port map(
        reset                   =>reset,
        clock                   =>clock,
        memoryReadEnable        =>memory_read_enable_s,
        pcPrevious              =>pc_out_s,
        branchFlag              =>branch_flag_s,
        pcNext                  =>pc_in_s,
        instruction             =>instruction_s,
        ulaSel                  =>ulaSel_s,
        muxUlaBSel              =>muxUlaBSel_s,
        instructionRegisterWriteEnable=> instructionRegisterWriteEnable_s,
        registerBankWriteEnable =>registerBankWriteEnable_s,
        estado                  =>estado_s,
        BranchTypeSel           =>BranchTypeSel_s
        );

    pcWriteEnable_s<=
        '1' when estado_s="10" else
        '0';
    program_counter:PC port map(
        reset                           =>reset,
        clock                           =>clock,
        writeEnable                     =>pcWriteEnable_s,
        data_in                         =>pc_in_s,
        data_out                        =>pc_out_s
        );

    branchFlagWriteEnable_s<=
        '1' when estado_s="01" else
        '0';

    branch_flag:branchFlag port map(
        reset       =>reset,
        clock       =>clock,
        writeEnable =>branchFlagWriteEnable_s,
        data_in     =>branch_flag_data_in_s,
        data_out    =>branch_flag_s
    );
    
    instruction_register:instructionRegister port map(
        clock=>clock,
        reset=>reset,
        writeEnable=>instructionRegisterWriteEnable_s,
        instruction_in=>memory_data_s,
        instruction_out=>instruction_s
    );

    banco_de_registradores:registerBank port map(
        selRegRead1=>instruction_s(11 downto 9),
        selRegRead2=>instruction_s(8 downto 6),
        writeData=>ulaOut_s,
        selRegWrite=>instruction_s(2 downto 0),
        writeEnable=>registerBankWriteEnable_s,
        clock=>clock,
        reset=>reset,
        reg1Data=>reg1Data_s,
        reg2Data=>reg2Data_s
    );
    
    mux_ula_b: mux2x1 port map(
        sel=>muxUlaBSel_s,
        in0=>instruction_s(8 downto 4),
        in1=>reg2Data_s,
        saida=>muxUlaBOut_S
    );

    mux_branch_flag: mux2x1_std_logic port map(
        sel=>BranchTypeSel_s,
        in0=>"not"(eqSign_s),
        in1=>"not"(carrySubtr_s),
        saida=>branch_flag_data_in_s
    );

    unidade_logica_aritmetica: ula port map(
        A=>reg1Data_s,
        B=>muxUlaBOut_S,
        ULA_sel=>ulaSel_s,
        ULA_out=> ulaOut_s,
        carrySubtr=>carrySubtr_s,
        eqSign=>eqSign_s
    );
    
    clock_o         <=clock;
    reset_o         <=reset; 
    estado_o        <=estado_s;
    pc_o            <=pc_out_s;
    instruction_o   <=instruction_s;
    reg1_o          <=reg1Data_s;
    reg2_o          <=reg2Data_s;
    ula_o           <=ulaOut_s;
end architecture;