-- Set explicit relative column widths for every table, proportional to the
-- longest cell text in each column (header and body), with a floor so short
-- numeric columns do not wrap. Without explicit widths, word processors
-- distribute width unevenly and break numbers across lines.
local MIN_CHARS = 9
local PAD = 3        -- padding for cells that must not wrap
local HEAD_PAD = 4   -- padding for the longest word of a header

local function cell_len(cell)
  return utf8.len(pandoc.utils.stringify(cell.contents)) or 0
end

function Table(tbl)
  local ncol = #tbl.colspecs
  local maxlen = {}
  for i = 1, ncol do maxlen[i] = MIN_CHARS end

  local function scan(rows)
    for _, row in ipairs(rows) do
      for i, cell in ipairs(row.cells) do
        if i <= ncol then
          local n = cell_len(cell)
          -- The label column (first) may wrap over two lines; numeric
          -- columns must not wrap, so they get their full length plus padding.
          local text = pandoc.utils.stringify(cell.contents)
          -- Paired values ("1.123 / 1.258") may break at the slash.
          if (i == 1 and text:find("%s")) or text:find(" / ", 1, true) then
            n = math.ceil(n / 2) + PAD
          else
            n = n + PAD
          end
          if maxlen[i] < n then maxlen[i] = n end
        end
      end
    end
  end

  -- Header text is allowed to wrap, so weight it at half its length.
  for _, row in ipairs(tbl.head.rows) do
    for i, cell in ipairs(row.cells) do
      if i <= ncol then
        local text = pandoc.utils.stringify(cell.contents)
        local n = math.ceil((utf8.len(text) or 0) / 2)
        -- Never narrower than the longest single word, so words do not split.
        for w in text:gmatch("%S+") do
          local wl = (utf8.len(w) or 0) + HEAD_PAD
          if n < wl then n = wl end
        end
        if maxlen[i] < n then maxlen[i] = n end
      end
    end
  end
  for _, body in ipairs(tbl.bodies) do scan(body.body) end

  local total = 0
  for i = 1, ncol do total = total + maxlen[i] end
  for i = 1, ncol do
    tbl.colspecs[i] = { tbl.colspecs[i][1], maxlen[i] / total }
  end
  return tbl
end
