//
//  ViewController.swift
//  ScrollViewStudy
//
//  Created by ByungHoon Ann on 2019/12/02.
//  Copyright © 2019 ByungHoon Ann. All rights reserved.
//

//MARK:Asset과 테이블뷰, 스크롤뷰와의 연계 학습, 출처: https://etst.tistory.com/111

import UIKit
import Photos
class ViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    
    var tableView : UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.backgroundColor = .white
        return tableView
    }()
    
    let cell: String = "CustomTableCell"
    var fecthResult: PHFetchResult<PHAsset>!
    let imageManager: PHCachingImageManager = PHCachingImageManager()
   
    override func viewDidLoad() {
        super.viewDidLoad()
        customTableView()
        
        tableView.register(UINib(nibName: "CustomTableCell", bundle: nil),
                           forCellReuseIdentifier: "CustomTableCell")
        
        let photoAuthorizationStatus = PHPhotoLibrary.authorizationStatus()
        
        switch photoAuthorizationStatus {
        case .authorized:
            print("접근 허가됨")
            self.requesCollecton()
            self.tableView.reloadData()
        case .denied:
            print("접근 불허됨")
        case .notDetermined:
            print("응답 받아야 함")
            PHPhotoLibrary.requestAuthorization { (status) in
                switch status {
                case .authorized:
                    print("사용자가 접근을 허가함")
                    self.requesCollecton()
                    OperationQueue.main.addOperation {
                        self.tableView.reloadData()
                    }
                    print("hello")
                case .denied:
                    print("사용자가 접근을 불허")
                default:
                    break
                }
            }
        case .restricted:
            print("접근 제한됨")
        @unknown default:
            print("접근 제한됨")
            return
        }
    }
    let sampleIndexText :[String] = ["back1.jpeg","back2.jpg","back3.jpg","back4.jpg"]
    
    func customTableView() {
        view.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        tableView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
    }
    
    func requesCollecton() {
        let cameraRoll : PHFetchResult<PHAssetCollection> = PHAssetCollection.fetchAssetCollections(with: .smartAlbum, subtype: .smartAlbumUserLibrary, options: nil)
        
        guard let cameraRollCollection = cameraRoll.firstObject else { return }
        let fecthOptions = PHFetchOptions()
        fecthOptions.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]
        self.fecthResult = PHAsset.fetchAssets(in: cameraRollCollection, options: fecthOptions)
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return fecthResult?.count ?? 0
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CustomTableCell") as! CustomTableCell
        
        let asset = fecthResult.object(at: indexPath.row)
        
        imageManager.requestImage(for: asset,
                                  targetSize: CGSize(width: 30, height: 30),
                                  contentMode: .aspectFill,
                                  options: nil) { image, _ in
                                    cell.imageView?.image = image
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = storyboard?.instantiateViewController(withIdentifier: "ImageZoomViewController") as! ImageZoomViewController
        
        vc.asset = fecthResult[indexPath.row]
        
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let asset: PHAsset = fecthResult[indexPath.row]
            
            PHPhotoLibrary.shared().performChanges({
                PHAssetChangeRequest.deleteAssets([asset] as NSArray)
            }, completionHandler: nil)
        }
    }
    
    func photoLibraryDidChange(_ changeInstance: PHChange) {
        guard let changes = changeInstance.changeDetails(for: fecthResult) else { return }
        
        fecthResult = changes.fetchResultAfterChanges
        
        OperationQueue.main.addOperation {
            self.tableView.reloadSections(IndexSet(0...0), with: .automatic)
        }
    }
}


