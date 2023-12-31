from argparse import ArgumentParser
from seguid import __version__

from seguid.chksum import seguid
from seguid.chksum import slseguid
from seguid.chksum import scseguid
from seguid.chksum import dlseguid
from seguid.chksum import dcseguid
from seguid.manip import reverse
from seguid.reprutils import tuple_from_repr

parser = ArgumentParser(prog="python -m seguid", description="seguid: Sequence Globally Unique Identifier (SEGUID) for Nucleotide and Amino-Acid Sequences")
parser.add_argument("--version", action="store_true", help="Show version")
parser.add_argument("--type", type=str, nargs="?", help="Type of checksum to calculate")

args = vars(parser.parse_args())

if args.pop("version"):
    print(__version__)
else:
    type=args.pop("type")
    if type == None:
        type="seguid"
        
    ## Read sequence data from the standard input
    lines=[]
    try:
        while True:
            line = input()
            if not line:  # Optionally, break if an empty line is encountered
                break
            lines.append(line)
    except EOFError:
        pass
    seq="\n".join(lines)

    if type == "seguid":
        res=seguid(seq)
    elif type == "slseguid":
        res=slseguid(seq)
    elif type == "scseguid":
        res=scseguid(seq)
    elif type == "dlseguid":
        tuple=tuple_from_repr(seq)
        res=dlseguid(watson = tuple[0], crick = tuple[1], overhang = tuple[2])
    elif type == "dcseguid":
        tuple=tuple_from_repr(seq)
        res=dcseguid(watson = tuple[0], crick = tuple[1])
    else:
        raise ValueError("Unknown --type='" + type + "'")
    
    print(res)
