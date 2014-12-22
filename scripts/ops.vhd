elsif std_match(mem_dout, "00000000") then  -- NOP   
elsif std_match(mem_dout, "00000010") then  -- LD   (BC) A
elsif std_match(mem_dout, "00000111") then  -- RLCA  
elsif std_match(mem_dout, "00001000") then  -- LD   (d16) SP
elsif std_match(mem_dout, "00001010") then  -- LD   A (BC)
elsif std_match(mem_dout, "00001111") then  -- RRCA  
elsif std_match(mem_dout, "00010000") then  -- STOP  
elsif std_match(mem_dout, "00010010") then  -- LD   (DE) A
elsif std_match(mem_dout, "00010111") then  -- RLA   
elsif std_match(mem_dout, "00011000") then  -- JR   r8 
elsif std_match(mem_dout, "00011010") then  -- LD   A (DE)
elsif std_match(mem_dout, "00011111") then  -- RRA   
elsif std_match(mem_dout, "00100010") then  -- LD   (HL++) A
elsif std_match(mem_dout, "00100111") then  -- DDA   
elsif std_match(mem_dout, "00101010") then  -- LD   A (HL++)
elsif std_match(mem_dout, "00101111") then  -- CPL   
elsif std_match(mem_dout, "00110010") then  -- LD   (HL--)  A
elsif std_match(mem_dout, "00110100") then  -- INC  (HL) 
elsif std_match(mem_dout, "00110101") then  -- DEC  (HL) 
elsif std_match(mem_dout, "00110110") then  -- LD   (HL) d8
elsif std_match(mem_dout, "00110111") then  -- SCF   
elsif std_match(mem_dout, "00111010") then  -- LD   A (HL--)
elsif std_match(mem_dout, "00111111") then  -- CCF   
elsif std_match(mem_dout, "11000011") then  -- JP   d16 
elsif std_match(mem_dout, "11001001") then  -- RET   
elsif std_match(mem_dout, "11001011") then  -- CB    
elsif std_match(mem_dout, "11001101") then  -- CALL d16 
elsif std_match(mem_dout, "11010011") then  -- INVALID  
elsif std_match(mem_dout, "11011001") then  -- RETI  
elsif std_match(mem_dout, "11011011") then  -- INVALID  
elsif std_match(mem_dout, "11011101") then  -- INVALID  
elsif std_match(mem_dout, "11100000") then  -- LDH  (d8) A
elsif std_match(mem_dout, "11100010") then  -- LD   (C) A
elsif std_match(mem_dout, "11100011") then  -- INVALID  
elsif std_match(mem_dout, "11100100") then  -- INVALID  
elsif std_match(mem_dout, "11101000") then  -- ADD  SP r8
elsif std_match(mem_dout, "11101001") then  -- JP   PC (HL)
elsif std_match(mem_dout, "11101010") then  -- LD   (d16) A
elsif std_match(mem_dout, "11101011") then  -- INVALID  
elsif std_match(mem_dout, "11101100") then  -- INVALID  
elsif std_match(mem_dout, "11101101") then  -- INVALID  
elsif std_match(mem_dout, "11110000") then  -- LDH  A (d8)
elsif std_match(mem_dout, "11110010") then  -- LD   A (C)
elsif std_match(mem_dout, "11110011") then  -- DI    
elsif std_match(mem_dout, "11110100") then  -- INVALID  
elsif std_match(mem_dout, "11111000") then  -- LD   HL SP + r8
elsif std_match(mem_dout, "11111001") then  -- LD   SP HL
elsif std_match(mem_dout, "11111010") then  -- LD   A (d16)
elsif std_match(mem_dout, "11111011") then  -- EI    
elsif std_match(mem_dout, "11111100") then  -- INVALID  
elsif std_match(mem_dout, "11111101") then  -- INVALID  
elsif std_match(mem_dout, "01110110") then  -- HALT  
elsif std_match(mem_dout, "01110---") then  -- LD   (HL) r'
elsif std_match(mem_dout, "001--000") then  -- JR   cc r8
elsif std_match(mem_dout, "110--000") then  -- RET  cc 
elsif std_match(mem_dout, "110--010") then  -- JP   cc d16
elsif std_match(mem_dout, "110--100") then  -- CALL cc d16
elsif std_match(mem_dout, "00--0001") then  -- LD   dd d16
elsif std_match(mem_dout, "00--0011") then  -- INC  ss 
elsif std_match(mem_dout, "00--1001") then  -- ADD  HL ss
elsif std_match(mem_dout, "00--1011") then  -- DEC  ss 
elsif std_match(mem_dout, "11--0001") then  -- POP  qq 
elsif std_match(mem_dout, "11--0101") then  -- PUSH qq 
elsif std_match(mem_dout, "00---100") then  -- INC  r 
elsif std_match(mem_dout, "00---101") then  -- DEC  r 
elsif std_match(mem_dout, "00---110") then  -- LD   r n
elsif std_match(mem_dout, "01---110") then  -- LD   r (HL)
elsif std_match(mem_dout, "10---110") then  -- f    A (HL)
elsif std_match(mem_dout, "11---110") then  -- f    A n
elsif std_match(mem_dout, "11---111") then  -- RST  t 
elsif std_match(mem_dout, "01------") then  -- LD   r r'
elsif std_match(mem_dout, "10------") then  -- f    A r'
