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

        detailTableViewModel.configure()
        
        detailTableViewModel.listData.bind { _ in
            self.collectionView.reloadData()
        }
        
        
    }
    
    @objc func plusBtnClicked() {
//        list = detailTableViewModel.configure()
        detailTableViewModel.addDetailValue()
//        self.collectionView.reloadData()
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
//        return list.count
        detailTableViewModel.listData.value.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let data = detailTableViewModel.listData.value[indexPath.item]
        let cell = collectionView.dequeueConfiguredReusableCell(using: cellResisteration, for: indexPath, item: data)
        return cell
    }
    
}
