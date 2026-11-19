extends Node3D
## Slab House Tycoon — game loop, currency, shop state, screen switching.
## Milestone 1 skeleton: 3D shop room, UI shell, currency + save,
## buy a lot and receive a random card.

const SAVE_PATH := "user://slab_house_save.json"
const STARTING_CASH := 500

enum Screen { SHOP, SUPPLIER, PACK_OPENING, INSPECTION, GRADING, AUCTION, INVENTORY, UPGRADES }

var cash: int = STARTING_CASH
var inventory: Array = []  # Array of card dictionaries (see data/cards.json).
var card_data: Dictionary = {}
var current_screen: int = Screen.SHOP
var showcase_card: Node = null

@onready var currency_label: Label = $UI/TopBar/CurrencyLabel
@onready var screen_label: Label = $UI/TopBar/ScreenLabel
@onready var message_label: Label = $UI/MessageLabel
@onready var buy_button: Button = $UI/BuyLotButton
@onready var flip_button: Button = $UI/FlipCardButton

func _ready() -> void:
	showcase_card = $ShowcaseCard
	_load_card_data()
	_load_save()
	_update_currency_label()
	buy_button.pressed.connect(_on_buy_lot_pressed)
	flip_button.pressed.connect(_on_flip_card_pressed)
	set_screen(Screen.SHOP)

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("buy_lot"):
		_on_buy_lot_pressed()
	elif event.is_action_pressed("flip_card"):
		_on_flip_card_pressed()

# --- Screens ----------------------------------------------------------------

func set_screen(screen: int) -> void:
	current_screen = screen
	screen_label.text = Screen.keys()[screen].capitalize().replace("_", " ")

# --- Economy ----------------------------------------------------------------

func buy_lot(lot_id: String = "starter_sports") -> Dictionary:
	var lots: Array = card_data.get("lots", [])
	for lot in lots:
		if lot.get("id") == lot_id:
			var price: int = int(lot.get("price", 0))
			if cash < price:
				return {"ok": false, "reason": "Not enough cash for that lot."}
			cash -= price
			var pulled: Array = []
			for i in int(lot.get("cards_per_lot", 1)):
				pulled.append(_pull_random_card(lot))
			inventory.append_array(pulled)
			_update_currency_label()
			_save()
			return {"ok": true, "cards": pulled, "spent": price}
	return {"ok": false, "reason": "Unknown lot: %s" % lot_id}

func card_value(card: Dictionary) -> int:
	var base: int = int(card.get("base_value", 0))
	var grade: int = int(card.get("grade", 0))
	if grade <= 0:
		return base
	# Grade multipliers: a pristine 10 is worth 5x, a 9 is 3x, an 8 is 2x.
	var mult := {10: 5.0, 9: 3.0, 8: 2.0, 7: 1.5, 6: 1.2, 5: 1.0}.get(grade, 0.8)
	return int(round(base * mult))

# --- Card pulls ---------------------------------------------------------------

func _pull_random_card(lot: Dictionary) -> Dictionary:
	var pool: Array = []
	for card in card_data.get("cards", []):
		if card.get("set") in lot.get("sets", []):
			pool.append(card)
	if pool.is_empty():
		pool = card_data.get("cards", [])
	var template: Dictionary = (pool[randi() % pool.size()] as Dictionary).duplicate(true)
	# Hidden true condition (0.0–1.0) drives the Inspection Desk and grading.
	template["true_condition"] = randf_range(0.55, 1.0)
	template["grade"] = 0
	template["inspected"] = false
	return template

# --- Data / save ---------------------------------------------------------------

func _load_card_data() -> void:
	var file := FileAccess.open("res://data/cards.json", FileAccess.READ)
	if file == null:
		push_warning("cards.json not found; card pool is empty.")
		return
	var parsed: Variant = JSON.parse_string(file.get_as_text())
	if parsed is Dictionary:
		card_data = parsed

func _load_save() -> void:
	if not FileAccess.file_exists(SAVE_PATH):
		return
	var file := FileAccess.open(SAVE_PATH, FileAccess.READ)
	var parsed: Variant = JSON.parse_string(file.get_as_text())
	if parsed is Dictionary:
		cash = int(parsed.get("cash", STARTING_CASH))
		inventory = parsed.get("inventory", [])

func _save() -> void:
	var file := FileAccess.open(SAVE_PATH, FileAccess.WRITE)
	file.store_string(JSON.stringify({"cash": cash, "inventory": inventory}))

# --- UI hooks ------------------------------------------------------------------

func _update_currency_label() -> void:
	currency_label.text = "Cash: $%d" % cash

func _on_buy_lot_pressed() -> void:
	var result: Dictionary = buy_lot()
	if result["ok"]:
		var first: Dictionary = (result["cards"] as Array)[0]
		message_label.text = "Pulled: %s (%s) — %d card(s) added to inventory." % [
			first.get("name", "?"), first.get("rarity", "?"), (result["cards"] as Array).size()
		]
		if showcase_card != null and showcase_card.has_method("show_card"):
			showcase_card.show_card(first)
	else:
		message_label.text = result["reason"]

func _on_flip_card_pressed() -> void:
	if showcase_card != null and showcase_card.has_method("flip"):
		showcase_card.flip()
