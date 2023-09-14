//
//  RealmCollectionViewController.swift
//  PhotoGramRealm
//
//  Created by 염성필 on 2023/09/14.
//

import UIKit
import SnapKit
import RealmSwift

class RealmCollectionViewController: BaseViewController {
    
    var collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout())
    
    let realm = try! Realm()
    
    var list: Results<TodoTable>!
    
    // UICollectionViewListCell : iOS 14.0 이상 가능한 Cell 형식임
    // String : 타입에 대한 형태 , String 배열로 리스트가 구성됨 , ⭐️ 하나의 Cell을 차지하는 Model에 대한 타입 ex) list[indexPath.item] ⭐️
    var cellRegisteration: UICollectionView.CellRegistration<UICollectionViewListCell, TodoTable>!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(collectionView)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        list = realm.objects(TodoTable.self)
        
        
        // cellRegisteration 초기화
        cellRegisteration = UICollectionView.CellRegistration(handler: { cell, indexPath, itemIdentifier in
            // 어떤 Cell Style을 사용 할것이냐?
            var content = UIListContentConfiguration.valueCell()
            // Cell 구성
            // itemIdentifier == list[indexPath.item]  / cellFor ~ item: data로 전달해줬기 때문에 클로저로 넘어옴
            content.image = itemIdentifier.favorite ? UIImage(systemName: "star.fill") : UIImage(systemName: "star")
            content.text = itemIdentifier.title
            content.secondaryText = "\(itemIdentifier.detail.count)개의 세부 할일"
            
            cell.contentConfiguration = content
            
            
            
        })
        
        
        
        
    }
    
    static func layout() -> UICollectionViewLayout {
        
        let configuration = UICollectionLayoutListConfiguration(appearance: .grouped)
        let layout = UICollectionViewCompositionalLayout.list(using: configuration)
        return layout
    }
    
    
    
    
    
}

extension RealmCollectionViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return list.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let data = list[indexPath.item]
        let cell = collectionView.dequeueConfiguredReusableCell(using: cellRegisteration, for: indexPath, item: data)
        return cell
    }
}
