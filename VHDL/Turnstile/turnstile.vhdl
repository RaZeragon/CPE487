library ieee;
use ieee.std_logic_1164.all;

entity turnstile is
	port(
		clk : in std_logic; -- Clock 
		coin : in std_logic; -- Turnstile input (Coin)
		cstate : in std_logic; -- Current State
		nstate : out std_logic; -- Next state
		tout : out std_logic -- Output
	);
end turnstile;

architecture bhv of turnstile is
begin
	process(clk, coin, cstate)
	begin
		