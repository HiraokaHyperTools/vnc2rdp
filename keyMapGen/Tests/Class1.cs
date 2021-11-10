using keyMapGen.Utils;
using keyMapGen.Extensions;
using NUnit.Framework;
using System;
using System.IO;
using keyMapGen.Models;
using System.Collections.Generic;
using System.Linq;

namespace keyMapGen.Tests
{
    public class Class1
    {
        internal static object[] GetToVncByKeyboardLayout(string layout)
        {
            return File.OpenRead(
                Path.Combine(
                    TestContext.CurrentContext.WorkDirectory,
                    "Designation.xml"
                )
            )
                .Using(stream => stream.XmlDeserialize<Designation>())
                .KeyboardLayout
                .Single(kbdLay => kbdLay.Layout == layout)
                .ToVnc
                .Select(it => new object[] { it.hint, it.key_code, it.key, it.lshift_key, })
                .ToArray();
        }

        [Test]
        [Ignore("run ondemand")]
        public void Prepare_ToVnc_109()
        {
            var keymap = KeyMaps.keymap_jp;
            for (int key_code = 0; key_code < 128; key_code++)
            {
                var key = KeyMapUtil.ToVnc((ushort)key_code, new v2r_rdp_t { keymap = keymap, }, false);
                var lshift_key = KeyMapUtil.ToVnc((ushort)key_code, new v2r_rdp_t { keymap = keymap, lshift = true, }, false);
                Console.WriteLine($"<ToVnc hint=\"{key_code:X4}→{key:X4} (S={lshift_key:X4})\" key_code=\"{key_code}\" key=\"{key}\" lshift_key=\"{lshift_key}\" />");
            }
        }

        [Test]
        [Ignore("run ondemand")]
        public void Prepare_ToVnc_101()
        {
            var keymap = KeyMaps.keymap_us;
            for (int key_code = 0; key_code < 128; key_code++)
            {
                var key = KeyMapUtil.ToVnc((ushort)key_code, new v2r_rdp_t { keymap = keymap, }, false);
                var lshift_key = KeyMapUtil.ToVnc((ushort)key_code, new v2r_rdp_t { keymap = keymap, lshift = true, }, false);
                Console.WriteLine($"<ToVnc hint=\"{key_code:X4}→{key:X4} (S={lshift_key:X4})\" key_code=\"{key_code}\" key=\"{key}\" lshift_key=\"{lshift_key}\" />");
            }
        }
    }
}
