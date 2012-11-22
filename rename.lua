-- this is the lua ls rename plugin
-- takes a regex search and replaces the search within the entry name with the
-- plain text replace

-- the apply function, which is exported for use as plugin
-- takes the standard plugin parameters, uses it's own set of command line
-- parameters as well
-- plugin parameters:
--      entry,   the entry in the directory to check our execution against
--      path,    the path to this entry (minus the entry)
--      attr,    the attributes of this entry (we just check to make sure it's
--               a file)
--      params,  the parameters this plugin accepts from the command line
-- command line parameters:
--      --search=$LUA_REGEX,        the lua compat regex we use to search the
--                                  filename for replacement
--      --replace=$TEXT,            the plain text replacement for whatever is
--                                  matched by the $LUA_REGEX
--      --execute=[true||false],    whether or not we shall execute an actual
--                                  rename
--      --verbose=[true||false],    whether or not to print info on our actions
function apply(entry, path, attr, params)
    local ret = 0
    if attr.mode == "file" then
        local rename =  entry:gsub(params.search, params.replace)
        local names =   {
                            full_name =
                                path .. "/" .. entry,
                            full_rename =
                                path .. "/" .. rename
                        }
        local prefix = " "
        if names.full_name ~= names.full_rename then
            if params.execute == "true" then
                prefix = "executing: "
                os.rename(names.full_name, names.full_rename)
            end
            if params.verbose == "true" then
                print(prefix .. "renaming" .. names.full_name 
                    .. " to " .. names.full_rename)
            end
        ret = 1
        end
    end
    return ret
end

-- export the plugin
return {apply = apply}
