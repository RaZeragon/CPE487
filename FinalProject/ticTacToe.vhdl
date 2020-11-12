-- Author: Kevin Ward
-- Date: 11/12/2020
-- Title: Tic-Tac-Toe
-- Code Version: N/A
-- Type: N/A
-- Availability: N/A

LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;

ENTITY ticTacToe IS
	PORT(
	F : IN STD_LOGIC;
	S0, S1: IN STD_LOGIC;
	A, B, C, D: OUT STD_LOGIC
	);
	END ticTacToe;
	
ARCHITECTURE bhv OF demux IS
BEGIN
	PROCESS (F, S0, S1) IS
	BEGIN
		IF (S0 = '0' and S1 = '0') THEN
			A <= F;
		ELSIF (S0 = '1' and S1 = '0') THEN
			B <= F;
		ELSIF (S0 = '0' and S1 = '1') THEN
			C <= F;
		ELSE
			D <= F;
		END IF;
	END PROCESS;
END bhv;