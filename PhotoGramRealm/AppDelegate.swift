//
//  AppDelegate.swift
//  PhotoGramRealm
//
//  Created by jack on 2023/09/03.
//

import UIKit
import RealmSwift

@main
class AppDelegate: UIResponder, UIApplicationDelegate {



    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        // Pin을 추가해서 마이그레이션 바뀌었다는 것을 알림
        // migration : 바뀐 버젼
        // oldSchemaVersion : 기존에 사용하던 버젼
        // 컬럼과 테이블 단순 추가 삭제의 경우엔 별도 코드가 필요없음
        
        //userdefaults
        let config = Realm.Configuration(schemaVersion: 5) { migration, oldSchemaVersion in
            
            // 순차적으로 마이그레이션 되게끔 설정해야 함
            if oldSchemaVersion < 1 {
                // 다이어리 핀 추가
            }
            
            // 컬럼(다이어리 핀)을 지운다고 해도 버젼이 내려가는게 아니고 하나라도 건드리면 무조건 올라감
            if oldSchemaVersion < 2 {
                // 다이어리 핀 삭제
            }
            
            // 0 -> 1 -> 2 순차적으로 스키마 버젼 업데이트
            
            if oldSchemaVersion < 3 {
                // 다이어리 포토 컬럼을 -> 포토 컬럼명 변경
                migration.renameProperty(onType: DiaryTable.className(), from: "diaryPhoto", to: "photo")
            }
            
            if oldSchemaVersion < 4 {
                // 다이어리 contents -> contents로 컬럼명 변경
                // rename 없으면 모든 데이터 null로 변함
                 migration.renameProperty(onType: DiaryTable.className(), from: "diaryContents", to: "contents")
            }
            
            if oldSchemaVersion < 5 {
                // diarySummery 컬럼 추가 : diaryTitle + contents 합쳐서 넣기'
                // oldObject : 기존 컬럼
                // newObject : 추가된 컬럼
                migration.enumerateObjects(ofType: DiaryTable.className()) { oldObject, newObject in
                    guard let new = newObject else { return }
                    guard let old = oldObject else { return }
                    
                    new["diarySummery"] =  "제목은 '\(old["diaryTitle"])' 이고, 내용은 '\(old["contents"])' 입니다."

                }
            }
            
            
            
            
            
            
            
        }
        
        Realm.Configuration.defaultConfiguration = config
    
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }


}

