//
//  HomeViewController.swift
//  PhotoGramRealm
//
//  Created by jack on 2023/09/03.
//

import UIKit
import SnapKit
import RealmSwift

class HomeViewController: BaseViewController {
    
    lazy var tableView: UITableView = {
        let view = UITableView()
        view.rowHeight = 100
        view.delegate = self
        view.dataSource = self
        view.backgroundColor = .black
        view.register(PhotoListTableViewCell.self, forCellReuseIdentifier: PhotoListTableViewCell.reuseIdentifier)
        return view
    }()
    
    var tasks: Results<DiaryTable>!
    
    let repository = DiaryTableRepository()

    override func viewDidLoad() {
        super.viewDidLoad()
        
 
        
        // 저장된 모든 데이터 불러오기
        // sorted(byKeyPath: 기준이 되는 것, ascending: false(오름차순, 내림차순))
        tasks = repository.fetch()
        repository.checkShemaVersion()
       
       // print(tasks)
    }
    
    // 저장을 했을때 뷰가 나타날때마다 데이터를 갱신 시켜주기 위해
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // 담긴 데이터를 테이블 뷰 에서 갱신
        self.tableView.reloadData()
        
    }
    
    override func configure() {
        view.addSubview(tableView)
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "plus"), style: .plain, target: self, action: #selector(plusButtonClicked))
        
        let sortButton = UIBarButtonItem(title: "정렬", style: .plain, target: self, action: #selector(sortButtonClicked))
        let filterButton = UIBarButtonItem(title: "필터", style: .plain, target: self, action: #selector(filterButtonClicked))
        let backupButton = UIBarButtonItem(title: "백업", style: .plain, target: self, action: #selector(backupButtonClicked))
        navigationItem.leftBarButtonItems = [sortButton, filterButton, backupButton]
    }
    
    override func setConstraints() {
        tableView.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }
    }
    
    @objc func plusButtonClicked() {
        navigationController?.pushViewController(AddViewController(), animated: true)
    }
    
    @objc func backupButtonClicked() {
        navigationController?.pushViewController(BackupViewController(), animated: true)
    }
    
    
    @objc func sortButtonClicked() {
        
    }
    
    @objc func filterButtonClicked() {
 
        tasks = repository.fetchFilter()
        // 데이터가 변경되었으니 테이브 뷰 갱신
        self.tableView.reloadData()
    }
}

extension HomeViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tasks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: PhotoListTableViewCell.reuseIdentifier) as? PhotoListTableViewCell else { return UITableViewCell() }
        
        let data = tasks[indexPath.row]
        
        cell.titleLabel.text = data.diaryTitle
        cell.contentLabel.text = data.contents
        cell.dateLabel.text = "\(data.diaryDate)"
        
        
        cell.diaryImageView.image = loadImageFromDocument(fileName: "sesac_ \(data._id).jpg")
        
        
        
        
        
        
        
        
        
        // DB에서 그대로 받아오는데 글로벌로 접근해서 에러 발생함 => global 밖에서 진행
        // 1. 셀 서버 통신 용량이 크다면 로드가 오래 걸릴 수 있음
        // 2. 이미지를 미리 UIImage 형식으로 반환하고, 셀에서 UIImage를 바로 보여주자
        // => 100개라면 배열안에 100개가 만들어짐 -> 재사용 매커니즘을 효율적으로 사용하지 못할 수도 있고, UIImage 배열 구성 자체가 오래 걸릴 수 있음
        // => ⭐️해결 방법 : cell 에서 prepareForReuse을 사용한다. ==> URL을 사용해서 비동기로 불러오지 말고 Document파일에 이미지 파일을 생성해주자
//        let url = URL(string: data.diaryPhoto ?? "")
//        DispatchQueue.global().async {
//        if let url = url, let data = try? Data(contentsOf: url) {
//
//                DispatchQueue.main.async {
//                    cell.diaryImageView.image = UIImage(data: data)
//                }
//            }
//        }
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let vc = DetailViewController()
        vc.data = tasks[indexPath.row]
        navigationController?.pushViewController(vc, animated: true)
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        // Realm Delete - ‼️ 시점 중요
        // cell을 클릭하면 record 찾아내기
//        let data = tasks[indexPath.row]
//        
//        // 👉 추가 코드
//        removeImageFromDocument(fileName: "sesac_ \(data._id).jpg")
//        
//        // transaction에서 수정, 추가, 삭제 해야함
//        try! realm.write {
//            // ‼️ but 도큐먼트에 사진 파일은 삭제 되지 않음 ( 삭제되었지만 삭제 적용되지 않음? )
//            realm.delete(data)
//        }
//        
//       
//        // row에서 삭제되었으니 테이블 뷰 갱신해야함
//        self.tableView.reloadData()
        
    }
    
    
    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let likeSwipe = UIContextualAction(style: .normal, title: nil) { action, view, completionHandler in
            print("좋아요 선택")
            
        }
        
        likeSwipe.backgroundColor = .orange
        likeSwipe.image = tasks[indexPath.row].diaryLike ?  UIImage(systemName: "star.fill") : UIImage(systemName: "star")
        
        let sampleSwipe = UIContextualAction(style: .normal, title: "샘플이에요") { action, view, completionHandler in
            print("샘플이에요 선택")
            
        }
        
       
        
        return UISwipeActionsConfiguration(actions: [likeSwipe, sampleSwipe])
    }
}
