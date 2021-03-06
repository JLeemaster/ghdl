-- Test Bench
-- inspired from http://ghdl.free.fr/ghdl/A-full-adder.html#A-full-adder
-------------------------------------------------------------------------------
LIBRARY ieee;
USE ieee.std_logic_1164.all;
use IEEE.NUMERIC_STD.ALL;
-------------------------------------------------------------------------------
ENTITY add_tb IS
END add_tb;
-------------------------------------------------------------------------------
ARCHITECTURE behave OF add_tb IS
    COMPONENT add4
        GENERIC ( n : INTEGER := 4 );
        PORT ( a, b : IN STD_LOGIC_VECTOR ( n-1 DOWNTO 0 );
                cin : IN STD_LOGIC;
                sum : OUT STD_LOGIC_VECTOR ( n DOWNTO 0 ) );
    END COMPONENT;
    
    FOR ALL: add4 USE ENTITY work.addern;
    
    SIGNAL i0, i1  : STD_LOGIC_VECTOR ( 3 DOWNTO 0 );
    SIGNAL s       : STD_LOGIC_VECTOR ( 4 DOWNTO 0 );
    SIGNAL ci      : STD_LOGIC;    

    subtype hexstring is string(1 to 12);

    function to_hex(n: in std_logic_vector) return hexstring is
        variable n_int : std_logic_vector(n'high + 3 downto 0);
        variable digit : unsigned(3 downto 0);
        variable d_pos : natural;
        variable s     : hexstring := (others => ' ');
    begin
        -- assert n'high < 32 report "Hex conversion failed; supports 32 bits max!" severity warning;
        n_int := (others => '0');
        n_int(n'range) := n;
        for i in 1 to (n'length + 3)/4 loop
            d_pos := ((n'length + 3)/4 - i) * 4;
            digit := unsigned(n_int(d_pos+3 downto d_pos));
            -- look after metavalues...
            if Is_X(std_logic_vector(digit)) then
                s(i) := 'X';
            elsif digit > 9 then
                s(i) := character'val(character'pos('A') 
                        + to_integer(digit) - 10);
            else 
                s(i) := character'val(character'pos('0') 
                        + to_integer(digit));
            end if;
        end loop;
        return s;
    end to_hex;

BEGIN
    adder0: add4 
        PORT MAP ( a => i0, b => i1, cin => ci, sum => s );
    --  This process does the real job.
    PROCESS
        TYPE pattern_type IS RECORD
            --  The inputs of the adder.
            i0, i1 : STD_LOGIC_VECTOR( 3 DOWNTO 0 );
            ci : STD_LOGIC;
            --  The expected outputs of the adder.
            s  : STD_LOGIC_VECTOR( 4 DOWNTO 0 );
        END RECORD;
        --  The patterns to apply.
        TYPE pattern_array IS ARRAY (natural RANGE <>) OF pattern_type;
        CONSTANT patterns : pattern_array :=
            (("0000", "0000", '0', "00000"),
             ("0000", "0001", '0', "00001"),
             ("0001", "0000", '0', "00001"),
             ("0001", "0001", '0', "00010"),
             ("0001", "0001", '1', "00011"),
             ("0001", "0010", '0', "00011"),
             ("0001", "0010", '1', "00100"),
             ("0010", "0010", '0', "00100"));
    BEGIN
      --  Check each pattern.
      FOR i IN patterns'RANGE LOOP
        --  Set the inputs.
        i0 <= patterns(i).i0;
        i1 <= patterns(i).i1;
        ci <= patterns(i).ci;
        --  Wait for the results.
        WAIT FOR 1 ns;
        --  Check the outputs.
        
        ASSERT s = patterns(i).s
           REPORT "bad sum : value " & to_hex(s) & "should be " & to_hex(patterns(i).s) SEVERITY note;
--         assert co = patterns(i).co
--           report "bad carray out value" severity error;
       END LOOP;
       ASSERT false REPORT "end of test" SEVERITY note;
       --  Wait forever; this will finish the simulation.
       WAIT;
    END PROCESS;

END behave;
