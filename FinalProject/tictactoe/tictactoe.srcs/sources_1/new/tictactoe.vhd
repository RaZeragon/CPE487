-- Author: Kevin Ward
-- Date: 12/15/2020
-- Title: tictactoe.vhd
-- Code Version: N/A
-- Type: Source File
-- Availability:

LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_UNSIGNED.ALL;

ENTITY tictactoe IS
    PORT (
        PXL_CLK             : IN STD_LOGIC;
        KP_CLK, SM_CLK      : IN STD_LOGIC;
        DISPLAY             : IN STD_LOGIC;
        X_POS, Y_POS        : IN INTEGER;
        PRESS               : IN STD_LOGIC; 
        INPUT               : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
        R_OUT, G_OUT, B_OUT : OUT STD_LOGIC_VECTOR(3 DOWNTO 0)
    );
END tictactoe;

ARCHITECTURE Behavioral OF tictactoe IS
-- Colors
CONSTANT WHITE  : STD_LOGIC_VECTOR(11 DOWNTO 0) := "111111111111";
CONSTANT BLACK  : STD_LOGIC_VECTOR(11 DOWNTO 0) := "000000000000";
CONSTANT RED    : STD_LOGIC_VECTOR(11 DOWNTO 0) := "111100000000";
CONSTANT BLUE   : STD_LOGIC_VECTOR(11 DOWNTO 0) := "000000001111";

-- Hash Constants
CONSTANT HASH_MAX_X : INTEGER := 560;
CONSTANT HASH_MIN_X : INTEGER := 240;
CONSTANT HASH_MAX_Y : INTEGER := 520;
CONSTANT HASH_MIN_Y : INTEGER := 200;
CONSTANT HASH_HOR_T : INTEGER := 300;
CONSTANT HASH_HOR_B : INTEGER := 420;
CONSTANT HASH_VER_R : INTEGER := 340;
CONSTANT HASH_VER_L : INTEGER := 460;
CONSTANT HASH_WIDTH : INTEGER := 10;    -- Multiply by 2 to get actual width

-- Game Variables
SIGNAL END_STATE    : STD_LOGIC_VECTOR(1 DOWNTO 0) := "00";
    -- END_STATE: "11" -> Victory
    -- END_STATE: "01" -> Stalemate

-- Game Board
SIGNAL X_GAME_BOARD     : STD_LOGIC_VECTOR(8 DOWNTO 0) := "000000000";
SIGNAL O_GAME_BOARD     : STD_LOGIC_VECTOR(8 DOWNTO 0) := "000000000";
SIGNAL TURN             : STD_LOGIC_VECTOR(8 DOWNTO 0) := "000000000";
SIGNAL PLAYER           : STD_LOGIC := '1';
CONSTANT TURN_COUNT     : INTEGER := 0;

-- Testing
SIGNAL TEST : STD_LOGIC_VECTOR(1 DOWNTO 0) := "00";

-- Bitmaps
TYPE BITMAP_X IS ARRAY(0 TO 39) OF STD_LOGIC_VECTOR(39 DOWNTO 0);
TYPE BITMAP_O IS ARRAY(0 TO 39) OF STD_LOGIC_VECTOR(39 DOWNTO 0);

-- Bitmaps Continued
CONSTANT X_SPRITE : BITMAP_X := ((
    "1110000000000000000000000000000000000111",
    "1111000000000000000000000000000000001111",
    "1111100000000000000000000000000000011111",
    "0111110000000000000000000000000000111110",
    "0011111000000000000000000000000001111100",
    "0001111100000000000000000000000011111000",
    "0000111110000000000000000000000111110000",
    "0000011111000000000000000000001111100000",
    "0000001111100000000000000000011111000000",
    "0000000111110000000000000000111110000000",
    "0000000011111000000000000001111100000000",
    "0000000001111100000000000011111000000000",
    "0000000000111110000000000111110000000000",
    "0000000000011111000000001111100000000000",
    "0000000000001111100000011111000000000000",
    "0000000000000111110000111110000000000000",
    "0000000000000011111001111100000000000000",
    "0000000000000001111111111000000000000000",
    "0000000000000000111111110000000000000000",
    "0000000000000000011111100000000000000000",
    "0000000000000000011111100000000000000000",
    "0000000000000000111111110000000000000000",
    "0000000000000001111111111000000000000000",
    "0000000000000011111001111100000000000000",
    "0000000000000111110000111110000000000000",
    "0000000000001111100000011111000000000000",
    "0000000000011111000000001111100000000000",
    "0000000000111110000000000111110000000000",
    "0000000001111100000000000011111000000000",
    "0000000011111000000000000001111100000000",
    "0000000111110000000000000000111110000000",
    "0000001111100000000000000000011111000000",
    "0000011111000000000000000000001111100000",
    "0000111110000000000000000000000111110000",
    "0001111100000000000000000000000011111000",
    "0011111000000000000000000000000001111100",
    "0111110000000000000000000000000000111110",
    "1111100000000000000000000000000000011111",
    "1111000000000000000000000000000000001111",
    "1110000000000000000000000000000000000111"));
    
CONSTANT O_SPRITE : BITMAP_O := ((
    "0000000000001111111111111111000000000000",
    "0000000011111111111111111111111100000000",
    "0000001111111111111111111111111111000000",
    "0000011111111111111111111111111111100000",
    "0000111111111111111111111111111111110000",
    "0001111111110000000000000000111111111000",
    "0011111110000000000000000000000111111100",
    "0011111100000000000000000000000011111100",
    "0111111000000000000000000000000001111110",
    "0111110000000000000000000000000000111110",
    "0111110000000000000000000000000000111110",
    "0111110000000000000000000000000000111110",
    "1111100000000000000000000000000000011111",
    "1111100000000000000000000000000000011111",
    "1111100000000000000000000000000000011111",
    "1111100000000000000000000000000000011111",
    "1111100000000000000000000000000000011111",
    "1111100000000000000000000000000000011111",
    "1111100000000000000000000000000000011111",
    "1111100000000000000000000000000000011111",
    "1111100000000000000000000000000000011111",
    "1111100000000000000000000000000000011111",
    "1111100000000000000000000000000000011111",
    "1111100000000000000000000000000000011111",
    "1111100000000000000000000000000000011111",
    "1111100000000000000000000000000000011111",
    "1111100000000000000000000000000000011111",
    "1111100000000000000000000000000000011111",
    "0111110000000000000000000000000000111110",
    "0111110000000000000000000000000000111110",
    "0111110000000000000000000000000000111110",
    "0111111000000000000000000000000001111110",
    "0011111100000000000000000000000011111100",
    "0011111110000000000000000000000111111100",
    "0001111111110000000000000000111111111000",
    "0000111111111111111111111111111111110000",
    "0000011111111111111111111111111111100000",
    "0000001111111111111111111111111111000000",
    "0000000011111111111111111111111100000000",
    "0000000000001111111111111111000000000000"));

BEGIN
draw_hash : PROCESS(X_POS, Y_POS, X_GAME_BOARD, O_GAME_BOARD, END_STATE)
BEGIN
    IF (END_STATE = "00") THEN
        IF ((X_POS > 0 AND X_POS < 800) AND (Y_POS > 0 AND Y_POS < 600)) THEN
            R_OUT <= WHITE(11 DOWNTO 8);
            G_OUT <= WHITE(7 DOWNTO 4);
            B_OUT <= WHITE(3 DOWNTO 0);
        
            IF ((X_POS >= HASH_MIN_X AND X_POS <= HASH_MAX_X) AND (Y_POS >= HASH_MIN_Y AND Y_POS <= HASH_MAX_Y)) THEN
                IF (((X_POS >= HASH_VER_L - HASH_WIDTH AND X_POS <= HASH_VER_L + HASH_WIDTH) OR (X_POS >= HASH_VER_R - HASH_WIDTH AND X_POS <= HASH_VER_R + HASH_WIDTH)) OR
                    ((Y_POS >= HASH_HOR_T - HASH_WIDTH AND Y_POS <= HASH_HOR_T + HASH_WIDTH) OR (Y_POS >= HASH_HOR_B - HASH_WIDTH AND Y_POS <= HASH_HOR_B + HASH_WIDTH))) THEN
                    R_OUT <= BLACK(11 DOWNTO 8);
                    G_OUT <= BLACK(7 DOWNTO 4);
                    B_OUT <= BLACK(3 DOWNTO 0);
                END IF;
                
                -- Position 1 (Top Left)
                IF (X_GAME_BOARD(0) = '1') THEN
                    IF ((Y_POS > 220 AND Y_POS < 260) AND (X_POS > 260 AND X_POS < 300)) THEN
                        IF (X_SPRITE(Y_POS - 220)(X_POS - 260) = '1') THEN
                            R_OUT <= RED(11 DOWNTO 8);
                            G_OUT <= RED(7 DOWNTO 4);
                            B_OUT <= RED(3 DOWNTO 0);
                        END IF;
                    END IF;
                ELSIF (O_GAME_BOARD(0) = '1') THEN
                    IF ((Y_POS > 220 AND Y_POS < 260) AND (X_POS > 260 AND X_POS < 300)) THEN
                        IF (O_SPRITE(Y_POS - 220)(X_POS - 260) = '1') THEN
                            R_OUT <= BLUE(11 DOWNTO 8);
                            G_OUT <= BLUE(7 DOWNTO 4);
                            B_OUT <= BLUE(3 DOWNTO 0);
                        END IF;
                    END IF;
                END IF;
                
                -- Position 2 (Top Mid)
                IF (X_GAME_BOARD(1) = '1') THEN
                    IF ((Y_POS > 220 AND Y_POS < 260) AND (X_POS > 380 AND X_POS < 420)) THEN
                        IF (X_SPRITE(Y_POS - 220)(X_POS - 380) = '1') THEN
                            R_OUT <= RED(11 DOWNTO 8);
                            G_OUT <= RED(7 DOWNTO 4);
                            B_OUT <= RED(3 DOWNTO 0);
                        END IF;
                    END IF;
                ELSIF (O_GAME_BOARD(1) = '1') THEN
                    IF ((Y_POS > 220 AND Y_POS < 260) AND (X_POS > 380 AND X_POS < 420)) THEN
                        IF (O_SPRITE(Y_POS - 220)(X_POS - 380) = '1') THEN
                            R_OUT <= BLUE(11 DOWNTO 8);
                            G_OUT <= BLUE(7 DOWNTO 4);
                            B_OUT <= BLUE(3 DOWNTO 0);
                        END IF;
                    END IF;
                END IF;
                
                -- Position 3 (Top Right)
                IF (X_GAME_BOARD(2) = '1') THEN
                    IF ((Y_POS > 220 AND Y_POS < 260) AND (X_POS > 500 AND X_POS < 540)) THEN
                        IF (X_SPRITE(Y_POS - 220)(X_POS - 500) = '1') THEN
                            R_OUT <= RED(11 DOWNTO 8);
                            G_OUT <= RED(7 DOWNTO 4);
                            B_OUT <= RED(3 DOWNTO 0);
                        END IF;
                    END IF;
                ELSIF (O_GAME_BOARD(2) = '1') THEN
                    IF ((Y_POS > 220 AND Y_POS < 260) AND (X_POS > 500 AND X_POS < 540)) THEN
                        IF (O_SPRITE(Y_POS - 220)(X_POS - 500) = '1') THEN
                            R_OUT <= BLUE(11 DOWNTO 8);
                            G_OUT <= BLUE(7 DOWNTO 4);
                            B_OUT <= BLUE(3 DOWNTO 0);
                        END IF;
                    END IF;
                END IF;
                
                -- Position 4 (Mid Left)
                IF (X_GAME_BOARD(3) = '1') THEN
                    IF ((Y_POS > 340 AND Y_POS < 380) AND (X_POS > 260 AND X_POS < 300)) THEN
                        IF (X_SPRITE(Y_POS - 340)(X_POS - 260) = '1') THEN
                            R_OUT <= RED(11 DOWNTO 8);
                            G_OUT <= RED(7 DOWNTO 4);
                            B_OUT <= RED(3 DOWNTO 0);
                        END IF;
                    END IF;
                ELSIF (O_GAME_BOARD(3) = '1') THEN
                    IF ((Y_POS > 340 AND Y_POS < 380) AND (X_POS > 260 AND X_POS < 300)) THEN
                        IF (O_SPRITE(Y_POS - 340)(X_POS - 260) = '1') THEN
                            R_OUT <= BLUE(11 DOWNTO 8);
                            G_OUT <= BLUE(7 DOWNTO 4);
                            B_OUT <= BLUE(3 DOWNTO 0);
                        END IF;
                    END IF;
                END IF;
                
                -- Position 5 (Mid Mid)
                IF (X_GAME_BOARD(4) = '1') THEN
                    IF ((Y_POS > 340 AND Y_POS < 380) AND (X_POS > 380 AND X_POS < 420)) THEN
                        IF (X_SPRITE(Y_POS - 340)(X_POS - 380) = '1') THEN
                            R_OUT <= RED(11 DOWNTO 8);
                            G_OUT <= RED(7 DOWNTO 4);
                            B_OUT <= RED(3 DOWNTO 0);
                        END IF;
                    END IF;
                ELSIF (O_GAME_BOARD(4) = '1') THEN
                    IF ((Y_POS > 340 AND Y_POS < 380) AND (X_POS > 380 AND X_POS < 420)) THEN
                        IF (O_SPRITE(Y_POS - 340)(X_POS - 380) = '1') THEN
                            R_OUT <= BLUE(11 DOWNTO 8);
                            G_OUT <= BLUE(7 DOWNTO 4);
                            B_OUT <= BLUE(3 DOWNTO 0);
                        END IF;
                    END IF;
                END IF;
                
                -- Position 6 (Mid Right)
                IF (X_GAME_BOARD(5) = '1') THEN
                    IF ((Y_POS > 340 AND Y_POS < 380) AND (X_POS > 500 AND X_POS < 540)) THEN
                        IF (X_SPRITE(Y_POS - 340)(X_POS - 500) = '1') THEN
                            R_OUT <= RED(11 DOWNTO 8);
                            G_OUT <= RED(7 DOWNTO 4);
                            B_OUT <= RED(3 DOWNTO 0);
                        END IF;
                    END IF;
                ELSIF (O_GAME_BOARD(5) = '1') THEN
                    IF ((Y_POS > 340 AND Y_POS < 380) AND (X_POS > 500 AND X_POS < 540)) THEN
                        IF (O_SPRITE(Y_POS - 340)(X_POS - 500) = '1') THEN
                            R_OUT <= BLUE(11 DOWNTO 8);
                            G_OUT <= BLUE(7 DOWNTO 4);
                            B_OUT <= BLUE(3 DOWNTO 0);
                        END IF;
                    END IF;
                END IF;
                
                -- Position 7 (Bot Left)
                IF (X_GAME_BOARD(6) = '1') THEN
                    IF ((Y_POS > 460 AND Y_POS < 500) AND (X_POS > 260 AND X_POS < 300)) THEN
                        IF (X_SPRITE(Y_POS - 460)(X_POS - 260) = '1') THEN
                            R_OUT <= RED(11 DOWNTO 8);
                            G_OUT <= RED(7 DOWNTO 4);
                            B_OUT <= RED(3 DOWNTO 0);
                        END IF;
                    END IF;
                ELSIF (O_GAME_BOARD(6) = '1') THEN
                    IF ((Y_POS > 460 AND Y_POS < 500) AND (X_POS > 260 AND X_POS < 300)) THEN
                        IF (O_SPRITE(Y_POS - 460)(X_POS - 260) = '1') THEN
                            R_OUT <= BLUE(11 DOWNTO 8);
                            G_OUT <= BLUE(7 DOWNTO 4);
                            B_OUT <= BLUE(3 DOWNTO 0);
                        END IF;
                    END IF;
                END IF;
                
                -- Position 8 (Bot Mid)
                IF (X_GAME_BOARD(7) = '1') THEN
                    IF ((Y_POS > 460 AND Y_POS < 500) AND (X_POS > 380 AND X_POS < 420)) THEN
                        IF (X_SPRITE(Y_POS - 460)(X_POS - 380) = '1') THEN
                            R_OUT <= RED(11 DOWNTO 8);
                            G_OUT <= RED(7 DOWNTO 4);
                            B_OUT <= RED(3 DOWNTO 0);
                        END IF;
                    END IF;
                ELSIF (O_GAME_BOARD(7) = '1') THEN
                    IF ((Y_POS > 460 AND Y_POS < 500) AND (X_POS > 380 AND X_POS < 420)) THEN
                        IF (O_SPRITE(Y_POS - 460)(X_POS - 380) = '1') THEN
                            R_OUT <= BLUE(11 DOWNTO 8);
                            G_OUT <= BLUE(7 DOWNTO 4);
                            B_OUT <= BLUE(3 DOWNTO 0);
                        END IF;
                    END IF;
                END IF;
                
                -- Position 9 (Bot Right)
                IF (X_GAME_BOARD(8) = '1') THEN
                    IF ((Y_POS > 460 AND Y_POS < 500) AND (X_POS > 500 AND X_POS < 540)) THEN
                        IF (X_SPRITE(Y_POS - 460)(X_POS - 500) = '1') THEN
                            R_OUT <= RED(11 DOWNTO 8);
                            G_OUT <= RED(7 DOWNTO 4);
                            B_OUT <= RED(3 DOWNTO 0);
                        END IF;
                    END IF;
                ELSIF (O_GAME_BOARD(8) = '1') THEN
                    IF ((Y_POS > 460 AND Y_POS < 500) AND (X_POS > 500 AND X_POS < 540)) THEN
                        IF (O_SPRITE(Y_POS - 460)(X_POS - 500) = '1') THEN
                            R_OUT <= BLUE(11 DOWNTO 8);
                            G_OUT <= BLUE(7 DOWNTO 4);
                            B_OUT <= BLUE(3 DOWNTO 0);
                        END IF;
                    END IF;
                END IF;
                
                IF (TEST = "01") THEN
                    IF ((X_POS > 0 AND X_POS < 800) AND (Y_POS > 0 AND Y_POS < 600)) THEN
                        R_OUT <= BLACK(11 DOWNTO 8);
                        G_OUT <= BLACK(7 DOWNTO 4);
                        B_OUT <= BLACK(3 DOWNTO 0);
                    END IF;
                ELSIF (TEST = "11") THEN
                    IF ((X_POS > 0 AND X_POS < 800) AND (Y_POS > 0 AND Y_POS < 600)) THEN
                        R_OUT <= WHITE(11 DOWNTO 8);
                        G_OUT <= WHITE(7 DOWNTO 4);
                        B_OUT <= WHITE(3 DOWNTO 0);
                    END IF;
                END IF;
            END IF;
        ELSE
            R_OUT <= BLACK(11 DOWNTO 8);
            G_OUT <= BLACK(7 DOWNTO 4);
            B_OUT <= BLACK(3 DOWNTO 0);
        END IF;
    
    -- Tie
--    ELSIF (END_STATE = "01" OR END_STATE = "11") THEN
--        IF (INPUT = X"A") THEN
--            END_STATE <= "00";
--        ELSE
--            END_STATE <= "10";
--        END IF;
        
    -- Black Screen
--    ELSIF (END_STATE = "10") THEN
--        IF ((X_POS > 0 AND X_POS < 800) AND (Y_POS > 0 AND Y_POS < 600)) THEN
--            R_OUT <= BLACK(11 DOWNTO 8);
--            G_OUT <= BLACK(7 DOWNTO 4);
--            B_OUT <= BLACK(3 DOWNTO 0);
--        ELSE
--            R_OUT <= BLACK(11 DOWNTO 8);
--            G_OUT <= BLACK(7 DOWNTO 4);
--            B_OUT <= BLACK(3 DOWNTO 0);
--        END IF;
   END IF;
END PROCESS draw_hash;

player_turn : PROCESS(PRESS)
BEGIN
    IF (PRESS'event AND PRESS = '1') THEN
        -- Turns hex input value into different input
        IF (INPUT = X"1") THEN
            TURN <= "000000001";
        ELSIF (INPUT = X"2") THEN
            TURN <= "000000010";
        ELSIF (INPUT = X"3") THEN
            TURN <= "000000100";
        ELSIF (INPUT = X"4") THEN
            TURN <= "000001000";
        ELSIF (INPUT = X"5") THEN
            TURN <= "000010000";
        ELSIF (INPUT = X"6") THEN
            TURN <= "000100000";
        ELSIF (INPUT = X"7") THEN
            TURN <= "001000000";
        ELSIF (INPUT = X"8") THEN
            TURN <= "010000000";
        ELSIF (INPUT = X"9") THEN
            TURN <= "100000000";
        ELSE   
            TURN <= "111111111";
        END IF;
        
        IF (((X_GAME_BOARD AND TURN) = "000000000") AND ((O_GAME_BOARD AND TURN) = "000000000")) THEN       -- If the turn is allowed
            IF (PLAYER = '0') THEN
                --TEST <= "11";
                X_GAME_BOARD <= X_GAME_BOARD OR TURN;           -- Updates the board
                PLAYER <= '1';
                
                -- Win condition check
                IF (X_GAME_BOARD = "000000111" OR
                    X_GAME_BOARD = "000111000" OR
                    X_GAME_BOARD = "111000000" OR
                    X_GAME_BOARD = "001001001" OR
                    X_GAME_BOARD = "010010010" OR
                    X_GAME_BOARD = "100100100" OR
                    X_GAME_BOARD = "100010001" OR
                    X_GAME_BOARD = "001010100")
                THEN
                    END_STATE <= "11";
--                ELSIF (TURN_COUNT >= 9) THEN
--                    END_STATE <= "01"; 
                END IF;
            ELSE
                --TEST <= "01";
                O_GAME_BOARD <= O_GAME_BOARD OR TURN;           -- Updates the board
                PLAYER <= '0'; 
                
                -- Win condition check
                IF (O_GAME_BOARD = "000000111" OR
                    O_GAME_BOARD = "000111000" OR
                    O_GAME_BOARD = "111000000" OR
                    O_GAME_BOARD = "001001001" OR
                    O_GAME_BOARD = "010010010" OR
                    O_GAME_BOARD = "100100100" OR
                    O_GAME_BOARD = "100010001" OR
                    O_GAME_BOARD = "001010100")
                THEN
                    END_STATE <= "11";
                END IF;   
            END IF;
        END IF;
    END IF;
END PROCESS player_turn;
END Behavioral;