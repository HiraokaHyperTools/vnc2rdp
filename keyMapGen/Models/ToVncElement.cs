﻿using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Xml.Serialization;

namespace keyMapGen.Models
{
    public class ToVncElement
    {
        [XmlAttribute] public string hint;
        [XmlAttribute] public ushort key_code;
        [XmlAttribute] public uint key;
        [XmlAttribute] public uint lshift_key;
    }
}
