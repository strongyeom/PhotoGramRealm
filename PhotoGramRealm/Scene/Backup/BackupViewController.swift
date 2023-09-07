//
//  BackupViewController.swift
//  PhotoGramRealm
//
//  Created by 염성필 on 2023/09/07.
//

import UIKit
import SnapKit
import Zip

class BackupViewController: BaseViewController {
    
    let backupButton = {
       let view = UIButton()
        view.backgroundColor = .systemOrange
        return view
    }()
    
    let restoreButton = {
       let view = UIButton()
        view.backgroundColor = .systemGreen
        return view
    }()
    
    let backupTableView = {
       let table = UITableView()
        table.rowHeight = 60
        table.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        return table
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        backupTableView.delegate = self
        backupTableView.dataSource = self

    }
    
   
    
    override func configure() {
        super.configure()
        
        [backupTableView, backupButton, restoreButton].forEach {
            view.addSubview($0)
        }
        
        
        
        backupButton.addTarget(self, action: #selector(backupButtonClicked), for: .touchUpInside)
        restoreButton.addTarget(self, action: #selector(restoreButtonClicked), for: .touchUpInside)
    }
    
    @objc func backupButtonClicked() {
        // realm 파일을 압축 파일로 만들기
        
        // 경로를 담아줄 배열을 만들어 준다.
        // 1. 백업하고자 하는 파일들의 경로 배열 생성
        var urlPaths = [URL]()
        
        // 2. 백업 파일 경로가 있는지 여부
        guard let path = documentDirectoryPath() else {
            print("도큐먼트 위치에 오류가 있습니다.")
            return
        }
        print("파일에 경로가 있는지 파악 순서1. : \(path)")
        
        // 3. 백업하고자 하는 파일 경로  ex) ~~~ / ~~~/ ~ /Document/default.realm
        let realmFile = path.appendingPathComponent("default.realm")
        print("해당 파일에 default.realm 추가 순서2. : \(realmFile)")
        
        // 4. 3번의 경로가 유효한 경로인지 확인
        guard FileManager.default.fileExists(atPath: realmFile.path) else {
            print("백업할 파일이 없습니다")
            return
        }
        
        // 5. 압축하고자 하는 파일을 배열에 추가하기
        urlPaths.append(realmFile)
        print("백업 파일 경로 추가 순서3.: \(urlPaths)")
        // 6. 배열을 통으로 압축
        do {
            let zipFilePath = try Zip.quickZipFiles(urlPaths, fileName: "JackArchive")
            print("location 순서4.: \(zipFilePath)")
        } catch {
            print("압축 실패 ")
        }
        
        
    }
    
    @objc func restoreButtonClicked() {
        // 파일앱의 default 화면 띄우기
        // forOpeningContentTypes 해당 확장자만 활성화 나머지는 비활성화
        let documentPicker = UIDocumentPickerViewController(forOpeningContentTypes: [.archive], asCopy: true)
        print("복구 버튼을 누르면 default로 아카이브화면만 보여준다. \(documentPicker)")
        documentPicker.delegate = self
        // allowsMultipleSelection: 한개만 가져오게 설정 즉, 중복선택 불가능
        documentPicker.allowsMultipleSelection = false
        present(documentPicker, animated: true)
    }
    
    
    override func setConstraints() {
        super.setConstraints()
        
        backupTableView.snp.makeConstraints { make in
            make.bottom.horizontalEdges.equalToSuperview()
            make.top.equalTo(view.safeAreaLayoutGuide).offset(100)
        }
        
        backupButton.snp.makeConstraints { make in
            make.size.equalTo(50)
            make.top.leading.equalTo(view.safeAreaLayoutGuide)
        }
        
        restoreButton.snp.makeConstraints { make in
            make.size.equalTo(50)
            make.top.trailing.equalTo(view.safeAreaLayoutGuide)
        }
    }
}

extension BackupViewController : UIDocumentPickerDelegate {
    func documentPickerWasCancelled(_ controller: UIDocumentPickerViewController) {
        print("도큐먼트 피커의 취소 버튼이 눌렸다.")
    }
    
    func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
        // 파일앱 에 있는 zip -> 앱 도큐먼트 로 옮기고 해제까지 하는 과정
        guard let selectedFileURL = urls.first else { // 파일 앱내의 선택한 url 주소
            print("선택한 파일에 오류가 있어요")
            return
        }
        print("백업에서 저장된 파일의 경로가 있음 - selectedFileURL: \(selectedFileURL)")
        // 아카이브 파일을 -> 도큐먼트 파일로 옮겨서 압축 풀기
        guard let path = documentDirectoryPath() else {
            print("도큐먼트 위치에 오류가 있어요")
            return
        }
        print("도큐먼트 경로 피커 - path: \(path)")
        
        // 도큐먼트 폴더 내 저장할 경로 설정
        // path에 선택한 경로의 주소를 붙임 -> 압축파일을 풀어줄 경로를 지정함
        let sandboxFileURL = path.appendingPathComponent(selectedFileURL.lastPathComponent)
        print("도큐먼트 파일에 선택한 아카이브 확장자 추가하기 - sandboxFileURL: \(sandboxFileURL)")
        
        // 경로에 복구할 파일(zip)이 있는지 확인
        if FileManager.default.fileExists(atPath: sandboxFileURL.path) {
            
            // 기존 vs 새로운것 알럿 적용
            print("---기존에 똑같은 형식의 파일이 존재합니다.")
            // 경로 가져오기
            let fileURL = path.appendingPathComponent("JackArchive.zip")
            print("파일이 존재한다면 도큐먼트 경로에 JackArchive.zip을 추가한 경로를 가져온다. \(fileURL)")
            // 압축 파일을 해제시킨다.
            do {
                // overwrite : 기존에 있는 default.realm에 덮어쓰기
                // progress : 압축에 대한 진행률을 보여줌
                // fileOutputHandler : progress가 100이 되면 어떤 action을 할것인가
                try Zip.unzipFile(fileURL, destination: path, overwrite: true, password: nil, progress: { progress in
                    print("압축 해제율 : \(Int(progress * 100))")
                }, fileOutputHandler: { unzippedFile in
                    print("압축해제 완료 :\(unzippedFile)")
                    
                })
            } catch {
                print("압축 해제 실패")
            }
            
        } else {
            print("---기존에 똑같은 형식의 파일이 존재하지 않습니다.")
            // 경로에 복구할 파일이 없을때의 대응
            do {
                // at: 출발지
                // to: 도착지
                try FileManager.default.copyItem(at: selectedFileURL, to: sandboxFileURL)
                
                // 경로 가져오기
                let fileURL = path.appendingPathComponent("JackArchive.zip")
                
                // overwrite : 기존에 있는 default.realm에 덮어쓰기
                // progress : 압축에 대한 진행률을 보여줌
                // fileOutputHandler : progress가 100이 되면 어떤 action을 할것인가
                try Zip.unzipFile(fileURL, destination: path, overwrite: true, password: nil, progress: { progress in
                    print("압축 해제율 : \(progress)")
                }, fileOutputHandler: { unzippedFile in
                    print("압축해제 완료 :\(unzippedFile)")
                    
                    // 강제 종료 코드
                    exit(0)
                })
                
                
            } catch {
                print("압축 해제 실패")
            }
        }
        
    }
}

extension BackupViewController : UITableViewDelegate, UITableViewDataSource {
    
    func fetchZipList() -> [String] {
        var list: [String] = []
        
        do {
            // 도큐먼트 경로
            guard let path = documentDirectoryPath() else { return list }
            print("도큐먼트 경로 : \(path)")
            // 경로 안의 전체 컨텐츠
            let docs = try FileManager.default.contentsOfDirectory(at: path, includingPropertiesForKeys: nil)
            print("도큐먼트 경로 안의 모든 요소들 : \(docs)")
            // 모든 파일들의 목록중에서 zip인 확장자만 가져오기
            // pathExtension : 확장자 자체를 의미함
            let zip = docs.filter { $0.pathExtension == "zip" }
            print("zip으로 된 확장자만 필터하기 :\(zip)")
            // 배열안에 담기
            for i in zip {
                list.append(i.lastPathComponent)
            }
            
        } catch {
            print("ERROR")
        }
        return list
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return fetchZipList().count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell")!
        cell.textLabel?.text = fetchZipList()[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        showActivityViewController(fileName: fetchZipList()[indexPath.row])
    }
    
    func showActivityViewController(fileName: String) {
        
        
        
        guard let path = documentDirectoryPath() else {
            print("도큐먼트 위치에 오류가 있어요")
            return
        }
        print("도큐먼트 TableCellDidSelect위치 : \(path)")
        let backupFileURL = path.appendingPathComponent(fileName)
        print("클릭한 해당 TableCell의 zip의 위치 : \(backupFileURL)")
        let vc = UIActivityViewController(activityItems: [backupFileURL], applicationActivities: [])
        present(vc, animated: true)
    }
    
}
