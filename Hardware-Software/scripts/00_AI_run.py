import subprocess
import numpy as np
import matplotlib.pyplot as plt
from matplotlib.widgets import Slider
import os
import time
import re

# =========================
# Configuration
# =========================

THRESHOLD = 120

# Brightness scaling of Threshold 0-255
# high brightness:          230
# medium brightness:        175
# low-medium brightness:    150
# low brightness:           20

IMAGE_WIDTH  = 1920
IMAGE_HEIGHT = 1080

WIDTH  = 128
HEIGHT = 128
BYTES_PER_PIXEL = 3

RAW_FILENAME = "raw8.bin"

SYSTEM_CONSOLE_PATH = r"C:\altera_pro\25.3\syscon\bin\system-console.exe"

DIGIT_LABELS = [

    'Banana', 'El Camino', 'Car', 'Carrot', 'Castle', 'Cruise ship', 'Flower', 'Lightning', 'Traffic light', 'Umbrella'

]

# Hardware Memory Map
ADDR_FRAME_BUFFER     = "0x00080000"
ADDR_AI_RESULTS_START = "0x00070010"
ADDR_CONTROL_REG      = "0x00070080"
ADDR_AI_CONTROL_READY = "0x00070000"

# Interrupt/Status registers
ADDR_VFW_IRQ_ACK   = "0x1000968"
ADDR_VFW_IRQ_CLEAR = "0x1000904"

# Derived
READ_SIZE_BYTES = WIDTH * HEIGHT * BYTES_PER_PIXEL
inter_line_offset = WIDTH * BYTES_PER_PIXEL

script_dir        = os.path.dirname(os.path.abspath(__file__))
tcl_script_path   = os.path.join(script_dir, "image_config.tcl")

# =========================
# SYSTEM CONFIGURATION TCL
# =========================
def initialize_tcl_script():
    tcl_script = f"""
# Auto-generated from Python
# Image: {WIDTH}x{HEIGHT} RGB8 (32-bit aligned)

set outfile "{os.path.join(script_dir, RAW_FILENAME).replace('\\', '/')}"

set coeff_r 0x00000050 
set coeff_g 0x00000050 
set coeff_b 0x00000050 

set binary_threshold {THRESHOLD}

set mpath [lindex [get_service_paths master] 0]
open_service master $mpath

# CLIPPER
master_write_32 $mpath 0x1000720 {IMAGE_WIDTH}
master_write_32 $mpath 0x1000724 {IMAGE_HEIGHT}
master_write_32 $mpath 0x1000728 0x00000000
master_write_32 $mpath 0x1000730 0x00000000
master_write_32 $mpath 0x1000734 0x00000003
master_write_32 $mpath 0x1000738 0x00000000
master_write_32 $mpath 0x1000748 420
master_write_32 $mpath 0x1000750 420
master_write_32 $mpath 0x1000744 0x00000001

# DEMOSAIC
master_write_32 $mpath 0x1000320 1920
master_write_32 $mpath 0x1000324 1080
master_write_32 $mpath 0x100034c 0x00000000

# SCALER
master_write_32 $mpath 0x1000520 1080
master_write_32 $mpath 0x1000524 1080
master_write_32 $mpath 0x1000548 {WIDTH}
master_write_32 $mpath 0x100054C {HEIGHT}

# CSC
master_write_32 $mpath 0x1000b20 {WIDTH}
master_write_32 $mpath 0x1000b24 {HEIGHT}
master_write_32 $mpath 0x1000b28 0x00000000
master_write_32 $mpath 0x1000b30 0x00000000
master_write_32 $mpath 0x1000b34 0x00000000
master_write_32 $mpath 0x1000b38 0x00000000
master_write_32 $mpath 0x1000b48 $coeff_r
master_write_32 $mpath 0x1000b4C $coeff_g
master_write_32 $mpath 0x1000b50 $coeff_b
master_write_32 $mpath 0x1000b54 $coeff_r
master_write_32 $mpath 0x1000b58 $coeff_g
master_write_32 $mpath 0x1000b5C $coeff_b
master_write_32 $mpath 0x1000b60 $coeff_r
master_write_32 $mpath 0x1000b64 $coeff_g
master_write_32 $mpath 0x1000b68 $coeff_b
master_write_32 $mpath 0x1000b6C 0x00000000
master_write_32 $mpath 0x1000b70 0x00000000
master_write_32 $mpath 0x1000b74 0x00000000
master_write_32 $mpath 0x1000b44 0x00000001

# LUT
master_write_32 $mpath 0x1001120 {WIDTH}
master_write_32 $mpath 0x1001124 {HEIGHT}
master_write_32 $mpath 0x100114c 0x00000000

set packed_white 0x0000FFFF
set packed_black 0x00000000

for {{set i 0}} {{$i < 256}} {{incr i}} {{
    set val [expr ($i < $binary_threshold) ? $packed_black : $packed_white]
    master_write_32 $mpath [expr 0x1001200 + ($i * 4)] $val
    master_write_32 $mpath [expr 0x1001600 + ($i * 4)] $val
    master_write_32 $mpath [expr 0x1001A00 + ($i * 4)] $val
}}


# VFW
master_write_32 $mpath 0x1000920 {WIDTH}
master_write_32 $mpath 0x1000924 {HEIGHT}
master_write_32 $mpath 0x1000928 0x00000000
master_write_32 $mpath 0x1000930 0x00000000
master_write_32 $mpath 0x1000934 0x00000003
master_write_32 $mpath 0x1000938 0x00000000
master_write_32 $mpath 0x100093C 0x00000003
master_write_32 $mpath 0x100097C {inter_line_offset}
master_write_32 $mpath 0x1000974 0x00080000
master_write_32 $mpath 0x1000970 0x00000001

#master_write_32 $mpath 0x1000968 0x00000001
#master_write_32 $mpath 0x100096C 0x00000003
#master_write_32 $mpath 0x1000964 0x00000001

#after 500

# Enable field_write IRQ and arm VFW in single-shot mode
master_write_32 $mpath 0x1000900 0x00000001
master_write_32 $mpath 0x1000968 0x00000001
master_write_32 $mpath 0x100096C 0x00000003
master_write_32 $mpath 0x1000964 0x00000001

puts "INIT_DONE"
"""
    with open(tcl_script_path, "w") as f:
        f.write(tcl_script)
    print("TCL configuration script written.")
    print(f"Expected frame size: {READ_SIZE_BYTES} bytes")


def run_system_console_init():
    """Run System Console once with the init TCL script (blocking)."""
    if not os.path.exists(SYSTEM_CONSOLE_PATH):
        raise FileNotFoundError(f"system-console.exe not found at {SYSTEM_CONSOLE_PATH}")

    print("Running system initialisation via System Console...")
    result = subprocess.run(
        [
            SYSTEM_CONSOLE_PATH,
            "--cli",
            "--disable_readline",
            "--script", tcl_script_path
        ],
        capture_output=True,
        text=True
    )

    print("===== SYSTEM CONSOLE STDOUT =====")
    print(result.stdout)

    if result.returncode != 0:
        print("===== SYSTEM CONSOLE STDERR =====")
        print(result.stderr)
        raise RuntimeError("System Console initialisation failed.")

    print("System initialisation complete.\n")


# =========================
# INTERACTIVE SESSION
# =========================
class SystemConsoleSession:
    def __init__(self):
        if not os.path.exists(SYSTEM_CONSOLE_PATH):
            raise FileNotFoundError(f"System Console not found at {SYSTEM_CONSOLE_PATH}")

        self.proc = subprocess.Popen(
            [SYSTEM_CONSOLE_PATH, "--cli"],
            stdin=subprocess.PIPE,
            stdout=subprocess.PIPE,
            stderr=subprocess.PIPE,
            text=True,
            bufsize=1,
            universal_newlines=True,
            creationflags=subprocess.CREATE_NO_WINDOW if os.name == 'nt' else 0
        )
        time.sleep(3)
        self.last_focus_val = 0
        self.send_command("set mpath [lindex [get_service_paths master] 0]")
        self.send_command("open_service master $mpath")

    def send_command(self, cmd):
        self.proc.stdin.write(cmd + "\n")
        self.proc.stdin.flush()

    def capture_and_reset_irq(self, num_classes):
        tcl_cmd = f"""
        # --- Capture Image Data ---
        master_read_to_file $mpath "{RAW_FILENAME.replace('\\', '/')}" {ADDR_FRAME_BUFFER} {READ_SIZE_BYTES}

        # --- Capture AI Results ---
        master_write_32 $mpath {ADDR_CONTROL_REG} 0x00000000

        set results {{}}
        for {{set i 0}} {{$i < {num_classes}}} {{incr i}} {{
            lappend results [master_read_32 $mpath {ADDR_AI_RESULTS_START} 1]
        }}
        puts "AI_RESULTS $results"


        # --- Reset IRQ and re-arm VFW single-shot ---
        master_write_32 $mpath {ADDR_VFW_IRQ_ACK}   0x00000001  ;# BUFFER_ACKNOWLEDGE
        master_write_32 $mpath {ADDR_VFW_IRQ_CLEAR} 0x01        ;# Clear IRQ_STATUS
        master_write_32 $mpath 0x100096C            0x00000003  ;# RUN = single-shot
        master_write_32 $mpath 0x1000964            0x00000001  ;# COMMIT


        #master_read_32 $mpath {ADDR_AI_CONTROL_READY} 1
        
        puts "DONE_SIGNAL"
        """
        self.send_command(tcl_cmd)

        output = ""
        while True:
            line = self.proc.stdout.readline()
            output += line
            if "DONE_SIGNAL" in line:
                break
        return output
    


    def set_camera_focus(self, focus_val):
        focus_val = int(focus_val)
        self.last_focus_val = focus_val
        
        # KEY[1] is Bit 25 (0x02000000)
        # We need a falling edge to move ST from 1 to 80
        
        tcl_cmd = f"""
            # 1. Set KEY[1] HIGH with the data
            master_write_32 $mpath 0x0000000 [expr 0x02000000 | {focus_val}] ;
            
            # 2. Set KEY[1] LOW (Falling edge) to trigger State 80
            master_write_32 $mpath 0x0000000 {focus_val} ;
        """
        self.send_command(tcl_cmd)

    def end_camera_focus(self, event=None):
        """Park motor when mouse released"""
        # VCM_END (Bit 16) + Last Position
        end_val = 0x00010000 | (self.last_focus_val & 0xFFFF)
        self.send_command(f"after 10; master_write_32 $mpath 0x0000000 {hex(end_val)}")
        print(f"Focus Fixed at: {self.last_focus_val}")

    def on_slider_move(self, val):
        """Callback for Matplotlib Slider"""
        # val is already 0-65535 from the slider definition
        self.set_camera_focus(val)




    def wait_for_ready(self):
        tcl_cmd = f"""
            set val [master_read_32 $mpath {ADDR_AI_CONTROL_READY} 1]
            puts "READY_VALUE $val"
            puts "DONE_SIGNAL"
        """
        self.send_command(tcl_cmd)

        output = ""
        while True:
            line = self.proc.stdout.readline()
            output += line
            if "DONE_SIGNAL" in line:
                break
        return output

    def poll_until_ready(self):
        while True:
            output = self.wait_for_ready()
            match = re.search(r"READY_VALUE\s+(0x[0-9a-fA-F]+)", output)

            if match and int(match.group(1), 16) == 1:
                return
            

    def close(self):
        self.send_command("close_service master $mpath")
        self.proc.terminate()


# =========================
# MAIN
# =========================
def main():
    # --- hardware initialisation ---
    initialize_tcl_script()
    run_system_console_init()
    time.sleep(1)

    # --- Start capture loop ---
    print(f"Starting capture loop with {len(DIGIT_LABELS)} classes...")
    sc = SystemConsoleSession()

    plt.ion()
    fig, ax = plt.subplots(figsize=(12, 7))
    plt.subplots_adjust(bottom=0.25)

    ax_slider = plt.axes([0.2, 0.1, 0.6, 0.03]) # [left, bottom, width, height]
    focus_slider = Slider(
        ax_slider, 'Focus', 0, 4095, 
        valinit=1000, valstep=1, color="teal"
    )

    focus_slider.on_changed(sc.on_slider_move)

    def handle_release(event):
        sc.end_camera_focus()

    fig.canvas.mpl_connect('button_release_event', handle_release)

    


    try:
        while True:
            start_time = time.time()

            console_output = sc.capture_and_reset_irq(len(DIGIT_LABELS))

            sc.poll_until_ready()

            # Parse AI results
            ai_values = []
            match = re.search(r"AI_RESULTS\s+\{?(.*?)\}?\n", console_output)
            if match:
                raw_list = match.group(1).replace('{', '').replace('}', '').split()
                ai_values = [int(v, 0) for v in raw_list]

            # Process and display image
            if os.path.exists(RAW_FILENAME):
                try:
                    raw_bytes = np.fromfile(RAW_FILENAME, dtype=np.uint8)
                    if len(raw_bytes) >= READ_SIZE_BYTES:
                        rgb = raw_bytes[:READ_SIZE_BYTES].reshape((HEIGHT, WIDTH, 3))
                        rgb = rgb.astype(np.float32) / 255.0

                        ax.clear()
                        ax.imshow(rgb)
                        ax.axis("off")

                        if len(ai_values) == len(DIGIT_LABELS):
                            if all(v == 0 for v in ai_values):
                                ax.set_title("Detection: No image", fontsize=14)
                            else:
                                max_idx = np.argmax(ai_values)
                                detected = DIGIT_LABELS[max_idx]
                                scaled_values = [round(v / 127 * 100) for v in ai_values]
                                title_str = f"Detection: {detected}\n"
                                results_str = " | ".join(
                                    [f"{DIGIT_LABELS[i]}:{scaled_values[i]}%" for i, v in enumerate(ai_values) if v > 0]
                                )
                                ax.set_title(title_str + results_str, fontsize=14)
                        else:
                            ax.set_title("Detection: No image", fontsize=14)

                        plt.draw()
                        plt.pause(0.01)
                except Exception as e:
                    print(f"Frame processing error: {e}")

            elapsed = time.time() - start_time
            time.sleep(max(0.01, 0.1 - elapsed))

    except KeyboardInterrupt:
        print("\nStopping...")
    finally:
        sc.close()
        plt.close()


if __name__ == "__main__":
    main()