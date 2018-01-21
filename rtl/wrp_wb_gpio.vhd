library ieee;
use ieee.std_logic_1164.all;
use work.wishbone_pkg.all;

entity wrp_wb_gpio is
    port(
      clk_sys_i     : in std_logic;
      rst_n_i       : in std_logic;
      
      gpio_in_i     : in std_logic_vector(7 downto 0);
      gpio_oen_o    : out std_logic_vector(7 downto 0);
      gpio_out_o    : out std_logic_vector(7 downto 0);
      -- GPIO        : inout std_logic_vector(7 downto 0);
      
      slave_i       : in  t_wishbone_slave_in;
      slave_o       : out t_wishbone_slave_out;
      desc_o        : out t_wishbone_device_descriptor
    );
end wrp_wb_gpio;
