
#import "SYSafeCategory.h"
#import "JRSwizzle.h"
#import <objc/runtime.h>

#define LOG_Error {if(error)NSLog(@"%@",error.debugDescription);error = nil;}

@interface NSArray(SYSafeCategory)
-(id)SY_safeObjectAtIndex:(int)index;
-(id)SY_safeInitWithObjects:(const id [])objects count:(NSUInteger)cnt;
@end
@interface NSMutableArray(SYSafeCategory)
-(void)SY_safeAddObject:(id)anObject;
@end

@interface NSDictionary(SYSafeCategory)
-(id)SY_safeObjectForKey:(id)aKey;
@end
@interface NSMutableDictionary(SYSafeCategory)
-(void)SY_safeSetObject:(id)anObject forKey:(id<NSCopying>)aKey;
@end

@implementation NSArray(SYSafeCategory)
-(id)SY_safeObjectAtIndex:(int)index{
    if(index>=0 && index < self.count)
    {
        return [self SY_safeObjectAtIndex:index];
    }
    return nil;
}
-(id)SY_safeInitWithObjects:(const id [])objects count:(NSUInteger)cnt
{
    for (int i=0; i<cnt; i++) {
        if(objects[i] == nil)
            return nil;
    }
    
    return [self SY_safeInitWithObjects:objects count:cnt];
}
@end

@implementation NSMutableArray(SYSafeCategory)
-(void)SY_safeAddObject:(id)anObject
{
    if(anObject != nil){
        [self SY_safeAddObject:anObject];
    }
}
@end

@implementation NSDictionary(SYSafeCategory)

- (NSUInteger)length
{
    return 0;
}

-(id)SY_safeObjectForKey:(id)aKey
{
    if(aKey == nil)
        return nil;
    id value = [self SY_safeObjectForKey:aKey];
    if (value == [NSNull null]) {
        return nil;
    }
    return value;
}
@end

@implementation NSMutableDictionary(SYSafeCategory)
- (NSUInteger)length
{
    return 0;
}

-(void)setObjects:(id)anObject forKey:(id<NSCopying>)aKey{
    if(anObject == nil || aKey == nil || [anObject isKindOfClass:[NSString class]] == NO)
        return;
    
    [self setObject:anObject forKey:aKey];
}

-(void)SY_safeSetObject:(id)anObject forKey:(id<NSCopying>)aKey{
    if(anObject == nil || aKey == nil)
        return;
    
    [self SY_safeSetObject:anObject forKey:aKey];
}
@end

@interface NSURL(SYSafeCategory)
@end;
@implementation NSURL(SYSafeCategory)
+(id)SY_safeFileURLWithPath:(NSString *)path isDirectory:(BOOL)isDir
{
    if(path == nil)
        return nil;
    
    return [self SY_safeFileURLWithPath:path isDirectory:isDir];
}
@end
@interface NSFileManager(SYSafeCategory)

@end
@implementation NSFileManager(SYSafeCategory)
-(NSDirectoryEnumerator *)SY_safeEnumeratorAtURL:(NSURL *)url includingPropertiesForKeys:(NSArray *)keys options:(NSDirectoryEnumerationOptions)mask errorHandler:(BOOL (^)(NSURL *, NSError *))handler
{
    if(url == nil)
        return nil;
    
    return [self SY_safeEnumeratorAtURL:url includingPropertiesForKeys:keys options:mask errorHandler:handler];
}
@end

@interface NSString(SYSafeCategory)
@end
@implementation NSString(SYSafeCategory)


- (NSUInteger)countByEnumeratingWithState:(NSFastEnumerationState *)state objects:(id *)stackbuf count:(NSUInteger)len
{
    return 0;
}

-(id)objectForKey:(id)aKey
{
    return nil;
}

-(void)SY_safeSetString:(NSString*)aString
{
    if(aString == nil)
    {
        return;
    }
    [self SY_safeSetString:aString];
}

- (void)SY_safeAppendString:(NSString *)aString
{
    if(aString == nil)
    {
        return;
    }
    [self SY_safeAppendString:aString];
}

@end

@interface NSMutableString(SYSafeCategory)
@end
@implementation NSMutableString(SYSafeCategory)


- (NSUInteger)countByEnumeratingWithState:(NSFastEnumerationState *)state objects:(id *)stackbuf count:(NSUInteger)len
{
    return 0;
}

-(id)objectForKey:(id)aKey
{
    return nil;
}


- (void)SY_safeAppendString:(NSString *)aString
{
    if(aString == nil)
    {
        return;
    }
    [self SY_safeAppendString:aString];
}
@end


@implementation SYSafeCategory
+(void)callSafeCategory
{
    NSError* error = nil;
    [objc_getClass("__NSPlaceholderArray") jr_swizzleMethod:@selector(initWithObjects:count:) withMethod:@selector(SY_safeInitWithObjects:count:) error:&error];
    LOG_Error
    
    //    [objc_getClass("__NSCFString") jr_swizzleMethod:@selector(countByEnumeratingWithState:objects:count:) withMethod:@selector(SY_countByEnumeratingWithState:objects:count:) error:&error];
    //    LOG_Error
    
    [objc_getClass("__NSArrayI") jr_swizzleMethod:@selector(objectAtIndex:) withMethod:@selector(SY_safeObjectAtIndex:) error:&error];
    LOG_Error
    
    [objc_getClass("__NSArrayM") jr_swizzleMethod:@selector(objectAtIndex:) withMethod:@selector(SY_safeObjectAtIndex:) error:&error];
    LOG_Error
    [objc_getClass("__NSArrayM") jr_swizzleMethod:@selector(addObject:) withMethod:@selector(SY_safeAddObject:) error:&error];
    LOG_Error
    
    [objc_getClass("__NSDictionaryI") jr_swizzleMethod:@selector(objectForKey:) withMethod:@selector(SY_safeObjectForKey:) error:&error];
    LOG_Error
    
    [objc_getClass("__NSDictionaryM") jr_swizzleMethod:@selector(objectForKey:) withMethod:@selector(SY_safeObjectForKey:) error:&error];
    LOG_Error
    [objc_getClass("__NSDictionaryM") jr_swizzleMethod:@selector(setObject:forKey:) withMethod:@selector(SY_safeSetObject:forKey:) error:&error];
    LOG_Error
    
    
    [NSURL jr_swizzleClassMethod:@selector(fileURLWithPath:isDirectory:) withClassMethod:@selector(SY_safeFileURLWithPath:isDirectory:) error:&error];
    LOG_Error
    
    [NSFileManager jr_swizzleMethod:@selector(enumeratorAtURL:includingPropertiesForKeys:options:errorHandler:) withMethod:@selector(SY_safeEnumeratorAtURL:includingPropertiesForKeys:options:errorHandler:) error:&error];
    LOG_Error
    
    [objc_getClass("__NSCFString") jr_swizzleMethod:@selector(appendString:) withMethod:@selector(SY_safeAppendString:) error:&error];
    LOG_Error
    
    [objc_getClass("__NSCFString") jr_swizzleMethod:@selector(setString:) withMethod:@selector(SY_safeSetString:) error:&error];
    LOG_Error
}

+(NSString*)getSafeString:(id)obj
{
    if([obj isKindOfClass:[NSString class]])
    {
        return obj;
    }
    else
    {
        return nil;
    }
}

@end

