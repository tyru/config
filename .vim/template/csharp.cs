/* vim:<% eval: printf("ts=%s:sw=%s:sts=%s:tw=%s:%s", &ts, &sw, &sts, &tw, &expandtab ? "et" : "noet") %>: */
/* 
 * <%filename%> - DESCRIPTION HERE
 *
 * Written By: <%author%> <<%email%>>
 * Last Change: 2009-05-31.
 *
 */

namespace <%filename_noext%> {
    using System;
    using System.Drawing;
    using System.Windows.Forms;

    class Program {
        public static void Main() {
            Application.Run( new Form1() );
        }
    }

    class Form1 : Form {
        public Form1() {
          this.Text = "Hello";
        }
    }
}
