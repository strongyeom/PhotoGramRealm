//
//  FileManager+Ext.swift
//  PhotoGramRealm
//
//  Created by 염성필 on 2023/09/05.
//

import UIKit

extension UIViewController {
    
    
    func documentDirectoryPath() -> URL? {
        // 1. 도큐먼트 폴더 경로 찾기
        guard let documnentDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else { return nil }
        return documnentDirectory
    }
    
    // MARK: - 도큐먼트 폴더에서 이미지 삭제하는 메서드
    
    /// 도큐먼트 폴더에서 이미지를 삭제하는 메서드
    /// - Parameter fileName: 파일 명
    func removeImageFromDocument(fileName:String) {
        // 1. 도큐먼트 폴더 경로 찾기
        guard let documnentDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else { return }
        // 2. 저장할 경로 설정 ( 세부 경로, 이미지를 저장할 위치 )
        let fileURL = documnentDirectory.appendingPathComponent(fileName)
        
        // 특정 경로에 있는 확장자(이미지)를 제거해달라
        do {
            try FileManager.default.removeItem(at: fileURL)
        } catch {
            print(error)
        }
    }
    
    
    // MARK: - 도큐먼트 폴더에서 이미지를 가져오는 메서드
    func loadImageFromDocument(fileName: String) -> UIImage {
        // 1. 도큐먼트 폴더 경로 찾기
        guard let documnentDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else { return UIImage(systemName: "flame")! }
        // 2. 저장할 경로 설정 ( 세부 경로, 이미지를 저장할 위치 )
        let fileURL = documnentDirectory.appendingPathComponent(fileName)
        
        // 파일명이 유효한지 검증해주는 메서드 ex) "789"이면 시스템 이미지 띄우기
        if FileManager.default.fileExists(atPath: fileURL.path) {
            return UIImage(contentsOfFile: fileURL.path)!
        } else {
            return UIImage(systemName: "flame")!
        }
        
    }
    
    
    // MARK: - 도큐먼트 폴더에 이미지를 저장하는 메서드
    // PK를 이용해서 PK.jpg 형식으로 만들면 새로운 이미지 컬럼을 만들지 않아도 됨
    func saveImageToDocument(fileName: String, image: UIImage) {
        // 1. 도큐먼트 폴더 경로 찾기
        guard let documnentDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else { return }
        // 2. 저장할 경로 설정 ( 세부 경로, 이미지를 저장할 위치 )
        let fileURL = documnentDirectory.appendingPathComponent(fileName)
        print("저장 할 파일 경로 :\(fileURL)")
        // 3. 이미지 변환
        //compressionQuality : 압축률
        guard let data = image.jpegData(compressionQuality: 0.5) else { return }
        
        // 4. 이미지 저장
        // 일반적으로 data를 다룰때는 do - cathch 사용함
        do {
            try data.write(to: fileURL)
        } catch let error {
            
            print("file ever error",error)
        }
    }
    
    
}
