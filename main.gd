extends Node2D

@onready var player: AudioStreamPlayer2D = $Music
@onready var back: TextureRect = $Background
@onready var sel: ItemList = $Games

@onready var current_track: String = ""
@onready var args_flags = {} 

func _ready():
	var language = "automatic"
	# Load here language from the user settings file
	if language == "automatic":
		var preferred_language = OS.get_locale_language()
		TranslationServer.set_locale(preferred_language)
	else:
		TranslationServer.set_locale(language)
	args_flags = parse_flags() 
	$Play.text = tr("start")
	args_flags = parse_flags() 
	sel.select(0)
	
func parse_flags() -> Dictionary:
	var out = {"noimg": false, "nosnd": false}
	var args = OS.get_cmdline_args()
	for i in range(args.size()):
		if args[i] == "-noimg":
			out.noimg = true
		elif args[i] == "-nosnd":
			out.nosnd = true
	return out

func _process(_delta: float) -> void:
	var onesel = sel.is_selected(0) or sel.is_selected(1)
	var twosel = sel.is_selected(2) or sel.is_selected(3)
	var infsel = sel.is_selected(4)

	if onesel and current_track != "res://Music/1.mp3":
		play_sound("res://Music/1.mp3")
		change_texture("res://Backgrounds/1.exr")
	elif twosel and current_track != "res://Music/2.mp3":
		play_sound("res://Music/2.mp3")
		change_texture("res://Backgrounds/2.exr")
	elif infsel and current_track != "res://Music/Infinite.mp3":
		play_sound("res://Music/Infinite.mp3")
		change_texture("res://Backgrounds/Infinite.exr")
	if Input.is_action_just_pressed("Play"):
		open_game()

func play_sound(audio_path: String):
	if args_flags["nosnd"]:
		return

	var new_audio_stream: AudioStream = load(audio_path)
	if not new_audio_stream:
		push_error("No such audio: " + audio_path)
		OS.alert("Memory Access Violation\nNo such audio:\n" + audio_path, "Catastrophic Error!")
		exit()

	player.stream = new_audio_stream
	player.play()
	current_track = audio_path

func change_texture(new_texture_path: String):
	if args_flags["noimg"]:
		return  # skip if no image flag is set

	var new_texture = load(new_texture_path)
	if not new_texture:
		push_error("No such image: " + new_texture_path)
		OS.alert("Memory Access Violation\nNo such image:\n" + new_texture_path, "Catastrophic Error!")
		exit()

	if new_texture is Texture2D:
		back.texture = new_texture

func Play_pressed() -> void:
	var supported_os = ["Windows", "Linux", "macOS"]
	if OS.get_name() in supported_os:
		open_game()

func open_game():
	const inc = preload("res://Common/constants.gd")
	var gameslist = inc.gamelist

	for i in range(len(gameslist)):
		if sel.is_selected(i):
			var link = "steam://run/" + str(gameslist[i])
			OS.shell_open(link)
			exit()

func exit():
	get_tree().quit()
