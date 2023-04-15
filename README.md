# flp.ksy

Kaitai Struct spec for FL Studio file formats.

FL Studio uses a TLV format based on MIDI for storing project and preset
files. All information is stored in the form of TLV constructs called events
which can be thought of as flattened object attributes.

FLP is an undocumented format. There is rarely any information about it,
except from a note by Didier Dambrin (a.k.a gol, ex Image-Line employee) and
a list of event IDs and few enums by Image-Line for FL Studio 11.

## Acknowledgements

Special thanks to @RoadCrewWorker for reversing a significant chunk of the
FLP format and FLPEdit and to @monadgroup for FLParser. Apart from that, many
definitions are from my library [PyFLP](https://github.com/demberto/PyFLP)
