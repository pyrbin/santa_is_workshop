extends Control

func _ready():
	if (!game.game_over):
		$Guide.hide();
		$EndScreen.hide();
		$StartMenu.show();
	else:
		$Guide.hide();
		$EndScreen.show();
		audio_utils.play_audio($AudioStreamPlayer, game.sfx["game_over"]);
		$StartMenu.hide();

func button_pressed():
	audio_utils.play_audio($AudioStreamPlayer, game.sfx["button"]);

func _on_PlayButton_pressed():
	button_pressed();
	game.start_game()

func _on_TutorialButton_pressed():
	button_pressed();
	$Guide.show();
	$StartMenu.hide();
	$EndScreen.hide();
	
func _on_BackButton_pressed():
	button_pressed();
	get_tree().quit()

func _on_BackButton2_pressed():
	button_pressed();
	$Guide.hide();
	$EndScreen.hide();
	$StartMenu.show();

func _on_EndScreen_visibility_changed():
	$EndScreen/Score.text = str(game.score);
	
