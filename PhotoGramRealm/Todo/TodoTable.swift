//
//  TodoTable.swift
//  PhotoGramRealm
//
//  Created by 염성필 on 2023/09/08.
//

import Foundation
import RealmSwift


// MARK: - Todo 테이블 구성
class TodoTable: Object {
    
    @Persisted(primaryKey: true) var _id: ObjectId
    @Persisted var title: String
    @Persisted var favorite: Bool
    
    // To many Relationship // 옵셔널 타입으로 지정해주지 않아도 default로 [] 설정 됨 
    @Persisted var detail: List<DetailTable>
    // To One Relationship // 있을 수도 있고 없을 수도 있기때문에 옵셔널 처리해야함 , 별도의 테이블이 생기지는 않음
    @Persisted var memo: Memo?
    
    convenience init(title: String, favorite: Bool) {
        self.init()
        self.title = title
        self.favorite = favorite
    }
}


// MARK: - 디테일 테이블 구성
class DetailTable: Object {
    
    @Persisted(primaryKey: true) var _id: ObjectId
    @Persisted var detail: String
    @Persisted var deadLine: Date
    
    // TodoTable과 역관계 Inverse Relationship Property (LinkingObjects) - 자식이 어느 부모에 속해있는지 알려달라
    // "detail" 는 TodoTable에서의 detail
    @Persisted(originProperty: "detail") var mainTodo: LinkingObjects<TodoTable>
   
    convenience init(detail: String, deadLine: Date) {
        self.init()
        
        self.detail = detail
        self.deadLine = deadLine
    }
}

// 1:1 관계
class Memo: EmbeddedObject {
    @Persisted var content: String
    @Persisted var date: Date
}
