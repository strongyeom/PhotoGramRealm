//
//  DiaryViewModel.swift
//  PhotoGramRealm
//
//  Created by 염성필 on 2023/09/15.
//

import Foundation
import RealmSwift

class DetailTableViewModel {
    
    let realm = try! Realm()
    
    var detailRealm = Observable(DetailTable(detail: "", deadLine: Date()))
    
    lazy var detailReamls = Observable(realm.objects(DetailTable.self))
    
    lazy var listData = Observable<[DetailTable]>([])
//        .init(
//        realm.objects(DetailTable.self).map { $0 }
//    )

    
    func addDetailValue() {
        let aa = DetailTable(detail: "123", deadLine: Date())
        try! realm.write {
            realm.add(aa)
            listData.value.append(aa)
        }
    }
    
    func configure() {
        listData.value = realm.objects(DetailTable.self).map { $0 }
    }
    
    
}
