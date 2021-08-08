(pair
  (string
    (string_content) @_key)
  (object
    (pair
      (string
        (string_content) @key)
      (string
        (string_content) @value)
    )
  )
  (#any-of? @_key "devDependencies" "dependencies" "peerDependencies")
)
