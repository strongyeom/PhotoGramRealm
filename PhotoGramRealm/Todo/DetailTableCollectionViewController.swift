//
//  DiaryCollectionViewController.swift
//  PhotoGramRealm
//
//  Created by 염성필 on 2023/09/15.
//

import UIKit
import SnapKit
import RealmSwift

class DiaryCollectionViewController : BaseViewController {
    
    var collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout())
    
    
    let realm = try! Realm()
    
    var list: Results<DetailTable>!
    
    let detailTableViewModel = DetailTableViewModel()
    
    var cellResisteration: UICollectionView.CellRegistration<UICollectionViewCell, DetailTable>!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(collectionView)
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "plus"), style: .plain, target: self, action: #selector(plusBtnClicked))
        
        
        
        
        collectionView.delegate = self
        collectionView.dataSource = self
        print(realm.configuration.fileURL)
        // list = realm.objects(DetailTable.self)
        
        collectionView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        cellResisteration = UICollectionView.CellRegistration(handler: { cell, indexPath, itemIdentifier in
            var content = UIListContentConfiguration.cell()
            content.text = itemIdentifier.detail
            content.secondaryText = "\(itemIdentifier._id)"
            cell.contentConfiguration = content
        })
        
        
          list = detailTableViewModel.configure()
    
        detailTableViewModel.detailRealm.bind { aaa in
            // reaml에 데이터를 추가할때마다 지켜보고 있다가 DetailTable이 didSet이 되면
            // reload 시켜주고 싶은데... 어떻게 구현해야 하지?
            DispatchQueue.main.async {
                self.collectionView.reloadData()
            }
           
        }
        
        
    }
    
    @objc func plusBtnClicked() {
        detailTableViewModel.addDetailValue()
       // self.collectionView.reloadData()
    }
    
    
    
    
    static func layout() -> UICollectionViewLayout {
        var configure = UICollectionLayoutListConfiguration(appearance: .insetGrouped)
        configure.backgroundColor = .yellow
        let layout = UICollectionViewCompositionalLayout.list(using: configure)
        return layout
    }
    
    
    
}

extension DiaryCollectionViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return list.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let data = list[indexPath.item]
        let cell = collectionView.dequeueConfiguredReusableCell(using: cellResisteration, for: indexPath, item: data)
        return cell
    }
    
}
