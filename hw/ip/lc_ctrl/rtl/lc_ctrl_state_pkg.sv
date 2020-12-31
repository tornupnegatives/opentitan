// Copyright lowRISC contributors.
// Licensed under the Apache License, Version 2.0, see LICENSE for details.
// SPDX-License-Identifier: Apache-2.0
//
// Life cycle state encoding definition.
//
// DO NOT EDIT THIS FILE DIRECTLY.
// It has been generated with
// $ cd hw/ip/otp_ctrl/util/ && .gen-lc-state-enc.py --seed 10167336684108184581
//
package lc_ctrl_state_pkg;

  // These values have been generated such that they are incrementally writeable with respect
  // to the ECC polynomial specified. The values are used to define the life cycle manufacturing
  // state and transition counter encoding in lc_ctrl_pkg.sv.
  //
  // The values are unique and have the following statistics (considering all 16
  // data and 6 ECC bits):
  //
  // - Minimum Hamming weight: 8
  // - Maximum Hamming weight: 16
  // - Minimum Hamming distance from any other value: 6
  // - Maximum Hamming distance from any other value: 18
  //
  // Hamming distance histogram:
  //
  //  0: --
  //  1: --
  //  2: --
  //  3: --
  //  4: --
  //  5: --
  //  6: |||| (6.29%)
  //  7: --
  //  8: ||||||||||| (17.48%)
  //  9: --
  // 10: ||||||||||||||||||| (29.34%)
  // 11: --
  // 12: |||||||||||||||||||| (30.73%)
  // 13: --
  // 14: ||||||| (12.28%)
  // 15: --
  // 16: || (3.45%)
  // 17: --
  // 18:  (0.42%)
  // 19: --
  // 20: --
  // 21: --
  // 22: --
  //
  //
  // Note that the ECC bits are not defined in this package as they will be calculated by
  // the OTP ECC logic at runtime.

  // The A/B values are used for the encoded LC state.
  parameter logic [15:0] A0 = 16'b1011000010101001; // ECC: 6'b100101
  parameter logic [15:0] B0 = 16'b1111110010111101; // ECC: 6'b101101

  parameter logic [15:0] A1 = 16'b1110001110001001; // ECC: 6'b110000
  parameter logic [15:0] B1 = 16'b1111011110001101; // ECC: 6'b110111

  parameter logic [15:0] A2 = 16'b0111110000011000; // ECC: 6'b111000
  parameter logic [15:0] B2 = 16'b0111110100111111; // ECC: 6'b111010

  parameter logic [15:0] A3 = 16'b0001001011001110; // ECC: 6'b100000
  parameter logic [15:0] B3 = 16'b1001111011111111; // ECC: 6'b100011

  parameter logic [15:0] A4 = 16'b0011010100001010; // ECC: 6'b100111
  parameter logic [15:0] B4 = 16'b0011110111101110; // ECC: 6'b110111

  parameter logic [15:0] A5 = 16'b0110011111110000; // ECC: 6'b100000
  parameter logic [15:0] B5 = 16'b1110111111111011; // ECC: 6'b100010

  parameter logic [15:0] A6 = 16'b1101000101000100; // ECC: 6'b110000
  parameter logic [15:0] B6 = 16'b1111010101000111; // ECC: 6'b110101

  parameter logic [15:0] A7 = 16'b0011000110001100; // ECC: 6'b000011
  parameter logic [15:0] B7 = 16'b0111101111101101; // ECC: 6'b100111

  parameter logic [15:0] A8 = 16'b0001110110100001; // ECC: 6'b100101
  parameter logic [15:0] B8 = 16'b0011111110100111; // ECC: 6'b101111

  parameter logic [15:0] A9 = 16'b0100111010001011; // ECC: 6'b100001
  parameter logic [15:0] B9 = 16'b0100111010011111; // ECC: 6'b111111

  parameter logic [15:0] A10 = 16'b1111101100011000; // ECC: 6'b000010
  parameter logic [15:0] B10 = 16'b1111101101011011; // ECC: 6'b111010

  parameter logic [15:0] A11 = 16'b0010101011110100; // ECC: 6'b001001
  parameter logic [15:0] B11 = 16'b0011111111111100; // ECC: 6'b101101


  // The C/D values are used for the encoded LC transition counter.
  parameter logic [15:0] C0 = 16'b0101011000001101; // ECC: 6'b100011
  parameter logic [15:0] D0 = 16'b0101111001101101; // ECC: 6'b111111

  parameter logic [15:0] C1 = 16'b1001111011000010; // ECC: 6'b010001
  parameter logic [15:0] D1 = 16'b1101111011001110; // ECC: 6'b011111

  parameter logic [15:0] C2 = 16'b1000010011010011; // ECC: 6'b100110
  parameter logic [15:0] D2 = 16'b1100110011110111; // ECC: 6'b111110

  parameter logic [15:0] C3 = 16'b1010010010000011; // ECC: 6'b011000
  parameter logic [15:0] D3 = 16'b1010011111001111; // ECC: 6'b011100

  parameter logic [15:0] C4 = 16'b0110010000011011; // ECC: 6'b010101
  parameter logic [15:0] D4 = 16'b0111011101011111; // ECC: 6'b010111

  parameter logic [15:0] C5 = 16'b1000010010001100; // ECC: 6'b011100
  parameter logic [15:0] D5 = 16'b1000111011101110; // ECC: 6'b111100

  parameter logic [15:0] C6 = 16'b1010010001100101; // ECC: 6'b011100
  parameter logic [15:0] D6 = 16'b1111011101110101; // ECC: 6'b111100

  parameter logic [15:0] C7 = 16'b1010100011011001; // ECC: 6'b000101
  parameter logic [15:0] D7 = 16'b1010110111011101; // ECC: 6'b011111

  parameter logic [15:0] C8 = 16'b0010111110000000; // ECC: 6'b110000
  parameter logic [15:0] D8 = 16'b1011111110101100; // ECC: 6'b110100

  parameter logic [15:0] C9 = 16'b0001000111001110; // ECC: 6'b010110
  parameter logic [15:0] D9 = 16'b1111000111011111; // ECC: 6'b011110

  parameter logic [15:0] C10 = 16'b1100001000110001; // ECC: 6'b100100
  parameter logic [15:0] D10 = 16'b1110101000111001; // ECC: 6'b101111

  parameter logic [15:0] C11 = 16'b0000010000110110; // ECC: 6'b100101
  parameter logic [15:0] D11 = 16'b1010111010110111; // ECC: 6'b111101

  parameter logic [15:0] C12 = 16'b1100100001010000; // ECC: 6'b101010
  parameter logic [15:0] D12 = 16'b1110101011010101; // ECC: 6'b111010

  parameter logic [15:0] C13 = 16'b0100011110001101; // ECC: 6'b001010
  parameter logic [15:0] D13 = 16'b0111011111011101; // ECC: 6'b101110

  parameter logic [15:0] C14 = 16'b0100011101010000; // ECC: 6'b001001
  parameter logic [15:0] D14 = 16'b1100011101111000; // ECC: 6'b101111

  parameter logic [15:0] C15 = 16'b0110010111000100; // ECC: 6'b011100
  parameter logic [15:0] D15 = 16'b1111110111010110; // ECC: 6'b011101


  // The E/F values are used for the encoded ID state.
  parameter logic [15:0] E0 = 16'b1111010010011100; // ECC: 6'b000100
  parameter logic [15:0] F0 = 16'b1111011110111110; // ECC: 6'b101100


endpackage : lc_ctrl_state_pkg
