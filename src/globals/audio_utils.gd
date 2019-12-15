extends Node2D

func play_audio(asp: AudioStreamPlayer, ast: AudioStream, pos: float = 0):
	asp.stream = ast;
	asp.play(pos);