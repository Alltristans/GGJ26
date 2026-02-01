extends TextureRect

@export var gender: CharacterResourceManager.Gender = CharacterResourceManager.Gender.ANY

func _ready() -> void:
    var tex = CharacterResourceManager.get_random_character_texture(gender)
    if tex:
        texture = tex