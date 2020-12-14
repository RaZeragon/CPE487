LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_UNSIGNED.ALL;

ENTITY tictactoe IS
    PORT (
        PXL_CLK             : IN STD_LOGIC;
        DISPLAY             : IN STD_LOGIC;
        X_POS, Y_POS        : IN INTEGER;
        R_OUT, G_OUT, B_OUT : OUT STD_LOGIC_VECTOR(3 DOWNTO 0)
    );
END tictactoe;

ARCHITECTURE Behavioral OF tictactoe IS
    
BEGIN
PROCESS(X_POS, Y_POS)
BEGIN
    IF ((X_POS > 50 AND Y_POS > 50) AND (X_POS < 800 AND Y_POS < 600)) THEN
        R_OUT <= "1111";
        G_OUT <= "1111";
        B_OUT <= "1111";
    ELSE
        R_OUT <= "0000";
        G_OUT <= "0000";
        B_OUT <= "0000";
    END IF;
END PROCESS;
END Behavioral;
