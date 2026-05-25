require "sanity"

local SPANS = array {
    { marker = "`", attr = "code", raw = true },
    { marker = "*", attr = "italic" },
    { marker = "**", attr = "bold" },
    { marker = "_", attr = "italic" },
    { marker = "__", attr = "bold" },
    { marker = "~~", attr = "strikethrough" },
}

local span_delimiter_byte_set = {}
for _, span in ipairs(SPANS) do
    span.bytes = {}
    for i = 1, #span.marker do
        span.bytes[i] = span.marker:byte(i)
    end
    span_delimiter_byte_set[span.bytes[1]] = true
end

local function parse_spans(input)
    local markers = array()

    local prev_byte = nil
    for pos, byte in input:bytes() do
        if not span_delimiter_byte_set[byte] then
            goto next_byte
        end

        for _, span in ipairs(SPANS) do
            local valid_span = true
            for i, marker_byte in ipairs(span.bytes) do
                if marker_byte ~= input:byte(pos + i - 1) then
                    valid_span = false
                    break
                end
            end

            if valid_span then
                local next_byte = input:byte(pos + #span.bytes)
                local open = next_byte ~= " "
                    and next_byte ~= span.bytes[1]
                local close = prev_byte ~= " "
                    and prev_byte ~= span.bytes[1]
                if open or close then
                    markers:push({
                        span = span,
                        pos = pos,
                        open = open,
                        close = close
                    })
                end
            end
        end

        prev_byte = byte
        ::next_byte::
    end

    vim.print(markers)
    vim.print(input)
    for _, span in ipairs(SPANS) do
        local open_marker = nil
        for i, marker in ipairs(markers) do
            if marker.ignore or marker.span ~= span then
                goto next_marker
            end

            if marker.close and open_marker then
                vim.print(
                    marker.span.attr .. ":"
                    .. open_marker.pos .. " -> " .. marker.pos)

                for _, other_marker in ipairs(markers) do
                    if other_marker.pos >= marker.pos
                            and other_marker.pos <= marker.pos + #marker.span.bytes
                        or other_marker.pos + #other_marker.span.bytes >= marker.pos
                            and other_marker.pos + #other_marker.span.bytes <= marker.pos + #marker.span.bytes
                        or other_marker.pos >= open_marker.pos
                            and other_marker.pos <= open_marker.pos + #open_marker.span.bytes
                        or other_marker.pos + #other_marker.span.bytes >= open_marker.pos
                            and other_marker.pos + #other_marker.span.bytes <= open_marker.pos + #open_marker.span.bytes
                    then
                        marker.ignore = true
                    end
                end
                open_marker = nil


                -- for raw things (code) we must delete things contained
                -- within entire range. not just within the markers

            elseif marker.open then
                open_marker = marker
            end
            ::next_marker::
        end
    end

    -- vim.print(markers)

    return nil
end

-- vim.print(parse_spans("i should see *italic* **bold** and ***bold italic***"))
-- vim.print(parse_spans("***bold italic* bold** nada"))
-- vim.print(parse_spans("***bold italic** italic*"))
vim.print(parse_spans("__*bold italic__ italic*"))
