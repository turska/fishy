last_checksum = '';
framenumber = 0;
seq = 0;
delay = 0; 
delay_max = 10000;

on_paint=function()
  gui.top_gap(16);
  gui.text(0, -16, memory.hash_region(0x10000000, 0x2000));
end

on_reset=function()
	this_checksum = memory.hash_region(0x10000000, 0x2000);
    if this_checksum ~= last_checksum then
      io.stderr:write(this_checksum .. " (A)\n");
    s = "";
    for i = 0,8191 do
      s = s .. string.char(memory.readbyte(0x10000000 + i));
    end
    io.stderr:write(this_checksum .. " (B)\n");
    filename = "/tmp/ct/ct-sram4-"..string.format("%05d", seq);
    io.stderr:write(filename .. "\n");
    file,err = io.open(filename, "wb");
    if not file then
      io.stderr:write("Fail");
      error(err);
    else
      io.stderr:write(filename .. " " .. tostring(file) .. "\n");
    end
    file:write(s);
    file:close();
    last_checksum = this_checksum;
  end
  seq = seq + 1;
end


on_input=function(subframe)
  frame = movie.currentframe();

  if frame == 12254 then
    input.set(0, 8, 1);
  end 
  if frame == 12255 then
    input.set(0, 8, 0);
    input.reset(delay);
    print(delay)
    delay = delay + 1;
  end

	if frame == 12256 then
		exec("load state.lsmv");
	end

	if delay == delay_max then
		exec("pause-emulator");
	end
end
