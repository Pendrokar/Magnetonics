-------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------
--
-- A collection of some useful functions
--
-------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------

Spring.Utilities = Spring.Utilities or {}

Spring.Echo("")

local SCRIPT_DIR = Script.GetName() .. '/'
local utilFiles = VFS.DirList(SCRIPT_DIR .. 'utilities/', "*.lua")
for i=1,#utilFiles do
  VFS.Include(utilFiles[i])
end