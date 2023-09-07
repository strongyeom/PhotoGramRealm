//
//  AddViewController.swift
//  PhotoGramRealm
//
//  Created by jack on 2023/09/03.
//

import UIKit
import SnapKit
import RealmSwift

class AddViewController: BaseViewController {
    
     let userImageView: PhotoImageView = {
         let view = PhotoImageView(frame: .zero)
         return view
     }()
     
     let titleTextField: WriteTextField = {
         let view = WriteTextField()
         view.tintColor = .yellow
         view.placeholder = "제목을 입력해주세요"
         return view
     }()
     
     let dateTextField: WriteTextField = {
         let view = WriteTextField()
         view.placeholder = "날짜를 입력해주세요"
         return view
     }()
     
     let contentTextView: UITextView = {
         let view = UITextView()
         view.font = .systemFont(ofSize: 14)
         view.tintColor = .yellow
         view.layer.borderWidth = Constants.Desgin.borderWidth
         view.layer.borderColor = Constants.BaseColor.border
         view.layer.cornerRadius = Constants.Desgin.cornerRadius
         return view
     }()
     
     lazy var searchImageButton: UIButton = {
         let view = UIButton()
         view.setImage(UIImage(systemName: "photo"), for: .normal)
         view.tintColor = Constants.BaseColor.text
         view.backgroundColor = Constants.BaseColor.point
         view.layer.cornerRadius = 25
         view.addTarget(self, action: #selector(searchImageButtonClicked), for: .touchUpInside)
         return view
     }()
    
    lazy var searchWebButton: UIButton = {
        let view = UIButton()
        view.setImage(UIImage(systemName: "web"), for: .normal)
        view.tintColor = Constants.BaseColor.text
        view.backgroundColor = Constants.BaseColor.point
        view.layer.cornerRadius = 25
        view.addTarget(self, action: #selector(searchWebButtonClicked), for: .touchUpInside)
        return view
    }()
      
    
    var fullurl: String?
    
    let repository = DiaryTableRepository()
    
    override func viewDidLoad() {
        super.viewDidLoad() //안하는 경우 생기는 문제
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "저장", style: .plain, target: self, action: #selector(saveButtonClicked))
    }
    
    @objc func saveButtonClicked() {

        
        // 식판 만들기 : 어떤 요소로 구성할 것인지
        let task = DiaryTable(diaryTitle: titleTextField.text!, diaryDate: Date(), diaryContents: contentTextView.text!, diaryPhoto: fullurl)
        
        repository.createItem(task)
        
        // 사진이 옵셔널로 되어 있기 때문에 조건문 사용
        if userImageView.image != nil {
            saveImageToDocument(fileName: "sesac_ \(task._id).jpg", image: userImageView.image!)
            
            
            //
            let aa = "1234567".replacingOccurrences(of: "4", with: "")
            
            
        }
        
        
        navigationController?.popViewController(animated: true)
    }
    
    @objc func searchImageButtonClicked() {
        let picker = UIImagePickerController()
        picker.sourceType = .photoLibrary
        picker.delegate = self
        picker.allowsEditing = true
        present(picker, animated: true)
    }
    
    @objc func searchWebButtonClicked() {
        let vc = SearchViewController()
        vc.didSelectItemHandler = { [weak self] value in
            self?.fullurl = value
            DispatchQueue.global().async {
                if let url = URL(string: value), let data = try? Data(contentsOf: url ) {
                    
                    DispatchQueue.main.async {
                        self?.userImageView.image = UIImage(data: data)
                    }
                }
            }
            
        }
        present(vc, animated: true)
    }
    
    override func configure() {
        super.configure()
        
        [userImageView, titleTextField, dateTextField, contentTextView, searchImageButton, searchWebButton].forEach {
            view.addSubview($0)
        }

    }
    
    override func setConstraints() {
          
        userImageView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(12)
            make.leading.equalTo(view).offset(20)
            make.trailing.equalTo(view).offset(-20)
            make.height.equalTo(view.snp.width).multipliedBy(0.55)
        }
        
        titleTextField.snp.makeConstraints { make in
            make.top.equalTo(userImageView.snp.bottom).offset(12)
            make.leading.equalTo(view).offset(20)
            make.trailing.equalTo(view).offset(-20)
            make.height.equalTo(55)
        }
        
        dateTextField.snp.makeConstraints { make in
            make.top.equalTo(titleTextField.snp.bottom).offset(12)
            make.leading.equalTo(view).offset(20)
            make.trailing.equalTo(view).offset(-20)
            make.height.equalTo(55)
        }
        
        contentTextView.snp.makeConstraints { make in
            make.top.equalTo(dateTextField.snp.bottom).offset(12)
            make.leading.equalTo(view).offset(20)
            make.trailing.equalTo(view).offset(-20)
            make.bottom.equalTo(view.safeAreaLayoutGuide).offset(-12)
        }
        
        searchImageButton.snp.makeConstraints { make in
            make.trailing.equalTo(userImageView.snp.trailing).offset(-12)
            make.bottom.equalTo(userImageView.snp.bottom).offset(-12)
            make.width.height.equalTo(50)
        }
        
        searchWebButton.snp.makeConstraints { make in
            make.trailing.equalTo(searchImageButton.snp.leading).offset(-12)
            make.bottom.equalTo(userImageView.snp.bottom).offset(-12)
            make.width.height.equalTo(50)
        }
    }
}

extension AddViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[.editedImage] as? UIImage {
            userImageView.image = image
        }
        dismiss(animated: true)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true)
    }
    
}
