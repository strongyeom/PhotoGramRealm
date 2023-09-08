//
//  TodoViewController.swift
//  PhotoGramRealm
//
//  Created by 염성필 on 2023/09/08.
//

import UIKit
import RealmSwift
import SnapKit

// ⭐️ Object vs EmbeddedObject 차이는?  EmbeddedObject로 구현했으면 인스턴스로 관리가 되고 테이블을 사용 할 수 없음

class TodoViewController: BaseViewController, UITableViewDelegate, UITableViewDataSource {
    
    let realm = try! Realm()


    let tableView = UITableView()
    
    var list: Results<DetailTable>!

    
    override func viewDidLoad() {

        super.viewDidLoad()
        
//        let data = TodoTable(title: "영화보기", favorite: false)
//        
//        let memo = Memo()
//        memo.content = "주말에 뭐하지?"
//        memo.date = Date()
//        
//        data.memo = memo
//        
//        try! realm.write {
//            realm.add(data)
//        }
        
        
        
        
//        let data = TodoTable(title: "장보기", favorite: true)
//
//        let detail1 = DetailTable(detail: "양파", deadLine: Date())
//        let detail2 = DetailTable(detail: "사과", deadLine: Date())
//        let detail3 = DetailTable(detail: "배", deadLine: Date())
//
//
//
//        data.detail.append(detail1)
//        data.detail.append(detail2)
//        data.detail.append(detail3)
//
//        try! realm.write {
//            realm.add(data)
//
//        }
        
        
        
        
        print(realm.configuration.fileURL)
        print("어떤 구성으로 되어있나요? \(realm.objects(TodoTable.self))")
        
        view.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = 40
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "todoCell")
        
        tableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        list = realm.objects(DetailTable.self)
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return list.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "todoCell")!
//        cell.textLabel?.text = "\(list[indexPath.row].title) : \(list[indexPath.row].detail.count)개 \(list[indexPath.row].memo?.content ?? "" )"
        let data = list[indexPath.row]
        cell.textLabel?.text =  "\(data.detail) in \(data.mainTodo.first?.title ?? "")"
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // 렘 리스트 형식으로 되어 있을때 detailTable 제거 후 TodoTable 해당 record 삭제해야함
        
        
        
//        let data = list[indexPath.row]
//
//        try! realm.write {
//            // 1. 해당 record의 detailTable 제거
//            realm.delete(data.detail)
//            // 2. TodoTable record 제거
//            realm.delete(data)
//        }
//
        // 제거가 되었기 때문에 갱신
        tableView.reloadData()
        
        
        
    }
    
    func createDetail() {
        // 1. 먼저 TodoTable 등록
        createTodo()
        // 2. 등록 후 장보기 컬럼에 DetailTable 만들어준다.
        let main = realm.objects(TodoTable.self).where {
            $0.title == "장보기"
        }.first!
        
        for i in 1...10 {
            let detailTodo = DetailTable(detail: "장보기 세부 할 일 \(i)", deadLine: Date())
            
            try! realm.write {
                // realm.add(detailTodo)
                main.detail.append(detailTodo)
            }
        }
    }
    
    func createTodo() {
        
        for i in ["장보기", "영화보기", "리캡하기", "좋아요 구현하기", "잠자기"] {
            
            let data = TodoTable(title: i, favorite: false)
            
            try! realm.write {
                realm.add(data)
            }
        }
    }
    
}
