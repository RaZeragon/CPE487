library ieee;
use ieee.std_logic_1164.all;

-- 1. What is referred to by the word bundle?
-- A set of similar signals (sort of like an array)

-- 2. What is a common method of representing bundles in black-box diagrams?
-- A slash across the signal line with a number next to it denoting the number of signals in the bundle

-- 3. Why is it considered a good approach to always draw a black-box diagram when using VHDL to model digital circuits?
-- It simplifies the design from a systems standpoint and makes it easily digestible and allows for the reuse of previous code

-- 4. Write VHDL entity declarations that describe the following black-box diagrams:
entity sys1 is
port (
	a_in1, b_in2 : in std_logic;
	clk : in std_logic;
	ctrl_int : in std_logic;
	out_b : out std_logic
);
end sys1;

entity sys2 is
port (
	input_w : in std_logic;
	a_data, b_data : in std_logic_vector(7 downto 0);
	clk : in std_logic;
	dat_4, dat_5 : out std_logic_vector(7 downto 0)
);
end sys2;

-- 5. Provide black-box diagrams that are defined by the following VHDL entity declarations
-- a.
entity ckt_c is
port (
	bun_a, bun_b, bun_c : in std_logic_vector(7 downto 0);
	lda, ldb, ldc : in std_logic;
	reg_a, reg_b, reg_c : out std_logic_vector(7 downto 0)
);
end ckt_c;
--				-----
-- bun_a -8/-> |	 | -8/-> reg_a
-- bun_b -8/-> |	 | -8/-> reg_b
-- bun_c -8/-> |ckt_c| -8/-> reg_c
-- lda ------> |	 |
-- ldb ------> | 	 |
-- ldc ------> |	 |
--				-----

-- b.
entity ckt_e is
port (
	RAM_CS, RAM_WE, RAM_OE : in std_logic;
	SEL_OP1, SEL_OP2 : in std_logic_vector(3 downto 0);
	RAM_DATA_IN : in std_logic_vector(7 downto 0);
	RAM_ADDR_IN : in std_logic_vector(9 downto 0);
	RAM_DATA_OUT : out std_logic_vector(7 downto 0)
);
end ckt_e;
--					   -----
-- RAM_CS ----------> |		| -8/-> RAM_DATA_OUT
-- RAM_WE ----------> |		|
-- RAM_OE ----------> |		|
-- SEL_OP1 ----4/---> |ckt_e|
-- SEL_OP2 ----4/---> |		|
-- RAM_DATA_IN --8/-> |		|
-- RAM_ADDR_IN -10/-> |		|
-- 					   -----

-- 6. The following two entity declarations contain two of the most common syntax errors made in VHDL. What are they?
-- a.
entity ckt_a is
port (
	J,K : in std_logic;
	CLK : in std_logic
	Q : out std_logic; 
)
end ckt_a;
-- There is a missing ';' after the CLK line and an unnecessary ';' after the Q line

-- b. 
entity ckt_b is
port (
	mr_fluffy : in std_logic_vector(15 downto 0);
	mux_ctrl : in std_logic_vector(3 downto 0);
	byte_out : out std_logic_vector(3 downto 0);
end ckt_b;
-- There is a missing ')' after the byte_out line

