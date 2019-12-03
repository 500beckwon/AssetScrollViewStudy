//
//  InfinityScrollView.swift
//  ScrollViewStudy
//
//  Created by ByungHoon Ann on 2019/12/03.
//  Copyright © 2019 ByungHoon Ann. All rights reserved.
//

//MARK: 무한스크롤 학습, 출처: https://www.hohyeonmoon.com/swift-infinite-scrolling/

import Foundation
import UIKit

class InfinityScrollView : UIViewController,UITableViewDataSource,UITableViewDelegate {
    var fetchingMore = false
    var items = [0,1,2,3,4,5,6,7,8,9,10]
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let loadingNib = UINib(nibName: "LoadingCell", bundle: nil)
        tableView.register(loadingNib, forCellReuseIdentifier: "LoadingCell")
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 1
        case 1:
            return items.count
        case 2:
            return 1
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: "tablecell") as! TableCell
            return cell
                  
        case 1:
              let cell = tableView.dequeueReusableCell(withIdentifier: "InfinityCell") as! InfinityCell
              cell.userName.setTitle("User \(items[indexPath.row])", for: .normal)
              return cell
        default:
            let cell = tableView.dequeueReusableCell(withIdentifier: "LoadingCell") as! LoadingCell
            cell.spinner.startAnimating()
            return cell
        }
    }
    
   
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        
        if offsetY > contentHeight - scrollView.frame.height {
            if !fetchingMore {
                beginBatchFetch()
            }
        }
    }
    
    func beginBatchFetch(){
        fetchingMore = true
        tableView.reloadSections(IndexSet(integer: 2), with: .none)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.25) {
            let newItems = (self.items.count...self.items.count + 10).map { index in
                index }
            self.items.append(contentsOf: newItems)
            self.fetchingMore = false
            self.tableView.reloadData()
        }
    }
}


class TableCell: UITableViewCell {
    
}
class InfinityCell: UITableViewCell {
    
    @IBOutlet weak var userName: UIButton!
}
