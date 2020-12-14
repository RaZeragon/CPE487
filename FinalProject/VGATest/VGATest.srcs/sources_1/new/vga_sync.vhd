LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_UNSIGNED.ALL;

ENTITY vga_sync IS
    PORT(
        clk_in              : IN STD_LOGIC;
        R_IN, G_IN, B_IN    : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
        HSYNC, VSYNC        : OUT STD_LOGIC;
        DISPLAY_OUT         : OUT STD_LOGIC;
        R_OUT, G_OUT, B_OUT : OUT STD_LOGIC_VECTOR(3 DOWNTO 0);
        X_POS, Y_POS        : OUT INTEGER
    );
END vga_sync;

ARCHITECTURE Behavioral of vga_sync IS
    -- VGA Constants 
    CONSTANT H      : INTEGER := 640;
    CONSTANT V      : INTEGER := 480;
    CONSTANT H_FP   : INTEGER := 16;
    CONSTANT H_BP   : INTEGER := 48;
    CONSTANT H_SYNC : INTEGER := 96;
    CONSTANT V_FP   : INTEGER := 10;
    CONSTANT V_BP   : INTEGER := 29;
    CONSTANT V_SYNC : INTEGER := 2;
    CONSTANT FREQ   : INTEGER := 60;
    
BEGIN
PROCESS(clk_in)
    VARIABLE HPOS       : INTEGER := 0;
    VARIABLE VPOS       : INTEGER := 0;
    VARIABLE DISPLAY    : STD_LOGIC;
BEGIN
    IF (clk_in'EVENT AND clk_in ='1') THEN
        -- Runs through each pixel from left to right and then going down a row
        IF (HPOS < H + H_FP + H_BP + H_SYNC) THEN
            HPOS := HPOS + 1;
        ELSE
            HPOS := 0;
            IF (VPOS < V + V_FP + V_BP + V_SYNC) THEN
                VPOS := VPOS + 1;
            ELSE
                VPOS := 0;
            END IF;
        END IF;
        
        X_POS <= HPOS - 144;
        Y_POS <= VPOS - 31;
        
        -- Setting up VSYNC and HSYNC signals (synchronization)
        -- If the signal is low between Front Porch and Back Porch, else it's high
        IF (HPOS >= H_FP AND HPOS < (H_BP + H_SYNC)) THEN
            HSYNC <= '0';
        ELSE
            HSYNC <= '1';
        END IF;
        
        IF (VPOS >= V_FP AND VPOS < (V_BP + V_SYNC)) THEN
            VSYNC <= '0';
        ELSE
            VSYNC <= '1';
        END IF;
        
        -- Only display colors when needed
        IF (HPOS >= (H_SYNC + H_BP) AND HPOS < (800 - H_FP)) THEN
            DISPLAY := '1';
            R_OUT <= R_IN;
            G_OUT <= G_IN;
            B_OUT <= B_IN;
        ELSE
            DISPLAY := '0';
            R_OUT <= "0000";
            G_OUT <= "0000";
            B_OUT <= "0000";
        END IF;
    END IF;  
END PROCESS;
END Behavioral;
