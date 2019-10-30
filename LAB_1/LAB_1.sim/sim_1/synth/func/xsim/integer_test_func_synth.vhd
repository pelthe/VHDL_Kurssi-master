-- Copyright 1986-2018 Xilinx, Inc. All Rights Reserved.
-- --------------------------------------------------------------------------------
-- Tool Version: Vivado v.2018.2 (win64) Build 2258646 Thu Jun 14 20:03:12 MDT 2018
-- Date        : Wed Oct 30 08:49:41 2019
-- Host        : DESKTOP-52MUKO7 running 64-bit major release  (build 9200)
-- Command     : write_vhdl -mode funcsim -nolib -force -file
--               C:/GITs/VHDL_Kurssi-master/LAB_1/LAB_1.sim/sim_1/synth/func/xsim/integer_test_func_synth.vhd
-- Design      : integer_test
-- Purpose     : This VHDL netlist is a functional simulation representation of the design and should not be modified or
--               synthesized. This netlist cannot be used for SDF annotated simulation.
-- Device      : xc7z020clg400-1
-- --------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
library UNISIM;
use UNISIM.VCOMPONENTS.ALL;
entity integer_test is
  port (
    sysclk : in STD_LOGIC;
    ja : out STD_LOGIC_VECTOR ( 7 downto 0 );
    jb : out STD_LOGIC_VECTOR ( 7 downto 0 )
  );
  attribute NotValidForBitStream : boolean;
  attribute NotValidForBitStream of integer_test : entity is true;
end integer_test;

architecture STRUCTURE of integer_test is
  signal \int_a[0]_i_2_n_0\ : STD_LOGIC;
  signal \int_a_reg[0]_i_1_n_0\ : STD_LOGIC;
  signal \int_a_reg[0]_i_1_n_1\ : STD_LOGIC;
  signal \int_a_reg[0]_i_1_n_2\ : STD_LOGIC;
  signal \int_a_reg[0]_i_1_n_3\ : STD_LOGIC;
  signal \int_a_reg[0]_i_1_n_4\ : STD_LOGIC;
  signal \int_a_reg[0]_i_1_n_5\ : STD_LOGIC;
  signal \int_a_reg[0]_i_1_n_6\ : STD_LOGIC;
  signal \int_a_reg[0]_i_1_n_7\ : STD_LOGIC;
  signal \int_a_reg[4]_i_1_n_1\ : STD_LOGIC;
  signal \int_a_reg[4]_i_1_n_2\ : STD_LOGIC;
  signal \int_a_reg[4]_i_1_n_3\ : STD_LOGIC;
  signal \int_a_reg[4]_i_1_n_4\ : STD_LOGIC;
  signal \int_a_reg[4]_i_1_n_5\ : STD_LOGIC;
  signal \int_a_reg[4]_i_1_n_6\ : STD_LOGIC;
  signal \int_a_reg[4]_i_1_n_7\ : STD_LOGIC;
  signal ja_OBUF : STD_LOGIC_VECTOR ( 7 downto 0 );
  signal jb_OBUF : STD_LOGIC_VECTOR ( 4 downto 0 );
  signal p_0_in : STD_LOGIC_VECTOR ( 4 downto 0 );
  signal sysclk_IBUF : STD_LOGIC;
  signal sysclk_IBUF_BUFG : STD_LOGIC;
  signal \NLW_int_a_reg[4]_i_1_CO_UNCONNECTED\ : STD_LOGIC_VECTOR ( 3 to 3 );
  attribute SOFT_HLUTNM : string;
  attribute SOFT_HLUTNM of \int_b[1]_i_1\ : label is "soft_lutpair1";
  attribute SOFT_HLUTNM of \int_b[2]_i_1\ : label is "soft_lutpair1";
  attribute SOFT_HLUTNM of \int_b[3]_i_1\ : label is "soft_lutpair0";
  attribute SOFT_HLUTNM of \int_b[4]_i_1\ : label is "soft_lutpair0";
begin
\int_a[0]_i_2\: unisim.vcomponents.LUT1
    generic map(
      INIT => X"1"
    )
        port map (
      I0 => ja_OBUF(0),
      O => \int_a[0]_i_2_n_0\
    );
\int_a_reg[0]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => sysclk_IBUF_BUFG,
      CE => '1',
      D => \int_a_reg[0]_i_1_n_7\,
      Q => ja_OBUF(0),
      R => '0'
    );
\int_a_reg[0]_i_1\: unisim.vcomponents.CARRY4
     port map (
      CI => '0',
      CO(3) => \int_a_reg[0]_i_1_n_0\,
      CO(2) => \int_a_reg[0]_i_1_n_1\,
      CO(1) => \int_a_reg[0]_i_1_n_2\,
      CO(0) => \int_a_reg[0]_i_1_n_3\,
      CYINIT => '0',
      DI(3 downto 0) => B"0001",
      O(3) => \int_a_reg[0]_i_1_n_4\,
      O(2) => \int_a_reg[0]_i_1_n_5\,
      O(1) => \int_a_reg[0]_i_1_n_6\,
      O(0) => \int_a_reg[0]_i_1_n_7\,
      S(3 downto 1) => ja_OBUF(3 downto 1),
      S(0) => \int_a[0]_i_2_n_0\
    );
\int_a_reg[1]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => sysclk_IBUF_BUFG,
      CE => '1',
      D => \int_a_reg[0]_i_1_n_6\,
      Q => ja_OBUF(1),
      R => '0'
    );
\int_a_reg[2]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => sysclk_IBUF_BUFG,
      CE => '1',
      D => \int_a_reg[0]_i_1_n_5\,
      Q => ja_OBUF(2),
      R => '0'
    );
\int_a_reg[3]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => sysclk_IBUF_BUFG,
      CE => '1',
      D => \int_a_reg[0]_i_1_n_4\,
      Q => ja_OBUF(3),
      R => '0'
    );
\int_a_reg[4]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => sysclk_IBUF_BUFG,
      CE => '1',
      D => \int_a_reg[4]_i_1_n_7\,
      Q => ja_OBUF(4),
      R => '0'
    );
\int_a_reg[4]_i_1\: unisim.vcomponents.CARRY4
     port map (
      CI => \int_a_reg[0]_i_1_n_0\,
      CO(3) => \NLW_int_a_reg[4]_i_1_CO_UNCONNECTED\(3),
      CO(2) => \int_a_reg[4]_i_1_n_1\,
      CO(1) => \int_a_reg[4]_i_1_n_2\,
      CO(0) => \int_a_reg[4]_i_1_n_3\,
      CYINIT => '0',
      DI(3 downto 0) => B"0000",
      O(3) => \int_a_reg[4]_i_1_n_4\,
      O(2) => \int_a_reg[4]_i_1_n_5\,
      O(1) => \int_a_reg[4]_i_1_n_6\,
      O(0) => \int_a_reg[4]_i_1_n_7\,
      S(3 downto 0) => ja_OBUF(7 downto 4)
    );
\int_a_reg[5]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => sysclk_IBUF_BUFG,
      CE => '1',
      D => \int_a_reg[4]_i_1_n_6\,
      Q => ja_OBUF(5),
      R => '0'
    );
\int_a_reg[6]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => sysclk_IBUF_BUFG,
      CE => '1',
      D => \int_a_reg[4]_i_1_n_5\,
      Q => ja_OBUF(6),
      R => '0'
    );
\int_a_reg[7]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => sysclk_IBUF_BUFG,
      CE => '1',
      D => \int_a_reg[4]_i_1_n_4\,
      Q => ja_OBUF(7),
      R => '0'
    );
\int_b[0]_i_1\: unisim.vcomponents.LUT1
    generic map(
      INIT => X"1"
    )
        port map (
      I0 => jb_OBUF(0),
      O => p_0_in(0)
    );
\int_b[1]_i_1\: unisim.vcomponents.LUT2
    generic map(
      INIT => X"6"
    )
        port map (
      I0 => jb_OBUF(0),
      I1 => jb_OBUF(1),
      O => p_0_in(1)
    );
\int_b[2]_i_1\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"78"
    )
        port map (
      I0 => jb_OBUF(0),
      I1 => jb_OBUF(1),
      I2 => jb_OBUF(2),
      O => p_0_in(2)
    );
\int_b[3]_i_1\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"7F80"
    )
        port map (
      I0 => jb_OBUF(1),
      I1 => jb_OBUF(0),
      I2 => jb_OBUF(2),
      I3 => jb_OBUF(3),
      O => p_0_in(3)
    );
\int_b[4]_i_1\: unisim.vcomponents.LUT5
    generic map(
      INIT => X"7FFF8000"
    )
        port map (
      I0 => jb_OBUF(2),
      I1 => jb_OBUF(0),
      I2 => jb_OBUF(1),
      I3 => jb_OBUF(3),
      I4 => jb_OBUF(4),
      O => p_0_in(4)
    );
\int_b_reg[0]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => sysclk_IBUF_BUFG,
      CE => '1',
      D => p_0_in(0),
      Q => jb_OBUF(0),
      R => '0'
    );
\int_b_reg[1]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => sysclk_IBUF_BUFG,
      CE => '1',
      D => p_0_in(1),
      Q => jb_OBUF(1),
      R => '0'
    );
\int_b_reg[2]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => sysclk_IBUF_BUFG,
      CE => '1',
      D => p_0_in(2),
      Q => jb_OBUF(2),
      R => '0'
    );
\int_b_reg[3]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => sysclk_IBUF_BUFG,
      CE => '1',
      D => p_0_in(3),
      Q => jb_OBUF(3),
      R => '0'
    );
\int_b_reg[4]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => sysclk_IBUF_BUFG,
      CE => '1',
      D => p_0_in(4),
      Q => jb_OBUF(4),
      R => '0'
    );
\ja_OBUF[0]_inst\: unisim.vcomponents.OBUF
     port map (
      I => ja_OBUF(0),
      O => ja(0)
    );
\ja_OBUF[1]_inst\: unisim.vcomponents.OBUF
     port map (
      I => ja_OBUF(1),
      O => ja(1)
    );
\ja_OBUF[2]_inst\: unisim.vcomponents.OBUF
     port map (
      I => ja_OBUF(2),
      O => ja(2)
    );
\ja_OBUF[3]_inst\: unisim.vcomponents.OBUF
     port map (
      I => ja_OBUF(3),
      O => ja(3)
    );
\ja_OBUF[4]_inst\: unisim.vcomponents.OBUF
     port map (
      I => ja_OBUF(4),
      O => ja(4)
    );
\ja_OBUF[5]_inst\: unisim.vcomponents.OBUF
     port map (
      I => ja_OBUF(5),
      O => ja(5)
    );
\ja_OBUF[6]_inst\: unisim.vcomponents.OBUF
     port map (
      I => ja_OBUF(6),
      O => ja(6)
    );
\ja_OBUF[7]_inst\: unisim.vcomponents.OBUF
     port map (
      I => ja_OBUF(7),
      O => ja(7)
    );
\jb_OBUF[0]_inst\: unisim.vcomponents.OBUF
     port map (
      I => jb_OBUF(0),
      O => jb(0)
    );
\jb_OBUF[1]_inst\: unisim.vcomponents.OBUF
     port map (
      I => jb_OBUF(1),
      O => jb(1)
    );
\jb_OBUF[2]_inst\: unisim.vcomponents.OBUF
     port map (
      I => jb_OBUF(2),
      O => jb(2)
    );
\jb_OBUF[3]_inst\: unisim.vcomponents.OBUF
     port map (
      I => jb_OBUF(3),
      O => jb(3)
    );
\jb_OBUF[4]_inst\: unisim.vcomponents.OBUF
     port map (
      I => jb_OBUF(4),
      O => jb(4)
    );
\jb_OBUF[5]_inst\: unisim.vcomponents.OBUF
     port map (
      I => '0',
      O => jb(5)
    );
\jb_OBUF[6]_inst\: unisim.vcomponents.OBUF
     port map (
      I => '0',
      O => jb(6)
    );
\jb_OBUF[7]_inst\: unisim.vcomponents.OBUF
     port map (
      I => '0',
      O => jb(7)
    );
sysclk_IBUF_BUFG_inst: unisim.vcomponents.BUFG
     port map (
      I => sysclk_IBUF,
      O => sysclk_IBUF_BUFG
    );
sysclk_IBUF_inst: unisim.vcomponents.IBUF
     port map (
      I => sysclk,
      O => sysclk_IBUF
    );
end STRUCTURE;
