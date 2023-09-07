//
//  DetailViewController.swift
//  PhotoGramRealm
//
//  Created by 염성필 on 2023/09/05.
//

import UIKit
import SnapKit
import RealmSwift

class DetailViewController: BaseViewController {
    
   
    
    let titleTextField: WriteTextField = {
        let view = WriteTextField()
        view.tintColor = .yellow
        view.textColor = .white
        view.placeholder = "제목을 입력해주세요"
        return view
    }()
    
    let contentTextField: WriteTextField = {
        let view = WriteTextField()
        view.textColor = .white
        view.placeholder = "날짜를 입력해주세요"
        return view
    }()
    
    let realm = try! Realm()
    
    var data: DiaryTable?
    
    let repository = DiaryTableRepository()

    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func configure() {
        super.configure()
        view.addSubview(titleTextField)
        view.addSubview(contentTextField)
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "수정", style: .plain, target: self, action: #selector(editBtnClicked))
    }
    
    @objc func editBtnClicked() {
        print("수정 버튼 클릭")
        
        
        guard let data else { return }
        
        repository.updateItem(id: data._id, title: titleTextField.text!, contensts: contentTextField.text!)
        
        navigationController?.popViewController(animated: true)
    }
    
    override func setConstraints() {
        
        titleTextField.snp.makeConstraints { make in
            make.width.equalTo(300)
            make.height.equalTo(50)
            make.center.equalToSuperview()
        }
        
        contentTextField.snp.makeConstraints { make in
            make.width.equalTo(300)
            make.height.equalTo(50)
            make.centerX.equalTo(view)
            make.centerY.equalTo(view).offset(60)
        }
    }
}
