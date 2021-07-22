extends Node

const red = Color(0.7,0.13,0.13,1)
const green = Color(0.18,0.55,0.34,1)
const yellow = Color(0.85,0.65,0.13,1)
const blue = Color(0.1,0.1,0.44,1)
const wild = Color(0.44,0.5,0.56,1)
const facedown = Color(0,0,0,1)

const playable = Color(0.58,0,0.83,1)
const hover = Color(0.97,0.97,1,1)

enum card_colour {
	RED, 
	GREEN, 
	BLUE, 
	YELLOW, 
	WILD,
}

enum card_type {
	CARD_0, 
	CARD_1, 
	CARD_2, 
	CARD_3, 
	CARD_4, 
	CARD_5, 
	CARD_6, 
	CARD_7, 
	CARD_8, 
	CARD_9, 
	CARD_SKIP, 
	CARD_REVERSE, 
	CARD_PLUS2, 
	CARD_PLUS4, 
	CARD_WILD,
}

enum pickup_type {
	NULL, 
	PLUS2, 
	PLUS4,
}
