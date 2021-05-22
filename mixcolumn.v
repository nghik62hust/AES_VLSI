module mixcolumn(
  input        [127:0] a,
  output  reg  [127:0] mc1
);

function  [7:0] mul_2;
  input [7:0] a;
  begin
  mul_2 = (a[7] == 1) ? ((a << 1) ^ 8'b00011011) : (a << 1);
  end
endfunction

function reg [7:0] mul_3 (input [7:0] a);
  mul_3=a ^ mul_2(a);
endfunction

function reg [31:0] matrix_mul_word (input [31:0] a);
  begin
  matrix_mul_word[31:24] = mul_2(a[31:24]) ^ mul_3(a[23:16]) ^       a[15:8]  ^       a[7:0]  ;
  matrix_mul_word[23:16] =       a[31:24]  ^ mul_2(a[23:16]) ^ mul_3(a[15:8]) ^       a[7:0]  ;
  matrix_mul_word[15:8]  =       a[31:24]  ^       a[23:16]  ^ mul_2(a[15:8]) ^ mul_3(a[7:0]) ;
  matrix_mul_word[7:0]   = mul_3(a[31:24]) ^       a[23:16]  ^       a[15:8]  ^ mul_2(a[7:0]) ;
  end
endfunction

always @*
begin
  mc1[127:96] = matrix_mul_word(a[127:96]);
  mc1[95:64]  = matrix_mul_word(a[95:64] );
  mc1[63:32]  = matrix_mul_word(a[63:32] );
  mc1[31:0]   = matrix_mul_word(a[31:0]  );
end

endmodule
