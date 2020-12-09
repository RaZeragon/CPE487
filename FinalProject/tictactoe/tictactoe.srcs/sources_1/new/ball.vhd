LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_ARITH.ALL;
USE IEEE.STD_LOGIC_UNSIGNED.ALL;

ENTITY ball IS
	PORT (
		v_sync    : IN STD_LOGIC;
		pixel_row : IN STD_LOGIC_VECTOR(10 DOWNTO 0);
		pixel_col : IN STD_LOGIC_VECTOR(10 DOWNTO 0);
		red       : OUT STD_LOGIC;
		green     : OUT STD_LOGIC;
		blue      : OUT STD_LOGIC
	);
END ball;

ARCHITECTURE Behavioral OF ball IS
	CONSTANT hash_length  : INTEGER := 160;
	CONSTANT hash_width   : INTEGER := 10;
	CONSTANT color_2 : std_logic_vector(11 downto 0) := "111100000000"; --red
	CONSTANT color_1 : std_logic_vector(11 downto 0) := "000000000000";-- black
    CONSTANT color_0 : std_logic_vector(11 downto 0) := "111111111111";-- white
	SIGNAL board_on : STD_LOGIC; 
	SIGNAL boardcenter_x   : STD_LOGIC_VECTOR(10 DOWNTO 0) := CONV_STD_LOGIC_VECTOR(400, 11);
	SIGNAL boardcenter_y   : STD_LOGIC_VECTOR(10 DOWNTO 0) := CONV_STD_LOGIC_VECTOR(360,11);
	SIGNAL topright_x      : STD_LOGIC_VECTOR(10 DOWNTO 0) := CONV_STD_LOGIC_VECTOR(460, 11);
	SIGNAL topright_y      : STD_LOGIC_VECTOR(10 DOWNTO 0) := CONV_STD_LOGIC_VECTOR(300, 11);
	SIGNAL botleft_x       : STD_LOGIC_VECTOR(10 DOWNTO 0) := CONV_STD_LOGIC_VECTOR(340, 11);
	SIGNAL botleft_y       : STD_LOGIC_VECTOR(10 DOWNTO 0) := CONV_STD_LOGIC_VECTOR(420, 11);
BEGIN
	red <= board_on; -- color setup for red ball on white background
	green <= board_on;
	blue  <= board_on;
	-- process to draw ball current pixel address is covered by ball position
	bdraw : PROCESS (
	              boardcenter_x, boardcenter_y,
	              topright_x, topright_y,
	              botleft_x, botleft_y,
	              pixel_row, pixel_col
	         ) IS
	BEGIN
        IF ((((pixel_col >= topright_x - hash_width) AND (pixel_col <= topright_x + hash_width)) OR
		   ((pixel_row >= topright_y - hash_width) AND (pixel_row <= topright_y + hash_width))) OR
		   -- ^^ Creates top right corner
		   -- vv Creates bottom left corner
		   (((pixel_col >= botleft_x - hash_width) AND (pixel_col <= botleft_x + hash_width)) OR
		   ((pixel_row >= botleft_y - hash_width) AND (pixel_row <= botleft_y + hash_width)))) AND
		   -- vv Limits lines to within the #
		   (((pixel_col >= boardcenter_x - hash_length) AND (pixel_col <= boardcenter_x + hash_length)) AND
		   ((pixel_row >= boardcenter_y - hash_length) AND (pixel_row <= boardcenter_y + hash_length)))
	    THEN
		      board_on <= '1';
		ELSE
			board_on <= '0';
		END IF;
	END PROCESS;
END Behavioral;