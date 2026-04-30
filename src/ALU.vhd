----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 04/18/2025 02:50:18 PM
-- Design Name: 
-- Module Name: ALU - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity ALU is
    Port ( i_A : in STD_LOGIC_VECTOR (7 downto 0);
           i_B : in STD_LOGIC_VECTOR (7 downto 0);
           i_op : in STD_LOGIC_VECTOR (2 downto 0);
           o_result : out STD_LOGIC_VECTOR (7 downto 0);
           o_flags : out STD_LOGIC_VECTOR (3 downto 0));-- N negative, Z all zero, C carry out and control is addition or subtraction, V (addition or subtracts, A and sum opposite signs
end ALU;

architecture Behavioral of ALU is
    signal add_result : std_logic_vector(7 downto 0);
    signal subtract_result : std_logic_vector(7 downto 0);
    signal subtract_result_B : std_logic_vector(7 downto 0);
    signal b_value_subtract : std_logic_vector(7 downto 0);
    signal and_result : std_logic_vector(7 downto 0);
    signal or_result : std_logic_vector(7 downto 0);
    signal c_out : std_logic;
    signal c_out_add : std_logic;
    signal c_out_sub_B : std_logic;
    signal c_out_sub : std_logic;
    signal signal_o_result : std_logic_vector(7 downto 0);
    signal zero_flag : std_logic;
    
     component ripple_adder is
        port ( A : in STD_LOGIC_VECTOR (7 downto 0);
           B : in STD_LOGIC_VECTOR (7 downto 0);
           Cin : in STD_LOGIC;
           S : out STD_LOGIC_VECTOR (7 downto 0);
           Cout : out STD_LOGIC);
     end component ripple_adder;
     
     
begin
    rippleAdder_inst : ripple_adder port map (
        A => i_A,
        B => i_B,
        Cin => '0',
        S => add_result,
        Cout => c_out_add
    );
    
    b_value_subtract <= NOT i_B;
    rippleAdder_inst_subtract_for_B : ripple_adder port map (
        A => "00000001",
        B => b_value_subtract,
        Cin => '0',
        S => subtract_result_B,
        Cout => c_out_sub_B
    );
    
    rippleAdder_inst_subtract : ripple_adder port map (
        A => i_A,
        B => subtract_result_B,
        Cin => '0',
        S => subtract_result,
        Cout => c_out_sub
    );
    
    and_result <= i_A AND i_B;
    or_result <= i_A OR i_B;
    
    with i_op select
    signal_o_result <= add_result when "000",
                subtract_result when "001",
                and_result when "010",
                or_result when "011",
                add_result when others;
     with i_op select
     c_out <= c_out_add when "000",
              c_out_sub when "001",
              '0' when others;
    o_result <= signal_o_result;
    
    with signal_o_result select
    zero_flag <= '1' when "00000000",
                 '0' when others;
    
   
    o_flags(3) <= signal_o_result(7);
    o_flags(2) <= zero_flag;
    o_flags(1) <= (NOT i_op(1)) AND c_out;
    o_flags(0) <= NOT i_op(1) AND (i_A(7) XOR signal_o_result(7)) AND ((NOT i_op(0) AND i_A(7) AND i_B(7)) OR ((i_op(0) AND (i_A(7) XOR i_B(7)))));

end Behavioral;
