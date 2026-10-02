<!---

This file is used to generate your project datasheet. Please fill in the information below and delete any unused
sections.

You can also include images in this folder and reference them in the markdown. Each image must be less than
512 kb in size, and the combined size of all images must be less than 1 MB.
-->

## How it works

This project displays a simple animated hydroponic greenhouse using VGA output.

The image is generated directly in Verilog using the horizontal and vertical pixel coordinates provided by the VGA synchronization module. Different areas of the screen are colored to create the sky, ground, greenhouse structure, water tank, plant, and sun.

A counter is updated on every vertical synchronization pulse (`vsync`). This counter is used to animate the project. As the counter changes, the plant appears to grow and the water level in the tank changes over time.

The design does not use a framebuffer or stored images. Instead, every object is created using simple coordinate comparisons, which keeps the hardware implementation relatively small and suitable for Tiny Tapeout.

## How to test

1. Open the project in the VGA Playground.
2. Run the simulation.
3. Observe the VGA output on the screen.
4. You should see a simple greenhouse scene containing:
   - A blue background representing the sky.
   - A sun.
   - A greenhouse structure.
   - A water tank.
   - A green plant.
5. Wait a few seconds and observe the animation.
6. The plant should gradually change in height, creating a growing effect.
7. The water level in the tank should also change automatically.

To restart the animation, activate the reset input. After the reset is released, the counter starts again from zero and the animation begins again.

## External hardware

List external hardware used in your project (e.g. PMOD, LED display, etc), if any
