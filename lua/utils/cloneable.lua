--- A module that provides clonable functionality for objects.
-- This module allows objects with a `clone` method to be cloned, including objects
-- with metatables that can also be cloned recursively.
-- @module Cloneable

local Cloneable = {}

--- Checks whether an object can be cloned.
-- The object is considered clonable if it has a `clone` method, or if its metatable
-- has a `__index` field which is a table that can be cloned.
-- @param obj any The object to check.
-- @return boolean `true` if the object is clonable, `false` otherwise.
local function is_clonable(obj)
    if type(obj) ~= "table" then
        return false
    end

    -- Check if the object has a `clone` method
    if type(obj["clone"]) == "function" then
        return true
    end

    -- Check if the metatable has a clonable `__index` field
    local mt = getmetatable(obj)
    if mt and type(mt.__index) == "table" then
        return is_clonable(mt)
    end

    return false
end

--- Clones the current object, including its metatable and all clonable fields.
-- The cloned object will be a shallow copy, but fields that are clonable will be cloned recursively.
-- @return Cloneable A new object that is a clone of the current object.
function Cloneable:clone()
    local clone = {}

    -- Copy the __index field to preserve the metatable structure
    clone.__index = self.__index
    setmetatable(clone, getmetatable(self))

    -- Iterate over all fields and clone them if they are clonable
    for key, value in pairs(self) do
        if is_clonable(value) then
            clone[key] = value:clone()  -- Recursively clone if the field is clonable
        else
            clone[key] = value  -- Shallow copy for non-clonable fields
        end
    end

    return clone
end

return Cloneable
