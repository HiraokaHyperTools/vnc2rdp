using keyMapGen.Utils;
using keyMapGen.Extensions;
using NUnit.Framework;
using System;
using System.IO;
using keyMapGen.Models;
using System.Collections.Generic;
using System.Linq;

namespace keyMapGen
{
    public class Class1
    {
        [Test]
        [TestCaseSource(nameof(GetToVnc))]
        public void Compare(string hint, uint key, ushort key_code)
        {
            var r = new v2r_rdp_t { };
            Assert.AreEqual(key, KeyMapUtil.ToVnc(key_code, r, false));
        }

        private static object[] GetToVnc()
        {
            return File.OpenRead(
                Path.Combine(
                    TestContext.CurrentContext.WorkDirectory,
                    "Designation.xml"
                )
            )
                .Using(it => it.XmlDeserialize<Designation>())
                .ToVnc
                .Select(it => new object[] { it.hint, it.key, it.key_code, })
                .ToArray();
        }

        [Test]
        [Ignore("run ondemand")]
        public void Generate()
        {
            for (int key_code = 0; key_code < 128; key_code++)
            {
                var r = new v2r_rdp_t { };
                var key = KeyMapUtil.ToVnc((ushort)key_code, r, false);
                Console.WriteLine($"<ToVnc hint=\"{key_code:X4}→{key:X4}\" key_code=\"{key_code}\" key=\"{key}\" />");
            }
        }
    }
}
