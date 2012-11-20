#!/usr/bin/env lua

-- This is a mutative ls program
--      ls lists the directory recursively as specified by the arguments
--      passed and uses the plugin specified to mutate files according to the
--      plugin's options.
--
--      arguments to the program are to be passed as followed
--      ls [dir] [options] [plugin] [plugin options]
--          dir : --directory="$DIR" : directory to list
--          options :
--              --recurse="$INT" :  how many times to recursively enter sub
--              directories
--              --plugins_path="$PATH" : where to locate the plugins
--          plugin :
--              --plugin="$PLUGIN" : which plugin to apply to the files
--          plugin options :
--              any left over arguments are used by the plugin

local lfs   = require "lfs"
local args  = require "args"
local path  = require "pl.path"

function require_args(args, ...)
    ret = true

    for k, v in ipairs{...} do
        if args[v] == nil then
            ret = false
            break
        end
    end

    return ret
end

function setup(args)
    local function setup_path(plugin_path)
        print(plugin_path)
        plugin_path = path.expanduser(plugin_path)
        if plugin_path:sub(-1) ~= "/" then
            plugin_path = plugin_path .. "/"
        end
        package.path = package.path .. ";" .. plugin_path .. "?.lua"
    end

    local dir, plugin, recurse, plugin_path

    if require_args(args, "directory", "plugins_path", "plugin", "recurse") then
        dir, plugin, recurse, plugin_path
            = path.expanduser(args.directory), args.plugin, args.recurse,
                args.plugins_path
                            
        setup_path(plugin_path)
    else
        print("sorry, RTFM, thx, bye")
        os.exit()
    end

    return dir, plugin, recurse, args
end

function attributes(entry)
    local attr = lfs.attributes(entry)
    local ret = "unknown"

    if attr ~= nil then
        ret = attr.mode
    end

    return { mode = ret }
end

function ls(path, plugin, data, allowed_recurse, parent, curr_recursion)
    local dirs = {}
    local recurse = curr_recursion
    local applied = 0
    local real_path = parent .. "/" .. path

    for entry in lfs.dir(real_path) do
        if entry ~= "." and entry ~= ".." then
            local attr = attributes(real_path .. "/" .. entry)
            if attr.mode == "directory" then
                table.insert(dirs, entry)
            end
            local app = require(plugin)
            applied = applied + app.apply(entry, real_path, attr, data)
        end
    end

    if allowed_recurse ~= 0 then
        allowed_recurse = allowed_recurse - 1
        for k, v in ipairs(dirs) do
            local l_applied, l_recurse 
              = ls(v, plugin, data, allowed_recurse, real_path, curr_recursion + 1)
            applied = applied + l_applied
            if recurse < l_recurse then
                recurse = l_recurse
            end
        end
    end

    return applied, recurse
end

local dir, plugin, recurse, args = setup(args.getopt(arg))
local applied, recursed = ls(dir, plugin, args, recurse, "", 0)
print(plugin .. " applied to " .. applied .. " files.")
print("ls recursed " .. recursed .. " levels of directories.")
