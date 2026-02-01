extends Node
class_name CharacterResourceManager

# Character texture pools
const MALE_CHARACTERS = [
	"res://asset/InGame/characters/male/sheet male example.png"
	# Tambahkan lebih banyak male character di sini
]

const FEMALE_CHARACTERS = [
	# Tambahkan female character di sini ketika asset tersedia
]

const MASK_ACCESSORIES = [
	"res://asset/InGame/characters/mask/IMG_3672.PNG",
	"res://asset/InGame/characters/mask/IMG_3673.PNG",
	"res://asset/InGame/characters/mask/IMG_3674.PNG",
	"res://asset/InGame/characters/mask/IMG_3675.PNG",
	"res://asset/InGame/characters/mask/IMG_3676.PNG",
	"res://asset/InGame/characters/mask/IMG_3677.PNG",
	"res://asset/InGame/characters/mask/IMG_3678.PNG",
	"res://asset/InGame/characters/mask/IMG_3679.PNG"
]

# Character appearance configuration
enum Gender { MALE, FEMALE, ANY }
enum AccessoryType { NONE, MASK }

static func get_random_character_texture(gender: Gender = Gender.ANY) -> Texture2D:
	var texture_pool: Array = []
	
	match gender:
		Gender.MALE:
			texture_pool = MALE_CHARACTERS
		Gender.FEMALE:
			texture_pool = FEMALE_CHARACTERS if FEMALE_CHARACTERS.size() > 0 else MALE_CHARACTERS
		Gender.ANY:
			texture_pool = MALE_CHARACTERS + FEMALE_CHARACTERS
			if texture_pool.size() == 0:
				texture_pool = MALE_CHARACTERS
	
	if texture_pool.size() == 0:
		push_error("No character textures available!")
		return null
	
	var random_index = randi() % texture_pool.size()
	return load(texture_pool[random_index])

static func get_random_accessory(type: AccessoryType = AccessoryType.MASK) -> Texture2D:
	match type:
		AccessoryType.MASK:
			if MASK_ACCESSORIES.size() > 0:
				var random_index = randi() % MASK_ACCESSORIES.size()
				return load(MASK_ACCESSORIES[random_index])
		AccessoryType.NONE:
			return null
	return null

static func should_have_accessory(suspicion_level: int) -> bool:
	# Higher suspicion = higher chance of mask
	# Suspicion 0-40 (innocent): 20-40% chance
	# Suspicion 60-100 (suspicious): 60-100% chance
	var chance = clamp(suspicion_level / 100.0, 0.2, 0.7)
	return randf() < chance
