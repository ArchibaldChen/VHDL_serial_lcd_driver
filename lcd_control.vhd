library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

entity lcd_control is
port(clk:in std_logic;
rst:in std_logic;
read_data:in std_logic_vector(7 downto 0);
read_add:out std_logic_vector(9 downto 0);
spi_done:in std_logic;
spi_start:out std_logic;
spi_data:out std_logic_vector(9 downto 0);testpin2:out std_logic;clk_2n:out std_logic
);
end entity;

architecture behave of lcd_control is
	--constant f25:std_logic_vector:="1111010000100011111";--用于40Hz的分频
	--signal c:std_logic_vector(18 downto 0);--这里尝试采用二进制数组代替一般的计数以满足/2的要求
	--位操作实现过于困难，考虑采用土办法替代
	--constant f25:integer:=499999;
	constant f25:integer:=416667;
	signal c:integer;
	signal isstart:std_logic_vector(1 downto 0);
	--signal i:std_logic_vector(5 downto 0);
	signal i:integer;
	signal rdata:std_logic_vector(9 downto 0);
	signal x:std_logic_vector(7 downto 0);
	signal y:std_logic_vector(3 downto 0);
	--signal y:bit_vector(3 downto 0);
	signal isdone,isspi_start:std_logic;
	signal temp_add:std_logic_vector(11 downto 0);
	
	begin
	process(clk,rst)
	variable temp:integer;
	begin
	if(clk'event and clk='1')then
	if(rst='0')then 
	c<=0;
	elsif(c=f25)then
	c<=0;
	else
	temp:=c;
	c<=temp+1;
	end if;
	end if;
	end process;
	
	process(clk,rst)
	begin
	if(clk'event and clk='1')then
	if(rst='0')then isstart<="10";
	elsif(c=f25)then isstart<="01";
	elsif(isdone='1')then isstart<="00";
	end if;
	end if;
	end process;
	
	process(clk,rst)
	--variable te:std_logic_vector(5 downto 0);
	variable te:integer;
	variable tex:std_logic_vector(7 downto 0);
	variable tey:std_logic_vector(3 downto 0);
	begin
	if(clk'event and clk='1')then
	if(rst='0')then
	--i<="000000";
	i<=0;
	rdata<="11"&"00101111";
	x<="00000000";
	y<="0000";
	isspi_start<='0';
	isdone<='0';
	elsif(isstart(1)='1')then--初始化功能
		case i is
		when 0=>if(spi_done='1')then 
		isspi_start<='0';te:=i;i<=te+1;
		else rdata<="00"&"10101111";isspi_start<='1';end if;
		when 1=>if(spi_done='1')then 
		isspi_start<='0';te:=i;i<=te+1;
		else rdata<="00"&"01000000";isspi_start<='1';end if;
		when 2=>if(spi_done='1')then 
		isspi_start<='0';te:=i;i<=te+1;
		else rdata<="00"&"10100000";isspi_start<='1';end if;
		--else rdata<="00"&"10100110";isspi_start<='1';end if;
		when 3=>if(spi_done='1')then 
		isspi_start<='0';te:=i;i<=te+1;
		--else rdata<="00"&"10100000";isspi_start<='1';end if;
		else rdata<="00"&"10100110";isspi_start<='1';end if;
		when 4=>if(spi_done='1')then 
		isspi_start<='0';te:=i;i<=te+1;
		--else rdata<="00"&"11001000";isspi_start<='1';end if;
		else rdata<="00"&"10100100";isspi_start<='1';end if;
		when 5=>if(spi_done='1')then 
		isspi_start<='0';te:=i;i<=te+1;
		else rdata<="00"&"10100010";isspi_start<='1';end if;
		when 6=>if(spi_done='1')then 
		isspi_start<='0';te:=i;i<=te+1;
		else rdata<="00"&"11001000";isspi_start<='1';end if;
		when 7=>if(spi_done='1')then 
		isspi_start<='0';te:=i;i<=te+1;
		else rdata<="00"&"00101111";isspi_start<='1';end if;
		when 8=>if(spi_done='1')then 
		isspi_start<='0';te:=i;i<=te+1;
		else rdata<="00"&"00100100";isspi_start<='1';end if;
		when 9=>if(spi_done='1')then 
		isspi_start<='0';te:=i;i<=te+1;
		else rdata<="00"&"10000001";isspi_start<='1';end if;
		when 10=>if(spi_done='1')then 
		isspi_start<='0';te:=i;i<=te+1;
		else rdata<="00"&"00100100";isspi_start<='1';end if;
		when 11=>rdata<="11"&"00101111";isdone<='1';te:=i;i<=te+1;
		--when 12=>isdone<='0';i<="000000"
		when 12=>isdone<='0';i<=0;
		when others =>
		null;
		end case;
		
	elsif(isstart(0)='1')then--draw功能
		case i is
		when 0=>if(spi_done='1')then 
		isspi_start<='0';te:=i;i<=te+1;
		else rdata<="00"&"1011"&y;isspi_start<='1';end if;
		when 4=>if(spi_done='1')then isspi_start<='0';te:=i;i<=te+1;else rdata<="00"&"1011"&y;isspi_start<='1';end if;
		when 8=>if(spi_done='1')then isspi_start<='0';te:=i;i<=te+1;else rdata<="00"&"1011"&y;isspi_start<='1';end if;
		when 12=>if(spi_done='1')then isspi_start<='0';te:=i;i<=te+1;else rdata<="00"&"1011"&y;isspi_start<='1';end if;
		when 16=>if(spi_done='1')then isspi_start<='0';te:=i;i<=te+1;else rdata<="00"&"1011"&y;isspi_start<='1';end if;
		when 20=>if(spi_done='1')then isspi_start<='0';te:=i;i<=te+1;else rdata<="00"&"1011"&y;isspi_start<='1';end if;
		when 24=>if(spi_done='1')then isspi_start<='0';te:=i;i<=te+1;else rdata<="00"&"1011"&y;isspi_start<='1';end if;
		when 28=>if(spi_done='1')then isspi_start<='0';te:=i;i<=te+1;else rdata<="00"&"1011"&y;isspi_start<='1';end if;
		
		when 1=>if(spi_done='1')then isspi_start<='0';te:=i;i<=te+1;else rdata<="00"&"0001"&"0000";isspi_start<='1';end if;
		when 5=>if(spi_done='1')then isspi_start<='0';te:=i;i<=te+1;else rdata<="00"&"0001"&"0000";isspi_start<='1';end if;
		when 9=>if(spi_done='1')then isspi_start<='0';te:=i;i<=te+1;else rdata<="00"&"0001"&"0000";isspi_start<='1';end if;
		when 13=>if(spi_done='1')then isspi_start<='0';te:=i;i<=te+1;else rdata<="00"&"0001"&"0000";isspi_start<='1';end if;
		when 17=>if(spi_done='1')then isspi_start<='0';te:=i;i<=te+1;else rdata<="00"&"0001"&"0000";isspi_start<='1';end if;
		when 21=>if(spi_done='1')then isspi_start<='0';te:=i;i<=te+1;else rdata<="00"&"0001"&"0000";isspi_start<='1';end if;
		when 25=>if(spi_done='1')then isspi_start<='0';te:=i;i<=te+1;else rdata<="00"&"0001"&"0000";isspi_start<='1';end if;
		when 29=>if(spi_done='1')then isspi_start<='0';te:=i;i<=te+1;else rdata<="00"&"0001"&"0000";isspi_start<='1';end if;
		
		when 2=>if(spi_done='1')then isspi_start<='0';te:=i;i<=te+1;else rdata<="00"&"0000"&"0000";isspi_start<='1';end if;
		when 6=>if(spi_done='1')then isspi_start<='0';te:=i;i<=te+1;else rdata<="00"&"0000"&"0000";isspi_start<='1';end if;
		when 10=>if(spi_done='1')then isspi_start<='0';te:=i;i<=te+1;else rdata<="00"&"0000"&"0000";isspi_start<='1';end if;
		when 14=>if(spi_done='1')then isspi_start<='0';te:=i;i<=te+1;else rdata<="00"&"0000"&"0000";isspi_start<='1';end if;
		when 18=>if(spi_done='1')then isspi_start<='0';te:=i;i<=te+1;else rdata<="00"&"0000"&"0000";isspi_start<='1';end if;
		when 22=>if(spi_done='1')then isspi_start<='0';te:=i;i<=te+1;else rdata<="00"&"0000"&"0000";isspi_start<='1';end if;
		when 26=>if(spi_done='1')then isspi_start<='0';te:=i;i<=te+1;else rdata<="00"&"0000"&"0000";isspi_start<='1';end if;
		when 30=>if(spi_done='1')then isspi_start<='0';te:=i;i<=te+1;else rdata<="00"&"0000"&"0000";isspi_start<='1';end if;
		
		when 3=>if(x="10000000")then tey:=y;y<=tey+1;x<="00000000";te:=i;i<=te+1;elsif(spi_done='1')then isspi_start<='0';tex:=x;x<=tex+1;else rdata<="01"&read_data;isspi_start<='1';end if;
		when 7=>if(x="10000000")then tey:=y;y<=tey+1;x<="00000000";te:=i;i<=te+1;elsif(spi_done='1')then isspi_start<='0';tex:=x;x<=tex+1;else rdata<="01"&read_data;isspi_start<='1';end if;
		when 11=>if(x="10000000")then tey:=y;y<=tey+1;x<="00000000";te:=i;i<=te+1;elsif(spi_done='1')then isspi_start<='0';tex:=x;x<=tex+1;else rdata<="01"&read_data;isspi_start<='1';end if;
		when 15=>if(x="10000000")then tey:=y;y<=tey+1;x<="00000000";te:=i;i<=te+1;elsif(spi_done='1')then isspi_start<='0';tex:=x;x<=tex+1;else rdata<="01"&read_data;isspi_start<='1';end if;
		when 19=>if(x="10000000")then tey:=y;y<=tey+1;x<="00000000";te:=i;i<=te+1;elsif(spi_done='1')then isspi_start<='0';tex:=x;x<=tex+1;else rdata<="01"&read_data;isspi_start<='1';end if;
		when 23=>if(x="10000000")then tey:=y;y<=tey+1;x<="00000000";te:=i;i<=te+1;elsif(spi_done='1')then isspi_start<='0';tex:=x;x<=tex+1;else rdata<="01"&read_data;isspi_start<='1';end if;
		when 27=>if(x="10000000")then tey:=y;y<=tey+1;x<="00000000";te:=i;i<=te+1;elsif(spi_done='1')then isspi_start<='0';tex:=x;x<=tex+1;else rdata<="01"&read_data;isspi_start<='1';end if;
		when 31=>if(x="10000000")then tey:=y;y<=tey+1;x<="00000000";te:=i;i<=te+1;elsif(spi_done='1')then isspi_start<='0';tex:=x;x<=tex+1;else rdata<="01"&read_data;isspi_start<='1';end if;
		
		when 32=>rdata<="1100000000";y<="0000";isdone<='1';te:=i;i<=te+1;
		--when 33=>isdone<='0';i<="000000";
		when 33=>isdone<='0';i<=0;
		when others =>
		null;
		end case;
	end if;
	end if;
	end process;
	
	
	temp_add<=x+to_STDLOGICVECTOR((TO_BITVECTOR("00000000"&y) sll 7));--这里的原文是y<<7，依然无法确定位操作的问题
	read_add<=temp_add(9 downto 0);
	--read_add<=x+to_STDLOGICVECTOR((conv_integer(y)*128));
	spi_start<=isspi_start;
	spi_data<=rdata;
	--testpin<=temp_add(7);
	testpin2<=isstart(0);
	clk_2n<=not isstart(0);
end architecture;