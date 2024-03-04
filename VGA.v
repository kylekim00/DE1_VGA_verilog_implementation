module vga_connect (
    clk, vga_clk, vsync, hsync, vid_blank, VGA_R, VGA_G, VGA_B
    
    // output reg vga_sync
);
    input clk;
    output reg vga_clk = 0;
    output vsync;
    output hsync;
    output vid_blank;
    output [7:0] VGA_R;
    output [7:0] VGA_G;
    output [7:0] VGA_B;
    //vga clock 25mhz
        // reg vga_clk = 0;
        always @(posedge clk) begin
            vga_clk = ~vga_clk;
        end

    reg [30:0] mov_cnt = 0;
    always @(posedge clk) begin
        if(mov_cnt[30:21] > 640)begin
            mov_cnt = 0;
        end
        else begin
            mov_cnt = mov_cnt + 1;
        end

    end

    reg [20:0] contvidv = 0, contvidh =0;
    assign vsync = ((contvidv >= 498) & (contvidv < 500))? 1'b0 : 1'b1;//7 line
    assign hsync = ((contvidh >= 666) & (contvidh < 761))? 1'b0 : 1'b1;//96 clock
    assign vid_blank = ((contvidv >= 8) & (contvidv < 488) & (contvidh >= 16) & (contvidh < 651)) ? 1'b1 : 1'b0;//412 line, 604cycle
	 
    wire clrvidh = (contvidh <= 793) ? 1'b0 : 1'b1;
    wire clrvidv = (contvidv <= 525) ? 1'b0 : 1'b1;
//	 assign VGA_R = ((contvidh >=641)&(contvidh < 651)&(contvidv >= 478) & (contvidv < 488))? 8'd255:8'd0;
//	 assign VGA_G = ((contvidh >=641)&(contvidh < 651)&(contvidv >= 478) & (contvidv < 488))? 8'd255:8'd0;
//	 assign VGA_B = ((contvidh >=641)&(contvidh < 651)&(contvidv >= 478) & (contvidv < 488))? 8'd255:8'd0;
	 assign VGA_R = (contvidh > mov_cnt[30:21] + 8 & contvidh < mov_cnt[30:21] + 16)? 8'd255:0;
	 assign VGA_B = (contvidh > mov_cnt[30:21] + 8 & contvidh < mov_cnt[30:21] + 16)? 8'd255:0;
	 assign VGA_G = (contvidh > mov_cnt[30:21] + 8 & contvidh < mov_cnt[30:21] + 16)? 8'd255:0;
    always@(posedge vga_clk)begin
        if(clrvidh) begin
            contvidh <= 0;
        end
        else begin
            contvidh <= contvidh + 1;
        end
    end

    always@(posedge vga_clk) begin
        if(clrvidv) begin
            contvidv <= 0;
        end
        else begin
            if(contvidh == 791)begin
                contvidv <= contvidv + 1;
            end
        end
    end
	 
	 
	 
endmodule
