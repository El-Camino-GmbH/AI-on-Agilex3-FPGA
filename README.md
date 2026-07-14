Running a neural network on an FPGA offers key advantages over CPU- or GPU-based solutions: low latency, low power consumption, and direct integration with sensor hardware. This project presents El Camino GmbH’s deployment of a neural network
image classifier on the Altera Agilex 3 FPGA using the ONE WARE Studio toolchain. The design combines an AI engine, a MIPI CSI-2 camera interface, and
a video processing path within a single FPGA fabric. The system classifies images across ten object categories with an accuracy of 97.55 % and a latency of
11 ms at a 50 MHz clock. This project covers the complete workflow, from model training and hardware integration to validation, and provides resource usage
and performance data that confirm the suitability of ONE WARE-based AI on Altera®FPGAs.

<img width="2686" height="1042" alt="Blockdesgin drawio" src="https://github.com/user-attachments/assets/5ffc47bc-db7e-4c8b-bcdd-619b91336063" />
