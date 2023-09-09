# Prompt (I feel like an LLM)

So about those transistors -- Course overview. Describe how FPGAs are buildable using transistors, and that ICs are just collections of transistors in a nice reliable package. Understand the LUTs and stuff. Talk briefly about the theory of transistors, but all projects must build on each other so we can’t build one.

# Answer

Transistors are used to control current. There are several types (MOSFETS, BJTs, etc), however digital electronics typically use MOSFETS. MOSFETS can be positively doped (PMOS) or negatively doped (NMOS). A complementary mosfet (CMOS) is a configuation of both NMOS and PMOS transistors such that a transistor, rather than a resistor, is used for the load. This imporoves power usage and performance. Here are a few CMOS logic gates:


<div style="display: flex; justify-content: space-between;">
    <figure>
        <img src="https://www.elprocus.com/wp-content/uploads/CMOS-Inverter-Circuit.png" width="200" height="200">
        <figcaption>NOT</figcaption>
    </figure>
    <figure>
        <img src="https://i.stack.imgur.com/LOYtw.png" width="200" height="200">
        <figcaption>AND</figcaption>
    </figure>
</div>


Because boolean logic can be implemented with transistors, various digital components can be built, such as LookUp Tables (LUTs). LUTs map a set of inputs to a set of outputs. They can be static or reconfigurable. In FPGAs, they are reconfigurable. LUTs are a core part of the programmable logic blocks (PLBs), which comprise an FPGA. Using LUTs, PLBs can change their outputs. In FPGAs, PLBs are connected via a programmable connection matrix, tying together the inputs/outputs of PLBs. Between PLBs and the connection matrix, FPGAs can implement complex digital ciruits.

<figure>
    <img src="https://www.researchgate.net/publication/254060327/figure/fig1/AS:616476935483392@1523990963075/A-two-input-lookup-table-LUT.png" width="200" height="200">
    <figcaption>LUT</figcaption>
</figure>


<figure>
    <img src="https://upload.wikimedia.org/wikipedia/commons/1/1c/FPGA_cell_example.png" width="600" height="300">
    <figcaption>PLB</figcaption>
</figure>

Finally, ICs are transitors in a "nice reliable package". This goes into fabrication, and I don't know much about it (and am not keen on learning more at the moment). What I think I know:
- Wafers start as layered n and p doped silicon
- The IC design is "painted" onto the wafer
- The painted wafer is exposed to special UV light. The light reacts with the paint and etches away material
- Repeat for all layers?

The result is an etched wafer that has transitors configured according to the specification.

# Reference

[1] https://en.wikipedia.org/wiki/Field-programmable_gate_array<br>
[2] https://en.wikipedia.org/wiki/Logic_block<br>
[3] https://en.wikipedia.org/wiki/Lookup_table<br>
[4] https://electronics.stackexchange.com/questions/169757/how-is-a-lut-in-an-fpga-configured <br>
[5] https://docs.xilinx.com/v/u/en-US/ug474_7Series_CLB<br>