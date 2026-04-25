# tools/reparar_uids.gd
@tool
extends EditorScript

func _run():
	print("🔧 Iniciando reparación de UIDs...")
	
	# Directorio donde están tus piezas
	var directorio_piezas = "res://assets/modelos/piezas/"
	
	reparar_todos_los_archivos(directorio_piezas)
	print("✅ Reparación completada!")

func reparar_todos_los_archivos(directorio: String):
	var dir = DirAccess.open(directorio)
	if not dir:
		print("❌ No se puede abrir el directorio: ", directorio)
		return
	
	dir.list_dir_begin()
	var archivo = dir.get_next()
	var archivos_reparados = 0
	
	while archivo != "":
		var ruta_completa = directorio + archivo
		
		if archivo.ends_with(".tscn") or archivo.ends_with(".scn"):
			if reparar_archivo_tscn(ruta_completa):
				archivos_reparados += 1
		
		archivo = dir.get_next()
	
	dir.list_dir_end()
	print("📁 Archivos reparados: ", archivos_reparados)

func reparar_archivo_tscn(ruta: String) -> bool:
	# Leer el archivo
	var file = FileAccess.open(ruta, FileAccess.READ)
	if not file:
		print("❌ No se puede leer: ", ruta)
		return false
	
	var contenido = file.get_as_text()
	file.close()
	
	# Buscar y eliminar todos los UIDs inválidos
	var regex = RegEx.new()
	regex.compile("uid=\"[^\"]+\"\\s*")
	var nuevo_contenido = regex.sub(contenido, "", true)
	
	# También limpiar referencias a UIDs en líneas de recursos
	var regex2 = RegEx.new()
	regex2.compile("\\[ext_resource[^\\]]*uid=\"[^\"]+\"\\s*")
	nuevo_contenido = regex2.sub(nuevo_contenido, "[ext_resource ", true)
	
	if nuevo_contenido != contenido:
		# Guardar el archivo reparado
		file = FileAccess.open(ruta, FileAccess.WRITE)
		if not file:
			print("❌ No se puede escribir: ", ruta)
			return false
		
		file.store_string(nuevo_contenido)
		file.close()
		print("✅ Reparado: ", ruta.get_file())
		return true
	
	return false
