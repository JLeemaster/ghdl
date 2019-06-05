--  GHDL Run Time (GRT) - IO for variable strings.
--  Copyright (C) 2019 Tristan Gingold
--
--  GHDL is free software; you can redistribute it and/or modify it under
--  the terms of the GNU General Public License as published by the Free
--  Software Foundation; either version 2, or (at your option) any later
--  version.
--
--  GHDL is distributed in the hope that it will be useful, but WITHOUT ANY
--  WARRANTY; without even the implied warranty of MERCHANTABILITY or
--  FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License
--  for more details.
--
--  You should have received a copy of the GNU General Public License
--  along with GCC; see the file COPYING.  If not, write to the Free
--  Software Foundation, 59 Temple Place - Suite 330, Boston, MA
--  02111-1307, USA.
--
--  As a special exception, if other files instantiate generics from this
--  unit, or you link this unit with other files to produce an executable,
--  this unit does not by itself cause the resulting executable to be
--  covered by the GNU General Public License. This exception does not
--  however invalidate any other reasons why the executable file might be
--  covered by the GNU Public License.

with Grt.Errors; use Grt.Errors;
with Grt.C; use Grt.C;

package body Grt.Vstrings_IO is
   procedure Put (Stream : FILEs; Vstr : Vstring)
   is
      S : size_t;
   begin
      S := size_t (Length (Vstr));
      if S > 0 then
         S := fwrite (Get_Address (Vstr), S, 1, Stream);
      end if;
   end Put;

   procedure Put (Stream : FILEs; Rstr : Rstring)
   is
      S : size_t;
   begin
      S := size_t (Length (Rstr));
      if S > 0 then
         S := fwrite (Get_Address (Rstr), S, 1, Stream);
      end if;
   end Put;

end Grt.Vstrings_IO;