(pair
  (string
    (string_content) @_key)
  (object)
  (#any-of? @_key "devDependencies" "dependencies" "peerDependencies")
) @dependency_type
