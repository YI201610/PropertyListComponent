//
//  PropertyListComponent
//
//  Copyright © 2019 YI201610. All rights reserved.
//

#import "PropertyListComponent.h"

@implementation PropertyListComponent

#pragma mark - Public

+ (NSArray*) plistWithPath:(NSString*)plistPathString
{
    if(plistPathString.length == 0) {
        return nil;
    }
    
    NSArray* plistArray = [NSArray arrayWithContentsOfFile:plistPathString];
    if(plistArray.count > 0) {
        return plistArray;
    }

    return nil;
}

+ (NSString *) pathWithDirectoryType:(PropertyListComponentDirectoryType)directoryType
                             subPath:(NSString *)subPath
                           plistName:(NSString *)plistName
{
    NSString *writePath = nil;
    
    switch (directoryType) {
        case PropertyListComponentDirectoryTypeLibraryApplicationSupport:
            writePath = [PropertyListComponent applicationSupportDirectoryPathString];
            break;
            
        case PropertyListComponentDirectoryTypeLibraryCaches:
            writePath = [PropertyListComponent cachesDirectoryPathString];
            break;
            
        case PropertyListComponentDirectoryTypeDocuments:
            writePath = [PropertyListComponent documentsDirectoryPathString];
            break;
            
        case PropertyListComponentDirectoryTypeTmp:
            writePath = [PropertyListComponent tmpDirectoryPathString];
            break;
    }
    
    if (subPath.length > 0) {
        writePath = [writePath stringByAppendingPathComponent:subPath];
    }
    
    if (plistName.length > 0) {
        writePath = [writePath stringByAppendingPathComponent:plistName];
    }

    return writePath;
}


+ (BOOL) writePlistWithPath:(NSString*)writePath data:(NSDictionary *)plistData {

    [PropertyListComponent createDirectoryIfNeededWithWritePath:writePath];
    
    /* もし既存ファイルが存在すれば、パラメーターとマージする */
    __block NSMutableDictionary *writeData = [[NSDictionary dictionaryWithContentsOfFile:writePath] mutableCopy];
    if (writeData) {
        // 同期でマージ
        [plistData enumerateKeysAndObjectsUsingBlock:^(NSString *key, NSString *value, BOOL *stoped) {
            writeData[key] = value;
        }];
    }else{
        writeData = [plistData mutableCopy];
    }
    
    NSError *error = nil;
    NSURL *writePathURL = [NSURL fileURLWithPath:writePath];
    BOOL result = [writeData writeToURL:writePathURL error:&error];
    if (error) {
        NSAssert(error, @"Error: cannot write plist. %@, %@", writePathURL.description, error.description);
    }

    
    return result;
}


#pragma mark - Private

/**
 Application Support DirecotryのPathを返す
 
 @return Pathの文字列
 */
+ (NSString*) applicationSupportDirectoryPathString {
    
    NSString *applicationSupportDirectoryListPath = [NSSearchPathForDirectoriesInDomains(NSApplicationSupportDirectory, NSUserDomainMask, YES) firstObject];
    
    return applicationSupportDirectoryListPath;
}

/**
 Caches DirecotryのPathを返す
 
 @return Pathの文字列
 */
+ (NSString*) cachesDirectoryPathString {
    NSString *path = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) firstObject];
    return path;
}

/**
 Documents DirecotryのPathを返す
 
 @return Pathの文字列
 */
+ (NSString*) documentsDirectoryPathString {
    NSString *path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
    return path;
}

/**
 tmp DirecotryのPathを返す
 
 @return Pathの文字列
 */
+ (NSString*) tmpDirectoryPathString {
    NSString *path = NSTemporaryDirectory();
    return path;
}


/**
 もし指定されたPathのディレクトリが存在しなければ、作成する

 @param writePath 保存パス
 */
+ (void) createDirectoryIfNeededWithWritePath:(NSString *)writePath {
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSError *error = nil;
    BOOL isDirectory = NO;
    NSString *dirString = [writePath stringByDeletingLastPathComponent];
    BOOL isExistApplicationSupportDirectory = [fileManager fileExistsAtPath:dirString isDirectory:&isDirectory];
    
    if (!isExistApplicationSupportDirectory && !isDirectory) {
        BOOL created = [fileManager createDirectoryAtPath:dirString withIntermediateDirectories:YES attributes:nil error:&error];
        if (!created) {
            NSAssert(created, @"Error: cannot create Application Support directory. ");
        }
    }
}

@end
