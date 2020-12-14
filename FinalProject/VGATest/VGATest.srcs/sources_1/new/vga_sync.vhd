LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_UNSIGNED.ALL;

ENTITY vga_sync IS
    PORT(
    clk_in : IN STD_LOGIC;
    HSYNC, VSYNC : OUT STD_LOGIC;
    R, G, B : OUT STD_LOGIC_VECTOR(3 DOWNTO 0)
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
    VARIABLE HPOS   : INTEGER :=0;
    VARIABLE VPOS   : INTEGER :=0;
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
        
        -- Setting up colors
        IF ((HPOS > 0 AND HPOS < (H_FP + H_SYNC + H_BP)) OR (VPOS > 0 AND VPOS < (V_FP + V_SYNC + V_BP))) THEN
            R <= (OTHERS => '0');
            G <= (OTHERS => '0');
            B <= (OTHERS => '0');
        END IF;
        
        IF (HPOS > 480 OR VPOS > 281) THEN
            R <= (OTHERS => '1');
            G <= (OTHERS => '1');
            B <= (OTHERS => '1');
        END IF;
    END IF;
END PROCESS;
END Behavioral;
