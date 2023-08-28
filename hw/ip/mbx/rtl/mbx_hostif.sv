// Copyright lowRISC contributors.
// Licensed under the Apache License, Version 2.0, see LICENSE for details.
// SPDX-License-Identifier: Apache-2.0

module mbx_hostif
  import mbx_reg_pkg::*;
#(
    parameter logic [NumAlerts-1:0] AlertAsyncOn = {NumAlerts{1'b1}},
    parameter int unsigned CfgSramAddrWidth      = 32
) (
  input  logic                        clk_i,
  input  logic                        rst_ni,
  // Device port to the host side
  input  tlul_pkg::tl_h2d_t           tl_host_i,
  output tlul_pkg::tl_d2h_t           tl_host_o,
  // Generated interrupt event
  input  logic                        event_intr_i,
  output logic                        irq_o,
  // External errors
  input  logic                        intg_err_i,
  // Alerts
  input  prim_alert_pkg::alert_rx_t [NumAlerts-1:0] alert_rx_i,
  output prim_alert_pkg::alert_tx_t [NumAlerts-1:0] alert_tx_o,
  // Access to the control register
  output logic                        hostif_control_abort_set_o,
  // Access to the status register
  output logic                        hostif_status_busy_clear_o,
  output logic                        hostif_status_doe_intr_status_set_o,
  output logic                        hostif_status_error_set_o,
  output logic                        hostif_status_error_clear_o,
  output logic                        hostif_status_async_msg_status_set_o,
  input  logic                        hostif_status_busy_i,
  input  logic                        hostif_status_doe_intr_status_i,
  input  logic                        hostif_status_error_i,
  input  logic                        hostif_status_async_msg_status_i,
  input  logic                        hostif_status_ready_i,
  // Access to the IB/OB RD/WR pointers
  input  logic [CfgSramAddrWidth-1:0] hostif_ib_write_ptr_i,
  input  logic [CfgSramAddrWidth-1:0] hostif_ob_read_ptr_i,
  // Base/Limit for in/outbound mailbox
  output logic                        hostif_address_range_valid_o,
  output logic [CfgSramAddrWidth-1:0] hostif_ib_base_o,
  output logic [CfgSramAddrWidth-1:0] hostif_ib_limit_o,
  output logic [CfgSramAddrWidth-1:0] hostif_ob_base_o,
  output logic [CfgSramAddrWidth-1:0] hostif_ob_limit_o,
  // Read/Write access for the OB DW Count register
  output logic                        hostif_write_ob_object_size_o,
  output logic [10:0]                 hostif_ob_object_size_o,
  input  logic [10:0]                 hostif_ob_object_size_i,
  input  logic                        hostif_read_ob_object_size_i,
  // Control inputs coming from the system registers interface
  input  logic                        sysif_write_control_abort_i
);
  mbx_reg_pkg::mbx_host_reg2hw_t reg2hw;
  mbx_reg_pkg::mbx_host_hw2reg_t hw2reg;

  // Alerts
  logic tlul_intg_err;
  logic [NumAlerts-1:0] alert_test, alerts;
  assign alert_test = {reg2hw.alert_test.q & reg2hw.alert_test.qe};
  assign alerts[0]  = tlul_intg_err | intg_err_i;

  for (genvar i = 0; i < NumAlerts; i++) begin : gen_alert_tx
    prim_alert_sender #(
      .AsyncOn ( AlertAsyncOn[i] ),
      .IsFatal ( 1'b1            )
    ) u_prim_alert_sender (
    .clk_i          ( clk_i         ),
    .rst_ni         ( rst_ni        ),
      .alert_test_i ( alert_test[i] ),
      .alert_req_i  ( alerts[i]     ),
      .alert_ack_o  (               ),
      .alert_state_o(               ),
      .alert_rx_i   ( alert_rx_i[i] ),
      .alert_tx_o   ( alert_tx_o[i] )
    );
  end

  // SEC_CM: BUS.INTEGRITY
  mbx_host_reg_top u_regs(
    .clk_i      ( clk_i         ),
    .rst_ni     ( rst_ni        ),
    .tl_i       ( tl_host_i     ),
    .tl_o       ( tl_host_o     ),
    .reg2hw     ( reg2hw        ),
    .hw2reg     ( hw2reg        ),
    .intg_err_o ( tlul_intg_err ),
    .devmode_i  ( 1'b1          )
  );

  // instantiate interrupt hardware primitive
  prim_intr_hw #(.Width(1)) u_intr_hw (
    .clk_i                  ( clk_i                ),
    .rst_ni                 ( rst_ni               ),
    .event_intr_i           ( event_intr_i         ),
    .reg2hw_intr_enable_q_i ( reg2hw.intr_enable.q ),
    .reg2hw_intr_test_q_i   ( reg2hw.intr_test.q   ),
    .reg2hw_intr_test_qe_i  ( reg2hw.intr_test.qe  ),
    .reg2hw_intr_state_q_i  ( reg2hw.intr_state.q  ),
    .hw2reg_intr_state_de_o ( hw2reg.intr_state.de ),
    .hw2reg_intr_state_d_o  ( hw2reg.intr_state.d  ),
    .intr_o                 ( irq_o                )
  );

  // Control Register
  // External read logic
  logic abort_d, abort_q;
  assign  hw2reg.control.abort.d = abort_q;
  // External write logic
  assign hostif_control_abort_set_o = reg2hw.control.abort.qe & reg2hw.control.abort.q;

  // Abort computation from system and host interface
  always_comb begin
    abort_d = abort_q;

    if (sysif_write_control_abort_i) begin
      abort_d = 1'b1;
    end else if (hostif_control_abort_set_o) begin
      abort_d = 1'b0;
    end
  end

  prim_flop #(
    .Width(1)
  ) u_abort (
    .clk_i ( clk_i   ),
    .rst_ni( rst_ni  ),
    .d_i   ( abort_d ),
    .q_o   ( abort_q )
  );

  // Status Register
  // It is implemented as hwext and implemented in a different hierarchy and only providing an
  // alias. Thus manually assigning the external signals

  // External read logic
  assign hw2reg.status.busy.d             = hostif_status_busy_i;
  assign hw2reg.status.doe_intr_status.d  = hostif_status_doe_intr_status_i;
  assign hw2reg.status.error.d            = hostif_status_error_i;
  assign hw2reg.status.async_msg_status.d = hostif_status_async_msg_status_i;
  assign hw2reg.status.ready.d            = hostif_status_ready_i;
  // External write logic
  assign hostif_status_busy_clear_o           = reg2hw.status.busy.qe  & ~reg2hw.status.busy.q;
  assign hostif_status_doe_intr_status_set_o  = reg2hw.status.doe_intr_status.qe &
                                                reg2hw.status.doe_intr_status.q;
  assign hostif_status_error_set_o            = reg2hw.status.error.qe &  reg2hw.status.error.q;
  assign hostif_status_error_clear_o          = reg2hw.status.error.qe & ~reg2hw.status.error.q;
  assign hostif_status_async_msg_status_set_o =
    reg2hw.status.async_msg_status.qe & reg2hw.status.async_msg_status.q;

  // Address config valid
  assign hostif_address_range_valid_o = reg2hw.address_range_valid.q;

  // Inbound Mailbox Base/Limit Register
  assign  hostif_ib_base_o  = { reg2hw.inbound_base_address.q, {2{1'b0}} };
  assign  hostif_ib_limit_o = { reg2hw.inbound_limit_address.q, {2{1'b0}} };

  // Outbound Mailbox Base/Limit Register
  assign  hostif_ob_base_o  = { reg2hw.outbound_base_address.q, {2{1'b0}} };
  assign  hostif_ob_limit_o = { reg2hw.outbound_limit_address.q, {2{1'b0}} };

  // Read/Write pointers
  assign  hw2reg.inbound_write_ptr.d  = hostif_ib_write_ptr_i[CfgSramAddrWidth-1:2];
  assign  hw2reg.outbound_read_ptr.d  = hostif_ob_read_ptr_i[CfgSramAddrWidth-1:2];

  // Outbound object size Register
  // External read logic
  assign  hw2reg.outbound_object_size.d   = hostif_ob_object_size_i;
  assign  hw2reg.outbound_object_size.de  = hostif_read_ob_object_size_i;
  // External write logic
  assign  hostif_write_ob_object_size_o = reg2hw.outbound_object_size.qe;
  assign  hostif_ob_object_size_o       = reg2hw.outbound_object_size.q;
endmodule
