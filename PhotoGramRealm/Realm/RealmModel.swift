//
//  RealModel.swift
//  PhotoGramRealm
//
//  Created by 염성필 on 2023/09/04.
//

import Foundation
import RealmSwift
// 필수로 해야하는 것만 등록을 하고 나머지는 옵션으로 등록 ( Table에 nil이 들어올 수 있음 )
class DiaryTable: Object {
    
    // realm이 자동적으로 id 생성해줌
    @Persisted(primaryKey: true) var _id: ObjectId
    @Persisted var diaryTitle: String // 일기 제목 ( 필수 )
    @Persisted var diaryDate: Date // 일기 등록 날짜 ( 필수 )
    @Persisted var contents: String? // 일기 내용 ( 옵션 )
    @Persisted var Photo: String? // 일기 ImageUrl ( 옵션 )
    @Persisted var diaryLike: Bool // 즐겨찾기 기능 ( 필수 )
    // @Persisted var diaryPin: Bool
    @Persisted var diarySummery: String

    convenience init(diaryTitle: String, diaryDate: Date, diaryContents: String?, diaryPhoto: String?) {
        self.init()
        
        self.diaryTitle = diaryTitle
        self.diaryDate = diaryDate
        self.contents = diaryContents
        self.Photo = Photo
        self.diaryLike = true
        self.diarySummery =  "제목은 '\(diaryTitle)' 이고, 내용은 '\(diaryContents ?? "")' 입니다."
    }
}

