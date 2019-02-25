module riley0(
	input CLOCK_IN,
	input RESET
	);

wire [15:0] address;	// Address bus
wire [7:0] data;		// Data bus
wire write_enable;   // write enable
wire irq;				// interrupt request
wire nmi;      		// non-maskable interrupt request
wire rdy;				// Ready signal. Pauses CPU when RDY=0 

// Chip selects
wire ram_enable;

cpu_65c02 cpu(
	.AB(address),
	.DI(data),
	.DO(data),
	.WE(write_enable),
	.IRQ(irq),
	.NMI(nmi),
	.RDY(rdy)
	);

sram ram(
	.address(ADDRESS),
	.data(DATA),
	.chip_enable(ram_enable),
	.write_enable(write_enable),
	.output_enable(output_enable)
	);
	
endmodule
