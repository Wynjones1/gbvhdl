#include <stdio.h>

int main(int argc, char **argv)
{
	FILE *fp  = fopen("bin/DMG_ROM.bin", "rb");
	FILE *out = fopen("bin/DMG_ROM.mif", "w");
	unsigned char c = fgetc(fp);
	int i;
	while(!feof(fp))
	{
		for(i = 7; i >= 0; i--)
		{
			fputc((c >> i) & 0x1 ? '1' : '0', out);
		}
		fputc('\n', out);
		c = fgetc(fp);
	}
	return 0;
}
