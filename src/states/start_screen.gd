extends Control

func _ready():
	if (!game.game_over):
		$Guide.hide();
		$EndScreen.hide();
		$StartMenu.show();
	else:
		$Guide.hide();
		$EndScreen.show();
		$StartMenu.hide();
		
func _on_PlayButton_pressed():
	game.start_game()

func _on_TutorialButton_pressed():
	$Guide.show();
	$StartMenu.hide();
	$EndScreen.hide();
	
func _on_BackButton_pressed():
	get_tree().quit()

func _on_BackButton2_pressed():
	$Guide.hide();
	$EndScreen.hide();
	$StartMenu.show();

func _on_EndScreen_visibility_changed():
	$EndScreen/Score.text = str(game.score);
	
