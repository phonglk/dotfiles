local status, monokai = pcall(require, "ofirkai")
if (not status) then return end
monokai.setup {}
