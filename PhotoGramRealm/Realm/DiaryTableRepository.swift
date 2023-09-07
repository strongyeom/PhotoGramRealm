//
//  DiaryTableRepository.swift
//  PhotoGramRealm
//
//  Created by 염성필 on 2023/09/06.
//

import Foundation
import RealmSwift


// 다른 Table이 있을경우 프로토콜을 사용해서 정리 할 수 있음
protocol DiaryTableRepositoryType : AnyObject {
    func fetch() -> Results<DiaryTable>
    func fetchFilter() -> Results<DiaryTable>
    func createItem(_ item: DiaryTable)
}

class DiaryTableRepository: DiaryTableRepositoryType {
    
    // realm 파일에 접근할 수 있도록, 위치를 찾는 코드 ex) 엑셀시트에 추가하려면 위치를 알아야하기 때문에
    
    // realm에서 데이터 가져오기 Read
    // 경로 찾기
    private let realm = try! Realm()
    
    
    private func a() { } // 다른 파일에서는 쓸 수 없고, 클래스 안에서만 쓸 수 있음 => 오버라이딩 불가능 => final과 같은 역할을 한다.
    
    
    // MARK: - 전체 데이터를 가져온다.
    func fetch() -> Results<DiaryTable> {
        let data = realm.objects(DiaryTable.self).sorted(byKeyPath: "diaryTitle", ascending: true)
        return data
    }
    
    
    // MARK: - DB에서 필터하기
    func fetchFilter() -> Results<DiaryTable> {
        let result = realm.objects(DiaryTable.self).where {
            // caseInsensitive : 대소문자 구별을 없애줌
            // $0.diaryTitle.contains("제목", options: .caseInsensitive)
            
            // 2. Bool
            // $0.diaryLike == true
            
            // 3. 사진이 있는 데이터만 불러오기 ( diaryPhoho의 nil 여부 판단 )
            $0.Photo != nil
         }
        
        return result
    }
    
    
    // MARK: - 해당 스키마 버젼 출력하기
    func checkShemaVersion() {
        
        do {
            let version = try schemaVersionAtURL(realm.configuration.fileURL!)
            print("Schema Version : \(version)")
        } catch {
            print(error)
        }
        
    }
    
    
    // MARK: - DB에 저장하기
    func createItem(_ item: DiaryTable) {

        do {
            // 한 울타리에서 진행해야 오류 발생하지 않음 ex) ATM
            try realm.write {
                // 엑셀 시트에 추가하기
                realm.add(item)
            }
        }catch {
            
        }
    }
    
    // MARK: - DB 수정하기
    func updateItem(id: ObjectId, title: String, contensts: String) {
        
        // Realm Update - 해당 record를 전체 업데이트 하는 것
//        let item = DiaryTable(value: ["_id":data._id, "diaryTitle": titleTextField.text!, "diaryContents": contentTextField.text!])
//
        do {
            // 트랜잭션에게 값 전달
            try realm.write {
                // modified : 수정하면서 업데이트
                // Realm 설정하지 않은것은 초기값으로 셋팅 후 업데이트
                // realm.add(item, update: .modified)
                
                // Realm Update 해당 record중에 요소만 업데이트
                realm.create(DiaryTable.self, value: ["_id":id, "diaryTitle": title, "diaryContents": contensts], update: .modified)
            }
        } catch {
            print(error)
        }
    }
    
    
}
