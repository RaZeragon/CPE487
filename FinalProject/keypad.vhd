-- Author: Kevin Lu
-- Date: 12/15/2020
-- Title: keypad.vhd
-- Code Version: N/A
-- Type: Source File
-- Availability: https://github.com/kevinwlu/dsd/blob/master/Nexys-A7/Lab-4/keypad.vhd

LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_UNSIGNED.ALL;

ENTITY keypad IS
	PORT (
        PXL_CLK   : IN STD_LOGIC; -- clock to strobe columns
		COL       : OUT STD_LOGIC_VECTOR (4 DOWNTO 1); -- output column lines
		ROW       : IN STD_LOGIC_VECTOR (4 DOWNTO 1); -- input row lines
		VALUE     : OUT STD_LOGIC_VECTOR (3 DOWNTO 0); -- hex value of key depressed
	    HIT       : OUT STD_LOGIC -- indicates when a key has been pressed
	);
END keypad;

ARCHITECTURE Behavioral OF keypad IS
	SIGNAL CV1, CV2, CV3, CV4  : STD_LOGIC_VECTOR(4 DOWNTO 1) := "1111"; -- column vector of each row
	SIGNAL CURR_COL            : STD_LOGIC_VECTOR(4 DOWNTO 1) := "1110"; -- current column code
BEGIN
	-- This process synchronously tests the state of the keypad buttons. On each edge of samp_ck,
	-- this module outputs a column code to the keypad in which one column line is held low while the
	-- other three column lines are held high. The row outputs of that column are then read
	-- into the corresponding column vector. The current column is then updated ready for the next
	-- clock edge. Remember that curr_col is not updated until the process suspends.
	strobe_proc : PROCESS
	BEGIN
		WAIT UNTIL rising_edge(PXL_CLK);
		CASE CURR_COL IS
			WHEN "1110" => 
				CV1 <= ROW;
				CURR_COL <= "1101";
			WHEN "1101" => 
				CV2 <= ROW;
				CURR_COL <= "1011";
			WHEN "1011" => 
				CV3 <= ROW;
				CURR_COL <= "0111";
			WHEN "0111" => 
				CV4 <= ROW;
				CURR_COL <= "1110";
			WHEN OTHERS => 
				CURR_COL <= "1110";
		END CASE;
	END PROCESS;
	-- This process runs whenever any of the column vectors change. Each vector is tested to see
	-- if there are any '0's in the vector. This would indicate that a button had been pushed in
	-- that column. If so, the value of the button is output and the hit signal is assereted. If
	-- not button is pushed, the hit signal is cleared
	out_proc : PROCESS (CV1, CV2, CV3, CV4)
	BEGIN
		HIT <= '1';
		IF CV1(1) = '0' THEN
			VALUE <= X"1";
		ELSIF CV1(2) = '0' THEN
			VALUE <= X"4";
		ELSIF CV1(3) = '0' THEN
			VALUE <= X"7";
		ELSIF CV1(4) = '0' THEN
			VALUE <= X"0";
		ELSIF CV2(1) = '0' THEN
			VALUE <= X"2";
		ELSIF CV2(2) = '0' THEN
			VALUE <= X"5";
		ELSIF CV2(3) = '0' THEN
			VALUE <= X"8";
		ELSIF CV2(4) = '0' THEN
			VALUE <= X"F";
		ELSIF CV3(1) = '0' THEN
			VALUE <= X"3";
		ELSIF CV3(2) = '0' THEN
			VALUE <= X"6";
		ELSIF CV3(3) = '0' THEN
			VALUE <= X"9";
		ELSIF CV3(4) = '0' THEN
			VALUE <= X"E";
		ELSIF CV4(1) = '0' THEN
			VALUE <= X"A";
		ELSIF CV4(2) = '0' THEN
			VALUE <= X"B";
		ELSIF CV4(3) = '0' THEN
			VALUE <= X"C";
		ELSIF CV4(4) = '0' THEN
			VALUE <= X"D";
		ELSE
			HIT <= '0';
			VALUE <= X"0";
		END IF;
	END PROCESS;
	COL <= CURR_COL;
END Behavioral;