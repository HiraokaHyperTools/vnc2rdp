﻿using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Xml.Serialization;

namespace keyMapGen.Models
{
    [XmlRoot]
    public class Designation
    {
        [XmlElement] public KeyboardLayout[] KeyboardLayout;
    }
}
