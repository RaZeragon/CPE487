LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_UNSIGNED.ALL;

ENTITY vga_top IS
    PORT(
        clk_in                  : IN STD_LOGIC;
        VGA_HS, VGA_VS          : OUT STD_LOGIC;
        VGA_R, VGA_G, VGA_B     : OUT STD_LOGIC_VECTOR(3 DOWNTO 0);
        KB_COL                  : OUT STD_LOGIC_VECTOR(4 DOWNTO 1); 
        KB_ROW                  : IN STD_LOGIC_VECTOR(4 DOWNTO 1)
    );
END vga_top;

ARCHITECTURE Behavioral OF vga_top IS
    COMPONENT vga_sync IS
        PORT(
            PXL_CLK             : IN STD_LOGIC;
            R_IN, G_IN, B_IN    : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
            HSYNC, VSYNC        : OUT STD_LOGIC;
            DISPLAY_OUT         : OUT STD_LOGIC;
            R_OUT, G_OUT, B_OUT : OUT STD_LOGIC_VECTOR(3 DOWNTO 0);
            X_POS, Y_POS        : OUT INTEGER
        );
    END COMPONENT vga_sync;
    
    COMPONENT tictactoe IS
        PORT (
            PXL_CLK             : IN STD_LOGIC;
            KP_CLK, SM_CLK      : IN STD_LOGIC;
            DISPLAY             : IN STD_LOGIC;
            X_POS, Y_POS        : IN INTEGER;
            PRESS               : IN STD_LOGIC; 
            INPUT               : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
            R_OUT, G_OUT, B_OUT : OUT STD_LOGIC_VECTOR(3 DOWNTO 0)
        );
    END COMPONENT tictactoe;
    
    COMPONENT clk_wiz_0 IS
        PORT (
            clk_in1 : IN STD_LOGIC;
            clk_out1 : OUT STD_LOGIC
        );
    END COMPONENT clk_wiz_0;
    
    COMPONENT keypad IS
        PORT (
            PXL_CLK   : IN STD_LOGIC;
            COL       : OUT STD_LOGIC_VECTOR (4 DOWNTO 1);
            ROW       : IN STD_LOGIC_VECTOR (4 DOWNTO 1);
            VALUE     : OUT STD_LOGIC_VECTOR (3 DOWNTO 0);
            HIT       : OUT STD_LOGIC
        );
    END COMPONENT keypad;
    
--    COMPONENT clk IS
--        PORT (
--            clk_in  : IN STD_LOGIC;
--            clk_out : OUT STD_LOGIC
--        );
--    END COMPONENT clk;
    
    -- Internal Signals
    SIGNAL CLK_108, SM_CLK, KP_CLK  : STD_LOGIC;
    SIGNAL CNT                      : STD_LOGIC_VECTOR(20 DOWNTO 0);
    SIGNAL display                  : STD_LOGIC := '0';
    SIGNAL red, green, blue         : STD_LOGIC_VECTOR(3 DOWNTO 0) := "0000";
    SIGNAL SX_POS                   : INTEGER := -1;
    SIGNAL SY_POS                   : INTEGER := -1;
    SIGNAL KP_VAL                   : STD_LOGIC_VECTOR(3 DOWNTO 0);
    SIGNAL KP_HIT                   : STD_LOGIC;
    
    
BEGIN
    clk_proc : PROCESS (clk_in)
	BEGIN
		IF RISING_EDGE(clk_in) THEN -- on rising edge of clock
			CNT <= CNT + 1; -- increment counter
		END IF;
	END PROCESS clk_proc;
	
	KP_CLK <= CNT(15); -- keypad interrogation clock
	SM_CLK <= CNT(20); -- state machine clock
    
    vga_driver : vga_sync
    PORT MAP(
        PXL_CLK => CLK_108,
        R_IN => red,
        G_IN => green,
        B_IN => blue,
        HSYNC => VGA_HS,
        VSYNC => VGA_VS,
        DISPLAY_OUT => display,
        R_OUT => VGA_R,
        G_OUT => VGA_G,
        B_OUT => VGA_B,
        X_POS => SX_POS,
        Y_POS => SY_POS
    );
    
    ttt_logic : tictactoe
    PORT MAP(
        PXL_CLK => CLK_108,
        KP_CLK => KP_CLK,
        SM_CLK => SM_CLK,
        DISPLAY => display,
        X_POS => SX_POS,
        Y_POS => SY_POS,
        INPUT => KP_VAL,
        PRESS => KP_HIT,
        R_OUT => red,
        G_OUT => green,
        B_OUT => blue
    );
    
    clk_wiz_0_inst : clk_wiz_0
    PORT MAP (
        clk_in1 => clk_in,
        clk_out1 => CLK_108
    );
    
    input : keypad
    PORT MAP (
        PXL_CLK => KP_CLK,
        COL => KB_COL,
        ROW => KB_ROW,
        VALUE => KP_VAL,
        HIT => KP_HIT
    );
    
--    clk_wiz : clk
--    PORT MAP(
--        clk_in => clk_in,
--        clk_out => CLK_25
--    );
END Behavioral;
