
# Auto-generated from Python
# Image: 128x128 RGB8 (32-bit aligned)

set outfile "raw8.bin"

set coeff_r 0x00000050 
set coeff_g 0x00000050 
set coeff_b 0x00000050 

set binary_threshold 120

set mpath [lindex [get_service_paths master] 0]
open_service master $mpath

# CLIPPER
master_write_32 $mpath 0x1000720 1920
master_write_32 $mpath 0x1000724 1080
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
master_write_32 $mpath 0x1000548 128
master_write_32 $mpath 0x100054C 128

# CSC
master_write_32 $mpath 0x1000b20 128
master_write_32 $mpath 0x1000b24 128
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
master_write_32 $mpath 0x1001120 128
master_write_32 $mpath 0x1001124 128
master_write_32 $mpath 0x100114c 0x00000000

set packed_white 0x0000FFFF
set packed_black 0x00000000

for {set i 0} {$i < 256} {incr i} {
    set val [expr ($i < $binary_threshold) ? $packed_black : $packed_white]
    master_write_32 $mpath [expr 0x1001200 + ($i * 4)] $val
    master_write_32 $mpath [expr 0x1001600 + ($i * 4)] $val
    master_write_32 $mpath [expr 0x1001A00 + ($i * 4)] $val
}


# VFW
master_write_32 $mpath 0x1000920 128
master_write_32 $mpath 0x1000924 128
master_write_32 $mpath 0x1000928 0x00000000
master_write_32 $mpath 0x1000930 0x00000000
master_write_32 $mpath 0x1000934 0x00000003
master_write_32 $mpath 0x1000938 0x00000000
master_write_32 $mpath 0x100093C 0x00000003
master_write_32 $mpath 0x100097C 384
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
