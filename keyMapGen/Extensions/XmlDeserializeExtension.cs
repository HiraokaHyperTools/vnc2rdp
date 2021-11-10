using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Xml.Serialization;

namespace keyMapGen.Extensions
{
    internal static class XmlDeserializeExtension
    {
        internal static Out XmlDeserialize<Out>(this Stream input)
        {
            return (Out)new XmlSerializer(typeof(Out)).Deserialize(input);
        }
    }
}
