# PropertyListComponent

デバッグ時などに使うことを想定した、plistのI/O担当クラスです。

## インストール方法

1. ビルドします。
2. 成果物（.framework）をFinderで特定します。
<img src="https://github.com/YI201610/PropertyListComponent/blob/develop/images/build.png" width="600">

3. frameworkを入れたいプロジェクトに、EmbeddedFrameworkとして取り込みます。
<img src="https://github.com/YI201610/PropertyListComponent/blob/develop/images/install.png" width="600">

## 使い方

- インポート

(e.g.) obj-c

```
#import <PropertyListComponent/PropertyListComponent.h>
```

- plistの読み込み

(e.g.) swift

```
let testBundle = Bundle(for: type(of: self))
let path = testBundle.path(forResource: "topMenu", ofType: "plist")
        
guard let plistPath = path else {
	return String()
}

let plistBuffer = PropertyListComponent.plist(withPath: plistPath)
print(plistBuffer!)
```

- Library/Application Support ディレクトリ配下にplistを書き込み
  - ディレクトリタイプは、いくつか選べます。
	- PropertyListComponentDirectoryTypeLibraryApplicationSupport ... Library/Application Support
    - PropertyListComponentDirectoryTypeLibraryCaches ... Library/Caches
	- PropertyListComponentDirectoryTypeDocuments ... Documents
	- PropertyListComponentDirectoryTypeTmp ... tmp

(e.g.) obj-c

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

