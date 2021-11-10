using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace keyMapGen.Extensions
{
    internal static class UsingExtension
    {
        internal static Out Using<In, Out>(this In input, Func<In, Out> action) where In : IDisposable
        {
            using (input)
            {
                return action(input);
            }
        }
    }
}
