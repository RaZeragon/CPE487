LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_UNSIGNED.ALL;

ENTITY vga_top IS
    PORT(
    clk_in                  : IN STD_LOGIC_VECTOR (1 DOWNTO 0);
    VGA_HS, VGA_VS          : OUT STD_LOGIC;
    VGA_R, VGA_G, VGA_B     : OUT STD_LOGIC_VECTOR(3 DOWNTO 0)
    );
END vga_top;

ARCHITECTURE Behavioral OF vga_top IS
    COMPONENT vga_sync IS
        PORT(
        clk_in          : IN STD_LOGIC;
        HSYNC, VSYNC    : OUT STD_LOGIC;
        R, G, B         : OUT STD_LOGIC_VECTOR(3 DOWNTO 0);
        X_POS, Y_POS    : OUT INTEGER
        );
    END COMPONENT vga_sync;
    
    -- Internal Signals
    SIGNAL CLK_25           : STD_LOGIC := '0';
    SIGNAL red, green, blue : STD_LOGIC_VECTOR(3 DOWNTO 0) := "0000";
    SIGNAL SX_POS           : INTEGER := -1;
    SIGNAL SY_POS           : INTEGER := -1;
    
BEGIN
    vga_driver : vga_sync
    PORT MAP(
        clk_in => CLK_25,
        HSYNC => VGA_HS,
        VSYNC => VGA_VS,
        R(3 DOWNTO 0) => VGA_R(3 DOWNTO 0),
        G(3 DOWNTO 0) => VGA_G(3 DOWNTO 0),
        B(3 DOWNTO 0) => VGA_B(3 DOWNTO 0),
        X_POS => SX_POS,
        Y_POS => SY_POS
    );
    
END Behavioral;
