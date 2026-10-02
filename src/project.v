/*
 * Mini invernadero hidropónico VGA
 * Basado en el ejemplo de Tiny Tapeout
 */

`default_nettype none

module tt_um_vga_example(
  input  wire [7:0] ui_in,
  output wire [7:0] uo_out,
  input  wire [7:0] uio_in,
  output wire [7:0] uio_out,
  output wire [7:0] uio_oe,
  input  wire       ena,
  input  wire       clk,
  input  wire       rst_n
);

  // ------------------------------------------------------------
  // Señales VGA
  // ------------------------------------------------------------

  wire hsync;
  wire vsync;
  reg  [1:0] R;
  reg  [1:0] G;
  reg  [1:0] B;

  wire video_active;
  wire [9:0] pix_x;
  wire [9:0] pix_y;

  // TinyVGA PMOD
  assign uo_out = {
    hsync,
    B[0],
    G[0],
    R[0],
    vsync,
    B[1],
    G[1],
    R[1]
  };

  // IO no utilizados
  assign uio_out = 0;
  assign uio_oe  = 0;

  // ------------------------------------------------------------
  // Generador VGA
  // ------------------------------------------------------------

  hvsync_generator hvsync_gen(
    .clk(clk),
    .reset(~rst_n),
    .hsync(hsync),
    .vsync(vsync),
    .display_on(video_active),
    .hpos(pix_x),
    .vpos(pix_y)
  );

  // ------------------------------------------------------------
  // Animación
  // ------------------------------------------------------------

  reg [9:0] counter;

  always @(posedge vsync or negedge rst_n) begin
    if (~rst_n)
      counter <= 0;
    else
      counter <= counter + 2;
  end

  // Valor de crecimiento entre 0 y 31 píxeles aproximadamente
  wire [4:0] growth;

  assign growth = counter[7:3];

  // Nivel de agua animado
  wire [3:0] water_animation;

  assign water_animation = counter[7:4];

  // ------------------------------------------------------------
  // Dibujar pantalla
  // ------------------------------------------------------------

  always @(*) begin

    // Fondo negro por defecto
    R = 2'b00;
    G = 2'b00;
    B = 2'b00;

    if (video_active) begin

      // --------------------------------------------------------
      // CIELO
      // --------------------------------------------------------

      R = 2'b00;
      G = 2'b10;
      B = 2'b11;


      // --------------------------------------------------------
      // SUELO
      // --------------------------------------------------------

      if (pix_y > 400) begin

        R = 2'b01;
        G = 2'b01;
        B = 2'b00;

      end


      // --------------------------------------------------------
      // SOL
      // --------------------------------------------------------

      if (
        pix_x > 500 &&
        pix_x < 550 &&
        pix_y > 50 &&
        pix_y < 100
      ) begin

        R = 2'b11;
        G = 2'b11;
        B = 2'b00;

      end


      // --------------------------------------------------------
      // ESTRUCTURA DEL INVERNADERO
      // --------------------------------------------------------

      // Columna izquierda
      if (
        pix_x > 100 &&
        pix_x < 108 &&
        pix_y > 130 &&
        pix_y < 400
      ) begin

        R = 2'b11;
        G = 2'b11;
        B = 2'b11;

      end


      // Columna derecha
      if (
        pix_x > 530 &&
        pix_x < 538 &&
        pix_y > 130 &&
        pix_y < 400
      ) begin

        R = 2'b11;
        G = 2'b11;
        B = 2'b11;

      end


      // Techo
      if (
        pix_x > 100 &&
        pix_x < 538 &&
        pix_y > 130 &&
        pix_y < 138
      ) begin

        R = 2'b11;
        G = 2'b11;
        B = 2'b11;

      end


      // --------------------------------------------------------
      // TANQUE HIDROPÓNICO
      // --------------------------------------------------------

      if (
        pix_x > 200 &&
        pix_x < 440 &&
        pix_y > 330 &&
        pix_y < 400
      ) begin

        // Contorno gris

        R = 2'b10;
        G = 2'b10;
        B = 2'b10;

      end


      // --------------------------------------------------------
      // AGUA DEL TANQUE
      // --------------------------------------------------------

      if (
        pix_x > 208 &&
        pix_x < 432 &&
        pix_y > (350 + water_animation) &&
        pix_y < 392
      ) begin

        // Azul

        R = 2'b00;
        G = 2'b10;
        B = 2'b11;

      end


      // --------------------------------------------------------
      // TALLO DE LA PLANTA
      // --------------------------------------------------------

      if (
        pix_x > 316 &&
        pix_x < 324 &&
        pix_y > (240 - growth) &&
        pix_y < 350
      ) begin

        // Verde

        R = 2'b00;
        G = 2'b11;
        B = 2'b00;

      end


      // --------------------------------------------------------
      // HOJA IZQUIERDA
      // --------------------------------------------------------

      if (
        pix_x > 285 &&
        pix_x < 320 &&
        pix_y > (260 - growth) &&
        pix_y < (280 - growth)
      ) begin

        R = 2'b00;
        G = 2'b11;
        B = 2'b00;

      end


      // --------------------------------------------------------
      // HOJA DERECHA
      // --------------------------------------------------------

      if (
        pix_x > 320 &&
        pix_x < 355 &&
        pix_y > (230 - growth) &&
        pix_y < (250 - growth)
      ) begin

        R = 2'b00;
        G = 2'b11;
        B = 2'b00;

      end

    end
  end


  // Evitar warnings por entradas no usadas
  wire _unused_ok = &{
    ena,
    ui_in,
    uio_in
  };

endmodule