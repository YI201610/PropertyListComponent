//
//  PropertyListComponent
//
//  Copyright © 2019 YI201610. All rights reserved.
//


#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, PropertyListComponentDirectoryType) {
    
    /** Library/ApplicationSupportディレクトリ。ユーザーのドキュメントに関連付けされていないアプリ内部の情報を記録する。 */
    PropertyListComponentDirectoryTypeLibraryApplicationSupport,
    
    /** Library/Cachesディレクトリ。アプリが簡単に作成し直せるファイルを配置する場所。iOSにより削除される可能性がある。 */
    PropertyListComponentDirectoryTypeLibraryCaches,
    
    /** Documentsディレクトリ。ユーザーデータを保存する */
    PropertyListComponentDirectoryTypeDocuments,
    
    /** tmpディレクトリ。一時的なファイルを保存する。iOSから頻繁に削除される可能性がある。 */
    PropertyListComponentDirectoryTypeTmp,
};

/**
 plistを操作するテクニカルクラス
 */
@interface PropertyListComponent : NSObject

/**
 plistを保存するPathを返す
 
 @param directoryType ディレクトリの種類
 @param subPath サブディレクトリ
 @param plistName 保存するplistのファイル名
 @return iOS内の保存パス
 */
+ (NSString *) pathWithDirectoryType:(PropertyListComponentDirectoryType)directoryType
                             subPath:(NSString *)subPath
                           plistName:(NSString *)plistName;

/**
 指定したPathのplistをリスト型で返す
 
 @param plistPathString plistのパス
 @return plistが入ったリスト
 */
+ (NSArray*) plistWithPath:(NSString*)plistPathString;

/**
 指定されたDictionaryデータをPlistに保存する
 
 @param savePath 保存パス
 @param plistData 書き込みデータ
 @return YES: 書き込み成功, NO: 書き込み失敗
 */
+ (BOOL) writePlistWithPath:(NSString*)savePath data:(NSDictionary *)plistData;

@end

