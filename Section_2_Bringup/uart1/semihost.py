import pyverilator, subprocess, atexit, functools, serial, time
from typing import List

# cd Section_2_Bringup/uart1; . .venv/bin/activate

# create two linked virtual serial ports
command = "socat -d -d pty,raw,echo=0 pty,raw,echo=0"
process = subprocess.Popen(command.split(' '), stderr=subprocess.PIPE)
atexit.register(functools.partial(lambda x: x.terminate(), process))

# get the serial port names
ports = [process.stderr.readline().decode().split()[-1].strip() for _ in range(2)]
assert all((map(lambda x: '/dev/' in x, ports))), ports

# get terminals, timeout set to 0 to simulate a wire
rx = serial.Serial(ports[0], timeout=0.1) 
tx = serial.Serial(ports[1], timeout=0.1)

# read and write functions

def write_wire(val:bool):
    rx.reset_input_buffer() 
    tx.reset_output_buffer()
    tx.write(str(val).encode())
    tx.flush()

def read_wire():
    return int(rx.read(1).decode())

# testing
for i in range(1000):
    print(i)
    write_wire(i)
    read_wire()

# get bitarray helper
def bit_array(n) -> str:
    ret = []
    for i in range(8):
        v = n & 1<<(7-i)
        ret.append(str(int(bool(v))))
    return ''.join(ret)

# create two uarts
uart_tx = pyverilator.PyVerilator.build('uart.v')
uart_rx = pyverilator.PyVerilator.build('uart.v')

# clock cycle function
def tick():
    write_wire(uart_tx['tx'])
    uart_rx['rx'] = read_wire()
    for u in [uart_tx, uart_rx]:
        u['clk'] = 0
        u['clk'] = 1
    tx = uart_tx['tx']
    write_wire(tx)
    uart_rx['rx'] = read_wire()

# attemp to write a buffer
# lets test it out

uart_tx['wr_en'] = 1
uart_rx['rd_en'] = 1
for bit_num in range(257):
    uart_tx['din'] = bit_num
    while uart_rx['rd_rdy'] == 0:
        tick()
    tick()
    num_rx = int(uart_rx['dout'])
    print(num_rx, bit_num)
    assert num_rx == bit_num