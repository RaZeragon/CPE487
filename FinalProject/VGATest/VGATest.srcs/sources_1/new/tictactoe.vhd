LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_UNSIGNED.ALL;

ENTITY tictactoe IS
    PORT (
        clk_in              : IN STD_LOGIC;
        DISPLAY             : IN STD_LOGIC;
        X_POS, Y_POS        : IN INTEGER;
        R_OUT, G_OUT, B_OUT : OUT STD_LOGIC_VECTOR(3 DOWNTO 0)
    );
END tictactoe;

ARCHITECTURE Behavioral OF tictactoe IS
    
BEGIN
PROCESS(clk_in)
BEGIN
    IF (DISPLAY = '1') THEN
        IF (X_POS > 320 AND Y_POS > 240) THEN
            R_OUT <= "1111";
            G_OUT <= "1111";
            B_OUT <= "1111";
        END IF;
    END IF;
END PROCESS;
END Behavioral;
