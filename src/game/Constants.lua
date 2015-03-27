------------------------------------------------------------------------------------------

TEXTURES_MAIN_FOLDER_NAME = 'res/texture/'
TEXTURES_DEFAULT_DESIGN_NAME = ''

------------------------------------------------------------------------------------------

BUTTON_DOUBLE_CLICK_MAX_DELAY = 0.5

------------------------------------------------------------------------------------------

DEFAULT_EDITBOX_FONT_NAME   = 'Roboto-Regular.ttf'
DEFAULT_EDITBOX_TEXTURE_BG  = 'texture/common/transparent.png'
DEFAULT_EDITBOX_PLACEHOLDER = 'data.placeholder'

------------------------------------------------------------------------------------------

--"American Typewriter",
--"Arial",
--"Arial Rounded MT Bold",
--"Courier New",
--"Georgia",
--"Helvetica",
--"Marker Felt",
--"Times New Roman",
--"Trebuchet MS",
--"Verdana",
--"Zapfino",

DEFAULT_FONT_NAME = 'Helvetica'
DEFAULT_FONT_NAME = 'Marker Felt.ttf'
DEFAULT_FONT_NAME = 'Roboto-Thin.ttf'
DEFAULT_FONT_SIZE = 32

if (Platform.isAndroid() or Platform.isOSX()) then
	DEFAULT_FONT_NAME         = 'res/fonts/' .. DEFAULT_FONT_NAME
	DEFAULT_EDITBOX_FONT_NAME = 'res/fonts/' .. DEFAULT_EDITBOX_FONT_NAME
end

------------------------------------------------------------------------------------------

COLOR_WHITE      = '#ffffff'
COLOR_RED        = '#ff0000'
COLOR_GREEN      = '#00ff00'
COLOR_BLUE       = '#0000ff'
COLOR_BLACK      = '#000000'
COLOR_YELLOW     = '#ffdb3c'
COLOR_GRAY       = '#c2c2c2'
COLOR_LIGHT_GRAY = '#e9e9e9'
COLOR_DARK_GRAY  = '#7f7f7f'

------------------------------------------------------------------------------------------