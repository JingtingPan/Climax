extends Node

@onready var bgm_player = $AudioStreamPlayer  # 确保场景里有 AudioStreamPlayer
var entropy_level: int = 0  # 设定初始熵值

# 预加载 3 个不同的 BGM
var bgm_list = [
	preload("res://entro/Music/Entropy low.ogg"),
	preload("res://entro/Music/Entropy mid.ogg"),
	preload("res://entro/Music/Entropy high.ogg")
]

func _ready():
	update_bgm()  # 初始化 BGM 播放

# 当熵值变化时调用此函数
func set_entropy(new_level):
	if new_level != entropy_level:  # 只有在熵值变化时才切换 BGM
		entropy_level = new_level
		update_bgm()

func update_bgm():
	var bgm_index = 0  # 默认低熵 BGM
	
	if entropy_level >= 5 and entropy_level < 8:
		bgm_index = 1  # 中等熵 BGM
	elif entropy_level >= 8:
		bgm_index = 2  # 高熵 BGM
	
	if bgm_player.stream != bgm_list[bgm_index]:  # 只在 BGM 改变时播放新曲目
		bgm_player.stream = bgm_list[bgm_index]
		bgm_player.play()
