extends Resource
class_name OleadasData

static var estructura_por_nivel = {
	0: [
		{"pos": Vector2i(11,0), "tipo":1, "blancas":false},
		{"pos": Vector2i(15,3), "tipo":2, "blancas":false},
		{"pos": Vector2i(15,0), "tipo":5, "blancas":false},
		{"pos": Vector2i(12,5), "tipo":4, "blancas":false},
		{"pos": Vector2i(14,8), "tipo":3, "blancas":false}
	],
	1: [
		{"pos": Vector2i(9,5), "tipo":1, "blancas":false},
		{"pos": Vector2i(10,6), "tipo":1, "blancas":false}
	],
	2: [
		{"pos": Vector2i(8,3), "tipo":1, "blancas":false},
		{"pos": Vector2i(12,7), "tipo":1, "blancas":false},
		{"pos": Vector2i(10,5), "tipo":1, "blancas":false}
	],
	3: [
		{"pos": Vector2i(8,1), "tipo":1, "blancas":false},
		{"pos": Vector2i(8,2), "tipo":1, "blancas":false},
		{"pos": Vector2i(12,3), "tipo":1, "blancas":false},
		{"pos": Vector2i(13,7), "tipo":1, "blancas":false},
		{"pos": Vector2i(14,7), "tipo":1, "blancas":false}
	],
	4: [
		{"pos": Vector2i(9,0), "tipo":1, "blancas":false},
		{"pos": Vector2i(15,6), "tipo":1, "blancas":false},
		{"pos": Vector2i(13,1), "tipo":1, "blancas":false},
		{"pos": Vector2i(14,2), "tipo":1, "blancas":false},
		{"pos": Vector2i(9,4), "tipo":1, "blancas":false},
		{"pos": Vector2i(12,6), "tipo":1, "blancas":false}
	],
	5: [
		{"pos": Vector2i(9,3), "tipo":1, "blancas":false},
		{"pos": Vector2i(12,6), "tipo":1, "blancas":false},
		{"pos": Vector2i(10,5), "tipo":2, "blancas":false}
	],
	6: [ 
		{"pos": Vector2i(8,3), "tipo":2, "blancas":false},
		{"pos": Vector2i(10,3), "tipo":2, "blancas":false},
		{"pos": Vector2i(12,7), "tipo":2, "blancas":false},
		{"pos": Vector2i(11,5), "tipo":2, "blancas":false}
	],
	7: [
		{"pos": Vector2i(8,1), "tipo":2, "blancas":false},
		{"pos": Vector2i(14,7), "tipo":2, "blancas":false},
		{"pos": Vector2i(12,1), "tipo":1, "blancas":false},
		{"pos": Vector2i(14,3), "tipo":1, "blancas":false},
		{"pos": Vector2i(12,3), "tipo":2, "blancas":false}
	],
	8: [
		{"pos": Vector2i(9,1), "tipo":1, "blancas":false},
		{"pos": Vector2i(14,6), "tipo":1, "blancas":false},
		{"pos": Vector2i(10,2), "tipo":2, "blancas":false},
		{"pos": Vector2i(13,5), "tipo":2, "blancas":false},
		{"pos": Vector2i(11,3), "tipo":2, "blancas":false},
		{"pos": Vector2i(12,4), "tipo":1, "blancas":false}
	],
	9:[
		{"pos": Vector2i(13,0), "tipo":2, "blancas":false},
		{"pos": Vector2i(15,2), "tipo":2, "blancas":false},
		{"pos": Vector2i(13,2), "tipo":2, "blancas":false},
		{"pos": Vector2i(9,5), "tipo":2, "blancas":false},
		{"pos": Vector2i(10,6), "tipo":2, "blancas":false}
	],
	10:[
		{"pos": Vector2i(9,4), "tipo":2, "blancas":false},
		{"pos": Vector2i(11,6), "tipo":2, "blancas":false},
		{"pos": Vector2i(12,2), "tipo":1, "blancas":false},
		{"pos": Vector2i(13,3), "tipo":1, "blancas":false},
		{"pos": Vector2i(10,0), "tipo":2, "blancas":false},
		{"pos": Vector2i(15,5), "tipo":2, "blancas":false},
		{"pos": Vector2i(15,0), "tipo":2, "blancas":false}
	],
	11:[
		{"pos": Vector2i(8,3), "tipo":1, "blancas":false},
		{"pos": Vector2i(12,7), "tipo":1, "blancas":false},
		{"pos": Vector2i(9,4), "tipo":3, "blancas":false},
		{"pos": Vector2i(11,6), "tipo":3, "blancas":false}
		],
	12:[
		{"pos": Vector2i(10,0), "tipo":3, "blancas":false},
		{"pos": Vector2i(15,5), "tipo":3, "blancas":false},
		{"pos": Vector2i(9,1), "tipo":1, "blancas":false},
		{"pos": Vector2i(14,6), "tipo":1, "blancas":false},
		{"pos": Vector2i(10,2), "tipo":3, "blancas":false},
		{"pos": Vector2i(13,5), "tipo":3, "blancas":false},
		{"pos": Vector2i(11,3), "tipo":1, "blancas":false},
		{"pos": Vector2i(12,4), "tipo":1, "blancas":false}
	],
	13:[
		{"pos": Vector2i(9,5), "tipo":2, "blancas":false},
		{"pos": Vector2i(10,6), "tipo":2, "blancas":false},
		{"pos": Vector2i(10,3), "tipo":3, "blancas":false},
		{"pos": Vector2i(13,6), "tipo":3, "blancas":false}
		],
	14:[
		{"pos": Vector2i(10,5), "tipo":2, "blancas":false},
		{"pos": Vector2i(11,4), "tipo":1, "blancas":false},
		{"pos": Vector2i(12,3), "tipo":1, "blancas":false},
		#{"pos": Vector2i(14,3), "tipo":3, "blancas":false},
		#{"pos": Vector2i(12,1), "tipo":3, "blancas":false}
	],
	15:[
		{"pos": Vector2i(9,5), "tipo":1, "blancas":false},
		{"pos": Vector2i(10,6), "tipo":1, "blancas":false},
		{"pos": Vector2i(9,3), "tipo":1, "blancas":false},
		{"pos": Vector2i(12,6), "tipo":1, "blancas":false},
		{"pos": Vector2i(8,3), "tipo":3, "blancas":false},
		{"pos": Vector2i(12,7), "tipo":3, "blancas":false},
		{"pos": Vector2i(9,1), "tipo":3, "blancas":false},
		{"pos": Vector2i(14,6), "tipo":3, "blancas":false},
		{"pos": Vector2i(11,2), "tipo":2, "blancas":false},
		{"pos": Vector2i(13,4), "tipo":2, "blancas":false},
		{"pos": Vector2i(13,2), "tipo":2, "blancas":false}
	],
	16:[
		{"pos": Vector2i(9,5), "tipo":2, "blancas":false},
		{"pos": Vector2i(10,6), "tipo":2, "blancas":false},
		{"pos": Vector2i(13,1), "tipo":4, "blancas":false},
		{"pos": Vector2i(14,2), "tipo":4, "blancas":false}
	],
	17:[
		{"pos": Vector2i(9,3), "tipo":1, "blancas":false},
		{"pos": Vector2i(9,5), "tipo":2, "blancas":false},
		{"pos": Vector2i(10,6), "tipo":2, "blancas":false},
		{"pos": Vector2i(12,6), "tipo":1, "blancas":false},
		{"pos": Vector2i(13,1), "tipo":4, "blancas":false},
		{"pos": Vector2i(14,2), "tipo":4, "blancas":false}
	],
	18:[
		{"pos": Vector2i(9,5), "tipo":1, "blancas":false},
		{"pos": Vector2i(10,6), "tipo":1, "blancas":false},
		{"pos": Vector2i(14,1), "tipo":2, "blancas":false},
		{"pos": Vector2i(11,1), "tipo":4, "blancas":false},
		{"pos": Vector2i(8,3), "tipo":4, "blancas":false},
		{"pos": Vector2i(12,7), "tipo":4, "blancas":false},
		{"pos": Vector2i(14,4), "tipo":4, "blancas":false}
	],
	19:[
		{"pos": Vector2i(8,1), "tipo":3, "blancas":false},
		{"pos": Vector2i(8,3), "tipo":3, "blancas":false},
		{"pos": Vector2i(12,7), "tipo":3, "blancas":false},
		{"pos": Vector2i(14,7), "tipo":3, "blancas":false},
		{"pos": Vector2i(9,5), "tipo":2, "blancas":false},
		{"pos": Vector2i(10,6), "tipo":2, "blancas":false},
		{"pos": Vector2i(11,0), "tipo":4, "blancas":false},
		{"pos": Vector2i(12,1), "tipo":4, "blancas":false},
		{"pos": Vector2i(14,3), "tipo":4, "blancas":false},
		{"pos": Vector2i(15,4), "tipo":4, "blancas":false}
	],
	20:[
		{"pos": Vector2i(9,5), "tipo":1, "blancas":false},
		{"pos": Vector2i(10,6), "tipo":1, "blancas":false},
		{"pos": Vector2i(11,1), "tipo":4, "blancas":false},
		{"pos": Vector2i(14,3), "tipo":4, "blancas":false},
		{"pos": Vector2i(10,3), "tipo":2, "blancas":false},
		{"pos": Vector2i(11,4), "tipo":2, "blancas":false},
		{"pos": Vector2i(12,5), "tipo":2, "blancas":false},
		{"pos": Vector2i(13,2), "tipo":2, "blancas":false},
		{"pos": Vector2i(8,1), "tipo":3, "blancas":false},
		{"pos": Vector2i(14,7), "tipo":3, "blancas":false},
		{"pos": Vector2i(15,1), "tipo":5, "blancas":false},
	]
}
