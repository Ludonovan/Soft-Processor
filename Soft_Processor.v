`timescale 1ns / 1ps

/*
 Soft Processor Project for CMPE 420 and CMPE 330
 Author: Lucas Donovan

 8 input switches - [7:0] SWITCH
 SWITCH [7:4] - 4 bit opcode
 SWITCH [3:0] - 4 bit operand
 --- OPCODES ---
 0000 - ROM (Run the code in the ROM)
 0001 - LOD (Load from register to acc)
 0010 - STR (Store ACC to register)
 0011 - ADD (Add register to acc)
 0100 - SUB (Subtract register from acc)
 0101 - AND (AND with acc)
 0110 - OR  (OR with acc)
 0111 - LDI (Load immediate value into acc)
 1000 - ADI (Add immediate value to acc)
 1001 - SUI (Subtract immediate value from acc)
 1010 - JMP (Unconditional jump)
 1011 - JNZ (Jump if ACC != 0)
 1100 - JEZ (Jump if ACC = 0)
 1101 - JNC (Jump if no carry)
 1110 - JC  (Jump if carry)
 1111 - HLT (Halt execution)
 
 5 input buttons - 
 Reset PC without resetting registers   - UP
 Reset ACC without resetting registers  - DOWN
 Reset PC and ACC without resetting registers - LEFT
 Advance Clock   - CENTER
 Reset  - RIGHT
 
 
 --- Registers ---
 Operands are 4 bits, or 16 registers.
 
 PC  - Where we are in the program (0-16)
 ACC - Stores current value
 Registers - 16 4-bit registers
 
 --- Condition Codes ---
 carry (1 if acc has carry bit)
 zero (1 if acc is equal to 0) 

 
 8 output LEDs - [7:0] LED
 LED[7:4] - PC
 LED[3:0] - ACC
 2 Seven Segment Displays
 Left - Register Index
 Right - Value in register
*/

module Soft_Processor(
    output [7:0] LED,
    output [6:0] SEGMENT,
    output reg CTRL,
    input [7:0] SWITCH,
    input [2:0] BUTTON,
    input SYSCLK
);

    wire step;
    wire reset_all;
    wire pc_acc_reset;

    debounce STEP ( .clk(SYSCLK), .reset(1'b1), .button_in(BUTTON[0]), .button_out(step));   
    debounce RESET (.clk(SYSCLK), .reset(1'b1), .button_in(BUTTON[1]), .button_out(reset_all));
    debounce RESET_PC_ACC (.clk(SYSCLK), .reset(1'b1), .button_in(BUTTON[2]), .button_out(pc_acc_reset));

    reg [3:0] ACC;
    reg [3:0] PC;
    reg [3:0] R [0:15];
    reg carry;

    wire [7:0] rom_instr;
    Instruction_ROM ROM (.pc(PC), .instr(rom_instr));

    wire use_rom = (SWITCH[7:4] == 4'h0);
    wire [7:0] current_instr = use_rom ? rom_instr : SWITCH;

    wire [3:0] opcode = current_instr[7:4];
    wire [3:0] operand = current_instr[3:0];

    integer count, desired;
    initial begin
        CTRL = 0;
        count = 0;
        desired = 49999;
        //desired = 5; // testbench
    end

    always @(posedge SYSCLK) begin
        if (count == desired) begin
            CTRL = ~CTRL;
            count = 0;
        end else begin
            count = count + 1;
        end
    end

    integer i;
    initial begin
        PC <= 4'h0;
        ACC <= 4'h0;
    end

    always @ (posedge step or posedge reset_all or posedge pc_acc_reset) begin
       if (reset_all) begin
            ACC <= 0;
            PC <= 0;
            carry <= 0;
            for (i = 0; i < 16; i = i + 1) begin
                R[i] <= 4'b0;
            end
       end else if (pc_acc_reset) begin
            ACC <= 0;
            PC  <= 0;
       end else if (step) begin   
            case(opcode)
                4'h0: ;
                4'h1: ACC <= R[operand];
                4'h2: R[operand] <= ACC;
                4'h3: {carry, ACC} <= ACC + R[operand];
                4'h4: {carry, ACC} <= ACC - R[operand];
                4'h5: ACC <= ACC & R[operand];
                4'h6: ACC <= ACC | R[operand];
                4'h7: ACC <= operand;
                4'h8: {carry, ACC} <= ACC + operand;
                4'h9: {carry, ACC} <= ACC - operand;
                4'hA: PC <= operand;
                4'hB: if (!(ACC == 4'h0)) PC <= operand;
                4'hC: if (ACC == 4'h0) PC <= operand;
                4'hD: if (!carry) PC <= operand;
                4'hE: if (carry) PC <= operand;
                4'hF: ; // Halt
                default: ;
            endcase

            if (!(opcode == 4'hA || (opcode == 4'hB && !(ACC == 4'h0)) || (opcode == 4'hC && (ACC == 4'h0)) 
            || (opcode == 4'hD && !carry) || (opcode == 4'hE && carry) || opcode == 4'hF)) begin
                PC <= PC + 1;
            end
            
        end
    end

    wire [6:0] left;
    wire [6:0] right;
    SevenSegDisp LeftDisp (.segment(left), .value(operand));
    SevenSegDisp RightDisp (.segment(right), .value(R[operand]));
    
    wire [6:0] L_zero;
    wire [6:0] R_zero;
    SevenSegDisp Zero (.segment(L_zero), .value(0));
    SevenSegDisp R_Zero (.segment(R_zero), .value(R[0]));
    
    wire [6:0] left_seg = use_rom ? L_zero : left;
    wire [6:0] right_seg = use_rom ? R_zero : right;

    assign LED[7:4] = PC;
    assign LED[3:0] = ACC;
    assign SEGMENT = CTRL ? left_seg : right_seg;
endmodule


/*
Example Programs

Add Two Numbers
4'b0000: instr = 8'b0111_0101; // ACC = 5
4'b0001: instr = 8'b0011_1000; // ACC = ACC + 2
4'b0010: instr = 8'b1111_0000; // Stop Execution
            
Counter
// This counter does not restart at 1 when the registers are cleared on reset during execution
4'b0000: instr = 8'b1000_0000; // ACC = 0;
4'b0001: instr = 8'b0001_0000; // ACC = R0
4'b0010: instr = 8'b1000_0001; // ACC = ACC + 1
4'b0011: instr = 8'b1011_0000; // PC = 0 if ACC != 0
default: instr = 8'b1111_1111; // Halt Execution

// This counter restarts at 1 when the regitsters are cleared on reset
4'b0000: instr = 8'b1000_0001; // ACC = ACC + 1
4'b0001: instr = 8'b0010_0000; // R0 = ACC
4'b0010: instr = 8'b1011_0000; // PC = 0 if ACC != 0
default: instr = 8'b1111_1111; // Halt Execution

*/
module Instruction_ROM (
    input [3:0] pc,
    output reg [7:0] instr
);
    always @(*) begin
        case (pc)
            4'b0000: instr = 8'b0001_0000; // ACC = R0
            4'b0001: instr = 8'b1000_0001; // ACC = ACC + 1
            4'b0010: instr = 8'b0010_0000; // R0 = ACC
            4'b0011: instr = 8'b1011_0000; // PC = 0 if ACC != 0
            default: instr = 8'b1111_1111; // Halt Execution
        endcase
    end
endmodule

module SevenSegDisp(
    output reg [6:0] segment,
    input [3:0] value
);
    always @(*) begin
        case(value)
            4'b0000: segment = 7'b1111110;
            4'b0001: segment = 7'b0110000;
            4'b0010: segment = 7'b1101101;
            4'b0011: segment = 7'b1111001;
            4'b0100: segment = 7'b0110011;
            4'b0101: segment = 7'b1011011;
            4'b0110: segment = 7'b1011111;
            4'b0111: segment = 7'b1110000;
            4'b1000: segment = 7'b1111111;
            4'b1001: segment = 7'b1110011;
            4'b1010: segment = 7'b1110111;
            4'b1011: segment = 7'b0011111;
            4'b1100: segment = 7'b0001101;
            4'b1101: segment = 7'b0111101;
            4'b1110: segment = 7'b1001111;
            4'b1111: segment = 7'b1000111;
            default: segment = 7'b0000000;
        endcase
    end
endmodule

module debounce(
    input clk,
    input reset,        // Active-low
    input button_in,
    output button_out
);
    wire slow_clk_en;
    wire Q1, Q2, Q2_bar, Q0;

    clock_enable u1(
        .Clk_100M(clk),
        .reset_n(reset), 
        .slow_clk_en(slow_clk_en)
    );

    my_dff_en d0(
        .DFF_CLOCK(clk),
        .reset_n(reset),
        .clock_enable(slow_clk_en),
        .D(button_in),
        .Q(Q0)
    );
    
    my_dff_en d1(
        .DFF_CLOCK(clk),
        .reset_n(reset),
        .clock_enable(slow_clk_en),
        .D(Q0),
        .Q(Q1)
    );
    
    my_dff_en d2(
        .DFF_CLOCK(clk),
        .reset_n(reset),
        .clock_enable(slow_clk_en),
        .D(Q1),
        .Q(Q2)
    );

    assign Q2_bar = ~Q2;
    assign button_out = Q1 & Q2_bar;
endmodule

module clock_enable(
    input Clk_100M,
    input reset_n,      // Active-low
    output slow_clk_en
);
    reg [26:0] counter;
    integer desired = 249999;
    //integer desired = 5;

    always @(posedge Clk_100M or negedge reset_n) begin
        if (!reset_n) begin
            counter <= 0;
        end else begin
            counter <= (counter >= desired) ? 0 : counter + 1;
        end
    end

    assign slow_clk_en = (counter == desired) ? 1'b1 : 1'b0;
endmodule

module my_dff_en(
    input DFF_CLOCK,
    input reset_n,      // Active-low
    input clock_enable,
    input D,
    output reg Q
);
    always @(posedge DFF_CLOCK or negedge reset_n) begin
        if (!reset_n) begin
            Q <= 1'b0;
        end else if (clock_enable) begin
            Q <= D;
        end
    end
endmodule






