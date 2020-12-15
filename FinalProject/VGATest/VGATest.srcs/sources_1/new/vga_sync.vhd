LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_UNSIGNED.ALL;

ENTITY vga_sync IS
    PORT(
        PXL_CLK             : IN STD_LOGIC;
        R_IN, G_IN, B_IN    : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
        HSYNC, VSYNC        : OUT STD_LOGIC;
        DISPLAY_OUT         : OUT STD_LOGIC;
        R_OUT, G_OUT, B_OUT : OUT STD_LOGIC_VECTOR(3 DOWNTO 0);
        X_POS, Y_POS        : OUT INTEGER
    );
END vga_sync;

ARCHITECTURE Behavioral of vga_sync IS
    -- VGA Constants 
    CONSTANT H      : INTEGER := 800;
    CONSTANT V      : INTEGER := 600;
    CONSTANT H_FP   : INTEGER := 40;
    CONSTANT H_BP   : INTEGER := 88;
    CONSTANT H_SYNC : INTEGER := 128;
    CONSTANT V_FP   : INTEGER := 1;
    CONSTANT V_BP   : INTEGER := 23;
    CONSTANT V_SYNC : INTEGER := 4;
    
BEGIN
PROCESS(PXL_CLK)
    VARIABLE HPOS       : INTEGER := 0;
    VARIABLE VPOS       : INTEGER := 0;
    VARIABLE DISPLAY    : STD_LOGIC;
BEGIN
    IF (PXL_CLK'EVENT AND PXL_CLK ='1') THEN
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
        
        X_POS <= HPOS - 216;
        Y_POS <= VPOS - 27;
        
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
        IF (HPOS >= (H_SYNC + H_BP) AND HPOS < (1056 - H_FP)) THEN
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
