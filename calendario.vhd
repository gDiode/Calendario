--CABECERAS
library	ieee;
use		ieee.std_logic_1164.all;
use		ieee.numeric_std.all;

--ENTIDAD
entity calendario is
port(
	clk,rst,ctrl	: in	std_logic;
	u1,u2,d1,d2	: out	std_logic_vector(3 downto 0) -- no ;
);
end calendario;

--ARQUITECTURA
architecture arq1 of calendario is
--declaraciones
	type estados is (reloj,mesdia,anio);
	signal maquina: estados;
	--memorias ded relojr
	signal iseg,imin : unsigned(5 downto 0);
	signal ihor,idias : unsigned (4 downto 0);
	signal imes : unsigned (3 downto 0);
	signal ianio: unsigned (13 downto 0);--max 16k anios
	--memorias para la conversion
	signal useg,umin : unsigned(5 downto 0);
	signal uhor,udias : unsigned (4 downto 0);
	signal umes : unsigned (3 downto 0);
	signal uanio: unsigned (13 downto 0);
	
	signal dseg,dmin : unsigned(5 downto 0);
	signal dhor,ddias : unsigned (4 downto 0);
	signal dmes : unsigned (3 downto 0);
	signal danio: unsigned (13 downto 0);
	
	signal canio: unsigned (13 downto 0);
	signal manio: unsigned (27 downto 0);
	--memorias para salidas
	signal memsegu,memsegd,memminu,memmind,memhoru : unsigned(3 downto 0);
	signal memhord,memdiau,memdiad,memmesu,memmesd,timer2s : unsigned(3 downto 0);
	signal memaniou,memaniod,memanioc,memaniom : unsigned(3 downto 0);
	signal fbisciesto : std_logic;--flag de bisiesto
	


begin



aniobisiesto:process(ianio)
begin

if(ianio mod  4 = 0) then
	if(ianio mod 100 = 0) then
		if(ianio mod 400 = 0) then
			fbisciesto<='1';
			else
			fbisciesto<='0';
			end if;
		else
		fbisciesto<='1';
	end if;
else
	fbisciesto<='0';
end if;

--bisiesto o no y levanta un flag
--1 Si el año es uniformemente divisible por 4, vaya al paso 2. De lo contrario, vaya al paso 5.
--2 Si el año es uniformemente divisible por 100, vaya al paso 3. De lo contrario, vaya al paso 4.
--3 Si el año es uniformemente divisible por 400, vaya al paso 4. De lo contrario, vaya al paso 5.
--4 El año es un año bisiesto (tiene 366 días).
--5 El año no es un año bisiesto (tiene 365 días).
end process;

--incremento de numeritos

	contador: process(clk)
	begin
		if rising_edge(clk) then
			if (rst='1') then
				iseg<= (others=>'0');
--				memsegu <= (others=>'0');
--				memsegd <= (others=>'0');
		--		imin<= (others=>'0');
--				memminu <= (others=>'0');
--				memmind <= (others=>'0');
		--		ihor<= (others=>'0');
--				memhoru <= (others=>'0');
--				memhord <= (others=>'0');
				-- es conforme al inicio del unix time 1 enero 1970
			
		--		idias<="00001";
--				memdiau <= "0001"; --no hay dias con 0
--				memdiad <= (others=>'0');
		--		imes<="0001";
--				memmesu <= "0001"; -- tampoco meses con 0 KEKW
--				memmesd <= (others=>'0');

				--1970
--				ianio<="00011110110010"; 
--				memaniou<=(others=>'0');
--				memaniod<= "0111"; -- es un 7 ok?
--				memanioc<= "1001"; -- 9
--				memaniom<= "0001"; --1
			
		
				--2011 feb 28  dos minuto antes del siguiente dia
				ianio<="00011111011000";
			--ianio<="00011111011100";
				imes<="0010";
				idias<="11100";
				ihor<="10111";
				imin<="111010";
				
			else
--			
		if(iseg=59) then
		iseg<= (others=>'0');
			if(imin=59) then
			imin<= (others=>'0');
				if(ihor=23) then
				ihor<= (others=>'0');
					
					
					case(imes) is
						when "0001"|"0011"|"0101"|"0111"|"1000"|"1010"|"1100" => --31 1|3|5|7|8|10|12
							if(idias=31) then
									idias<= "00001";
									if(imes=12) then
										imes<="0001";
										ianio<=ianio+1;
										else
										imes<=imes+1;
									end if;
								else
								idias<=idias+1;
							end if;	
						when "0100"|"0110"|"1001"|"1011" => --30 4|6|9|11
							if(idias=30) then
								idias<= "00001";
									if(imes=12) then
										imes<="0001";
										ianio<=ianio+1;
										else
										imes<=imes+1;
									end if;								
								else
								idias<= idias+1;
							end if;	
						when "0010" => --bisiesto
							if(fbisciesto='1') then
								if(idias=29) then
									idias<= "00001";
									if(imes=12) then
										imes<="0001";
										ianio<=ianio+1;
										else
										imes<=imes+1;
									end if;								
									else
									idias<= idias+1;
								end if;
							else
								if(idias=28) then
									idias<= "00001";
									if(imes=12) then
										imes<="0001";
										ianio<=ianio+1;
										else
										imes<=imes+1;
									end if;
								else
								idias<=idias+1;
								end if;	
							end if;
							
						when others=>
							idias<=(others=>'Z');
					end case;
					
				else
				ihor<=ihor+1;
				end if;--ihor
			else
			imin<=imin+1;
			end if;--imin
		else
		iseg<=iseg+1;
		end if;--iseg
	end if; -- rst
end if; --rising edge
end process;

--	signal iseg,imin : unsigned(5 downto 0);
--	signal ihor,idias : unsigned (4 downto 0);
--	signal imes : unsigned (3 downto 0);
--	signal ianio: unsigned (13 downto 0);

--convertidor de datos

--aqui como los datos son mas grandes que las salidas, se tienen que adaptar a una salida de 4 bits


conversionmin :process(clk,iseg,imin,ihor,idias,imes,ianio,useg,dseg,umin,dmin,uhor,dhor,udias,ddias,umes,dmes,uanio,danio,canio,manio)	
begin
if (rising_edge(clk)) then
--var d = (z % 100 - u) /10;
umin<=imin mod 10;
memminu<=umin(3)&umin(2)&umin(1)&umin(0);


--var d = (z % 100 - u) /10;
dmin<=(imin mod 100 - umin)/10;
memmind<=dmin(3)&dmin(2)&dmin(1)&dmin(0);
end if;
end process;
----
----
conversionhor: process(clk,ihor,uhor,memhord,memhoru)
begin
if (rising_edge(clk)) then
uhor<=ihor mod 10;
memhoru<=uhor(3)&uhor(2)&uhor(1)&uhor(0);
--
dhor<=((ihor mod 100) - uhor)/10;
memhord<=dhor(3)&dhor(2)&dhor(1)&dhor(0);
end if;
end process;



conversiondias: process(clk,udias,memdiau,memdiad,idias)
begin
if rising_edge(clk) then
udias<=idias mod 10;
memdiau<=udias(3)&udias(2)&udias(1)&udias(0);

ddias<=((idias mod 100) - udias)/10;
memdiad<=ddias(3)&ddias(2)&ddias(1)&ddias(0);
end if;
end process;
----
--
conversionmes: process(clk,imes,umes,memmesu,memmesd)
begin
if rising_edge(clk) then
umes<= imes mod 10;
memmesu<=umes(3)&umes(2)&umes(1)&umes(0);

dmes<=((imes mod 100) - umes)/10;
memmesd<=dmes(3)&dmes(2)&dmes(1)&dmes(0);
end if;
end process;

conversionanio: process(clk,ianio,uanio)
begin
if rising_edge (clk) then

uanio<= ianio mod 10;
memaniou<=uanio(3)&uanio(2)&uanio(1)&uanio(0);

danio<=((ianio mod 100) - danio)/10;
memaniod<=danio(3)&danio(2)&danio(1)&danio(0);

--var c = ((z -(z % 100 - u) - u) /100) % 10
canio<=((ianio-(ianio mod 100 - uanio)-uanio)/10) mod 10;
memanioc<=canio(3)&canio(2)&canio(1)&canio(0);

--var m =(z - u - d*10 - c*100)/1000;
manio<=(ianio - uanio - (danio * 10) - (canio * 100))/1000 ;
memaniom<=manio(3)&manio(2)&manio(1)&manio(0);
end if;
end process;
	
	
	
	
	--se encarga de la logica de boton de DD/mm y YYYY
	
display: process(ctrl,clk,rst,maquina,memsegu,memsegd,memminu,memmind,memhoru,memhord,memdiau,memdiad,memmesu,memmesd,timer2s,memaniou,memaniod,memanioc,memaniom)
	begin
	if rising_edge(clk)then
	if (rst='1') then
		 maquina<= reloj;
		else
		case(maquina) is
		
			when reloj =>
						--salidas y señales/memorias
						u1<=std_logic_vector(memminu);
						d1<=std_logic_vector(memmind);--min
						u2<=std_logic_vector(memhoru);
						d2<=std_logic_vector(memhord);--horas
						--transiciones
						if (ctrl='1') then
							maquina <= mesdia;
							else
							
						end if;
					--algo por aqui esta pendejeandola
					
			when mesdia =>
						--salidas/memorias/señales
						u1<=std_logic_vector(memdiau);
						d1<=std_logic_vector(memdiad);
						u2<=std_logic_vector(memmesu);
						d2<=std_logic_vector(memmesd);
						
						
						--transiciones
						if (timer2s=2) then
							maquina <= anio;
							timer2s <= (others=>'0');
							else
							timer2s<= timer2s + 1;
							end if;
			when anio =>
						--salidas etc
						u1<=std_logic_vector(memaniou);
						d1<=std_logic_vector(memaniod);
						u2<=std_logic_vector(memanioc);
						d2<=std_logic_vector(memaniom);
						--transiciones
						if (timer2s=2) then
							maquina <= reloj;
							timer2s <= (others=>'0');
							else
							timer2s<= timer2s + 1;
							end if;

				end case;
		end if;
	end if; --rising edge	
	end process;



end arq1;