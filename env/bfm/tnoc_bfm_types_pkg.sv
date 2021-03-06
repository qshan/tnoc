`ifndef TNOC_BFM_TYPES_PKG_SV
`define TNOC_BFM_TYPES_PKG_SV
package tnoc_bfm_types_pkg;
  `include  "tnoc_bfm_macro.svh"

  typedef enum bit [7:0] {
    TNOC_BFM_READ               = 'b001_00000,
    TNOC_BFM_POSTED_WRITE       = 'b010_00000,
    TNOC_BFM_NON_POSTED_WRITE   = 'b011_00000,
    TNOC_BFM_RESPONSE           = 'b100_00000,
    TNOC_BFM_RESPONSE_WITH_DATA = 'b110_00000
  } tnoc_bfm_packet_type;

  typedef bit [`TNOC_BFM_MAX_ID_X_WIDTH-1:0]  tnoc_bfm_id_x;
  typedef bit [`TNOC_BFM_MAX_ID_Y_WIDTH-1:0]  tnoc_bfm_id_y;
  typedef struct packed {
    tnoc_bfm_id_x  x;
    tnoc_bfm_id_y  y;
  } tnoc_bfm_location_id;

  localparam  int TNOC_BFM_VC_WIDTH = (`TNOC_BFM_MAX_VIRTUAL_CHANNELS == 1) ? 1 : $clog2(`TNOC_BFM_MAX_VIRTUAL_CHANNELS);
  typedef bit [TNOC_BFM_VC_WIDTH-1:0] tnoc_bfm_vc;

  localparam  int TNOC_BFM_TAG_WIDTH  = (`TNOC_BFM_MAX_TAGS == 1) ? 1 : $clog2(`TNOC_BFM_MAX_TAGS);
  typedef bit [TNOC_BFM_TAG_WIDTH-1:0]  tnoc_bfm_tag;

  typedef enum bit [1:0] {
    TNOC_BFM_FIXED_BURST        = 'b00,
    TNOC_BFM_INCREMENTING_BURST = 'b01,
    TNOC_BFM_WRAPPING_BURST     = 'b10
  } tnoc_bfm_burst_type;

  localparam  int TNOC_BFM_BURST_LENGTH_WIDTH   = (`TNOC_BFM_MAX_BURST_LENGTH == 1) ? 1 : $clog2(`TNOC_BFM_MAX_BURST_LENGTH);
  typedef bit [TNOC_BFM_BURST_LENGTH_WIDTH-1:0] tnoc_bfm_burst_length;

  localparam  int TNOC_BFM_BURST_SIZE_WIDTH = (
    `TNOC_BFM_MAX_DATA_WIDTH <= 16
  ) ? 1 : $clog2($clog2(`TNOC_BFM_MAX_DATA_WIDTH / 8));
  typedef bit [TNOC_BFM_BURST_SIZE_WIDTH-1:0] tnoc_bfm_burst_size;

  typedef bit [`TNOC_BFM_MAX_ADDRESS_WIDTH-1:0] tnoc_bfm_address;

  typedef enum bit [1:0] {
    TNOC_BFM_OKAY         = 'b00,
    TNOC_BFM_EXOKAY       = 'b01,
    TNOC_BFM_SLAVE_ERROR  = 'b10,
    TNOC_BFM_DECODE_ERROR = 'b11
  } tnoc_bfm_response_status;

  localparam  int TNOC_BFM_COMMON_HEADER_WIDTH  =
    $bits(tnoc_bfm_packet_type ) +
    $bits(tnoc_bfm_location_id ) +
    $bits(tnoc_bfm_location_id ) +
    $bits(tnoc_bfm_vc          ) +
    $bits(tnoc_bfm_tag         ) +
    1;                              //  invalid destination flag
  localparam  int TNOC_BFM_REQUEST_HEADER_WIDTH =
    TNOC_BFM_COMMON_HEADER_WIDTH +
    $bits(tnoc_bfm_burst_type  ) +
    $bits(tnoc_bfm_burst_length) +
    $bits(tnoc_bfm_burst_size  ) +
    $bits(tnoc_bfm_address     );
  localparam  int TNOC_BFM_RESPONSE_HEADER_WIDTH  =
    TNOC_BFM_COMMON_HEADER_WIDTH + $bits(tnoc_bfm_response_status);
  localparam  int TNOC_BFM_HEADER_WIDTH  = (
    TNOC_BFM_REQUEST_HEADER_WIDTH > TNOC_BFM_RESPONSE_HEADER_WIDTH
  ) ? TNOC_BFM_REQUEST_HEADER_WIDTH : TNOC_BFM_RESPONSE_HEADER_WIDTH;

  typedef bit [`TNOC_BFM_MAX_DATA_WIDTH-1:0]    tnoc_bfm_data;
  typedef bit [`TNOC_BFM_MAX_DATA_WIDTH/8-1:0]  tnoc_bfm_byte_enable;
  typedef struct packed {
    tnoc_bfm_data        data;
    tnoc_bfm_byte_enable byte_enable;
  } tnoc_bfm_write_payload;
  typedef struct packed {
    tnoc_bfm_data             data;
    tnoc_bfm_response_status  status;
    bit                       last;
  } tnoc_bfm_read_payload;

  localparam  int TNOC_BFM_PAYLOAD_WIDTH  = (
    $bits(tnoc_bfm_write_payload) >= $bits(tnoc_bfm_read_payload)
  ) ? $bits(tnoc_bfm_write_payload) : $bits(tnoc_bfm_read_payload);

  typedef enum bit {
    TNOC_BFM_HEADER_FLIT,
    TNOC_BFM_PAYLOAD_FLIT
  } tnoc_bfm_flit_type;

  localparam  int TNOC_FLIT_DATA_WIDTH = (
    TNOC_BFM_COMMON_HEADER_WIDTH > TNOC_BFM_PAYLOAD_WIDTH
  ) ? TNOC_BFM_COMMON_HEADER_WIDTH : TNOC_BFM_PAYLOAD_WIDTH;

  typedef bit [TNOC_FLIT_DATA_WIDTH-1:0]  tnoc_bfm_flit_data;

  typedef struct packed {
    tnoc_bfm_flit_data  data;
    bit                 tail;
    bit                 head;
    tnoc_bfm_flit_type  flit_type;
  } tnoc_bfm_flit;
endpackage
`endif
