sampler s0 : register(s0);
float4 p0 : register(c0);
float4 p1 : register(c1);

#define width (p0[0])
#define height (p0[1])
#define counter (p0[2])
#define clock (p0[3])
#define one_over_width (p1[0])
#define one_over_height (p1[1])

#define PI acos(-1)
#define pixelSize 4 // minimum = 4

float4 main(float2 tex : TEXCOORD0) : COLOR
{

	int pixelX = (int)(tex.x*width);
	int pixelY = (int)(tex.y*height);
	int xType = (pixelX % pixelSize)/(pixelSize/4);
	int yType = (pixelY % (pixelSize*2))/(pixelSize);
	int row = (pixelY % pixelSize)*2/pixelSize;
	uint type = abs(xType + row) % 4;

	int sourcePixelX = pixelX - (pixelX % pixelSize) + xType * (pixelSize/4);
	int sourcePixelY = pixelY - (pixelY % pixelSize) + row * (pixelSize /2);
	float2 sourceTex = {one_over_width * sourcePixelX, one_over_height * sourcePixelY};
	float4 sourceColor = tex2D(s0, sourceTex);

	switch (type) {
		case 0:
			// Red
			sourceColor[1] = 0;
			sourceColor[2] = 0;
		break;
		case 1:
			// Green
			sourceColor[0] = 0;
			sourceColor[2] = 0;
		break;
		case 2:
			// Blue;
			sourceColor[1] = 0;
			sourceColor[0] = 0;
		break;
		case 3:
			// White
			float luminance = (sourceColor[0] + sourceColor[1] + sourceColor[2] )/3;
			float4 lumCol = {luminance, luminance, luminance, 0};
			sourceColor = lumCol;
		break;
	}
	return sourceColor;
}