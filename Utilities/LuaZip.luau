local LuaZip = {}

local bit_band = bit32.band
local bit_bor = bit32.bor
local bit_bxor = bit32.bxor
local bit_lshift = bit32.lshift
local bit_rshift = bit32.rshift
local bit_bnot = bit32.bnot

local function u8(data, pos)
    return string.byte(data, pos)
end

local function u16(data, pos)
    local a, b = string.byte(data, pos, pos + 1)
    return a + b * 256
end

local function u32(data, pos)
    local a, b, c, d = string.byte(data, pos, pos + 3)
    return a + b * 256 + c * 65536 + d * 16777216
end

local function p16(value)
    return string.char(bit_band(value, 255), bit_band(bit_rshift(value, 8), 255))
end

local function p32(value)
    return string.char(bit_band(value, 255), bit_band(bit_rshift(value, 8), 255), bit_band(bit_rshift(value, 16), 255), bit_band(bit_rshift(value, 24), 255))
end

local crc_table = {}

for i = 0, 255 do
    local crc = i

    for _ = 1, 8 do
        if bit_band(crc, 1) ~= 0 then
            crc = bit_bxor(bit_rshift(crc, 1), 0xEDB88320)
        else
            crc = bit_rshift(crc, 1)
        end
    end

    crc_table[i] = crc
end

local function crc32(data)
    local crc = 0xFFFFFFFF

    for i = 1, #data do
        local byte = string.byte(data, i)
        local index = bit_band(bit_bxor(crc, byte), 255)
        crc = bit_bxor(bit_rshift(crc, 8), crc_table[index])
    end

    return bit_bxor(crc, 0xFFFFFFFF)
end

local function reverse_bits(value, count)
    local result = 0

    for _ = 1, count do
        result = bit_bor(bit_lshift(result, 1), bit_band(value, 1))
        value = bit_rshift(value, 1)
    end

    return result
end

local function make_huffman(lengths)
    local counts = {}

    for i = 0, 15 do
        counts[i] = 0
    end

    for _, length in pairs(lengths) do
        if length > 0 then
            counts[length] = counts[length] + 1
        end
    end

    local next_code = {}
    local code = 0

    for bits = 1, 15 do
        code = bit_lshift(code + counts[bits - 1], 1)
        next_code[bits] = code
    end

    local tree = {}

    for symbol, length in pairs(lengths) do
        if length > 0 then
            local canonical = next_code[length]
            next_code[length] = canonical + 1

            local reversed = reverse_bits(canonical, length)
            local node = tree

            for bit = 1, length do
                local value = bit_band(bit_rshift(reversed, bit - 1), 1)

                if bit == length then
                    node[value] = symbol
                else
                    node[value] = node[value] or {}
                    node = node[value]
                end
            end
        end
    end

    return tree
end

local function bit_reader(data, position)
    local reader = {
        data = data,
        byte = position or 1,
        bit = 0
    }

    function reader:read(count)
        local result = 0
        local shift = 0

        while count > 0 do
            if self.byte > #self.data then
                error("Unexpected end of compressed data")
            end

            local current = string.byte(self.data, self.byte)
            local available = 8 - self.bit
            local take = math.min(count, available)
            local mask = bit_lshift(1, take) - 1
            local value = bit_band(bit_rshift(current, self.bit), mask)

            result = bit_bor(result, bit_lshift(value, shift))

            self.bit = self.bit + take
            shift = shift + take
            count = count - take

            if self.bit == 8 then
                self.bit = 0
                self.byte = self.byte + 1
            end
        end

        return result
    end

    function reader:align()
        if self.bit ~= 0 then
            self.bit = 0
            self.byte = self.byte + 1
        end
    end

    return reader
end

local length_base = {
    3, 4, 5, 6, 7, 8, 9, 10,
    11, 13, 15, 17, 19, 23, 27, 31,
    35, 43, 51, 59, 67, 83, 99, 115,
    131, 163, 195, 227, 258
}

local length_extra = {
    0, 0, 0, 0, 0, 0, 0, 0,
    1, 1, 1, 1, 2, 2, 2, 2,
    3, 3, 3, 3, 4, 4, 4, 4,
    5, 5, 5, 5, 0
}

local distance_base = {
    1, 2, 3, 4, 5, 7, 9, 13,
    17, 25, 33, 49, 65, 97, 129, 193,
    257, 385, 513, 769, 1025, 1537, 2049, 3073,
    4097, 6145, 8193, 12289, 16385, 24577
}

local distance_extra = {
    0, 0, 0, 0, 1, 1, 2, 2,
    3, 3, 4, 4, 5, 5, 6, 6,
    7, 7, 8, 8, 9, 9, 10, 10,
    11, 11, 12, 12, 13, 13
}

local fixed_literal_tree
local fixed_distance_tree

do
    local lengths = {}

    for i = 0, 143 do
        lengths[i] = 8
    end

    for i = 144, 255 do
        lengths[i] = 9
    end

    for i = 256, 279 do
        lengths[i] = 7
    end

    for i = 280, 287 do
        lengths[i] = 8
    end

    fixed_literal_tree = make_huffman(lengths)

    local distance_lengths = {}

    for i = 0, 31 do
        distance_lengths[i] = 5
    end

    fixed_distance_tree = make_huffman(distance_lengths)
end

local function read_huffman(reader, tree)
    local node = tree

    while type(node) == "table" do
        node = node[reader:read(1)]

        if node == nil then
            error("Invalid DEFLATE Huffman code")
        end
    end

    return node
end

local function inflate(data)
    local reader = bit_reader(data)
    local output = {}

    while true do
        local final = reader:read(1)
        local block_type = reader:read(2)

        if block_type == 0 then
            reader:align()

            local length = reader:read(16)
            local inverse = reader:read(16)

            if bit_band(length, 0xFFFF) ~= bit_band(bit_bnot(inverse), 0xFFFF) then
                error("Invalid stored DEFLATE block")
            end

            for _ = 1, length do
                output[#output + 1] = string.char(reader:read(8))
            end
        elseif block_type == 1 or block_type == 2 then
            local literal_tree
            local distance_tree

            if block_type == 1 then
                literal_tree = fixed_literal_tree
                distance_tree = fixed_distance_tree
            else
                local hlit = reader:read(5) + 257
                local hdist = reader:read(5) + 1
                local hclen = reader:read(4) + 4

                local order = {
                    16, 17, 18, 0, 8, 7, 9, 6,
                    10, 5, 11, 4, 12, 3, 13, 2,
                    14, 1, 15
                }

                local code_lengths = {}

                for i = 1, 19 do
                    code_lengths[i - 1] = 0
                end

                for i = 1, hclen do
                    code_lengths[order[i]] = reader:read(3)
                end

                local code_tree = make_huffman(code_lengths)
                local all_lengths = {}
                local total = hlit + hdist
                local index = 1

                while index <= total do
                    local symbol = read_huffman(reader, code_tree)

                    if symbol <= 15 then
                        all_lengths[index] = symbol
                        index = index + 1
                    elseif symbol == 16 then
                        if index == 1 then
                            error("Invalid DEFLATE repeat")
                        end

                        local repeat_count = reader:read(2) + 3
                        local previous = all_lengths[index - 1]

                        for _ = 1, repeat_count do
                            all_lengths[index] = previous
                            index = index + 1
                        end
                    elseif symbol == 17 then
                        local repeat_count = reader:read(3) + 3

                        for _ = 1, repeat_count do
                            all_lengths[index] = 0
                            index = index + 1
                        end
                    elseif symbol == 18 then
                        local repeat_count = reader:read(7) + 11

                        for _ = 1, repeat_count do
                            all_lengths[index] = 0
                            index = index + 1
                        end
                    else
                        error("Invalid DEFLATE code length")
                    end
                end

                local literal_lengths = {}
                local distance_lengths = {}

                for i = 0, hlit - 1 do
                    literal_lengths[i] = all_lengths[i + 1] or 0
                end

                for i = 0, hdist - 1 do
                    distance_lengths[i] = all_lengths[hlit + i + 1] or 0
                end

                literal_tree = make_huffman(literal_lengths)
                distance_tree = make_huffman(distance_lengths)
            end

            while true do
                local symbol = read_huffman(reader, literal_tree)

                if symbol < 256 then
                    output[#output + 1] = string.char(symbol)
                elseif symbol == 256 then
                    break
                elseif symbol <= 285 then
                    local index = symbol - 256
                    local length = length_base[index]
                    local extra = length_extra[index]

                    if extra > 0 then
                        length = length + reader:read(extra)
                    end

                    local distance_symbol = read_huffman(reader, distance_tree)

                    if distance_symbol > 29 then
                        error("Invalid DEFLATE distance")
                    end

                    local distance = distance_base[distance_symbol + 1]
                    local distance_bits = distance_extra[distance_symbol + 1]

                    if distance_bits > 0 then
                        distance = distance + reader:read(distance_bits)
                    end

                    local current = #output

                    for i = 1, length do
                        local source = current - distance + i

                        if source < 1 then
                            error("Invalid DEFLATE back-reference")
                        end

                        output[#output + 1] = output[source]
                    end
                else
                    error("Invalid DEFLATE literal")
                end
            end
        else
            error("Reserved DEFLATE block type")
        end

        if final ~= 0 then
            break
        end
    end

    return table.concat(output)
end

local function basename(path)
    path = path:gsub("\\", "/")
    return path:match("([^/]+)$") or path
end

local function relative_path(path, root)
    path = path:gsub("\\", "/")
    root = root:gsub("\\", "/")

    if root:sub(-1) ~= "/" then
        root = root .. "/"
    end

    return path:sub(#root + 1)
end

local function ensure_folder(path)
    path = path:gsub("\\", "/")

    local current = ""

    for part in path:gmatch("[^/]+") do
        if current == "" then
            current = part
        else
            current = current .. "/" .. part
        end

        if not isfolder(current) then
            makefolder(current)
        end
    end
end

local function collect_files(path, root, files)
    if isfile(path) then
        files[#files + 1] = {
            path = path,
            name = basename(path)
        }
        return
    end

    assert(isfolder(path), "Path does not exist: " .. path)

    for _, child in ipairs(listfiles(path)) do
        if isfile(child) then
            files[#files + 1] = {
                path = child,
                name = relative_path(child, root)
            }
        elseif isfolder(child) then
            collect_files(child, root, files)
        end
    end
end

function LuaZip.zip(input_path, output_path)
    assert(type(input_path) == "string", "input_path must be a string")
    assert(type(output_path) == "string", "output_path must be a string")

    local files = {}
    collect_files(input_path, input_path, files)

    local local_headers = {}
    local central_headers = {}
    local offset = 0
    local count = 0

    for _, file in ipairs(files) do
        local data = readfile(file.path)
        local name = file.name:gsub("\\", "/")
        local checksum = crc32(data)

        local header = "PK\003\004" ..
            p16(20) ..
            p16(0) ..
            p16(0) ..
            p16(0) ..
            p16(0) ..
            p32(checksum) ..
            p32(#data) ..
            p32(#data) ..
            p16(#name) ..
            p16(0) ..
            name ..
            data

        local_headers[#local_headers + 1] = header

        local central = "PK\001\002" ..
            p16(20) ..
            p16(20) ..
            p16(0) ..
            p16(0) ..
            p16(0) ..
            p16(0) ..
            p32(checksum) ..
            p32(#data) ..
            p32(#data) ..
            p16(#name) ..
            p16(0) ..
            p16(0) ..
            p16(0) ..
            p16(0) ..
            p32(0) ..
            p32(offset) ..
            name

        central_headers[#central_headers + 1] = central
        offset = offset + #header
        count = count + 1
    end

    local local_data = table.concat(local_headers)
    local central_data = table.concat(central_headers)

    local end_record = "PK\005\006" ..
        p16(0) ..
        p16(0) ..
        p16(count) ..
        p16(count) ..
        p32(#central_data) ..
        p32(#local_data) ..
        p16(0)

    writefile(output_path, local_data .. central_data .. end_record)
    return true
end

function LuaZip.unzip(zip_path, output_path)
    assert(isfile(zip_path), "ZIP file does not exist: " .. zip_path)

    local data = readfile(zip_path)
    local eocd

    for position = #data - 21, math.max(1, #data - 65557), -1 do
        if data:sub(position, position + 3) == "PK\005\006" then
            eocd = position
            break
        end
    end

    assert(eocd, "Invalid ZIP: end of central directory not found")

    local count = u16(data, eocd + 10)
    local central_size = u32(data, eocd + 12)
    local central_offset = u32(data, eocd + 16)

    assert(central_offset + central_size <= #data, "Invalid ZIP central directory")

    if not isfolder(output_path) then
        makefolder(output_path)
    end

    local position = central_offset + 1

    for _ = 1, count do
        assert(data:sub(position, position + 3) == "PK\001\002", "Invalid ZIP central directory entry")

        local compression = u16(data, position + 10)
        local compressed_size = u32(data, position + 20)
        local uncompressed_size = u32(data, position + 24)
        local name_length = u16(data, position + 28)
        local extra_length = u16(data, position + 30)
        local comment_length = u16(data, position + 32)
        local local_offset = u32(data, position + 42)

        local name = data:sub(position + 46, position + 45 + name_length):gsub("\\", "/")

        if name:sub(-1) == "/" then
            ensure_folder(output_path .. "/" .. name)
        else
            local local_position = local_offset + 1

            assert(data:sub(local_position, local_position + 3) == "PK\003\004", "Invalid local ZIP header")

            local local_name_length = u16(data, local_position + 26)
            local local_extra_length = u16(data, local_position + 28)
            local compressed_start = local_position + 30 + local_name_length + local_extra_length

            local compressed_data = data:sub(compressed_start, compressed_start + compressed_size - 1)
            local file_data

            if compression == 0 then
                file_data = compressed_data
            elseif compression == 8 then
                file_data = inflate(compressed_data)
            else
                error("Unsupported ZIP compression method " .. tostring(compression) .. " for " .. name)
            end

            assert(#file_data == uncompressed_size, "Size mismatch while extracting " .. name)

            local output_file = output_path .. "/" .. name
            local parent = output_file:match("^(.+)/[^/]+$")

            if parent then
                ensure_folder(parent)
            end

            writefile(output_file, file_data)
        end

        position = position + 46 + name_length + extra_length + comment_length
    end

    return true
end

zip = LuaZip.zip
unzip = LuaZip.unzip
