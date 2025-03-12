#include <stdio.h>
int main(){
    char* c = "%ld x is 10";
    char c_ref = 'c';
    printf(c, c_ref);
}