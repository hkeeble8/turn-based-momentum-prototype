class_name SerializationUtils

static func serialized_dictionary_entries(source: Dictionary) -> Dictionary:
    var dict = {}
    for key in source.keys():
        dict[key] = source[key].serialize()
    return dict