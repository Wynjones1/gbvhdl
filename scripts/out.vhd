elsif mem_dout = "00000000" then -- NOP   
elsif mem_dout = "00000111" then -- RLCA  
elsif mem_dout = "00001111" then -- RRCA  
elsif mem_dout = "00010000" then -- STOP  
elsif mem_dout = "00010111" then -- RLA   
elsif mem_dout = "00011000" then -- JR   r8 
elsif mem_dout = "00011111" then -- RRA   
elsif mem_dout = "00100111" then -- DDA   
elsif mem_dout = "00101111" then -- CPL   
elsif mem_dout = "00110100" then -- INC  (HL) 
elsif mem_dout = "00110101" then -- DEC  (HL) 
elsif mem_dout = "00110111" then -- SCF   
elsif mem_dout = "00111111" then -- CCF   
elsif mem_dout = "01110110" then -- HALT  
elsif mem_dout = "11000011" then -- JP   d16 
elsif mem_dout = "11001001" then -- RET   
elsif mem_dout = "11001011" then -- CB    
elsif mem_dout = "11001101" then -- CALL d16 
elsif mem_dout = "11011001" then -- RETI  
elsif mem_dout = "11101000" then -- ADD  SP r8
elsif mem_dout = "11101001" then -- JP   PC (HL)
elsif mem_dout = "11110011" then -- DI    
elsif mem_dout = "11111011" then -- EI    
elsif mem_dout = "00000010" then -- LD   (BC) A
elsif mem_dout = "00001000" then -- LD   (d16) SP
elsif mem_dout = "00001010" then -- LD   A (BC)
elsif mem_dout = "00010010" then -- LD   (DE) A
elsif mem_dout = "00011010" then -- LD   A (DE)
elsif mem_dout = "00100010" then -- LD   (HL++) A
elsif mem_dout = "00101010" then -- LD   A (HL++)
elsif mem_dout = "00110010" then -- LD   (HL--)  A
elsif mem_dout = "00110110" then -- LD   (HL) d8
elsif mem_dout = "00111010" then -- LD   A (HL--)
elsif mem_dout = "11100010" then -- LD   (C) A
elsif mem_dout = "11101010" then -- LD   (d16) A
elsif mem_dout = "11110010" then -- LD   A (C)
elsif mem_dout = "11111000" then -- LD   HL SP + r8
elsif mem_dout = "11111001" then -- LD   SP HL
elsif mem_dout = "11111010" then -- LD   A (d16)
elsif mem_dout = "11100000" then -- LDH  (d8) A
elsif mem_dout = "11110000" then -- LDH  A (d8)
elsif mem_dout = "11010011" then -- INVALID  
elsif mem_dout = "11011011" then -- INVALID  
elsif mem_dout = "11011101" then -- INVALID  
elsif mem_dout = "11100011" then -- INVALID  
elsif mem_dout = "11100100" then -- INVALID  
elsif mem_dout = "11101011" then -- INVALID  
elsif mem_dout = "11101100" then -- INVALID  
elsif mem_dout = "11101101" then -- INVALID  
elsif mem_dout = "11110100" then -- INVALID  
elsif mem_dout = "11111100" then -- INVALID  
elsif mem_dout = "11111101" then -- INVALID  
elsif mem_dout(7 downto 3) = "01110" then                                 -- LD   (HL) r'
elsif mem_dout(7 downto 5) = "001" and mem_dout(2 downto 0) = "000"  then -- JR   cc r8
elsif mem_dout(7 downto 5) = "110" and mem_dout(2 downto 0) = "000"  then -- RET  cc 
elsif mem_dout(7 downto 5) = "110" and mem_dout(2 downto 0) = "010"  then -- JP   cc d16
elsif mem_dout(7 downto 5) = "110" and mem_dout(2 downto 0) = "100"  then -- CALL cc d16
elsif mem_dout(7 downto 6) = "00"  and mem_dout(2 downto 0) = "100"  then -- INC  r 
elsif mem_dout(7 downto 6) = "00"  and mem_dout(2 downto 0) = "101"  then -- DEC  r 
elsif mem_dout(7 downto 6) = "00"  and mem_dout(2 downto 0) = "110"  then -- LD   r n
elsif mem_dout(7 downto 6) = "01"  and mem_dout(2 downto 0) = "110"  then -- LD   r (HL)
elsif mem_dout(7 downto 6) = "10"  and mem_dout(2 downto 0) = "110"  then -- f    A (HL)
elsif mem_dout(7 downto 6) = "11"  and mem_dout(2 downto 0) = "110"  then -- f    A n
elsif mem_dout(7 downto 6) = "11"  and mem_dout(2 downto 0) = "111"  then -- RST  t 
elsif mem_dout(7 downto 6) = "00"  and mem_dout(3 downto 0) = "0001" then -- LD   dd d16
elsif mem_dout(7 downto 6) = "00"  and mem_dout(3 downto 0) = "0011" then -- INC  ss 
elsif mem_dout(7 downto 6) = "00"  and mem_dout(3 downto 0) = "1001" then -- ADD  HL ss
elsif mem_dout(7 downto 6) = "00"  and mem_dout(3 downto 0) = "1011" then -- DEC  ss 
elsif mem_dout(7 downto 6) = "11"  and mem_dout(3 downto 0) = "0001" then -- POP  qq 
elsif mem_dout(7 downto 6) = "11"  and mem_dout(3 downto 0) = "0101" then -- PUSH qq 
elsif mem_dout(7 downto 6) = "01" then                                    -- LD   r r'
elsif mem_dout(7 downto 6) = "10" then                                    -- f    A r'
