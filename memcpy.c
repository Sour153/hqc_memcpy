#include <stdio.h>
#include <float.h>

#define DOUBLE_MAX DBL_MAX

// #include <sys/time.h>

#ifndef CPY_TYPE
#define CPY_TYPE int
#endif

#ifndef CPY_ARRAY_SIZE
#define CPY_ARRAY_SIZE 200000000
#endif

#define MIN(a,b) (a)>(b)?(b):(a)

#define M 10

typedef void*(*MEM)(void*,const void*,size_t);

extern double mysecond();           //外部变量

static CPY_TYPE a[CPY_ARRAY_SIZE],b[CPY_ARRAY_SIZE];
static double bytes = 2*sizeof(CPY_TYPE)*CPY_ARRAY_SIZE;




 
void *fast_memcpy(void *dst, const void *src, size_t length)
{
    union{
        char *lpstr;
        long *lpint;
    }s;
    union{
        char *lpstr;
        long *lpint;
    }d;
    
    char *suffix = (void*)(((long)src) + length);
    char *prefix = (void*)(((long)src) & (~(sizeof(long)-1)));
    long *middle = (void*)(((long)suffix) & (~(sizeof(long)-1)));
 
    
    s.lpstr = (void*)src;
    d.lpstr = (void*)dst;
    
    if (prefix != src)
    {
        while(s.lpstr < prefix + sizeof(long))
        {
            *d.lpstr++ = *s.lpstr ++;
        }
    }
 
    while(s.lpint < middle - (sizeof(long) * 8))
    {
        *d.lpint++ = *s.lpint ++;
        *d.lpint++ = *s.lpint ++;
        *d.lpint++ = *s.lpint ++;
        *d.lpint++ = *s.lpint ++;
        *d.lpint++ = *s.lpint ++;
        *d.lpint++ = *s.lpint ++;
        *d.lpint++ = *s.lpint ++;
        *d.lpint++ = *s.lpint ++;
    }
 
    while(s.lpint < middle - (sizeof(long) * 4))
    {
        *d.lpint++ = *s.lpint ++;
        *d.lpint++ = *s.lpint ++;
        *d.lpint++ = *s.lpint ++;
        *d.lpint++ = *s.lpint ++;
    }
 
    while(s.lpint < middle - (sizeof(long) * 2))
    {
        *d.lpint++ = *s.lpint ++;
        *d.lpint++ = *s.lpint ++;
    }
 
    while(s.lpint < middle) *d.lpint++ = *s.lpint ++;
    while(s.lpstr < suffix) *d.lpstr++ = *s.lpstr ++;
 
    return dst;    
}
 
void *my_memcpy4(void *dst, const void *src, size_t length)
{
    if ((((long)src) & (~(sizeof(long)-1))) != (((long)dst) & (~(sizeof(long)-1))))
    {
        char *lpSrc = (void*)src;
        char *lpDst = (void*)dst;
        char *lpTail = lpSrc + length;
        
        while(lpSrc < lpTail) *lpDst ++ = *lpSrc ++;
        
        return dst;
    }
    
    return fast_memcpy(dst, src, length);
}


/*
    @memcpy:将一块内存拷贝至另一块内存
    @dest：目标内存指针
    @src：源内存指针
    @size：拷贝空间大小(单位字节)
*/
void* my_memcpy1(void *dest,const void *src,size_t size)
{
    char* c_dest = (char*)dest;
    const char* c_src = (char*) src;
    if(c_dest < c_src)
    {
        while(size-- >0)
        {
            *(c_dest++) = *(c_src++);
        }
    }
    else
    {
        char* d = c_dest + size -1;
        const char* s = c_src + size -1;
        while(size-- > 0)
        {
            *(d--) = *(s--);
        }
    }
    return dest;
    
}
void* my_memcpy2(void *dest,const void *src,size_t size)
{
    char* c_dest = (char*)dest;
    char* c_src = (char*) src;
    size_t loop = size%10;
    if(c_dest < c_src)
    {
// #pragma omp parallel for
        for(int i=0;i<size;i+=10)
        {
            c_dest[i] = c_src[i];
            c_dest[i+1] = c_src[i+1];
            c_dest[i+2] = c_src[i+2];
            c_dest[i+3] = c_src[i+3];
            c_dest[i+4] = c_src[i+4];
            c_dest[i+5] = c_src[i+5];
            c_dest[i+6] = c_src[i+6];
            c_dest[i+7] = c_src[i+7];
            c_dest[i+8] = c_src[i+8];
            c_dest[i+9] = c_src[i+9];
        }
        if(loop!=0)
        {
            for(int i=size-loop;i<size;i++)
            {
                c_dest[i] = c_src[i];
            }
        }
        
    }
    else
    {
        char* d = c_dest + size -1;
        const char* s = c_src + size -1;
// #pragma omp parallel for
        for(int i=size-1;i>=0;i-=10)
        {
            d[i] = s[i];
            d[i-1] = s[i-1];
            d[i-2] = s[i-2];
            d[i-3] = s[i-3];
            d[i-4] = s[i-4];
            d[i-5] = s[i-5];
            d[i-6] = s[i-6];
            d[i-7] = s[i-7];
            d[i-8] = s[i-8];
            d[i-9] = s[i-9];
        }
        if(loop!=0)
        {
            for(int i=0;i<loop;i++)
            {
                c_dest[i] = c_src[i];
            }
        }
    }
    
    return dest;
}

/*
    @memcpy:将一块内存拷贝至另一块内存
    @dest：目标内存指针
    @src：源内存指针
    @size：拷贝空间大小(单位字节)
*/
void* my_memcpy3(void *dest,const void *src,size_t size)
{
    long* c_dest = (long*)dest;
    long* c_src = (long*) src;
    size_t cache_line_size = sizeof(long);
    size_t loop_size = size - (size%cache_line_size);
    size_t num = loop_size/cache_line_size;
    //从前往后copy
    if(c_dest < c_src)
    {
// #pragma omp parallel for
        for(int i=0;i<num;i++)
        {
            c_dest[i] = c_src[i];
            // c_dest[i+1] = c_src[i+1];
        }
        if(size>loop_size)
        {
            char* a = (char*)dest;
            char* b = (char*)src;
            for(int i=loop_size;i<size;i++)
            {
                a[i] = b[i];
            }
        }
    }
    //从后往前copy
    else
    {
        long* d = c_dest + num -1;
        const long* s = c_src + num -1;
// #pragma omp parallel for
        for(int i=num-1;i>=0;i--)
        {
            c_dest[i] = c_src[i];
            // c_dest[i+1] = c_src[i+1];
        }
        if(size>loop_size)
        {
            char* a = (char*)dest;
            char* b = (char*)src;
            for(int i=loop_size;i<size;i++)
            {
                a[i] = b[i];
            }
        }
    }

    return dest;
}

double getRate(MEM memcpy,size_t size)
{
    double time[M] = {0.0};
    double mintime = DOUBLE_MAX;
    for(int i=0;i<M;i++)
    {
        time[i] = mysecond();
        memcpy(a,b,size);
        time[i] = mysecond() - time[i];
    }
    for(int i=0;i<M;i++)
    {
        mintime = MIN(time[i],mintime);
    }
    return (double)size*2/mintime/1024/1024;
}


int main(int argc, char const *argv[])
{
    double g1,g2,g3;
    printf("byte_size          mem_Rate1          mem_Rate2          mem_Rate3          mem_Rate4\n");
    for(int i=20000;i<1500000;i+=50000)
    {
        if(i>=1024 && i<(1024*1024))
        {
            printf("%8.2lfKB ",(double)i/1024);
        }
        else if(i>=(1024*1024))
        {
            printf("%8.2lfMB ",(double)i/1024/1024);
        }
        else
        {
            printf("%8.2lfB ",(double)i);
        }
        printf("%14.4lf MB/s%14.4lf MB/s%14.4lf MB/s%14.4lf MB/s\n",getRate(my_memcpy1,i),getRate(my_memcpy2,i),getRate(my_memcpy3,i),getRate(fast_memcpy,i));
    }
    // g2 = getGFlops(my_memcpy2);
    // g1 = getGFlops();
    return 0;
}



