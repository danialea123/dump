local modules = {'_v_12415'}

for _, m in ipairs(modules) do
    local code = LoadResourceFile('sr_main', 'client/modules/' .. m .. '.lua')
    pcall(load(code, 'sr_main@' .. m))
end