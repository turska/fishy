on_paint=function()
  gui.top_gap(16);
  gui.text(0, -16, memory.hash_region(0x10000000, 0x2000));
end
