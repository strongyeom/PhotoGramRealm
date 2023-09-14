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
    
   
    
    func addDetailValue() {
        let aa = DetailTable(detail: "123", deadLine: Date())

        
        try! realm.write {
            realm.add(aa)
        }
    }
    
    func configure() -> Results<DetailTable> {
        realm.objects(DetailTable.self)
    }
}
