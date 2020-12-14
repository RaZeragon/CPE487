LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_UNSIGNED.ALL;

ENTITY clk IS
    PORT (
        clk_in  : IN STD_LOGIC;
        clk_out : OUT STD_LOGIC
    );
END clk;

ARCHITECTURE Behavioral OF clk IS
BEGIN
    clk_out <= clk_in;
END Behavioral;
