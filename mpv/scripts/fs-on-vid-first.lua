local first = true

-- list of formats that should NOT trigger fullscreen
local get_ext = {
    png=true, jpg=true, jpeg=true, webp=true, gif=true, avif=true, 
    bmp=true, tiff=true, cbz=true, cbr=true, cb7=true, flac=true, 
    opus=true, mp3=true, aac=true, alac=true, wav=true, m4a=true
}

local function is_illegal(fname)
    if not fname then return false end
    local ext = fname:match("%.([^%.]+)$")
    if not ext then return false end
    ext = ext:lower()
    return get_ext[ext] == true
end

mp.register_event("file-loaded", function ()
    if not first then
        return  -- only apply to very first file after mpv launch
    end
    first = false

    local path = mp.get_property("path")

    -- if first file is image/gif → don't fullscreen
    if is_illegal(path) then
        return
    end

    -- only fullscreen if user is currently NOT in fullscreen
    local fs = mp.get_property_native("fullscreen")
    if not fs then
        mp.set_property("fullscreen", "yes")
    end
end)

