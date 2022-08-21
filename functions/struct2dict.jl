function struct_to_dict(s)
  return Dict(key => getfield(s, key) for key in propertynames(s))
end

