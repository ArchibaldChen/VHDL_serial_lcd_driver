-- spi_write_modeule
--这个模块接收10位数据，转换为串行输出，其中有一个时间常量确定了半周期分频。
--遗留问题：除法不能综合成电路，寻找把i进行移位的方案，同时注意原文对i的操作有点奇怪，2/10进制交错使用
library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

entity spi is
port(
	clk: in std_logic; 
	rst:in std_logic;
	start:in std_logic; 
	spi_in:in std_logic_vector(9 downto 0);
	done:out std_logic;
	spi_out:out std_logic_vector(3 downto 0);clk_3n:out std_logic
);
end entity;
architecture behave of spi is
	constant f:integer:=9;
	signal count:integer;
	signal i:integer;
	signal rclk,rdo,isdone:std_logic;
begin
	process(clk,rst)
	begin
	if(clk'event and clk='1')then
		if(rst='0')then
		count<=0;
		elsif(count=f)then
		count<=0;
		elsif(start='1')then
		count<=count+1;
		else
		count<=0;
		end if;
		end if;
	end process;
	
	process(clk,rst)
	variable temp:integer;
	begin
	if(clk'event and clk='1')then
	if (rst='0')then
	i<=0;rclk<='1';rdo<='0';isdone<='0';
	elsif(start='1')then
	case i is 
		when 0 =>if(count=f)then rclk<='0';rdo<=spi_in(7);temp:=i;i<=temp+1;end if;--反正无伤大雅，干脆手写变量，忽略未知部分。最专业的做法是采用类型转换，先暂时这么用，不行再用专业的办法，因为这种方法可能不能总合成电路
		when 2 =>if(count=f)then rclk<='0';rdo<=spi_in(6);temp:=i;i<=temp+1;end if;
		when 4 =>if(count=f)then rclk<='0';rdo<=spi_in(5);temp:=i;i<=temp+1;end if;
		when 6 =>if(count=f)then rclk<='0';rdo<=spi_in(4);temp:=i;i<=temp+1;end if;
		when 8 =>if(count=f)then rclk<='0';rdo<=spi_in(3);temp:=i;i<=temp+1;end if;
		when 10 =>if(count=f)then rclk<='0';rdo<=spi_in(2);temp:=i;i<=temp+1;end if;
		when 12 =>if(count=f)then rclk<='0';rdo<=spi_in(1);temp:=i;i<=temp+1;end if;
		when 14 =>if(count=f)then rclk<='0';rdo<=spi_in(0);temp:=i;i<=temp+1;end if;
		when 1=>if(count=f)then rclk<='1';temp:=i;i<=temp+1;end if;
		when 3=>if(count=f)then rclk<='1';temp:=i;i<=temp+1;end if;
		when 5=>if(count=f)then rclk<='1';temp:=i;i<=temp+1;end if;
		when 7=>if(count=f)then rclk<='1';temp:=i;i<=temp+1;end if;
		when 9=>if(count=f)then rclk<='1';temp:=i;i<=temp+1;end if;
		when 11=>if(count=f)then rclk<='1';temp:=i;i<=temp+1;end if;
		when 13=>if(count=f)then rclk<='1';temp:=i;i<=temp+1;end if;
		when 15=>if(count=f)then rclk<='1';temp:=i;i<=temp+1;end if;
		when 16=>isdone<='1';temp:=i;i<=temp+1;
		when 17=>isdone<='0';i<=0;
		when others =>null;
		end case;
	end if;
	end if;
		end process;
		done<=isdone;
		spi_out(3)<=spi_in(9);
		spi_out(2)<=spi_in(8);
		spi_out(1)<=rclk;
		spi_out(0)<=rdo;
		clk_3n<=rclk;
		--spi_out<={spi_in(9),spi_in(8),rclk,rdo};
end architecture;