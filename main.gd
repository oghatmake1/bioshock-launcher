extends Node2D

@onready var player: AudioStreamPlayer2D = $Music
@onready var back: TextureRect = $Background
@onready var sel: ItemList = $Games
var current_track: String = ""

func exit():
	get_tree().quit()

func _process(_delta) -> void:
	var onesel: bool = sel.is_selected(0) or sel.is_selected(1)
	var twosel: bool = sel.is_selected(2) or sel.is_selected(3)
	var infsel: bool = sel.is_selected(4)

	if onesel and current_track != "res://Music/1.mp3":
		play_sound("res://Music/1.mp3")
		change_texture("res://Backgrounds/1.webp")
	elif twosel and current_track != "res://Music/2.mp3":
		play_sound("res://Music/2.mp3")
		change_texture("res://Backgrounds/2.webp")
	elif infsel and current_track != "res://Music/Infinite.mp3":
		play_sound("res://Music/Infinite.mp3")
		change_texture("res://Backgrounds/Infinite.webp")

func play_sound(audio_path: String):
	var new_audio_stream: AudioStream = load(audio_path)
	player.stream = new_audio_stream
	player.play()
	current_track = audio_path  # update current track
	if not new_audio_stream:
		push_error("No such audio" + audio_path)
		OS.alert("Memory Access Violation\nNo such audio.\n" + audio_path, "Catastrophic Error!")
		exit()

func change_texture(new_texture_path):
	var new_texture = load(new_texture_path)
	if new_texture is Texture2D:
		back.texture = new_texture
	if not new_texture:
		push_error("No such image" + new_texture_path)
		OS.alert("Memory Access Violation\nNo such image\n" + new_texture_path, "Catastrophic Error!")
		exit()

func Play_pressed() -> void:
	var sup = ["Windows", "Linux", "macOS"]
	if OS.get_name() in sup:
		open_game()

func open_game():
	const inc = preload("res://Common/constants.gd")
	var gameslist = inc.gamelist
	for i in len(gameslist):
		if $Games.is_selected(i):
			var link = "steam://run/" + str(gameslist[i])
			OS.shell_open(link)
			exit()
