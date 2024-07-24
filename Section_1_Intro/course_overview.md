# Prompt

So about those transistors -- Course overview. Describe how FPGAs are buildable using transistors, and that ICs are just collections of transistors in a nice reliable package. Understand the LUTs and stuff. Talk briefly about the theory of transistors, but all projects must build on each other so we can’t build one.

# Answer

### Basics of Transistors

Transistors affect current using three terminals. One terminal is used to control current flow between the other two terminals.

In digital electronics, Metal-Oxide-Semiconductor Field Effect Transistors (MOSFETs) are most often used. There are three main flavors of this type of transistor: positively doped (PMOS), negatively doped (NMOS), or complementary (CMOS). The dominant flavor in modern digital electronics is CMOSFET.

A complementary mosfet (CMOS) is a configuation of both NMOS and PMOS transistors such that a transistor, rather than a resistor, is used for the load. This imporoves power usage and performance.

Because one gate controls current through the other two gates, transistors can be used to implement boolean logic. Here are a few CMOS logic gates:

<div style="display: flex; justify-content: space-between;">
    <figure>
        <img src="https://www.elprocus.com/wp-content/uploads/CMOS-Inverter-Circuit.png" width="200" height="200">
        <figcaption>NOT</figcaption>
        <p>
            Vin high closes the PMOS gate and opens the NMOS gate. The result is that Vout is tied to ground. Vin low opens the PMOS gate and close the NMOS gates. Vout is then tied to high and shutoff from ground.
        </p>
    </figure>
    <figure>
        <img src="https://i.stack.imgur.com/LOYtw.png" width="200" height="200">
        <figcaption>AND</figcaption>
        <p>
            If either A or B is low, OUT will low as the PMOS gates will be open. Unless both A and B are high, the NMOS series will not allow current to Vout.
        </p>
    </figure>
</div>


### Transistors and FPGAs

Because we know transistors can be used to implement boolean logic, we can think in terms of boolean logic, rather than transistors. We can then rephrase the question, how are FPGAs 
built using boolean logic?

FPGAs are fundamentally programmable via reconfigurable Lookup Tables (LUTs) and reconfigurable interconnects. First, LUTs are software or hardware components that map inputs to outputs. We will focus on the hardware LUT.

Strictly adhering to the above definition of LUT, a single logic gate, like the CMOS ones pictured above, can be considered a LUT. But, in reality, LUTs are used for more "complex"
boolean equations. Consider:

<div>
    <figure>
        <img src="https://raw.githubusercontent.com/imaolo/fromthetransistor/master/Section_1_Intro/truth_table.jpeg">
     <figcaption>https://nandland.com/lesson-4-what-is-a-look-up-table-lut/</figcaption>
    <gig>
</div>

But, the above LUT is not reconfigurable, meaning we cannot change what inputs map to what outputs.

A reconfigurable LUT is one that can change its truth table. These are usually implemented with a decoder or multiplexer and a set of memory cells. To configure an LUT of this type, the memory cells are overwritten.

<figure>
    <img src="https://www.researchgate.net/publication/254060327/figure/fig1/AS:616476935483392@1523990963075/A-two-input-lookup-table-LUT.png" width="500" height="500">
    <figcaption>LUT</figcaption>
</figure>

Then, decoders and memory can be implemented in boolean logic (and thus using transistors):

<figure>
    <img src="https://raw.githubusercontent.com/imaolo/fromthetransistor/master/Section_1_Intro/sram-bool.jpg">
    <figcaption>SRAM cell</figcaption>
</figure>

<figure style="background-color: white;">
    <img src="https://www.electronics-tutorials.ws/wp-content/uploads/2018/05/combination-comb44.gif">
    <figcaption>Decoder</figcaption>
</figure>


The second fundamental component of FPGAs are reconfigurable innterconnects.

TODO - explain interconnects
TODO - revamp IC explanation and transistor theory

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