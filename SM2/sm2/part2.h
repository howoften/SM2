#ifndef PART2_H
#define PART2_H

#include "SM2.h"

void test_part2(char **sm2_param, int type, int point_bit_length);


void sm2Sign(const char userAid[],int userIdDataLength,const char mingwen[],int mingwenDataLength,const char pa[],unsigned char px[],unsigned char py[],char *singResultR,char *singResultS);



int sm2CheckSign(char userAid[],int userIdDataLength,char mingwen[],int mingwenDataLength,unsigned char px[],unsigned char py[],char *singResultR,char *singResultS);

int sm2_gen_key(const char *pri_key, char *pub_key_x, char *pub_key_y);
    
#endif
