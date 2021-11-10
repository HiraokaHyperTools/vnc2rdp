using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Xml.Serialization;

namespace keyMapGen.Models
{
    public class KeyboardLayout
    {
        [XmlAttribute] public string Layout;
        [XmlElement] public ToVncElement[] ToVnc;
    }
}
