using keyMapGen.Utils;
using NUnit.Framework;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace keyMapGen.Tests
{
    public class Kbd101
    {
        private v2r_keymap_t keymap = KeyMaps.keymap_us;

        [Test]
        [TestCaseSource(nameof(GetToVncByKeyboardLayout))]
        public void Noshift(string hint, ushort key_code, uint key, uint lshift_key)
        {
            var r = new v2r_rdp_t
            {
                keymap = keymap,
            };
            Assert.AreEqual(Hex4(key), Hex4(KeyMapUtil.ToVnc(key_code, r, false, debug: true)));
        }

        [Test]
        [TestCaseSource(nameof(GetToVncByKeyboardLayout))]
        public void Shift(string hint, ushort key_code, uint key, uint lshift_key)
        {
            var r = new v2r_rdp_t
            {
                keymap = keymap,
                lshift = true,
            };
            Assert.AreEqual(Hex4(lshift_key), Hex4(KeyMapUtil.ToVnc(key_code, r, false, debug: true)));
        }

        private static string Hex4(uint value) => $"{value:X4}";

        private static object[] GetToVncByKeyboardLayout() => Class1.GetToVncByKeyboardLayout("101");
    }
}
