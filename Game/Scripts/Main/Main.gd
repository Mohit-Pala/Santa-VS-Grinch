extends Node2D

var regenTimer
# Called when the node enters the scene tree for the first time.
func _ready():
	regenTimer = 10 * sin(4.5 / (Upgrades.regen + 3))
	$Health.max_value = Run.charHealth
	
	# start timers on run start
	$Regen.start(regenTimer)
	
	# replace with variables
	$Enemy.start(1)
	$Candy.start(5)
	$Snowball.start(1)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	$Health.value = Run.charHealth
	$Kills.text = "Kills: " + str(Run.enemiesKilled)


func _on_flee_pressed():
	get_tree().change_scene_to_file("res://Game/Scenes/Ui/Main Menu.tscn")


func _on_candy_timeout():
	for i in (Upgrades.amount + 1):
		var candy = load("res://Game/Scenes/Weapons/candy.tscn").instantiate()
		candy.position = $Santa.position
		add_child(candy)
		print("Spawned candy")
		await get_tree().create_timer(0.01).timeout


func _on_enemy_timeout():
	var screenSize = get_window().size
	
	for i in (Upgrades.curse + 1):
		var enemySpawn = randi_range(0,1)
		var enemy
		if (enemySpawn == 0):
			enemy = load("res://Game/Scenes/Enemies/Snowman.tscn").instantiate()
		else:
			enemy = load("res://Game/Scenes/Enemies/Cookie.tscn").instantiate()
			
		enemy.position.x = randi_range(0 , screenSize.x)
		enemy.position.y = randi_range(0 ,screenSize.y)
		add_child(enemy)
		print("Spawned Enemy")


func _on_regen_timeout():
	print("Gained 1 hp")
	Run.charHealth += 1


func _on_snowball_timeout():
	if(Shop.snowball):
		for i in (Upgrades.amount + 1):
			var snowball = load("res://Game/Scenes/Weapons/Snowball.tscn").instantiate()
			snowball.position = $Santa.position
			add_child(snowball)
			print("Spawned snowball")
			await get_tree().create_timer(0.1).timeout
	else:
		pass
