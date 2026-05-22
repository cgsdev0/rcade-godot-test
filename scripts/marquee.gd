extends SubViewport



var enabled = false
var buf
var marquee
func _ready() -> void:
	$Label/AnimationPlayer.play("marquee")
	if OS.has_feature("web"):
		enabled = true
		marquee = JavaScriptBridge.get_interface("RCadeInput")
		marquee.take()
		buf = marquee.buf
		
const FPS = 30
const framerate = 1 / float(FPS)
var t = 0.0

func _process(delta: float) -> void:
	if !enabled: return
	t += delta
	if t > framerate:
		t = 0.0
		flip()

func flip():
	var img := get_texture().get_image()
	img.convert(Image.FORMAT_RGB8)
	var bytes := img.get_data()
	for i in bytes.size():
		buf[i] = bytes[i]
	marquee.flip()
