module vga_pwm
(
	input				clk,
	input				csync_en,
	 
	input				hsync,
	input				csync,
	 
	input			[23:0] din,
	output reg	[17:0] dout
);

	reg [1:0] phase;
	always @(posedge clk) begin
		if (csync_en ? ~csync : ~hsync)
			phase <= phase + 2'd1;
		else
			phase <= 2'd0;
	end

	reg  [23:0] din_q;
	reg  [17:0] dout_q;



	always @(posedge clk) begin
		din_q <= din;

		dout_q[17:12] 	<= din_q[23:18] + ((phase < din_q[17:16]) & ~&din_q[23:18]);
		dout_q[11:6] 	<= din_q[15:10] + ((phase < din_q[9:8])  & ~&din_q[15:10]);
		dout_q[5:0]   	<= din_q[7:2]  + ((phase < din_q[1:0])  & ~&din_q[7:2]);

		dout <= dout_q;
    end

endmodule