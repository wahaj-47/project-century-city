@tool
extends UserWidget

func initialize(data: Variant) -> void:
	if data is ControllerIconTexture:
		$PanelContainer/TextureRect.texture = data
