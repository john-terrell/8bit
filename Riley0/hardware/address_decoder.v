`timescale 1 ns/10 ps  // time-unit = 1 ns, precision = 10 ps

module address_decoder(	
	input [15:0] address,
	output ram_sel,
	output io_sel,
	output rom_sel
	);

wire [7:0] upper_nibble_enable;
	
ic_74138 u7(
	.A(address[14:12]),
	.Y(upper_nibble_enable),
	.E1(0),
	.E2(0),
	.E3(address[15])
	);

assign io_sel = upper_nibble_enable[5];
	
wire rom_line_and;	
	
ic_7400 u8(
	.A1(St0),
	.B1(St0),
	.A2(io_sel),
	.B2(rom_sel),
	.Y2(ram_sel),
	.A3(upper_nibble_enable[6]),  // A3/B3 and A4/B4 are used to implement an AND gate.
	.B3(upper_nibble_enable[7]),
	.Y3(rom_line_and),
	.A4(rom_line_and),
	.B4(rom_line_and),
	.Y4(rom_sel)
	);

endmodule

module address_decoder_tb;

	reg [15:0] address;
	wire ram_sel;
	wire rom_sel;
	wire io_sel;
	
	reg clk;
	
	// duration for each bit = 20 * timescale = 20 * 1 ns  = 20ns
	localparam period = 100;
	 
	address_decoder decoder(
		.address(address),
		.ram_sel(ram_sel),
		.rom_sel(rom_sel),
		.io_sel(io_sel)
		);

	always 
	begin
		 clk = 1'b1; 
		 #50; // high for 20 * timescale = 20 ns

		 clk = 1'b0;
		 #50; // low for 20 * timescale = 20 ns
	end		
	
	always @(posedge clk)
	begin
		address = 16'b0000000000000000;
		#5; // wait for period
		// display message if output not matched
		if(ram_sel != 0 && rom_sel != 1 && io_sel != 1)  
			$stop;

		address = 16'b1101000000000000;
		#period; // wait for period
		// display message if output not matched
		if(ram_sel != 1 && rom_sel != 1 && io_sel != 0)  
			$stop;

		address = 16'b1110000000000000;
		#period; // wait for period
		// display message if output not matched
		if(ram_sel != 1 && rom_sel != 0 && io_sel != 1)  
			$stop;

		address = 16'b1111000000000000;
		#period; // wait for period
		// display message if output not matched
		if(ram_sel != 1 && rom_sel != 0 && io_sel != 1)  
			$stop;
			
		$stop;   // end of simulation
	end
endmodule
