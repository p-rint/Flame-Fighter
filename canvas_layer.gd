extends CanvasLayer

@onready var scoreLabel: Label = $Score

@onready var animPlr: AnimationPlayer = $AnimationPlayer

var oldScore : int

@onready var plr = %Player
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.
	oldScore = plr.score


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if oldScore != plr.score:
		scoreLabel.text = str(plr.score)
		animPlr.play("ScoreUp")
		oldScore = plr.score
