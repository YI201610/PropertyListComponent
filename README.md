# PropertyListComponent

デバッグ時などに使うことを想定した、plistのI/O担当クラスです。

## インストール方法

1. ビルドします。
2. 成果物（.framework）をFinderで特定します。
<img src="https://github.com/YI201610/PropertyListComponent/blob/develop/images/build.png" width=640>

3. frameworkを入れたいプロジェクトに、EmbeddedFrameworkとして取り込みます。
<img src="https://github.com/YI201610/PropertyListComponent/blob/develop/images/install.png" width=640>

## 使い方

- インポート

```
#import <PropertyListComponent/PropertyListComponent.h>
```

- plistの読み込み

```
let testBundle = Bundle(for: type(of: self))
let plistPath = testBundle.path(forResource: "topMenuTest", ofType: "plist")

NSArray* plist = [PropertyListComponent plistWithPath:plistNameString];
```

- Library/Application Support ディレクトリ配下にplistを書き込み
  - ディレクトリタイプは、いくつか選べます。
    - PropertyListComponentDirectoryTypeLibraryCaches ... Library/Caches
	- PropertyListComponentDirectoryTypeDocuments ... Documents
	- PropertyListComponentDirectoryTypeTmp ... tmp

```
NSString *dynamicKey = [NSString stringWithFormat:@"key_%@", [self currentDatetimeString]];
NSDictionary *data = @{dynamicKey : @"some_value"};
NSString *plistName = @"applicationSupport.plist";
NSString *subPath = @"app1";
NSString *savePath = [PropertyListComponent pathWithDirectoryType:PropertyListComponentDirectoryTypeLibraryApplicationSupport
                                                              subPath:subPath
                                                            plistName:plistName];
BOOL result = [PropertyListComponent writePlistWithPath:savePath data:data];
```

