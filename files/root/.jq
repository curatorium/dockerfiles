#
# Flatten a deeply nested object into keypath/value pairs.
def flatten: [
  leaf_paths as $paths | {
    "key": $paths | join("."),
    "value": getpath($paths)
  }
] | from_entries;

def unflatten:
 reduce to_entries[] as $kv (
    {}; setpath($kv.key|split("."); $kv.value)
);
