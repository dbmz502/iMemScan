//
//  Root.m
//  Root
//
//  Created by yiming on 2021/8/14.
//

#import "Root.h"
#import <UIKit/UIKit.h>
#import <dlfcn.h>

@implementation Root

void patch_setuid(void) {
    void* handle = dlopen("/usr/lib/libjailbreak.dylib", RTLD_LAZY);
    if (!handle)
        return;
    
    // Reset errors
    dlerror();
    typedef void (*fix_setuid_prt_t)(pid_t pid);
    fix_setuid_prt_t ptr = (fix_setuid_prt_t)dlsym(handle, "jb_oneshot_fix_setuid_now");
    
    const char *dlsym_error = dlerror();
    if (dlsym_error)
        return;
    
    ptr(getpid());
}
 
/* Set platform binary flag */
#define FLAG_PLATFORMIZE (1 << 1)
 
void platformize_me(void) {
    void* handle = dlopen("/usr/lib/libjailbreak.dylib", RTLD_LAZY);
    if (!handle) return;
    
    // Reset errors
    dlerror();
    typedef void (*fix_entitle_prt_t)(pid_t pid, uint32_t what);
    fix_entitle_prt_t ptr = (fix_entitle_prt_t)dlsym(handle, "jb_oneshot_entitle_now");
    
    const char *dlsym_error = dlerror();
    if (dlsym_error) return;
    
    ptr(getpid(), FLAG_PLATFORMIZE);
}
 
void iOSRoot(void){
    patch_setuid();
    platformize_me();
    setuid(0);
    setgid(0);
}

+ (void)load
{
    iOSRoot();
}

@end
