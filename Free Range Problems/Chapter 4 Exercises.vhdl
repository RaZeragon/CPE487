library ieee;
use ieee.std_logic_1164.all;

-- 1. For the following function descriptions, write VHDL models that implement these functions using concurrent signal assignment
	-- a. F(A,B) = ^AB + A + A^B
	entity 1a is
	port (
		A, B : in std_logic;
		F : out std_logic
	);
	end 1a;

	architecture 1a_behavior of 1a is
	begin
		F <= ((NOT A) AND B) OR A OR (A AND (NOT B));
	end 1a_behavior;

	-- b. F(A,B,C,D) = ^AB^D + ^BC + BC^D
	entity 1b is
	port (
		A, B, C, D : in std_logic;
		F : out std_logic
	);
	end 1b;

	architecture 1b_behavior of 1b is
	begin
		F <= ((NOT A) AND B AND (NOT C)) OR ((NOT B) AND C) OR (B AND C AND (NOT D));
	end 1b_behavior;

	-- c. F(A,B,C,D) = (^A + B)(^B + C + ^D)(^A + D)
	entity 1c is
	port (
		A, B, C, D : in std_logic;
		F : out std_logic
	);
	end 1c;

	architecture 1c_behavior of 1c is
	begin
		F <= ((NOT A) OR B) AND ((NOT B) OR C OR (NOT D)) AND ((NOT A) OR D);
	end 1c_behavior;

	-- d. F(A,B,C,D) = PI(3,2)

	-- e. F(A,B,C) = PI(5,1,4,3)

	-- f. F(A,B,C,D) = SUM(1,2)
	entity 1f is
	port (
		A, B, C, D : in std_logic;
		F : out std_logic
	);
	end 1f;

	architecture 1f_behavior of 1f is
	begin
		F <= C AND D;
	end 1f_behavior;

-- 2. For the following function descriptions, write VHDL models that implement these functions using both conditional and selected signal assignment
	-- a. F(A,B,C,D) = ^AB^D + ^BC + BC^D
	entity 2a is
	port (
		A, B, C, D : in std_logic;
		F : out std_logic
	);
	end 2a;

	architecture 2a_behavior of 2a is
	begin
		F <= '1' when (A = '0', B = '1', D = '0') else
			 '1' when (B = '0', C = '1') else
			 '1' when (B = '1', C = '1', D = '0') else
			 '0';
	end 2a_behavior;
	
	-- b. F(A,B,C,D) = (^A + B)(^B + C + ^D)(^A + D) -> ^ABC + ^AB^D + ^A^B + ^A^BD + ^AC + ^ACD + ^A^D + BCD
	entity 2b is
	port (
		A, B, C, D : in std_logic;
		F : out std_logic
	);
	end 2b;

	architecture 2b_behavior of 2b is
	begin
		F <= '1' when (A = '0', B = '1', C = '1') else
			 '1' when (A = '0', B = '1', D = '0') else
			 '1' when (A = '0', B = '0') else
			 '1' when (A = '0', B = '0', D = '1') else
			 '1' when (A = '0', C = '1') else 
			 '1' when (A = '0', C = '1', D = '1') else
			 '1' when (A = '0', D = '0') else 
			 '1' when (B = '1', C = '1', D = '1') else
			 '0';
	end 2b_behavior;
	
	-- c. F(A,B,C,D) = PI(3,2)
	
	-- d. F(A,B,C,D) = SUM(1,2)
	entity 2d is
	port (
		A, B, C, D : in std_logic;
		F : out std_logic)
	);
	end 2d;
	
	architecture 2d_behavior of 2d is
		signal 2d_signal : std_logic_vector(3 downto 0);
	begin
		2d_signal <= (A & B & C & D);
		
		with (2d_signal) select
			F <= '1' when "0001" | "0010",
				 '0' when others;
	end 2d_behavior;

-- 3. Provide a VHDL model of an 8-input AND gate using concurrent, conditional, and selected signal assignment
	entity 3andgate is
	port (
		A, B, C, D, E, F, G, H : in std_logic;
		O : out std_logic
	);
	end 3andgate;
	
	architecture 3andgate_behavior of 3andgate is
	begin
		O <= A AND B AND C AND D AND E AND F AND G AND H;
	end 3andgate_behavior;
	
-- 4. Provide a VHDL model of an 8-input OR gate using concurrent, conditional, and selected signal assignment
	entity 4orgate is
	port (
		A, B, C, D, E, F, G, H : in std_logic;
		O : out std_logic
	);
	end 4orgate;
	
	architecture 4orgate_behavior of 4orgate is
	begin
		O <= A OR B OR C OR D OR E OR F OR G OR H;
	end 4orgate_behavior;
	
-- 5. Provide a VHDL model of an 8:1 MUX using conditional signal assignment and selected signal assignment
	entity 5mux is
	port (
		A, B, C, D, E, F, G, H : in std_logic;
		SEL : in std_logic_vector(2 downto 0);
		O : out std_logic
	);
	end 5mux;
	
	architecture 5mux_behavior of 5mux is
	begin
		with SEL select
			O <= A when "000",
				 B when "001",
				 C when "010",
				 D when "011",
				 E when "100",
				 F when "101",
				 G when "110",
				 H when "111",
				 '0' when others;
	end 5mux_behavior;
	
-- 6. Provide a VHDL model of a 3:8 decoder using conditional signal assignment and selected signal assignment; consider the decoder's outputs to be active-high
	entity 6decoder_ah is
	port (
		DEC_IN : in std_logic_vector(2 downto 0);
		DEC_OUT : in std_logic_vector(7 downto 0)
	);
	end 6decoder_ah;
	
	architecture 6decoder_ah_behavior of 6decoder_ah is
	begin
		

-- 7. Provide a VHDL model of a 3:8 decoder using conditional signal assignment and selected signal assignment; consider the decoder's outputs to be active-low

