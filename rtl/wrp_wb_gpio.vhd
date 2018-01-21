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

architecture rtl of wrp_wb_gpio is 
  component wb_gpio
    port (
      clk_sys_i : in std_logic;
      rst_n_i   : in std_logic;
      
      gpio_in_i   : in std_logic_vector(7 downto 0);
      gpio_oen_o   : out std_logic_vector(7 downto 0);
      gpio_out_o  : out std_logic_vector(7 downto 0);
      -- GPIO      : inout std_logic_vector(7 downto 0);
      
      wb_adr_i  : in std_logic_vector(4 downto 0);
      wb_dat_i  : in std_logic_vector(31 downto 0);
      wb_dat_o  : out std_logic_vector(31 downto 0);
      --wb_sel_i  : in std_logic;
      wb_stb_i  : in std_logic;
      wb_cyc_i  : in std_logic;
      wb_we_i   : in std_logic;
      wb_ack_o  : out std_logic
    );
  end component;
begin
  U_gpio_wb : wb_gpio
    port map (
        clk_sys_i  => clk_sys_i,
        rst_n_i    => rst_n_i,
        
        gpio_in_i => gpio_in_i,
        gpio_oen_o => gpio_oen_o,
        gpio_out_o => gpio_out_o,
        -- GPIO    => GPIO,
        
        wb_adr_i   => slave_i.adr(4 downto 0),
        wb_dat_i   => slave_i.dat,
        wb_dat_o   => slave_o.dat,
        --wb_sel_i   => slave_i.sel,
        wb_stb_i   => slave_i.stb,
        wb_cyc_i   => slave_i.cyc,
        wb_we_i    => slave_i.we,
        wb_ack_o   => slave_o.ack
        --   wb_err_o   => slave_o.err,
        --   wb_int_o   => slave_o.int,
        --   wb_stall_o => slave_o.stall,
    );
end rtl;