local lfs = require "lfs"

function apply(file, path, attr, data) 
    local match = data["search"]
    local replace = data["replace"]
    local execute = data["execute"]
    local verbose = data["verbose"]

    local rename = file:gsub(match, replace)
    local full_name = path .. "/" .. file
    local full_rename = path .. "/" .. rename
    local mode = attr.mode

    ret = 0

    if mode ~= "directory" and file ~= rename then
        if execute == "true" then
            os.rename(full_name, full_rename)
        end
        if verbose == "true" then
            print("renaming " .. full_name .. " to " .. full_rename)
        end
        ret = 1
    end
    return ret
end

function new_apply(file, path, mode, data)
    local ret = 0

    if mode == "file" then
        local rename = file:gsub(data["search"], data["replace"])
        local names = { name = path .. "/" .. file,
                    rename = path .. "/" .. file }

        if names.name ~= names.rename then
           if execute == "true" then
               os.rename(names.name, names.rename)
           end
           if verbose == "true" then
               print("renaming " .. names.name .. " to " .. names.rename)
           end
           
           ret = 1
        end
    end

    return ret
end

return {apply = apply}
