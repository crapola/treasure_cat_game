# Create emoji sprite sheet.

from PIL import Image, ImageDraw, ImageFont

def main()->None:
	emojis=u"⚪⚫💀🕷️🕸️👻😺🐭🐯💰❤️💣🥾🗡️💥✨ "
	output="../objects.png"
	image:Image.Image=emoji_spritesheet(emojis)
	image.show()
	image.save(output,format="PNG",optimize=True,compress_level=9)

def emoji_spritesheet(emojis:str)->Image.Image:
	# Turn into list of character.
	char_list:list=[]
	for e in zip(emojis,emojis[1:]):
		if ord(e[0])!=65039:
			char_list.append(e[0])
	# Draw image.
	w:int=256
	char_size:int=64
	img:Image.Image=Image.new("RGBA",(w,w))
	draw:ImageDraw.ImageDraw=ImageDraw.Draw(img)
	font:ImageFont.FreeTypeFont=ImageFont.truetype("seguiemj.ttf",char_size-6)
	show_boxes:bool=False
	for i,e in enumerate(char_list):
		x:int=(char_size*i)%w
		y:int=(i//(w//char_size))*char_size
		pos=(x-8,y+10)
		if show_boxes:
			if ((x+y)%(2*char_size)):
				draw.rectangle((x,y,x+char_size-1,y+char_size-1),"red",None,0)
		draw.text(pos,e,None,font,embedded_color=True)
	return img.convert(mode='P',palette=Image.Palette.ADAPTIVE)

if __name__=="__main__":
	main()