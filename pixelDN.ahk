

; Path to image
imageFile := "image.png"

; Initialize GDIP and load image
GDIPToken := Gdip_Startup()
pBM := Gdip_CreateBitmapFromFile(imageFile)

; Get dimensions
W:= Gdip_GetImageWidth(pBM)
H:= Gdip_GetImageHeight(pBM)

; Get TOL deathnote rectangle
screenX := 700
screenY := 175
width = 520
height = 750

; Calculate the zoom factor and draw a centralized image
ratio := width/W
if (ratio > height/H)
{
    ratio := height/H
}
widthActual := W * ratio
heightActual := H * ratio
xOffset := (width - widthActual) / 2
yOffset := (height - heightActual) / 2

; Detect points and lines
drawBegin := 0
xBegin := 0
xEnd := 0

; Draw a portion of the image.
division := 3
drawDiv := 0

InputBox, drawDiv, Select Part to Draw, Enter 0 or 1 or 2

jFrom := H * drawDiv / division
jTo := H * (drawDiv + 1) / division

i := 0
j := jFrom
pixels := (jTo - jFrom) * W

; Looping and draw dark pixels
Loop, %pixels%
{
    ARGB := GDIP_GetPixel(pBM, i, j)
	B := ARGB & 255
	G := (ARGB >> 8) & 255
	R := (ARGB >> 16) & 255
    
    ; Calculate the target position of pixel
    x := screenX + xOffset + i * ratio
    y := screenY + yOffset + j * ratio
    
    ; Using only the blue channel
    if (B < 128)
    {
        if (drawBegin == 0)
        {
            drawBegin := 1
            xBegin := x
            xEnd := x
        }
        else
        {
            xEnd := x
        }
        ; MsgBox, From %xBegin% to %xEnd%
    }
    else
    {
        if (drawBegin == 1)
        {
            if (xBegin == xEnd)
            {
                ; Click on a point
                MouseMove, xBegin, y
                MouseClick, Left, xBegin, y
                ; MsgBox, MouseClick At %xBegin%, %y%
            }
            else
            {
                ; There is a straight line
                MouseMove, xBegin, y
                MouseClickDrag, Left, xBegin, y, xEnd, y, 7
                ; MsgBox, MouseClickDrag From %xBegin%, %y% to %xEnd%, %y%
            }
            drawBegin := 0
        }
    }
    
    ; Move to next pixel
    i := i + 1
    if (i == W)
    {
        i := 0
        j := j + 1
        drawBegin := 0
    }
}

; Clean resources
GDIP_DisposeImage(pBM)
GDIP_Shutdown(GDIPToken)
