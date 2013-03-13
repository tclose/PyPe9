#!/usr/bin/env python
"""
Contains a method for plotting morphologies of NINEML+ network. The selected cell model 
will be loaded along with NeuronVisio's controls, from which the morphology can be plotted using the
Plot3D function (as a bonus the cell can also be run interactively using the other NeuronVisio 
commands). 

Requires NeuronVisio,to install NeuronVisio see http://mattions.github.com/neuronvisio/install.html.

@author Tom Close

"""
#######################################################################################
#
#    Copyright 2011 Okinawa Institute of Science and Technology (OIST), Okinawa, Japan
#
#######################################################################################

from ninemlp.neuron.ncml import load_cell_type

#def plot_morphology(xml_filename):
#    """Draw the model.
#    Params:
#    controls - the main gui obj."""
#
#    # Draw the new one
#    h.define_shape()
#    num_sections = 0
#
#    # Disable the render. Faster drawing.
#    self.mayavi.visualization.scene.disable_render = True
#
#
#    x, y, z, d = [], [], [], []
#    voltage = []
#    connections = []
#    for sec in h.allsec():
#        x_sec, y_sec, z_sec, d_sec = self.retrieve_coordinate(sec)
#        self.sec2coords[sec.name()] = [x_sec, y_sec, z_sec]
#        # Store the section. later.
#        radius = sec.diam / 2.
#        sec_coords_bound = ((x_sec.min(), x_sec.max()),
#                            (y_sec.min() - radius,
#                             y_sec.max() + radius),
#                            (z_sec.min() - radius,
#                             z_sec.max() + radius))
#        self.cyl2sec[sec_coords_bound] = sec
#        self.sec2cyl[sec] = sec_coords_bound
#
#
#        for i, xi in enumerate(x_sec):
#            x.append(x_sec[i])
#            y.append(y_sec[i])
#            z.append(z_sec[i])
#            d.append(d_sec[i])
#            indx_geom_seg = len(x) - 1
#
#            if len(x) > 1 and i > 0:
#                connections.append([indx_geom_seg, indx_geom_seg - 1])
#
#    self.edges = connections
#    self.x = x
#    self.y = y
#    self.z = z
#
#    # Mayavi pipeline        
#    d = np.array(d) # Transforming for easy division
#
#    self.draw_mayavi(x, y, z, d, self.edges)


def plot_morphology(xml_filename, cell_id, morph_id=None):  
    """
    The main function that actually runs the script
    """
    # Import NeuroVisio gui
    from neuronvisio.controls import Controls
    # Start the GUI
    controls = Controls() #@UnusedVariable: Just needs to be created for the GUI to be initialised
    # Load the cell
    Cell = load_cell_type(cell_id, xml_filename, morph_id)
    cell = Cell() #@UnusedVariable: Just needs to be created for the morphology to show up
    # Pause the script to allow inspection of the morphology
    raw_input("<press the 'Plot3D' button on the control panel to plot morphology, then press " \
              " return to continue>")

if __name__ == "__main__":
    import argparse
    # Set up the argument parser
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('xml_filename', type=str, 
                        help="The name of the xml file containing the morphology to plot")
    parser.add_argument('cell_id', type=str, help="The ID of the cell to extract from the xml file")
    parser.add_argument('--morph_id', type=str, default=None, 
                        help='The morphology ID to load from the xml file')
    args = parser.parse_args()
    plot_morphology(args.xml_filename, args.cell_id, args.morph_id)
