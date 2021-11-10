using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace keyMapGen.Utils
{
    class KeyMapUtil
    {
        internal static uint ToVnc(ushort key_code, v2r_rdp_t r, bool extended)
        {
            var x11_key_code = KeyMaps.scancode_to_x11_keycode_map[key_code, extended ? 1 : 0];
            uint key;

            /* get X11 KeySym by keycode and current status */
            if ((79 <= x11_key_code) && (x11_key_code <= 91))
            {
                if (r.numlock)
                {
                    key = r.keymap.shift[x11_key_code];
                }
                else
                {
                    key = r.keymap.noshift[x11_key_code];
                }
            }
            else if (r.lshift || r.rshift)
            {
                if (r.capslock)
                {
                    key = r.keymap.shiftcapslock[x11_key_code];
                }
                else
                {
                    key = r.keymap.shift[x11_key_code];
                }
            }
            else if (r.capslock)
            {
                key = r.keymap.capslock[x11_key_code];
            }
            else if (r.altgr)
            {
                key = r.keymap.altgr[x11_key_code];
            }
            else
            {
                key = r.keymap.noshift[x11_key_code];
            }

            return key;
        }
    }
}
