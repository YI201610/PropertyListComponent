//
//  PropertyListComponentTests.m
//  PropertyListComponentTests
//
//  Copyright © 2019 YI201610. All rights reserved.
//

#import <XCTest/XCTest.h>
#import <PropertyListComponent/PropertyListComponent.h>

@interface PropertyListComponentTests : XCTestCase {
    
    PropertyListComponent *_component;
    
    NSString *_plistPath;
}

@end

@implementation PropertyListComponentTests

- (void)setUp {
    _component = [PropertyListComponent new];
    
    _plistPath = [[NSBundle bundleForClass:[PropertyListComponent class]] pathForResource:@"sample" ofType:@"plist"];
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
}

#pragma mark - Common

- (void) validationWithPlistPath:(NSString *)plistPath {
    NSDictionary *plistData = [NSDictionary dictionaryWithContentsOfFile:plistPath];
    XCTAssertNotNil(plistData, @"plistファイルの内容を取得できない");
    XCTAssertTrue(plistData.allKeys.count > 0, @"num of write data keys: %ld, plistに情報を書き込めていない", plistData.allKeys.count);
    
    NSLog(@"plistのKeyの数: %ld", plistData.allKeys.count);
}

#pragma mark - Tests
/**
 plistを読み取ることができる
 */
- (void)testComponentCanReadPlist {
    
    id plist = [PropertyListComponent plistWithPath:_plistPath];
    XCTAssertNotNil(plist, @"plistが取得できない");
}

- (void)testComponentCannotReadPlist {
    
    id plist = [PropertyListComponent plistWithPath:@"xxxx-xxx--not-found--"];
    XCTAssertNil(plist, @"plistが取得できないはずなのに、取得できている");
}

- (void)testComponentCannotReadPlist2 {
    
    id plist = [PropertyListComponent plistWithPath:nil];
    XCTAssertNil(plist, @"plistがnilなのに、取得できている");
}

- (NSString *)currentDatetimeString {
    NSDate *currentDate = [NSDate date];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy_MM_dd_HH:mm:ss.SSS"];
    NSString *dateString = [dateFormatter stringFromDate:currentDate];
    return dateString;
}

/**
 plistを、/Library/Application Support/ 配下に新規に保存することができる
 */
- (void)testComponentCanWritePlistToApplicationSupportDirectory {
    
    NSString *dynamicKey = [NSString stringWithFormat:@"key_%@", [self currentDatetimeString]];
    NSDictionary *data = @{dynamicKey : @"some_value"};
    NSString *plistName = @"applicationSupport.plist";
    NSString *subPath = @"app1";
    NSString *savePath = [PropertyListComponent pathWithDirectoryType:PropertyListComponentDirectoryTypeLibraryApplicationSupport
                                                              subPath:subPath
                                                            plistName:plistName];
    
    BOOL result = [PropertyListComponent writePlistWithPath:savePath data:data];
    XCTAssertTrue(result, @"%@ 書き込みエラー", plistName);
    
    [self validationWithPlistPath:savePath];
}

/**
 plistを、/Library/Caches/ 配下に新規に保存することができる
 */
- (void)testComponentCanWritePlistToCachesDirectory {
    
    NSString *dynamicKey = [NSString stringWithFormat:@"key_%@", [self currentDatetimeString]];
    NSDictionary *data = @{dynamicKey : @"some_value"};
    NSString *plistName = @"caches.plist";
    NSString *subPath = @"sub-cache";
    NSString *savePath = [PropertyListComponent pathWithDirectoryType:PropertyListComponentDirectoryTypeLibraryCaches
                                                              subPath:subPath
                                                            plistName:plistName];
    
    BOOL result = [PropertyListComponent writePlistWithPath:savePath data:data];
    XCTAssertTrue(result, @"%@ 書き込みエラー", plistName);
    
    [self validationWithPlistPath:savePath];
}

/**
 plistを、Documents 配下に新規に保存することができる
 */
- (void)testComponentCanWritePlistToDocumentsDirectory {
    
    NSString *dynamicKey = [NSString stringWithFormat:@"key_%@", [self currentDatetimeString]];
    NSDictionary *data = @{dynamicKey : @"some_value"};
    NSString *plistName = @"documents.plist";
    NSString *subPath = @"sub-documents";
    NSString *savePath = [PropertyListComponent pathWithDirectoryType:PropertyListComponentDirectoryTypeDocuments
                                                              subPath:subPath
                                                            plistName:plistName];
    BOOL result = [PropertyListComponent writePlistWithPath:savePath data:data];
    XCTAssertTrue(result, @"%@ 書き込みエラー", plistName);
    
    [self validationWithPlistPath:savePath];
}

/**
 plistを、Tmp 配下に新規に保存することができる
 */
- (void)testComponentCanWritePlistToTmpDirectory {
    
    NSString *dynamicKey = [NSString stringWithFormat:@"key_%@", [self currentDatetimeString]];
    NSDictionary *data = @{dynamicKey : @"some_value"};
    NSString *plistName = @"tmp.plist";
    NSString *subPath = @"sub-tmp";
    NSString *savePath = [PropertyListComponent pathWithDirectoryType:PropertyListComponentDirectoryTypeTmp
                                                              subPath:subPath
                                                            plistName:plistName];
    BOOL result = [PropertyListComponent writePlistWithPath:savePath data:data];
    XCTAssertTrue(result, @"%@ 書き込みエラー", plistName);
    
    [self validationWithPlistPath:savePath];
}


- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
}
@end
