extends Label

func _ready():
	sync_score();

func sync_score():
	text = str(game.score);
