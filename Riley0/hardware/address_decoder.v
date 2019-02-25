module address_decoder(	
	input [15:0] address,
	output ram_sel,
	output io_sel,
	output rom_sel
	);

wire [7:0] upper_nibble_enable;
	
ic_74138 u7(
	.A(address[12:3]),
	.Y(upper_nibble_enable),
	.E1(address[15]),
	.E2(0),
	.E3(0)
	);

assign io_sel = upper_nibble_enable[5];

ic_7400 u8(
	.A2(io_sel),
	.B2(rom_sel),
	.Y2(ram_sel),
	.A3(upper_nibble_enable[6]),
	.B3(upper_nibble_enable[7]),
	.Y3(rom_sel)
	);

endmodule
